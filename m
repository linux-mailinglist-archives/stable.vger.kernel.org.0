Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59C3318E6A
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBKP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhBKPWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A300A64F3A;
        Thu, 11 Feb 2021 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056046;
        bh=G25eVsCG0FfJD+6TQYx5u0/1KEGw50qSzxQT6J01+js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMquAHeHjtAlOVJi1qj8ACMM5hw2A5YWhU73UNOHrGs79S+D3vi+/mgc+kP406dV3
         wSOAD377ixPY91bSgBrAd1vV06OOutdHpXRxt6H7clEKAmIXGeqAVXSygW83c7y3vs
         bI4XAQxidMapUWKBAkBj38DMMecydPuC1NQKsiSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/24] regulator: core: avoid regulator_resolve_supply() race condition
Date:   Thu, 11 Feb 2021 16:02:41 +0100
Message-Id: <20210211150148.069380965@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Collins <collinsd@codeaurora.org>

[ Upstream commit eaa7995c529b54d68d97a30f6344cc6ca2f214a7 ]

The final step in regulator_register() is to call
regulator_resolve_supply() for each registered regulator
(including the one in the process of being registered).  The
regulator_resolve_supply() function first checks if rdev->supply
is NULL, then it performs various steps to try to find the supply.
If successful, rdev->supply is set inside of set_supply().

This procedure can encounter a race condition if two concurrent
tasks call regulator_register() near to each other on separate CPUs
and one of the regulators has rdev->supply_name specified.  There
is currently nothing guaranteeing atomicity between the rdev->supply
check and set steps.  Thus, both tasks can observe rdev->supply==NULL
in their regulator_resolve_supply() calls.  This then results in
both creating a struct regulator for the supply.  One ends up
actually stored in rdev->supply and the other is lost (though still
present in the supply's consumer_list).

Here is a kernel log snippet showing the issue:

[   12.421768] gpu_cc_gx_gdsc: supplied by pm8350_s5_level
[   12.425854] gpu_cc_gx_gdsc: supplied by pm8350_s5_level
[   12.429064] debugfs: Directory 'regulator.4-SUPPLY' with parent
               '17a00000.rsc:rpmh-regulator-gfxlvl-pm8350_s5_level'
               already present!

Avoid this race condition by holding the rdev->mutex lock inside
of regulator_resolve_supply() while checking and setting
rdev->supply.

Signed-off-by: David Collins <collinsd@codeaurora.org>
Link: https://lore.kernel.org/r/1610068562-4410-1-git-send-email-collinsd@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8a6ca06d9c160..fa8f5fc04d8fd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1567,23 +1567,34 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 {
 	struct regulator_dev *r;
 	struct device *dev = rdev->dev.parent;
-	int ret;
+	int ret = 0;
 
 	/* No supply to resovle? */
 	if (!rdev->supply_name)
 		return 0;
 
-	/* Supply already resolved? */
+	/* Supply already resolved? (fast-path without locking contention) */
 	if (rdev->supply)
 		return 0;
 
+	/*
+	 * Recheck rdev->supply with rdev->mutex lock held to avoid a race
+	 * between rdev->supply null check and setting rdev->supply in
+	 * set_supply() from concurrent tasks.
+	 */
+	regulator_lock(rdev);
+
+	/* Supply just resolved by a concurrent task? */
+	if (rdev->supply)
+		goto out;
+
 	r = regulator_dev_lookup(dev, rdev->supply_name);
 	if (IS_ERR(r)) {
 		ret = PTR_ERR(r);
 
 		/* Did the lookup explicitly defer for us? */
 		if (ret == -EPROBE_DEFER)
-			return ret;
+			goto out;
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
@@ -1591,15 +1602,18 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
 				rdev->supply_name, rdev->desc->name);
-			return -EPROBE_DEFER;
+			ret = -EPROBE_DEFER;
+			goto out;
 		}
 	}
 
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
-		if (!have_full_constraints())
-			return -EINVAL;
+		if (!have_full_constraints()) {
+			ret = -EINVAL;
+			goto out;
+		}
 		r = dummy_regulator_rdev;
 		get_device(&r->dev);
 	}
@@ -1613,7 +1627,8 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r->dev.parent && r->dev.parent != rdev->dev.parent) {
 		if (!device_is_bound(r->dev.parent)) {
 			put_device(&r->dev);
-			return -EPROBE_DEFER;
+			ret = -EPROBE_DEFER;
+			goto out;
 		}
 	}
 
@@ -1621,13 +1636,13 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	ret = regulator_resolve_supply(r);
 	if (ret < 0) {
 		put_device(&r->dev);
-		return ret;
+		goto out;
 	}
 
 	ret = set_supply(rdev, r);
 	if (ret < 0) {
 		put_device(&r->dev);
-		return ret;
+		goto out;
 	}
 
 	/* Cascade always-on state to supply */
@@ -1636,11 +1651,13 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 		if (ret < 0) {
 			_regulator_put(rdev->supply);
 			rdev->supply = NULL;
-			return ret;
+			goto out;
 		}
 	}
 
-	return 0;
+out:
+	regulator_unlock(rdev);
+	return ret;
 }
 
 /* Internal regulator request function */
-- 
2.27.0



