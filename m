Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB911AF12
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfLKPKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbfLKPKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A7582173E;
        Wed, 11 Dec 2019 15:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077045;
        bh=hHswzUoJBI7sw/V2s28kacVYKh5Hk9zVtWzcTVL8L1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYqSnbYKs2cRH0U6+0nqLQqd8cwwmpjcb13aCj7aLbWorledwMS9kaDSw7XDQmySt
         PjtZWeRIOQ0gCcg19o/+e8OKZY1GzXgCoMOEuslRYWP0W6MHl0HsyN5Zg4Gh+sQiXk
         cOgJRIYgNQB4GM+NYY6d7XQoyovNi+jBgCnKYFik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Je Yen Tam <je.yen.tam@ni.com>
Subject: [PATCH 5.4 89/92] Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"
Date:   Wed, 11 Dec 2019 16:06:20 +0100
Message-Id: <20191211150302.547979951@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Je Yen Tam <je.yen.tam@ni.com>

commit 27ed14d0ecb38516b6f3c6fdcd62c25c9454f979 upstream.

This reverts commit fdc2de87124f5183a98ea7eced1f76dbdba22951 ("serial/8250:
Add support for NI-Serial PXI/PXIe+485 devices").

The commit fdc2de87124f ("serial/8250: Add support for NI-Serial
PXI/PXIe+485 devices") introduced a breakage on NI-Serial PXI(e)-RS485
devices, RS-232 variants have no issue. The Linux system can enumerate the
NI-Serial PXI(e)-RS485 devices, but it broke the R/W operation on the
ports.

However, the implementation is working on the NI internal Linux RT kernel
but it does not work in the Linux main tree kernel. This is only affecting
NI products, specifically the RS-485 variants. Reverting the upstream
until a proper implementation that can apply to both NI internal Linux
kernel and Linux mainline kernel is figured out.

Signed-off-by: Je Yen Tam <je.yen.tam@ni.com>
Fixes: fdc2de87124f ("serial/8250: Add support for NI-Serial PXI/PXIe+485 devices")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191127075301.9866-1-je.yen.tam@ni.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |  292 -------------------------------------
 1 file changed, 4 insertions(+), 288 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -745,16 +745,8 @@ static int pci_ni8430_init(struct pci_de
 }
 
 /* UART Port Control Register */
-#define NI16550_PCR_OFFSET	0x0f
-#define NI16550_PCR_RS422	0x00
-#define NI16550_PCR_ECHO_RS485	0x01
-#define NI16550_PCR_DTR_RS485	0x02
-#define NI16550_PCR_AUTO_RS485	0x03
-#define NI16550_PCR_WIRE_MODE_MASK	0x03
-#define NI16550_PCR_TXVR_ENABLE_BIT	BIT(3)
-#define NI16550_PCR_RS485_TERMINATION_BIT	BIT(6)
-#define NI16550_ACR_DTR_AUTO_DTR	(0x2 << 3)
-#define NI16550_ACR_DTR_MANUAL_DTR	(0x0 << 3)
+#define NI8430_PORTCON	0x0f
+#define NI8430_PORTCON_TXVR_ENABLE	(1 << 3)
 
 static int
 pci_ni8430_setup(struct serial_private *priv,
@@ -776,117 +768,14 @@ pci_ni8430_setup(struct serial_private *
 		return -ENOMEM;
 
 	/* enable the transceiver */
-	writeb(readb(p + offset + NI16550_PCR_OFFSET) | NI16550_PCR_TXVR_ENABLE_BIT,
-	       p + offset + NI16550_PCR_OFFSET);
+	writeb(readb(p + offset + NI8430_PORTCON) | NI8430_PORTCON_TXVR_ENABLE,
+	       p + offset + NI8430_PORTCON);
 
 	iounmap(p);
 
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
-static int pci_ni8431_config_rs485(struct uart_port *port,
-	struct serial_rs485 *rs485)
-{
-	u8 pcr, acr;
-	struct uart_8250_port *up;
-
-	up = container_of(port, struct uart_8250_port, port);
-	acr = up->acr;
-	pcr = port->serial_in(port, NI16550_PCR_OFFSET);
-	pcr &= ~NI16550_PCR_WIRE_MODE_MASK;
-
-	if (rs485->flags & SER_RS485_ENABLED) {
-		/* RS-485 */
-		if ((rs485->flags & SER_RS485_RX_DURING_TX) &&
-			(rs485->flags & SER_RS485_RTS_ON_SEND)) {
-			dev_dbg(port->dev, "Invalid 2-wire mode\n");
-			return -EINVAL;
-		}
-
-		if (rs485->flags & SER_RS485_RX_DURING_TX) {
-			/* Echo */
-			dev_vdbg(port->dev, "2-wire DTR with echo\n");
-			pcr |= NI16550_PCR_ECHO_RS485;
-			acr |= NI16550_ACR_DTR_MANUAL_DTR;
-		} else {
-			/* Auto or DTR */
-			if (rs485->flags & SER_RS485_RTS_ON_SEND) {
-				/* Auto */
-				dev_vdbg(port->dev, "2-wire Auto\n");
-				pcr |= NI16550_PCR_AUTO_RS485;
-				acr |= NI16550_ACR_DTR_AUTO_DTR;
-			} else {
-				/* DTR-controlled */
-				/* No Echo */
-				dev_vdbg(port->dev, "2-wire DTR no echo\n");
-				pcr |= NI16550_PCR_DTR_RS485;
-				acr |= NI16550_ACR_DTR_MANUAL_DTR;
-			}
-		}
-	} else {
-		/* RS-422 */
-		dev_vdbg(port->dev, "4-wire\n");
-		pcr |= NI16550_PCR_RS422;
-		acr |= NI16550_ACR_DTR_MANUAL_DTR;
-	}
-
-	dev_dbg(port->dev, "write pcr: 0x%08x\n", pcr);
-	port->serial_out(port, NI16550_PCR_OFFSET, pcr);
-
-	up->acr = acr;
-	port->serial_out(port, UART_SCR, UART_ACR);
-	port->serial_out(port, UART_ICR, up->acr);
-
-	/* Update the cache. */
-	port->rs485 = *rs485;
-
-	return 0;
-}
-
-static int pci_ni8431_setup(struct serial_private *priv,
-		 const struct pciserial_board *board,
-		 struct uart_8250_port *uart, int idx)
-{
-	u8 pcr, acr;
-	struct pci_dev *dev = priv->dev;
-	void __iomem *addr;
-	unsigned int bar, offset = board->first_offset;
-
-	if (idx >= board->num_ports)
-		return 1;
-
-	bar = FL_GET_BASE(board->flags);
-	offset += idx * board->uart_offset;
-
-	addr = pci_ioremap_bar(dev, bar);
-	if (!addr)
-		return -ENOMEM;
-
-	/* enable the transceiver */
-	writeb(readb(addr + NI16550_PCR_OFFSET) | NI16550_PCR_TXVR_ENABLE_BIT,
-		addr + NI16550_PCR_OFFSET);
-
-	pcr = readb(addr + NI16550_PCR_OFFSET);
-	pcr &= ~NI16550_PCR_WIRE_MODE_MASK;
-
-	/* set wire mode to default RS-422 */
-	pcr |= NI16550_PCR_RS422;
-	acr = NI16550_ACR_DTR_MANUAL_DTR;
-
-	/* write port configuration to register */
-	writeb(pcr, addr + NI16550_PCR_OFFSET);
-
-	/* access and write to UART acr register */
-	writeb(UART_ACR, addr + UART_SCR);
-	writeb(acr, addr + UART_ICR);
-
-	uart->port.rs485_config = &pci_ni8431_config_rs485;
-
-	iounmap(addr);
-
-	return setup_port(priv, uart, bar, offset, board->reg_shift);
-}
-
 static int pci_netmos_9900_setup(struct serial_private *priv,
 				const struct pciserial_board *board,
 				struct uart_8250_port *port, int idx)
@@ -2023,15 +1912,6 @@ pci_moxa_setup(struct serial_private *pr
 #define PCI_DEVICE_ID_ACCESIO_PCIE_COM_8SM	0x10E9
 #define PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4SM	0x11D8
 
-#define PCIE_DEVICE_ID_NI_PXIE8430_2328	0x74C2
-#define PCIE_DEVICE_ID_NI_PXIE8430_23216	0x74C1
-#define PCI_DEVICE_ID_NI_PXI8431_4852	0x7081
-#define PCI_DEVICE_ID_NI_PXI8431_4854	0x70DE
-#define PCI_DEVICE_ID_NI_PXI8431_4858	0x70E3
-#define PCI_DEVICE_ID_NI_PXI8433_4852	0x70E9
-#define PCI_DEVICE_ID_NI_PXI8433_4854	0x70ED
-#define PCIE_DEVICE_ID_NI_PXIE8431_4858	0x74C4
-#define PCIE_DEVICE_ID_NI_PXIE8431_48516	0x74C3
 
 #define	PCI_DEVICE_ID_MOXA_CP102E	0x1024
 #define	PCI_DEVICE_ID_MOXA_CP102EL	0x1025
@@ -2269,87 +2149,6 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_ni8430_setup,
 		.exit		= pci_ni8430_exit,
 	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCIE_DEVICE_ID_NI_PXIE8430_2328,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8430_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCIE_DEVICE_ID_NI_PXIE8430_23216,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8430_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCI_DEVICE_ID_NI_PXI8431_4852,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCI_DEVICE_ID_NI_PXI8431_4854,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCI_DEVICE_ID_NI_PXI8431_4858,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCI_DEVICE_ID_NI_PXI8433_4852,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCI_DEVICE_ID_NI_PXI8433_4854,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCIE_DEVICE_ID_NI_PXIE8431_4858,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_NI,
-		.device		= PCIE_DEVICE_ID_NI_PXIE8431_48516,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.init		= pci_ni8430_init,
-		.setup		= pci_ni8431_setup,
-		.exit		= pci_ni8430_exit,
-	},
 	/* Quatech */
 	{
 		.vendor		= PCI_VENDOR_ID_QUATECH,
@@ -3106,13 +2905,6 @@ enum pci_board_num_t {
 	pbn_ni8430_4,
 	pbn_ni8430_8,
 	pbn_ni8430_16,
-	pbn_ni8430_pxie_8,
-	pbn_ni8430_pxie_16,
-	pbn_ni8431_2,
-	pbn_ni8431_4,
-	pbn_ni8431_8,
-	pbn_ni8431_pxie_8,
-	pbn_ni8431_pxie_16,
 	pbn_ADDIDATA_PCIe_1_3906250,
 	pbn_ADDIDATA_PCIe_2_3906250,
 	pbn_ADDIDATA_PCIe_4_3906250,
@@ -3765,55 +3557,6 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 0x10,
 		.first_offset	= 0x800,
 	},
-	[pbn_ni8430_pxie_16] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 16,
-		.base_baud	= 3125000,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8430_pxie_8] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 8,
-		.base_baud	= 3125000,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8431_8] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 8,
-		.base_baud	= 3686400,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8431_4] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 4,
-		.base_baud	= 3686400,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8431_2] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 2,
-		.base_baud	= 3686400,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8431_pxie_16] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 16,
-		.base_baud	= 3125000,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
-	[pbn_ni8431_pxie_8] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 8,
-		.base_baud	= 3125000,
-		.uart_offset	= 0x10,
-		.first_offset	= 0x800,
-	},
 	/*
 	 * ADDI-DATA GmbH PCI-Express communication cards <info@addi-data.com>
 	 */
@@ -5567,33 +5310,6 @@ static const struct pci_device_id serial
 	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI8432_2324,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_ni8430_4 },
-	{	PCI_VENDOR_ID_NI, PCIE_DEVICE_ID_NI_PXIE8430_2328,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8430_pxie_8 },
-	{	PCI_VENDOR_ID_NI, PCIE_DEVICE_ID_NI_PXIE8430_23216,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8430_pxie_16 },
-	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8431_4852,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_2 },
-	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8431_4854,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_4 },
-	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8431_4858,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_8 },
-	{	PCI_VENDOR_ID_NI, PCIE_DEVICE_ID_NI_PXIE8431_4858,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_pxie_8 },
-	{	PCI_VENDOR_ID_NI, PCIE_DEVICE_ID_NI_PXIE8431_48516,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_pxie_16 },
-	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8433_4852,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_2 },
-	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8433_4854,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_ni8431_4 },
 
 	/*
 	 * MOXA


