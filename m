Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8925B1A1F
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIHKhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiIHKhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91142883F1;
        Thu,  8 Sep 2022 03:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C772061C44;
        Thu,  8 Sep 2022 10:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA51AC433C1;
        Thu,  8 Sep 2022 10:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662633453;
        bh=xqDiTi5q2CM4a4iq1x2VeBDkbcHqESm56tyf7T2ltG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKwdHNd3+H3mr3f4MHCx0aSrA/k2ijkJNLZR6/p9KnTtXFjgPjiwex6x3j25GGJUn
         nq1xMLNUu1RTmg3Ejz5SIOKWEe6WvZDSHbp9BrwmB7Ho96Yw88DO9dVxm7aBxKlA8q
         MRik0AFo2Gi2jVHmAuK+oK68fJ2p3BaLU8rQAr2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.66
Date:   Thu,  8 Sep 2022 12:37:47 +0200
Message-Id: <1662633466120198@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166263346611761@kroah.com>
References: <166263346611761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9142dbf41f0d..4e747c99e7e0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 65
+SUBLEVEL = 66
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -480,6 +480,8 @@ LZ4		= lz4c
 XZ		= xz
 ZSTD		= zstd
 
+PAHOLE_FLAGS	= $(shell PAHOLE=$(PAHOLE) $(srctree)/scripts/pahole-flags.sh)
+
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
 NOSTDINC_FLAGS :=
@@ -534,6 +536,7 @@ export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
+export PAHOLE_FLAGS
 
 # Files to ignore in find ... statements
 
diff --git a/arch/powerpc/kernel/systbl.S b/arch/powerpc/kernel/systbl.S
index cb3358886203..6c1db3b6de2d 100644
--- a/arch/powerpc/kernel/systbl.S
+++ b/arch/powerpc/kernel/systbl.S
@@ -18,6 +18,7 @@
 	.p2align	3
 #define __SYSCALL(nr, entry)	.8byte entry
 #else
+	.p2align	2
 #define __SYSCALL(nr, entry)	.long entry
 #endif
 
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 5e49e4b4a4cc..86c56616e5de 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -118,10 +118,10 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 	if (!numpages)
 		return 0;
 
-	mmap_read_lock(&init_mm);
+	mmap_write_lock(&init_mm);
 	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
 				     &masks);
-	mmap_read_unlock(&init_mm);
+	mmap_write_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
 
diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 60f9241e5e4a..d3642fb634bd 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -28,9 +28,11 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline int prepare_hugepage_range(struct file *file,
 			unsigned long addr, unsigned long len)
 {
-	if (len & ~HPAGE_MASK)
+	struct hstate *h = hstate_file(file);
+
+	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if (addr & ~HPAGE_MASK)
+	if (addr & ~huge_page_mask(h))
 		return -EINVAL;
 	return 0;
 }
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 42c43521878f..b508ccad4856 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -132,6 +132,7 @@ SECTIONS
 	/*
 	 * Table with the patch locations to undo expolines
 	*/
+	. = ALIGN(4);
 	.nospec_call_table : {
 		__nospec_call_start = . ;
 		*(.s390_indirect*)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfb3a5c809f2..e5584e974c77 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -831,8 +831,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
-					 MSR_IA32_SPEC_CTRL);
+	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
 }
 
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5b7a05530eb..9109e5589b42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1465,12 +1465,32 @@ static const u32 msr_based_features_all[] = {
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
 static unsigned int num_msr_based_features;
 
+/*
+ * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
+ * does not yet virtualize. These include:
+ *   10 - MISC_PACKAGE_CTRLS
+ *   11 - ENERGY_FILTERING_CTL
+ *   12 - DOITM
+ *   18 - FB_CLEAR_CTRL
+ *   21 - XAPIC_DISABLE_STATUS
+ *   23 - OVERCLOCKING_STATUS
+ */
+
+#define KVM_SUPPORTED_ARCH_CAP \
+	(ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
+	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
+	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
+	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+
 static u64 kvm_get_arch_capabilities(void)
 {
 	u64 data = 0;
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
+		data &= KVM_SUPPORTED_ARCH_CAP;
+	}
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -1518,9 +1538,6 @@ static u64 kvm_get_arch_capabilities(void)
 		 */
 	}
 
-	/* Guests don't need to know "Fill buffer clear control" exists */
-	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
-
 	return data;
 }
 
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 56a2387656a0..00c6c03ff822 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1358,6 +1358,18 @@ static int binder_inc_ref_for_node(struct binder_proc *proc,
 	}
 	ret = binder_inc_ref_olocked(ref, strong, target_list);
 	*rdata = ref->data;
+	if (ret && ref == new_ref) {
+		/*
+		 * Cleanup the failed reference here as the target
+		 * could now be dead and have already released its
+		 * references by now. Calling on the new reference
+		 * with strong=0 and a tmp_refs will not decrement
+		 * the node. The new_ref gets kfree'd below.
+		 */
+		binder_cleanup_ref_olocked(new_ref);
+		ref = NULL;
+	}
+
 	binder_proc_unlock(proc);
 	if (new_ref && ref != new_ref)
 		/*
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index f2d9587833d4..849f8dff0be1 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 	 */
 	if (vma) {
 		vm_start = vma->vm_start;
-		alloc->vma_vm_mm = vma->vm_mm;
 		mmap_assert_write_locked(alloc->vma_vm_mm);
 	} else {
 		mmap_assert_locked(alloc->vma_vm_mm);
@@ -795,7 +794,6 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	binder_insert_free_buffer(alloc, buffer);
 	alloc->free_async_space = alloc->buffer_size / 2;
 	binder_alloc_set_vma(alloc, vma);
-	mmgrab(alloc->vma_vm_mm);
 
 	return 0;
 
@@ -1095,6 +1093,8 @@ static struct shrinker binder_shrinker = {
 void binder_alloc_init(struct binder_alloc *alloc)
 {
 	alloc->pid = current->group_leader->pid;
+	alloc->vma_vm_mm = current->mm;
+	mmgrab(alloc->vma_vm_mm);
 	mutex_init(&alloc->mutex);
 	INIT_LIST_HEAD(&alloc->buffers);
 }
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 70e9ee8a10f7..63cc01118810 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -877,6 +877,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Device can't match with a driver right now, so don't attempt
+		 * to match or bind with other drivers on the bus.
+		 */
+		return ret;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;
@@ -1115,6 +1120,11 @@ static int __driver_attach(struct device *dev, void *data)
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index bda5c815e441..a28473470e66 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -226,6 +226,9 @@ struct xen_vbd {
 	sector_t		size;
 	unsigned int		flush_support:1;
 	unsigned int		discard_secure:1;
+	/* Connect-time cached feature_persistent parameter value */
+	unsigned int		feature_gnt_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int		feature_gnt_persistent:1;
 	unsigned int		overflow_max_grants:1;
 };
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 78b50ac11e19..1525e28c5d70 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -910,7 +910,7 @@ static void connect(struct backend_info *be)
 	xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
 
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			be->blkif->vbd.feature_gnt_persistent);
+			be->blkif->vbd.feature_gnt_persistent_parm);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "writing %s/feature-persistent",
 				 dev->nodename);
@@ -1088,7 +1088,9 @@ static int connect_ring(struct backend_info *be)
 		return -ENOSYS;
 	}
 
-	blkif->vbd.feature_gnt_persistent = feature_persistent &&
+	blkif->vbd.feature_gnt_persistent_parm = feature_persistent;
+	blkif->vbd.feature_gnt_persistent =
+		blkif->vbd.feature_gnt_persistent_parm &&
 		xenbus_read_unsigned(dev->otherend, "feature-persistent", 0);
 
 	blkif->vbd.overflow_max_grants = 0;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 23fc4c8f2603..24a86d829f92 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -212,6 +212,9 @@ struct blkfront_info
 	unsigned int feature_fua:1;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
+	/* Connect-time cached feature_persistent parameter */
+	unsigned int feature_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int feature_persistent:1;
 	unsigned int bounce:1;
 	unsigned int discard_granularity;
@@ -1782,6 +1785,12 @@ static int write_per_ring_nodes(struct xenbus_transaction xbt,
 	return err;
 }
 
+/* Enable the persistent grants feature. */
+static bool feature_persistent = true;
+module_param(feature_persistent, bool, 0644);
+MODULE_PARM_DESC(feature_persistent,
+		"Enables the persistent grants feature");
+
 /* Common code used when first setting up, and when resuming. */
 static int talk_to_blkback(struct xenbus_device *dev,
 			   struct blkfront_info *info)
@@ -1873,8 +1882,9 @@ static int talk_to_blkback(struct xenbus_device *dev,
 		message = "writing protocol";
 		goto abort_transaction;
 	}
+	info->feature_persistent_parm = feature_persistent;
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			info->feature_persistent);
+			info->feature_persistent_parm);
 	if (err)
 		dev_warn(&dev->dev,
 			 "writing persistent grants feature to xenbus");
@@ -1942,12 +1952,6 @@ static int negotiate_mq(struct blkfront_info *info)
 	return 0;
 }
 
-/* Enable the persistent grants feature. */
-static bool feature_persistent = true;
-module_param(feature_persistent, bool, 0644);
-MODULE_PARM_DESC(feature_persistent,
-		"Enables the persistent grants feature");
-
 /*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffer for communication with the backend, and
@@ -2307,7 +2311,7 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (feature_persistent)
+	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index dd3b71eafabf..56c5166f841a 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -139,7 +139,7 @@ static unsigned long raspberrypi_fw_get_rate(struct clk_hw *hw,
 	ret = raspberrypi_clock_property(rpi->firmware, data,
 					 RPI_FIRMWARE_GET_CLOCK_RATE, &val);
 	if (ret)
-		return ret;
+		return 0;
 
 	return val;
 }
@@ -156,7 +156,7 @@ static int raspberrypi_fw_set_rate(struct clk_hw *hw, unsigned long rate,
 	ret = raspberrypi_clock_property(rpi->firmware, data,
 					 RPI_FIRMWARE_SET_CLOCK_RATE, &_rate);
 	if (ret)
-		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d",
+		dev_err_ratelimited(rpi->dev, "Failed to change %s frequency: %d\n",
 				    clk_hw_get_name(hw), ret);
 
 	return ret;
@@ -208,7 +208,7 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 					 RPI_FIRMWARE_GET_MIN_CLOCK_RATE,
 					 &min_rate);
 	if (ret) {
-		dev_err(rpi->dev, "Failed to get clock %d min freq: %d",
+		dev_err(rpi->dev, "Failed to get clock %d min freq: %d\n",
 			id, ret);
 		return ERR_PTR(ret);
 	}
@@ -251,8 +251,13 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 	struct rpi_firmware_get_clocks_response *clks;
 	int ret;
 
+	/*
+	 * The firmware doesn't guarantee that the last element of
+	 * RPI_FIRMWARE_GET_CLOCKS is zeroed. So allocate an additional
+	 * zero element as sentinel.
+	 */
 	clks = devm_kcalloc(rpi->dev,
-			    sizeof(*clks), RPI_FIRMWARE_NUM_CLK_ID,
+			    RPI_FIRMWARE_NUM_CLK_ID + 1, sizeof(*clks),
 			    GFP_KERNEL);
 	if (!clks)
 		return -ENOMEM;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d6dc58bd07b3..0674dbc62eb5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -846,10 +846,9 @@ static void clk_core_unprepare(struct clk_core *core)
 	if (core->ops->unprepare)
 		core->ops->unprepare(core->hw);
 
-	clk_pm_runtime_put(core);
-
 	trace_clk_unprepare_complete(core);
 	clk_core_unprepare(core->parent);
+	clk_pm_runtime_put(core);
 }
 
 static void clk_core_unprepare_lock(struct clk_core *core)
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 64befd6f702b..4860bf3b7e00 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1163,7 +1163,9 @@ static int pca953x_suspend(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
+	mutex_unlock(&chip->i2c_lock);
 
 	if (atomic_read(&chip->wakeup_path))
 		device_set_wakeup_path(dev);
@@ -1186,13 +1188,17 @@ static int pca953x_resume(struct device *dev)
 		}
 	}
 
+	mutex_lock(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(dev);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&chip->i2c_lock);
 		return ret;
+	}
 
 	ret = regcache_sync(chip->regmap);
