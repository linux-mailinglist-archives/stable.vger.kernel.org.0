Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4993C6247F9
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiKJRKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiKJRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:09:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F4F45A1F;
        Thu, 10 Nov 2022 09:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C503261C30;
        Thu, 10 Nov 2022 17:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FE8C433C1;
        Thu, 10 Nov 2022 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668100177;
        bh=aOBRosltIiVJgc+bsLf3KenQp/xwM7tP+6xWgBmgR5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdHIUJulLTzUCHwnFP0WinjhM5AiCYevQRe0bm3NeDzrXTbX4nutTsMPyD0OpMqm3
         rRWAmYZIQXWzvC8vlJF0hSXUzK+LMqHKlSot38qZlaxz7AYG+zTwWkdDTJ8bx4v8n4
         hup8IlulryDrgiInKp8t9+B0vPeLJxPdv4DacZII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.265
Date:   Thu, 10 Nov 2022 18:09:24 +0100
Message-Id: <166810016414286@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <16681001648992@kroah.com>
References: <16681001648992@kroah.com>
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

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index c14dab13a47e..d2849713d37b 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -39,7 +39,7 @@ Documentation written by Tom Zanussi
   will use the event's kernel stacktrace as the key.  The keywords
   'keys' or 'key' can be used to specify keys, and the keywords
   'values', 'vals', or 'val' can be used to specify values.  Compound
-  keys consisting of up to two fields can be specified by the 'keys'
+  keys consisting of up to three fields can be specified by the 'keys'
   keyword.  Hashing a compound key produces a unique entry in the
   table for each unique combination of component keys, and can be
   useful for providing more fine-grained summaries of event data.
diff --git a/Makefile b/Makefile
index bc4864f3bd0e..592e6928e020 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 264
+SUBLEVEL = 265
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/parisc/include/asm/hardware.h b/arch/parisc/include/asm/hardware.h
index d6e1ed145031..f4eab68e25a9 100644
--- a/arch/parisc/include/asm/hardware.h
+++ b/arch/parisc/include/asm/hardware.h
@@ -10,12 +10,12 @@
 #define SVERSION_ANY_ID		PA_SVERSION_ANY_ID
 
 struct hp_hardware {
-	unsigned short	hw_type:5;	/* HPHW_xxx */
-	unsigned short	hversion;
-	unsigned long	sversion:28;
-	unsigned short	opt;
-	const char	name[80];	/* The hardware description */
-};
+	unsigned int	hw_type:8;	/* HPHW_xxx */
+	unsigned int	hversion:12;
+	unsigned int	sversion:12;
+	unsigned char	opt;
+	unsigned char	name[59];	/* The hardware description */
+} __packed;
 
 struct parisc_device;
 
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 592e8cec16dd..01a2ed59d2f2 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -861,15 +861,13 @@ void __init walk_central_bus(void)
 			&root);
 }
 
