Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F204788A8
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhLQKVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 05:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbhLQKVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 05:21:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902A4C06173E;
        Fri, 17 Dec 2021 02:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28FD8B82786;
        Fri, 17 Dec 2021 10:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7C7C36AE5;
        Fri, 17 Dec 2021 10:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639736471;
        bh=3sDJoylVYpviodi90DXk2YF+a4m58VePEpSduRXf/6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/n5jFm/cYZ1vxq7lrVU/Zotawb/pM2+RQbm5H2S9vDxmNrDsaAx09LhiMZ7t6W8r
         1CfLUdk8e7sYMT9Tl0oe7Qc5JXBWZo389M/M7Q+aLW0baTSXOR1YdAtGmfzOC+Thqg
         8YoNQuPhX9Ez7HWFse5sWwwI4YKoYVeS2LWL/nH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.87
Date:   Fri, 17 Dec 2021 11:21:02 +0100
Message-Id: <1639736462866@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <163973646218123@kroah.com>
References: <163973646218123@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5c1a33f1ecad..d627f4ae5af5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 86
+SUBLEVEL = 87
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 75f3ab531bdf..15af4dd52426 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -125,11 +125,22 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 int pfn_valid(unsigned long pfn)
 {
 	phys_addr_t addr = __pfn_to_phys(pfn);
+	unsigned long pageblock_size = PAGE_SIZE * pageblock_nr_pages;
 
 	if (__phys_to_pfn(addr) != pfn)
 		return 0;
 
-	return memblock_is_map_memory(addr);
+	/*
+	 * If address less than pageblock_size bytes away from a present
+	 * memory chunk there still will be a memory map entry for it
+	 * because we round freed memory map to the pageblock boundaries.
+	 */
+	if (memblock_overlaps_region(&memblock.memory,
+				     ALIGN_DOWN(addr, pageblock_size),
+				     pageblock_size))
+		return 1;
+
+	return 0;
 }
 EXPORT_SYMBOL(pfn_valid);
 #endif
@@ -313,14 +324,14 @@ static void __init free_unused_memmap(void)
 		 */
 		start = min(start,
 				 ALIGN(prev_end, PAGES_PER_SECTION));
-#else
+#endif
 		/*
-		 * Align down here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank start aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align down here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
-		start = round_down(start, MAX_ORDER_NR_PAGES);
-#endif
+		start = round_down(start, pageblock_nr_pages);
+
 		/*
 		 * If we had a previous bank, and there is a space
 		 * between the current bank and the previous, free it.
@@ -329,17 +340,19 @@ static void __init free_unused_memmap(void)
 			free_memmap(prev_end, start);
 
 		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align up here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
-		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
+		prev_end = ALIGN(end, pageblock_nr_pages);
 	}
 
 #ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
+		prev_end = ALIGN(end, pageblock_nr_pages);
 		free_memmap(prev_end,
 			    ALIGN(prev_end, PAGES_PER_SECTION));
+	}
 #endif
 }
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 000e8210000b..80fb5a4a5c05 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 #include <linux/sizes.h>
+#include <linux/memblock.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
@@ -284,7 +285,8 @@ static void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	 * Don't allow RAM to be mapped with mismatched attributes - this
 	 * causes problems with ARMv6+
 	 */
-	if (WARN_ON(pfn_valid(pfn) && mtype != MT_MEMORY_RW))
+	if (WARN_ON(memblock_is_map_memory(PFN_PHYS(pfn)) &&
+		    mtype != MT_MEMORY_RW))
 		return NULL;
 
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1f875a8f20c4..8116ae1e636a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -406,6 +406,12 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	/*
+	 * Save PSTATE early so that we can evaluate the vcpu mode
+	 * early on.
+	 */
+	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index cce43bfe158f..0eacfb9d17b0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -54,7 +54,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
-	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
+	/*
+	 * Guest PSTATE gets saved at guest fixup time in all
+	 * cases. We still need to handle the nVHE host side here.
+	 */
+	if (!has_vhe() && ctxt->__hyp_running_vcpu)
+		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
index 6bad84c372dc..b0b67e6d1f6e 100644
--- a/arch/s390/lib/test_unwind.c
+++ b/arch/s390/lib/test_unwind.c
@@ -171,10 +171,11 @@ static noinline int unwindme_func4(struct unwindme *u)
 		}
 
 		/*
-		 * trigger specification exception
+		 * Trigger operation exception; use insn notation to bypass
+		 * llvm's integrated assembler sanity checks.
 		 */
 		asm volatile(
-			"	mvcl	%%r1,%%r1\n"
+			"	.insn	e,0x0000\n"	/* illegal opcode */
 			"0:	nopr	%%r7\n"
 			EX_TABLE(0b, 0b)
 			:);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bb39f493447c..328f37e4fd3a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1641,11 +1641,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
