Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EE66247F7
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiKJRJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiKJRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:09:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF154732B;
        Thu, 10 Nov 2022 09:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B41B82267;
        Thu, 10 Nov 2022 17:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7D9C433D6;
        Thu, 10 Nov 2022 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668100171;
        bh=ymP8kUFWnG37T98jd6OjvLLfds7KzHBNEncgfo23dMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEEckxgre2Di9N3kJuZN+I9IvtrwKCQuo3iPxEeLIHc9vEETZdNJSlE6SlSMxsOv6
         4WuklwFiEo+EqfFAaO5AjasJYSRDwL5Gpzt1NJeGtIiPz0MrhcFlbzR+3YZhCj0J5R
         R3UzTR3fjfys8ijSmUu2JEAENa1yWu0+a0p7FWGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.299
Date:   Thu, 10 Nov 2022 18:09:20 +0100
Message-Id: <166810015926136@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <16681001598861@kroah.com>
References: <16681001598861@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c1912ead188e..e3c5ad9500a1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 298
+SUBLEVEL = 299
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 1f54e4e98c1e..4f12847e765b 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -22,12 +22,6 @@
 #include <mach/memory.h>
 #endif
 
-/*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
 /* PAGE_OFFSET - the virtual address of the start of the kernel image */
 #define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index d4bae7d6e0d8..0276d3bd0e96 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -28,12 +28,6 @@
 #include <asm/page-def.h>
 #include <asm/sizes.h>
 
-/*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
 /*
  * Size of the PCI I/O space. This must remain a power of two so that
  * IO_SPACE_LIMIT acts as a mask for the low bits of I/O addresses.
diff --git a/arch/unicore32/include/asm/memory.h b/arch/unicore32/include/asm/memory.h
index 3bb0a29fd2d7..66bb9f6525c0 100644
--- a/arch/unicore32/include/asm/memory.h
+++ b/arch/unicore32/include/asm/memory.h
@@ -19,12 +19,6 @@
 #include <asm/sizes.h>
 #include <mach/memory.h>
 
-/*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
 /*
  * PAGE_OFFSET - the virtual address of the start of the kernel image
  * TASK_SIZE - the maximum size of a user space task.
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd1eb8600ccf..3dbbf4b00dba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -663,6 +663,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
+		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		/*
 		 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 21480a6b1adc..135c993e6768 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -758,8 +758,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 			   ctxt->mode, linear);
 }
 
-static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
-			     enum x86emul_mode mode)
+static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
 	ulong linear;
 	int rc;
@@ -769,41 +768,71 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, mode, &linear);
+	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
 }
 
+static inline int emulator_recalc_and_set_mode(struct x86_emulate_ctxt *ctxt)
+{
+	u64 efer;
+	struct desc_struct cs;
+	u16 selector;
+	u32 base3;
+
+	ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
+
+	if (!(ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PE)) {
+		/* Real mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_REAL;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (ctxt->eflags & X86_EFLAGS_VM) {
+		/* Protected/VM86 mode. cpu must not have long mode active */
+		if (efer & EFER_LMA)
+			return X86EMUL_UNHANDLEABLE;
+		ctxt->mode = X86EMUL_MODE_VM86;
+		return X86EMUL_CONTINUE;
+	}
+
+	if (!ctxt->ops->get_segment(ctxt, &selector, &cs, &base3, VCPU_SREG_CS))
+		return X86EMUL_UNHANDLEABLE;
+
+	if (efer & EFER_LMA) {
+		if (cs.l) {
+			/* Proper long mode */
+			ctxt->mode = X86EMUL_MODE_PROT64;
+		} else if (cs.d) {
+			/* 32 bit compatibility mode*/
+			ctxt->mode = X86EMUL_MODE_PROT32;
+		} else {
+			ctxt->mode = X86EMUL_MODE_PROT16;
+		}
+	} else {
+		/* Legacy 32 bit / 16 bit mode */
+		ctxt->mode = cs.d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
+	}
+
+	return X86EMUL_CONTINUE;
+}
+
 static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	return assign_eip(ctxt, dst, ctxt->mode);
+	return assign_eip(ctxt, dst);
 }
 
-static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
-			  const struct desc_struct *cs_desc)
+static int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
-	enum x86emul_mode mode = ctxt->mode;
-	int rc;
+	int rc = emulator_recalc_and_set_mode(ctxt);
 