+	mutex_unlock(&chip->i2c_lock);
 	if (ret) {
 		dev_err(dev, "Failed to restore register map: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 26cf75422945..9d371be7dc5c 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -249,6 +249,7 @@ i915-y += \
 	display/g4x_dp.o \
 	display/g4x_hdmi.o \
 	display/icl_dsi.o \
+	display/intel_backlight.o \
 	display/intel_crt.o \
 	display/intel_ddi.o \
 	display/intel_ddi_buf_trans.o \
diff --git a/drivers/gpu/drm/i915/display/g4x_dp.c b/drivers/gpu/drm/i915/display/g4x_dp.c
index de0f358184aa..29c0eca647e3 100644
--- a/drivers/gpu/drm/i915/display/g4x_dp.c
+++ b/drivers/gpu/drm/i915/display/g4x_dp.c
@@ -7,6 +7,7 @@
 
 #include "g4x_dp.h"
 #include "intel_audio.h"
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_de.h"
 #include "intel_display_types.h"
@@ -16,7 +17,6 @@
 #include "intel_fifo_underrun.h"
 #include "intel_hdmi.h"
 #include "intel_hotplug.h"
-#include "intel_panel.h"
 #include "intel_pps.h"
 #include "intel_sideband.h"
 
diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 638a00b2dc2d..2601873e1546 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -29,6 +29,7 @@
 #include <drm/drm_mipi_dsi.h>
 
 #include "intel_atomic.h"
+#include "intel_backlight.h"
 #include "intel_combo_phy.h"
 #include "intel_connector.h"
 #include "intel_crtc.h"
diff --git a/drivers/gpu/drm/i915/display/intel_backlight.c b/drivers/gpu/drm/i915/display/intel_backlight.c
new file mode 100644
index 000000000000..60f91ac7d142
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -0,0 +1,1776 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#include <linux/kernel.h>
+#include <linux/pwm.h>
+
+#include "intel_backlight.h"
+#include "intel_connector.h"
+#include "intel_de.h"
+#include "intel_display_types.h"
+#include "intel_dp_aux_backlight.h"
+#include "intel_dsi_dcs_backlight.h"
+#include "intel_panel.h"
+
+/**
+ * scale - scale values from one range to another
+ * @source_val: value in range [@source_min..@source_max]
+ * @source_min: minimum legal value for @source_val
+ * @source_max: maximum legal value for @source_val
+ * @target_min: corresponding target value for @source_min
+ * @target_max: corresponding target value for @source_max
+ *
+ * Return @source_val in range [@source_min..@source_max] scaled to range
+ * [@target_min..@target_max].
+ */
+static u32 scale(u32 source_val,
+		 u32 source_min, u32 source_max,
+		 u32 target_min, u32 target_max)
+{
+	u64 target_val;
+
+	WARN_ON(source_min > source_max);
+	WARN_ON(target_min > target_max);
+
+	/* defensive */
+	source_val = clamp(source_val, source_min, source_max);
+
+	/* avoid overflows */
+	target_val = mul_u32_u32(source_val - source_min,
+				 target_max - target_min);
+	target_val = DIV_ROUND_CLOSEST_ULL(target_val, source_max - source_min);
+	target_val += target_min;
+
+	return target_val;
+}
+
+/*
+ * Scale user_level in range [0..user_max] to [0..hw_max], clamping the result
+ * to [hw_min..hw_max].
+ */
+static u32 clamp_user_to_hw(struct intel_connector *connector,
+			    u32 user_level, u32 user_max)
+{
+	struct intel_panel *panel = &connector->panel;
+	u32 hw_level;
+
+	hw_level = scale(user_level, 0, user_max, 0, panel->backlight.max);
+	hw_level = clamp(hw_level, panel->backlight.min, panel->backlight.max);
+
+	return hw_level;
+}
+
+/* Scale hw_level in range [hw_min..hw_max] to [0..user_max]. */
+static u32 scale_hw_to_user(struct intel_connector *connector,
+			    u32 hw_level, u32 user_max)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	return scale(hw_level, panel->backlight.min, panel->backlight.max,
+		     0, user_max);
+}
+
+u32 intel_panel_invert_pwm_level(struct intel_connector *connector, u32 val)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
+
+	if (dev_priv->params.invert_brightness < 0)
+		return val;
+
+	if (dev_priv->params.invert_brightness > 0 ||
+	    dev_priv->quirks & QUIRK_INVERT_BRIGHTNESS) {
+		return panel->backlight.pwm_level_max - val + panel->backlight.pwm_level_min;
+	}
+
+	return val;
+}
+
+void intel_panel_set_pwm_level(const struct drm_connector_state *conn_state, u32 val)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *i915 = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	drm_dbg_kms(&i915->drm, "set backlight PWM = %d\n", val);
+	panel->backlight.pwm_funcs->set(conn_state, val);
+}
+
+u32 intel_panel_backlight_level_to_pwm(struct intel_connector *connector, u32 val)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	drm_WARN_ON_ONCE(&dev_priv->drm,
+			 panel->backlight.max == 0 || panel->backlight.pwm_level_max == 0);
+
+	val = scale(val, panel->backlight.min, panel->backlight.max,
+		    panel->backlight.pwm_level_min, panel->backlight.pwm_level_max);
+
+	return intel_panel_invert_pwm_level(connector, val);
+}
+
+u32 intel_panel_backlight_level_from_pwm(struct intel_connector *connector, u32 val)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	drm_WARN_ON_ONCE(&dev_priv->drm,
+			 panel->backlight.max == 0 || panel->backlight.pwm_level_max == 0);
+
+	if (dev_priv->params.invert_brightness > 0 ||
+	    (dev_priv->params.invert_brightness == 0 && dev_priv->quirks & QUIRK_INVERT_BRIGHTNESS))
+		val = panel->backlight.pwm_level_max - (val - panel->backlight.pwm_level_min);
+
+	return scale(val, panel->backlight.pwm_level_min, panel->backlight.pwm_level_max,
+		     panel->backlight.min, panel->backlight.max);
+}
+
+static u32 lpt_get_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	return intel_de_read(dev_priv, BLC_PWM_PCH_CTL2) & BACKLIGHT_DUTY_CYCLE_MASK;
+}
+
+static u32 pch_get_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	return intel_de_read(dev_priv, BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
+}
+
+static u32 i9xx_get_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 val;
+
+	val = intel_de_read(dev_priv, BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
+	if (DISPLAY_VER(dev_priv) < 4)
+		val >>= 1;
+
+	if (panel->backlight.combination_mode) {
+		u8 lbpc;
+
+		pci_read_config_byte(to_pci_dev(dev_priv->drm.dev), LBPC, &lbpc);
+		val *= lbpc;
+	}
+
+	return val;
+}
+
+static u32 vlv_get_backlight(struct intel_connector *connector, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	if (drm_WARN_ON(&dev_priv->drm, pipe != PIPE_A && pipe != PIPE_B))
+		return 0;
+
+	return intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe)) & BACKLIGHT_DUTY_CYCLE_MASK;
+}
+
+static u32 bxt_get_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	return intel_de_read(dev_priv,
+			     BXT_BLC_PWM_DUTY(panel->backlight.controller));
+}
+
+static u32 ext_pwm_get_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct intel_panel *panel = &connector->panel;
+	struct pwm_state state;
+
+	pwm_get_state(panel->backlight.pwm, &state);
+	return pwm_get_relative_duty_cycle(&state, 100);
+}
+
+static void lpt_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	u32 val = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, val | level);
+}
+
+static void pch_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	u32 tmp;
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+	intel_de_write(dev_priv, BLC_PWM_CPU_CTL, tmp | level);
+}
+
+static void i9xx_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 tmp, mask;
+
+	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
+
+	if (panel->backlight.combination_mode) {
+		u8 lbpc;
+
+		lbpc = level * 0xfe / panel->backlight.pwm_level_max + 1;
+		level /= lbpc;
+		pci_write_config_byte(to_pci_dev(dev_priv->drm.dev), LBPC, lbpc);
+	}
+
+	if (DISPLAY_VER(dev_priv) == 4) {
+		mask = BACKLIGHT_DUTY_CYCLE_MASK;
+	} else {
+		level <<= 1;
+		mask = BACKLIGHT_DUTY_CYCLE_MASK_PNV;
+	}
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_CTL) & ~mask;
+	intel_de_write(dev_priv, BLC_PWM_CTL, tmp | level);
+}
+
+static void vlv_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	enum pipe pipe = to_intel_crtc(conn_state->crtc)->pipe;
+	u32 tmp;
+
+	tmp = intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe)) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+	intel_de_write(dev_priv, VLV_BLC_PWM_CTL(pipe), tmp | level);
+}
+
+static void bxt_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	intel_de_write(dev_priv,
+		       BXT_BLC_PWM_DUTY(panel->backlight.controller), level);
+}
+
+static void ext_pwm_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_panel *panel = &to_intel_connector(conn_state->connector)->panel;
+
+	pwm_set_relative_duty_cycle(&panel->backlight.pwm_state, level, 100);
+	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
+}
+
+static void
+intel_panel_actually_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *i915 = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	drm_dbg_kms(&i915->drm, "set backlight level = %d\n", level);
+
+	panel->backlight.funcs->set(conn_state, level);
+}
+
+/* set backlight brightness to level in range [0..max], assuming hw min is
+ * respected.
+ */
+void intel_panel_set_backlight_acpi(const struct drm_connector_state *conn_state,
+				    u32 user_level, u32 user_max)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 hw_level;
+
+	/*
+	 * Lack of crtc may occur during driver init because
+	 * connection_mutex isn't held across the entire backlight
+	 * setup + modeset readout, and the BIOS can issue the
+	 * requests at any time.
+	 */
+	if (!panel->backlight.present || !conn_state->crtc)
+		return;
+
+	mutex_lock(&dev_priv->backlight_lock);
+
+	drm_WARN_ON(&dev_priv->drm, panel->backlight.max == 0);
+
+	hw_level = clamp_user_to_hw(connector, user_level, user_max);
+	panel->backlight.level = hw_level;
+
+	if (panel->backlight.device)
+		panel->backlight.device->props.brightness =
+			scale_hw_to_user(connector,
+					 panel->backlight.level,
+					 panel->backlight.device->props.max_brightness);
+
+	if (panel->backlight.enabled)
+		intel_panel_actually_set_backlight(conn_state, hw_level);
+
+	mutex_unlock(&dev_priv->backlight_lock);
+}
+
+static void lpt_disable_backlight(const struct drm_connector_state *old_conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, level);
+
+	/*
+	 * Although we don't support or enable CPU PWM with LPT/SPT based
+	 * systems, it may have been enabled prior to loading the
+	 * driver. Disable to avoid warnings on LCPLL disable.
+	 *
+	 * This needs rework if we need to add support for CPU PWM on PCH split
+	 * platforms.
+	 */
+	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
+	if (tmp & BLM_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "cpu backlight was enabled, disabling\n");
+		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2,
+			       tmp & ~BLM_PWM_ENABLE);
+	}
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, tmp & ~BLM_PCH_PWM_ENABLE);
+}
+
+static void pch_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, val);
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
+	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, tmp & ~BLM_PWM_ENABLE);
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, tmp & ~BLM_PCH_PWM_ENABLE);
+}
+
+static void i9xx_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	intel_panel_set_pwm_level(old_conn_state, val);
+}
+
+static void i965_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	struct drm_i915_private *dev_priv = to_i915(old_conn_state->connector->dev);
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, val);
+
+	tmp = intel_de_read(dev_priv, BLC_PWM_CTL2);
+	intel_de_write(dev_priv, BLC_PWM_CTL2, tmp & ~BLM_PWM_ENABLE);
+}
+
+static void vlv_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	enum pipe pipe = to_intel_crtc(old_conn_state->crtc)->pipe;
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, val);
+
+	tmp = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
+	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe),
+		       tmp & ~BLM_PWM_ENABLE);
+}
+
+static void bxt_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, val);
+
+	tmp = intel_de_read(dev_priv,
+			    BXT_BLC_PWM_CTL(panel->backlight.controller));
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       tmp & ~BXT_BLC_PWM_ENABLE);
+
+	if (panel->backlight.controller == 1) {
+		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
+		val &= ~UTIL_PIN_ENABLE;
+		intel_de_write(dev_priv, UTIL_PIN_CTL, val);
+	}
+}
+
+static void cnp_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 tmp;
+
+	intel_panel_set_pwm_level(old_conn_state, val);
+
+	tmp = intel_de_read(dev_priv,
+			    BXT_BLC_PWM_CTL(panel->backlight.controller));
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       tmp & ~BXT_BLC_PWM_ENABLE);
+}
+
+static void ext_pwm_disable_backlight(const struct drm_connector_state *old_conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	panel->backlight.pwm_state.enabled = false;
+	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
+}
+
+void intel_panel_disable_backlight(const struct drm_connector_state *old_conn_state)
+{
+	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	if (!panel->backlight.present)
+		return;
+
+	/*
+	 * Do not disable backlight on the vga_switcheroo path. When switching
+	 * away from i915, the other client may depend on i915 to handle the
+	 * backlight. This will leave the backlight on unnecessarily when
+	 * another client is not activated.
+	 */
+	if (dev_priv->drm.switch_power_state == DRM_SWITCH_POWER_CHANGING) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "Skipping backlight disable on vga switch\n");
+		return;
+	}
+
+	mutex_lock(&dev_priv->backlight_lock);
+
+	if (panel->backlight.device)
+		panel->backlight.device->props.power = FB_BLANK_POWERDOWN;
+	panel->backlight.enabled = false;
+	panel->backlight.funcs->disable(old_conn_state, 0);
+
+	mutex_unlock(&dev_priv->backlight_lock);
+}
+
+static void lpt_enable_backlight(const struct intel_crtc_state *crtc_state,
+				 const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 pch_ctl1, pch_ctl2, schicken;
+
+	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	if (pch_ctl1 & BLM_PCH_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "pch backlight already enabled\n");
+		pch_ctl1 &= ~BLM_PCH_PWM_ENABLE;
+		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
+	}
+
+	if (HAS_PCH_LPT(dev_priv)) {
+		schicken = intel_de_read(dev_priv, SOUTH_CHICKEN2);
+		if (panel->backlight.alternate_pwm_increment)
+			schicken |= LPT_PWM_GRANULARITY;
+		else
+			schicken &= ~LPT_PWM_GRANULARITY;
+		intel_de_write(dev_priv, SOUTH_CHICKEN2, schicken);
+	} else {
+		schicken = intel_de_read(dev_priv, SOUTH_CHICKEN1);
+		if (panel->backlight.alternate_pwm_increment)
+			schicken |= SPT_PWM_GRANULARITY;
+		else
+			schicken &= ~SPT_PWM_GRANULARITY;
+		intel_de_write(dev_priv, SOUTH_CHICKEN1, schicken);
+	}
+
+	pch_ctl2 = panel->backlight.pwm_level_max << 16;
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, pch_ctl2);
+
+	pch_ctl1 = 0;
+	if (panel->backlight.active_low_pwm)
+		pch_ctl1 |= BLM_PCH_POLARITY;
+
+	/* After LPT, override is the default. */
+	if (HAS_PCH_LPT(dev_priv))
+		pch_ctl1 |= BLM_PCH_OVERRIDE_ENABLE;
+
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
+	intel_de_posting_read(dev_priv, BLC_PWM_PCH_CTL1);
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
+		       pch_ctl1 | BLM_PCH_PWM_ENABLE);
+
+	/* This won't stick until the above enable. */
+	intel_panel_set_pwm_level(conn_state, level);
+}
+
+static void pch_enable_backlight(const struct intel_crtc_state *crtc_state,
+				 const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
+	u32 cpu_ctl2, pch_ctl1, pch_ctl2;
+
+	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
+	if (cpu_ctl2 & BLM_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "cpu backlight already enabled\n");
+		cpu_ctl2 &= ~BLM_PWM_ENABLE;
+		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2);
+	}
+
+	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	if (pch_ctl1 & BLM_PCH_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "pch backlight already enabled\n");
+		pch_ctl1 &= ~BLM_PCH_PWM_ENABLE;
+		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
+	}
+
+	if (cpu_transcoder == TRANSCODER_EDP)
+		cpu_ctl2 = BLM_TRANSCODER_EDP;
+	else
+		cpu_ctl2 = BLM_PIPE(cpu_transcoder);
+	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2);
+	intel_de_posting_read(dev_priv, BLC_PWM_CPU_CTL2);
+	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2 | BLM_PWM_ENABLE);
+
+	/* This won't stick until the above enable. */
+	intel_panel_set_pwm_level(conn_state, level);
+
+	pch_ctl2 = panel->backlight.pwm_level_max << 16;
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, pch_ctl2);
+
+	pch_ctl1 = 0;
+	if (panel->backlight.active_low_pwm)
+		pch_ctl1 |= BLM_PCH_POLARITY;
+
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
+	intel_de_posting_read(dev_priv, BLC_PWM_PCH_CTL1);
+	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
+		       pch_ctl1 | BLM_PCH_PWM_ENABLE);
+}
+
+static void i9xx_enable_backlight(const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 ctl, freq;
+
+	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
+	if (ctl & BACKLIGHT_DUTY_CYCLE_MASK_PNV) {
+		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
+		intel_de_write(dev_priv, BLC_PWM_CTL, 0);
+	}
+
+	freq = panel->backlight.pwm_level_max;
+	if (panel->backlight.combination_mode)
+		freq /= 0xff;
+
+	ctl = freq << 17;
+	if (panel->backlight.combination_mode)
+		ctl |= BLM_LEGACY_MODE;
+	if (IS_PINEVIEW(dev_priv) && panel->backlight.active_low_pwm)
+		ctl |= BLM_POLARITY_PNV;
+
+	intel_de_write(dev_priv, BLC_PWM_CTL, ctl);
+	intel_de_posting_read(dev_priv, BLC_PWM_CTL);
+
+	/* XXX: combine this into above write? */
+	intel_panel_set_pwm_level(conn_state, level);
+
+	/*
+	 * Needed to enable backlight on some 855gm models. BLC_HIST_CTL is
+	 * 855gm only, but checking for gen2 is safe, as 855gm is the only gen2
+	 * that has backlight.
+	 */
+	if (DISPLAY_VER(dev_priv) == 2)
+		intel_de_write(dev_priv, BLC_HIST_CTL, BLM_HISTOGRAM_ENABLE);
+}
+
+static void i965_enable_backlight(const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	enum pipe pipe = to_intel_crtc(conn_state->crtc)->pipe;
+	u32 ctl, ctl2, freq;
+
+	ctl2 = intel_de_read(dev_priv, BLC_PWM_CTL2);
+	if (ctl2 & BLM_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
+		ctl2 &= ~BLM_PWM_ENABLE;
+		intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2);
+	}
+
+	freq = panel->backlight.pwm_level_max;
+	if (panel->backlight.combination_mode)
+		freq /= 0xff;
+
+	ctl = freq << 16;
+	intel_de_write(dev_priv, BLC_PWM_CTL, ctl);
+
+	ctl2 = BLM_PIPE(pipe);
+	if (panel->backlight.combination_mode)
+		ctl2 |= BLM_COMBINATION_MODE;
+	if (panel->backlight.active_low_pwm)
+		ctl2 |= BLM_POLARITY_I965;
+	intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2);
+	intel_de_posting_read(dev_priv, BLC_PWM_CTL2);
+	intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2 | BLM_PWM_ENABLE);
+
+	intel_panel_set_pwm_level(conn_state, level);
+}
+
+static void vlv_enable_backlight(const struct intel_crtc_state *crtc_state,
+				 const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
+	u32 ctl, ctl2;
+
+	ctl2 = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
+	if (ctl2 & BLM_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
+		ctl2 &= ~BLM_PWM_ENABLE;
+		intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe), ctl2);
+	}
+
+	ctl = panel->backlight.pwm_level_max << 16;
+	intel_de_write(dev_priv, VLV_BLC_PWM_CTL(pipe), ctl);
+
+	/* XXX: combine this into above write? */
+	intel_panel_set_pwm_level(conn_state, level);
+
+	ctl2 = 0;
+	if (panel->backlight.active_low_pwm)
+		ctl2 |= BLM_POLARITY_I965;
+	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe), ctl2);
+	intel_de_posting_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
+	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe),
+		       ctl2 | BLM_PWM_ENABLE);
+}
+
+static void bxt_enable_backlight(const struct intel_crtc_state *crtc_state,
+				 const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
+	u32 pwm_ctl, val;
+
+	/* Controller 1 uses the utility pin. */
+	if (panel->backlight.controller == 1) {
+		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
+		if (val & UTIL_PIN_ENABLE) {
+			drm_dbg_kms(&dev_priv->drm,
+				    "util pin already enabled\n");
+			val &= ~UTIL_PIN_ENABLE;
+			intel_de_write(dev_priv, UTIL_PIN_CTL, val);
+		}
+
+		val = 0;
+		if (panel->backlight.util_pin_active_low)
+			val |= UTIL_PIN_POLARITY;
+		intel_de_write(dev_priv, UTIL_PIN_CTL,
+			       val | UTIL_PIN_PIPE(pipe) | UTIL_PIN_MODE_PWM | UTIL_PIN_ENABLE);
+	}
+
+	pwm_ctl = intel_de_read(dev_priv,
+				BXT_BLC_PWM_CTL(panel->backlight.controller));
+	if (pwm_ctl & BXT_BLC_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
+		pwm_ctl &= ~BXT_BLC_PWM_ENABLE;
+		intel_de_write(dev_priv,
+			       BXT_BLC_PWM_CTL(panel->backlight.controller),
+			       pwm_ctl);
+	}
+
+	intel_de_write(dev_priv,
+		       BXT_BLC_PWM_FREQ(panel->backlight.controller),
+		       panel->backlight.pwm_level_max);
+
+	intel_panel_set_pwm_level(conn_state, level);
+
+	pwm_ctl = 0;
+	if (panel->backlight.active_low_pwm)
+		pwm_ctl |= BXT_BLC_PWM_POLARITY;
+
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       pwm_ctl);
+	intel_de_posting_read(dev_priv,
+			      BXT_BLC_PWM_CTL(panel->backlight.controller));
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       pwm_ctl | BXT_BLC_PWM_ENABLE);
+}
+
+static void cnp_enable_backlight(const struct intel_crtc_state *crtc_state,
+				 const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 pwm_ctl;
+
+	pwm_ctl = intel_de_read(dev_priv,
+				BXT_BLC_PWM_CTL(panel->backlight.controller));
+	if (pwm_ctl & BXT_BLC_PWM_ENABLE) {
+		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
+		pwm_ctl &= ~BXT_BLC_PWM_ENABLE;
+		intel_de_write(dev_priv,
+			       BXT_BLC_PWM_CTL(panel->backlight.controller),
+			       pwm_ctl);
+	}
+
+	intel_de_write(dev_priv,
+		       BXT_BLC_PWM_FREQ(panel->backlight.controller),
+		       panel->backlight.pwm_level_max);
+
+	intel_panel_set_pwm_level(conn_state, level);
+
+	pwm_ctl = 0;
+	if (panel->backlight.active_low_pwm)
+		pwm_ctl |= BXT_BLC_PWM_POLARITY;
+
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       pwm_ctl);
+	intel_de_posting_read(dev_priv,
+			      BXT_BLC_PWM_CTL(panel->backlight.controller));
+	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
+		       pwm_ctl | BXT_BLC_PWM_ENABLE);
+}
+
+static void ext_pwm_enable_backlight(const struct intel_crtc_state *crtc_state,
+				     const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	pwm_set_relative_duty_cycle(&panel->backlight.pwm_state, level, 100);
+	panel->backlight.pwm_state.enabled = true;
+	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
+}
+
+static void __intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
+					   const struct drm_connector_state *conn_state)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	WARN_ON(panel->backlight.max == 0);
+
+	if (panel->backlight.level <= panel->backlight.min) {
+		panel->backlight.level = panel->backlight.max;
+		if (panel->backlight.device)
+			panel->backlight.device->props.brightness =
+				scale_hw_to_user(connector,
+						 panel->backlight.level,
+						 panel->backlight.device->props.max_brightness);
+	}
+
+	panel->backlight.funcs->enable(crtc_state, conn_state, panel->backlight.level);
+	panel->backlight.enabled = true;
+	if (panel->backlight.device)
+		panel->backlight.device->props.power = FB_BLANK_UNBLANK;
+}
+
+void intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
+
+	if (!panel->backlight.present)
+		return;
+
+	drm_dbg_kms(&dev_priv->drm, "pipe %c\n", pipe_name(pipe));
+
+	mutex_lock(&dev_priv->backlight_lock);
+
+	__intel_panel_enable_backlight(crtc_state, conn_state);
+
+	mutex_unlock(&dev_priv->backlight_lock);
+}
+
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
+static u32 intel_panel_get_backlight(struct intel_connector *connector)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 val = 0;
+
+	mutex_lock(&dev_priv->backlight_lock);
+
+	if (panel->backlight.enabled)
+		val = panel->backlight.funcs->get(connector, intel_connector_get_pipe(connector));
+
+	mutex_unlock(&dev_priv->backlight_lock);
+
+	drm_dbg_kms(&dev_priv->drm, "get backlight PWM = %d\n", val);
+	return val;
+}
+
+/* Scale user_level in range [0..user_max] to [hw_min..hw_max]. */
+static u32 scale_user_to_hw(struct intel_connector *connector,
+			    u32 user_level, u32 user_max)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	return scale(user_level, 0, user_max,
+		     panel->backlight.min, panel->backlight.max);
+}
+
+/* set backlight brightness to level in range [0..max], scaling wrt hw min */
+static void intel_panel_set_backlight(const struct drm_connector_state *conn_state,
+				      u32 user_level, u32 user_max)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 hw_level;
+
+	if (!panel->backlight.present)
+		return;
+
+	mutex_lock(&dev_priv->backlight_lock);
+
+	drm_WARN_ON(&dev_priv->drm, panel->backlight.max == 0);
+
+	hw_level = scale_user_to_hw(connector, user_level, user_max);
+	panel->backlight.level = hw_level;
+
+	if (panel->backlight.enabled)
+		intel_panel_actually_set_backlight(conn_state, hw_level);
+
+	mutex_unlock(&dev_priv->backlight_lock);
+}
+
+static int intel_backlight_device_update_status(struct backlight_device *bd)
+{
+	struct intel_connector *connector = bl_get_data(bd);
+	struct intel_panel *panel = &connector->panel;
+	struct drm_device *dev = connector->base.dev;
+
+	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+	DRM_DEBUG_KMS("updating intel_backlight, brightness=%d/%d\n",
+		      bd->props.brightness, bd->props.max_brightness);
+	intel_panel_set_backlight(connector->base.state, bd->props.brightness,
+				  bd->props.max_brightness);
+
+	/*
+	 * Allow flipping bl_power as a sub-state of enabled. Sadly the
+	 * backlight class device does not make it easy to differentiate
+	 * between callbacks for brightness and bl_power, so our backlight_power
+	 * callback needs to take this into account.
+	 */
+	if (panel->backlight.enabled) {
+		if (panel->backlight.power) {
+			bool enable = bd->props.power == FB_BLANK_UNBLANK &&
+				bd->props.brightness != 0;
+			panel->backlight.power(connector, enable);
+		}
+	} else {
+		bd->props.power = FB_BLANK_POWERDOWN;
+	}
+
+	drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	return 0;
+}
+
+static int intel_backlight_device_get_brightness(struct backlight_device *bd)
+{
+	struct intel_connector *connector = bl_get_data(bd);
+	struct drm_device *dev = connector->base.dev;
+	struct drm_i915_private *dev_priv = to_i915(dev);
+	intel_wakeref_t wakeref;
+	int ret = 0;
+
+	with_intel_runtime_pm(&dev_priv->runtime_pm, wakeref) {
+		u32 hw_level;
+
+		drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+
+		hw_level = intel_panel_get_backlight(connector);
+		ret = scale_hw_to_user(connector,
+				       hw_level, bd->props.max_brightness);
+
+		drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	}
+
+	return ret;
+}
+
+static const struct backlight_ops intel_backlight_device_ops = {
+	.update_status = intel_backlight_device_update_status,
+	.get_brightness = intel_backlight_device_get_brightness,
+};
+
+int intel_backlight_device_register(struct intel_connector *connector)
+{
+	struct drm_i915_private *i915 = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	struct backlight_properties props;
+	struct backlight_device *bd;
+	const char *name;
+	int ret = 0;
+
+	if (WARN_ON(panel->backlight.device))
+		return -ENODEV;
+
+	if (!panel->backlight.present)
+		return 0;
+
+	WARN_ON(panel->backlight.max == 0);
+
+	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
+
+	/*
+	 * Note: Everything should work even if the backlight device max
+	 * presented to the userspace is arbitrarily chosen.
+	 */
+	props.max_brightness = panel->backlight.max;
+	props.brightness = scale_hw_to_user(connector,
+					    panel->backlight.level,
+					    props.max_brightness);
+
+	if (panel->backlight.enabled)
+		props.power = FB_BLANK_UNBLANK;
+	else
+		props.power = FB_BLANK_POWERDOWN;
+
+	name = kstrdup("intel_backlight", GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	bd = backlight_device_get_by_name(name);
+	if (bd) {
+		put_device(&bd->dev);
+		/*
+		 * Using the same name independent of the drm device or connector
+		 * prevents registration of multiple backlight devices in the
+		 * driver. However, we need to use the default name for backward
+		 * compatibility. Use unique names for subsequent backlight devices as a
+		 * fallback when the default name already exists.
+		 */
+		kfree(name);
+		name = kasprintf(GFP_KERNEL, "card%d-%s-backlight",
+				 i915->drm.primary->index, connector->base.name);
+		if (!name)
+			return -ENOMEM;
+	}
+	bd = backlight_device_register(name, connector->base.kdev, connector,
+				       &intel_backlight_device_ops, &props);
+
+	if (IS_ERR(bd)) {
+		drm_err(&i915->drm,
+			"[CONNECTOR:%d:%s] backlight device %s register failed: %ld\n",
+			connector->base.base.id, connector->base.name, name, PTR_ERR(bd));
+		ret = PTR_ERR(bd);
+		goto out;
+	}
+
+	panel->backlight.device = bd;
+
+	drm_dbg_kms(&i915->drm,
+		    "[CONNECTOR:%d:%s] backlight device %s registered\n",
+		    connector->base.base.id, connector->base.name, name);
+
+out:
+	kfree(name);
+
+	return ret;
+}
+
+void intel_backlight_device_unregister(struct intel_connector *connector)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	if (panel->backlight.device) {
+		backlight_device_unregister(panel->backlight.device);
+		panel->backlight.device = NULL;
+	}
+}
+#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+
+/*
+ * CNP: PWM clock frequency is 19.2 MHz or 24 MHz.
+ *      PWM increment = 1
+ */
+static u32 cnp_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(dev_priv)->rawclk_freq),
+				 pwm_freq_hz);
+}
+
+/*
+ * BXT: PWM clock frequency = 19.2 MHz.
+ */
+static u32 bxt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	return DIV_ROUND_CLOSEST(KHz(19200), pwm_freq_hz);
+}
+
+/*
+ * SPT: This value represents the period of the PWM stream in clock periods
+ * multiplied by 16 (default increment) or 128 (alternate increment selected in
+ * SCHICKEN_1 bit 0). PWM clock is 24 MHz.
+ */
+static u32 spt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct intel_panel *panel = &connector->panel;
+	u32 mul;
+
+	if (panel->backlight.alternate_pwm_increment)
+		mul = 128;
+	else
+		mul = 16;
+
+	return DIV_ROUND_CLOSEST(MHz(24), pwm_freq_hz * mul);
+}
+
+/*
+ * LPT: This value represents the period of the PWM stream in clock periods
+ * multiplied by 128 (default increment) or 16 (alternate increment, selected in
+ * LPT SOUTH_CHICKEN2 register bit 5).
+ */
+static u32 lpt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 mul, clock;
+
+	if (panel->backlight.alternate_pwm_increment)
+		mul = 16;
+	else
+		mul = 128;
+
+	if (HAS_PCH_LPT_H(dev_priv))
+		clock = MHz(135); /* LPT:H */
+	else
+		clock = MHz(24); /* LPT:LP */
+
+	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * mul);
+}
+
+/*
+ * ILK/SNB/IVB: This value represents the period of the PWM stream in PCH
+ * display raw clocks multiplied by 128.
+ */
+static u32 pch_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(dev_priv)->rawclk_freq),
+				 pwm_freq_hz * 128);
+}
+
+/*
+ * Gen2: This field determines the number of time base events (display core
+ * clock frequency/32) in total for a complete cycle of modulated backlight
+ * control.
+ *
+ * Gen3: A time base event equals the display core clock ([DevPNV] HRAW clock)
+ * divided by 32.
+ */
+static u32 i9xx_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	int clock;
+
+	if (IS_PINEVIEW(dev_priv))
+		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
+	else
+		clock = KHz(dev_priv->cdclk.hw.cdclk);
+
+	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * 32);
+}
+
+/*
+ * Gen4: This value represents the period of the PWM stream in display core
+ * clocks ([DevCTG] HRAW clocks) multiplied by 128.
+ *
+ */
+static u32 i965_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	int clock;
+
+	if (IS_G4X(dev_priv))
+		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
+	else
+		clock = KHz(dev_priv->cdclk.hw.cdclk);
+
+	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * 128);
+}
+
+/*
+ * VLV: This value represents the period of the PWM stream in display core
+ * clocks ([DevCTG] 200MHz HRAW clocks) multiplied by 128 or 25MHz S0IX clocks
+ * multiplied by 16. CHV uses a 19.2MHz S0IX clock.
+ */
+static u32 vlv_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	int mul, clock;
+
+	if ((intel_de_read(dev_priv, CBR1_VLV) & CBR_PWM_CLOCK_MUX_SELECT) == 0) {
+		if (IS_CHERRYVIEW(dev_priv))
+			clock = KHz(19200);
+		else
+			clock = MHz(25);
+		mul = 16;
+	} else {
+		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
+		mul = 128;
+	}
+
+	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * mul);
+}
+
+static u16 get_vbt_pwm_freq(struct drm_i915_private *dev_priv)
+{
+	u16 pwm_freq_hz = dev_priv->vbt.backlight.pwm_freq_hz;
+
+	if (pwm_freq_hz) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "VBT defined backlight frequency %u Hz\n",
+			    pwm_freq_hz);
+	} else {
+		pwm_freq_hz = 200;
+		drm_dbg_kms(&dev_priv->drm,
+			    "default backlight frequency %u Hz\n",
+			    pwm_freq_hz);
+	}
+
+	return pwm_freq_hz;
+}
+
+static u32 get_backlight_max_vbt(struct intel_connector *connector)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u16 pwm_freq_hz = get_vbt_pwm_freq(dev_priv);
+	u32 pwm;
+
+	if (!panel->backlight.pwm_funcs->hz_to_pwm) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "backlight frequency conversion not supported\n");
+		return 0;
+	}
+
+	pwm = panel->backlight.pwm_funcs->hz_to_pwm(connector, pwm_freq_hz);
+	if (!pwm) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "backlight frequency conversion failed\n");
+		return 0;
+	}
+
+	return pwm;
+}
+
+/*
+ * Note: The setup hooks can't assume pipe is set!
+ */
+static u32 get_backlight_min_vbt(struct intel_connector *connector)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	int min;
+
+	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
+
+	/*
+	 * XXX: If the vbt value is 255, it makes min equal to max, which leads
+	 * to problems. There are such machines out there. Either our
+	 * interpretation is wrong or the vbt has bogus data. Or both. Safeguard
+	 * against this by letting the minimum be at most (arbitrarily chosen)
+	 * 25% of the max.
+	 */
+	min = clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
+	if (min != dev_priv->vbt.backlight.min_brightness) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "clamping VBT min backlight %d/255 to %d/255\n",
+			    dev_priv->vbt.backlight.min_brightness, min);
+	}
+
+	/* vbt value is a coefficient in range [0..255] */
+	return scale(min, 0, 255, 0, panel->backlight.pwm_level_max);
+}
+
+static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 cpu_ctl2, pch_ctl1, pch_ctl2, val;
+	bool alt, cpu_mode;
+
+	if (HAS_PCH_LPT(dev_priv))
+		alt = intel_de_read(dev_priv, SOUTH_CHICKEN2) & LPT_PWM_GRANULARITY;
+	else
+		alt = intel_de_read(dev_priv, SOUTH_CHICKEN1) & SPT_PWM_GRANULARITY;
+	panel->backlight.alternate_pwm_increment = alt;
+
+	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	panel->backlight.active_low_pwm = pch_ctl1 & BLM_PCH_POLARITY;
+
+	pch_ctl2 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2);
+	panel->backlight.pwm_level_max = pch_ctl2 >> 16;
+
+	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	panel->backlight.pwm_enabled = pch_ctl1 & BLM_PCH_PWM_ENABLE;
+
+	cpu_mode = panel->backlight.pwm_enabled && HAS_PCH_LPT(dev_priv) &&
+		   !(pch_ctl1 & BLM_PCH_OVERRIDE_ENABLE) &&
+		   (cpu_ctl2 & BLM_PWM_ENABLE);
+
+	if (cpu_mode) {
+		val = pch_get_backlight(connector, unused);
+
+		drm_dbg_kms(&dev_priv->drm,
+			    "CPU backlight register was enabled, switching to PCH override\n");
+
+		/* Write converted CPU PWM value to PCH override register */
+		lpt_set_backlight(connector->base.state, val);
+		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
+			       pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
+
+		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2,
+			       cpu_ctl2 & ~BLM_PWM_ENABLE);
+	}
+
+	return 0;
+}
+
+static int pch_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 cpu_ctl2, pch_ctl1, pch_ctl2;
+
+	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
+	panel->backlight.active_low_pwm = pch_ctl1 & BLM_PCH_POLARITY;
+
+	pch_ctl2 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2);
+	panel->backlight.pwm_level_max = pch_ctl2 >> 16;
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
+	panel->backlight.pwm_enabled = (cpu_ctl2 & BLM_PWM_ENABLE) &&
+		(pch_ctl1 & BLM_PCH_PWM_ENABLE);
+
+	return 0;
+}
+
+static int i9xx_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 ctl, val;
+
+	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
+
+	if (DISPLAY_VER(dev_priv) == 2 || IS_I915GM(dev_priv) || IS_I945GM(dev_priv))
+		panel->backlight.combination_mode = ctl & BLM_LEGACY_MODE;
+
+	if (IS_PINEVIEW(dev_priv))
+		panel->backlight.active_low_pwm = ctl & BLM_POLARITY_PNV;
+
+	panel->backlight.pwm_level_max = ctl >> 17;
+
+	if (!panel->backlight.pwm_level_max) {
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+		panel->backlight.pwm_level_max >>= 1;
+	}
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	if (panel->backlight.combination_mode)
+		panel->backlight.pwm_level_max *= 0xff;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	val = i9xx_get_backlight(connector, unused);
+	val = intel_panel_invert_pwm_level(connector, val);
+	val = clamp(val, panel->backlight.pwm_level_min, panel->backlight.pwm_level_max);
+
+	panel->backlight.pwm_enabled = val != 0;
+
+	return 0;
+}
+
+static int i965_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 ctl, ctl2;
+
+	ctl2 = intel_de_read(dev_priv, BLC_PWM_CTL2);
+	panel->backlight.combination_mode = ctl2 & BLM_COMBINATION_MODE;
+	panel->backlight.active_low_pwm = ctl2 & BLM_POLARITY_I965;
+
+	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
+	panel->backlight.pwm_level_max = ctl >> 16;
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	if (panel->backlight.combination_mode)
+		panel->backlight.pwm_level_max *= 0xff;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	panel->backlight.pwm_enabled = ctl2 & BLM_PWM_ENABLE;
+
+	return 0;
+}
+
+static int vlv_setup_backlight(struct intel_connector *connector, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 ctl, ctl2;
+
+	if (drm_WARN_ON(&dev_priv->drm, pipe != PIPE_A && pipe != PIPE_B))
+		return -ENODEV;
+
+	ctl2 = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
+	panel->backlight.active_low_pwm = ctl2 & BLM_POLARITY_I965;
+
+	ctl = intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe));
+	panel->backlight.pwm_level_max = ctl >> 16;
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	panel->backlight.pwm_enabled = ctl2 & BLM_PWM_ENABLE;
+
+	return 0;
+}
+
+static int
+bxt_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 pwm_ctl, val;
+
+	panel->backlight.controller = dev_priv->vbt.backlight.controller;
+
+	pwm_ctl = intel_de_read(dev_priv,
+				BXT_BLC_PWM_CTL(panel->backlight.controller));
+
+	/* Controller 1 uses the utility pin. */
+	if (panel->backlight.controller == 1) {
+		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
+		panel->backlight.util_pin_active_low =
+					val & UTIL_PIN_POLARITY;
+	}
+
+	panel->backlight.active_low_pwm = pwm_ctl & BXT_BLC_PWM_POLARITY;
+	panel->backlight.pwm_level_max =
+		intel_de_read(dev_priv, BXT_BLC_PWM_FREQ(panel->backlight.controller));
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	panel->backlight.pwm_enabled = pwm_ctl & BXT_BLC_PWM_ENABLE;
+
+	return 0;
+}
+
+static int
+cnp_setup_backlight(struct intel_connector *connector, enum pipe unused)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+	u32 pwm_ctl;
+
+	/*
+	 * CNP has the BXT implementation of backlight, but with only one
+	 * controller. TODO: ICP has multiple controllers but we only use
+	 * controller 0 for now.
+	 */
+	panel->backlight.controller = 0;
+
+	pwm_ctl = intel_de_read(dev_priv,
+				BXT_BLC_PWM_CTL(panel->backlight.controller));
+
+	panel->backlight.active_low_pwm = pwm_ctl & BXT_BLC_PWM_POLARITY;
+	panel->backlight.pwm_level_max =
+		intel_de_read(dev_priv, BXT_BLC_PWM_FREQ(panel->backlight.controller));
+
+	if (!panel->backlight.pwm_level_max)
+		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
+
+	if (!panel->backlight.pwm_level_max)
+		return -ENODEV;
+
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	panel->backlight.pwm_enabled = pwm_ctl & BXT_BLC_PWM_ENABLE;
+
+	return 0;
+}
+
+static int ext_pwm_setup_backlight(struct intel_connector *connector,
+				   enum pipe pipe)
+{
+	struct drm_device *dev = connector->base.dev;
+	struct drm_i915_private *dev_priv = to_i915(dev);
+	struct intel_panel *panel = &connector->panel;
+	const char *desc;
+	u32 level;
+
+	/* Get the right PWM chip for DSI backlight according to VBT */
+	if (dev_priv->vbt.dsi.config->pwm_blc == PPS_BLC_PMIC) {
+		panel->backlight.pwm = pwm_get(dev->dev, "pwm_pmic_backlight");
+		desc = "PMIC";
+	} else {
+		panel->backlight.pwm = pwm_get(dev->dev, "pwm_soc_backlight");
+		desc = "SoC";
+	}
+
+	if (IS_ERR(panel->backlight.pwm)) {
+		drm_err(&dev_priv->drm, "Failed to get the %s PWM chip\n",
+			desc);
+		panel->backlight.pwm = NULL;
+		return -ENODEV;
+	}
+
+	panel->backlight.pwm_level_max = 100; /* 100% */
+	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
+
+	if (pwm_is_enabled(panel->backlight.pwm)) {
+		/* PWM is already enabled, use existing settings */
+		pwm_get_state(panel->backlight.pwm, &panel->backlight.pwm_state);
+
+		level = pwm_get_relative_duty_cycle(&panel->backlight.pwm_state,
+						    100);
+		level = intel_panel_invert_pwm_level(connector, level);
+		panel->backlight.pwm_enabled = true;
+
+		drm_dbg_kms(&dev_priv->drm, "PWM already enabled at freq %ld, VBT freq %d, level %d\n",
+			    NSEC_PER_SEC / (unsigned long)panel->backlight.pwm_state.period,
+			    get_vbt_pwm_freq(dev_priv), level);
+	} else {
+		/* Set period from VBT frequency, leave other settings at 0. */
+		panel->backlight.pwm_state.period =
+			NSEC_PER_SEC / get_vbt_pwm_freq(dev_priv);
+	}
+
+	drm_info(&dev_priv->drm, "Using %s PWM for LCD backlight control\n",
+		 desc);
+	return 0;
+}
+
+static void intel_pwm_set_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	panel->backlight.pwm_funcs->set(conn_state,
+				       intel_panel_invert_pwm_level(connector, level));
+}
+
+static u32 intel_pwm_get_backlight(struct intel_connector *connector, enum pipe pipe)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	return intel_panel_invert_pwm_level(connector,
+					    panel->backlight.pwm_funcs->get(connector, pipe));
+}
+
+static void intel_pwm_enable_backlight(const struct intel_crtc_state *crtc_state,
+				       const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	panel->backlight.pwm_funcs->enable(crtc_state, conn_state,
+					   intel_panel_invert_pwm_level(connector, level));
+}
+
+static void intel_pwm_disable_backlight(const struct drm_connector_state *conn_state, u32 level)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct intel_panel *panel = &connector->panel;
+
+	panel->backlight.pwm_funcs->disable(conn_state,
+					    intel_panel_invert_pwm_level(connector, level));
+}
+
+static int intel_pwm_setup_backlight(struct intel_connector *connector, enum pipe pipe)
+{
+	struct intel_panel *panel = &connector->panel;
+	int ret = panel->backlight.pwm_funcs->setup(connector, pipe);
+
+	if (ret < 0)
+		return ret;
+
+	panel->backlight.min = panel->backlight.pwm_level_min;
+	panel->backlight.max = panel->backlight.pwm_level_max;
+	panel->backlight.level = intel_pwm_get_backlight(connector, pipe);
+	panel->backlight.enabled = panel->backlight.pwm_enabled;
+
+	return 0;
+}
+
+void intel_panel_update_backlight(struct intel_atomic_state *state,
+				  struct intel_encoder *encoder,
+				  const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state)
+{
+	struct intel_connector *connector = to_intel_connector(conn_state->connector);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_panel *panel = &connector->panel;
+
+	if (!panel->backlight.present)
+		return;
+
+	mutex_lock(&dev_priv->backlight_lock);
+	if (!panel->backlight.enabled)
+		__intel_panel_enable_backlight(crtc_state, conn_state);
+
+	mutex_unlock(&dev_priv->backlight_lock);
+}
+
+int intel_panel_setup_backlight(struct drm_connector *connector, enum pipe pipe)
+{
+	struct drm_i915_private *dev_priv = to_i915(connector->dev);
+	struct intel_connector *intel_connector = to_intel_connector(connector);
+	struct intel_panel *panel = &intel_connector->panel;
+	int ret;
+
+	if (!dev_priv->vbt.backlight.present) {
+		if (dev_priv->quirks & QUIRK_BACKLIGHT_PRESENT) {
+			drm_dbg_kms(&dev_priv->drm,
+				    "no backlight present per VBT, but present per quirk\n");
+		} else {
+			drm_dbg_kms(&dev_priv->drm,
+				    "no backlight present per VBT\n");
+			return 0;
+		}
+	}
+
+	/* ensure intel_panel has been initialized first */
+	if (drm_WARN_ON(&dev_priv->drm, !panel->backlight.funcs))
+		return -ENODEV;
+
+	/* set level and max in panel struct */
+	mutex_lock(&dev_priv->backlight_lock);
+	ret = panel->backlight.funcs->setup(intel_connector, pipe);
+	mutex_unlock(&dev_priv->backlight_lock);
+
+	if (ret) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "failed to setup backlight for connector %s\n",
+			    connector->name);
+		return ret;
+	}
+
+	panel->backlight.present = true;
+
+	drm_dbg_kms(&dev_priv->drm,
+		    "Connector %s backlight initialized, %s, brightness %u/%u\n",
+		    connector->name,
+		    enableddisabled(panel->backlight.enabled),
+		    panel->backlight.level, panel->backlight.max);
+
+	return 0;
+}
+
+void intel_panel_destroy_backlight(struct intel_panel *panel)
+{
+	/* dispose of the pwm */
+	if (panel->backlight.pwm)
+		pwm_put(panel->backlight.pwm);
+
+	panel->backlight.present = false;
+}
+
+static const struct intel_panel_bl_funcs bxt_pwm_funcs = {
+	.setup = bxt_setup_backlight,
+	.enable = bxt_enable_backlight,
+	.disable = bxt_disable_backlight,
+	.set = bxt_set_backlight,
+	.get = bxt_get_backlight,
+	.hz_to_pwm = bxt_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs cnp_pwm_funcs = {
+	.setup = cnp_setup_backlight,
+	.enable = cnp_enable_backlight,
+	.disable = cnp_disable_backlight,
+	.set = bxt_set_backlight,
+	.get = bxt_get_backlight,
+	.hz_to_pwm = cnp_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs lpt_pwm_funcs = {
+	.setup = lpt_setup_backlight,
+	.enable = lpt_enable_backlight,
+	.disable = lpt_disable_backlight,
+	.set = lpt_set_backlight,
+	.get = lpt_get_backlight,
+	.hz_to_pwm = lpt_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs spt_pwm_funcs = {
+	.setup = lpt_setup_backlight,
+	.enable = lpt_enable_backlight,
+	.disable = lpt_disable_backlight,
+	.set = lpt_set_backlight,
+	.get = lpt_get_backlight,
+	.hz_to_pwm = spt_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs pch_pwm_funcs = {
+	.setup = pch_setup_backlight,
+	.enable = pch_enable_backlight,
+	.disable = pch_disable_backlight,
+	.set = pch_set_backlight,
+	.get = pch_get_backlight,
+	.hz_to_pwm = pch_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs ext_pwm_funcs = {
+	.setup = ext_pwm_setup_backlight,
+	.enable = ext_pwm_enable_backlight,
+	.disable = ext_pwm_disable_backlight,
+	.set = ext_pwm_set_backlight,
+	.get = ext_pwm_get_backlight,
+};
+
+static const struct intel_panel_bl_funcs vlv_pwm_funcs = {
+	.setup = vlv_setup_backlight,
+	.enable = vlv_enable_backlight,
+	.disable = vlv_disable_backlight,
+	.set = vlv_set_backlight,
+	.get = vlv_get_backlight,
+	.hz_to_pwm = vlv_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs i965_pwm_funcs = {
+	.setup = i965_setup_backlight,
+	.enable = i965_enable_backlight,
+	.disable = i965_disable_backlight,
+	.set = i9xx_set_backlight,
+	.get = i9xx_get_backlight,
+	.hz_to_pwm = i965_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs i9xx_pwm_funcs = {
+	.setup = i9xx_setup_backlight,
+	.enable = i9xx_enable_backlight,
+	.disable = i9xx_disable_backlight,
+	.set = i9xx_set_backlight,
+	.get = i9xx_get_backlight,
+	.hz_to_pwm = i9xx_hz_to_pwm,
+};
+
+static const struct intel_panel_bl_funcs pwm_bl_funcs = {
+	.setup = intel_pwm_setup_backlight,
+	.enable = intel_pwm_enable_backlight,
+	.disable = intel_pwm_disable_backlight,
+	.set = intel_pwm_set_backlight,
+	.get = intel_pwm_get_backlight,
+};
+
+/* Set up chip specific backlight functions */
+void
+intel_panel_init_backlight_funcs(struct intel_panel *panel)
+{
+	struct intel_connector *connector =
+		container_of(panel, struct intel_connector, panel);
+	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+
+	if (connector->base.connector_type == DRM_MODE_CONNECTOR_DSI &&
+	    intel_dsi_dcs_init_backlight_funcs(connector) == 0)
+		return;
+
+	if (IS_GEMINILAKE(dev_priv) || IS_BROXTON(dev_priv)) {
+		panel->backlight.pwm_funcs = &bxt_pwm_funcs;
+	} else if (INTEL_PCH_TYPE(dev_priv) >= PCH_CNP) {
+		panel->backlight.pwm_funcs = &cnp_pwm_funcs;
+	} else if (INTEL_PCH_TYPE(dev_priv) >= PCH_LPT) {
+		if (HAS_PCH_LPT(dev_priv))
+			panel->backlight.pwm_funcs = &lpt_pwm_funcs;
+		else
+			panel->backlight.pwm_funcs = &spt_pwm_funcs;
+	} else if (HAS_PCH_SPLIT(dev_priv)) {
+		panel->backlight.pwm_funcs = &pch_pwm_funcs;
+	} else if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) {
+		if (connector->base.connector_type == DRM_MODE_CONNECTOR_DSI) {
+			panel->backlight.pwm_funcs = &ext_pwm_funcs;
+		} else {
+			panel->backlight.pwm_funcs = &vlv_pwm_funcs;
+		}
+	} else if (DISPLAY_VER(dev_priv) == 4) {
+		panel->backlight.pwm_funcs = &i965_pwm_funcs;
+	} else {
+		panel->backlight.pwm_funcs = &i9xx_pwm_funcs;
+	}
+
+	if (connector->base.connector_type == DRM_MODE_CONNECTOR_eDP &&
+	    intel_dp_aux_init_backlight_funcs(connector) == 0)
+		return;
+
+	/* We're using a standard PWM backlight interface */
+	panel->backlight.funcs = &pwm_bl_funcs;
+}
diff --git a/drivers/gpu/drm/i915/display/intel_backlight.h b/drivers/gpu/drm/i915/display/intel_backlight.h
new file mode 100644
index 000000000000..282020cb47d5
--- /dev/null
+++ b/drivers/gpu/drm/i915/display/intel_backlight.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#ifndef __INTEL_BACKLIGHT_H__
+#define __INTEL_BACKLIGHT_H__
+
+#include <linux/types.h>
+
+struct drm_connector;
+struct drm_connector_state;
+struct intel_atomic_state;
+struct intel_connector;
+struct intel_crtc_state;
+struct intel_encoder;
+struct intel_panel;
+enum pipe;
+
+void intel_panel_init_backlight_funcs(struct intel_panel *panel);
+void intel_panel_destroy_backlight(struct intel_panel *panel);
+void intel_panel_set_backlight_acpi(const struct drm_connector_state *conn_state,
+				    u32 level, u32 max);
+int intel_panel_setup_backlight(struct drm_connector *connector,
+				enum pipe pipe);
+void intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state);
+void intel_panel_update_backlight(struct intel_atomic_state *state,
+				  struct intel_encoder *encoder,
+				  const struct intel_crtc_state *crtc_state,
+				  const struct drm_connector_state *conn_state);
+void intel_panel_disable_backlight(const struct drm_connector_state *old_conn_state);
+void intel_panel_set_pwm_level(const struct drm_connector_state *conn_state, u32 level);
+u32 intel_panel_invert_pwm_level(struct intel_connector *connector, u32 level);
+u32 intel_panel_backlight_level_to_pwm(struct intel_connector *connector, u32 level);
+u32 intel_panel_backlight_level_from_pwm(struct intel_connector *connector, u32 val);
+
+#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
+int intel_backlight_device_register(struct intel_connector *connector);
+void intel_backlight_device_unregister(struct intel_connector *connector);
+#else /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+static inline int intel_backlight_device_register(struct intel_connector *connector)
+{
+	return 0;
+}
+static inline void intel_backlight_device_unregister(struct intel_connector *connector)
+{
+}
+#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+
+#endif /* __INTEL_BACKLIGHT_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_connector.c b/drivers/gpu/drm/i915/display/intel_connector.c
index 9bed1ccecea0..4f49d782eca2 100644
--- a/drivers/gpu/drm/i915/display/intel_connector.c
+++ b/drivers/gpu/drm/i915/display/intel_connector.c
@@ -29,13 +29,13 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_edid.h>
 
-#include "display/intel_panel.h"
-
 #include "i915_drv.h"
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_display_debugfs.h"
 #include "intel_display_types.h"
 #include "intel_hdcp.h"
+#include "intel_panel.h"
 
 int intel_connector_init(struct intel_connector *connector)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index f61901e26409..68489c729830 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -29,6 +29,7 @@
 
 #include "i915_drv.h"
 #include "intel_audio.h"
+#include "intel_backlight.h"
 #include "intel_combo_phy.h"
 #include "intel_connector.h"
 #include "intel_crtc.h"
@@ -49,7 +50,6 @@
 #include "intel_hdmi.h"
 #include "intel_hotplug.h"
 #include "intel_lspcon.h"
-#include "intel_panel.h"
 #include "intel_pps.h"
 #include "intel_psr.h"
 #include "intel_snps_phy.h"
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 631cf7d4323c..f87e4d510ea5 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -45,6 +45,7 @@
 #include "i915_drv.h"
 #include "intel_atomic.h"
 #include "intel_audio.h"
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_ddi.h"
 #include "intel_de.h"
diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index e7b90863aa43..0a77f0e48aa1 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -34,10 +34,10 @@
  * for some reason.
  */
 
+#include "intel_backlight.h"
 #include "intel_display_types.h"
 #include "intel_dp.h"
 #include "intel_dp_aux_backlight.h"
-#include "intel_panel.h"
 
 /* TODO:
  * Implement HDR, right now we just implement the bare minimum to bring us back into SDR mode so we
diff --git a/drivers/gpu/drm/i915/display/intel_lvds.c b/drivers/gpu/drm/i915/display/intel_lvds.c
index e0381b0fce91..8f5741ebd58d 100644
--- a/drivers/gpu/drm/i915/display/intel_lvds.c
+++ b/drivers/gpu/drm/i915/display/intel_lvds.c
@@ -40,6 +40,7 @@
 
 #include "i915_drv.h"
 #include "intel_atomic.h"
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_de.h"
 #include "intel_display_types.h"
diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index f7f49b69830f..aad5c1cd3898 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -30,10 +30,9 @@
 #include <linux/firmware.h>
 #include <acpi/video.h>
 
-#include "display/intel_panel.h"
-
 #include "i915_drv.h"
 #include "intel_acpi.h"
+#include "intel_backlight.h"
 #include "intel_display_types.h"
 #include "intel_opregion.h"
 
diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 7d7a60b4d2de..ad54767440c1 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -28,17 +28,13 @@
  *      Chris Wilson <chris@chris-wilson.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
-#include <linux/moduleparam.h>
 #include <linux/pwm.h>
 
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_de.h"
 #include "intel_display_types.h"
-#include "intel_dp_aux_backlight.h"
-#include "intel_dsi_dcs_backlight.h"
 #include "intel_panel.h"
 
 void
@@ -456,1767 +452,6 @@ int intel_gmch_panel_fitting(struct intel_crtc_state *crtc_state,
 	return 0;
 }
 
-/**
- * scale - scale values from one range to another
- * @source_val: value in range [@source_min..@source_max]
- * @source_min: minimum legal value for @source_val
- * @source_max: maximum legal value for @source_val
- * @target_min: corresponding target value for @source_min
- * @target_max: corresponding target value for @source_max
- *
- * Return @source_val in range [@source_min..@source_max] scaled to range
- * [@target_min..@target_max].
- */
-static u32 scale(u32 source_val,
-		 u32 source_min, u32 source_max,
-		 u32 target_min, u32 target_max)
-{
-	u64 target_val;
-
-	WARN_ON(source_min > source_max);
-	WARN_ON(target_min > target_max);
-
-	/* defensive */
-	source_val = clamp(source_val, source_min, source_max);
-
-	/* avoid overflows */
-	target_val = mul_u32_u32(source_val - source_min,
-				 target_max - target_min);
-	target_val = DIV_ROUND_CLOSEST_ULL(target_val, source_max - source_min);
-	target_val += target_min;
-
-	return target_val;
-}
-
-/* Scale user_level in range [0..user_max] to [0..hw_max], clamping the result
- * to [hw_min..hw_max]. */
-static u32 clamp_user_to_hw(struct intel_connector *connector,
-			    u32 user_level, u32 user_max)
-{
-	struct intel_panel *panel = &connector->panel;
-	u32 hw_level;
-
-	hw_level = scale(user_level, 0, user_max, 0, panel->backlight.max);
-	hw_level = clamp(hw_level, panel->backlight.min, panel->backlight.max);
-
-	return hw_level;
-}
-
-/* Scale hw_level in range [hw_min..hw_max] to [0..user_max]. */
-static u32 scale_hw_to_user(struct intel_connector *connector,
-			    u32 hw_level, u32 user_max)
-{
-	struct intel_panel *panel = &connector->panel;
-
-	return scale(hw_level, panel->backlight.min, panel->backlight.max,
-		     0, user_max);
-}
-
-u32 intel_panel_invert_pwm_level(struct intel_connector *connector, u32 val)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
-
-	if (dev_priv->params.invert_brightness < 0)
-		return val;
-
-	if (dev_priv->params.invert_brightness > 0 ||
-	    dev_priv->quirks & QUIRK_INVERT_BRIGHTNESS) {
-		return panel->backlight.pwm_level_max - val + panel->backlight.pwm_level_min;
-	}
-
-	return val;
-}
-
-void intel_panel_set_pwm_level(const struct drm_connector_state *conn_state, u32 val)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *i915 = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	drm_dbg_kms(&i915->drm, "set backlight PWM = %d\n", val);
-	panel->backlight.pwm_funcs->set(conn_state, val);
-}
-
-u32 intel_panel_backlight_level_to_pwm(struct intel_connector *connector, u32 val)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	drm_WARN_ON_ONCE(&dev_priv->drm,
-			 panel->backlight.max == 0 || panel->backlight.pwm_level_max == 0);
-
-	val = scale(val, panel->backlight.min, panel->backlight.max,
-		    panel->backlight.pwm_level_min, panel->backlight.pwm_level_max);
-
-	return intel_panel_invert_pwm_level(connector, val);
-}
-
-u32 intel_panel_backlight_level_from_pwm(struct intel_connector *connector, u32 val)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	drm_WARN_ON_ONCE(&dev_priv->drm,
-			 panel->backlight.max == 0 || panel->backlight.pwm_level_max == 0);
-
-	if (dev_priv->params.invert_brightness > 0 ||
-	    (dev_priv->params.invert_brightness == 0 && dev_priv->quirks & QUIRK_INVERT_BRIGHTNESS))
-		val = panel->backlight.pwm_level_max - (val - panel->backlight.pwm_level_min);
-
-	return scale(val, panel->backlight.pwm_level_min, panel->backlight.pwm_level_max,
-		     panel->backlight.min, panel->backlight.max);
-}
-
-static u32 lpt_get_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	return intel_de_read(dev_priv, BLC_PWM_PCH_CTL2) & BACKLIGHT_DUTY_CYCLE_MASK;
-}
-
-static u32 pch_get_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	return intel_de_read(dev_priv, BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
-}
-
-static u32 i9xx_get_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 val;
-
-	val = intel_de_read(dev_priv, BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
-	if (DISPLAY_VER(dev_priv) < 4)
-		val >>= 1;
-
-	if (panel->backlight.combination_mode) {
-		u8 lbpc;
-
-		pci_read_config_byte(to_pci_dev(dev_priv->drm.dev), LBPC, &lbpc);
-		val *= lbpc;
-	}
-
-	return val;
-}
-
-static u32 vlv_get_backlight(struct intel_connector *connector, enum pipe pipe)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	if (drm_WARN_ON(&dev_priv->drm, pipe != PIPE_A && pipe != PIPE_B))
-		return 0;
-
-	return intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe)) & BACKLIGHT_DUTY_CYCLE_MASK;
-}
-
-static u32 bxt_get_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	return intel_de_read(dev_priv,
-			     BXT_BLC_PWM_DUTY(panel->backlight.controller));
-}
-
-static u32 ext_pwm_get_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct intel_panel *panel = &connector->panel;
-	struct pwm_state state;
-
-	pwm_get_state(panel->backlight.pwm, &state);
-	return pwm_get_relative_duty_cycle(&state, 100);
-}
-
-static void lpt_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	u32 val = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2) & ~BACKLIGHT_DUTY_CYCLE_MASK;
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, val | level);
-}
-
-static void pch_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	u32 tmp;
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
-	intel_de_write(dev_priv, BLC_PWM_CPU_CTL, tmp | level);
-}
-
-static void i9xx_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 tmp, mask;
-
-	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
-
-	if (panel->backlight.combination_mode) {
-		u8 lbpc;
-
-		lbpc = level * 0xfe / panel->backlight.pwm_level_max + 1;
-		level /= lbpc;
-		pci_write_config_byte(to_pci_dev(dev_priv->drm.dev), LBPC, lbpc);
-	}
-
-	if (DISPLAY_VER(dev_priv) == 4) {
-		mask = BACKLIGHT_DUTY_CYCLE_MASK;
-	} else {
-		level <<= 1;
-		mask = BACKLIGHT_DUTY_CYCLE_MASK_PNV;
-	}
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_CTL) & ~mask;
-	intel_de_write(dev_priv, BLC_PWM_CTL, tmp | level);
-}
-
-static void vlv_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	enum pipe pipe = to_intel_crtc(conn_state->crtc)->pipe;
-	u32 tmp;
-
-	tmp = intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe)) & ~BACKLIGHT_DUTY_CYCLE_MASK;
-	intel_de_write(dev_priv, VLV_BLC_PWM_CTL(pipe), tmp | level);
-}
-
-static void bxt_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	intel_de_write(dev_priv,
-		       BXT_BLC_PWM_DUTY(panel->backlight.controller), level);
-}
-
-static void ext_pwm_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_panel *panel = &to_intel_connector(conn_state->connector)->panel;
-
-	pwm_set_relative_duty_cycle(&panel->backlight.pwm_state, level, 100);
-	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
-}
-
-static void
-intel_panel_actually_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *i915 = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	drm_dbg_kms(&i915->drm, "set backlight level = %d\n", level);
-
-	panel->backlight.funcs->set(conn_state, level);
-}
-
-/* set backlight brightness to level in range [0..max], assuming hw min is
- * respected.
- */
-void intel_panel_set_backlight_acpi(const struct drm_connector_state *conn_state,
-				    u32 user_level, u32 user_max)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 hw_level;
-
-	/*
-	 * Lack of crtc may occur during driver init because
-	 * connection_mutex isn't held across the entire backlight
-	 * setup + modeset readout, and the BIOS can issue the
-	 * requests at any time.
-	 */
-	if (!panel->backlight.present || !conn_state->crtc)
-		return;
-
-	mutex_lock(&dev_priv->backlight_lock);
-
-	drm_WARN_ON(&dev_priv->drm, panel->backlight.max == 0);
-
-	hw_level = clamp_user_to_hw(connector, user_level, user_max);
-	panel->backlight.level = hw_level;
-
-	if (panel->backlight.device)
-		panel->backlight.device->props.brightness =
-			scale_hw_to_user(connector,
-					 panel->backlight.level,
-					 panel->backlight.device->props.max_brightness);
-
-	if (panel->backlight.enabled)
-		intel_panel_actually_set_backlight(conn_state, hw_level);
-
-	mutex_unlock(&dev_priv->backlight_lock);
-}
-
-static void lpt_disable_backlight(const struct drm_connector_state *old_conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, level);
-
-	/*
-	 * Although we don't support or enable CPU PWM with LPT/SPT based
-	 * systems, it may have been enabled prior to loading the
-	 * driver. Disable to avoid warnings on LCPLL disable.
-	 *
-	 * This needs rework if we need to add support for CPU PWM on PCH split
-	 * platforms.
-	 */
-	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
-	if (tmp & BLM_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "cpu backlight was enabled, disabling\n");
-		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2,
-			       tmp & ~BLM_PWM_ENABLE);
-	}
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, tmp & ~BLM_PCH_PWM_ENABLE);
-}
-
-static void pch_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, val);
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
-	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, tmp & ~BLM_PWM_ENABLE);
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, tmp & ~BLM_PCH_PWM_ENABLE);
-}
-
-static void i9xx_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	intel_panel_set_pwm_level(old_conn_state, val);
-}
-
-static void i965_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	struct drm_i915_private *dev_priv = to_i915(old_conn_state->connector->dev);
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, val);
-
-	tmp = intel_de_read(dev_priv, BLC_PWM_CTL2);
-	intel_de_write(dev_priv, BLC_PWM_CTL2, tmp & ~BLM_PWM_ENABLE);
-}
-
-static void vlv_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	enum pipe pipe = to_intel_crtc(old_conn_state->crtc)->pipe;
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, val);
-
-	tmp = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
-	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe),
-		       tmp & ~BLM_PWM_ENABLE);
-}
-
-static void bxt_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, val);
-
-	tmp = intel_de_read(dev_priv,
-			    BXT_BLC_PWM_CTL(panel->backlight.controller));
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       tmp & ~BXT_BLC_PWM_ENABLE);
-
-	if (panel->backlight.controller == 1) {
-		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
-		val &= ~UTIL_PIN_ENABLE;
-		intel_de_write(dev_priv, UTIL_PIN_CTL, val);
-	}
-}
-
-static void cnp_disable_backlight(const struct drm_connector_state *old_conn_state, u32 val)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 tmp;
-
-	intel_panel_set_pwm_level(old_conn_state, val);
-
-	tmp = intel_de_read(dev_priv,
-			    BXT_BLC_PWM_CTL(panel->backlight.controller));
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       tmp & ~BXT_BLC_PWM_ENABLE);
-}
-
-static void ext_pwm_disable_backlight(const struct drm_connector_state *old_conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	panel->backlight.pwm_state.enabled = false;
-	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
-}
-
-void intel_panel_disable_backlight(const struct drm_connector_state *old_conn_state)
-{
-	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	if (!panel->backlight.present)
-		return;
-
-	/*
-	 * Do not disable backlight on the vga_switcheroo path. When switching
-	 * away from i915, the other client may depend on i915 to handle the
-	 * backlight. This will leave the backlight on unnecessarily when
-	 * another client is not activated.
-	 */
-	if (dev_priv->drm.switch_power_state == DRM_SWITCH_POWER_CHANGING) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "Skipping backlight disable on vga switch\n");
-		return;
-	}
-
-	mutex_lock(&dev_priv->backlight_lock);
-
-	if (panel->backlight.device)
-		panel->backlight.device->props.power = FB_BLANK_POWERDOWN;
-	panel->backlight.enabled = false;
-	panel->backlight.funcs->disable(old_conn_state, 0);
-
-	mutex_unlock(&dev_priv->backlight_lock);
-}
-
-static void lpt_enable_backlight(const struct intel_crtc_state *crtc_state,
-				 const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 pch_ctl1, pch_ctl2, schicken;
-
-	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	if (pch_ctl1 & BLM_PCH_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "pch backlight already enabled\n");
-		pch_ctl1 &= ~BLM_PCH_PWM_ENABLE;
-		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
-	}
-
-	if (HAS_PCH_LPT(dev_priv)) {
-		schicken = intel_de_read(dev_priv, SOUTH_CHICKEN2);
-		if (panel->backlight.alternate_pwm_increment)
-			schicken |= LPT_PWM_GRANULARITY;
-		else
-			schicken &= ~LPT_PWM_GRANULARITY;
-		intel_de_write(dev_priv, SOUTH_CHICKEN2, schicken);
-	} else {
-		schicken = intel_de_read(dev_priv, SOUTH_CHICKEN1);
-		if (panel->backlight.alternate_pwm_increment)
-			schicken |= SPT_PWM_GRANULARITY;
-		else
-			schicken &= ~SPT_PWM_GRANULARITY;
-		intel_de_write(dev_priv, SOUTH_CHICKEN1, schicken);
-	}
-
-	pch_ctl2 = panel->backlight.pwm_level_max << 16;
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, pch_ctl2);
-
-	pch_ctl1 = 0;
-	if (panel->backlight.active_low_pwm)
-		pch_ctl1 |= BLM_PCH_POLARITY;
-
-	/* After LPT, override is the default. */
-	if (HAS_PCH_LPT(dev_priv))
-		pch_ctl1 |= BLM_PCH_OVERRIDE_ENABLE;
-
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
-	intel_de_posting_read(dev_priv, BLC_PWM_PCH_CTL1);
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
-		       pch_ctl1 | BLM_PCH_PWM_ENABLE);
-
-	/* This won't stick until the above enable. */
-	intel_panel_set_pwm_level(conn_state, level);
-}
-
-static void pch_enable_backlight(const struct intel_crtc_state *crtc_state,
-				 const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
-	u32 cpu_ctl2, pch_ctl1, pch_ctl2;
-
-	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
-	if (cpu_ctl2 & BLM_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "cpu backlight already enabled\n");
-		cpu_ctl2 &= ~BLM_PWM_ENABLE;
-		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2);
-	}
-
-	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	if (pch_ctl1 & BLM_PCH_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "pch backlight already enabled\n");
-		pch_ctl1 &= ~BLM_PCH_PWM_ENABLE;
-		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
-	}
-
-	if (cpu_transcoder == TRANSCODER_EDP)
-		cpu_ctl2 = BLM_TRANSCODER_EDP;
-	else
-		cpu_ctl2 = BLM_PIPE(cpu_transcoder);
-	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2);
-	intel_de_posting_read(dev_priv, BLC_PWM_CPU_CTL2);
-	intel_de_write(dev_priv, BLC_PWM_CPU_CTL2, cpu_ctl2 | BLM_PWM_ENABLE);
-
-	/* This won't stick until the above enable. */
-	intel_panel_set_pwm_level(conn_state, level);
-
-	pch_ctl2 = panel->backlight.pwm_level_max << 16;
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL2, pch_ctl2);
-
-	pch_ctl1 = 0;
-	if (panel->backlight.active_low_pwm)
-		pch_ctl1 |= BLM_PCH_POLARITY;
-
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1, pch_ctl1);
-	intel_de_posting_read(dev_priv, BLC_PWM_PCH_CTL1);
-	intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
-		       pch_ctl1 | BLM_PCH_PWM_ENABLE);
-}
-
-static void i9xx_enable_backlight(const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 ctl, freq;
-
-	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
-	if (ctl & BACKLIGHT_DUTY_CYCLE_MASK_PNV) {
-		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
-		intel_de_write(dev_priv, BLC_PWM_CTL, 0);
-	}
-
-	freq = panel->backlight.pwm_level_max;
-	if (panel->backlight.combination_mode)
-		freq /= 0xff;
-
-	ctl = freq << 17;
-	if (panel->backlight.combination_mode)
-		ctl |= BLM_LEGACY_MODE;
-	if (IS_PINEVIEW(dev_priv) && panel->backlight.active_low_pwm)
-		ctl |= BLM_POLARITY_PNV;
-
-	intel_de_write(dev_priv, BLC_PWM_CTL, ctl);
-	intel_de_posting_read(dev_priv, BLC_PWM_CTL);
-
-	/* XXX: combine this into above write? */
-	intel_panel_set_pwm_level(conn_state, level);
-
-	/*
-	 * Needed to enable backlight on some 855gm models. BLC_HIST_CTL is
-	 * 855gm only, but checking for gen2 is safe, as 855gm is the only gen2
-	 * that has backlight.
-	 */
-	if (DISPLAY_VER(dev_priv) == 2)
-		intel_de_write(dev_priv, BLC_HIST_CTL, BLM_HISTOGRAM_ENABLE);
-}
-
-static void i965_enable_backlight(const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	enum pipe pipe = to_intel_crtc(conn_state->crtc)->pipe;
-	u32 ctl, ctl2, freq;
-
-	ctl2 = intel_de_read(dev_priv, BLC_PWM_CTL2);
-	if (ctl2 & BLM_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
-		ctl2 &= ~BLM_PWM_ENABLE;
-		intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2);
-	}
-
-	freq = panel->backlight.pwm_level_max;
-	if (panel->backlight.combination_mode)
-		freq /= 0xff;
-
-	ctl = freq << 16;
-	intel_de_write(dev_priv, BLC_PWM_CTL, ctl);
-
-	ctl2 = BLM_PIPE(pipe);
-	if (panel->backlight.combination_mode)
-		ctl2 |= BLM_COMBINATION_MODE;
-	if (panel->backlight.active_low_pwm)
-		ctl2 |= BLM_POLARITY_I965;
-	intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2);
-	intel_de_posting_read(dev_priv, BLC_PWM_CTL2);
-	intel_de_write(dev_priv, BLC_PWM_CTL2, ctl2 | BLM_PWM_ENABLE);
-
-	intel_panel_set_pwm_level(conn_state, level);
-}
-
-static void vlv_enable_backlight(const struct intel_crtc_state *crtc_state,
-				 const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
-	u32 ctl, ctl2;
-
-	ctl2 = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
-	if (ctl2 & BLM_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
-		ctl2 &= ~BLM_PWM_ENABLE;
-		intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe), ctl2);
-	}
-
-	ctl = panel->backlight.pwm_level_max << 16;
-	intel_de_write(dev_priv, VLV_BLC_PWM_CTL(pipe), ctl);
-
-	/* XXX: combine this into above write? */
-	intel_panel_set_pwm_level(conn_state, level);
-
-	ctl2 = 0;
-	if (panel->backlight.active_low_pwm)
-		ctl2 |= BLM_POLARITY_I965;
-	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe), ctl2);
-	intel_de_posting_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
-	intel_de_write(dev_priv, VLV_BLC_PWM_CTL2(pipe),
-		       ctl2 | BLM_PWM_ENABLE);
-}
-
-static void bxt_enable_backlight(const struct intel_crtc_state *crtc_state,
-				 const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
-	u32 pwm_ctl, val;
-
-	/* Controller 1 uses the utility pin. */
-	if (panel->backlight.controller == 1) {
-		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
-		if (val & UTIL_PIN_ENABLE) {
-			drm_dbg_kms(&dev_priv->drm,
-				    "util pin already enabled\n");
-			val &= ~UTIL_PIN_ENABLE;
-			intel_de_write(dev_priv, UTIL_PIN_CTL, val);
-		}
-
-		val = 0;
-		if (panel->backlight.util_pin_active_low)
-			val |= UTIL_PIN_POLARITY;
-		intel_de_write(dev_priv, UTIL_PIN_CTL,
-			       val | UTIL_PIN_PIPE(pipe) | UTIL_PIN_MODE_PWM | UTIL_PIN_ENABLE);
-	}
-
-	pwm_ctl = intel_de_read(dev_priv,
-				BXT_BLC_PWM_CTL(panel->backlight.controller));
-	if (pwm_ctl & BXT_BLC_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
-		pwm_ctl &= ~BXT_BLC_PWM_ENABLE;
-		intel_de_write(dev_priv,
-			       BXT_BLC_PWM_CTL(panel->backlight.controller),
-			       pwm_ctl);
-	}
-
-	intel_de_write(dev_priv,
-		       BXT_BLC_PWM_FREQ(panel->backlight.controller),
-		       panel->backlight.pwm_level_max);
-
-	intel_panel_set_pwm_level(conn_state, level);
-
-	pwm_ctl = 0;
-	if (panel->backlight.active_low_pwm)
-		pwm_ctl |= BXT_BLC_PWM_POLARITY;
-
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       pwm_ctl);
-	intel_de_posting_read(dev_priv,
-			      BXT_BLC_PWM_CTL(panel->backlight.controller));
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       pwm_ctl | BXT_BLC_PWM_ENABLE);
-}
-
-static void cnp_enable_backlight(const struct intel_crtc_state *crtc_state,
-				 const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 pwm_ctl;
-
-	pwm_ctl = intel_de_read(dev_priv,
-				BXT_BLC_PWM_CTL(panel->backlight.controller));
-	if (pwm_ctl & BXT_BLC_PWM_ENABLE) {
-		drm_dbg_kms(&dev_priv->drm, "backlight already enabled\n");
-		pwm_ctl &= ~BXT_BLC_PWM_ENABLE;
-		intel_de_write(dev_priv,
-			       BXT_BLC_PWM_CTL(panel->backlight.controller),
-			       pwm_ctl);
-	}
-
-	intel_de_write(dev_priv,
-		       BXT_BLC_PWM_FREQ(panel->backlight.controller),
-		       panel->backlight.pwm_level_max);
-
-	intel_panel_set_pwm_level(conn_state, level);
-
-	pwm_ctl = 0;
-	if (panel->backlight.active_low_pwm)
-		pwm_ctl |= BXT_BLC_PWM_POLARITY;
-
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       pwm_ctl);
-	intel_de_posting_read(dev_priv,
-			      BXT_BLC_PWM_CTL(panel->backlight.controller));
-	intel_de_write(dev_priv, BXT_BLC_PWM_CTL(panel->backlight.controller),
-		       pwm_ctl | BXT_BLC_PWM_ENABLE);
-}
-
-static void ext_pwm_enable_backlight(const struct intel_crtc_state *crtc_state,
-				     const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	pwm_set_relative_duty_cycle(&panel->backlight.pwm_state, level, 100);
-	panel->backlight.pwm_state.enabled = true;
-	pwm_apply_state(panel->backlight.pwm, &panel->backlight.pwm_state);
-}
-
-static void __intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
-					   const struct drm_connector_state *conn_state)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	WARN_ON(panel->backlight.max == 0);
-
-	if (panel->backlight.level <= panel->backlight.min) {
-		panel->backlight.level = panel->backlight.max;
-		if (panel->backlight.device)
-			panel->backlight.device->props.brightness =
-				scale_hw_to_user(connector,
-						 panel->backlight.level,
-						 panel->backlight.device->props.max_brightness);
-	}
-
-	panel->backlight.funcs->enable(crtc_state, conn_state, panel->backlight.level);
-	panel->backlight.enabled = true;
-	if (panel->backlight.device)
-		panel->backlight.device->props.power = FB_BLANK_UNBLANK;
-}
-
-void intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
-
-	if (!panel->backlight.present)
-		return;
-
-	drm_dbg_kms(&dev_priv->drm, "pipe %c\n", pipe_name(pipe));
-
-	mutex_lock(&dev_priv->backlight_lock);
-
-	__intel_panel_enable_backlight(crtc_state, conn_state);
-
-	mutex_unlock(&dev_priv->backlight_lock);
-}
-
-#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
-static u32 intel_panel_get_backlight(struct intel_connector *connector)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 val = 0;
-
-	mutex_lock(&dev_priv->backlight_lock);
-
-	if (panel->backlight.enabled)
-		val = panel->backlight.funcs->get(connector, intel_connector_get_pipe(connector));
-
-	mutex_unlock(&dev_priv->backlight_lock);
-
-	drm_dbg_kms(&dev_priv->drm, "get backlight PWM = %d\n", val);
-	return val;
-}
-
-/* Scale user_level in range [0..user_max] to [hw_min..hw_max]. */
-static u32 scale_user_to_hw(struct intel_connector *connector,
-			    u32 user_level, u32 user_max)
-{
-	struct intel_panel *panel = &connector->panel;
-
-	return scale(user_level, 0, user_max,
-		     panel->backlight.min, panel->backlight.max);
-}
-
-/* set backlight brightness to level in range [0..max], scaling wrt hw min */
-static void intel_panel_set_backlight(const struct drm_connector_state *conn_state,
-				      u32 user_level, u32 user_max)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 hw_level;
-
-	if (!panel->backlight.present)
-		return;
-
-	mutex_lock(&dev_priv->backlight_lock);
-
-	drm_WARN_ON(&dev_priv->drm, panel->backlight.max == 0);
-
-	hw_level = scale_user_to_hw(connector, user_level, user_max);
-	panel->backlight.level = hw_level;
-
-	if (panel->backlight.enabled)
-		intel_panel_actually_set_backlight(conn_state, hw_level);
-
-	mutex_unlock(&dev_priv->backlight_lock);
-}
-
-static int intel_backlight_device_update_status(struct backlight_device *bd)
-{
-	struct intel_connector *connector = bl_get_data(bd);
-	struct intel_panel *panel = &connector->panel;
-	struct drm_device *dev = connector->base.dev;
-
-	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-	DRM_DEBUG_KMS("updating intel_backlight, brightness=%d/%d\n",
-		      bd->props.brightness, bd->props.max_brightness);
-	intel_panel_set_backlight(connector->base.state, bd->props.brightness,
-				  bd->props.max_brightness);
-
-	/*
-	 * Allow flipping bl_power as a sub-state of enabled. Sadly the
-	 * backlight class device does not make it easy to to differentiate
-	 * between callbacks for brightness and bl_power, so our backlight_power
-	 * callback needs to take this into account.
-	 */
-	if (panel->backlight.enabled) {
-		if (panel->backlight.power) {
-			bool enable = bd->props.power == FB_BLANK_UNBLANK &&
-				bd->props.brightness != 0;
-			panel->backlight.power(connector, enable);
-		}
-	} else {
-		bd->props.power = FB_BLANK_POWERDOWN;
-	}
-
-	drm_modeset_unlock(&dev->mode_config.connection_mutex);
-	return 0;
-}
-
-static int intel_backlight_device_get_brightness(struct backlight_device *bd)
-{
-	struct intel_connector *connector = bl_get_data(bd);
-	struct drm_device *dev = connector->base.dev;
-	struct drm_i915_private *dev_priv = to_i915(dev);
-	intel_wakeref_t wakeref;
-	int ret = 0;
-
-	with_intel_runtime_pm(&dev_priv->runtime_pm, wakeref) {
-		u32 hw_level;
-
-		drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-
-		hw_level = intel_panel_get_backlight(connector);
-		ret = scale_hw_to_user(connector,
-				       hw_level, bd->props.max_brightness);
-
-		drm_modeset_unlock(&dev->mode_config.connection_mutex);
-	}
-
-	return ret;
-}
-
-static const struct backlight_ops intel_backlight_device_ops = {
-	.update_status = intel_backlight_device_update_status,
-	.get_brightness = intel_backlight_device_get_brightness,
-};
-
-int intel_backlight_device_register(struct intel_connector *connector)
-{
-	struct drm_i915_private *i915 = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	struct backlight_properties props;
-	struct backlight_device *bd;
-	const char *name;
-	int ret = 0;
-
-	if (WARN_ON(panel->backlight.device))
-		return -ENODEV;
-
-	if (!panel->backlight.present)
-		return 0;
-
-	WARN_ON(panel->backlight.max == 0);
-
-	memset(&props, 0, sizeof(props));
-	props.type = BACKLIGHT_RAW;
-
-	/*
-	 * Note: Everything should work even if the backlight device max
-	 * presented to the userspace is arbitrarily chosen.
-	 */
-	props.max_brightness = panel->backlight.max;
-	props.brightness = scale_hw_to_user(connector,
-					    panel->backlight.level,
-					    props.max_brightness);
-
-	if (panel->backlight.enabled)
-		props.power = FB_BLANK_UNBLANK;
-	else
-		props.power = FB_BLANK_POWERDOWN;
-
-	name = kstrdup("intel_backlight", GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	bd = backlight_device_register(name, connector->base.kdev, connector,
-				       &intel_backlight_device_ops, &props);
-
-	/*
-	 * Using the same name independent of the drm device or connector
-	 * prevents registration of multiple backlight devices in the
-	 * driver. However, we need to use the default name for backward
-	 * compatibility. Use unique names for subsequent backlight devices as a
-	 * fallback when the default name already exists.
-	 */
-	if (IS_ERR(bd) && PTR_ERR(bd) == -EEXIST) {
-		kfree(name);
-		name = kasprintf(GFP_KERNEL, "card%d-%s-backlight",
-				 i915->drm.primary->index, connector->base.name);
-		if (!name)
-			return -ENOMEM;
-
-		bd = backlight_device_register(name, connector->base.kdev, connector,
-					       &intel_backlight_device_ops, &props);
-	}
-
-	if (IS_ERR(bd)) {
-		drm_err(&i915->drm,
-			"[CONNECTOR:%d:%s] backlight device %s register failed: %ld\n",
-			connector->base.base.id, connector->base.name, name, PTR_ERR(bd));
-		ret = PTR_ERR(bd);
-		goto out;
-	}
-
-	panel->backlight.device = bd;
-
-	drm_dbg_kms(&i915->drm,
-		    "[CONNECTOR:%d:%s] backlight device %s registered\n",
-		    connector->base.base.id, connector->base.name, name);
-
-out:
-	kfree(name);
-
-	return ret;
-}
-
-void intel_backlight_device_unregister(struct intel_connector *connector)
-{
-	struct intel_panel *panel = &connector->panel;
-
-	if (panel->backlight.device) {
-		backlight_device_unregister(panel->backlight.device);
-		panel->backlight.device = NULL;
-	}
-}
-#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
-
-/*
- * CNP: PWM clock frequency is 19.2 MHz or 24 MHz.
- *      PWM increment = 1
- */
-static u32 cnp_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(dev_priv)->rawclk_freq),
-				 pwm_freq_hz);
-}
-
-/*
- * BXT: PWM clock frequency = 19.2 MHz.
- */
-static u32 bxt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	return DIV_ROUND_CLOSEST(KHz(19200), pwm_freq_hz);
-}
-
-/*
- * SPT: This value represents the period of the PWM stream in clock periods
- * multiplied by 16 (default increment) or 128 (alternate increment selected in
- * SCHICKEN_1 bit 0). PWM clock is 24 MHz.
- */
-static u32 spt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct intel_panel *panel = &connector->panel;
-	u32 mul;
-
-	if (panel->backlight.alternate_pwm_increment)
-		mul = 128;
-	else
-		mul = 16;
-
-	return DIV_ROUND_CLOSEST(MHz(24), pwm_freq_hz * mul);
-}
-
-/*
- * LPT: This value represents the period of the PWM stream in clock periods
- * multiplied by 128 (default increment) or 16 (alternate increment, selected in
- * LPT SOUTH_CHICKEN2 register bit 5).
- */
-static u32 lpt_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 mul, clock;
-
-	if (panel->backlight.alternate_pwm_increment)
-		mul = 16;
-	else
-		mul = 128;
-
-	if (HAS_PCH_LPT_H(dev_priv))
-		clock = MHz(135); /* LPT:H */
-	else
-		clock = MHz(24); /* LPT:LP */
-
-	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * mul);
-}
-
-/*
- * ILK/SNB/IVB: This value represents the period of the PWM stream in PCH
- * display raw clocks multiplied by 128.
- */
-static u32 pch_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	return DIV_ROUND_CLOSEST(KHz(RUNTIME_INFO(dev_priv)->rawclk_freq),
-				 pwm_freq_hz * 128);
-}
-
-/*
- * Gen2: This field determines the number of time base events (display core
- * clock frequency/32) in total for a complete cycle of modulated backlight
- * control.
- *
- * Gen3: A time base event equals the display core clock ([DevPNV] HRAW clock)
- * divided by 32.
- */
-static u32 i9xx_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	int clock;
-
-	if (IS_PINEVIEW(dev_priv))
-		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
-	else
-		clock = KHz(dev_priv->cdclk.hw.cdclk);
-
-	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * 32);
-}
-
-/*
- * Gen4: This value represents the period of the PWM stream in display core
- * clocks ([DevCTG] HRAW clocks) multiplied by 128.
- *
- */
-static u32 i965_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	int clock;
-
-	if (IS_G4X(dev_priv))
-		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
-	else
-		clock = KHz(dev_priv->cdclk.hw.cdclk);
-
-	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * 128);
-}
-
-/*
- * VLV: This value represents the period of the PWM stream in display core
- * clocks ([DevCTG] 200MHz HRAW clocks) multiplied by 128 or 25MHz S0IX clocks
- * multiplied by 16. CHV uses a 19.2MHz S0IX clock.
- */
-static u32 vlv_hz_to_pwm(struct intel_connector *connector, u32 pwm_freq_hz)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	int mul, clock;
-
-	if ((intel_de_read(dev_priv, CBR1_VLV) & CBR_PWM_CLOCK_MUX_SELECT) == 0) {
-		if (IS_CHERRYVIEW(dev_priv))
-			clock = KHz(19200);
-		else
-			clock = MHz(25);
-		mul = 16;
-	} else {
-		clock = KHz(RUNTIME_INFO(dev_priv)->rawclk_freq);
-		mul = 128;
-	}
-
-	return DIV_ROUND_CLOSEST(clock, pwm_freq_hz * mul);
-}
-
-static u16 get_vbt_pwm_freq(struct drm_i915_private *dev_priv)
-{
-	u16 pwm_freq_hz = dev_priv->vbt.backlight.pwm_freq_hz;
-
-	if (pwm_freq_hz) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "VBT defined backlight frequency %u Hz\n",
-			    pwm_freq_hz);
-	} else {
-		pwm_freq_hz = 200;
-		drm_dbg_kms(&dev_priv->drm,
-			    "default backlight frequency %u Hz\n",
-			    pwm_freq_hz);
-	}
-
-	return pwm_freq_hz;
-}
-
-static u32 get_backlight_max_vbt(struct intel_connector *connector)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u16 pwm_freq_hz = get_vbt_pwm_freq(dev_priv);
-	u32 pwm;
-
-	if (!panel->backlight.pwm_funcs->hz_to_pwm) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "backlight frequency conversion not supported\n");
-		return 0;
-	}
-
-	pwm = panel->backlight.pwm_funcs->hz_to_pwm(connector, pwm_freq_hz);
-	if (!pwm) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "backlight frequency conversion failed\n");
-		return 0;
-	}
-
-	return pwm;
-}
-
-/*
- * Note: The setup hooks can't assume pipe is set!
- */
-static u32 get_backlight_min_vbt(struct intel_connector *connector)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	int min;
-
-	drm_WARN_ON(&dev_priv->drm, panel->backlight.pwm_level_max == 0);
-
-	/*
-	 * XXX: If the vbt value is 255, it makes min equal to max, which leads
-	 * to problems. There are such machines out there. Either our
-	 * interpretation is wrong or the vbt has bogus data. Or both. Safeguard
-	 * against this by letting the minimum be at most (arbitrarily chosen)
-	 * 25% of the max.
-	 */
-	min = clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
-	if (min != dev_priv->vbt.backlight.min_brightness) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "clamping VBT min backlight %d/255 to %d/255\n",
-			    dev_priv->vbt.backlight.min_brightness, min);
-	}
-
-	/* vbt value is a coefficient in range [0..255] */
-	return scale(min, 0, 255, 0, panel->backlight.pwm_level_max);
-}
-
-static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 cpu_ctl2, pch_ctl1, pch_ctl2, val;
-	bool alt, cpu_mode;
-
-	if (HAS_PCH_LPT(dev_priv))
-		alt = intel_de_read(dev_priv, SOUTH_CHICKEN2) & LPT_PWM_GRANULARITY;
-	else
-		alt = intel_de_read(dev_priv, SOUTH_CHICKEN1) & SPT_PWM_GRANULARITY;
-	panel->backlight.alternate_pwm_increment = alt;
-
-	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	panel->backlight.active_low_pwm = pch_ctl1 & BLM_PCH_POLARITY;
-
-	pch_ctl2 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2);
-	panel->backlight.pwm_level_max = pch_ctl2 >> 16;
-
-	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	panel->backlight.pwm_enabled = pch_ctl1 & BLM_PCH_PWM_ENABLE;
-
-	cpu_mode = panel->backlight.pwm_enabled && HAS_PCH_LPT(dev_priv) &&
-		   !(pch_ctl1 & BLM_PCH_OVERRIDE_ENABLE) &&
-		   (cpu_ctl2 & BLM_PWM_ENABLE);
-
-	if (cpu_mode) {
-		val = pch_get_backlight(connector, unused);
-
-		drm_dbg_kms(&dev_priv->drm,
-			    "CPU backlight register was enabled, switching to PCH override\n");
-
-		/* Write converted CPU PWM value to PCH override register */
-		lpt_set_backlight(connector->base.state, val);
-		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
-			       pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
-
-		intel_de_write(dev_priv, BLC_PWM_CPU_CTL2,
-			       cpu_ctl2 & ~BLM_PWM_ENABLE);
-	}
-
-	return 0;
-}
-
-static int pch_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 cpu_ctl2, pch_ctl1, pch_ctl2;
-
-	pch_ctl1 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL1);
-	panel->backlight.active_low_pwm = pch_ctl1 & BLM_PCH_POLARITY;
-
-	pch_ctl2 = intel_de_read(dev_priv, BLC_PWM_PCH_CTL2);
-	panel->backlight.pwm_level_max = pch_ctl2 >> 16;
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	cpu_ctl2 = intel_de_read(dev_priv, BLC_PWM_CPU_CTL2);
-	panel->backlight.pwm_enabled = (cpu_ctl2 & BLM_PWM_ENABLE) &&
-		(pch_ctl1 & BLM_PCH_PWM_ENABLE);
-
-	return 0;
-}
-
-static int i9xx_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 ctl, val;
-
-	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
-
-	if (DISPLAY_VER(dev_priv) == 2 || IS_I915GM(dev_priv) || IS_I945GM(dev_priv))
-		panel->backlight.combination_mode = ctl & BLM_LEGACY_MODE;
-
-	if (IS_PINEVIEW(dev_priv))
-		panel->backlight.active_low_pwm = ctl & BLM_POLARITY_PNV;
-
-	panel->backlight.pwm_level_max = ctl >> 17;
-
-	if (!panel->backlight.pwm_level_max) {
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-		panel->backlight.pwm_level_max >>= 1;
-	}
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	if (panel->backlight.combination_mode)
-		panel->backlight.pwm_level_max *= 0xff;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	val = i9xx_get_backlight(connector, unused);
-	val = intel_panel_invert_pwm_level(connector, val);
-	val = clamp(val, panel->backlight.pwm_level_min, panel->backlight.pwm_level_max);
-
-	panel->backlight.pwm_enabled = val != 0;
-
-	return 0;
-}
-
-static int i965_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 ctl, ctl2;
-
-	ctl2 = intel_de_read(dev_priv, BLC_PWM_CTL2);
-	panel->backlight.combination_mode = ctl2 & BLM_COMBINATION_MODE;
-	panel->backlight.active_low_pwm = ctl2 & BLM_POLARITY_I965;
-
-	ctl = intel_de_read(dev_priv, BLC_PWM_CTL);
-	panel->backlight.pwm_level_max = ctl >> 16;
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	if (panel->backlight.combination_mode)
-		panel->backlight.pwm_level_max *= 0xff;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	panel->backlight.pwm_enabled = ctl2 & BLM_PWM_ENABLE;
-
-	return 0;
-}
-
-static int vlv_setup_backlight(struct intel_connector *connector, enum pipe pipe)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 ctl, ctl2;
-
-	if (drm_WARN_ON(&dev_priv->drm, pipe != PIPE_A && pipe != PIPE_B))
-		return -ENODEV;
-
-	ctl2 = intel_de_read(dev_priv, VLV_BLC_PWM_CTL2(pipe));
-	panel->backlight.active_low_pwm = ctl2 & BLM_POLARITY_I965;
-
-	ctl = intel_de_read(dev_priv, VLV_BLC_PWM_CTL(pipe));
-	panel->backlight.pwm_level_max = ctl >> 16;
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	panel->backlight.pwm_enabled = ctl2 & BLM_PWM_ENABLE;
-
-	return 0;
-}
-
-static int
-bxt_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 pwm_ctl, val;
-
-	panel->backlight.controller = dev_priv->vbt.backlight.controller;
-
-	pwm_ctl = intel_de_read(dev_priv,
-				BXT_BLC_PWM_CTL(panel->backlight.controller));
-
-	/* Controller 1 uses the utility pin. */
-	if (panel->backlight.controller == 1) {
-		val = intel_de_read(dev_priv, UTIL_PIN_CTL);
-		panel->backlight.util_pin_active_low =
-					val & UTIL_PIN_POLARITY;
-	}
-
-	panel->backlight.active_low_pwm = pwm_ctl & BXT_BLC_PWM_POLARITY;
-	panel->backlight.pwm_level_max =
-		intel_de_read(dev_priv, BXT_BLC_PWM_FREQ(panel->backlight.controller));
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	panel->backlight.pwm_enabled = pwm_ctl & BXT_BLC_PWM_ENABLE;
-
-	return 0;
-}
-
-static int
-cnp_setup_backlight(struct intel_connector *connector, enum pipe unused)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-	u32 pwm_ctl;
-
-	/*
-	 * CNP has the BXT implementation of backlight, but with only one
-	 * controller. TODO: ICP has multiple controllers but we only use
-	 * controller 0 for now.
-	 */
-	panel->backlight.controller = 0;
-
-	pwm_ctl = intel_de_read(dev_priv,
-				BXT_BLC_PWM_CTL(panel->backlight.controller));
-
-	panel->backlight.active_low_pwm = pwm_ctl & BXT_BLC_PWM_POLARITY;
-	panel->backlight.pwm_level_max =
-		intel_de_read(dev_priv, BXT_BLC_PWM_FREQ(panel->backlight.controller));
-
-	if (!panel->backlight.pwm_level_max)
-		panel->backlight.pwm_level_max = get_backlight_max_vbt(connector);
-
-	if (!panel->backlight.pwm_level_max)
-		return -ENODEV;
-
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	panel->backlight.pwm_enabled = pwm_ctl & BXT_BLC_PWM_ENABLE;
-
-	return 0;
-}
-
-static int ext_pwm_setup_backlight(struct intel_connector *connector,
-				   enum pipe pipe)
-{
-	struct drm_device *dev = connector->base.dev;
-	struct drm_i915_private *dev_priv = to_i915(dev);
-	struct intel_panel *panel = &connector->panel;
-	const char *desc;
-	u32 level;
-
-	/* Get the right PWM chip for DSI backlight according to VBT */
-	if (dev_priv->vbt.dsi.config->pwm_blc == PPS_BLC_PMIC) {
-		panel->backlight.pwm = pwm_get(dev->dev, "pwm_pmic_backlight");
-		desc = "PMIC";
-	} else {
-		panel->backlight.pwm = pwm_get(dev->dev, "pwm_soc_backlight");
-		desc = "SoC";
-	}
-
-	if (IS_ERR(panel->backlight.pwm)) {
-		drm_err(&dev_priv->drm, "Failed to get the %s PWM chip\n",
-			desc);
-		panel->backlight.pwm = NULL;
-		return -ENODEV;
-	}
-
-	panel->backlight.pwm_level_max = 100; /* 100% */
-	panel->backlight.pwm_level_min = get_backlight_min_vbt(connector);
-
-	if (pwm_is_enabled(panel->backlight.pwm)) {
-		/* PWM is already enabled, use existing settings */
-		pwm_get_state(panel->backlight.pwm, &panel->backlight.pwm_state);
-
-		level = pwm_get_relative_duty_cycle(&panel->backlight.pwm_state,
-						    100);
-		level = intel_panel_invert_pwm_level(connector, level);
-		panel->backlight.pwm_enabled = true;
-
-		drm_dbg_kms(&dev_priv->drm, "PWM already enabled at freq %ld, VBT freq %d, level %d\n",
-			    NSEC_PER_SEC / (unsigned long)panel->backlight.pwm_state.period,
-			    get_vbt_pwm_freq(dev_priv), level);
-	} else {
-		/* Set period from VBT frequency, leave other settings at 0. */
-		panel->backlight.pwm_state.period =
-			NSEC_PER_SEC / get_vbt_pwm_freq(dev_priv);
-	}
-
-	drm_info(&dev_priv->drm, "Using %s PWM for LCD backlight control\n",
-		 desc);
-	return 0;
-}
-
-static void intel_pwm_set_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	panel->backlight.pwm_funcs->set(conn_state,
-				       intel_panel_invert_pwm_level(connector, level));
-}
-
-static u32 intel_pwm_get_backlight(struct intel_connector *connector, enum pipe pipe)
-{
-	struct intel_panel *panel = &connector->panel;
-
-	return intel_panel_invert_pwm_level(connector,
-					    panel->backlight.pwm_funcs->get(connector, pipe));
-}
-
-static void intel_pwm_enable_backlight(const struct intel_crtc_state *crtc_state,
-				       const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	panel->backlight.pwm_funcs->enable(crtc_state, conn_state,
-					   intel_panel_invert_pwm_level(connector, level));
-}
-
-static void intel_pwm_disable_backlight(const struct drm_connector_state *conn_state, u32 level)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct intel_panel *panel = &connector->panel;
-
-	panel->backlight.pwm_funcs->disable(conn_state,
-					    intel_panel_invert_pwm_level(connector, level));
-}
-
-static int intel_pwm_setup_backlight(struct intel_connector *connector, enum pipe pipe)
-{
-	struct intel_panel *panel = &connector->panel;
-	int ret = panel->backlight.pwm_funcs->setup(connector, pipe);
-
-	if (ret < 0)
-		return ret;
-
-	panel->backlight.min = panel->backlight.pwm_level_min;
-	panel->backlight.max = panel->backlight.pwm_level_max;
-	panel->backlight.level = intel_pwm_get_backlight(connector, pipe);
-	panel->backlight.enabled = panel->backlight.pwm_enabled;
-
-	return 0;
-}
-
-void intel_panel_update_backlight(struct intel_atomic_state *state,
-				  struct intel_encoder *encoder,
-				  const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state)
-{
-	struct intel_connector *connector = to_intel_connector(conn_state->connector);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-	struct intel_panel *panel = &connector->panel;
-
-	if (!panel->backlight.present)
-		return;
-
-	mutex_lock(&dev_priv->backlight_lock);
-	if (!panel->backlight.enabled)
-		__intel_panel_enable_backlight(crtc_state, conn_state);
-
-	mutex_unlock(&dev_priv->backlight_lock);
-}
-
-int intel_panel_setup_backlight(struct drm_connector *connector, enum pipe pipe)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->dev);
-	struct intel_connector *intel_connector = to_intel_connector(connector);
-	struct intel_panel *panel = &intel_connector->panel;
-	int ret;
-
-	if (!dev_priv->vbt.backlight.present) {
-		if (dev_priv->quirks & QUIRK_BACKLIGHT_PRESENT) {
-			drm_dbg_kms(&dev_priv->drm,
-				    "no backlight present per VBT, but present per quirk\n");
-		} else {
-			drm_dbg_kms(&dev_priv->drm,
-				    "no backlight present per VBT\n");
-			return 0;
-		}
-	}
-
-	/* ensure intel_panel has been initialized first */
-	if (drm_WARN_ON(&dev_priv->drm, !panel->backlight.funcs))
-		return -ENODEV;
-
-	/* set level and max in panel struct */
-	mutex_lock(&dev_priv->backlight_lock);
-	ret = panel->backlight.funcs->setup(intel_connector, pipe);
-	mutex_unlock(&dev_priv->backlight_lock);
-
-	if (ret) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "failed to setup backlight for connector %s\n",
-			    connector->name);
-		return ret;
-	}
-
-	panel->backlight.present = true;
-
-	drm_dbg_kms(&dev_priv->drm,
-		    "Connector %s backlight initialized, %s, brightness %u/%u\n",
-		    connector->name,
-		    enableddisabled(panel->backlight.enabled),
-		    panel->backlight.level, panel->backlight.max);
-
-	return 0;
-}
-
-static void intel_panel_destroy_backlight(struct intel_panel *panel)
-{
-	/* dispose of the pwm */
-	if (panel->backlight.pwm)
-		pwm_put(panel->backlight.pwm);
-
-	panel->backlight.present = false;
-}
-
-static const struct intel_panel_bl_funcs bxt_pwm_funcs = {
-	.setup = bxt_setup_backlight,
-	.enable = bxt_enable_backlight,
-	.disable = bxt_disable_backlight,
-	.set = bxt_set_backlight,
-	.get = bxt_get_backlight,
-	.hz_to_pwm = bxt_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs cnp_pwm_funcs = {
-	.setup = cnp_setup_backlight,
-	.enable = cnp_enable_backlight,
-	.disable = cnp_disable_backlight,
-	.set = bxt_set_backlight,
-	.get = bxt_get_backlight,
-	.hz_to_pwm = cnp_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs lpt_pwm_funcs = {
-	.setup = lpt_setup_backlight,
-	.enable = lpt_enable_backlight,
-	.disable = lpt_disable_backlight,
-	.set = lpt_set_backlight,
-	.get = lpt_get_backlight,
-	.hz_to_pwm = lpt_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs spt_pwm_funcs = {
-	.setup = lpt_setup_backlight,
-	.enable = lpt_enable_backlight,
-	.disable = lpt_disable_backlight,
-	.set = lpt_set_backlight,
-	.get = lpt_get_backlight,
-	.hz_to_pwm = spt_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs pch_pwm_funcs = {
-	.setup = pch_setup_backlight,
-	.enable = pch_enable_backlight,
-	.disable = pch_disable_backlight,
-	.set = pch_set_backlight,
-	.get = pch_get_backlight,
-	.hz_to_pwm = pch_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs ext_pwm_funcs = {
-	.setup = ext_pwm_setup_backlight,
-	.enable = ext_pwm_enable_backlight,
-	.disable = ext_pwm_disable_backlight,
-	.set = ext_pwm_set_backlight,
-	.get = ext_pwm_get_backlight,
-};
-
-static const struct intel_panel_bl_funcs vlv_pwm_funcs = {
-	.setup = vlv_setup_backlight,
-	.enable = vlv_enable_backlight,
-	.disable = vlv_disable_backlight,
-	.set = vlv_set_backlight,
-	.get = vlv_get_backlight,
-	.hz_to_pwm = vlv_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs i965_pwm_funcs = {
-	.setup = i965_setup_backlight,
-	.enable = i965_enable_backlight,
-	.disable = i965_disable_backlight,
-	.set = i9xx_set_backlight,
-	.get = i9xx_get_backlight,
-	.hz_to_pwm = i965_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs i9xx_pwm_funcs = {
-	.setup = i9xx_setup_backlight,
-	.enable = i9xx_enable_backlight,
-	.disable = i9xx_disable_backlight,
-	.set = i9xx_set_backlight,
-	.get = i9xx_get_backlight,
-	.hz_to_pwm = i9xx_hz_to_pwm,
-};
-
-static const struct intel_panel_bl_funcs pwm_bl_funcs = {
-	.setup = intel_pwm_setup_backlight,
-	.enable = intel_pwm_enable_backlight,
-	.disable = intel_pwm_disable_backlight,
-	.set = intel_pwm_set_backlight,
-	.get = intel_pwm_get_backlight,
-};
-
-/* Set up chip specific backlight functions */
-static void
-intel_panel_init_backlight_funcs(struct intel_panel *panel)
-{
-	struct intel_connector *connector =
-		container_of(panel, struct intel_connector, panel);
-	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
-
-	if (connector->base.connector_type == DRM_MODE_CONNECTOR_DSI &&
-	    intel_dsi_dcs_init_backlight_funcs(connector) == 0)
-		return;
-
-	if (IS_GEMINILAKE(dev_priv) || IS_BROXTON(dev_priv)) {
-		panel->backlight.pwm_funcs = &bxt_pwm_funcs;
-	} else if (INTEL_PCH_TYPE(dev_priv) >= PCH_CNP) {
-		panel->backlight.pwm_funcs = &cnp_pwm_funcs;
-	} else if (INTEL_PCH_TYPE(dev_priv) >= PCH_LPT) {
-		if (HAS_PCH_LPT(dev_priv))
-			panel->backlight.pwm_funcs = &lpt_pwm_funcs;
-		else
-			panel->backlight.pwm_funcs = &spt_pwm_funcs;
-	} else if (HAS_PCH_SPLIT(dev_priv)) {
-		panel->backlight.pwm_funcs = &pch_pwm_funcs;
-	} else if (IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) {
-		if (connector->base.connector_type == DRM_MODE_CONNECTOR_DSI) {
-			panel->backlight.pwm_funcs = &ext_pwm_funcs;
-		} else {
-			panel->backlight.pwm_funcs = &vlv_pwm_funcs;
-		}
-	} else if (DISPLAY_VER(dev_priv) == 4) {
-		panel->backlight.pwm_funcs = &i965_pwm_funcs;
-	} else {
-		panel->backlight.pwm_funcs = &i9xx_pwm_funcs;
-	}
-
-	if (connector->base.connector_type == DRM_MODE_CONNECTOR_eDP &&
-	    intel_dp_aux_init_backlight_funcs(connector) == 0)
-		return;
-
-	/* We're using a standard PWM backlight interface */
-	panel->backlight.funcs = &pwm_bl_funcs;
-}
-
 enum drm_connector_status
 intel_panel_detect(struct drm_connector *connector, bool force)
 {
diff --git a/drivers/gpu/drm/i915/display/intel_panel.h b/drivers/gpu/drm/i915/display/intel_panel.h
index 1d340f77bffc..67dbb15026bf 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.h
+++ b/drivers/gpu/drm/i915/display/intel_panel.h
@@ -8,15 +8,13 @@
 
 #include <linux/types.h>
 
-#include "intel_display.h"
-
+enum drm_connector_status;
 struct drm_connector;
 struct drm_connector_state;
 struct drm_display_mode;
+struct drm_i915_private;
 struct intel_connector;
-struct intel_crtc;
 struct intel_crtc_state;
-struct intel_encoder;
 struct intel_panel;
 
 int intel_panel_init(struct intel_panel *panel,
@@ -31,17 +29,6 @@ int intel_pch_panel_fitting(struct intel_crtc_state *crtc_state,
 			    const struct drm_connector_state *conn_state);
 int intel_gmch_panel_fitting(struct intel_crtc_state *crtc_state,
 			     const struct drm_connector_state *conn_state);
-void intel_panel_set_backlight_acpi(const struct drm_connector_state *conn_state,
-				    u32 level, u32 max);
-int intel_panel_setup_backlight(struct drm_connector *connector,
-				enum pipe pipe);
-void intel_panel_enable_backlight(const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state);
-void intel_panel_update_backlight(struct intel_atomic_state *state,
-				  struct intel_encoder *encoder,
-				  const struct intel_crtc_state *crtc_state,
-				  const struct drm_connector_state *conn_state);
-void intel_panel_disable_backlight(const struct drm_connector_state *old_conn_state);
 struct drm_display_mode *
 intel_panel_edid_downclock_mode(struct intel_connector *connector,
 				const struct drm_display_mode *fixed_mode);
@@ -49,22 +36,5 @@ struct drm_display_mode *
 intel_panel_edid_fixed_mode(struct intel_connector *connector);
 struct drm_display_mode *
 intel_panel_vbt_fixed_mode(struct intel_connector *connector);
-void intel_panel_set_pwm_level(const struct drm_connector_state *conn_state, u32 level);
-u32 intel_panel_invert_pwm_level(struct intel_connector *connector, u32 level);
-u32 intel_panel_backlight_level_to_pwm(struct intel_connector *connector, u32 level);
-u32 intel_panel_backlight_level_from_pwm(struct intel_connector *connector, u32 val);
-
-#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
-int intel_backlight_device_register(struct intel_connector *connector);
-void intel_backlight_device_unregister(struct intel_connector *connector);
-#else /* CONFIG_BACKLIGHT_CLASS_DEVICE */
-static inline int intel_backlight_device_register(struct intel_connector *connector)
-{
-	return 0;
-}
-static inline void intel_backlight_device_unregister(struct intel_connector *connector)
-{
-}
-#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
 
 #endif /* __INTEL_PANEL_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index 8a52b7a16774..407b096f5392 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -190,6 +190,9 @@ static struct intel_quirk intel_quirks[] = {
 	/* ASRock ITX*/
 	{ 0x3185, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
+	/* ECS Liva Q2 */
+	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index 0ee4ff341e25..b27738df447d 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -32,6 +32,7 @@
 
 #include "i915_drv.h"
 #include "intel_atomic.h"
+#include "intel_backlight.h"
 #include "intel_connector.h"
 #include "intel_crtc.h"
 #include "intel_de.h"
diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index cde0a477fb49..7ed7dba42c83 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -909,7 +909,7 @@ static int update_fdi_rx_iir_status(struct intel_vgpu *vgpu,
 	else if (FDI_RX_IMR_TO_PIPE(offset) != INVALID_INDEX)
 		index = FDI_RX_IMR_TO_PIPE(offset);
 	else {
-		gvt_vgpu_err("Unsupport registers %x\n", offset);
+		gvt_vgpu_err("Unsupported registers %x\n", offset);
 		return -EINVAL;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 1a27e4833adf..9123baf723d8 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6638,7 +6638,10 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
 		enum plane_id plane_id;
 		u8 slices;
 
-		skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
+		memset(&crtc_state->wm.skl.optimal, 0,
+		       sizeof(crtc_state->wm.skl.optimal));
+		if (crtc_state->hw.active)
+			skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
 		crtc_state->wm.skl.raw = crtc_state->wm.skl.optimal;
 
 		memset(&dbuf_state->ddb[pipe], 0, sizeof(dbuf_state->ddb[pipe]));
@@ -6649,6 +6652,9 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
 			struct skl_ddb_entry *ddb_uv =
 				&crtc_state->wm.skl.plane_ddb_uv[plane_id];
 
+			if (!crtc_state->hw.active)
+				continue;
+
 			skl_ddb_get_hw_plane_state(dev_priv, crtc->pipe,
 						   plane_id, ddb_y, ddb_uv);
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index b6f4ce2a48af..6d9eec98e0d3 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1198,7 +1198,7 @@ static int dp_ctrl_link_train_2(struct dp_ctrl_private *ctrl,
 	if (ret)
 		return ret;
 
-	dp_ctrl_train_pattern_set(ctrl, pattern | DP_RECOVERED_CLOCK_OUT_EN);
+	dp_ctrl_train_pattern_set(ctrl, pattern);
 
 	for (tries = 0; tries <= maximum_retries; tries++) {
 		drm_dp_link_train_channel_eq_delay(ctrl->aux, ctrl->panel->dpcd);
diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index 96bbc8b6d009..ce3901439c69 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -109,7 +109,7 @@ static const char * const dsi_8996_bus_clk_names[] = {
 static const struct msm_dsi_config msm8996_dsi_cfg = {
 	.io_offset = DSI_6G_REG_SHIFT,
 	.reg_cfg = {
-		.num = 2,
+		.num = 3,
 		.regs = {
 			{"vdda", 18160, 1 },	/* 1.25 V */
 			{"vcca", 17000, 32 },	/* 0.925 V */
@@ -148,7 +148,7 @@ static const char * const dsi_sdm660_bus_clk_names[] = {
 static const struct msm_dsi_config sdm660_dsi_cfg = {
 	.io_offset = DSI_6G_REG_SHIFT,
 	.reg_cfg = {
-		.num = 2,
+		.num = 1,
 		.regs = {
 			{"vdda", 12560, 4 },	/* 1.2 V */
 		},
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index a878b8b079c6..6a917fe69a83 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -347,7 +347,7 @@ int msm_dsi_dphy_timing_calc_v3(struct msm_dsi_dphy_timing *timing,
 	} else {
 		timing->shared_timings.clk_pre =
 			linear_inter(tmax, tmin, pcnt2, 0, false);
-			timing->shared_timings.clk_pre_inc_by_2 = 0;
+		timing->shared_timings.clk_pre_inc_by_2 = 0;
 	}
 
 	timing->ta_go = 3;
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index befe989ca7b9..fbf3f5a4ecb6 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -391,6 +391,9 @@ static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	if (!fan_data)
 		return -EINVAL;
 
+	if (state >= fan_data->num_speed)
+		return -EINVAL;
+
 	set_fan_speed(fan_data, state);
 	return 0;
 }
diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
index 3271a31afde1..e3e14a1253e8 100644
--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -287,10 +287,8 @@ static int ad7292_probe(struct spi_device *spi)
 
 		ret = devm_add_action_or_reset(&spi->dev,
 					       ad7292_regulator_disable, st);
-		if (ret) {
-			regulator_disable(st->reg);
+		if (ret)
 			return ret;
-		}
 
 		ret = regulator_get_voltage(st->reg);
 		if (ret < 0)
diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index e573da5397bb..65278270a75c 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -38,8 +38,8 @@
 #define MCP3911_CHANNEL(x)		(MCP3911_REG_CHANNEL0 + x * 3)
 #define MCP3911_OFFCAL(x)		(MCP3911_REG_OFFCAL_CH0 + x * 6)
 
-/* Internal voltage reference in uV */
-#define MCP3911_INT_VREF_UV		1200000
+/* Internal voltage reference in mV */
+#define MCP3911_INT_VREF_MV		1200
 
 #define MCP3911_REG_READ(reg, id)	((((reg) << 1) | ((id) << 5) | (1 << 0)) & 0xff)
 #define MCP3911_REG_WRITE(reg, id)	((((reg) << 1) | ((id) << 5) | (0 << 0)) & 0xff)
@@ -111,6 +111,8 @@ static int mcp3911_read_raw(struct iio_dev *indio_dev,
 		if (ret)
 			goto out;
 
+		*val = sign_extend32(*val, 23);
+
 		ret = IIO_VAL_INT;
 		break;
 
@@ -135,11 +137,18 @@ static int mcp3911_read_raw(struct iio_dev *indio_dev,
 
 			*val = ret / 1000;
 		} else {
-			*val = MCP3911_INT_VREF_UV;
+			*val = MCP3911_INT_VREF_MV;
 		}
 
-		*val2 = 24;
-		ret = IIO_VAL_FRACTIONAL_LOG2;
+		/*
+		 * For 24bit Conversion
+		 * Raw = ((Voltage)/(Vref) * 2^23 * Gain * 1.5
+		 * Voltage = Raw * (Vref)/(2^23 * Gain * 1.5)
+		 */
+
+		/* val2 = (2^23 * 1.5) */
+		*val2 = 12582912;
+		ret = IIO_VAL_FRACTIONAL;
 		break;
 	}
 
diff --git a/drivers/input/joystick/iforce/iforce-serio.c b/drivers/input/joystick/iforce/iforce-serio.c
index f95a81b9fac7..2380546d7978 100644
--- a/drivers/input/joystick/iforce/iforce-serio.c
+++ b/drivers/input/joystick/iforce/iforce-serio.c
@@ -39,7 +39,7 @@ static void iforce_serio_xmit(struct iforce *iforce)
 
 again:
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -64,7 +64,7 @@ static void iforce_serio_xmit(struct iforce *iforce)
 	if (test_and_clear_bit(IFORCE_XMIT_AGAIN, iforce->xmit_flags))
 		goto again;
 
-	clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+	iforce_clear_xmit_and_wake(iforce);
 
 	spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 }
@@ -169,7 +169,7 @@ static irqreturn_t iforce_serio_irq(struct serio *serio,
 			iforce_serio->cmd_response_len = iforce_serio->len;
 
 			/* Signal that command is done */
-			wake_up(&iforce->wait);
+			wake_up_all(&iforce->wait);
 		} else if (likely(iforce->type)) {
 			iforce_process_packet(iforce, iforce_serio->id,
 					      iforce_serio->data_in,
diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index ea58805c480f..cba92bd590a8 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -30,7 +30,7 @@ static void __iforce_usb_xmit(struct iforce *iforce)
 	spin_lock_irqsave(&iforce->xmit_lock, flags);
 
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -58,9 +58,9 @@ static void __iforce_usb_xmit(struct iforce *iforce)
 	XMIT_INC(iforce->xmit.tail, n);
 
 	if ( (n=usb_submit_urb(iforce_usb->out, GFP_ATOMIC)) ) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
 		dev_warn(&iforce_usb->intf->dev,
 			 "usb_submit_urb failed %d\n", n);
+		iforce_clear_xmit_and_wake(iforce);
 	}
 
 	/* The IFORCE_XMIT_RUNNING bit is not cleared here. That's intended.
@@ -175,15 +175,15 @@ static void iforce_usb_out(struct urb *urb)
 	struct iforce *iforce = &iforce_usb->iforce;
 
 	if (urb->status) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
 		dev_dbg(&iforce_usb->intf->dev, "urb->status %d, exiting\n",
 			urb->status);
+		iforce_clear_xmit_and_wake(iforce);
 		return;
 	}
 
 	__iforce_usb_xmit(iforce);
 
-	wake_up(&iforce->wait);
+	wake_up_all(&iforce->wait);
 }
 
 static int iforce_usb_probe(struct usb_interface *intf,
diff --git a/drivers/input/joystick/iforce/iforce.h b/drivers/input/joystick/iforce/iforce.h
index 6aa761ebbdf7..9ccb9107ccbe 100644
--- a/drivers/input/joystick/iforce/iforce.h
+++ b/drivers/input/joystick/iforce/iforce.h
@@ -119,6 +119,12 @@ static inline int iforce_get_id_packet(struct iforce *iforce, u8 id,
 					 response_data, response_len);
 }
 
+static inline void iforce_clear_xmit_and_wake(struct iforce *iforce)
+{
+	clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+	wake_up_all(&iforce->wait);
+}
+
 /* Public functions */
 /* iforce-main.c */
 int iforce_init_device(struct device *parent, u16 bustype,
diff --git a/drivers/input/misc/rk805-pwrkey.c b/drivers/input/misc/rk805-pwrkey.c
index 3fb64dbda1a2..76873aa005b4 100644
--- a/drivers/input/misc/rk805-pwrkey.c
+++ b/drivers/input/misc/rk805-pwrkey.c
@@ -98,6 +98,7 @@ static struct platform_driver rk805_pwrkey_driver = {
 };
 module_platform_driver(rk805_pwrkey_driver);
 
+MODULE_ALIAS("platform:rk805-pwrkey");
 MODULE_AUTHOR("Joseph Chen <chenjh@rock-chips.com>");
 MODULE_DESCRIPTION("RK805 PMIC Power Key driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 5f296f985b07..deb3db45a94c 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1416,42 +1416,37 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int ret;
 	struct device *dev = ir->dev;
-	char *data;
-
-	data = kzalloc(USB_CTRL_MSG_SZ, GFP_KERNEL);
-	if (!data) {
-		dev_err(dev, "%s: memory allocation failed!", __func__);
-		return;
-	}
+	char data[USB_CTRL_MSG_SZ];
 
 	/*
 	 * This is a strange one. Windows issues a set address to the device
 	 * on the receive control pipe and expect a certain value pair back
 	 */
-	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
-			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, 3000);
+	ret = usb_control_msg_recv(ir->usbdev, 0, USB_REQ_SET_ADDRESS,
+				   USB_DIR_IN | USB_TYPE_VENDOR,
+				   0, 0, data, USB_CTRL_MSG_SZ, 3000,
+				   GFP_KERNEL);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
 
 	/* set feature: bit rate 38400 bps */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
+				   0xc04e, 0x0000, NULL, 0, 3000, GFP_KERNEL);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   4, USB_TYPE_VENDOR,
+				   0x0808, 0x0000, NULL, 0, 3000, GFP_KERNEL);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   2, USB_TYPE_VENDOR,
+				   0x0000, 0x0100, NULL, 0, 3000, GFP_KERNEL);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
@@ -1459,8 +1454,6 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 
 	/* get hw/sw revision? */
 	mce_command_out(ir, GET_REVISION, sizeof(GET_REVISION));
-
-	kfree(data);
 }
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index c7134d2cf69a..cf5705776c4f 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1550,7 +1550,12 @@ static int fastrpc_cb_probe(struct platform_device *pdev)
 	of_property_read_u32(dev->of_node, "qcom,nsessions", &sessions);
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	sess = &cctx->session[cctx->sesscount];
+	if (cctx->sesscount >= FASTRPC_MAX_SESSIONS) {
+		dev_err(&pdev->dev, "too many sessions\n");
+		spin_unlock_irqrestore(&cctx->lock, flags);
+		return -ENOSPC;
+	}
+	sess = &cctx->session[cctx->sesscount++];
 	sess->used = false;
 	sess->valid = true;
 	sess->dev = dev;
@@ -1563,13 +1568,12 @@ static int fastrpc_cb_probe(struct platform_device *pdev)
 		struct fastrpc_session_ctx *dup_sess;
 
 		for (i = 1; i < sessions; i++) {
-			if (cctx->sesscount++ >= FASTRPC_MAX_SESSIONS)
+			if (cctx->sesscount >= FASTRPC_MAX_SESSIONS)
 				break;
-			dup_sess = &cctx->session[cctx->sesscount];
+			dup_sess = &cctx->session[cctx->sesscount++];
 			memcpy(dup_sess, sess, sizeof(*dup_sess));
 		}
 	}
-	cctx->sesscount++;
 	spin_unlock_irqrestore(&cctx->lock, flags);
 	rc = dma_set_mask(dev, DMA_BIT_MASK(32));
 	if (rc) {
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 44e134fa04af..7e8d4abed602 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -942,15 +942,16 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 
 		/* Erase init depends on CSD and SSR */
 		mmc_init_erase(card);
-
-		/*
-		 * Fetch switch information from card.
-		 */
-		err = mmc_read_switch(card);
-		if (err)
-			return err;
 	}
 
+	/*
+	 * Fetch switch information from card. Note, sd3_bus_mode can change if
+	 * voltage switch outcome changes, so do this always.
+	 */
+	err = mmc_read_switch(card);
+	if (err)
+		return err;
+
 	/*
 	 * For SPI, enable CRC as appropriate.
 	 * This CRC enable is located AFTER the reading of the
@@ -1473,26 +1474,15 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	if (!v18_fixup_failed && !mmc_host_is_spi(host) && mmc_host_uhs(host) &&
 	    mmc_sd_card_using_v18(card) &&
 	    host->ios.signal_voltage != MMC_SIGNAL_VOLTAGE_180) {
-		/*
-		 * Re-read switch information in case it has changed since
-		 * oldcard was initialized.
-		 */
-		if (oldcard) {
-			err = mmc_read_switch(card);
-			if (err)
-				goto free_card;
-		}
-		if (mmc_sd_card_using_v18(card)) {
-			if (mmc_host_set_uhs_voltage(host) ||
-			    mmc_sd_init_uhs_card(card)) {
-				v18_fixup_failed = true;
-				mmc_power_cycle(host, ocr);
-				if (!oldcard)
-					mmc_remove_card(card);
-				goto retry;
-			}
-			goto done;
+		if (mmc_host_set_uhs_voltage(host) ||
+		    mmc_sd_init_uhs_card(card)) {
+			v18_fixup_failed = true;
+			mmc_power_cycle(host, ocr);
+			if (!oldcard)
+				mmc_remove_card(card);
+			goto retry;
 		}
+		goto cont;
 	}
 
 	/* Initialization sequence for UHS-I cards */
@@ -1527,7 +1517,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 		}
 	}
-
+cont:
 	if (!oldcard) {
 		/* Read/parse the extension registers. */
 		err = sd_read_ext_regs(card);
@@ -1559,7 +1549,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		err = -EINVAL;
 		goto free_card;
 	}
-done:
+
 	host->card = card;
 	return 0;
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 469420941054..cf363d5a3002 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -108,6 +108,7 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
 {
 	struct xrs700x_port *p = &priv->ports[port];
 	struct rtnl_link_stats64 stats;
+	unsigned long flags;
 	int i;
 
 	memset(&stats, 0, sizeof(stats));
@@ -137,9 +138,9 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
 	 */
 	stats.rx_packets += stats.multicast;
 
-	u64_stats_update_begin(&p->syncp);
+	flags = u64_stats_update_begin_irqsave(&p->syncp);
 	p->stats64 = stats;
-	u64_stats_update_end(&p->syncp);
+	u64_stats_update_end_irqrestore(&p->syncp, flags);
 
 	mutex_unlock(&p->mib_mutex);
 }
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 012ca11a38cc..8361faf03e42 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1920,7 +1920,7 @@ static void gmac_get_stats64(struct net_device *netdev,
 
 	/* Racing with RX NAPI */
 	do {
-		start = u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
 
 		stats->rx_packets = port->stats.rx_packets;
 		stats->rx_bytes = port->stats.rx_bytes;
@@ -1932,11 +1932,11 @@ static void gmac_get_stats64(struct net_device *netdev,
 		stats->rx_crc_errors = port->stats.rx_crc_errors;
 		stats->rx_frame_errors = port->stats.rx_frame_errors;
 
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
 
 	/* Racing with MIB and TX completion interrupts */
 	do {
-		start = u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
 
 		stats->tx_errors = port->stats.tx_errors;
 		stats->tx_packets = port->stats.tx_packets;
@@ -1946,15 +1946,15 @@ static void gmac_get_stats64(struct net_device *netdev,
 		stats->rx_missed_errors = port->stats.rx_missed_errors;
 		stats->rx_fifo_errors = port->stats.rx_fifo_errors;
 
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
 
 	/* Racing with hard_start_xmit */
 	do {
-		start = u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
 
 		stats->tx_dropped = port->stats.tx_dropped;
 
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
 
 	stats->rx_dropped += stats->rx_missed_errors;
 }
@@ -2032,18 +2032,18 @@ static void gmac_get_ethtool_stats(struct net_device *netdev,
 	/* Racing with MIB interrupt */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
 
 		for (i = 0; i < RX_STATS_NUM; i++)
 			*p++ = port->hw_stats[i];
 
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
 	values = p;
 
 	/* Racing with RX NAPI */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
 
 		for (i = 0; i < RX_STATUS_NUM; i++)
 			*p++ = port->rx_stats[i];
@@ -2051,13 +2051,13 @@ static void gmac_get_ethtool_stats(struct net_device *netdev,
 			*p++ = port->rx_csum_stats[i];
 		*p++ = port->rx_napi_exits;
 
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
 	values = p;
 
 	/* Racing with TX start_xmit */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
 
 		for (i = 0; i < TX_MAX_FRAGS; i++) {
 			*values++ = port->tx_frag_stats[i];
@@ -2066,7 +2066,7 @@ static void gmac_get_ethtool_stats(struct net_device *netdev,
 		*values++ = port->tx_frags_linearized;
 		*values++ = port->tx_hw_csummed;
 
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
 }
 
 static int gmac_get_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 716e6240305d..878329ddcf8d 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -174,14 +174,14 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				struct gve_rx_ring *rx = &priv->rx[ring];
 
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_pkts = rx->rpackets;
 				tmp_rx_bytes = rx->rbytes;
 				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			rx_pkts += tmp_rx_pkts;
 			rx_bytes += tmp_rx_bytes;
@@ -195,10 +195,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		if (priv->tx) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_pkts = priv->tx[ring].pkt_done;
 				tmp_tx_bytes = priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			tx_pkts += tmp_tx_pkts;
 			tx_bytes += tmp_tx_bytes;
@@ -256,13 +256,13 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = rx->cnt;
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_bytes = rx->rbytes;
 				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			data[i++] = tmp_rx_bytes;
 			/* rx dropped packets */
@@ -323,9 +323,9 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			}
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_bytes = tx->bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			data[i++] = tmp_tx_bytes;
 			data[i++] = tx->wake_queue;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 68552848d388..49850cf7cfaf 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -51,10 +51,10 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				packets = priv->rx[ring].rpackets;
 				bytes = priv->rx[ring].rbytes;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			s->rx_packets += packets;
 			s->rx_bytes += bytes;
@@ -64,10 +64,10 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				packets = priv->tx[ring].pkt_done;
 				bytes = priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			s->tx_packets += packets;
 			s->tx_bytes += bytes;
@@ -1260,9 +1260,9 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			}
 
 			do {
-				start = u64_stats_fetch_begin(&priv->tx[idx].statss);
+				start = u64_stats_fetch_begin_irq(&priv->tx[idx].statss);
 				tx_bytes = priv->tx[idx].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[idx].statss, start));
+			} while (u64_stats_fetch_retry_irq(&priv->tx[idx].statss, start));
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(TX_WAKE_CNT),
 				.value = cpu_to_be64(priv->tx[idx].wake_queue),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index a102d486c435..d11ec69a2e17 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -74,14 +74,14 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&rxq_stats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxq_stats->syncp);
 		stats->pkts = rxq_stats->pkts;
 		stats->bytes = rxq_stats->bytes;
 		stats->errors = rxq_stats->csum_errors +
 				rxq_stats->other_errors;
 		stats->csum_errors = rxq_stats->csum_errors;
 		stats->other_errors = rxq_stats->other_errors;
-	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxq_stats->syncp, start));
 }
 
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index d1ea358a1fc0..8d3ec6c729cc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -98,14 +98,14 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&txq_stats->syncp);
+		start = u64_stats_fetch_begin_irq(&txq_stats->syncp);
 		stats->pkts    = txq_stats->pkts;
 		stats->bytes   = txq_stats->bytes;
 		stats->tx_busy = txq_stats->tx_busy;
 		stats->tx_wake = txq_stats->tx_wake;
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
-	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&txq_stats->syncp, start));
 }
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index e3509e69ed1c..3e8725b7f0b7 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -80,6 +80,7 @@ struct mlxbf_gige {
 	struct net_device *netdev;
 	struct platform_device *pdev;
 	void __iomem *mdio_io;
+	void __iomem *clk_io;
 	struct mii_bus *mdiobus;
 	void __iomem *gpio_io;
 	struct irq_domain *irqdomain;
@@ -149,7 +150,8 @@ enum mlxbf_gige_res {
 	MLXBF_GIGE_RES_MDIO9,
 	MLXBF_GIGE_RES_GPIO0,
 	MLXBF_GIGE_RES_LLU,
-	MLXBF_GIGE_RES_PLU
+	MLXBF_GIGE_RES_PLU,
+	MLXBF_GIGE_RES_CLK
 };
 
 /* Version of register data returned by mlxbf_gige_get_regs() */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 7905179a9575..f979ba7e5eff 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -22,10 +22,23 @@
 #include <linux/property.h>
 
 #include "mlxbf_gige.h"
+#include "mlxbf_gige_regs.h"
 
 #define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
 #define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
 
+#define MLXBF_GIGE_MDIO_FREQ_REFERENCE 156250000ULL
+#define MLXBF_GIGE_MDIO_COREPLL_CONST  16384ULL
+#define MLXBF_GIGE_MDC_CLK_NS          400
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG1 0x4
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG2 0x8
+#define MLXBF_GIGE_MDIO_CORE_F_SHIFT   0
+#define MLXBF_GIGE_MDIO_CORE_F_MASK    GENMASK(25, 0)
+#define MLXBF_GIGE_MDIO_CORE_R_SHIFT   26
+#define MLXBF_GIGE_MDIO_CORE_R_MASK    GENMASK(31, 26)
+#define MLXBF_GIGE_MDIO_CORE_OD_SHIFT  0
+#define MLXBF_GIGE_MDIO_CORE_OD_MASK   GENMASK(3, 0)
+
 /* Support clause 22 */
 #define MLXBF_GIGE_MDIO_CL22_ST1	0x1
 #define MLXBF_GIGE_MDIO_CL22_WRITE	0x1
@@ -50,27 +63,76 @@
 #define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
 #define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
 
+#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+
+#define MLXBF_GIGE_BF2_COREPLL_ADDR 0x02800c30
+#define MLXBF_GIGE_BF2_COREPLL_SIZE 0x0000000c
+
+static struct resource corepll_params[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.start = MLXBF_GIGE_BF2_COREPLL_ADDR,
+		.end = MLXBF_GIGE_BF2_COREPLL_ADDR + MLXBF_GIGE_BF2_COREPLL_SIZE - 1,
+		.name = "COREPLL_RES"
+	},
+};
+
+/* Returns core clock i1clk in Hz */
+static u64 calculate_i1clk(struct mlxbf_gige *priv)
+{
+	u8 core_od, core_r;
+	u64 freq_output;
+	u32 reg1, reg2;
+	u32 core_f;
+
+	reg1 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG1);
+	reg2 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG2);
+
+	core_f = (reg1 & MLXBF_GIGE_MDIO_CORE_F_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_F_SHIFT;
+	core_r = (reg1 & MLXBF_GIGE_MDIO_CORE_R_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_R_SHIFT;
+	core_od = (reg2 & MLXBF_GIGE_MDIO_CORE_OD_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_OD_SHIFT;
+
+	/* Compute PLL output frequency as follow:
+	 *
+	 *                                     CORE_F / 16384
+	 * freq_output = freq_reference * ----------------------------
+	 *                              (CORE_R + 1) * (CORE_OD + 1)
+	 */
+	freq_output = div_u64((MLXBF_GIGE_MDIO_FREQ_REFERENCE * core_f),
+			      MLXBF_GIGE_MDIO_COREPLL_CONST);
+	freq_output = div_u64(freq_output, (core_r + 1) * (core_od + 1));
+
+	return freq_output;
+}
+
 /* Formula for encoding the MDIO period. The encoded value is
  * passed to the MDIO config register.
  *
- * mdc_clk = 2*(val + 1)*i1clk
+ * mdc_clk = 2*(val + 1)*(core clock in sec)
  *
- * 400 ns = 2*(val + 1)*(((1/430)*1000) ns)
+ * i1clk is in Hz:
+ * 400 ns = 2*(val + 1)*(1/i1clk)
  *
- * val = (((400 * 430 / 1000) / 2) - 1)
+ * val = (((400/10^9) / (1/i1clk) / 2) - 1)
+ * val = (400/2 * i1clk)/10^9 - 1
  */
-#define MLXBF_GIGE_I1CLK_MHZ		430
-#define MLXBF_GIGE_MDC_CLK_NS		400
+static u8 mdio_period_map(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u64 i1clk;
 
-#define MLXBF_GIGE_MDIO_PERIOD	(((MLXBF_GIGE_MDC_CLK_NS * MLXBF_GIGE_I1CLK_MHZ / 1000) / 2) - 1)
+	i1clk = calculate_i1clk(priv);
 
-#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, \
-					    MLXBF_GIGE_MDIO_PERIOD) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+	mdio_period = div_u64((MLXBF_GIGE_MDC_CLK_NS >> 1) * i1clk, 1000000000) - 1;
+
+	return mdio_period;
+}
 
 static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
 				      int phy_reg, u32 opcode)
@@ -123,9 +185,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 				 int phy_reg, u16 val)
 {
 	struct mlxbf_gige *priv = bus->priv;
+	u32 temp;
 	u32 cmd;
 	int ret;
-	u32 temp;
 
 	if (phy_reg & MII_ADDR_C45)
 		return -EOPNOTSUPP;
@@ -142,18 +204,44 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	return ret;
 }
 
+static void mlxbf_gige_mdio_cfg(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u32 val;
+
+	mdio_period = mdio_period_map(priv);
+
+	val = MLXBF_GIGE_MDIO_CFG_VAL;
+	val |= FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
+	writel(val, priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+}
+
 int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 {
 	struct device *dev = &pdev->dev;
+	struct resource *res;
 	int ret;
 
 	priv->mdio_io = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MDIO9);
 	if (IS_ERR(priv->mdio_io))
 		return PTR_ERR(priv->mdio_io);
 
-	/* Configure mdio parameters */
-	writel(MLXBF_GIGE_MDIO_CFG_VAL,
-	       priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+	/* clk resource shared with other drivers so cannot use
+	 * devm_platform_ioremap_resource
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_CLK);
+	if (!res) {
+		/* For backward compatibility with older ACPI tables, also keep
+		 * CLK resource internal to the driver.
+		 */
+		res = &corepll_params[MLXBF_GIGE_VERSION_BF2];
+	}
+
+	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(priv->clk_io))
+		return PTR_ERR(priv->clk_io);
+
+	mlxbf_gige_mdio_cfg(priv);
 
 	priv->mdiobus = devm_mdiobus_alloc(dev);
 	if (!priv->mdiobus) {
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 5fb33c9294bf..7be3a793984d 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -8,6 +8,8 @@
 #ifndef __MLXBF_GIGE_REGS_H__
 #define __MLXBF_GIGE_REGS_H__
 
+#define MLXBF_GIGE_VERSION                            0x0000
+#define MLXBF_GIGE_VERSION_BF2                        0x0
 #define MLXBF_GIGE_STATUS                             0x0010
 #define MLXBF_GIGE_STATUS_READY                       BIT(0)
 #define MLXBF_GIGE_INT_STATUS                         0x0028
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 148d431fcde4..c460168131c2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -107,6 +107,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 			/* This assumes STATUS_WORD_POS == 1, Status
 			 * just after last data
 			 */
+			if (!byte_swap)
+				val = ntohl((__force __be32)val);
 			byte_cnt -= (4 - XTR_VALID_BYTES(val));
 			eof_flag = true;
 			break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 850bfdf83d0a..69ac205bbdbd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3482,21 +3482,21 @@ static void nfp_net_stat64(struct net_device *netdev,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin(&r_vec->rx_sync);
+			start = u64_stats_fetch_begin_irq(&r_vec->rx_sync);
 			data[0] = r_vec->rx_pkts;
 			data[1] = r_vec->rx_bytes;
 			data[2] = r_vec->rx_drops;
-		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->rx_sync, start));
 		stats->rx_packets += data[0];
 		stats->rx_bytes += data[1];
 		stats->rx_dropped += data[2];
 
 		do {
-			start = u64_stats_fetch_begin(&r_vec->tx_sync);
+			start = u64_stats_fetch_begin_irq(&r_vec->tx_sync);
 			data[0] = r_vec->tx_pkts;
 			data[1] = r_vec->tx_bytes;
 			data[2] = r_vec->tx_errors;
-		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->tx_sync, start));
 		stats->tx_packets += data[0];
 		stats->tx_bytes += data[1];
 		stats->tx_errors += data[2];
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index ae72cde71343..62546d197bfd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -483,7 +483,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin(&nn->r_vecs[i].rx_sync);
+			start = u64_stats_fetch_begin_irq(&nn->r_vecs[i].rx_sync);
 			data[0] = nn->r_vecs[i].rx_pkts;
 			tmp[0] = nn->r_vecs[i].hw_csum_rx_ok;
 			tmp[1] = nn->r_vecs[i].hw_csum_rx_inner_ok;
@@ -491,10 +491,10 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 			tmp[3] = nn->r_vecs[i].hw_csum_rx_error;
 			tmp[4] = nn->r_vecs[i].rx_replace_buf_alloc_fail;
 			tmp[5] = nn->r_vecs[i].hw_tls_rx;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].rx_sync, start));
 
 		do {
-			start = u64_stats_fetch_begin(&nn->r_vecs[i].tx_sync);
+			start = u64_stats_fetch_begin_irq(&nn->r_vecs[i].tx_sync);
 			data[1] = nn->r_vecs[i].tx_pkts;
 			data[2] = nn->r_vecs[i].tx_busy;
 			tmp[6] = nn->r_vecs[i].hw_csum_tx;
@@ -504,7 +504,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 			tmp[10] = nn->r_vecs[i].hw_tls_tx;
 			tmp[11] = nn->r_vecs[i].tls_tx_fallback;
 			tmp[12] = nn->r_vecs[i].tls_tx_no_fallback;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].tx_sync, start));
 
 		data += NN_RVEC_PER_Q_STATS;
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index bc70c6abd6a5..58cf7cc54f40 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1273,7 +1273,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 592e191adbf7..63b99dd8ca51 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -2584,6 +2586,8 @@ static int smsc911x_suspend(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
+		if (!device_may_wakeup(dev))
+			phy_stop(ndev->phydev);
 	}
 
 	/* enable wake on LAN, energy detection and the external PME
@@ -2625,6 +2629,8 @@ static int smsc911x_resume(struct device *dev)
 	if (netif_running(ndev)) {
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
+		if (!device_may_wakeup(dev))
+			phy_start(ndev->phydev);
 	}
 
 	return 0;
diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 7db9cbd0f5de..07adbeec1978 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1310,10 +1310,11 @@ static int adf7242_remove(struct spi_device *spi)
 
 	debugfs_remove_recursive(lp->debugfs_root);
 
+	ieee802154_unregister_hw(lp->hw);
+
 	cancel_delayed_work_sync(&lp->work);
 	destroy_workqueue(lp->wqueue);
 
-	ieee802154_unregister_hw(lp->hw);
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 50572e0f1f52..84741715f670 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -67,10 +67,10 @@ nsim_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&ns->syncp);
+		start = u64_stats_fetch_begin_irq(&ns->syncp);
 		stats->tx_bytes = ns->tx_bytes;
 		stats->tx_packets = ns->tx_packets;
-	} while (u64_stats_fetch_retry(&ns->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&ns->syncp, start));
 }
 
 static int
diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index a9d2a4b98e57..4b0739f95f8b 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -244,7 +244,7 @@ static void pmc_power_off(void)
 	pm1_cnt_port = acpi_base_addr + PM1_CNT;
 
 	pm1_cnt_value = inl(pm1_cnt_port);
-	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value &= ~SLEEP_TYPE_MASK;
 	pm1_cnt_value |= SLEEP_TYPE_S5;
 	pm1_cnt_value |= SLEEP_ENABLE;
 
diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 2adc0a75c051..1ce6f948e9a4 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -148,7 +148,7 @@ struct qcom_swrm_ctrl {
 	u8 wcmd_id;
 	struct qcom_swrm_port_config pconfig[QCOM_SDW_MAX_PORTS];
 	struct sdw_stream_runtime *sruntime[SWRM_MAX_DAIS];
-	enum sdw_slave_status status[SDW_MAX_DEVICES];
+	enum sdw_slave_status status[SDW_MAX_DEVICES + 1];
 	int (*reg_read)(struct qcom_swrm_ctrl *ctrl, int reg, u32 *val);
 	int (*reg_write)(struct qcom_swrm_ctrl *ctrl, int reg, int val);
 	u32 slave_status;
@@ -391,7 +391,7 @@ static int qcom_swrm_get_alert_slave_dev_num(struct qcom_swrm_ctrl *ctrl)
 
 	ctrl->reg_read(ctrl, SWRM_MCP_SLV_STATUS, &val);
 
-	for (dev_num = 0; dev_num < SDW_MAX_DEVICES; dev_num++) {
+	for (dev_num = 0; dev_num <= SDW_MAX_DEVICES; dev_num++) {
 		status = (val >> (dev_num * SWRM_MCP_SLV_STATUS_SZ));
 
 		if ((status & SWRM_MCP_SLV_STATUS_MASK) == SDW_SLAVE_ALERT) {
@@ -411,7 +411,7 @@ static void qcom_swrm_get_device_status(struct qcom_swrm_ctrl *ctrl)
 	ctrl->reg_read(ctrl, SWRM_MCP_SLV_STATUS, &val);
 	ctrl->slave_status = val;
 
-	for (i = 0; i < SDW_MAX_DEVICES; i++) {
+	for (i = 0; i <= SDW_MAX_DEVICES; i++) {
 		u32 s;
 
 		s = (val >> (i * 2));
diff --git a/drivers/staging/r8188eu/os_dep/os_intfs.c b/drivers/staging/r8188eu/os_dep/os_intfs.c
index 8d0158f4a45d..30caa1139c8e 100644
--- a/drivers/staging/r8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/r8188eu/os_dep/os_intfs.c
@@ -17,6 +17,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
 MODULE_VERSION(DRIVERVERSION);
+MODULE_FIRMWARE("rtlwifi/rtl8188eufw.bin");
 
 #define CONFIG_BR_EXT_BRNAME "br0"
 #define RTW_NOTCH_FILTER 0 /* 0:Disable, 1:Enable, */
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index e9294e1ed06e..eacf5efa3430 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -117,34 +117,6 @@ static void r871x_internal_cmd_hdl(struct _adapter *padapter, u8 *pbuf)
 	kfree(pdrvcmd->pbuf);
 }
 
-static u8 read_macreg_hdl(struct _adapter *padapter, u8 *pbuf)
-{
-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
-	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
-
-	/*  invoke cmd->callback function */
-	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
-	if (!pcmd_callback)
-		r8712_free_cmd_obj(pcmd);
-	else
-		pcmd_callback(padapter, pcmd);
-	return H2C_SUCCESS;
-}
-
-static u8 write_macreg_hdl(struct _adapter *padapter, u8 *pbuf)
-{
-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
-	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
-
-	/*  invoke cmd->callback function */
-	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
-	if (!pcmd_callback)
-		r8712_free_cmd_obj(pcmd);
-	else
-		pcmd_callback(padapter, pcmd);
-	return H2C_SUCCESS;
-}
-
 static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
@@ -213,14 +185,6 @@ static struct cmd_obj *cmd_hdl_filter(struct _adapter *padapter,
 	pcmd_r = NULL;
 
 	switch (pcmd->cmdcode) {
-	case GEN_CMD_CODE(_Read_MACREG):
-		read_macreg_hdl(padapter, (u8 *)pcmd);
-		pcmd_r = pcmd;
-		break;
-	case GEN_CMD_CODE(_Write_MACREG):
-		write_macreg_hdl(padapter, (u8 *)pcmd);
-		pcmd_r = pcmd;
-		break;
 	case GEN_CMD_CODE(_Read_BBREG):
 		read_bbreg_hdl(padapter, (u8 *)pcmd);
 		break;
diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 0fb5e04191e2..409ee1551a7c 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -408,7 +408,7 @@ static void tb_ctl_rx_submit(struct ctl_pkg *pkg)
 
 static int tb_async_error(const struct ctl_pkg *pkg)
 {
-	const struct cfg_error_pkg *error = (const struct cfg_error_pkg *)pkg;
+	const struct cfg_error_pkg *error = pkg->buffer;
 
 	if (pkg->frame.eof != TB_CFG_PKG_ERROR)
 		return false;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index b89655f585f1..154697be11b0 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2753,7 +2753,8 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			flags = *fp++;
 		switch (flags) {
 		case TTY_NORMAL:
-			gsm->receive(gsm, *cp);
+			if (gsm->receive)
+				gsm->receive(gsm, *cp);
 			break;
 		case TTY_OVERRUN:
 		case TTY_BREAK:
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 4155bd10711d..bf11ffafcad5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1381,9 +1381,9 @@ static int lpuart_config_rs485(struct uart_port *port,
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
-		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
 			modem |= UARTMODEM_TXRTSPOL;
+		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
+			modem &= ~UARTMODEM_TXRTSPOL;
 	}
 
 	/* Store the new configuration */
@@ -2203,6 +2203,7 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* wait transmit engin complete */
+	lpuart32_write(&sport->port, 0, UARTMODIR);
 	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
 
 	/* disable transmit and receive */
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 6eaf8eb84661..b8f5bc19416d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4662,9 +4662,11 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 	console_lock();
 	if (vc->vc_mode != KD_TEXT)
 		rc = -EINVAL;
-	else if (vc->vc_sw->con_font_set)
+	else if (vc->vc_sw->con_font_set) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	kfree(font.data);
@@ -4691,9 +4693,11 @@ static int con_font_default(struct vc_data *vc, struct console_font_op *op)
 		console_unlock();
 		return -EINVAL;
 	}
-	if (vc->vc_sw->con_font_default)
+	if (vc->vc_sw->con_font_default) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_default(vc, &font, s);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	if (!rc) {
diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 3f1ce8911077..1802f6818e63 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1530,7 +1530,8 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 						TRB_LEN(le32_to_cpu(trb->length));
 
 				if (priv_req->num_of_trb > 1 &&
-					le32_to_cpu(trb->control) & TRB_SMM)
+					le32_to_cpu(trb->control) & TRB_SMM &&
+					le32_to_cpu(trb->control) & TRB_CHAIN)
 					transfer_end = true;
 
 				cdns3_ep_inc_deq(priv_ep);
@@ -1690,6 +1691,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7b2e2420ecae..adc154b691d0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1814,6 +1814,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x09d8, 0x0320), /* Elatec GmbH TWN3 */
 	.driver_info = NO_UNION_NORMAL, /* has misplaced union descriptor */
 	},
+	{ USB_DEVICE(0x0c26, 0x0020), /* Icom ICF3400 Serie */
+	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
+	},
 	{ USB_DEVICE(0x0ca6, 0xa050), /* Castles VEGA3000 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index ac6c5ccfe1cb..23896c8e018a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6043,6 +6043,11 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
  * the reset is over (using their post_reset method).
  *
  * Return: The same as for usb_reset_and_verify_device().
+ * However, if a reset is already in progress (for instance, if a
+ * driver doesn't have pre_ or post_reset() callbacks, and while
+ * being unbound or re-bound during the ongoing reset its disconnect()
+ * or probe() routine tries to perform a second, nested reset), the
+ * routine returns -EINPROGRESS.
  *
  * Note:
  * The caller must own the device lock.  For example, it's safe to use
@@ -6076,6 +6081,10 @@ int usb_reset_device(struct usb_device *udev)
 		return -EISDIR;
 	}
 
+	if (udev->reset_in_progress)
+		return -EINPROGRESS;
+	udev->reset_in_progress = 1;
+
 	port_dev = hub->ports[udev->portnum - 1];
 
 	/*
@@ -6140,6 +6149,7 @@ int usb_reset_device(struct usb_device *udev)
 
 	usb_autosuspend_device(udev);
 	memalloc_noio_restore(noio_flag);
+	udev->reset_in_progress = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index c331a5128c2c..265d437ca0f1 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -154,9 +154,9 @@ static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 	} else if (hsotg->plat && hsotg->plat->phy_init) {
 		ret = hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 	} else {
-		ret = phy_power_on(hsotg->phy);
+		ret = phy_init(hsotg->phy);
 		if (ret == 0)
-			ret = phy_init(hsotg->phy);
+			ret = phy_power_on(hsotg->phy);
 	}
 
 	return ret;
@@ -188,9 +188,9 @@ static int __dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
 	} else if (hsotg->plat && hsotg->plat->phy_exit) {
 		ret = hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 	} else {
-		ret = phy_exit(hsotg->phy);
+		ret = phy_power_off(hsotg->phy);
 		if (ret == 0)
-			ret = phy_power_off(hsotg->phy);
+			ret = phy_exit(hsotg->phy);
 	}
 	if (ret)
 		return ret;
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index cfac5503aa66..9c24cf46b9a0 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -731,15 +731,16 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 {
 	dwc3_event_buffers_cleanup(dwc);
 
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
+
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
 	phy_exit(dwc->usb2_generic_phy);
 	phy_exit(dwc->usb3_generic_phy);
 
-	usb_phy_set_suspend(dwc->usb2_phy, 1);
-	usb_phy_set_suspend(dwc->usb3_phy, 1);
-	phy_power_off(dwc->usb2_generic_phy);
-	phy_power_off(dwc->usb3_generic_phy);
 	clk_bulk_disable_unprepare(dwc->num_clks, dwc->clks);
 	reset_control_assert(dwc->reset);
 }
@@ -1662,16 +1663,16 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_debugfs_exit(dwc);
 	dwc3_event_buffers_cleanup(dwc);
 
-	usb_phy_shutdown(dwc->usb2_phy);
-	usb_phy_shutdown(dwc->usb3_phy);
-	phy_exit(dwc->usb2_generic_phy);
-	phy_exit(dwc->usb3_generic_phy);
-
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 	phy_power_off(dwc->usb2_generic_phy);
 	phy_power_off(dwc->usb3_generic_phy);
 
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
 	dwc3_ulpi_exit(dwc);
 
 err4:
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 9c8887615701..c52f7b5b5ec0 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -43,6 +43,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
+#define PCI_DEVICE_ID_INTEL_RPL			0x460e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
@@ -420,6 +421,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 873bf5041117..d0352daab012 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -296,6 +296,14 @@ static void dwc3_qcom_interconnect_exit(struct dwc3_qcom *qcom)
 	icc_put(qcom->icc_path_apps);
 }
 
+/* Only usable in contexts where the role can not change. */
+static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
+{
+	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
+
+	return dwc->xhci;
+}
+
 static void dwc3_qcom_disable_interrupts(struct dwc3_qcom *qcom)
 {
 	if (qcom->hs_phy_irq) {
@@ -411,7 +419,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
 	if (qcom->pm_suspended)
 		return IRQ_HANDLED;
 
-	if (dwc->xhci)
+	/*
+	 * This is safe as role switching is done from a freezable workqueue
+	 * and the wakeup interrupts are disabled as part of resume.
+	 */
+	if (dwc3_qcom_is_host(qcom))
 		pm_runtime_resume(&dwc->xhci->dev);
 
 	return IRQ_HANDLED;
diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index f29a264635aa..85165a972076 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -10,8 +10,13 @@
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
 
+#include "../host/xhci-plat.h"
 #include "core.h"
 
+static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
+	.quirks = XHCI_SKIP_PHY_INIT,
+};
+
 static int dwc3_host_get_irq(struct dwc3 *dwc)
 {
 	struct platform_device	*dwc3_pdev = to_platform_device(dwc->dev);
@@ -87,6 +92,11 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
+	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
+					sizeof(dwc3_xhci_plat_priv));
+	if (ret)
+		goto err;
+
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)
@@ -130,4 +140,5 @@ int dwc3_host_init(struct dwc3 *dwc)
 void dwc3_host_exit(struct dwc3 *dwc)
 {
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }
diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index b859a158a414..e122050eebaf 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -294,8 +294,10 @@ EXPORT_SYMBOL_GPL(fsg_lun_fsync_sub);
 void store_cdrom_address(u8 *dest, int msf, u32 addr)
 {
 	if (msf) {
-		/* Convert to Minutes-Seconds-Frames */
-		addr >>= 2;		/* Convert to 2048-byte frames */
+		/*
+		 * Convert to Minutes-Seconds-Frames.
+		 * Sector size is already set to 2048 bytes.
+		 */
 		addr += 2*75;		/* Lead-in occupies 2 seconds */
 		dest[3] = addr % 75;	/* Frames */
 		addr /= 75;
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index fc322a9526c8..b9754784161d 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
@@ -1647,6 +1647,17 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 	status = bus_state->resuming_ports;
 
+	/*
+	 * SS devices are only visible to roothub after link training completes.
+	 * Keep polling roothubs for a grace period after xHC start
+	 */
+	if (xhci->run_graceperiod) {
+		if (time_before(jiffies, xhci->run_graceperiod))
+			status = 1;
+		else
+			xhci->run_graceperiod = 0;
+	}
+
 	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC | PORT_CEC;
 
 	/* For each port, did anything change?  If so, set that bit in buf. */
diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index f91a30432056..9d8094afcc8b 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -476,7 +476,6 @@ static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
 
 static int check_sch_tt(struct mu3h_sch_ep_info *sch_ep, u32 offset)
 {
-	u32 extra_cs_count;
 	u32 start_ss, last_ss;
 	u32 start_cs, last_cs;
 
@@ -512,18 +511,12 @@ static int check_sch_tt(struct mu3h_sch_ep_info *sch_ep, u32 offset)
 		if (last_cs > 7)
 			return -ESCH_CS_OVERFLOW;
 
-		if (sch_ep->ep_type == ISOC_IN_EP)
-			extra_cs_count = (last_cs == 7) ? 1 : 2;
-		else /*  ep_type : INTR IN / INTR OUT */
-			extra_cs_count = 1;
-
-		cs_count += extra_cs_count;
 		if (cs_count > 7)
 			cs_count = 7; /* HW limit */
 
 		sch_ep->cs_count = cs_count;
-		/* one for ss, the other for idle */
-		sch_ep->num_budget_microframes = cs_count + 2;
+		/* ss, idle are ignored */
+		sch_ep->num_budget_microframes = cs_count;
 
 		/*
 		 * if interval=1, maxp >752, num_budge_micoframe is larger
@@ -822,8 +815,8 @@ int xhci_mtk_drop_ep(struct usb_hcd *hcd, struct usb_device *udev,
 	if (ret)
 		return ret;
 
-	if (ep->hcpriv)
-		drop_ep_quirk(hcd, udev, ep);
+	/* needn't check @ep->hcpriv, xhci_endpoint_disable set it NULL */
+	drop_ep_quirk(hcd, udev, ep);
 
 	return 0;
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d76c10f9ad80..3cac7e40456e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -148,9 +148,11 @@ int xhci_start(struct xhci_hcd *xhci)
 		xhci_err(xhci, "Host took too long to start, "
 				"waited %u microseconds.\n",
 				XHCI_MAX_HALT_USEC);
-	if (!ret)
+	if (!ret) {
 		/* clear state flags. Including dying, halted or removing */
 		xhci->xhc_state = 0;
+		xhci->run_graceperiod = jiffies + msecs_to_jiffies(500);
+	}
 
 	return ret;
 }
@@ -776,8 +778,6 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	unsigned long flags;
-	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -793,21 +793,12 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irqsave(&xhci->lock, flags);
+	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-
-	/* Power off USB2 ports*/
-	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
-
-	/* Power off USB3 ports*/
-	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
-
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irqrestore(&xhci->lock, flags);
+	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 101f1956a96c..10a4230d95c3 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1830,7 +1830,7 @@ struct xhci_hcd {
 
 	/* Host controller watchdog timer structures */
 	unsigned int		xhc_state;
-
+	unsigned long		run_graceperiod;
 	u32			command;
 	struct s3_save		s3;
 /* Host controller is dying - not responding to commands. "I'm not dead yet!"
@@ -2174,8 +2174,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
-			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 4d61df6a9b5c..70693cae83ef 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -86,7 +86,7 @@ config USB_MUSB_TUSB6010
 	tristate "TUSB6010"
 	depends on HAS_IOMEM
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
-	depends on NOP_USB_XCEIV = USB_MUSB_HDRC # both built-in or both modules
+	depends on NOP_USB_XCEIV!=m || USB_MUSB_HDRC=m
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index b5a1864e9cfd..752daa952abd 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -97,7 +97,10 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
 	unsigned long quirks;
+	u8 version;
+
 	unsigned long break_end;
 };
 
@@ -256,8 +259,12 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	/*
 	 * CH341A buffers data until a full endpoint-size packet (32 bytes)
 	 * has been received unless bit 7 is set.
+	 *
+	 * At least one device with version 0x27 appears to have this bit
+	 * inverted.
 	 */
-	val |= BIT(7);
+	if (priv->version > 0x27)
+		val |= BIT(7);
 
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_DIVISOR << 8 | CH341_REG_PRESCALER,
@@ -271,6 +278,9 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	 * (stop bits, parity and word length). Version 0x30 and above use
 	 * CH341_REG_LCR only and CH341_REG_LCR2 is always set to zero.
 	 */
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_LCR2 << 8 | CH341_REG_LCR, lcr);
 	if (r)
@@ -323,7 +333,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index bd006e1712cc..a2126b07e854 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -130,6 +130,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8414) }, /* Decagon USB Cable Adapter */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8470) }, /* Juniper Networks BX Series System Console */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e2a8c33f0cae..a2ecb3b5d13e 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1045,6 +1045,8 @@ static const struct usb_device_id id_table_combined[] = {
 	/* IDS GmbH devices */
 	{ USB_DEVICE(IDS_VID, IDS_SI31A_PID) },
 	{ USB_DEVICE(IDS_VID, IDS_CM31A_PID) },
+	/* Omron devices */
+	{ USB_DEVICE(OMRON_VID, OMRON_CS1W_CIF31_PID) },
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 4e92c165c86b..31c8ccabbbb7 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -661,6 +661,12 @@
 #define INFINEON_TRIBOARD_TC1798_PID	0x0028 /* DAS JTAG TriBoard TC1798 V1.0 */
 #define INFINEON_TRIBOARD_TC2X7_PID	0x0043 /* DAS JTAG TriBoard TC2X7 V1.0 */
 
+/*
+ * Omron corporation (https://www.omron.com)
+ */
+ #define OMRON_VID			0x0590
+ #define OMRON_CS1W_CIF31_PID		0x00b2
+
 /*
  * Acton Research Corp.
  */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index de59fa919540..a5e8374a8d71 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -253,6 +253,7 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM05G			0x030a
+#define QUECTEL_PRODUCT_EM060K			0x030b
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
@@ -438,6 +439,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_MV31_2_RMNET		0x00b9
 #define CINTERION_PRODUCT_MV32_WA		0x00f1
 #define CINTERION_PRODUCT_MV32_WB		0x00f2
+#define CINTERION_PRODUCT_MV32_WA_RMNET		0x00f3
+#define CINTERION_PRODUCT_MV32_WB_RMNET		0x00f4
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -573,6 +576,10 @@ static void option_instat_callback(struct urb *urb);
 #define WETELECOM_PRODUCT_6802			0x6802
 #define WETELECOM_PRODUCT_WMD300		0x6803
 
+/* OPPO products */
+#define OPPO_VENDOR_ID				0x22d9
+#define OPPO_PRODUCT_R11			0x276c
+
 
 /* Device flags */
 
@@ -1138,6 +1145,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0x00, 0x40) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
@@ -1993,8 +2003,12 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(0)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA, 0xff),
 	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA_RMNET, 0xff),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB, 0xff),
 	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB_RMNET, 0xff),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD120),
