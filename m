Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC17392FAC
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhE0NaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 09:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236492AbhE0NaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 09:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBE4561059;
        Thu, 27 May 2021 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622122111;
        bh=Z9Wilw2+RP/FewgluEetbKEYHLYZYzd6a7jwEZTwhzE=;
        h=Subject:To:From:Date:From;
        b=bofgWTiyc8D114P/xtXDiVY4HzDlw3Rgt9u6CMZLE7KzEaZQLeQiYf2WzxT4Oh0MN
         2auKWUZmg8KwN0Z4mNqJ1JjMXWYnbVQrWxYH7kDPEB0QnwxWRMsYPd7/iZx0LpqsEv
         GvXv+62nmlTko9yrM2jqKEs7TppdKMpXcLRinCN8=
Subject: patch "serial: 8250_pci: handle FL_NOIRQ board flag" added to tty-linus
To:     christian.gmeiner@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 May 2021 15:28:29 +0200
Message-ID: <162212210933109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_pci: handle FL_NOIRQ board flag

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9808f9be31c68af43f6e531f2c851ebb066513fe Mon Sep 17 00:00:00 2001
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 27 May 2021 11:54:40 +0200
Subject: serial: 8250_pci: handle FL_NOIRQ board flag

In commit 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
the way the irq gets allocated was changed. With that change the
handling FL_NOIRQ got lost. Restore the old behaviour.

Fixes: 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Link: https://lore.kernel.org/r/20210527095529.26281-1-christian.gmeiner@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 04fe42469990..780cc99732b6 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3958,21 +3958,26 @@ pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 	uart.port.flags = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF | UPF_SHARE_IRQ;
 	uart.port.uartclk = board->base_baud * 16;
 
-	if (pci_match_id(pci_use_msi, dev)) {
-		dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
-		pci_set_master(dev);
-		rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (board->flags & FL_NOIRQ) {
+		uart.port.irq = 0;
 	} else {
-		dev_dbg(&dev->dev, "Using legacy interrupts\n");
-		rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);
-	}
-	if (rc < 0) {
-		kfree(priv);
-		priv = ERR_PTR(rc);
-		goto err_deinit;
+		if (pci_match_id(pci_use_msi, dev)) {
+			dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
+			pci_set_master(dev);
+			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
+		} else {
+			dev_dbg(&dev->dev, "Using legacy interrupts\n");
+			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);
+		}
+		if (rc < 0) {
+			kfree(priv);
+			priv = ERR_PTR(rc);
+			goto err_deinit;
+		}
+
+		uart.port.irq = pci_irq_vector(dev, 0);
 	}
 
-	uart.port.irq = pci_irq_vector(dev, 0);
 	uart.port.dev = &dev->dev;
 
 	for (i = 0; i < nr_ports; i++) {
-- 
2.31.1


