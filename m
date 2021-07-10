Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751083C3893
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhGJXz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233699AbhGJXya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0101B61362;
        Sat, 10 Jul 2021 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961082;
        bh=eWAWdoYUyGT4tcyRnagC6znYfXGQBgaN1dR66rV/snc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFFZEr5Fh0o47HJpzIS5LhZXyv6y47GFvEVMyy8ukL04JasTPnRA7uCht3oZdKgNV
         mY/AVta6r3yHJCzXoz9FOqRezwJIRDo7CH3oAWlIFJ3fPz8LHDkJxYWCOGYeu8RjKm
         BVU2ZEzBgUU6Rsd+9A/UU+aoXo1pMVhu4uaSEweMw7YXSGb4lT+zQze1A1Gz2grpfs
         kz3kSukTfTx1DL0QgBvUbhpTUt8g+4b3IWqK5tvsCBwF26ChX3yETBPbAtz1Xiy9QZ
         LwNU/WEGjkJ8MEcaJfxcztfxkMR1SYc/YW7lAnEk7/ELaLqN3TmQuC0eMRW7AXTSpS
         TbofHxr3V3Vsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 11/28] watchdog: Fix possible use-after-free by calling del_timer_sync()
Date:   Sat, 10 Jul 2021 19:50:50 -0400
Message-Id: <20210710235107.3221840-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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
index 78cf11c94941..60b6d74f267d 100644
--- a/drivers/watchdog/lpc18xx_wdt.c
+++ b/drivers/watchdog/lpc18xx_wdt.c
@@ -292,7 +292,7 @@ static int lpc18xx_wdt_remove(struct platform_device *pdev)
 	struct lpc18xx_wdt_dev *lpc18xx_wdt = platform_get_drvdata(pdev);
 
 	dev_warn(&pdev->dev, "I quit now, hardware will probably reboot!\n");
-	del_timer(&lpc18xx_wdt->timer);
+	del_timer_sync(&lpc18xx_wdt->timer);
 
 	return 0;
 }
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 6eb5185d6ea6..d9addf06b44d 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -166,7 +166,7 @@ static void wdt_startup(void)
 static void wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	wdt_change(WDT_DISABLE);
 
-- 
2.30.2