@@ -2155,6 +2169,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
+	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1a05e3dcfec8..4993227ab293 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2294,6 +2294,13 @@ UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0000,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Witold Lipieta <witold.lipieta@thaumatec.com> */
+UNUSUAL_DEV( 0x1fc9, 0x0117, 0x0100, 0x0100,
+		"NXP Semiconductors",
+		"PN7462AU",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /* Supplied with some Castlewood ORB removable drives */
 UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		"Double-H Technology",
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index b7f094435b00..998c1e3e318e 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -88,8 +88,8 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 	case DP_STATUS_CON_UFP_D:
 	case DP_STATUS_CON_BOTH: /* NOTE: First acting as DP source */
 		conf |= DP_CONF_UFP_U_AS_UFP_D;
-		pin_assign = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo) &
-			     DP_CAP_UFP_D_PIN_ASSIGN(dp->port->vdo);
+		pin_assign = DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo) &
+				 DP_CAP_PIN_ASSIGN_DFP_D(dp->port->vdo);
 		break;
 	default:
 		break;
diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 2cdd22130834..5daec9d79e94 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -554,9 +554,11 @@ static int pmc_usb_register_port(struct pmc_usb *pmc, int index,
 
 static int is_memory(struct acpi_resource *res, void *data)
 {
-	struct resource r;
+	struct resource_win win = {};
+	struct resource *r = &win.res;
 
-	return !acpi_dev_resource_memory(res, &r);
+	return !(acpi_dev_resource_memory(res, r) ||
+		 acpi_dev_resource_address_space(res, &win));
 }
 
 /* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
@@ -566,6 +568,9 @@ static const struct acpi_device_id iom_acpi_ids[] = {
 
 	/* AlderLake */
 	{ "INTC1079", 0x160, },
+
+	/* Meteor Lake */
+	{ "INTC107A", 0x160, },
 	{}
 };
 
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 5fce795b69c7..33aadc0a29ea 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6213,6 +6213,13 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
 	struct tcpm_port *port = power_supply_get_drvdata(psy);
 	int ret;
 
