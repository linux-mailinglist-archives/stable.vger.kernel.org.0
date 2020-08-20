Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759BF24B944
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHTLlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730493AbgHTKEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:04:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C76C22B4D;
        Thu, 20 Aug 2020 10:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917881;
        bh=z1bWgTa9JnH8RMIZqIT+XLK2kqP+JWiABGvNdNQcH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGBmfO2H4DvW9rFhxcrY4aDvjbI7UwoS2U7uL5PYMrV8IQjMvz8DXUvF0BO0HtODR
         ACGSmwHPOttCI2yA4/7dlk50KWsJ7K9GqREFvGAoFVLnVaw5gVzR2xevEspqUDzZqf
         dMZ7RqAE+fVzbwsMPiG58Vgp4t0nGWKAE/kanS7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 4.9 190/212] watchdog: f71808e_wdt: clear watchdog timeout occurred flag
Date:   Thu, 20 Aug 2020 11:22:43 +0200
Message-Id: <20200820091611.979934782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit 4f39d575844148fbf3081571a1f3b4ae04150958 upstream.

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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200611191750.28096-5-a.fatoum@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/f71808e_wdt.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -704,6 +704,13 @@ static int __init watchdog_init(int sioa
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


