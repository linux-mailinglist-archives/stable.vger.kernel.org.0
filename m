Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33913CE56F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349224AbhGSPuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241276AbhGSPqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD42E6145A;
        Mon, 19 Jul 2021 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712014;
        bh=dtrbSkRrJsSWp/litbZIc5oikePs1EjtcjMjJ7YtHmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNBRifpdQFkRy4Gh0q754w7OffpSzScpHoQWHtFIS7yog9g028d6VQoPYdvpxe/Ev
         HNEni3R1UL57+Ar2oyhWc3VpBH52SUlrlfZQMUVnralPxbueUXKG6ROHBdgSUJql+r
         wHDvBzykzvnayU198nE0+zKt1HK31I9ad9RfTeP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kris Pan <kris.pan@intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 190/292] watchdog: keembay: Upadate WDT pretimeout for every update in timeout
Date:   Mon, 19 Jul 2021 16:54:12 +0200
Message-Id: <20210719144948.740324599@linuxfoundation.org>
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

[ Upstream commit 0f7bfaf10c0abc979220442bae2af4f1f869c41e ]

The pre-timeout value to be programmed to the register has to be
calculated and updated for every change in the timeout value.
Else the threshold time wouldn't be calculated to its
corresponding timeout.

Fixes: fa0f8d51e90d ("watchdog: Add watchdog driver for Intel Keembay Soc")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kris Pan <kris.pan@intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20210517174953.19404-3-shruthi.sanil@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/keembay_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/keembay_wdt.c b/drivers/watchdog/keembay_wdt.c
index f2f5c9fae29c..b2afeb4a60e3 100644
--- a/drivers/watchdog/keembay_wdt.c
+++ b/drivers/watchdog/keembay_wdt.c
@@ -109,6 +109,7 @@ static int keembay_wdt_set_timeout(struct watchdog_device *wdog, u32 t)
 {
 	wdog->timeout = t;
 	keembay_wdt_set_timeout_reg(wdog);
+	keembay_wdt_set_pretimeout_reg(wdog);
 
 	return 0;
 }
-- 
2.30.2



