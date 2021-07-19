Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE47E3CE5A1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345391AbhGSPwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242147AbhGSPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20A6261376;
        Mon, 19 Jul 2021 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712035;
        bh=2YOHV8+qqf8dcNZqg3uXOI7cfpP8ORr6M0OS/ycxGjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwtdtmWNbvtB78I1ZBMGgGfMcdPFBSvwZv61srs4EK0UBJ+eRfw+uzDwtCVRxHmKi
         SdSk0wAZtMrFYv6Tkho1rdqUyfSyPVpuo+VZ++prAlizj6gDwAMaiCG2lDlF7+JK3q
         AwdrQl+rbgPTpSkqM5MiRPvNFI24yDHEHdu08oxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 192/292] watchdog: keembay: Clear either the TO or TH interrupt bit
Date:   Mon, 19 Jul 2021 16:54:14 +0200
Message-Id: <20210719144948.808641499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shruthi Sanil <shruthi.sanil@intel.com>

[ Upstream commit 0e36a09faea25f4564d41a0c28938199b605148e ]

During the interrupt service routine of the TimeOut interrupt and
the ThresHold interrupt, the respective interrupt clear bit
have to be cleared and not both.

Fixes: fa0f8d51e90d ("watchdog: Add watchdog driver for Intel Keembay Soc")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kris Pan <kris.pan@intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20210517174953.19404-5-shruthi.sanil@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/keembay_wdt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/keembay_wdt.c b/drivers/watchdog/keembay_wdt.c
index 6053416b8d3d..f2a16c9933c3 100644
--- a/drivers/watchdog/keembay_wdt.c
+++ b/drivers/watchdog/keembay_wdt.c
@@ -23,7 +23,8 @@
 #define TIM_WDOG_EN		0x8
 #define TIM_SAFE		0xc
 
-#define WDT_ISR_MASK		GENMASK(9, 8)
+#define WDT_TH_INT_MASK		BIT(8)
+#define WDT_TO_INT_MASK		BIT(9)
 #define WDT_ISR_CLEAR		0x8200ff18
 #define WDT_UNLOCK		0xf1d0dead
 #define WDT_LOAD_MAX		U32_MAX
@@ -142,7 +143,7 @@ static irqreturn_t keembay_wdt_to_isr(int irq, void *dev_id)
 	struct arm_smccc_res res;
 
 	keembay_wdt_writel(wdt, TIM_WATCHDOG, 1);
-	arm_smccc_smc(WDT_ISR_CLEAR, WDT_ISR_MASK, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_smc(WDT_ISR_CLEAR, WDT_TO_INT_MASK, 0, 0, 0, 0, 0, 0, &res);
 	dev_crit(wdt->wdd.parent, "Intel Keem Bay non-sec wdt timeout.\n");
 	emergency_restart();
 
@@ -156,7 +157,7 @@ static irqreturn_t keembay_wdt_th_isr(int irq, void *dev_id)
 
 	keembay_wdt_set_pretimeout(&wdt->wdd, 0x0);
 
-	arm_smccc_smc(WDT_ISR_CLEAR, WDT_ISR_MASK, 0, 0, 0, 0, 0, 0, &res);
+	arm_smccc_smc(WDT_ISR_CLEAR, WDT_TH_INT_MASK, 0, 0, 0, 0, 0, 0, &res);
 	dev_crit(wdt->wdd.parent, "Intel Keem Bay non-sec wdt pre-timeout.\n");
 	watchdog_notify_pretimeout(&wdt->wdd);
 
-- 
2.30.2



