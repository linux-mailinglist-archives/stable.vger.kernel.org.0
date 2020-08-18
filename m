Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4EF24843F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHRLxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgHRLxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:53:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA4E206B5;
        Tue, 18 Aug 2020 11:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597751610;
        bh=Xe61cljOQT5Jr855FdIsMgYQj/Lrk3Ve20zrwLufcRI=;
        h=Subject:To:From:Date:From;
        b=fdaKiQw4KI/842zZRCt9k4H2HPUUEsWFLsoHuBPqeZnNf2rHpzB3LUMSDJTg6j4iA
         SEaoYVTWOC+qXQEED7R1E85wAkTxP8nxzJRIeL9A3vKyGhKjoe/lmazLqX1bBzJZ3B
         8dfzBSXk+szf3L1t5PTWw0PzBoTZtF/JGD0ObXLc=
Subject: patch "serial: samsung: Removes the IRQ not found warning" added to tty-linus
To:     m.shams@samsung.com, alim.akhtar@samsung.com,
        gregkh@linuxfoundation.org, krzk@kernel.org,
        m.szyprowski@samsung.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:53:54 +0200
Message-ID: <159775163498230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: samsung: Removes the IRQ not found warning

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8c6c378b0cbe0c9f1390986b5f8ffb5f6ff7593b Mon Sep 17 00:00:00 2001
From: Tamseel Shams <m.shams@samsung.com>
Date: Mon, 10 Aug 2020 08:30:21 +0530
Subject: serial: samsung: Removes the IRQ not found warning

In few older Samsung SoCs like s3c2410, s3c2412
and s3c2440, UART IP is having 2 interrupt lines.
However, in other SoCs like s3c6400, s5pv210,
exynos5433, and exynos4210 UART is having only 1
interrupt line. Due to this, "platform_get_irq(platdev, 1)"
call in the driver gives the following false-positive error:
"IRQ index 1 not found" on newer SoC's.

This patch adds the condition to check for Tx interrupt
only for the those SoC's which have 2 interrupt lines.

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Tamseel Shams <m.shams@samsung.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200810030021.45348-1-m.shams@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index 8ed3482d2e1e..8ae3e03fbd8c 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -1905,9 +1905,11 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 		ourport->tx_irq = ret + 1;
 	}
 
-	ret = platform_get_irq(platdev, 1);
-	if (ret > 0)
-		ourport->tx_irq = ret;
+	if (!s3c24xx_serial_has_interrupt_mask(port)) {
+		ret = platform_get_irq(platdev, 1);
+		if (ret > 0)
+			ourport->tx_irq = ret;
+	}
 	/*
 	 * DMA is currently supported only on DT platforms, if DMA properties
 	 * are specified.
-- 
2.28.0


