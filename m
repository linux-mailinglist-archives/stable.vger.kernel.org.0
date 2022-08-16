Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEAC5957B4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiHPKL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiHPKLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:11:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AB21372B2;
        Tue, 16 Aug 2022 01:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF23611A1;
        Tue, 16 Aug 2022 08:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B49AC433C1;
        Tue, 16 Aug 2022 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660638495;
        bh=EmPoDDOrmxZizY34vsnNzHSlCf7i+dCyUot8tQaZBjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI95BQPQh6RpNOD0Bs5nBCKpR0pqBZQyYCa18uzfz70pZq9O8PW9cn03ovIHTj4ng
         ii6Kz+lUG0CJw2+CRc5WpRLz7qBWPpBcyBevINsmGrdrrhhN0vD3wbVFsLBklQDSx3
         wvCfPENpwGeattgqY45/ARnmvoK+l2XG3HTBrS+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 714/779] serial: 8250_pci: Replace dev_*() by pci_*() macros
Date:   Mon, 15 Aug 2022 20:05:58 +0200
Message-Id: <20220815180407.976919968@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1177384179416c7136e1348f07609e0da1ae6b91 ]

PCI subsystem provides convenient shortcut macros for message printing.
Use those macros instead of dev_*().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jiri Slaby <jslaby@kernel.org>
Link: https://lore.kernel.org/r/20211022135147.70965-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 52 +++++++++++++-----------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index ef44e5320bef..1994d2db213c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -75,13 +75,12 @@ static int pci_default_setup(struct serial_private*,
 
 static void moan_device(const char *str, struct pci_dev *dev)
 {
-	dev_err(&dev->dev,
-	       "%s: %s\n"
+	pci_err(dev, "%s\n"
 	       "Please send the output of lspci -vv, this\n"
 	       "message (0x%04x,0x%04x,0x%04x,0x%04x), the\n"
 	       "manufacturer and name of serial board or\n"
 	       "modem board to <linux-serial@vger.kernel.org>.\n",
-	       pci_name(dev), str, dev->vendor, dev->device,
+	       str, dev->vendor, dev->device,
 	       dev->subsystem_vendor, dev->subsystem_device);
 }
 
@@ -238,7 +237,7 @@ static int pci_inteli960ni_init(struct pci_dev *dev)
 	/* is firmware started? */
 	pci_read_config_dword(dev, 0x44, &oldval);
 	if (oldval == 0x00001000L) { /* RESET value */
-		dev_dbg(&dev->dev, "Local i960 firmware missing\n");
+		pci_dbg(dev, "Local i960 firmware missing\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -588,9 +587,8 @@ static int pci_timedia_probe(struct pci_dev *dev)
 	 * (0,2,3,5,6: serial only -- 7,8,9: serial + parallel)
 	 */
 	if ((dev->subsystem_device & 0x00f0) >= 0x70) {
-		dev_info(&dev->dev,
-			"ignoring Timedia subdevice %04x for parport_serial\n",
-			dev->subsystem_device);
+		pci_info(dev, "ignoring Timedia subdevice %04x for parport_serial\n",
+			 dev->subsystem_device);
 		return -ENODEV;
 	}
 
@@ -827,8 +825,7 @@ static int pci_netmos_9900_numports(struct pci_dev *dev)
 		if (sub_serports > 0)
 			return sub_serports;
 
-		dev_err(&dev->dev,
-			"NetMos/Mostech serial driver ignoring port on ambiguous config.\n");
+		pci_err(dev, "NetMos/Mostech serial driver ignoring port on ambiguous config.\n");
 		return 0;
 	}
 
@@ -927,7 +924,7 @@ static int pci_ite887x_init(struct pci_dev *dev)
 	}
 
 	if (i == ARRAY_SIZE(inta_addr)) {
-		dev_err(&dev->dev, "ite887x: could not find iobase\n");
+		pci_err(dev, "could not find iobase\n");
 		return -ENODEV;
 	}
 
@@ -1022,9 +1019,7 @@ static int pci_endrun_init(struct pci_dev *dev)
 	/* EndRun device */
 	if (deviceID == 0x07000200) {
 		number_uarts = ioread8(p + 4);
-		dev_dbg(&dev->dev,
-			"%d ports detected on EndRun PCI Express device\n",
-			number_uarts);
+		pci_dbg(dev, "%d ports detected on EndRun PCI Express device\n", number_uarts);
 	}
 	pci_iounmap(dev, p);
 	return number_uarts;
@@ -1054,9 +1049,7 @@ static int pci_oxsemi_tornado_init(struct pci_dev *dev)
 	/* Tornado device */
 	if (deviceID == 0x07000200) {
 		number_uarts = ioread8(p + 4);
-		dev_dbg(&dev->dev,
-			"%d ports detected on Oxford PCI Express device\n",
-			number_uarts);
+		pci_dbg(dev, "%d ports detected on Oxford PCI Express device\n", number_uarts);
 	}
 	pci_iounmap(dev, p);
 	return number_uarts;
@@ -1116,15 +1109,15 @@ static struct quatech_feature quatech_cards[] = {
 	{ 0, }
 };
 
-static int pci_quatech_amcc(u16 devid)
+static int pci_quatech_amcc(struct pci_dev *dev)
 {
 	struct quatech_feature *qf = &quatech_cards[0];
 	while (qf->devid) {
-		if (qf->devid == devid)
+		if (qf->devid == dev->device)
 			return qf->amcc;
 		qf++;
 	}
-	pr_err("quatech: unknown port type '0x%04X'.\n", devid);
+	pci_err(dev, "unknown port type '0x%04X'.\n", dev->device);
 	return 0;
 };
 
@@ -1287,7 +1280,7 @@ static int pci_quatech_rs422(struct uart_8250_port *port)
 
 static int pci_quatech_init(struct pci_dev *dev)
 {
-	if (pci_quatech_amcc(dev->device)) {
+	if (pci_quatech_amcc(dev)) {
 		unsigned long base = pci_resource_start(dev, 0);
 		if (base) {
 			u32 tmp;
@@ -1311,7 +1304,7 @@ static int pci_quatech_setup(struct serial_private *priv,
 	port->port.uartclk = pci_quatech_clock(port);
 	/* For now just warn about RS422 */
 	if (pci_quatech_rs422(port))
-		pr_warn("quatech: software control of RS422 features not currently supported.\n");
+		pci_warn(priv->dev, "software control of RS422 features not currently supported.\n");
 	return pci_default_setup(priv, board, port, idx);
 }
 
@@ -1525,7 +1518,7 @@ static int pci_fintek_setup(struct serial_private *priv,
 	/* Get the io address from configuration space */
 	pci_read_config_word(pdev, config_base + 4, &iobase);
 
-	dev_dbg(&pdev->dev, "%s: idx=%d iobase=0x%x", __func__, idx, iobase);
+	pci_dbg(pdev, "idx=%d iobase=0x%x", idx, iobase);
 
 	port->port.iotype = UPIO_PORT;
 	port->port.iobase = iobase;
@@ -1689,7 +1682,7 @@ static int skip_tx_en_setup(struct serial_private *priv,
 			struct uart_8250_port *port, int idx)
 {
 	port->port.quirks |= UPQ_NO_TXEN_TEST;
-	dev_dbg(&priv->dev->dev,
+	pci_dbg(priv->dev,
 		"serial8250: skipping TxEn test for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		priv->dev->vendor, priv->dev->device,
 		priv->dev->subsystem_vendor, priv->dev->subsystem_device);
@@ -4007,12 +4000,12 @@ pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 		uart.port.irq = 0;
 	} else {
 		if (pci_match_id(pci_use_msi, dev)) {
-			dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
+			pci_dbg(dev, "Using MSI(-X) interrupts\n");
 			pci_set_master(dev);
 			uart.port.flags &= ~UPF_SHARE_IRQ;
 			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
 		} else {
-			dev_dbg(&dev->dev, "Using legacy interrupts\n");
+			pci_dbg(dev, "Using legacy interrupts\n");
 			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);
 		}
 		if (rc < 0) {
@@ -4030,12 +4023,12 @@ pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 		if (quirk->setup(priv, board, &uart, i))
 			break;
 
-		dev_dbg(&dev->dev, "Setup PCI port: port %lx, irq %d, type %d\n",
+		pci_dbg(dev, "Setup PCI port: port %lx, irq %d, type %d\n",
 			uart.port.iobase, uart.port.irq, uart.port.iotype);
 
 		priv->line[i] = serial8250_register_8250_port(&uart);
 		if (priv->line[i] < 0) {
-			dev_err(&dev->dev,
+			pci_err(dev,
 				"Couldn't register serial port %lx, irq %d, type %d, error %d\n",
 				uart.port.iobase, uart.port.irq,
 				uart.port.iotype, priv->line[i]);
@@ -4131,8 +4124,7 @@ pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 	}
 
 	if (ent->driver_data >= ARRAY_SIZE(pci_boards)) {
-		dev_err(&dev->dev, "invalid driver_data: %ld\n",
-			ent->driver_data);
+		pci_err(dev, "invalid driver_data: %ld\n", ent->driver_data);
 		return -EINVAL;
 	}
 
@@ -4215,7 +4207,7 @@ static int pciserial_resume_one(struct device *dev)
 		err = pci_enable_device(pdev);
 		/* FIXME: We cannot simply error out here */
 		if (err)
-			dev_err(dev, "Unable to re-enable ports, trying to continue.\n");
+			pci_err(pdev, "Unable to re-enable ports, trying to continue.\n");
 		pciserial_resume_ports(priv);
 	}
 	return 0;
-- 
2.35.1



