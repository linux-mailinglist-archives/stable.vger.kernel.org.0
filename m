Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796D43CE3CF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhGSPkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239277AbhGSPeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7AD66135D;
        Mon, 19 Jul 2021 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711081;
        bh=9zqASD8Vjs3E/spUcYvm/3cnW30v8MLmnrtGEW8CPc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLKaaU1uRKGivGvVs4Y2/tJiM+7x2No53Ileuy5H/VBQyEn7p7lmnkRL7z32+yWTQ
         aBCgs5J8NZWrbcFujmQF2heqSkiUFBWeqGZlS01SZjAwcubD+qp+GYPywkk7uOzUiX
         EGojzsjDHYUAIC0GsQW+YrjisuObdG3wPH27asP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 220/351] watchdog: keembay: Update WDT pre-timeout during the initialization
Date:   Mon, 19 Jul 2021 16:52:46 +0200
Message-Id: <20210719144952.238924071@linuxfoundation.org>
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

[ Upstream commit 29353816300c79cb5157ed2719cc71285c7b77aa ]

The pretimeout register has a default reset value. Hence
when a smaller WDT timeout is set which would be lesser than the
default pretimeout, the system behaves abnormally, starts
triggering the pretimeout interrupt even when the WDT is
not enabled, most of the times leading to system crash.
Hence an update in the pre-timeout is also required for the
default timeout that is being configured.

Fixes: fa0f8d51e90d ("watchdog: Add watchdog driver for Intel Keembay Soc")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kris Pan <kris.pan@intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20210517174953.19404-2-shruthi.sanil@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/keembay_wdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/keembay_wdt.c b/drivers/watchdog/keembay_wdt.c
index 547d3fea33ff..f2f5c9fae29c 100644
--- a/drivers/watchdog/keembay_wdt.c
+++ b/drivers/watchdog/keembay_wdt.c
@@ -29,6 +29,7 @@
 #define WDT_LOAD_MAX		U32_MAX
 #define WDT_LOAD_MIN		1
 #define WDT_TIMEOUT		5
+#define WDT_PRETIMEOUT		4
 
 static unsigned int timeout = WDT_TIMEOUT;
 module_param(timeout, int, 0);
@@ -224,11 +225,13 @@ static int keembay_wdt_probe(struct platform_device *pdev)
 	wdt->wdd.min_timeout	= WDT_LOAD_MIN;
 	wdt->wdd.max_timeout	= WDT_LOAD_MAX / wdt->rate;
 	wdt->wdd.timeout	= WDT_TIMEOUT;
+	wdt->wdd.pretimeout	= WDT_PRETIMEOUT;
 
 	watchdog_set_drvdata(&wdt->wdd, wdt);
 	watchdog_set_nowayout(&wdt->wdd, nowayout);
 	watchdog_init_timeout(&wdt->wdd, timeout, dev);
 	keembay_wdt_set_timeout(&wdt->wdd, wdt->wdd.timeout);
+	keembay_wdt_set_pretimeout(&wdt->wdd, wdt->wdd.pretimeout);
 
 	ret = devm_watchdog_register_device(dev, &wdt->wdd);
 	if (ret)
-- 
2.30.2



