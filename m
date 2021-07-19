Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B4B3CE356
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbhGSPha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242768AbhGSPel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90095613D2;
        Mon, 19 Jul 2021 16:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711095;
        bh=4jecikHcgxeU8uQib/wwghp4sWMkjYX2jhx3uUKfQ5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLHfwSdjXQYUl3pUi4HVbbuqZ+um7FnncIkcq+Zk/0DRLd33YwKDY6WY0WPphJQ5p
         aD8EYHpxlvgNV/uYuvPX6r5bd+qUVpgkUAhAiPXlG1sl0EyHgeByQ+QrGN5gnnwtUW
         n7WCuGyR9+xLem8T+SN+PK0UqfqQnahWH29XZAAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 225/351] watchdog: keembay: Removed timeout update in the TO ISR
Date:   Mon, 19 Jul 2021 16:52:51 +0200
Message-Id: <20210719144952.399144746@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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



