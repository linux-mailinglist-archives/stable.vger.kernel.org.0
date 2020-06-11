Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC111F6DDF
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgFKTSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgFKTR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 15:17:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FF1C08C5C3
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 12:17:57 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi1-0002J6-Oi; Thu, 11 Jun 2020 21:17:53 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi1-0000yP-6Y; Thu, 11 Jun 2020 21:17:53 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Knud Poulsen <knpo@ieee.org>
Cc:     linux-watchdog@vger.kernel.org, kernel@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/8] watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options
Date:   Thu, 11 Jun 2020 21:17:43 +0200
Message-Id: <20200611191750.28096-3-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200611191750.28096-1-a.fatoum@pengutronix.de>
References: <20200611191750.28096-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver supports populating bootstatus with WDIOF_CARDRESET, but so
far userspace couldn't portably determine whether absence of this flag
meant no watchdog reset or no driver support. Or-in the bit to fix this.

Fixes: b97cb21a4634 ("watchdog: f71808e_wdt: Fix WDTMOUT_STS register read")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/watchdog/f71808e_wdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index a3c44d75d80e..c8ce80c13403 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -692,7 +692,8 @@ static int __init watchdog_init(int sioaddr)
 	watchdog.sioaddr = sioaddr;
 	watchdog.ident.options = WDIOC_SETTIMEOUT
 				| WDIOF_MAGICCLOSE
-				| WDIOF_KEEPALIVEPING;
+				| WDIOF_KEEPALIVEPING
+				| WDIOF_CARDRESET;
 
 	snprintf(watchdog.ident.identity,
 		sizeof(watchdog.ident.identity), "%s watchdog",
-- 
2.27.0