-#ifdef CONFIG_X86_64
-	if (ctxt->mode >= X86EMUL_MODE_PROT16) {
-		if (cs_desc->l) {
-			u64 efer = 0;
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
 
-			ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-			if (efer & EFER_LMA)
-				mode = X86EMUL_MODE_PROT64;
-		} else
-			mode = X86EMUL_MODE_PROT32; /* temporary value */
-	}
-#endif
-	if (mode == X86EMUL_MODE_PROT16 || mode == X86EMUL_MODE_PROT32)
-		mode = cs_desc->d ? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
-	rc = assign_eip(ctxt, dst, mode);
-	if (rc == X86EMUL_CONTINUE)
-		ctxt->mode = mode;
-	return rc;
+	return assign_eip(ctxt, dst);
 }
 
 static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
@@ -2205,7 +2234,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2286,7 +2315,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_far(ctxt, eip, &new_desc);
+	rc = assign_eip_far(ctxt, eip);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2889,6 +2918,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;
@@ -3474,7 +3504,7 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	if (rc != X86EMUL_CONTINUE)
 		goto fail;
 
@@ -3621,11 +3651,25 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
 
 static int em_cr_write(struct x86_emulate_ctxt *ctxt)
 {
-	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
+	int cr_num = ctxt->modrm_reg;
+	int r;
+
+	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
 		return emulate_gp(ctxt, 0);
 
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
+
+	if (cr_num == 0) {
+		/*
+		 * CR0 write might have updated CR0.PE and/or CR0.PG
+		 * which can affect the cpu's execution mode.
+		 */
+		r = emulator_recalc_and_set_mode(ctxt);
+		if (r != X86EMUL_CONTINUE)
+			return r;
+	}
+
 	return X86EMUL_CONTINUE;
 }
 
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f8c6b898f637..cc7fbd3f81f7 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -298,6 +298,8 @@ static struct bfq_io_cq *bfq_bic_lookup(struct bfq_data *bfqd,
  */
 void bfq_schedule_dispatch(struct bfq_data *bfqd)
 {
+	lockdep_assert_held(&bfqd->lock);
+
 	if (bfqd->queued != 0) {
 		bfq_log(bfqd, "schedule dispatch");
 		blk_mq_run_hw_queues(bfqd->queue, true);
@@ -4584,8 +4586,8 @@ bfq_idle_slice_timer_body(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_bfqq_expire(bfqd, bfqq, true, reason);
 
 schedule_dispatch:
-	spin_unlock_irqrestore(&bfqd->lock, flags);
 	bfq_schedule_dispatch(bfqd);
+	spin_unlock_irqrestore(&bfqd->lock, flags);
 }
 
 /*
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 9968b074fa96..c72d3cf903f1 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -292,9 +292,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(inb(0x1F4) & 0x07, 0x1F4);
 
 	rt = inb(0x1F3);
-	rt &= 0x07 << (3 * adev->devno);
+	rt &= ~(0x07 << (3 * !adev->devno));
 	if (pio)
-		rt |= (1 + 3 * pio) << (3 * adev->devno);
+		rt |= (1 + 3 * pio) << (3 * !adev->devno);
+	outb(rt, 0x1F3);
 
 	udelay(100);
 	outb(inb(0x1F2) | 0x01, 0x1F2);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 24365601fbbf..ed981f5e29ae 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -532,7 +532,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index da526cc471cc..1f512f0d31a5 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -900,6 +900,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 56b54aab51f9..88d380e00b51 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -970,7 +970,7 @@ nj_release(struct tiger_hw *card)
 	}
 	if (card->irq > 0)
 		free_irq(card->irq, card);
-	if (card->isac.dch.dev.dev.class)
+	if (device_is_registered(&card->isac.dch.dev.dev))
 		mISDN_unregister_device(&card->isac.dch.dev);
 
 	for (i = 0; i < 2; i++) {
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index f5a06a6fb297..5cd53b2c47c7 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -242,11 +242,12 @@ mISDN_register_device(struct mISDNdevice *dev,
 	if (debug & DEBUG_CORE)
 		printk(KERN_DEBUG "mISDN_register %s %d\n",
 		       dev_name(&dev->dev), dev->id);
+	dev->dev.class = &mISDN_class;
+
 	err = create_stack(dev);
 	if (err)
 		goto error1;
 
-	dev->dev.class = &mISDN_class;
 	dev->dev.platform_data = dev;
 	dev->dev.parent = parent;
 	dev_set_drvdata(&dev->dev, dev);
@@ -258,8 +259,8 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 error3:
 	delete_stack(dev);
-	return err;
 error1:
+	put_device(&dev->dev);
 	return err;
 
 }
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 48a8aad47a74..98146e74bbdf 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6700,7 +6700,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 3032247c63a5..554c8f2b60b8 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -116,6 +116,8 @@ static irqreturn_t s5p_cec_irq_handler(int irq, void *priv)
 				dev_dbg(cec->dev, "Buffer overrun (worker did not process previous message)\n");
 			cec->rx = STATE_BUSY;
 			cec->msg.len = status >> 24;
+			if (cec->msg.len > CEC_MAX_MSG_SIZE)
+				cec->msg.len = CEC_MAX_MSG_SIZE;
 			cec->msg.rx_status = CEC_RX_STATUS_OK;
 			s5p_cec_get_rx_buf(cec, cec->msg.len,
 					cec->msg.msg);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index a5a83d86bb0f..dbd21f95a700 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -330,6 +330,17 @@ static struct mdio_driver dsa_loop_drv = {
 
 #define NUM_FIXED_PHYS	(DSA_LOOP_NUM_PORTS - 2)
 
+static void dsa_loop_phydevs_unregister(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FIXED_PHYS; i++)
+		if (!IS_ERR(phydevs[i])) {
+			fixed_phy_unregister(phydevs[i]);
+			phy_device_free(phydevs[i]);
+		}
+}
+
 static int __init dsa_loop_init(void)
 {
 	struct fixed_phy_status status = {
@@ -337,23 +348,23 @@ static int __init dsa_loop_init(void)
 		.speed = SPEED_100,
 		.duplex = DUPLEX_FULL,
 	};
-	unsigned int i;
+	unsigned int i, ret;
 
 	for (i = 0; i < NUM_FIXED_PHYS; i++)
 		phydevs[i] = fixed_phy_register(PHY_POLL, &status, -1, NULL);
 
-	return mdio_driver_register(&dsa_loop_drv);
+	ret = mdio_driver_register(&dsa_loop_drv);
+	if (ret)
+		dsa_loop_phydevs_unregister();
+
+	return ret;
 }
 module_init(dsa_loop_init);
 
 static void __exit dsa_loop_exit(void)
 {
-	unsigned int i;
-
 	mdio_driver_unregister(&dsa_loop_drv);
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i]))
-			fixed_phy_unregister(phydevs[i]);
+	dsa_loop_phydevs_unregister();
 }
 module_exit(dsa_loop_exit);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6f7ffd975631..c6fc77a211ea 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -582,7 +582,7 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 		dev_kfree_skb_any(skb);
 		if (net_ratelimit())
 			netdev_err(ndev, "Tx DMA memory map failed\n");
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
 
 	bdp->cbd_datlen = cpu_to_fec16(size);
@@ -644,7 +644,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			dev_kfree_skb_any(skb);
 			if (net_ratelimit())
 				netdev_err(ndev, "Tx DMA memory map failed\n");
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2911648d4669..7a813449d0d1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -378,7 +378,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		bus->reset(bus);
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-		if ((bus->phy_mask & (1 << i)) == 0) {
+		if ((bus->phy_mask & BIT(i)) == 0) {
 			struct phy_device *phydev;
 
 			phydev = mdiobus_scan(bus, i);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index ef72baf6dd96..b9561c48630e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -237,6 +237,10 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			  brcmf_fweh_event_name(event->code), event->code,
 			  event->emsg.ifidx, event->emsg.bsscfgidx,
 			  event->emsg.addr);
+		if (event->emsg.bsscfgidx >= BRCMF_MAX_IFS) {
+			brcmf_err("invalid bsscfg index: %u\n", event->emsg.bsscfgidx);
+			goto event_free;
+		}
 
 		/* convert event message */
 		emsg_be = &event->emsg;
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 3dbe209221e4..a3a465d8383b 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -151,10 +151,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_private *priv,
 			ret = -EREMOTEIO;
 		} else
 			ret = 0;
+	}
+
+	if (ret) {
 		kfree_skb(skb);
+		return ret;
 	}
 
-	return ret;
+	consume_skb(skb);
+	return 0;
 }
 
 static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,
diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 64b58455e620..f23a1e4d7e1e 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -108,11 +108,15 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 
 	ret = s3fwrn5_write(info, skb);
-	if (ret < 0)
+	if (ret < 0) {
 		kfree_skb(skb);
+		mutex_unlock(&info->mutex);
+		return ret;
+	}
 
+	consume_skb(skb);
 	mutex_unlock(&info->mutex);
-	return ret;
+	return 0;
 }
 
 static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 144c77dfe4b1..eb9137faccf7 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -889,6 +889,7 @@ int iosapic_serial_irq(struct parisc_device *dev)
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index a5c0ef1e7695..4d88cade46b0 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -105,7 +105,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 93cfbdada40f..6d761d2f9ddb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -597,6 +597,18 @@ unode_aux_to_inode_list(struct ulist_node *node)
 	return (struct extent_inode_elem *)(uintptr_t)node->aux;
 }
 
+static void free_leaf_list(struct ulist *ulist)
+{
+	struct ulist_node *node;
+	struct ulist_iterator uiter;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((node = ulist_next(ulist, &uiter)))
+		free_inode_elem_list(unode_aux_to_inode_list(node));
+
+	ulist_free(ulist);
+}
+
 /*
  * We maintain three seperate rbtrees: one for direct refs, one for
  * indirect refs which have a key, and one for indirect refs which do not
@@ -711,7 +723,11 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		cond_resched();
 	}
 out:
-	ulist_free(parents);
+	/*
+	 * We may have inode lists attached to refs in the parents ulist, so we
+	 * must free them before freeing the ulist and its refs.
+	 */
+	free_leaf_list(parents);
 	return ret;
 }
 
