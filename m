Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A31318E12
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBKPUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E16264EEE;
        Thu, 11 Feb 2021 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055876;
        bh=l4jsbTIthBX8ZlPlTqTfRLysNM5GMsteOqAD2SmQ/Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jCLQtQXzBO81BkRWNMbmK/zpSKxbZJTb3PbjgzSrHP0vLXIAU/N3xi1MmWn+Kitn
         LUKs2Oy8RngbhEru3qCwexZK0rhXSzjOgPbAnh89VMUZm/2xlShgbGLNMPM2LWLd6W
         hzDQNx5qxDncn9mWkZZ5E92CAv02E60umiEBjrK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/54] regulator: Fix lockdep warning resolving supplies
Date:   Thu, 11 Feb 2021 16:02:27 +0100
Message-Id: <20210211150154.753986584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 14a71d509ac809dcf56d7e3ca376b15d17bd0ddd ]

With commit eaa7995c529b54 (regulator: core: avoid
regulator_resolve_supply() race condition) we started holding the rdev
lock while resolving supplies, an operation that requires holding the
regulator_list_mutex. This results in lockdep warnings since in other
places we take the list mutex then the mutex on an individual rdev.

Since the goal is to make sure that we don't call set_supply() twice
rather than a concern about the cost of resolution pull the rdev lock
and check for duplicate resolution down to immediately before we do the
set_supply() and drop it again once the allocation is done.

Fixes: eaa7995c529b54 (regulator: core: avoid regulator_resolve_supply() race condition)
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210122132042.10306-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2c31f04ff950f..35098dbd32a3c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1823,17 +1823,6 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (rdev->supply)
 		return 0;
 
-	/*
-	 * Recheck rdev->supply with rdev->mutex lock held to avoid a race
-	 * between rdev->supply null check and setting rdev->supply in
-	 * set_supply() from concurrent tasks.
-	 */
-	regulator_lock(rdev);
-
-	/* Supply just resolved by a concurrent task? */
-	if (rdev->supply)
-		goto out;
-
 	r = regulator_dev_lookup(dev, rdev->supply_name);
 	if (IS_ERR(r)) {
 		ret = PTR_ERR(r);
@@ -1885,12 +1874,29 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 		goto out;
 	}
 
+	/*
+	 * Recheck rdev->supply with rdev->mutex lock held to avoid a race
+	 * between rdev->supply null check and setting rdev->supply in
+	 * set_supply() from concurrent tasks.
+	 */
+	regulator_lock(rdev);
+
+	/* Supply just resolved by a concurrent task? */
+	if (rdev->supply) {
+		regulator_unlock(rdev);
+		put_device(&r->dev);
+		goto out;
+	}
+
 	ret = set_supply(rdev, r);
 	if (ret < 0) {
+		regulator_unlock(rdev);
 		put_device(&r->dev);
 		goto out;
 	}
 
+	regulator_unlock(rdev);
+
 	/*
 	 * In set_machine_constraints() we may have turned this regulator on
 	 * but we couldn't propagate to the supply if it hadn't been resolved
@@ -1906,7 +1912,6 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	}
 
 out:
-	regulator_unlock(rdev);
 	return ret;
 }
 
-- 
2.27.0