+	/*
+	 * All the properties below are related to USB PD. The check needs to be
+	 * property specific when a non-pd related property is added.
+	 */
+	if (!port->pd_supported)
+		return -EOPNOTSUPP;
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		ret = tcpm_psy_set_online(port, val);
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 5c83d41766c8..0a2d24d6ac6f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -981,6 +981,9 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
 	size_t size;
 	int i, ret;
 
+	if (args->nr_pages < 0 || args->nr_pages > (INT_MAX >> PAGE_SHIFT))
+		return -ENOMEM;
+
 	size = args->nr_pages << PAGE_SHIFT;
 	if (args->coherent)
 		args->vaddr = dma_alloc_coherent(args->dev, size,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 49ba3617db59..a423d1403539 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -933,16 +933,17 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	} else if (rc != 0)
 		goto neg_exit;
 
+	rc = -EIO;
 	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb311_operations;
@@ -953,7 +954,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb21_operations;
@@ -967,7 +968,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
 				le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
@@ -985,9 +986,10 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	else {
 		cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
 				le16_to_cpu(rsp->DialectRevision));
-		rc = -EIO;
 		goto neg_exit;
 	}
+
+	rc = 0;
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	/*
diff --git a/include/linux/platform_data/x86/pmc_atom.h b/include/linux/platform_data/x86/pmc_atom.h
index 022bcea9edec..99a9b09dc839 100644
--- a/include/linux/platform_data/x86/pmc_atom.h
+++ b/include/linux/platform_data/x86/pmc_atom.h
@@ -7,6 +7,8 @@
 #ifndef PMC_ATOM_H
 #define PMC_ATOM_H
 
+#include <linux/bits.h>
+
 /* ValleyView Power Control Unit PCI Device ID */
 #define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
 /* CherryTrail Power Control Unit PCI Device ID */