@@ -1361,24 +1377,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void free_leaf_list(struct ulist *blocks)
-{
-	struct ulist_node *node = NULL;
-	struct extent_inode_elem *eie;
-	struct ulist_iterator uiter;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((node = ulist_next(blocks, &uiter))) {
-		if (!node->aux)
-			continue;
-		eie = unode_aux_to_inode_list(node);
-		free_inode_elem_list(eie);
-		node->aux = 0;
-	}
-
-	ulist_free(blocks);
-}
-
 /*
  * Finds all leafs with a reference to the specified combination of bytenr and
  * offset. key_list_head will point to a list of corresponding keys (caller must
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index b6ce765aa7f3..5909d75570b0 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -57,7 +57,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 15db02462141..b3bbe6de8aa0 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -18,7 +18,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index eb72cf280546..1eb02cb46cfd 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -249,8 +249,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -283,8 +285,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	}
 
 	ret = remove_extent_item(root, nodesize, nodesize);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return -EINVAL;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -346,8 +350,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -379,8 +385,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = add_tree_ref(root, nodesize, nodesize, 0,
 			BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
@@ -418,8 +426,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = remove_extent_ref(root, nodesize, nodesize, 0,
 				BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5849bf2c41ad..39a573127e52 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -450,7 +450,8 @@ int ext4_ext_migrate(struct inode *inode)
 	 * already is extent-based, error out.
 	 */
 	if (!ext4_has_feature_extents(inode->i_sb) ||
-	    (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
+	    ext4_has_inline_data(inode))
 		return -EINVAL;
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index c7672c89b967..da2cde96e68a 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -326,6 +326,7 @@ int nfs40_init_client(struct nfs_client *clp)
 	ret = nfs4_setup_slot_table(tbl, NFS4_MAX_SLOT_TABLE,
 					"NFSv4.0 transport Slot table");
 	if (ret) {
+		nfs4_shutdown_slot_table(tbl);
 		kfree(tbl);
 		return ret;
 	}
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index c0987557d4ab..0c124465d4e5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1674,6 +1674,7 @@ static void nfs4_state_mark_reclaim_helper(struct nfs_client *clp,
 
 static void nfs4_state_start_reclaim_reboot(struct nfs_client *clp)
 {
+	set_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state);
 	/* Mark all delegations for reclaim */
 	nfs_delegation_mark_reclaim(clp);
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_reboot);
@@ -2507,6 +2508,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			if (status < 0)
 				goto out_error;
 			nfs4_state_end_reclaim_reboot(clp);
+			continue;
 		}
 
 		/* Detect expired delegations... */
