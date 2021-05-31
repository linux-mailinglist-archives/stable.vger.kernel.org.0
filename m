Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904D0396023
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhEaOXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233615AbhEaOVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94470619C4;
        Mon, 31 May 2021 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468681;
        bh=WI96yNYEwV38Y2J1FKT1h5hUwNeLHHgB+vbk3m1vC6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH/La89af7enriWVOYQIdJnmEUvBeqZWqYEqU2klZS2rWog99sgWtft0MwpAHNive
         crmWDhH7DVuXUWzRUOteDpataFevLJU/yE8CuiteRREvYlzS/74AhXUTXUUFBsquad
         6nwFpcvxm+0BCOpacg+tVOtuXLv444r/FleY+tuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.4 050/177] serial: 8250_pci: handle FL_NOIRQ board flag
Date:   Mon, 31 May 2021 15:13:27 +0200
Message-Id: <20210531130649.662027632@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gmeiner <christian.gmeiner@gmail.com>

commit 9808f9be31c68af43f6e531f2c851ebb066513fe upstream.

In commit 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
the way the irq gets allocated was changed. With that change the
handling FL_NOIRQ got lost. Restore the old behaviour.

Fixes: 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Link: https://lore.kernel.org/r/20210527095529.26281-1-christian.gmeiner@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3917,21 +3917,26 @@ pciserial_init_ports(struct pci_dev *dev
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