@@ -139,9 +141,9 @@
 #define	ACPI_MMIO_REG_LEN	0x100
 
 #define	PM1_CNT			0x4
-#define	SLEEP_TYPE_MASK		0xFFFFECFF
+#define	SLEEP_TYPE_MASK		GENMASK(12, 10)
 #define	SLEEP_TYPE_S5		0x1C00
-#define	SLEEP_ENABLE		0x2000
+#define	SLEEP_ENABLE		BIT(13)
 
 extern int pmc_atom_read(int offset, u32 *value);
 extern int pmc_atom_write(int offset, u32 value);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 7ccaa76a9a96..da1329b85329 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -575,6 +575,7 @@ struct usb3_lpm_parameters {
  * @devaddr: device address, XHCI: assigned by HW, others: same as devnum
  * @can_submit: URBs may be submitted
  * @persist_enabled:  USB_PERSIST enabled for this device
+ * @reset_in_progress: the device is being reset
  * @have_langid: whether string_langid is valid
  * @authorized: policy has said we can use it;
  *	(user space) policy determines if we authorize this device to be
@@ -661,6 +662,7 @@ struct usb_device {
 
 	unsigned can_submit:1;
 	unsigned persist_enabled:1;
+	unsigned reset_in_progress:1;
 	unsigned have_langid:1;
 	unsigned authorized:1;
 	unsigned authenticated:1;
diff --git a/include/linux/usb/typec_dp.h b/include/linux/usb/typec_dp.h
index cfb916cccd31..8d09c2f0a9b8 100644
--- a/include/linux/usb/typec_dp.h
+++ b/include/linux/usb/typec_dp.h
@@ -73,6 +73,11 @@ enum {
 #define DP_CAP_USB			BIT(7)
 #define DP_CAP_DFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(15, 8)) >> 8)
 #define DP_CAP_UFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(23, 16)) >> 16)
+/* Get pin assignment taking plug & receptacle into consideration */
+#define DP_CAP_PIN_ASSIGN_UFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_UFP_D_PIN_ASSIGN(_cap_) : DP_CAP_DFP_D_PIN_ASSIGN(_cap_))
+#define DP_CAP_PIN_ASSIGN_DFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
+			DP_CAP_DFP_D_PIN_ASSIGN(_cap_) : DP_CAP_UFP_D_PIN_ASSIGN(_cap_))
 
 /* DisplayPort Status Update VDO bits */
 #define DP_STATUS_CONNECTION(_status_)	((_status_) & 3)
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 565e4c59db66..eb3e787a3a97 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -709,8 +709,10 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
 				pos++;
 			}
 		}
