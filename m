Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573FA3CE5A4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348012AbhGSPwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239802AbhGSPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F9E613F5;
        Mon, 19 Jul 2021 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712038;
        bh=/6P/yh1GrLehfkA0U3vm5g25urVZMcCG+tR3K6Xmti8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmH1dkOpKeiANvOL8E+zi9idVpOzS80TM8GuUQ23nFf6FAxTVnCM5zrhCe/v4g/9U
         aeOSuNkPKI2n2YIGAVSQZHoHYJpBTQsPWoIx/9kC+dZdwA5kPtpY5OFs7jUQh3Ivn+
         geAjtb7II0S2x+BVnl1rhjlnCf+FWzJoopu+3Evo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 193/292] watchdog: keembay: Remove timeout update in the WDT start function
Date:   Mon, 19 Jul 2021 16:54:15 +0200
Message-Id: <20210719144948.841231597@linuxfoundation.org>
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

[ Upstream commit 9eb25269271c679e8cfcc7df5c0c5e9d0572fc27 ]

Removed set timeout from the start WDT function. There is a function
defined to set the timeout. Hence no need to set the timeout again in
start function as the timeout would have been already updated
before calling the start/enable.

Fixes: fa0f8d51e90d ("watchdog: Add watchdog driver for Intel Keembay Soc")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kris Pan <kris.pan@intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20210517174953.19404-6-shruthi.sanil@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/keembay_wdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/keembay_wdt.c b/drivers/watchdog/keembay_wdt.c
index f2a16c9933c3..039753b9932b 100644
--- a/drivers/watchdog/keembay_wdt.c
+++ b/drivers/watchdog/keembay_wdt.c
@@ -84,7 +84,6 @@ static int keembay_wdt_start(struct watchdog_device *wdog)
 {
 	struct keembay_wdt *wdt = watchdog_get_drvdata(wdog);
 
-	keembay_wdt_set_timeout_reg(wdog);
 	keembay_wdt_writel(wdt, TIM_WDOG_EN, 1);
 
 	return 0;
-- 
2.30.2