+		if (all_cpus)
+			goto check_and_send_ipi;
+
 		if (!sparse_banks_len)
 			goto ret_success;
 
-		if (!all_cpus &&
-		    kvm_read_guest(kvm,
+		if (kvm_read_guest(kvm,
 				   ingpa + offsetof(struct hv_send_ipi_ex,
 						    vp_set.bank_contents),
 				   sparse_banks,
@@ -1653,6 +1655,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
+check_and_send_ipi:
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index ed3c4c42fc23..d68d05d5d383 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -281,7 +281,7 @@ agp_ioc_init(void __iomem *ioc_regs)
         return 0;
 }
 
-static int
+static int __init
 lba_find_capability(int cap)
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
@@ -366,7 +366,7 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	return error;
 }
 
-static int
+static int __init
 find_quicksilver(struct device *dev, void *data)
 {
 	struct parisc_device **lba = data;
@@ -378,7 +378,7 @@ find_quicksilver(struct device *dev, void *data)
 	return 0;
 }
 
-static int
+static int __init
 parisc_agp_init(void)
 {
 	extern struct sba_device *sba_list;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index e00a30e7d252..04c20ce6e94d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -226,6 +226,14 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
 			ret = -EINVAL;
 			goto cleanup;
 		}
+
+		if ((aconn->base.connector_type != DRM_MODE_CONNECTOR_DisplayPort) &&
+				(aconn->base.connector_type != DRM_MODE_CONNECTOR_eDP)) {
+			DRM_DEBUG_DRIVER("No DP connector available for CRC source\n");
+			ret = -EINVAL;
+			goto cleanup;
+		}
+
 	}
 
 	if (amdgpu_dm_crtc_configure_crc_source(crtc, crtc_state, source)) {
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 59d48cf819ea..5f4cdb05c4db 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1698,6 +1698,10 @@ bool dc_is_stream_unchanged(
 	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
 		return false;
 
+	// Only Have Audio left to check whether it is same or not. This is a corner case for Tiled sinks
+	if (old_stream->audio_info.mode_count != stream->audio_info.mode_count)
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 96b5dcf8e454..64454a63bbac 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1692,6 +1692,8 @@ static int dsi_host_parse_lane_data(struct msm_dsi_host *msm_host,
 	if (!prop) {
 		DRM_DEV_DEBUG(dev,
 			"failed to find data lane mapping, using default\n");
+		/* Set the number of date lanes to 4 by default. */
+		msm_host->num_data_lanes = 4;
 		return 0;
 	}
 
diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 63b74e781c5d..87f401100466 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -603,15 +603,18 @@ static const struct proc_ops i8k_proc_ops = {
 	.proc_ioctl	= i8k_ioctl,
 };
 
+static struct proc_dir_entry *entry;
+
 static void __init i8k_init_procfs(void)
 {
 	/* Register the proc entry */
-	proc_create("i8k", 0, NULL, &i8k_proc_ops);
+	entry = proc_create("i8k", 0, NULL, &i8k_proc_ops);
 }
 
 static void __exit i8k_exit_procfs(void)
 {
-	remove_proc_entry("i8k", NULL);
+	if (entry)
+		remove_proc_entry("i8k", NULL);
 }
 
 #else
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 819ab4ee517e..02ddb237f69a 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -423,8 +423,8 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
 	if (!(ipd & REG_INT_MBRF))
 		return;
 
-	/* ack interrupt */
-	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
+	/* ack interrupt (read also produces a spurious START flag, clear it too) */
+	i2c_writel(i2c, REG_INT_MBRF | REG_INT_START, REG_IPD);
 
 	/* Can only handle a maximum of 32 bytes at a time */
 	if (len > 32)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 3616b77caa0a..01275c376721 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -663,7 +663,7 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_T, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_CX_SGMII, SPEED_1000,
-				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
+				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_KX, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_T, SPEED_10000,
@@ -675,9 +675,9 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_KR, SPEED_10000,
 				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_CR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseCR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_SR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseSR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_20GBASE_KR2, SPEED_20000,
 				       ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT,
 				       ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT);
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 8c2f384233aa..2fd6886f7728 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -723,6 +723,23 @@ static int get_dim2_clk_speed(const char *clock_speed, u8 *val)
 	return -EINVAL;
 }
 
+static void dim2_release(struct device *d)
+{
+	struct dim2_hdm *dev = container_of(d, struct dim2_hdm, dev);
+	unsigned long flags;
+
+	kthread_stop(dev->netinfo_task);
+
+	spin_lock_irqsave(&dim_lock, flags);
+	dim_shutdown();
+	spin_unlock_irqrestore(&dim_lock, flags);
+
+	if (dev->disable_platform)
+		dev->disable_platform(to_platform_device(d->parent));
+
+	kfree(dev);
+}
+
 /*
  * dim2_probe - dim2 probe handler
  * @pdev: platform device structure
@@ -743,7 +760,7 @@ static int dim2_probe(struct platform_device *pdev)
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -755,25 +772,27 @@ static int dim2_probe(struct platform_device *pdev)
 				      "microchip,clock-speed", &clock_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "missing dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	ret = get_dim2_clk_speed(clock_speed, &dev->clk_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "bad dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->io_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dev->io_base))
-		return PTR_ERR(dev->io_base);
+	if (IS_ERR(dev->io_base)) {
+		ret = PTR_ERR(dev->io_base);
+		goto err_free_dev;
+	}
 
 	of_id = of_match_node(dim2_of_match, pdev->dev.of_node);
 	pdata = of_id->data;
 	ret = pdata && pdata->enable ? pdata->enable(pdev) : 0;
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	dev->disable_platform = pdata ? pdata->disable : NULL;
 
@@ -864,24 +883,19 @@ static int dim2_probe(struct platform_device *pdev)
 	dev->most_iface.request_netinfo = request_netinfo;
 	dev->most_iface.driver_dev = &pdev->dev;
 	dev->most_iface.dev = &dev->dev;
-	dev->dev.init_name = "dim2_state";
+	dev->dev.init_name = dev->name;
 	dev->dev.parent = &pdev->dev;
+	dev->dev.release = dim2_release;
 
-	ret = most_register_interface(&dev->most_iface);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register MOST interface\n");
-		goto err_stop_thread;
-	}
-
-	return 0;
+	return most_register_interface(&dev->most_iface);
 
-err_stop_thread:
-	kthread_stop(dev->netinfo_task);
 err_shutdown_dim:
 	dim_shutdown();
 err_disable_platform:
 	if (dev->disable_platform)
 		dev->disable_platform(pdev);
+err_free_dev:
+	kfree(dev);
 
 	return ret;
 }
@@ -895,17 +909,8 @@ static int dim2_probe(struct platform_device *pdev)
 static int dim2_remove(struct platform_device *pdev)
 {
 	struct dim2_hdm *dev = platform_get_drvdata(pdev);
-	unsigned long flags;
 
 	most_deregister_interface(&dev->most_iface);
-	kthread_stop(dev->netinfo_task);
-
-	spin_lock_irqsave(&dim_lock, flags);
-	dim_shutdown();
-	spin_unlock_irqrestore(&dim_lock, flags);
-
-	if (dev->disable_platform)
-		dev->disable_platform(pdev);
 
 	return 0;
 }
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index a70911a227a8..b9f8add284e3 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2559,6 +2559,7 @@ OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-lpuart", lpuart_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1028a-lpuart", ls1028a_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2e300176cb88..e7667497b6b7 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -791,11 +791,19 @@ static int fuse_symlink(struct inode *dir, struct dentry *entry,
 	return create_new_entry(fm, &args, dir, entry, S_IFLNK);
 }
 
+void fuse_flush_time_update(struct inode *inode)
+{
+	int err = sync_inode_metadata(inode, 1);
+
+	mapping_set_error(inode->i_mapping, err);
+}
+
 void fuse_update_ctime(struct inode *inode)
 {
 	if (!IS_NOCMTIME(inode)) {
 		inode->i_ctime = current_time(inode);
 		mark_inode_dirty_sync(inode);
+		fuse_flush_time_update(inode);
 	}
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c9606f2d2864..4dd70b53df81 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1849,6 +1849,17 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct fuse_file *ff;
 	int err;
 
+	/*
+	 * Inode is always written before the last reference is dropped and
+	 * hence this should not be reached from reclaim.
+	 *
+	 * Writing back the inode from reclaim can deadlock if the request
+	 * processing itself needs an allocation.  Allocations triggering
+	 * reclaim while serving a request can't be prevented, because it can
+	 * involve any number of unrelated userspace processes.
+	 */
+	WARN_ON(wbc->for_reclaim);
+
 	ff = __fuse_write_file_get(fc, fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
@@ -3338,6 +3349,8 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (lock_inode)
 		inode_unlock(inode);
 
+	fuse_flush_time_update(inode);
+
 	return err;
 }
 
@@ -3447,6 +3460,8 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	inode_unlock(inode_out);
 	file_accessed(file_in);
 
+	fuse_flush_time_update(inode_out);
+
 	return err;
 }
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ff94da684017..b159d8b5e893 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1113,6 +1113,7 @@ int fuse_allow_current_process(struct fuse_conn *fc);
 
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
 
+void fuse_flush_time_update(struct inode *inode);
 void fuse_update_ctime(struct inode *inode);
 
 int fuse_update_attributes(struct inode *inode, struct file *file);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 053c56af3b6f..5e484676343e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -119,6 +119,9 @@ static void fuse_evict_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
+	/* Will write inode on close/munmap and in all other dirtiers */
+	WARN_ON(inode->i_state & I_DIRTY_INODE);
+
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (inode->i_sb->s_flags & SB_ACTIVE) {
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index b5be9659ab59..01149821ded9 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -92,7 +92,7 @@ static struct hlist_head *dev_map_create_hash(unsigned int entries,
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -153,7 +153,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index d63e51dde0d2..51a9d1185033 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -15,6 +15,7 @@
 #include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
+#include <linux/kmemleak.h>
 
 #include "tracing_map.h"
 #include "trace.h"
@@ -307,6 +308,7 @@ static void tracing_map_array_free(struct tracing_map_array *a)
 	for (i = 0; i < a->n_pages; i++) {
 		if (!a->pages[i])
 			break;
+		kmemleak_free(a->pages[i]);
 		free_page((unsigned long)a->pages[i]);
 	}
 
@@ -342,6 +344,7 @@ static struct tracing_map_array *tracing_map_array_alloc(unsigned int n_elts,
 		a->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!a->pages[i])
 			goto free;
+		kmemleak_alloc(a->pages[i], PAGE_SIZE, 1, GFP_KERNEL);
 	}
  out:
 	return a;
diff --git a/mm/memblock.c b/mm/memblock.c
index c337df03b6a1..faa4de579b3d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -182,6 +182,8 @@ bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
 {
 	unsigned long i;
 
+	memblock_cap_size(base, &size);
+
 	for (i = 0; i < type->cnt; i++)
 		if (memblock_addrs_overlap(base, size, type->regions[i].base,
 					   type->regions[i].size))
@@ -1792,7 +1794,6 @@ bool __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t siz
  */
 bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
-	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ddc899e83313..4ea5bc65848f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -52,7 +52,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	if (err)
 		goto free_stab;
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (stab->sks)
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..979dee6bb88c 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -249,6 +249,9 @@ struct ethnl_reply_data {
 
 static inline int ethnl_ops_begin(struct net_device *dev)
 {
+	if (dev && dev->reg_state == NETREG_UNREGISTERING)
+		return -ENODEV;
+
 	if (dev && dev->ethtool_ops->begin)
 		return dev->ethtool_ops->begin(dev);
 	else
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0886267ea81e..e55af5c078ac 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1863,6 +1863,11 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	if (len == 0) {
+		pr_warn_once("Zero length message leads to an empty skb\n");
+		return -ENODATA;
+	}
+
 	err = scm_send(sock, msg, &scm, true);
 	if (err < 0)
 		return err;
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 0767404636c1..78acc4e9ac93 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -636,8 +636,10 @@ static int nfc_genl_dump_devices_done(struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 64115a796af0..3cc936f2cbf8 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -369,7 +369,10 @@ enum {
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
-					((pci)->device == 0x490d))
+					((pci)->device == 0x490d) || \
+					((pci)->device == 0x4f90) || \
+					((pci)->device == 0x4f91) || \
+					((pci)->device == 0x4f92))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
@@ -2540,6 +2543,13 @@ static const struct pci_device_id azx_ids[] = {
 	/* DG1 */
 	{ PCI_DEVICE(0x8086, 0x490d),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* DG2 */
+	{ PCI_DEVICE(0x8086, 0x4f90),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f91),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f92),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Alderlake-S */
 	{ PCI_DEVICE(0x8086, 0x7ad0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c65144715af7..fe725f0f0931 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4362,10 +4362,11 @@ HDA_CODEC_ENTRY(0x8086280f, "Icelake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862812, "Tigerlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
-HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
+HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
 HDA_CODEC_ENTRY(0x80862882, "Valleyview2 HDMI",	patch_i915_byt_hdmi),
 HDA_CODEC_ENTRY(0x80862883, "Braswell HDMI",	patch_i915_byt_hdmi),
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 5378a14e3836..8f1a99e2fcd7 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -752,7 +752,7 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.ordered_events = true;
 		inject->tool.ordering_requires_timestamps = true;
 		/* Allow space in the header for new attributes */
-		output_data_offset = 4096;
+		output_data_offset = roundup(8192 + session->header.data_offset, 4096);
 		if (inject->strip)
 			strip_init(inject);
 	}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index e6029d4c096f..e4c485f92c02 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1114,61 +1114,69 @@ static int intel_pt_walk_insn(struct intel_pt_decoder *decoder,
 
 static bool intel_pt_fup_event(struct intel_pt_decoder *decoder)
 {
+	enum intel_pt_sample_type type = decoder->state.type;
 	bool ret = false;
 
+	decoder->state.type &= ~INTEL_PT_BRANCH;
+
 	if (decoder->set_fup_tx_flags) {
 		decoder->set_fup_tx_flags = false;
 		decoder->tx_flags = decoder->fup_tx_flags;
-		decoder->state.type = INTEL_PT_TRANSACTION;
+		decoder->state.type |= INTEL_PT_TRANSACTION;
 		if (decoder->fup_tx_flags & INTEL_PT_ABORT_TX)
 			decoder->state.type |= INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.flags = decoder->fup_tx_flags;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_ptw) {
 		decoder->set_fup_ptw = false;
-		decoder->state.type = INTEL_PT_PTW;
+		decoder->state.type |= INTEL_PT_PTW;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.ptw_payload = decoder->fup_ptw_payload;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_mwait) {
 		decoder->set_fup_mwait = false;
-		decoder->state.type = INTEL_PT_MWAIT_OP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
+		decoder->state.type |= INTEL_PT_MWAIT_OP;
 		decoder->state.mwait_payload = decoder->fup_mwait_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_pwre) {
 		decoder->set_fup_pwre = false;
 		decoder->state.type |= INTEL_PT_PWR_ENTRY;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.pwre_payload = decoder->fup_pwre_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_exstop) {
 		decoder->set_fup_exstop = false;
 		decoder->state.type |= INTEL_PT_EX_STOP;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		ret = true;
 	}
 	if (decoder->set_fup_bep) {
 		decoder->set_fup_bep = false;
 		decoder->state.type |= INTEL_PT_BLK_ITEMS;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
+		ret = true;
+	}
+	if (decoder->overflow) {
+		decoder->overflow = false;
+		if (!ret && !decoder->pge) {
+			if (decoder->hop) {
+				decoder->state.type = 0;
+				decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
+			}
+			decoder->pge = true;
+			decoder->state.type |= INTEL_PT_BRANCH | INTEL_PT_TRACE_BEGIN;
+			decoder->state.from_ip = 0;
+			decoder->state.to_ip = decoder->ip;
+			return true;
+		}
+	}
+	if (ret) {
 		decoder->state.from_ip = decoder->ip;
 		decoder->state.to_ip = 0;
-		ret = true;
+	} else {
+		decoder->state.type = type;
 	}
 	return ret;
 }
@@ -1486,7 +1494,16 @@ static int intel_pt_overflow(struct intel_pt_decoder *decoder)
 	intel_pt_log("ERROR: Buffer overflow\n");
 	intel_pt_clear_tx_flags(decoder);
 	decoder->timestamp_insn_cnt = 0;
-	decoder->pkt_state = INTEL_PT_STATE_ERR_RESYNC;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
+	decoder->state.from_ip = decoder->ip;
+	decoder->ip = 0;
+	decoder->pge = false;
+	decoder->set_fup_tx_flags = false;
+	decoder->set_fup_ptw = false;
+	decoder->set_fup_mwait = false;
+	decoder->set_fup_pwre = false;
+	decoder->set_fup_exstop = false;
+	decoder->set_fup_bep = false;
 	decoder->overflow = true;
 	return -EOVERFLOW;
 }
@@ -1937,6 +1954,8 @@ static int intel_pt_scan_for_psb(struct intel_pt_decoder *decoder);
 /* Hop mode: Ignore TNT, do not walk code, but get ip from FUPs and TIPs */
 static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, int *err)
 {
+	*err = 0;
+
 	/* Leap from PSB to PSB, getting ip from FUP within PSB+ */
 	if (decoder->leap && !decoder->in_psb && decoder->packet.type != INTEL_PT_PSB) {
 		*err = intel_pt_scan_for_psb(decoder);
@@ -1949,6 +1968,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		return HOP_IGNORE;
 
 	case INTEL_PT_TIP_PGD:
+		decoder->pge = false;
 		if (!decoder->packet.count)
 			return HOP_IGNORE;
 		intel_pt_set_ip(decoder);
@@ -1970,18 +1990,21 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		if (!decoder->packet.count)
 			return HOP_IGNORE;
 		intel_pt_set_ip(decoder);
-		if (intel_pt_fup_event(decoder))
-			return HOP_RETURN;
-		if (!decoder->branch_enable)
+		if (decoder->set_fup_mwait || decoder->set_fup_pwre)
+			*no_tip = true;
+		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
 			decoder->state.from_ip = decoder->ip;
 			decoder->state.to_ip = 0;
+			intel_pt_fup_event(decoder);
 			return HOP_RETURN;
 		}
+		intel_pt_fup_event(decoder);
+		decoder->state.type |= INTEL_PT_INSTRUCTION | INTEL_PT_BRANCH;
 		*err = intel_pt_walk_fup_tip(decoder);
-		if (!*err)
+		if (!*err && decoder->state.to_ip)
 			decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 		return HOP_RETURN;
 
@@ -2050,6 +2073,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 		if (err)
 			return err;
 next:
+		err = 0;
 		if (decoder->cyc_threshold) {
 			if (decoder->sample_cyc && last_packet_type != INTEL_PT_CYC)
 				decoder->sample_cyc = false;
@@ -2088,6 +2112,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 
 		case INTEL_PT_TIP_PGE: {
 			decoder->pge = true;
+			decoder->overflow = false;
 			intel_pt_mtc_cyc_cnt_pge(decoder);
 			if (decoder->packet.count == 0) {
 				intel_pt_log_at("Skipping zero TIP.PGE",
@@ -2124,7 +2149,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 				break;
 			}
 			intel_pt_set_last_ip(decoder);
-			if (!decoder->branch_enable) {
+			if (!decoder->branch_enable || !decoder->pge) {
 				decoder->ip = decoder->last_ip;
 				if (intel_pt_fup_event(decoder))
 					return 0;
@@ -2601,10 +2626,10 @@ static int intel_pt_sync_ip(struct intel_pt_decoder *decoder)
 	decoder->set_fup_pwre = false;
 	decoder->set_fup_exstop = false;
 	decoder->set_fup_bep = false;
+	decoder->overflow = false;
 
 	if (!decoder->branch_enable) {
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-		decoder->overflow = false;
 		decoder->state.type = 0; /* Do not have a sample */
 		return 0;
 	}
@@ -2619,7 +2644,6 @@ static int intel_pt_sync_ip(struct intel_pt_decoder *decoder)
 		decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 	else
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-	decoder->overflow = false;
 
 	decoder->state.from_ip = 0;
 	decoder->state.to_ip = decoder->ip;
@@ -2732,7 +2756,7 @@ static int intel_pt_sync(struct intel_pt_decoder *decoder)
 		return err;
 
 	decoder->have_last_ip = true;
-	decoder->pkt_state = INTEL_PT_STATE_NO_IP;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 
 	err = intel_pt_walk_psb(decoder);
 	if (err)
@@ -2828,7 +2852,8 @@ const struct intel_pt_state *intel_pt_decode(struct intel_pt_decoder *decoder)
 
 	if (err) {
 		decoder->state.err = intel_pt_ext_err(err);
-		decoder->state.from_ip = decoder->ip;
+		if (err != -EOVERFLOW)
+			decoder->state.from_ip = decoder->ip;
 		intel_pt_update_sample_time(decoder);
 		decoder->sample_tot_cyc_cnt = decoder->tot_cyc_cnt;
 	} else {
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index e5aaf1337be9..5163d2ffea70 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2271,6 +2271,7 @@ static int intel_pt_run_decoder(struct intel_pt_queue *ptq, u64 *timestamp)
 				ptq->sync_switch = false;
 				intel_pt_next_tid(pt, ptq);
 			}
+			ptq->timestamp = state->est_timestamp;
 			if (pt->synth_opts.errors) {
 				err = intel_ptq_synth_error(ptq, state);
 				if (err)