-static void print_parisc_device(struct parisc_device *dev)
+static __init void print_parisc_device(struct parisc_device *dev)
 {
-	char hw_path[64];
-	static int count;
+	static int count __initdata;
 
-	print_pa_hwpath(dev, hw_path);
-	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
-		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
+	pr_info("%d. %s at %pap { type:%d, hv:%#x, sv:%#x, rev:%#x }",
+		++count, dev->name, &(dev->hpa.start), dev->id.hw_type,
+		dev->id.hversion, dev->id.sversion, dev->id.hversion_rev);
 
 	if (dev->num_addrs) {
 		int k;
@@ -1058,7 +1056,7 @@ static __init int qemu_print_iodc_data(struct device *lin_dev, void *data)
 
 
 
-static int print_one_device(struct device * dev, void * data)
+static __init int print_one_device(struct device * dev, void * data)
 {
 	struct parisc_device * pdev = to_parisc_device(dev);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0489ffc3dfe5..768a765c49b0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -680,6 +680,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
+		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		/*
 		 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b1490e08f891..0cb75d29e67b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -759,8 +759,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 			   ctxt->mode, linear);
 }
 
-static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
-			     enum x86emul_mode mode)
+static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 {
 	ulong linear;
 	int rc;
@@ -770,41 +769,71 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst,
 
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
@@ -2192,7 +2221,7 @@ static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2273,7 +2302,7 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 				       &new_desc);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	rc = assign_eip_far(ctxt, eip, &new_desc);
+	rc = assign_eip_far(ctxt, eip);
 	/* Error handling is not implemented. */
 	if (rc != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
@@ -2895,6 +2924,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;
@@ -3491,7 +3521,7 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rc = assign_eip_far(ctxt, ctxt->src.val, &new_desc);
+	rc = assign_eip_far(ctxt, ctxt->src.val);
 	if (rc != X86EMUL_CONTINUE)
 		goto fail;
 
@@ -3638,11 +3668,25 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
 
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
index a9f42df92ea3..7415db053217 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -416,6 +416,8 @@ static struct bfq_io_cq *bfq_bic_lookup(struct bfq_data *bfqd,
  */
 void bfq_schedule_dispatch(struct bfq_data *bfqd)
 {
+	lockdep_assert_held(&bfqd->lock);
+
 	if (bfqd->queued != 0) {
 		bfq_log(bfqd, "schedule dispatch");
 		blk_mq_run_hw_queues(bfqd->queue, true);
@@ -5278,8 +5280,8 @@ bfq_idle_slice_timer_body(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_bfqq_expire(bfqd, bfqq, true, reason);
 
 schedule_dispatch:
-	spin_unlock_irqrestore(&bfqd->lock, flags);
 	bfq_schedule_dispatch(bfqd);
+	spin_unlock_irqrestore(&bfqd->lock, flags);
 }
 
 /*
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 52cea1b3ea70..591778024054 100644
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
index 7098744f9276..f0ef2643b70e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -556,7 +556,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 70079d29822b..00943ddbe417 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -793,6 +793,7 @@
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 #define USB_DEVICE_ID_MADCATZ_RAT5	0x1705
 #define USB_DEVICE_ID_MADCATZ_RAT9	0x1709
+#define USB_DEVICE_ID_MADCATZ_MMO7  0x1713
 
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index c1b76ba85fb4..8de294aa3184 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -620,6 +620,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT9) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7) },
 #endif
 #if IS_ENABLED(CONFIG_HID_SAMSUNG)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index 683861f324e3..95e004d9b110 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -191,6 +191,8 @@ static const struct hid_device_id saitek_devices[] = {
 		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7),
 		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7),
+		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
 	{ }
 };
 
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 52acb185a29c..03ce9b7d6456 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -893,6 +893,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 2a82661620fe..72ec9d36799f 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -338,6 +338,10 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 		spin_lock_init(&dev->qpidr.idr_lock);
 		idr_init(&dev->qpidr.idr);
 		dev->iwarp_wq = create_singlethread_workqueue("qedr_iwarpq");
+		if (!dev->iwarp_wq) {
+			rc = -ENOMEM;
+			goto err1;
+		}
 	}
 
 	/* Allocate Status blocks for CNQ */
@@ -345,7 +349,7 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 				GFP_KERNEL);
 	if (!dev->sb_array) {
 		rc = -ENOMEM;
-		goto err1;
+		goto err_destroy_wq;
 	}
 
 	dev->cnq_array = kcalloc(dev->num_cnq,
@@ -399,6 +403,9 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	kfree(dev->cnq_array);
 err2:
 	kfree(dev->sb_array);
+err_destroy_wq:
+	if (IS_IWARP(dev))
+		destroy_workqueue(dev->iwarp_wq);
 err1:
 	kfree(dev->sgid_tbl);
 	return rc;
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 4a342daac98d..45b6aaf3de4a 100644
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
index 84ac3f73f8fe..100a3a0b2db3 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6694,7 +6694,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
diff --git a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
index 7bc4d8a9af28..1f35770245d1 100644
--- a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
+++ b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
@@ -44,6 +44,8 @@ static void handle_cec_message(struct cros_ec_cec *cros_ec_cec)
 	uint8_t *cec_message = cros_ec->event_data.data.cec_message;
 	unsigned int len = cros_ec->event_size;
 
+	if (len > CEC_MAX_MSG_SIZE)
+		len = CEC_MAX_MSG_SIZE;
 	cros_ec_cec->rx_msg.len = len;
 	memcpy(cros_ec_cec->rx_msg.msg, cec_message, len);
 
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
index 990de7c54b46..30f8f0117a30 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -333,6 +333,17 @@ static struct mdio_driver dsa_loop_drv = {
 
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
@@ -340,23 +351,23 @@ static int __init dsa_loop_init(void)
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
index fcd5d845e99a..e97ab9545a79 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -623,7 +623,7 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 		dev_kfree_skb_any(skb);
 		if (net_ratelimit())
 			netdev_err(ndev, "Tx DMA memory map failed\n");
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
 
 	bdp->cbd_datlen = cpu_to_fec16(size);
@@ -685,7 +685,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			dev_kfree_skb_any(skb);
 			if (net_ratelimit())
 				netdev_err(ndev, "Tx DMA memory map failed\n");
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index efdac68da7f4..1d1fbd7bd6fc 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -412,7 +412,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		bus->reset(bus);
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-		if ((bus->phy_mask & (1 << i)) == 0) {
+		if ((bus->phy_mask & BIT(i)) == 0) {
 			struct phy_device *phydev;
 
 			phydev = mdiobus_scan(bus, i);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c3390999842a..8d1b34640f79 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1473,7 +1473,8 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	int err;
 	int i;
 
-	if (it->nr_segs > MAX_SKB_FRAGS + 1)
+	if (it->nr_segs > MAX_SKB_FRAGS + 1 ||
+	    len > (ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN))
 		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index e7eaa57d11d9..4a900d8d98b8 100644
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
index 919b4d2f5d8b..fa6db971bee9 100644
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
index f005eaf8bc57..a9ddd76d4170 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -106,7 +106,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 781c725e6432..a1eb573fbb10 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -589,6 +589,18 @@ unode_aux_to_inode_list(struct ulist_node *node)
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
@@ -703,7 +715,11 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
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
 
@@ -1360,24 +1376,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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
index 665ec85cb09b..ecc33e3a3c06 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -58,7 +58,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index f32f4113c976..5afb7ca42828 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -19,7 +19,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index d07dd26194b1..24a61e524861 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -237,8 +237,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots,
 			false);
@@ -273,8 +275,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	}
 
 	ret = remove_extent_item(root, nodesize, nodesize);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return -EINVAL;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots,
 			false);
@@ -338,8 +342,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots,
 			false);
@@ -373,8 +379,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = add_tree_ref(root, nodesize, nodesize, 0,
 			BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots,
 			false);
@@ -414,8 +422,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = remove_extent_ref(root, nodesize, nodesize, 0,
 				BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots,
 			false);
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 37ce665ae1d2..4a72583c7559 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -443,7 +443,8 @@ int ext4_ext_migrate(struct inode *inode)
 	 * already is extent-based, error out.
 	 */
 	if (!ext4_has_feature_extents(inode->i_sb) ||
-	    (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
+	    ext4_has_inline_data(inode))
 		return -EINVAL;
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index c97ec2fa0bbc..50d352011ea6 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -340,6 +340,7 @@ int nfs40_init_client(struct nfs_client *clp)
 	ret = nfs4_setup_slot_table(tbl, NFS4_MAX_SLOT_TABLE,
 					"NFSv4.0 transport Slot table");
 	if (ret) {
+		nfs4_shutdown_slot_table(tbl);
 		kfree(tbl);
 		return ret;
 	}
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 30576a10a1f4..5ab021f87ecf 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1736,6 +1736,7 @@ static void nfs4_state_mark_reclaim_helper(struct nfs_client *clp,
 
 static void nfs4_state_start_reclaim_reboot(struct nfs_client *clp)
 {
+	set_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state);
 	/* Mark all delegations for reclaim */
 	nfs_delegation_mark_reclaim(clp);
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_reboot);
@@ -2589,6 +2590,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec89e8bcc92f..789a194e18a4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1655,7 +1655,7 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
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
index 487b6c5f53f4..9a154fe06c60 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -901,6 +901,8 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 #endif
 	return 0;
 }
+
+void tcp_v6_early_demux(struct sk_buff *skb);
 #endif
 
 static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
diff --git a/include/net/udp.h b/include/net/udp.h
index 8482a990b0bb..618c83bea50d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -173,6 +173,7 @@ typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 				struct udphdr *uh, udp_lookup_t lookup);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
+void udp_v6_early_demux(struct sk_buff *skb);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b2f01e61f0ee..33aba4e2e3e3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2172,8 +2172,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 5c965f7b1709..251da90642cd 100644
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
index 73042407eb5b..2b96e9a7fc59 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -312,7 +312,7 @@ int neigh_ifdown(struct neigh_table *tbl, struct net_device *dev)
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev);
 	pneigh_ifdown_and_unlock(tbl, dev);
-	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
 		del_timer_sync(&tbl->proxy_timer);
 	return 0;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3cf9cd180898..4b26ae525d6d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1678,12 +1678,7 @@ static const struct net_protocol igmp_protocol = {
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
@@ -1691,12 +1686,7 @@ static struct net_protocol tcp_protocol = {
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
index c3a0683e83df..7ead5192b2a9 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -306,28 +306,38 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 	return true;
 }
 
+int udp_v4_early_demux(struct sk_buff *);
+int tcp_v4_early_demux(struct sk_buff *);
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			      struct sk_buff *skb, struct net_device *dev)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int (*edemux)(struct sk_buff *skb);
 	struct rtable *rt;
 	int err;
 
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
index ad132b6e8cfa..c97ba2a44b8b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -332,61 +332,6 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
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
@@ -638,14 +583,14 @@ static struct ctl_table ipv4_net_table[] = {
 		.data           = &init_net.ipv4.sysctl_udp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_udp_early_demux
+		.proc_handler   = proc_douintvec_minmax,
 	},
 	{
 		.procname       = "tcp_early_demux",
 		.data           = &init_net.ipv4.sysctl_tcp_early_demux,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = proc_tcp_early_demux
+		.proc_handler   = proc_douintvec_minmax,
 	},
 	{
 		.procname	= "ip_default_ttl",
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 57d84accbf1e..2bdb03a45baf 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -47,18 +47,25 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
 
+void udp_v6_early_demux(struct sk_buff *);
+void tcp_v6_early_demux(struct sk_buff *);
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 				struct sk_buff *skb)
 {
-	void (*edemux)(struct sk_buff *skb);
-
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
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b940285a111e..7b41d5d3575f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5374,10 +5374,16 @@ static void __net_exit ip6_route_net_exit(struct net *net)
 static int __net_init ip6_route_net_init_late(struct net *net)
 {
 #ifdef CONFIG_PROC_FS
-	proc_create_net("ipv6_route", 0, net->proc_net, &ipv6_route_seq_ops,
-			sizeof(struct ipv6_route_iter));
-	proc_create_net_single("rt6_stats", 0444, net->proc_net,
-			rt6_stats_seq_show, NULL);
+	if (!proc_create_net("ipv6_route", 0, net->proc_net,
+			     &ipv6_route_seq_ops,
+			     sizeof(struct ipv6_route_iter)))
+		return -ENOMEM;
+
+	if (!proc_create_net_single("rt6_stats", 0444, net->proc_net,
+				    rt6_stats_seq_show, NULL)) {
+		remove_proc_entry("ipv6_route", net->proc_net);
+		return -ENOMEM;
+	}
 #endif
 	return 0;
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 549ea5211bfa..7a5a7a4265cf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1673,7 +1673,7 @@ static int tcp_v6_rcv(struct sk_buff *skb)
 	goto discard_it;
 }
 
-static void tcp_v6_early_demux(struct sk_buff *skb)
+void tcp_v6_early_demux(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
 	const struct tcphdr *th;
@@ -2028,12 +2028,7 @@ struct proto tcpv6_prot = {
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
index fb71da6c6c74..9b0cae403027 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -912,7 +912,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 	return NULL;
 }
 
-static void udp_v6_early_demux(struct sk_buff *skb)
+void udp_v6_early_demux(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	const struct udphdr *uh;
@@ -1533,12 +1533,7 @@ int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
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
diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 80759aadd3e0..21149f4e0b6e 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -604,13 +604,19 @@ static const struct seq_operations ip_vs_app_seq_ops = {
 int __net_init ip_vs_app_net_init(struct netns_ipvs *ipvs)
 {
 	INIT_LIST_HEAD(&ipvs->app_list);
-	proc_create_net("ip_vs_app", 0, ipvs->net->proc_net, &ip_vs_app_seq_ops,
-			sizeof(struct seq_net_private));
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs_app", 0, ipvs->net->proc_net,
+			     &ip_vs_app_seq_ops,
+			     sizeof(struct seq_net_private)))
+		return -ENOMEM;
+#endif
 	return 0;
 }
 
 void __net_exit ip_vs_app_net_cleanup(struct netns_ipvs *ipvs)
 {
 	unregister_ip_vs_app(ipvs, NULL /* all */);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_app", ipvs->net->proc_net);
+#endif
 }
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 95c35aa639ec..51679d1e2d7d 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1230,8 +1230,8 @@ static inline int todrop_entry(struct ip_vs_conn *cp)
 	 * The drop rate array needs tuning for real environments.
 	 * Called from timer bh only => no locking
 	 */
-	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
-	static char todrop_counter[9] = {0};
+	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
+	static signed char todrop_counter[9] = {0};
 	int i;
 
 	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
@@ -1378,20 +1378,36 @@ int __net_init ip_vs_conn_net_init(struct netns_ipvs *ipvs)
 {
 	atomic_set(&ipvs->conn_count, 0);
 
-	proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
-			&ip_vs_conn_seq_ops, sizeof(struct ip_vs_iter_state));
-	proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
-			&ip_vs_conn_sync_seq_ops,
-			sizeof(struct ip_vs_iter_state));
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn;
+
+	if (!proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_sync_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn_sync;
+#endif
+
 	return 0;
+
+#ifdef CONFIG_PROC_FS
+err_conn_sync:
+	remove_proc_entry("ip_vs_conn", ipvs->net->proc_net);
+err_conn:
+	return -ENOMEM;
+#endif
 }
 
 void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 {
 	/* flush all the connection entries first */
 	ip_vs_conn_flush(ipvs);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_conn", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs_conn_sync", ipvs->net->proc_net);
+#endif
 }
 
 int __init ip_vs_conn_init(void)
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 62055d3069d2..f3d7105c6cdd 100644
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
index 0424aa747c34..afe0c2d689b1 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -63,6 +63,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *child = q->qdisc;
+	unsigned int len;
 	int ret;
 
 	q->vars.qavg = red_calc_qavg(&q->parms,
@@ -98,9 +99,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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
index 876cfe01d939..28b204eacc7a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -397,8 +397,10 @@ int cap_inode_getsecurity(struct inode *inode, const char *name, void **buffer,
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
index 1e0d94603692..3f353e051a1d 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3526,6 +3526,64 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* Asrock TRX40 Creator */
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
index b1bd63a9fc6d..512e052e59f7 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1174,6 +1174,7 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
