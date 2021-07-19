Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3005F3CE5BB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbhGSPwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344872AbhGSPrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B40561414;
        Mon, 19 Jul 2021 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712040;
        bh=4jecikHcgxeU8uQib/wwghp4sWMkjYX2jhx3uUKfQ5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEwoXfXPXiIRVQ77ie58EKWOhEIDDJ2BNRf8mWOu4InaABdyBR5jX6fPwFOmiaZl6
         pBQMk//BH+CduWeb6oyh46fPQf1ebCWOSwWLT7aBDr2E9dSSnVpIdMCPAjQQ9F6Lls
         /JeCowgTSSV0FccT/zp8NHSo/E1wJQpLNfcctkwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 194/292] watchdog: keembay: Removed timeout update in the TO ISR
Date:   Mon, 19 Jul 2021 16:54:16 +0200
Message-Id: <20210719144948.871965281@linuxfoundation.org>
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

[ Upstream commit 3168be5d66ac6c3508a880022f79b5a887865d5d ]

In the TO ISR removed updating the Timeout value because
its not serving any purpose as the timer would have already expired
and the system would be rebooting.

Fixes: fa0f8d51e90d ("watchdog: Add watchdog driver for Intel Keembay Soc")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kris Pan <kris.pan@intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20210517174953.19404-7-shruthi.sanil@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/keembay_wdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/keembay_wdt.c b/drivers/watchdog/keembay_wdt.c
index 039753b9932b..dd192b8dff55 100644
--- a/drivers/watchdog/keembay_wdt.c
+++ b/drivers/watchdog/keembay_wdt.c
@@ -141,7 +141,6 @@ static irqreturn_t keembay_wdt_to_isr(int irq, void *dev_id)
 	struct keembay_wdt *wdt = dev_id;
 	struct arm_smccc_res res;
 
-	keembay_wdt_writel(wdt, TIM_WATCHDOG, 1);
 	arm_smccc_smc(WDT_ISR_CLEAR, WDT_TO_INT_MASK, 0, 0, 0, 0, 0, 0, &res);
 	dev_crit(wdt->wdd.parent, "Intel Keem Bay non-sec wdt timeout.\n");
 	emergency_restart();
-- 
2.30.2