+
+		/* no link or prog match, skip the cgroup of this layer */
+		continue;
 found:
-		BUG_ON(!cg);
 		progs = rcu_dereference_protected(
 				desc->bpf.effective[atype],
 				lockdep_is_held(&cgroup_mutex));
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 48e02a725563..99ce46f51889 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4785,7 +4785,7 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 	case BPF_FUNC_sys_bpf:
-		return &bpf_sys_bpf_proto;
+		return !perfmon_capable() ? NULL : &bpf_sys_bpf_proto;
 	case BPF_FUNC_btf_find_by_name_kind:
 		return &bpf_btf_find_by_name_kind_proto;
 	case BPF_FUNC_sys_close:
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9b3db11a4d1d..fa7a3d21a751 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -110,7 +110,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) || (!walk->vma && !walk->no_vma)) {
+		if (pmd_none(*pmd)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, depth, walk);
 			if (err)
@@ -171,7 +171,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 	do {
  again:
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) || (!walk->vma && !walk->no_vma)) {
+		if (pud_none(*pud)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, depth, walk);
 			if (err)
@@ -366,19 +366,19 @@ static int __walk_page_range(unsigned long start, unsigned long end,
 	struct vm_area_struct *vma = walk->vma;
 	const struct mm_walk_ops *ops = walk->ops;
 
-	if (vma && ops->pre_vma) {
+	if (ops->pre_vma) {
 		err = ops->pre_vma(start, end, walk);
 		if (err)
 			return err;
 	}
 
-	if (vma && is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma)) {
 		if (ops->hugetlb_entry)
 			err = walk_hugetlb_range(start, end, walk);
 	} else
 		err = walk_pgd_range(start, end, walk);
 
-	if (vma && ops->post_vma)
+	if (ops->post_vma)
 		ops->post_vma(walk);
 
 	return err;
@@ -450,9 +450,13 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 		if (!vma) { /* after the last vma */
 			walk.vma = NULL;
 			next = end;
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, -1, &walk);
 		} else if (start < vma->vm_start) { /* outside vma */
 			walk.vma = NULL;
 			next = min(end, vma->vm_start);
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, -1, &walk);
 		} else { /* inside vma */
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
@@ -470,9 +474,8 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 			}
 			if (err < 0)
 				break;
