Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD630C488
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbhBBPyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235015AbhBBPMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03DC264F81;
        Tue,  2 Feb 2021 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278414;
        bh=EsMfjvEzCgcNelPGHItlpvhSL0P/9s9n/3PMRhQAf9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8lx/Iz5Y60Vu+zGuCon8sJpKrJklXVCGBIu66RxCLF+8+hrzgcadRFXMx0erXV+V
         dvGl9dls0ZiC3EgpVhZmGYg9pg1faKhf32ig+UQ45RawXLjgBSpr0wdJGZa4ltSJ3e
         dYcFBkclvdEW02GWRlUpvv7asGU3UvUlS2PwnsESOBPDefvtt5H69eQv2NLdkFbMux
         YAuMrUywB+mknvCppC1htAumtK2etbGQRnqunszCZ5+F59EaIho+3rwLSEafymhA7n
         oGGWW3sAWYvjvQtT2xbnK2iVXvBYIkxsDNBqkPH62CYMmgoLFpB2xk7QxifevfxKJk
         jRSiBqk9o6EvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 02/17] regulator: core: avoid regulator_resolve_supply() race condition
Date:   Tue,  2 Feb 2021 10:06:36 -0500
Message-Id: <20210202150651.1864426-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c9b8613e69db2..5e0490e18b46a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1772,23 +1772,34 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 {
 	struct regulator_dev *r;
 	struct device *dev = rdev->dev.parent;
-	int ret;
+	int ret = 0;
 
 	/* No supply to resolve? */
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
@@ -1796,15 +1807,18 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
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
@@ -1818,7 +1832,8 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r->dev.parent && r->dev.parent != rdev->dev.parent) {
 		if (!device_is_bound(r->dev.parent)) {
 			put_device(&r->dev);
-			return -EPROBE_DEFER;
+			ret = -EPROBE_DEFER;
+			goto out;
 		}
 	}
 
@@ -1826,13 +1841,13 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
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
 
 	/*
@@ -1845,11 +1860,13 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
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

