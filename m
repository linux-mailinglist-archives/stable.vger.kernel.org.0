Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122DA24B3E1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgHTJxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729902AbgHTJxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:53:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619562173E;
        Thu, 20 Aug 2020 09:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917216;
        bh=z1bWgTa9JnH8RMIZqIT+XLK2kqP+JWiABGvNdNQcH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/5I8b22y3R4vE6zBIgmQpcOR2BZ7o/3fRgyf/5VMdECTBXmaHJVNII+aWLY/Achm
         /s3+2aePlPbrGtosOjIxNvkwL6QF9+Th5NefioqDSNmfb+YIa/ksFgkwqdyzpcSizo
         uCShzwNo29vFvVRtJ92ZPhFzkOq8TocGeeC4ju4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 4.19 43/92] watchdog: f71808e_wdt: clear watchdog timeout occurred flag
Date:   Thu, 20 Aug 2020 11:21:28 +0200
Message-Id: <20200820091539.858163022@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
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


