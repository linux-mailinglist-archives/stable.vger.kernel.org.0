Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34EB1F6DDB
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 21:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFKTSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgFKTR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 15:17:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E707BC08C5C9
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 12:17:58 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi2-0002JP-BA; Thu, 11 Jun 2020 21:17:54 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi1-0000yi-MR; Thu, 11 Jun 2020 21:17:53 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Giel van Schijndel <me@mortis.eu>
Cc:     linux-watchdog@vger.kernel.org, kernel@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/8] watchdog: f71808e_wdt: remove use of wrong watchdog_info option
Date:   Thu, 11 Jun 2020 21:17:44 +0200
Message-Id: <20200611191750.28096-4-a.fatoum@pengutronix.de>
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

The flags that should be or-ed into the watchdog_info.options by drivers
all start with WDIOF_, e.g. WDIOF_SETTIMEOUT, which indicates that the
driver's watchdog_ops has a usable set_timeout.

WDIOC_SETTIMEOUT was used instead, which expands to 0xc0045706, which
equals:

   WDIOF_FANFAULT | WDIOF_EXTERN1 | WDIOF_PRETIMEOUT | WDIOF_ALARMONLY |
   WDIOF_MAGICCLOSE | 0xc0045000

These were so far indicated to userspace on WDIOC_GETSUPPORT.
As the driver has not yet been migrated to the new watchdog kernel API,
the constant can just be dropped without substitute.

Fixes: 96cb4eb019ce ("watchdog: f71808e_wdt: new watchdog driver for
       Fintek F71808E and F71882FG")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/watchdog/f71808e_wdt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index c8ce80c13403..8e5584c54423 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -690,8 +690,7 @@ static int __init watchdog_init(int sioaddr)
 	 * into the module have been registered yet.
 	 */
 	watchdog.sioaddr = sioaddr;
-	watchdog.ident.options = WDIOC_SETTIMEOUT
-				| WDIOF_MAGICCLOSE
+	watchdog.ident.options = WDIOF_MAGICCLOSE
 				| WDIOF_KEEPALIVEPING
 				| WDIOF_CARDRESET;
 
-- 
2.27.0

