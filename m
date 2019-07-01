Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D815C06D
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfGAPjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:39:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43931 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728248AbfGAPjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 11:39:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BB73621F48;
        Mon,  1 Jul 2019 11:39:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Jul 2019 11:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SkEsKY
        YK4Za89MaNYHDUIglLVMM8ya/QZ2oVDecYYIY=; b=GjM7fpQfFQMnmpD6xCSXZy
        xji1r+4rO31In/AduYym5jd3PfjhvPyiS988Yg0bpTH2A4CMNR6pCNNBo2xMOgt4
        uF8oS/im/UBOK7gu6txzJNnhi9B+MBxsPzvYDQU4a1ZbC3AmX1MnSjhCt3MAlrHk
        uH3b5spbvPtBV0j1wal03A/NZjF7/tBXB+3WD1jVw/z6wmvCkc5ftO3whadIhPOF
        zhKCj18Kcci/f1cAt8qeMfwS1qslVucQZn/wM/CBuO9SN+Icmg63cV0a6NcYeb1/
        yAwiUIbAhMTWyYONsl5jrAl0QkNc6Rz5Ij9rtvYNVO8Yq5BysOlD/M8M75N9lt4A
        ==
X-ME-Sender: <xms:RykaXS1TuWhvJGfiJTCCGr1iwmJ8265dYZVknGwYWudcGTvsLvMBIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SCkaXWdvOS2wYc-rP9TgrM0VqNBwIgwVogW2KAO9C7QNkwuCtcBsIg>
    <xmx:SCkaXUK4NXzWbbZ_vI7PjTIRKWT771gmmthOdpQMnu0ydxUNTppENg>
    <xmx:SCkaXcF2OUN1qmTb3NO44YmyROrYuB7S2Xo7yESAFhuF41mqmKDzlA>
    <xmx:SCkaXQFLX7MzjJp-04MvmEvG_01XczyLUCWICmXlhy29CWr2fUMglg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2B07380076;
        Mon,  1 Jul 2019 11:39:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] irqchip/mips-gic: Use the correct local interrupt map" failed to apply to 4.14-stable tree
To:     paul.burton@mips.com, ayan@wavecomp.com, jason@lakedaemon.net,
        marc.zyngier@arm.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 17:39:25 +0200
Message-ID: <1561995565150105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d4d367d0e9ffab4d64a3436256a6a052dc1195d Mon Sep 17 00:00:00 2001
From: Paul Burton <paul.burton@mips.com>
Date: Wed, 5 Jun 2019 09:34:10 +0100
Subject: [PATCH] irqchip/mips-gic: Use the correct local interrupt map
 registers

The MIPS GIC contains a block of registers used to map local interrupts
to a particular CPU interrupt pin. Since these registers are found at a
consecutive range of addresses we access them using an index, via the
(read|write)_gic_v[lo]_map accessor functions. We currently use values
from enum mips_gic_local_interrupt as those indices.

Unfortunately whilst enum mips_gic_local_interrupt provides the correct
offsets for bits in the pending & mask registers, the ordering of the
map registers is subtly different... Compared with the ordering of
pending & mask bits, the map registers move the FDC from the end of the
list to index 3 after the timer interrupt. As a result the performance
counter & software interrupts are therefore at indices 4-6 rather than
indices 3-5.

Notably this causes problems with performance counter interrupts being
incorrectly mapped on some systems, and presumably will also cause
problems for FDC interrupts.

Introduce a function to map from enum mips_gic_local_interrupt to the
index of the corresponding map register, and use it to ensure we access
the map registers for the correct interrupts.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: a0dc5cb5e31b ("irqchip: mips-gic: Simplify gic_local_irq_domain_map()")
Fixes: da61fcf9d62a ("irqchip: mips-gic: Use irq_cpu_online to (un)mask all-VP(E) IRQs")
Reported-and-tested-by: Archer Yan <ayan@wavecomp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

diff --git a/arch/mips/include/asm/mips-gic.h b/arch/mips/include/asm/mips-gic.h
index 558059a8f218..0277b56157af 100644
--- a/arch/mips/include/asm/mips-gic.h
+++ b/arch/mips/include/asm/mips-gic.h
@@ -314,6 +314,36 @@ static inline bool mips_gic_present(void)
 	return IS_ENABLED(CONFIG_MIPS_GIC) && mips_gic_base;
 }
 
+/**
+ * mips_gic_vx_map_reg() - Return GIC_Vx_<intr>_MAP register offset
+ * @intr: A GIC local interrupt
+ *
+ * Determine the index of the GIC_VL_<intr>_MAP or GIC_VO_<intr>_MAP register
+ * within the block of GIC map registers. This is almost the same as the order
+ * of interrupts in the pending & mask registers, as used by enum
+ * mips_gic_local_interrupt, but moves the FDC interrupt & thus offsets the
+ * interrupts after it...
+ *
+ * Return: The map register index corresponding to @intr.
+ *
+ * The return value is suitable for use with the (read|write)_gic_v[lo]_map
+ * accessor functions.
+ */
+static inline unsigned int
+mips_gic_vx_map_reg(enum mips_gic_local_interrupt intr)
+{
+	/* WD, Compare & Timer are 1:1 */
+	if (intr <= GIC_LOCAL_INT_TIMER)
+		return intr;
+
+	/* FDC moves to after Timer... */
+	if (intr == GIC_LOCAL_INT_FDC)
+		return GIC_LOCAL_INT_TIMER + 1;
+
+	/* As a result everything else is offset by 1 */
+	return intr + 1;
+}
+
 /**
  * gic_get_c0_compare_int() - Return cp0 count/compare interrupt virq
  *
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index d32268cc1174..f3985469c221 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -388,7 +388,7 @@ static void gic_all_vpes_irq_cpu_online(struct irq_data *d)
 	intr = GIC_HWIRQ_TO_LOCAL(d->hwirq);
 	cd = irq_data_get_irq_chip_data(d);
 
-	write_gic_vl_map(intr, cd->map);
+	write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
 	if (cd->mask)
 		write_gic_vl_smask(BIT(intr));
 }
@@ -517,7 +517,7 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
-		write_gic_vo_map(intr, map);
+		write_gic_vo_map(mips_gic_vx_map_reg(intr), map);
 	}
 	spin_unlock_irqrestore(&gic_lock, flags);
 

