Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA124B6E0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgHTKnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgHTKQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D3FF206DA;
        Thu, 20 Aug 2020 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918578;
        bh=z1bWgTa9JnH8RMIZqIT+XLK2kqP+JWiABGvNdNQcH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEwgI+t/lS5vt2k8qmKhI3o2f1B81n4DlVL0KRUYWD2qkEl/4vUqMVID9fdECi6WO
         +Q8U2SARoeZD3fTr/Xiysy1nrQ2PAsCs/aTKvBy1X4ZBzlusvxdUzxlyHQIVw/WIsz
         vGVb9VKbFlXjzZvQ+QGH+rkjIKjFLzJqwZ0qH5Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 4.14 191/228] watchdog: f71808e_wdt: clear watchdog timeout occurred flag
Date:   Thu, 20 Aug 2020 11:22:46 +0200
Message-Id: <20200820091617.115856099@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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


