Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7B1F6DDD
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 21:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgFKTSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgFKTR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 15:17:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5238DC08C5C7
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 12:17:58 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi2-0002KK-G7; Thu, 11 Jun 2020 21:17:54 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1jjSi2-00010A-6F; Thu, 11 Jun 2020 21:17:54 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Knud Poulsen <knpo@ieee.org>
Cc:     linux-watchdog@vger.kernel.org, kernel@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/8] watchdog: f71808e_wdt: clear watchdog timeout occurred flag
Date:   Thu, 11 Jun 2020 21:17:45 +0200
Message-Id: <20200611191750.28096-5-a.fatoum@pengutronix.de>
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

The flag indicating a watchdog timeout having occurred normally persists
till Power-On Reset of the Fintek Super I/O chip. The user can clear it
by writing a `1' to the bit.

The driver doesn't offer a restart method, so regular system reboot
might not reset the Super I/O and if the watchdog isn't enabled, we
won't touch the register containing the bit on the next boot.
In this case all subsequent regular reboots will be wrongly flagged
by the driver as being caused by the watchdog.

Fix this by having the flag cleared after read. This is also done by
other drivers like those for the i6300esb and mpc8xxx_wdt.

Fixes: b97cb21a4634 ("watchdog: f71808e_wdt: Fix WDTMOUT_STS register read")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/watchdog/f71808e_wdt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 8e5584c54423..26bf366aebc2 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -706,6 +706,13 @@ static int __init watchdog_init(int sioaddr)
 	wdt_conf = superio_inb(sioaddr, F71808FG_REG_WDT_CONF);
 	watchdog.caused_reboot = wdt_conf & BIT(F71808FG_FLAG_WDTMOUT_STS);
 
+	/*
+	 * We don't want WDTMOUT_STS to stick around till regular reboot.
+	 * Write 1 to the bit to clear it to zero.
+	 */
+	superio_outb(sioaddr, F71808FG_REG_WDT_CONF,
+		     wdt_conf | BIT(F71808FG_FLAG_WDTMOUT_STS));
+
 	superio_exit(sioaddr);
 
 	err = watchdog_set_timeout(timeout);
-- 
2.27.0

