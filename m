Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14078EF58E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKEGea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfKEGea (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 01:34:30 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738692084D;
        Tue,  5 Nov 2019 06:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572935669;
        bh=rTEJEt9VyI4GUKeij8O6GPPHR+uYhz9J0IL+N9L+tac=;
        h=Subject:To:From:Date:From;
        b=Iy9u5QBinW/IB2PQ4yKwDkc32/U5/3Kl5JP2VQMlzTVViAFVICIfQ0Fmp3fCbW1zS
         rou3vgiyOZfrui5Uk43wGs7tNRJzi26RWICC2nCMFHhAE44H46v4MZ20YTxv7pnI1g
         Bk+ss5eIj8irssUTDBrUSeHS6ygdSBgnYacpA65U=
Subject: patch "serial: 8250_dw: Avoid double error messaging when IRQ absent" added to tty-next
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Nov 2019 07:34:09 +0100
Message-ID: <157293564950102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_dw: Avoid double error messaging when IRQ absent

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 05faa64e73924556ba281911db24643e438fe7ba Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 23 Oct 2019 13:35:58 +0300
Subject: serial: 8250_dw: Avoid double error messaging when IRQ absent

Since the commit 7723f4c5ecdb ("driver core: platform: Add an error message
to platform_get_irq*()") platform_get_irq() started issuing an error message.
Thus, there is no need to have the same in the driver

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191023103558.51862-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index acbf23b3e300..aab3cccc6789 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -385,10 +385,10 @@ static int dw8250_probe(struct platform_device *pdev)
 {
 	struct uart_8250_port uart = {}, *up = &uart;
 	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int irq = platform_get_irq(pdev, 0);
 	struct uart_port *p = &up->port;
 	struct device *dev = &pdev->dev;
 	struct dw8250_data *data;
+	int irq;
 	int err;
 	u32 val;
 
@@ -397,11 +397,9 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (irq < 0) {
-		if (irq != -EPROBE_DEFER)
-			dev_err(dev, "cannot get irq\n");
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
 		return irq;
-	}
 
 	spin_lock_init(&p->lock);
 	p->mapbase	= regs->start;
-- 
2.23.0