-		}
-		if (walk.vma || walk.ops->pte_hole)
 			err = __walk_page_range(start, next, &walk);
+		}
 		if (err)
 			break;
 	} while (start = next, start < end);
@@ -501,9 +504,9 @@ int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 
-	mmap_assert_locked(walk.mm);
+	mmap_assert_write_locked(walk.mm);
 
-	return __walk_page_range(start, end, &walk);
+	return walk_pgd_range(start, end, &walk);
 }
 
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
diff --git a/mm/ptdump.c b/mm/ptdump.c
index da751448d0e4..f84ea700662f 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -144,13 +144,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 {
 	const struct ptdump_range *range = st->range;
 
-	mmap_read_lock(mm);
+	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
-	mmap_read_unlock(mm);
+	mmap_write_unlock(mm);
 
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4ddcfac34498..054073c7cbb9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 
 			if (copied == len)
 				break;
-		} while (!sg_is_last(sge));
+		} while ((i != msg_rx->sg.end) && !sg_is_last(sge));
 
 		if (unlikely(peek)) {
 			msg_rx = sk_psock_next_msg(psock, msg_rx);
@@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		}
 
 		msg_rx->sg.start = i;
-		if (!sge->length && sg_is_last(sge)) {
+		if (!sge->length && (i == msg_rx->sg.end || sg_is_last(sge))) {
 			msg_rx = sk_psock_dequeue_msg(psock);
 			kfree_sk_msg(msg_rx);
 		}
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 1eb7795edb9d..1452bb72b7d9 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	dev_match = dev_match || (res.type == RTN_LOCAL &&
 				  dev == net->loopback_dev);
 	if (dev_match) {
-		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 		return ret;
 	}
 	if (no_addr)
@@ -401,7 +401,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	ret = 0;
 	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
 		if (res.type == RTN_UNICAST)
-			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 	}
 	return ret;
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a33e6aa42a4c..7fd7e7cba0c9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3623,11 +3623,11 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
-	if (now != challenge_timestamp) {
+	if (now != READ_ONCE(challenge_timestamp)) {
 		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
-		challenge_timestamp = now;
+		WRITE_ONCE(challenge_timestamp, now);
 		WRITE_ONCE(challenge_count, half + prandom_u32_max(ack_limit));
 	}
 	count = READ_ONCE(challenge_count);
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 11a715d76a4f..f780fbe82e7d 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1411,12 +1411,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->sk = csk;
 	psock->bpf_prog = prog;
 
-	err = strp_init(&psock->strp, csk, &cb);
-	if (err) {
-		kmem_cache_free(kcm_psockp, psock);
-		goto out;
-	}
-
 	write_lock_bh(&csk->sk_callback_lock);
 
 	/* Check if sk_user_data is already by KCM or someone else.
@@ -1424,13 +1418,18 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	 */
 	if (csk->sk_user_data) {
 		write_unlock_bh(&csk->sk_callback_lock);
-		strp_stop(&psock->strp);
-		strp_done(&psock->strp);
 		kmem_cache_free(kcm_psockp, psock);
 		err = -EALREADY;
 		goto out;
 	}
 
+	err = strp_init(&psock->strp, csk, &cb);
+	if (err) {
+		write_unlock_bh(&csk->sk_callback_lock);
+		kmem_cache_free(kcm_psockp, psock);
+		goto out;
+	}
+
 	psock->save_data_ready = csk->sk_data_ready;
 	psock->save_write_space = csk->sk_write_space;
 	psock->save_state_change = csk->sk_state_change;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5d6ca4c3e698..1e133ca58e78 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -534,6 +534,10 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 
+	/* When not connected/joined, sending CSA doesn't make sense. */
+	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED)
+		return -ENOLINK;
+
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
 		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 887f945bb12d..d6afaacaf7ef 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -461,16 +461,19 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	scan_req = rcu_dereference_protected(local->scan_req,
 					     lockdep_is_held(&local->mtx));
 
