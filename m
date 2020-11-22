Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFA72BC2AB
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 00:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgKUXkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 18:40:18 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60574 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgKUXkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 18:40:18 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 1C91429AB9; Sat, 21 Nov 2020 18:40:16 -0500 (EST)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Michael Ellerman" <mpe@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "Joshua Thompson" <funaho@jurai.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jiri Slaby" <jirislaby@kernel.org>, stable@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Message-Id: <0c0fe1e4f11ccec202d4df09ea7d9d98155d101a.1606001297.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2] m68k: Fix WARNING splat in pmac_zilog driver
Date:   Sun, 22 Nov 2020 10:28:17 +1100
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Don't add platform resources that won't be used. This avoids a
recently-added warning from the driver core, that can show up on a
multi-platform kernel when !MACH_IS_MAC.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at drivers/base/platform.c:224 platform_get_irq_optional+0x8e/0xce
0 is an invalid IRQ number
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 5.9.0-multi #1
Stack from 004b3f04:
        004b3f04 00462c2f 00462c2f 004b3f20 0002e128 004754db 004b6ad4 004b3f4c
        0002e19c 004754f7 000000e0 00285ba0 00000009 00000000 004b3f44 ffffffff
        004754db 004b3f64 004b3f74 00285ba0 004754f7 000000e0 00000009 004754db
        004fdf0c 005269e2 004fdf0c 00000000 004b3f88 00285cae 004b6964 00000000
        004fdf0c 004b3fac 0051cc68 004b6964 00000000 004b6964 00000200 00000000
        0051cc3e 0023c18a 004b3fc0 0051cd8a 004fdf0c 00000002 0052b43c 004b3fc8
Call Trace: [<0002e128>] __warn+0xa6/0xd6
 [<0002e19c>] warn_slowpath_fmt+0x44/0x76
 [<00285ba0>] platform_get_irq_optional+0x8e/0xce
 [<00285ba0>] platform_get_irq_optional+0x8e/0xce
 [<00285cae>] platform_get_irq+0x12/0x4c
 [<0051cc68>] pmz_init_port+0x2a/0xa6
 [<0051cc3e>] pmz_init_port+0x0/0xa6
 [<0023c18a>] strlen+0x0/0x22
 [<0051cd8a>] pmz_probe+0x34/0x88
 [<0051cde6>] pmz_console_init+0x8/0x28
 [<00511776>] console_init+0x1e/0x28
 [<0005a3bc>] printk+0x0/0x16
 [<0050a8a6>] start_kernel+0x368/0x4ce
 [<005094f8>] _sinittext+0x4f8/0xc48
random: get_random_bytes called from print_oops_end_marker+0x56/0x80 with crng_init=0
---[ end trace 392d8e82eed68d6c ]---

Commit a85a6c86c25b ("driver core: platform: Clarify that IRQ 0 is invalid"),
which introduced the WARNING, suggests that testing for irq == 0 is
undesirable. Instead of that comparison, just test for resource existence.

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Joshua Thompson <funaho@jurai.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org # v5.8+
References: commit a85a6c86c25b ("driver core: platform: Clarify that IRQ 0 is invalid")
Reported-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Changed since v1:
 - Add a comment to explain the need for the global structs.
 - Expand the commit log to better explain the intention of the patch.
---
 arch/m68k/mac/config.c          | 17 +++++++++--------
 drivers/tty/serial/pmac_zilog.c | 14 +++++++++-----
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 0ac53d87493c..2bea1799b8de 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -777,16 +777,12 @@ static struct resource scc_b_rsrcs[] = {
 struct platform_device scc_a_pdev = {
 	.name           = "scc",
 	.id             = 0,
-	.num_resources  = ARRAY_SIZE(scc_a_rsrcs),
-	.resource       = scc_a_rsrcs,
 };
 EXPORT_SYMBOL(scc_a_pdev);
 
 struct platform_device scc_b_pdev = {
 	.name           = "scc",
 	.id             = 1,
-	.num_resources  = ARRAY_SIZE(scc_b_rsrcs),
-	.resource       = scc_b_rsrcs,
 };
 EXPORT_SYMBOL(scc_b_pdev);
 
@@ -813,10 +809,15 @@ static void __init mac_identify(void)
 
 	/* Set up serial port resources for the console initcall. */
 
-	scc_a_rsrcs[0].start = (resource_size_t) mac_bi_data.sccbase + 2;
-	scc_a_rsrcs[0].end   = scc_a_rsrcs[0].start;
-	scc_b_rsrcs[0].start = (resource_size_t) mac_bi_data.sccbase;
-	scc_b_rsrcs[0].end   = scc_b_rsrcs[0].start;
+	scc_a_rsrcs[0].start     = (resource_size_t)mac_bi_data.sccbase + 2;
+	scc_a_rsrcs[0].end       = scc_a_rsrcs[0].start;
+	scc_a_pdev.num_resources = ARRAY_SIZE(scc_a_rsrcs);
+	scc_a_pdev.resource      = scc_a_rsrcs;
+
+	scc_b_rsrcs[0].start     = (resource_size_t)mac_bi_data.sccbase;
+	scc_b_rsrcs[0].end       = scc_b_rsrcs[0].start;
+	scc_b_pdev.num_resources = ARRAY_SIZE(scc_b_rsrcs);
+	scc_b_pdev.resource      = scc_b_rsrcs;
 
 	switch (macintosh_config->scc_type) {
 	case MAC_SCC_PSC:
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 96e7aa479961..216b75ef5048 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1693,22 +1693,26 @@ static int __init pmz_probe(void)
 
 #else
 
+/* On PCI PowerMacs, pmz_probe() does an explicit search of the OpenFirmware
+ * tree to obtain the device_nodes needed to start the console before the
+ * macio driver. On Macs without OpenFirmware, global platform_devices take
+ * the place of those device_nodes.
+ */
 extern struct platform_device scc_a_pdev, scc_b_pdev;
 
 static int __init pmz_init_port(struct uart_pmac_port *uap)
 {
-	struct resource *r_ports;
-	int irq;
+	struct resource *r_ports, *r_irq;
 
 	r_ports = platform_get_resource(uap->pdev, IORESOURCE_MEM, 0);
-	irq = platform_get_irq(uap->pdev, 0);
-	if (!r_ports || irq <= 0)
+	r_irq = platform_get_resource(uap->pdev, IORESOURCE_IRQ, 0);
+	if (!r_ports || !r_irq)
 		return -ENODEV;
 
 	uap->port.mapbase  = r_ports->start;
 	uap->port.membase  = (unsigned char __iomem *) r_ports->start;
 	uap->port.iotype   = UPIO_MEM;
-	uap->port.irq      = irq;
+	uap->port.irq      = r_irq->start;
 	uap->port.uartclk  = ZS_CLOCK;
 	uap->port.fifosize = 1;
 	uap->port.ops      = &pmz_pops;
-- 
2.26.2

