Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B261E3E804A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhHJRr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235125AbhHJRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13CA6124F;
        Tue, 10 Aug 2021 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617218;
        bh=6UZ8UDbE+gtZ419+958w1Ct+az9EJtjv+tl1F1V8R0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcLUqEtM79AC0hLmbrjNCqKE8EhFBL5dST7+8vnK6bqZ8BH81764jIeElvyO+dOC+
         X5t/MHOMiO5x2YlQK5CV+8FIngMDBGah36vA5IaOjJ+qUuD4bSP+0DZ7X/snjFdI1B
         ZSEGnUS1DnbHPIA42yzQNehmRt0eK6cbGntoaLa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.10 097/135] MIPS: Malta: Do not byte-swap accesses to the CBUS UART
Date:   Tue, 10 Aug 2021 19:30:31 +0200
Message-Id: <20210810172959.062866669@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 9a936d6c3d3d6c33ecbadf72dccdb567b5cd3c72 upstream.

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

Fixes: e7c4782f92fc ("[MIPS] Put an end to <asm/serial.h>'s long and annyoing existence")
Cc: stable@vger.kernel.org # v2.6.23+
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2106260524430.37803@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mti-malta/malta-platform.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/mti-malta/malta-platform.c
+++ b/arch/mips/mti-malta/malta-platform.c
@@ -47,7 +47,8 @@ static struct plat_serial8250_port uart8
 		.mapbase	= 0x1f000900,	/* The CBUS UART */
 		.irq		= MIPS_CPU_IRQ_BASE + MIPSCPU_INT_MB2,
 		.uartclk	= 3686400,	/* Twice the usual clk! */
-		.iotype		= UPIO_MEM32,
+		.iotype		= IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) ?
+				  UPIO_MEM32BE : UPIO_MEM32,
 		.flags		= CBUS_UART_FLAGS,
 		.regshift	= 3,
 	},


