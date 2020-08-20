Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94AD24B26C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgHTJ3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgHTJ3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:29:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A14CF21744;
        Thu, 20 Aug 2020 09:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915751;
        bh=Jen+qfOZNmYM0kSGwzovdZBTZXKl8VbilUIN2LKYbyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fc4YBdMT2Fqcelr5PzAAPc0b98nnN9fjXSIY5mckynUfi9gZbMGPD8jg/BkeW+2vy
         EgyukgnhaLqg0znCllSwORIALjTH51H7eRKWurka4v2IkqpIxoCjmlRCmlpOrgWPYy
         FfYpsgwFBS1FlEA0rHqt9Do8QfMAEVbm29+eAans=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.8 094/232] watchdog: f71808e_wdt: clear watchdog timeout occurred flag
Date:   Thu, 20 Aug 2020 11:19:05 +0200
Message-Id: <20200820091617.390038716@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
@@ -706,6 +706,13 @@ static int __init watchdog_init(int sioa
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