-	if (scan_req != local->int_scan_req) {
-		local->scan_info.aborted = aborted;
-		cfg80211_scan_done(scan_req, &local->scan_info);
-	}
 	RCU_INIT_POINTER(local->scan_req, NULL);
 	RCU_INIT_POINTER(local->scan_sdata, NULL);
 
 	local->scanning = 0;
 	local->scan_chandef.chan = NULL;
 
+	synchronize_rcu();
+
+	if (scan_req != local->int_scan_req) {
+		local->scan_info.aborted = aborted;
+		cfg80211_scan_done(scan_req, &local->scan_info);
+	}
+
 	/* Set power back to normal operating levels. */
 	ieee80211_hw_config(local, 0);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6eeef7a61927..f1e263b2c295 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2206,9 +2206,9 @@ static inline u64 sta_get_tidstats_msdu(struct ieee80211_sta_rx_stats *rxstats,
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin(&rxstats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value = rxstats->msdu[tid];
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
 
 	return value;
 }
@@ -2272,9 +2272,9 @@ static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin(&rxstats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value = rxstats->bytes;
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
 
 	return value;
 }
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b8ce84618a55..c439125ef2b9 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
-		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
+		if (hdr->source.mode != IEEE802154_ADDR_NONE)
 			/* FIXME: check if we are PAN coordinator */
 			skb->pkt_type = PACKET_OTHERHOST;
 		else
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 6e587feb705c..58a7075084d1 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1079,9 +1079,9 @@ static void mpls_get_stats(struct mpls_dev *mdev,
 
 		p = per_cpu_ptr(mdev->stats, i);
 		do {
-			start = u64_stats_fetch_begin(&p->syncp);
+			start = u64_stats_fetch_begin_irq(&p->syncp);
 			local = p->stats;
-		} while (u64_stats_fetch_retry(&p->syncp, start));
+		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 		stats->rx_packets	+= local.rx_packets;
 		stats->rx_bytes		+= local.rx_bytes;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886..5e2c83cb7b12 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1801,7 +1801,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
-		goto err_unlock_and_destroy_meters;
+		goto err_destroy_portids;
 	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
@@ -1816,6 +1816,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
+err_destroy_portids:
+	kfree(rcu_dereference_raw(dp->upcall_portids));
 err_unlock_and_destroy_meters:
 	ovs_unlock();
 	ovs_meters_exit(dp);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 250d87d993cb..02299785209c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1083,6 +1083,21 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 }
 EXPORT_SYMBOL(dev_graft_qdisc);
 
+static void shutdown_scheduler_queue(struct net_device *dev,
+				     struct netdev_queue *dev_queue,
+				     void *_qdisc_default)
+{
+	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *qdisc_default = _qdisc_default;
+
+	if (qdisc) {
+		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
+		dev_queue->qdisc_sleeping = qdisc_default;
+
+		qdisc_put(qdisc);
+	}
+}
+
 static void attach_one_default_qdisc(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_unused)
@@ -1130,6 +1145,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (qdisc == &noop_qdisc) {
 		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
 			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
+		netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
 		qdisc = txq->qdisc_sleeping;
@@ -1384,21 +1400,6 @@ void dev_init_scheduler(struct net_device *dev)
 	timer_setup(&dev->watchdog_timer, dev_watchdog, 0);
 }
 
-static void shutdown_scheduler_queue(struct net_device *dev,
-				     struct netdev_queue *dev_queue,
-				     void *_qdisc_default)
-{
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
-	struct Qdisc *qdisc_default = _qdisc_default;
-
-	if (qdisc) {
-		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		dev_queue->qdisc_sleeping = qdisc_default;
-
-		qdisc_put(qdisc);
-	}
-}
-
 void dev_shutdown(struct net_device *dev)
 {
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc63..6eb17004a9e4 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -342,6 +342,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_TBF_MAX + 1];
 	struct tc_tbf_qopt *qopt;
 	struct Qdisc *child = NULL;
+	struct Qdisc *old = NULL;
 	struct psched_ratecfg rate;
 	struct psched_ratecfg peak;
 	u64 max_size;
@@ -433,7 +434,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
-		qdisc_put(q->qdisc);
+		old = q->qdisc;
 		q->qdisc = child;
 	}
 	q->limit = qopt->limit;
@@ -453,6 +454,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(&q->peak, &peak, sizeof(struct psched_ratecfg));
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 	err = 0;
 
 	tbf_offload_change(sch);
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 2ddd7b34b4ce..26f81e2e1dfb 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1490,7 +1490,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
-	sk_refcnt_debug_inc(newsmcsk);
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index aab43469a2f0..0878b162890a 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -65,9 +65,10 @@ static ssize_t ht40allow_map_read(struct file *file,
 {
 	struct wiphy *wiphy = file->private_data;
 	char *buf;
-	unsigned int offset = 0, buf_size = PAGE_SIZE, i, r;
+	unsigned int offset = 0, buf_size = PAGE_SIZE, i;
 	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
+	ssize_t r;
 
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index ff805777431c..ce9661d968a3 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -40,7 +40,7 @@ quiet_cmd_ld_ko_o = LD [M]  $@
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
-		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J $(PAHOLE_FLAGS) --btf_base vmlinux $@; \
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
 	fi;
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 3819a461465d..57ef6accbb40 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -211,7 +211,6 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
-	local extra_paholeopt=
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -226,16 +225,8 @@ gen_btf()
 
 	vmlinux_link ${1}
 
-	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
-		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
-		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
-	fi
-	if [ "${pahole_ver}" -ge "121" ]; then
-		extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
-	fi
-
 	info "BTF" ${2}
-	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${extra_paholeopt} ${1}
+	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${PAHOLE_FLAGS} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
new file mode 100644
index 000000000000..7acee326aa6c
--- /dev/null
+++ b/scripts/pahole-flags.sh
@@ -0,0 +1,24 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+extra_paholeopt=
+
+if ! [ -x "$(command -v ${PAHOLE})" ]; then
+	exit 0
+fi
+
+pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+
+if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+fi
+if [ "${pahole_ver}" -ge "121" ]; then
+	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
+fi
+
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
+echo ${extra_paholeopt}
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 1e3bf086f867..07efb38f58ac 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -270,7 +270,9 @@ snd_seq_oss_midi_clear_all(void)
 void
 snd_seq_oss_midi_setup(struct seq_oss_devinfo *dp)
 {
+	spin_lock_irq(&register_lock);
 	dp->max_mididev = max_midi_devs;
+	spin_unlock_irq(&register_lock);
 }
 
 /*
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 2e9d695d336c..2d707afa1ef1 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -121,13 +121,13 @@ struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_MODULES
 	if (!in_interrupt()) {
-		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
-		static char card_requested[SNDRV_CARDS];
+		static DECLARE_BITMAP(client_requested, SNDRV_SEQ_GLOBAL_CLIENTS);
+		static DECLARE_BITMAP(card_requested, SNDRV_CARDS);
+
 		if (clientid < SNDRV_SEQ_GLOBAL_CLIENTS) {
 			int idx;
 			
-			if (!client_requested[clientid]) {
-				client_requested[clientid] = 1;
+			if (!test_and_set_bit(clientid, client_requested)) {
 				for (idx = 0; idx < 15; idx++) {
 					if (seq_client_load[idx] < 0)
 						break;
@@ -142,10 +142,8 @@ struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
 			int card = (clientid - SNDRV_SEQ_GLOBAL_CLIENTS) /
 				SNDRV_SEQ_CLIENTS_PER_CARD;
 			if (card < snd_ecards_limit) {
-				if (! card_requested[card]) {
-					card_requested[card] = 1;
+				if (!test_and_set_bit(card, card_requested))
 					snd_request_card(card);
-				}
 				snd_seq_device_load_drivers();
 			}
 		}
diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index e2237239d922..8714891f50b0 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -55,20 +55,26 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 
 		/* find max number of channels based on format_configuration */
 		if (fmt_configs->fmt_count) {
-			dev_dbg(dev, "%s: found %d format definitions\n",
-				__func__, fmt_configs->fmt_count);
+			struct nhlt_fmt_cfg *fmt_cfg = fmt_configs->fmt_config;
+
+			dev_dbg(dev, "found %d format definitions\n",
+				fmt_configs->fmt_count);
 
 			for (i = 0; i < fmt_configs->fmt_count; i++) {
 				struct wav_fmt_ext *fmt_ext;
 
-				fmt_ext = &fmt_configs->fmt_config[i].fmt_ext;
+				fmt_ext = &fmt_cfg->fmt_ext;
 
 				if (fmt_ext->fmt.channels > max_ch)
 					max_ch = fmt_ext->fmt.channels;
+
+				/* Move to the next nhlt_fmt_cfg */
+				fmt_cfg = (struct nhlt_fmt_cfg *)(fmt_cfg->config.caps +
+								  fmt_cfg->config.size);
 			}
-			dev_dbg(dev, "%s: max channels found %d\n", __func__, max_ch);
+			dev_dbg(dev, "max channels found %d\n", max_ch);
 		} else {
-			dev_dbg(dev, "%s: No format information found\n", __func__);
+			dev_dbg(dev, "No format information found\n");
 		}
 
 		if (cfg->device_config.config_type != NHLT_CONFIG_TYPE_MIC_ARRAY) {
@@ -95,17 +101,16 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 			}
 
 			if (dmic_geo > 0) {
-				dev_dbg(dev, "%s: Array with %d dmics\n", __func__, dmic_geo);
+				dev_dbg(dev, "Array with %d dmics\n", dmic_geo);
 			}
 			if (max_ch > dmic_geo) {
-				dev_dbg(dev, "%s: max channels %d exceed dmic number %d\n",
-					__func__, max_ch, dmic_geo);
+				dev_dbg(dev, "max channels %d exceed dmic number %d\n",
+					max_ch, dmic_geo);
 			}
 		}
 	}
 
-	dev_dbg(dev, "%s: dmic number %d max_ch %d\n",
-		__func__, dmic_geo, max_ch);
+	dev_dbg(dev, "dmic number %d max_ch %d\n", dmic_geo, max_ch);
 
 	return dmic_geo;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 600ba91f7703..45b8ebda284d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4684,6 +4684,48 @@ static void alc236_fixup_hp_mute_led_micmute_vref(struct hda_codec *codec,
 	alc236_fixup_hp_micmute_led_vref(codec, fix, action);
 }
 
+static inline void alc298_samsung_write_coef_pack(struct hda_codec *codec,
+						  const unsigned short coefs[2])
+{
+	alc_write_coef_idx(codec, 0x23, coefs[0]);
+	alc_write_coef_idx(codec, 0x25, coefs[1]);
+	alc_write_coef_idx(codec, 0x26, 0xb011);
+}
+
+struct alc298_samsung_amp_desc {
+	unsigned char nid;
+	unsigned short init_seq[2][2];
+};
+
+static void alc298_fixup_samsung_amp(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	int i, j;
+	static const unsigned short init_seq[][2] = {
+		{ 0x19, 0x00 }, { 0x20, 0xc0 }, { 0x22, 0x44 }, { 0x23, 0x08 },
+		{ 0x24, 0x85 }, { 0x25, 0x41 }, { 0x35, 0x40 }, { 0x36, 0x01 },
+		{ 0x38, 0x81 }, { 0x3a, 0x03 }, { 0x3b, 0x81 }, { 0x40, 0x3e },
+		{ 0x41, 0x07 }, { 0x400, 0x1 }
+	};
+	static const struct alc298_samsung_amp_desc amps[] = {
+		{ 0x3a, { { 0x18, 0x1 }, { 0x26, 0x0 } } },
+		{ 0x39, { { 0x18, 0x2 }, { 0x26, 0x1 } } }
+	};
+
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(amps); i++) {
+		alc_write_coef_idx(codec, 0x22, amps[i].nid);
+
+		for (j = 0; j < ARRAY_SIZE(amps[i].init_seq); j++)
+			alc298_samsung_write_coef_pack(codec, amps[i].init_seq[j]);
+
+		for (j = 0; j < ARRAY_SIZE(init_seq); j++)
+			alc298_samsung_write_coef_pack(codec, init_seq[j]);
+	}
+}
+
 #if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
@@ -6842,6 +6884,7 @@ enum {
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
+	ALC298_FIXUP_SAMSUNG_AMP,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
@@ -8196,6 +8239,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_mute_led_micmute_vref,
 	},
+	[ALC298_FIXUP_SAMSUNG_AMP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_samsung_amp,
+		.chained = true,
+		.chain_id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET
+	},
 	[ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8985,13 +9034,13 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
-	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
-	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
@@ -9351,7 +9400,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
 	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
-	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
+	{.id = ALC298_FIXUP_SAMSUNG_AMP, .name = "alc298-samsung-amp"},
 	{.id = ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc256-samsung-headphone"},
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
