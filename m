Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147E43B4C60
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 06:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhFZENj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Jun 2021 00:13:39 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60044 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhFZENh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 00:13:37 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3F9D29200BF; Sat, 26 Jun 2021 06:11:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3C9289200BC;
        Sat, 26 Jun 2021 06:11:13 +0200 (CEST)
Date:   Sat, 26 Jun 2021 06:11:13 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-serial@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/2] MIPS: Malta: Do not byte-swap accesses to the CBUS
 UART
In-Reply-To: <alpine.DEB.2.21.2106260509300.37803@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2106260524430.37803@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2106260509300.37803@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correct big-endian accesses to the CBUS UART, a Malta on-board discrete 
TI16C550C part wired directly to the system controller's device bus, and 
do not use byte swapping with the 32-bit accesses to the device.

The CBUS is used for devices such as the boot flash memory needed early 
on in system bootstrap even before PCI has been initialised.  Therefore 
it uses the system controller's device bus, which follows the endianness 
set with the CPU, which means no byte-swapping is ever required for data 
accesses to CBUS, unlike with PCI.

The CBUS UART uses the UPIO_MEM32 access method, that is the `readl' and 
`writel' MMIO accessors, which on the MIPS platform imply byte-swapping 
with PCI systems.  Consequently the wrong byte lane is accessed with the
big-endian configuration and the UART is not correctly accessed.

As it happens the UPIO_MEM32BE access method makes use of the `ioread32' 
and `iowrite32' MMIO accessors, which still use `readl' and `writel' 
respectively, however they byte-swap data passed, effectively cancelling 
swapping done with the accessors themselves and making it suitable for 
the CBUS UART.

Make the CBUS UART switch between UPIO_MEM32 and UPIO_MEM32BE then, 
based on the endianness selected.  With this change in place the device 
is correctly recognised with big-endian Malta at boot, along with the 
Super I/O devices behind PCI:

Serial: 8250/16550 driver, 5 ports, IRQ sharing enabled
printk: console [ttyS0] disabled
serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
printk: console [ttyS0] enabled
printk: bootconsole [uart8250] disabled
serial8250.0: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
serial8250.0: ttyS2 at MMIO 0x1f000900 (irq = 20, base_baud = 230400) is a 16550A

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: e7c4782f92fc ("[MIPS] Put an end to <asm/serial.h>'s long and annyoing existence")
Cc: stable@vger.kernel.org # v2.6.23+
---
Changes from v1:

- Remove console message duplicates from the commit description.
---
 arch/mips/mti-malta/malta-platform.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

linux-mips-malta-cbus-uart-be.diff
Index: linux-macro-ide-tty/arch/mips/mti-malta/malta-platform.c
===================================================================
--- linux-macro-ide-tty.orig/arch/mips/mti-malta/malta-platform.c
+++ linux-macro-ide-tty/arch/mips/mti-malta/malta-platform.c
@@ -48,7 +48,8 @@ static struct plat_serial8250_port uart8
 		.mapbase	= 0x1f000900,	/* The CBUS UART */
 		.irq		= MIPS_CPU_IRQ_BASE + MIPSCPU_INT_MB2,
 		.uartclk	= 3686400,	/* Twice the usual clk! */
-		.iotype		= UPIO_MEM32,
+		.iotype		= IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) ?
+				  UPIO_MEM32BE : UPIO_MEM32,
 		.flags		= CBUS_UART_FLAGS,
 		.regshift	= 3,
 	},
