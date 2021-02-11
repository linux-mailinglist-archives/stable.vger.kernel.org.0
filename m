Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51548318E29
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhBKPWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhBKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA5764F11;
        Thu, 11 Feb 2021 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055956;
        bh=pa6Hgg3xEuFgkEo/ivc/91UtrOpegC71GIRRjIY8Efk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tThUqH4+n/lk2ysnSx/bd4ROyQVTFBRW2+msSKhTYK0pZAYW4Yk5uWhDHr9KFmlK1
         S5D+Rxuhrf9wIEy9hrJk6lwI70bPG5QWXKTDM3+wV3QO2XHPd9p4Gp1/0rAYi4kVnE
         OF3xXxHU0dtbcfIklDvqcY5oK2GyEp8d+960fLqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/24] regulator: Fix lockdep warning resolving supplies
Date:   Thu, 11 Feb 2021 16:02:42 +0100
Message-Id: <20210211150149.362433699@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
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
index 5e0490e18b46a..5b9d570df85cc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1782,17 +1782,6 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
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
@@ -1844,12 +1833,29 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
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
@@ -1865,7 +1871,6 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	}
 
 out:
-	regulator_unlock(rdev);
 	return ret;
 }
 
-- 
2.27.0



