Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B263C392D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhGJX5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234154AbhGJX4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01BC46139A;
        Sat, 10 Jul 2021 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961144;
        bh=R0K2ru8SwBXcnmYkkqAkC/oTg8Hmjm3VREYbCa1ftno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGIa6itFvUUQi97Ie4t6ab+sHSdQIQgJHDumphOaM5WoKBLq3LJ6ZzH2kODzTnnO4
         V6xWktD5EX+L16fZJA+BP8Da3Rj7FDqqikCgedZM2qg9pifaYpt5daZNtvGcwMFLYY
         79UA7QshGMp6GKB27wRCopYD86Ov1U8Y2rKWAnDdaw26GPIot4+BSgC2N6NWrK5EnJ
         M+tGifTE6+0BrjGynbgMOAshT4dTgBuhoLdCSmSAeStbc19TWvunwVzmGjEhxuHDWl
         /WysUESsZ4JPjgAtFvkn2E0YFA59slHgLaDjsvV0L0T34VS5z8kmQyL11Jo8SZOmY5
         SiUgtWmz8e89A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 08/21] watchdog: Fix possible use-after-free by calling del_timer_sync()
Date:   Sat, 10 Jul 2021 19:51:59 -0400
Message-Id: <20210710235212.3222375-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit d0212f095ab56672f6f36aabc605bda205e1e0bf ]

This driver's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://lore.kernel.org/r/1620802676-19701-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/lpc18xx_wdt.c | 2 +-
 drivers/watchdog/w83877f_wdt.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/lpc18xx_wdt.c b/drivers/watchdog/lpc18xx_wdt.c
index 3b8bb59adf02..e9deeda1fdbf 100644
--- a/drivers/watchdog/lpc18xx_wdt.c
+++ b/drivers/watchdog/lpc18xx_wdt.c
@@ -300,7 +300,7 @@ static int lpc18xx_wdt_remove(struct platform_device *pdev)
 	struct lpc18xx_wdt_dev *lpc18xx_wdt = platform_get_drvdata(pdev);
 
 	dev_warn(&pdev->dev, "I quit now, hardware will probably reboot!\n");
-	del_timer(&lpc18xx_wdt->timer);
+	del_timer_sync(&lpc18xx_wdt->timer);
 
 	watchdog_unregister_device(&lpc18xx_wdt->wdt_dev);
 	clk_disable_unprepare(lpc18xx_wdt->wdt_clk);
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index f0483c75ed32..4b52cf321747 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -170,7 +170,7 @@ static void wdt_startup(void)
 static void wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	wdt_change(WDT_DISABLE);
 
-- 
2.30.2