diff --git a/include/linux/bits.h b/include/linux/bits.h
index 2b7b532c1d51..669d69441a62 100644
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -1,13 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __LINUX_BITS_H
 #define __LINUX_BITS_H
+
+#include <linux/const.h>
 #include <asm/bitsperlong.h>
 
-#define BIT(nr)			(1UL << (nr))
-#define BIT_ULL(nr)		(1ULL << (nr))
-#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT(nr)			(UL(1) << (nr))
+#define BIT_ULL(nr)		(ULL(1) << (nr))
+#define BIT_MASK(nr)		(UL(1) << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BIT_ULL_MASK(nr)	(1ULL << ((nr) % BITS_PER_LONG_LONG))
+#define BIT_ULL_MASK(nr)	(ULL(1) << ((nr) % BITS_PER_LONG_LONG))
 #define BIT_ULL_WORD(nr)	((nr) / BITS_PER_LONG_LONG)
 #define BITS_PER_BYTE		8
 
@@ -17,10 +19,11 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #define GENMASK(h, l) \
-	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
+	(((~UL(0)) - (UL(1) << (l)) + 1) & \
+	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
 
 #define GENMASK_ULL(h, l) \
-	(((~0ULL) - (1ULL << (l)) + 1) & \
-	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
+	(((~ULL(0)) - (ULL(1) << (l)) + 1) & \
+	 (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
 
 #endif	/* __LINUX_BITS_H */
diff --git a/include/linux/const.h b/include/linux/const.h
new file mode 100644
index 000000000000..7b55a55f5911
--- /dev/null
+++ b/include/linux/const.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+#include <uapi/linux/const.h>
+
+#define UL(x)		(_UL(x))
+#define ULL(x)		(_ULL(x))
+
+#endif /* _LINUX_CONST_H */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2c63afd68978..8b25cd2bed40 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1607,7 +1607,7 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;
diff --git a/include/net/protocol.h b/include/net/protocol.h
index 4fc75f7ae23b..312a27393e0b 100644
--- a/include/net/protocol.h
+++ b/include/net/protocol.h
@@ -39,8 +39,6 @@
 
 /* This is used to register protocols. */
 struct net_protocol {
-	int			(*early_demux)(struct sk_buff *skb);
-	int			(*early_demux_handler)(struct sk_buff *skb);
 	int			(*handler)(struct sk_buff *skb);
 	void			(*err_handler)(struct sk_buff *skb, u32 info);
 	unsigned int		no_policy:1,
@@ -54,8 +52,6 @@ struct net_protocol {
 
 #if IS_ENABLED(CONFIG_IPV6)
 struct inet6_protocol {
-	void	(*early_demux)(struct sk_buff *skb);
-	void    (*early_demux_handler)(struct sk_buff *skb);
 	int	(*handler)(struct sk_buff *skb);
 
 	void	(*err_handler)(struct sk_buff *skb,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 003638f73ffa..4f97c0e2d5f3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -890,6 +890,8 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 #endif
 	return 0;
 }
+
+void tcp_v6_early_demux(struct sk_buff *skb);
 #endif
 
 static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
diff --git a/include/net/udp.h b/include/net/udp.h
index 18391015233e..07135de00166 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -173,6 +173,7 @@ typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
 struct sk_buff **udp_gro_receive(struct sk_buff **head, struct sk_buff *skb,
 				 struct udphdr *uh, udp_lookup_t lookup);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+void udp_v6_early_demux(struct sk_buff *skb);
 
 static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 {
diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index dab9f34383e5..0bd39530b2e3 100644
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /* const.h: Macros for dealing with constants.  */
 
-#ifndef _LINUX_CONST_H
-#define _LINUX_CONST_H
+#ifndef _UAPI_LINUX_CONST_H
+#define _UAPI_LINUX_CONST_H
 
 /* Some constant macros are used in both assembler and
  * C code.  Therefore we cannot annotate them always with
@@ -22,6 +22,9 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 
@@ -30,4 +33,4 @@
 
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 
-#endif /* !(_LINUX_CONST_H) */
+#endif /* _UAPI_LINUX_CONST_H */
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 652c0723051b..60bf8603ddc9 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3551,7 +3551,8 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
 			l2cap_add_conf_opt(&ptr, L2CAP_CONF_RFC,
 					   sizeof(rfc), (unsigned long) &rfc, endptr - ptr);
 
-			if (test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
+			if (remote_efs &&
+			    test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
 				chan->remote_id = efs.id;
 				chan->remote_stype = efs.stype;
 				chan->remote_msdu = le16_to_cpu(efs.msdu);
@@ -6255,6 +6256,7 @@ static int l2cap_rx_state_recv(struct l2cap_chan *chan,
 			       struct l2cap_ctrl *control,
 			       struct sk_buff *skb, u8 event)
 {
+	struct l2cap_ctrl local_control;
 	int err = 0;
 	bool skb_in_use = false;
 
@@ -6279,15 +6281,32 @@ static int l2cap_rx_state_recv(struct l2cap_chan *chan,
 			chan->buffer_seq = chan->expected_tx_seq;
 			skb_in_use = true;
 
+			/* l2cap_reassemble_sdu may free skb, hence invalidate
+			 * control, so make a copy in advance to use it after
+			 * l2cap_reassemble_sdu returns and to avoid the race
+			 * condition, for example:
+			 *
+			 * The current thread calls:
+			 *   l2cap_reassemble_sdu
+			 *     chan->ops->recv == l2cap_sock_recv_cb
+			 *       __sock_queue_rcv_skb
+			 * Another thread calls:
+			 *   bt_sock_recvmsg
+			 *     skb_recv_datagram
+			 *     skb_free_datagram
+			 * Then the current thread tries to access control, but
+			 * it was freed by skb_free_datagram.
+			 */
+			local_control = *control;
 			err = l2cap_reassemble_sdu(chan, skb, control);
 			if (err)
 				break;
 
-			if (control->final) {
+			if (local_control.final) {
 				if (!test_and_clear_bit(CONN_REJ_ACT,
 							&chan->conn_state)) {
-					control->final = 0;
-					l2cap_retransmit_all(chan, control);
+					local_control.final = 0;
+					l2cap_retransmit_all(chan, &local_control);
 					l2cap_ertm_send(chan);
 				}
 			}
@@ -6667,11 +6686,27 @@ static int l2cap_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 			   struct sk_buff *skb)
 {
+	/* l2cap_reassemble_sdu may free skb, hence invalidate control, so store
+	 * the txseq field in advance to use it after l2cap_reassemble_sdu
+	 * returns and to avoid the race condition, for example:
+	 *
+	 * The current thread calls:
+	 *   l2cap_reassemble_sdu
+	 *     chan->ops->recv == l2cap_sock_recv_cb
+	 *       __sock_queue_rcv_skb
+	 * Another thread calls:
+	 *   bt_sock_recvmsg
+	 *     skb_recv_datagram
+	 *     skb_free_datagram
+	 * Then the current thread tries to access control, but it was freed by
+	 * skb_free_datagram.
+	 */
+	u16 txseq = control->txseq;
+
 	BT_DBG("chan %p, control %p, skb %p, state %d", chan, control, skb,
 	       chan->rx_state);
 
-	if (l2cap_classify_txseq(chan, control->txseq) ==
-	    L2CAP_TXSEQ_EXPECTED) {
+	if (l2cap_classify_txseq(chan, txseq) == L2CAP_TXSEQ_EXPECTED) {
 		l2cap_pass_to_tx(chan, control);
 
 		BT_DBG("buffer_seq %d->%d", chan->buffer_seq,
@@ -6694,8 +6729,8 @@ static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		}
 	}
 
-	chan->last_acked_seq = control->txseq;
-	chan->expected_tx_seq = __next_seq(chan, control->txseq);
+	chan->last_acked_seq = txseq;
+	chan->expected_tx_seq = __next_seq(chan, txseq);
 
 	return 0;
 }
@@ -6933,6 +6968,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 				return;
 			}
 
+			l2cap_chan_hold(chan);
 			l2cap_chan_lock(chan);
 		} else {
 			BT_DBG("unknown cid 0x%4.4x", cid);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 51aacfdd4fb7..8e71f392ce21 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -310,7 +310,7 @@ int neigh_ifdown(struct neigh_table *tbl, struct net_device *dev)
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev);
 	pneigh_ifdown_and_unlock(tbl, dev);
-	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
 		del_timer_sync(&tbl->proxy_timer);
 	return 0;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 06ad21597d68..1eee002b12d2 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1608,12 +1608,7 @@ static const struct net_protocol igmp_protocol = {
 };
 #endif
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol tcp_protocol = {
-	.early_demux	=	tcp_v4_early_demux,
-	.early_demux_handler =  tcp_v4_early_demux,
+static const struct net_protocol tcp_protocol = {
 	.handler	=	tcp_v4_rcv,
 	.err_handler	=	tcp_v4_err,
 	.no_policy	=	1,
@@ -1621,12 +1616,7 @@ static struct net_protocol tcp_protocol = {
 	.icmp_strict_tag_validation = 1,
 };
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct net_protocol udp_protocol = {
-	.early_demux =	udp_v4_early_demux,
-	.early_demux_handler =	udp_v4_early_demux,
+static const struct net_protocol udp_protocol = {
 	.handler =	udp_rcv,
 	.err_handler =	udp_err,
 	.no_policy =	1,
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 6fc45d3a1f8a..155476df8f9a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -307,10 +307,11 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 	return true;
 }
 
+int udp_v4_early_demux(struct sk_buff *);
+int tcp_v4_early_demux(struct sk_buff *);
 static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	struct net_device *dev = skb->dev;
 	struct rtable *rt;
 	int err;
@@ -322,20 +323,29 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (!skb)
 		return NET_RX_SUCCESS;
 
-	if (net->ipv4.sysctl_ip_early_demux &&
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
 	    !skb_dst(skb) &&
 	    !skb->sk &&
 	    !ip_is_fragment(iph)) {
-		const struct net_protocol *ipprot;
-		int protocol = iph->protocol;
+		switch (iph->protocol) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
+				tcp_v4_early_demux(skb);
 
-		ipprot = rcu_dereference(inet_protos[protocol]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
-			err = edemux(skb);
-			if (unlikely(err))
-				goto drop_error;
-			/* must reload iph, skb->head might have changed */
-			iph = ip_hdr(skb);
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_udp_early_demux)) {
+				err = udp_v4_early_demux(skb);
+				if (unlikely(err))
+					goto drop_error;
+
+				/* must reload iph, skb->head might have changed */
+				iph = ip_hdr(skb);
+			}
+			break;
 		}
 	}
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 78771272f613..df118d5b1e28 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -311,61 +311,6 @@ static int proc_tcp_fastopen_key(struct ctl_table *ctl, int write,
 	return ret;
 }
 
-static void proc_configure_early_demux(int enabled, int protocol)
-{
-	struct net_protocol *ipprot;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_protocol *ip6prot;
-#endif
-
-	rcu_read_lock();
-
-	ipprot = rcu_dereference(inet_protos[protocol]);
-	if (ipprot)
-		ipprot->early_demux = enabled ? ipprot->early_demux_handler :
-						NULL;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	ip6prot = rcu_dereference(inet6_protos[protocol]);
-	if (ip6prot)
-		ip6prot->early_demux = enabled ? ip6prot->early_demux_handler :
-						 NULL;
-#endif
-	rcu_read_unlock();
-}
-
-static int proc_tcp_early_demux(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_tcp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_TCP);
-	}
-
-	return ret;
-}
-
-static int proc_udp_early_demux(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret = 0;
-
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (write && !ret) {
-		int enabled = init_net.ipv4.sysctl_udp_early_demux;
-
-		proc_configure_early_demux(enabled, IPPROTO_UDP);
-	}
-
-	return ret;
-}
-
 static int proc_tfo_blackhole_detect_timeout(struct ctl_table *table,
 					     int write,
 					     void __user *buffer,
@@ -853,14 +798,14 @@ static struct ctl_table ipv4_net_table[] = {
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_udp_early_demux
+		.proc_handler   = proc_douintvec,
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_tcp_early_demux
+		.proc_handler   = proc_douintvec,
 	},
 	{
 		.procname	= "ip_default_ttl",
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 9ee208a348f5..62b5dac7be30 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -47,10 +47,10 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
+void udp_v6_early_demux(struct sk_buff *);
+void tcp_v6_early_demux(struct sk_buff *);
 int ip6_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	void (*edemux)(struct sk_buff *skb);
-
 	/* if ingress device is enslaved to an L3 master device pass the
 	 * skb to its handler for processing
 	 */
@@ -58,13 +58,20 @@ int ip6_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (!skb)
 		return NET_RX_SUCCESS;
 
-	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
-		const struct inet6_protocol *ipprot;
-
-		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
-		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
-			edemux(skb);
+	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
+	    !skb_dst(skb) && !skb->sk) {
+		switch (ipv6_hdr(skb)->nexthdr) {
+		case IPPROTO_TCP:
+			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux))
+				tcp_v6_early_demux(skb);
+			break;
+		case IPPROTO_UDP:
+			if (READ_ONCE(net->ipv4.sysctl_udp_early_demux))
+				udp_v6_early_demux(skb);
+			break;
+		}
 	}
+
 	if (!skb_valid_dst(skb))
 		ip6_route_input(skb);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 711e5565e3a5..4ef55062d37c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1635,7 +1635,7 @@ static int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-static void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -1991,12 +1991,7 @@ struct proto tcpv6_prot = {
 	.diag_destroy		= tcp_abort,
 };
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol tcpv6_protocol = {
-	.early_demux	=	tcp_v6_early_demux,
-	.early_demux_handler =  tcp_v6_early_demux,
+static const struct inet6_protocol tcpv6_protocol = {
 	.handler	=	tcp_v6_rcv,
 	.err_handler	=	tcp_v6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 685efa6a8c32..0d4f82f9ebfd 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -932,7 +932,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-static void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1491,12 +1491,7 @@ int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
 }
 #endif
 
-/* thinking of making this const? Don't.
- * early_demux can change based on sysctl.
- */
-static struct inet6_protocol udpv6_protocol = {
-	.early_demux	=	udp_v6_early_demux,
-	.early_demux_handler =  udp_v6_early_demux,
+static const struct inet6_protocol udpv6_protocol = {
 	.handler	=	udpv6_rcv,
 	.err_handler	=	udpv6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 1ecce76bc266..eb58a930fbdf 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1240,8 +1240,8 @@ static inline int todrop_entry(struct ip_vs_conn *cp)
 	 * The drop rate array needs tuning for real environments.
 	 * Called from timer bh only => no locking
 	 */
-	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
-	static char todrop_counter[9] = {0};
+	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
+	static signed char todrop_counter[9] = {0};
 	int i;
 
 	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index cda4c6678ef1..d41618d9c764 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -239,6 +239,9 @@ void rose_transmit_clear_request(struct rose_neigh *neigh, unsigned int lci, uns
 	unsigned char *dptr;
 	int len;
 
+	if (!neigh->dev)
+		return;
+
 	len = AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN + 3;
 
 	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 9cf6cd8ea6c6..40114eb7eebf 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -61,6 +61,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
+	unsigned int len;
 	int ret;
 
 	q->vars.qavg = red_calc_qavg(&q->parms,
@@ -96,9 +97,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		break;
 	}
 
+	len = qdisc_pkt_len(skb);
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.pdrop++;
diff --git a/security/commoncap.c b/security/commoncap.c
index c9279d097aa8..159a1292a75b 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -398,8 +398,10 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
 				 &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0 || !tmpbuf)
-		return ret;
+	if (ret < 0 || !tmpbuf) {
+		size = ret;
+		goto out_free;
+	}
 
 	fs_ns = inode->i_sb->s_user_ns;
 	cap = (struct vfs_cap_data *) tmpbuf;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 1904fc542025..2cd789ddc2ab 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3333,6 +3333,64 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 	}
 },
 
+/*
+ * MacroSilicon MS2100/MS2106 based AV capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_AUDIO_ALIGN_TRANSFER, which makes one wonder if
+ * they pretend to be 96kHz mono as a workaround for stereo being broken
+ * by that...
+ *
+ * They also have an issue with initial stream alignment that causes the
+ * channels to be swapped and out of phase, which is dealt with in quirks.c.
+ */
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x534d,
+	.idProduct = 0x0021,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MacroSilicon",
+		.product_name = "MS210x",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 2,
+					.iface = 3,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 48000,
+					.rate_max = 48000,
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 /*
  * MacroSilicon MS2109 based HDMI capture cards
  *
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 182c9de4f255..5aa7a49dac75 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1128,6 +1128,7 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
