Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACE350571D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbiDRNmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243531AbiDRNlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:41:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7852F2FFD6;
        Mon, 18 Apr 2022 05:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9F2B80D9C;
        Mon, 18 Apr 2022 12:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A380C385A8;
        Mon, 18 Apr 2022 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286756;
        bh=Uhtkhwp0emFVkysSAJut3l/iaBX+S1tpfv+2mxEbLko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpMq9A8y9Mj08NY2LtwWta7pYV5rkXdppYVMi6OK+x87hjYL1XqSk9NiOWj3DWnBW
         YwX9HEXppeB2cQVQDS/YcJCccx1tD2tjS/KmCPtl9QV3SSACBfzwG4mLr0NMPU2h3a
         U6Q3W6zXnq5EhsSXrFmYcqseFkf9PdFE7fuVwpmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 235/284] parisc: Fix CPU affinity for Lasi, WAX and Dino chips
Date:   Mon, 18 Apr 2022 14:13:36 +0200
Message-Id: <20220418121218.394670409@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 939fc856676c266c3bc347c1c1661872a3725c0f ]

Add the missing logic to allow Lasi, WAX and Dino to set the
CPU affinity. This fixes IRQ migration to other CPUs when a
CPU is shutdown which currently holds the IRQs for one of those
chips.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/dino.c | 41 +++++++++++++++++++++++++++++++++--------
 drivers/parisc/gsc.c  | 31 +++++++++++++++++++++++++++++++
 drivers/parisc/gsc.h  |  1 +
 drivers/parisc/lasi.c |  7 +++----
 drivers/parisc/wax.c  |  7 +++----
 5 files changed, 71 insertions(+), 16 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index c11515bdac83..4cc84c3b7602 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -144,9 +144,8 @@ struct dino_device
 {
 	struct pci_hba_data	hba;	/* 'C' inheritance - must be first */
 	spinlock_t		dinosaur_pen;
-	unsigned long		txn_addr; /* EIR addr to generate interrupt */ 
-	u32			txn_data; /* EIR data assign to each dino */ 
 	u32 			imr;	  /* IRQ's which are enabled */ 
+	struct gsc_irq		gsc_irq;
 	int			global_irq[DINO_LOCAL_IRQS]; /* map IMR bit to global irq */
 #ifdef DINO_DEBUG
 	unsigned int		dino_irr0; /* save most recent IRQ line stat */
@@ -343,14 +342,43 @@ static void dino_unmask_irq(struct irq_data *d)
 	if (tmp & DINO_MASK_IRQ(local_irq)) {
 		DBG(KERN_WARNING "%s(): IRQ asserted! (ILR 0x%x)\n",
 				__func__, tmp);
-		gsc_writel(dino_dev->txn_data, dino_dev->txn_addr);
+		gsc_writel(dino_dev->gsc_irq.txn_data, dino_dev->gsc_irq.txn_addr);
 	}
 }
 
+#ifdef CONFIG_SMP
+static int dino_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct dino_device *dino_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+	u32 eim;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	dino_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
+	__raw_writel(eim, dino_dev->hba.base_addr+DINO_IAR0);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
 static struct irq_chip dino_interrupt_type = {
 	.name		= "GSC-PCI",
 	.irq_unmask	= dino_unmask_irq,
 	.irq_mask	= dino_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = dino_set_affinity_irq,
+#endif
 };
 
 
@@ -811,7 +839,6 @@ static int __init dino_common_init(struct parisc_device *dev,
 {
 	int status;
 	u32 eim;
-	struct gsc_irq gsc_irq;
 	struct resource *res;
 
 	pcibios_register_hba(&dino_dev->hba);
@@ -826,10 +853,8 @@ static int __init dino_common_init(struct parisc_device *dev,
 	**   still only has 11 IRQ input lines - just map some of them
 	**   to a different processor.
 	*/
-	dev->irq = gsc_alloc_irq(&gsc_irq);
-	dino_dev->txn_addr = gsc_irq.txn_addr;
-	dino_dev->txn_data = gsc_irq.txn_data;
-	eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	dev->irq = gsc_alloc_irq(&dino_dev->gsc_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
 
 	/* 
 	** Dino needs a PA "IRQ" to get a processor's attention.
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index 1bab5a2cd359..a0cae6194591 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -139,10 +139,41 @@ static void gsc_asic_unmask_irq(struct irq_data *d)
 	 */
 }
 
+#ifdef CONFIG_SMP
+static int gsc_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct gsc_asic *gsc_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	gsc_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
+
+	/* switch IRQ's for devices below LASI/WAX to other CPU */
+	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
+
 static struct irq_chip gsc_asic_interrupt_type = {
 	.name		=	"GSC-ASIC",
 	.irq_unmask	=	gsc_asic_unmask_irq,
 	.irq_mask	=	gsc_asic_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity =	gsc_set_affinity_irq,
+#endif
 };
 
 int gsc_assign_irq(struct irq_chip *type, void *data)
diff --git a/drivers/parisc/gsc.h b/drivers/parisc/gsc.h
index b9d7bfb68e24..9a364a4d09a5 100644
--- a/drivers/parisc/gsc.h
+++ b/drivers/parisc/gsc.h
@@ -32,6 +32,7 @@ struct gsc_asic {
 	int version;
 	int type;
 	int eim;
+	struct gsc_irq gsc_irq;
 	int global_irq[32];
 };
 
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index 4c9225431500..07ac0b8ee4fe 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -167,7 +167,6 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 {
 	extern void (*chassis_power_off)(void);
 	struct gsc_asic *lasi;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	lasi = kzalloc(sizeof(*lasi), GFP_KERNEL);
@@ -189,7 +188,7 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 	lasi_init_irq(lasi);
 
 	/* the IRQ lasi should use */
-	dev->irq = gsc_alloc_irq(&gsc_irq);
+	dev->irq = gsc_alloc_irq(&lasi->gsc_irq);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -197,9 +196,9 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	lasi->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	lasi->eim = ((u32) lasi->gsc_irq.txn_addr) | lasi->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
+	ret = request_irq(lasi->gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
 	if (ret < 0) {
 		kfree(lasi);
 		return ret;
diff --git a/drivers/parisc/wax.c b/drivers/parisc/wax.c
index 6a3e40702b3b..5c42bfa83398 100644
--- a/drivers/parisc/wax.c
+++ b/drivers/parisc/wax.c
@@ -72,7 +72,6 @@ static int __init wax_init_chip(struct parisc_device *dev)
 {
 	struct gsc_asic *wax;
 	struct parisc_device *parent;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	wax = kzalloc(sizeof(*wax), GFP_KERNEL);
@@ -89,7 +88,7 @@ static int __init wax_init_chip(struct parisc_device *dev)
 	wax_init_irq(wax);
 
 	/* the IRQ wax should use */
-	dev->irq = gsc_claim_irq(&gsc_irq, WAX_GSC_IRQ);
+	dev->irq = gsc_claim_irq(&wax->gsc_irq, WAX_GSC_IRQ);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -97,9 +96,9 @@ static int __init wax_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	wax->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	wax->eim = ((u32) wax->gsc_irq.txn_addr) | wax->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
+	ret = request_irq(wax->gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
 	if (ret < 0) {
 		kfree(wax);
 		return ret;
-- 
2.35.1



