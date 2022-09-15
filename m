Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EED75B98F1
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiIOKkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 06:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIOKkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 06:40:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA397B2A2;
        Thu, 15 Sep 2022 03:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F296212B;
        Thu, 15 Sep 2022 10:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB96C433D6;
        Thu, 15 Sep 2022 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663238434;
        bh=TJbS/YJKeexWoEA2tWdxJQF+tRX9z2qATfq7Rnvw49Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyFCpCpdkt6cNXVOmJznK3n2VjcNhbWg78UFr2WUwj4YmejR3DtyvkiDYjTnJ+qjd
         5I+aELRU/Q5ctYCNP4hnXlTiR7eeRLbdPwYJWoyV/+zNBAscSwlsRny5LOL7JxokfN
         Ig00iCmjqkkKVNTr26tbznZbYqKgQqA0p1hmp0TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.258
Date:   Thu, 15 Sep 2022 12:40:51 +0200
Message-Id: <166323845116290@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166323845116159@kroah.com>
References: <166323845116159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 18ccab9a01b0..e35356f7a1e6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 257
+SUBLEVEL = 258
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index d17414cbb89a..473935695efb 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -47,7 +47,8 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 
 int init_cache_level(unsigned int cpu)
 {
-	unsigned int ctype, level, leaves, fw_level;
+	unsigned int ctype, level, leaves;
+	int fw_level;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
 	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
@@ -65,6 +66,9 @@ int init_cache_level(unsigned int cpu)
 	else
 		fw_level = acpi_find_last_cache_level(cpu);
 
+	if (fw_level < 0)
+		return fw_level;
+
 	if (level < fw_level) {
 		/*
 		 * some external caches not specified in CLIDR_EL1
diff --git a/arch/mips/loongson32/ls1c/board.c b/arch/mips/loongson32/ls1c/board.c
index eb2d913c694f..2d9675a6782c 100644
--- a/arch/mips/loongson32/ls1c/board.c
+++ b/arch/mips/loongson32/ls1c/board.c
@@ -19,7 +19,6 @@ static struct platform_device *ls1c_platform_devices[] __initdata = {
 static int __init ls1c_platform_init(void)
 {
 	ls1x_serial_set_uartclk(&ls1x_uart_pdev);
-	ls1x_rtc_set_extclk(&ls1x_rtc_pdev);
 
 	return platform_add_devices(ls1c_platform_devices,
 				   ARRAY_SIZE(ls1c_platform_devices));
diff --git a/arch/parisc/kernel/head.S b/arch/parisc/kernel/head.S
index f56cbab64ac1..92bc2fa7e692 100644
--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -22,7 +22,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	.level	PA_ASM_LEVEL
+	.level	1.1
 
 	__INITDATA
 ENTRY(boot_args)
@@ -69,6 +69,47 @@ $bss_loop:
 	stw,ma          %arg2,4(%r1)
 	stw,ma          %arg3,4(%r1)
 
+#if !defined(CONFIG_64BIT) && defined(CONFIG_PA20)
+	/* This 32-bit kernel was compiled for PA2.0 CPUs. Check current CPU
+	 * and halt kernel if we detect a PA1.x CPU. */
+	ldi		32,%r10
+	mtctl		%r10,%cr11
+	.level 2.0
+	mfctl,w		%cr11,%r10
+	.level 1.1
+	comib,<>,n	0,%r10,$cpu_ok
+
+	load32		PA(msg1),%arg0
+	ldi		msg1_end-msg1,%arg1
+$iodc_panic:
+	copy		%arg0, %r10
+	copy		%arg1, %r11
+	load32		PA(init_stack),%sp
+#define MEM_CONS 0x3A0
+	ldw		MEM_CONS+32(%r0),%arg0	// HPA
+	ldi		ENTRY_IO_COUT,%arg1
+	ldw		MEM_CONS+36(%r0),%arg2	// SPA
+	ldw		MEM_CONS+8(%r0),%arg3	// layers
+	load32		PA(__bss_start),%r1
+	stw		%r1,-52(%sp)		// arg4
+	stw		%r0,-56(%sp)		// arg5
+	stw		%r10,-60(%sp)		// arg6 = ptr to text
+	stw		%r11,-64(%sp)		// arg7 = len
+	stw		%r0,-68(%sp)		// arg8
+	load32		PA(.iodc_panic_ret), %rp
+	ldw		MEM_CONS+40(%r0),%r1	// ENTRY_IODC
+	bv,n		(%r1)
+.iodc_panic_ret:
+	b .				/* wait endless with ... */
+	or		%r10,%r10,%r10	/* qemu idle sleep */
+msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
+msg1_end:
+
+$cpu_ok:
+#endif
+
+	.level	PA_ASM_LEVEL
+
 	/* Initialize startup VM. Just map first 16/32 MB of memory */
 	load32		PA(swapper_pg_dir),%r4
 	mtctl		%r4,%cr24	/* Initialize kernel root pointer */
diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 2d1afa58a4b6..23e575194084 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -30,9 +30,11 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
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
index 18ede6e806b9..160a05c6ce88 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -121,6 +121,7 @@ SECTIONS
 	/*
 	 * Table with the patch locations to undo expolines
 	*/
+	. = ALIGN(4);
 	.nospec_call_table : {
 		__nospec_call_start = . ;
 		*(.s390_indirect*)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 747549934fe3..17a236a8b237 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -35,6 +35,7 @@
  * the optimal version — two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
@@ -55,6 +56,19 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
+	.rept nr;				\
+	call	772f;				\
+	int3;					\
+772:;						\
+	.endr;					\
+	add	$(BITS_PER_LONG/8) * nr, sp;
+#endif
 
 /* Sequence to mitigate PBRSB on eIBRS CPUs */
 #define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 35c13be4adc6..3e57d5682b69 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1809,6 +1809,18 @@ static int binder_inc_ref_for_node(struct binder_proc *proc,
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
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 26ba7a99b7d5..63390a416b44 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -738,6 +738,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		driver_deferred_probe_add(dev);
+		/*
+		 * Device can't match with a driver right now, so don't attempt
+		 * to match or bind with other drivers on the bus.
+		 */
+		return ret;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d", ret);
 		return ret;
@@ -891,6 +896,11 @@ static int __driver_attach(struct device *dev, void *data)
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		driver_deferred_probe_add(dev);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d", ret);
 		return ret;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 32606d1094fe..53ac3a0e741d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -732,10 +732,9 @@ static void clk_core_unprepare(struct clk_core *core)
 	if (core->ops->unprepare)
 		core->ops->unprepare(core->hw);
 
-	clk_pm_runtime_put(core);
-
 	trace_clk_unprepare_complete(core);
 	clk_core_unprepare(core->parent);
+	clk_pm_runtime_put(core);
 }
 
 static void clk_core_unprepare_lock(struct clk_core *core)
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 96688986da56..94aae1e67c99 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -243,29 +243,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	return ret;
 }
 
-/**
- * efi_capsule_flush - called by file close or file flush
- * @file: file pointer
- * @id: not used
- *
- *	If a capsule is being partially uploaded then calling this function
- *	will be treated as upload termination and will free those completed
- *	buffer pages and -ECANCELED will be returned.
- **/
-static int efi_capsule_flush(struct file *file, fl_owner_t id)
-{
-	int ret = 0;
-	struct capsule_info *cap_info = file->private_data;
-
-	if (cap_info->index > 0) {
-		pr_err("capsule upload not complete\n");
-		efi_free_all_buff_pages(cap_info);
-		ret = -ECANCELED;
-	}
-
-	return ret;
-}
-
 /**
  * efi_capsule_release - called by file close
  * @inode: not used
@@ -278,6 +255,13 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
 {
 	struct capsule_info *cap_info = file->private_data;
 
+	if (cap_info->index > 0 &&
+	    (cap_info->header.headersize == 0 ||
+	     cap_info->count < cap_info->total_size)) {
+		pr_err("capsule upload not complete\n");
+		efi_free_all_buff_pages(cap_info);
+	}
+
 	kfree(cap_info->pages);
 	kfree(cap_info->phys);
 	kfree(file->private_data);
@@ -325,7 +309,6 @@ static const struct file_operations efi_capsule_fops = {
 	.owner = THIS_MODULE,
 	.open = efi_capsule_open,
 	.write = efi_capsule_write,
-	.flush = efi_capsule_flush,
 	.release = efi_capsule_release,
 	.llseek = no_llseek,
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index d8ae6a23e613..d36bea68a67e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1771,7 +1771,8 @@ static void gfx_v9_0_gpu_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 	adev->gfx.config.db_debug2 = RREG32_SOC15(GC, 0, mmDB_DEBUG2);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index c963eec58c70..923bc097a00b 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -155,6 +155,7 @@ static void mmhub_v1_0_init_cache_regs(struct amdgpu_device *adev)
 	tmp = REG_SET_FIELD(tmp, VM_L2_CNTL2, INVALIDATE_L2_CACHE, 1);
 	WREG32_SOC15(MMHUB, 0, mmVM_L2_CNTL2, tmp);
 
+	tmp = mmVM_L2_CNTL3_DEFAULT;
 	if (adev->gmc.translate_further) {
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3, BANK_SELECT, 12);
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3,
diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 94c1089ecf59..1bde4b618d15 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -651,7 +651,7 @@ static int update_fdi_rx_iir_status(struct intel_vgpu *vgpu,
 	else if (FDI_RX_IMR_TO_PIPE(offset) != INVALID_INDEX)
 		index = FDI_RX_IMR_TO_PIPE(offset);
 	else {
-		gvt_vgpu_err("Unsupport registers %x\n", offset);
+		gvt_vgpu_err("Unsupported registers %x\n", offset);
 		return -EINVAL;
 	}
 
diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index dcdfb1bb54f9..ad9d693e11da 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -105,7 +105,7 @@ static const char * const dsi_8996_bus_clk_names[] = {
 static const struct msm_dsi_config msm8996_dsi_cfg = {
 	.io_offset = DSI_6G_REG_SHIFT,
 	.reg_cfg = {
-		.num = 2,
+		.num = 3,
 		.regs = {
 			{"vdda", 18160, 1 },	/* 1.25 V */
 			{"vcca", 17000, 32 },	/* 0.925 V */
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index f01e245cd0ee..bed0cd72e3eb 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -355,7 +355,7 @@ int msm_dsi_dphy_timing_calc_v3(struct msm_dsi_dphy_timing *timing,
 	} else {
 		timing->shared_timings.clk_pre =
 			linear_inter(tmax, tmin, pcnt2, 0, false);
-			timing->shared_timings.clk_pre_inc_by_2 = 0;
+		timing->shared_timings.clk_pre_inc_by_2 = 0;
 	}
 
 	timing->ta_go = 3;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 59c8a6647ff2..cc1c07963116 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1625,6 +1625,9 @@ int radeon_suspend_kms(struct drm_device *dev, bool suspend,
 		if (r) {
 			/* delay GPU reset to resume */
 			radeon_fence_driver_force_completion(rdev, i);
+		} else {
+			/* finish executing delayed work */
+			flush_delayed_work(&rdev->fence_drv[i].lockup_work);
 		}
 	}
 
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index a3974cddef07..534a175a6e4c 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -404,6 +404,9 @@ static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	if (!fan_data)
 		return -EINVAL;
 
+	if (state >= fan_data->num_speed)
+		return -EINVAL;
+
 	set_fan_speed(fan_data, state);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index cdf6e26ebc87..fb6dcd12db25 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -216,6 +216,12 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+		/* set local port to one for Function-Per-Port HCA. */
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+	}
+
 	/* Declaring support of extended counters */
 	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO) {
 		struct ib_class_port_info cpi = {};
diff --git a/drivers/input/misc/rk805-pwrkey.c b/drivers/input/misc/rk805-pwrkey.c
index 921003963a53..cdcad5c01e3c 100644
--- a/drivers/input/misc/rk805-pwrkey.c
+++ b/drivers/input/misc/rk805-pwrkey.c
@@ -106,6 +106,7 @@ static struct platform_driver rk805_pwrkey_driver = {
 };
 module_platform_driver(rk805_pwrkey_driver);
 
+MODULE_ALIAS("platform:rk805-pwrkey");
 MODULE_AUTHOR("Joseph Chen <chenjh@rock-chips.com>");
 MODULE_DESCRIPTION("RK805 PMIC Power Key driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index c1832a848714..2fa4becdaee9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -178,6 +178,10 @@ void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset)
 			"Cannot locate client instance close routine\n");
 		return;
 	}
+	if (!test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		dev_dbg(&pf->pdev->dev, "Client is not open, abort close\n");
+		return;
+	}
 	cdev->client->ops->close(&cdev->lan_info, cdev->client, reset);
 	clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
 	i40e_client_release_qvlist(&cdev->lan_info);
@@ -376,7 +380,6 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				/* Remove failed client instance */
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
-				i40e_client_del_instance(pf);
 				return;
 			}
 		}
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 6473cc68c2d5..4039e1fc6e92 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1276,7 +1276,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index a686926bba71..6ef5523f4e71 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1318,10 +1318,11 @@ static int adf7242_remove(struct spi_device *spi)
 
 	debugfs_remove_recursive(lp->debugfs_root);
 
+	ieee802154_unregister_hw(lp->hw);
+
 	cancel_delayed_work_sync(&lp->work);
 	destroy_workqueue(lp->wqueue);
 
-	ieee802154_unregister_hw(lp->hw);
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 9e2ed98f7df2..cffa0cb51720 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -204,7 +204,6 @@ static int dp83822_config_intr(struct phy_device *phydev)
 			return misr_status;
 
 		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_ANEG_COMPLETE_INT_EN |
 				DP83822_DUP_MODE_CHANGE_INT_EN |
 				DP83822_SPEED_CHANGED_INT_EN |
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index f204e139e5f0..cfa54d35ba2e 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2422,7 +2422,7 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0) {
+		while (repeat_rate > 0 && idx < (LINK_QUAL_MAX_RETRY_NUM - 1)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
@@ -2441,8 +2441,6 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 			    cpu_to_le32(new_rate);
 			repeat_rate--;
 			idx++;
-			if (idx >= LINK_QUAL_MAX_RETRY_NUM)
-				goto out;
 		}
 
 		il4965_rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2487,7 +2485,6 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		repeat_rate--;
 	}
 
-out:
 	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 6efab7a06c5f..73ee74d6e7a3 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1390,15 +1390,17 @@ ccio_init_resource(struct resource *res, char *name, void __iomem *ioaddr)
 	}
 }
 
-static void __init ccio_init_resources(struct ioc *ioc)
+static int __init ccio_init_resources(struct ioc *ioc)
 {
 	struct resource *res = ioc->mmio_region;
 	char *name = kmalloc(14, GFP_KERNEL);
-
+	if (unlikely(!name))
+		return -ENOMEM;
 	snprintf(name, 14, "GSC Bus [%d/]", ioc->hw_path);
 
 	ccio_init_resource(res, name, &ioc->ioc_regs->io_io_low);
 	ccio_init_resource(res + 1, name, &ioc->ioc_regs->io_io_low_hv);
+	return 0;
 }
 
 static int new_ioc_area(struct resource *res, unsigned long size,
@@ -1552,7 +1554,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 		return -ENOMEM;
 	}
 	ccio_ioc_init(ioc);
-	ccio_init_resources(ioc);
+	if (ccio_init_resources(ioc)) {
+		kfree(ioc);
+		return -ENOMEM;
+	}
 	hppa_dma_ops = &ccio_ops;
 	dev->dev.platform_data = kzalloc(sizeof(struct pci_hba_data), GFP_KERNEL);
 
diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index 682fc49d172c..e8440850b73a 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -253,7 +253,7 @@ static void pmc_power_off(void)
 	pm1_cnt_port = acpi_base_addr + PM1_CNT;
 
 	pm1_cnt_value = inl(pm1_cnt_port);
-	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value &= ~SLEEP_TYPE_MASK;
 	pm1_cnt_value |= SLEEP_TYPE_S5;
 	pm1_cnt_value |= SLEEP_ENABLE;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d899f216245e..c8d97dc2ca63 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3215,6 +3215,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3249,7 +3250,6 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 }
 
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index f4ad45a1efab..fd124e085020 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -689,13 +689,14 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct device_node *dn;
 	void __iomem *base;
-	int ret, i;
+	int ret, i, s;
 
 	/* AON ctrl registers */
 	base = brcmstb_ioremap_match(aon_ctrl_dt_ids, 0, NULL);
 	if (IS_ERR(base)) {
 		pr_err("error mapping AON_CTRL\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto aon_err;
 	}
 	ctrl.aon_ctrl_base = base;
 
@@ -705,8 +706,10 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 		/* Assume standard offset */
 		ctrl.aon_sram = ctrl.aon_ctrl_base +
 				     AON_CTRL_SYSTEM_DATA_RAM_OFS;
+		s = 0;
 	} else {
 		ctrl.aon_sram = base;
+		s = 1;
 	}
 
 	writel_relaxed(0, ctrl.aon_sram + AON_REG_PANIC);
@@ -716,7 +719,8 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 				     (const void **)&ddr_phy_data);
 	if (IS_ERR(base)) {
 		pr_err("error mapping DDR PHY\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto ddr_phy_err;
 	}
 	ctrl.support_warm_boot = ddr_phy_data->supports_warm_boot;
 	ctrl.pll_status_offset = ddr_phy_data->pll_status_offset;
@@ -736,17 +740,20 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, ddr_shimphy_dt_ids) {
 		i = ctrl.num_memc;
 		if (i >= MAX_NUM_MEMC) {
+			of_node_put(dn);
 			pr_warn("too many MEMCs (max %d)\n", MAX_NUM_MEMC);
 			break;
 		}
 
 		base = of_io_request_and_map(dn, 0, dn->full_name);
 		if (IS_ERR(base)) {
+			of_node_put(dn);
 			if (!ctrl.support_warm_boot)
 				break;
 
 			pr_err("error mapping DDR SHIMPHY %d\n", i);
-			return PTR_ERR(base);
+			ret = PTR_ERR(base);
+			goto ddr_shimphy_err;
 		}
 		ctrl.memcs[i].ddr_shimphy_base = base;
 		ctrl.num_memc++;
@@ -757,14 +764,18 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, brcmstb_memc_of_match) {
 		base = of_iomap(dn, 0);
 		if (!base) {
+			of_node_put(dn);
 			pr_err("error mapping DDR Sequencer %d\n", i);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto brcmstb_memc_err;
 		}
 
 		of_id = of_match_node(brcmstb_memc_of_match, dn);
 		if (!of_id) {
 			iounmap(base);
-			return -EINVAL;
+			of_node_put(dn);
+			ret = -EINVAL;
+			goto brcmstb_memc_err;
 		}
 
 		ddr_seq_data = of_id->data;
@@ -784,21 +795,24 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	dn = of_find_matching_node(NULL, sram_dt_ids);
 	if (!dn) {
 		pr_err("SRAM not found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto brcmstb_memc_err;
 	}
 
 	ret = brcmstb_init_sram(dn);
 	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
-		return ret;
+		goto brcmstb_memc_err;
 	}
 
 	ctrl.pdev = pdev;
 
 	ctrl.s3_params = kmalloc(sizeof(*ctrl.s3_params), GFP_KERNEL);
-	if (!ctrl.s3_params)
-		return -ENOMEM;
+	if (!ctrl.s3_params) {
+		ret = -ENOMEM;
+		goto s3_params_err;
+	}
 	ctrl.s3_params_pa = dma_map_single(&pdev->dev, ctrl.s3_params,
 					   sizeof(*ctrl.s3_params),
 					   DMA_TO_DEVICE);
@@ -818,7 +832,21 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 
 out:
 	kfree(ctrl.s3_params);
-
+s3_params_err:
+	iounmap(ctrl.boot_sram);
+brcmstb_memc_err:
+	for (i--; i >= 0; i--)
+		iounmap(ctrl.memcs[i].ddr_ctrl);
+ddr_shimphy_err:
+	for (i = 0; i < ctrl.num_memc; i++)
+		iounmap(ctrl.memcs[i].ddr_shimphy_base);
+
+	iounmap(ctrl.memcs[0].ddr_phy_base);
+ddr_phy_err:
+	iounmap(ctrl.aon_ctrl_base);
+	if (s)
+		iounmap(ctrl.aon_sram);
+aon_err:
 	pr_warn("PM: initialization failed with code %d\n", ret);
 
 	return ret;
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 63bc811681d9..fb092d4ec521 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -129,34 +129,6 @@ static void r871x_internal_cmd_hdl(struct _adapter *padapter, u8 *pbuf)
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
@@ -225,14 +197,6 @@ static struct cmd_obj *cmd_hdl_filter(struct _adapter *padapter,
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
index 37a7f4c735d0..dcdfd3767a48 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -387,7 +387,7 @@ static void tb_ctl_rx_submit(struct ctl_pkg *pkg)
 
 static int tb_async_error(const struct ctl_pkg *pkg)
 {
-	const struct cfg_error_pkg *error = (const struct cfg_error_pkg *)pkg;
+	const struct cfg_error_pkg *error = pkg->buffer;
 
 	if (pkg->frame.eof != TB_CFG_PKG_ERROR)
 		return false;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index b757fd1bdbfa..069d02354c82 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1102,9 +1102,9 @@ static int lpuart_config_rs485(struct uart_port *port,
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
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 198bf54568cc..c9083d853076 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4518,9 +4518,11 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
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
@@ -4547,9 +4549,11 @@ static int con_font_default(struct vc_data *vc, struct console_font_op *op)
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
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0522bd2d9d3c..e927631c79c6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1883,6 +1883,9 @@ static const struct usb_device_id acm_ids[] = {
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
index 29cc2aa5abff..4d04c75ac381 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5851,6 +5851,11 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
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
@@ -5884,6 +5889,10 @@ int usb_reset_device(struct usb_device *udev)
 		return -EISDIR;
 	}
 
+	if (udev->reset_in_progress)
+		return -EINPROGRESS;
+	udev->reset_in_progress = 1;
+
 	port_dev = hub->ports[udev->portnum - 1];
 
 	/*
@@ -5948,6 +5957,7 @@ int usb_reset_device(struct usb_device *udev)
 
 	usb_autosuspend_device(udev);
 	memalloc_noio_restore(noio_flag);
+	udev->reset_in_progress = 0;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index a9e86f5e6eaa..4f3099496019 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -142,9 +142,9 @@ static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
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
@@ -176,9 +176,9 @@ static int __dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
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
index 984faecdd7ec..465aabb6e96c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -673,15 +673,16 @@ static void dwc3_core_exit(struct dwc3 *dwc)
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
 	clk_bulk_disable(dwc->num_clks, dwc->clks);
 	clk_bulk_unprepare(dwc->num_clks, dwc->clks);
 	reset_control_assert(dwc->reset);
@@ -1509,16 +1510,16 @@ static int dwc3_probe(struct platform_device *pdev)
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
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 5bb5384f3612..9d5320562e81 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -173,6 +173,14 @@ static int dwc3_qcom_register_extcon(struct dwc3_qcom *qcom)
 	return 0;
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
@@ -280,7 +288,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
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
index 1a3878a3be78..124e9f80dccd 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -142,4 +142,5 @@ void dwc3_host_exit(struct dwc3 *dwc)
 	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
 			  dev_name(dwc->dev));
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }
diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index f7e6c42558eb..021984921f91 100644
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
index e40370ed7d8a..b5a18817c807 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -565,7 +565,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 {
 	struct xhci_hub *rhub;
@@ -1464,6 +1464,17 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 
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
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 677587479d26..7fef6d9ed04f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -149,9 +149,11 @@ int xhci_start(struct xhci_hcd *xhci)
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
@@ -774,8 +776,6 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	unsigned long flags;
-	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -791,21 +791,12 @@ void xhci_shutdown(struct usb_hcd *hcd)
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
index 3b29dfc6f79e..029ffcb13d62 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1811,7 +1811,7 @@ struct xhci_hcd {
 
 	/* Host controller watchdog timer structures */
 	unsigned int		xhc_state;
-
+	unsigned long		run_graceperiod;
 	u32			command;
 	struct s3_save		s3;
 /* Host controller is dying - not responding to commands. "I'm not dead yet!"
@@ -2145,8 +2145,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
-			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f789b60ed8c1..7eabb1bfafde 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -96,6 +96,8 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
+	u8 version;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -174,13 +176,20 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	/*
 	 * CH341A buffers data until a full endpoint-size packet (32 bytes)
 	 * has been received unless bit 7 is set.
+	 *
+	 * At least one device with version 0x27 appears to have this bit
+	 * inverted.
 	 */
-	a |= BIT(7);
+	if (priv->version > 0x27)
+		a |= BIT(7);
 
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x1312, a);
 	if (r)
 		return r;
 
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x2518, lcr);
 	if (r)
 		return r;
@@ -232,7 +241,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
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
index 95a5c73f3f78..c7c6d5d1dfbc 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -131,6 +131,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8414) }, /* Decagon USB Cable Adapter */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8470) }, /* Juniper Networks BX Series System Console */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7fa56728696d..623b54a5cd49 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1035,6 +1035,8 @@ static const struct usb_device_id id_table_combined[] = {
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
index d7ea64e8b024..fe4e340ac66e 100644
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
index 66e7f5d123c4..6a59950a63a0 100644
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
index 3f06e94771a7..52cdc06e1dea 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -91,8 +91,8 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
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
diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 413b465e69d8..7ca149ab86d2 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -432,6 +432,7 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
  err_release_fb:
 	framebuffer_release(p);
  err_disable:
+	pci_disable_device(dp);
  err_out:
 	return rc;
 }
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e5126fad57c5..4661ecaf6741 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -766,6 +766,28 @@ void debugfs_remove_recursive(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
+/**
+ * debugfs_lookup_and_remove - lookup a directory or file and recursively remove it
+ * @name: a pointer to a string containing the name of the item to look up.
+ * @parent: a pointer to the parent dentry of the item.
+ *
+ * This is the equlivant of doing something like
+ * debugfs_remove(debugfs_lookup(..)) but with the proper reference counting
+ * handled for the directory being looked up.
+ */
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent)
+{
+	struct dentry *dentry;
+
+	dentry = debugfs_lookup(name, parent);
+	if (!dentry)
+		return;
+
+	debugfs_remove(dentry);
+	dput(dentry);
+}
+EXPORT_SYMBOL_GPL(debugfs_lookup_and_remove);
+
 /**
  * debugfs_rename - rename a file/directory in the debugfs filesystem
  * @old_dir: a pointer to the parent dentry for the renamed object. This
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 9d5b0a0a651f..87fbaa84b0df 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -136,6 +136,17 @@ BUFFER_FNS(Defer_Completion, defer_completion)
 
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
+	/*
+	 * If somebody else already set this uptodate, they will
+	 * have done the memory barrier, and a reader will thus
+	 * see *some* valid buffer state.
+	 *
+	 * Any other serialization (with IO errors or whatever that
+	 * might clear the bit) has to come from other state (eg BH_Lock).
+	 */
+	if (test_bit(BH_Uptodate, &bh->b_state))
+		return;
+
 	/*
 	 * make it consistent with folio_mark_uptodate
 	 * pairs with smp_load_acquire in buffer_uptodate
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 3bc1034c57e6..2a4638bb4033 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -85,6 +85,8 @@ struct dentry *debugfs_create_automount(const char *name,
 void debugfs_remove(struct dentry *dentry);
 void debugfs_remove_recursive(struct dentry *dentry);
 
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent);
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 int debugfs_file_get(struct dentry *dentry);
@@ -217,6 +219,10 @@ static inline void debugfs_remove(struct dentry *dentry)
 static inline void debugfs_remove_recursive(struct dentry *dentry)
 { }
 
+static inline void debugfs_lookup_and_remove(const char *name,
+					     struct dentry *parent)
+{ }
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 static inline int debugfs_file_get(struct dentry *dentry)
diff --git a/include/linux/platform_data/x86/pmc_atom.h b/include/linux/platform_data/x86/pmc_atom.h
index e4905fe69c38..e4cfcb6f1663 100644
--- a/include/linux/platform_data/x86/pmc_atom.h
+++ b/include/linux/platform_data/x86/pmc_atom.h
@@ -16,6 +16,8 @@
 #ifndef PMC_ATOM_H
 #define PMC_ATOM_H
 
+#include <linux/bits.h>
+
 /* ValleyView Power Control Unit PCI Device ID */
 #define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
 /* CherryTrail Power Control Unit PCI Device ID */
@@ -148,9 +150,9 @@
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
index ff010d1fd1c7..744023c91404 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -580,6 +580,7 @@ struct usb3_lpm_parameters {
  * @level: number of USB hub ancestors
  * @can_submit: URBs may be submitted
  * @persist_enabled:  USB_PERSIST enabled for this device
+ * @reset_in_progress: the device is being reset
  * @have_langid: whether string_langid is valid
  * @authorized: policy has said we can use it;
  *	(user space) policy determines if we authorize this device to be
@@ -664,6 +665,7 @@ struct usb_device {
 
 	unsigned can_submit:1;
 	unsigned persist_enabled:1;
+	unsigned reset_in_progress:1;
 	unsigned have_langid:1;
 	unsigned authorized:1;
 	unsigned authenticated:1;
diff --git a/include/linux/usb/typec_dp.h b/include/linux/usb/typec_dp.h
index 55ae781d60a9..92460ccd16ad 100644
--- a/include/linux/usb/typec_dp.h
+++ b/include/linux/usb/typec_dp.h
@@ -68,6 +68,11 @@ enum {
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
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b2fcad8635bc..b2f01e61f0ee 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1568,6 +1568,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	/* Ensure it is not in reserved area nor out of text */
 	if (!(core_kernel_text((unsigned long) p->addr) ||
 	    is_module_text_address((unsigned long) p->addr)) ||
+	    in_gate_area_no_mm((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    find_bug((unsigned long)p->addr)) {
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 639acbb91fd5..f54734abf946 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1196,7 +1196,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1210,7 +1210,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1222,7 +1222,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1234,7 +1234,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 55c7cdf5e7b8..35642dc96852 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -385,6 +385,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -414,6 +415,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 09d5e0c7b3ba..995d86777e7c 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -201,6 +201,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e1d065ea5a15..aac5d5b73926 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2372,6 +2372,21 @@ static inline bool tcp_may_undo(const struct tcp_sock *tp)
 	return tp->undo_marker && (!tp->undo_retrans || tcp_packet_delayed(tp));
 }
 
+static bool tcp_is_non_sack_preventing_reopen(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
+		/* Hold old state until something *above* high_seq
+		 * is ACKed. For Reno it is MUST to prevent false
+		 * fast retransmits (RFC2582). SACK TCP is safe. */
+		if (!tcp_any_retrans_done(sk))
+			tp->retrans_stamp = 0;
+		return true;
+	}
+	return false;
+}
+
 /* People celebrate: "We love our President!" */
 static bool tcp_try_undo_recovery(struct sock *sk)
 {
@@ -2394,14 +2409,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
 	} else if (tp->rack.reo_wnd_persist) {
 		tp->rack.reo_wnd_persist--;
 	}
-	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
-		/* Hold old state until something *above* high_seq
-		 * is ACKed. For Reno it is MUST to prevent false
-		 * fast retransmits (RFC2582). SACK TCP is safe. */
-		if (!tcp_any_retrans_done(sk))
-			tp->retrans_stamp = 0;
+	if (tcp_is_non_sack_preventing_reopen(sk))
 		return true;
-	}
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	return false;
@@ -2437,6 +2446,8 @@ static bool tcp_try_undo_loss(struct sock *sk, bool frto_undo)
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPSPURIOUSRTOS);
 		inet_csk(sk)->icsk_retransmits = 0;
+		if (tcp_is_non_sack_preventing_reopen(sk))
+			return true;
 		if (frto_undo || tcp_is_sack(tp)) {
 			tcp_set_ca_state(sk, TCP_CA_Open);
 			tp->is_sack_reneg = 0;
@@ -3468,11 +3479,11 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 
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
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 9b2f272ca164..89d55770ac74 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -130,6 +130,11 @@ static int seg6_genl_sethmac(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	if (slen > nla_len(info->attrs[SEG6_ATTR_SECRET])) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (hinfo) {
 		err = seg6_hmac_info_del(net, hmackeyid);
 		if (err)
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index b919db02c7f9..ef2543a4c1fc 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1412,12 +1412,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->sk = csk;
 	psock->bpf_prog = prog;
 
-	err = strp_init(&psock->strp, csk, &cb);
-	if (err) {
-		kmem_cache_free(kcm_psockp, psock);
-		goto out;
-	}
-
 	write_lock_bh(&csk->sk_callback_lock);
 
 	/* Check if sk_user_data is aready by KCM or someone else.
@@ -1425,13 +1419,18 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
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
index fa13eef25f2c..38383b7e4419 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -544,6 +544,10 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	sdata_assert_lock(sdata);
 
+	/* When not connected/joined, sending CSA doesn't make sense. */
+	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED)
+		return -ENOLINK;
+
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
 		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 4dcf6e18563a..060ccd0e14ce 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -52,7 +52,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
-		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
+		if (hdr->source.mode != IEEE802154_ADDR_NONE)
 			/* FIXME: check if we are PAN coordinator */
 			skb->pkt_type = PACKET_OTHERHOST;
 		else
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4099f4d79bae..b7436935b57d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -187,8 +187,9 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
 			tuple = &ct->tuplehash[dir].tuple;
-			if (tuple->src.u3.ip != dcc_ip &&
-			    tuple->dst.u3.ip != dcc_ip) {
+			if ((tuple->src.u3.ip != dcc_ip &&
+			     ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) ||
+			    dcc_port == 0) {
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 81d205acb1b6..a8ef8efa62fc 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -139,15 +139,15 @@ static void increment_one_qlen(u32 sfbhash, u32 slot, struct sfb_sched_data *q)
 	}
 }
 
-static void increment_qlen(const struct sk_buff *skb, struct sfb_sched_data *q)
+static void increment_qlen(const struct sfb_skb_cb *cb, struct sfb_sched_data *q)
 {
 	u32 sfbhash;
 
-	sfbhash = sfb_hash(skb, 0);
+	sfbhash = cb->hashes[0];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 0, q);
 
-	sfbhash = sfb_hash(skb, 1);
+	sfbhash = cb->hashes[1];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 1, q);
 }
@@ -285,8 +285,10 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 
 	struct sfb_sched_data *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
+	struct sfb_skb_cb cb;
 	int i;
 	u32 p_min = ~0;
 	u32 minqlen = ~0;
@@ -403,11 +405,12 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 enqueue:
+	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
-		increment_qlen(skb, q);
+		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.childdrop++;
 		qdisc_qstats_drop(sch);
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 4c904ab29e0e..dcd00b514c3f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1031,7 +1031,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
-	sk_refcnt_debug_inc(newsmcsk);
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d05fa7c36d00..b1abf4848bbc 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 7b6c1c5c30dc..0268857a3cfe 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -130,7 +130,7 @@ static void map_set(u64 *up_map, int i, unsigned int v)
 
 static int map_get(u64 up_map, int i)
 {
-	return (up_map & (1 << i)) >> i;
+	return (up_map & (1ULL << i)) >> i;
 }
 
 static struct tipc_peer *peer_prev(struct tipc_peer *peer)
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 30fc6eb352bc..e6410487e25d 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -68,9 +68,10 @@ static ssize_t ht40allow_map_read(struct file *file,
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
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index b7bef25b34cc..838c3c8b403c 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -280,7 +280,9 @@ snd_seq_oss_midi_clear_all(void)
 void
 snd_seq_oss_midi_setup(struct seq_oss_devinfo *dp)
 {
+	spin_lock_irq(&register_lock);
 	dp->max_mididev = max_midi_devs;
+	spin_unlock_irq(&register_lock);
 }
 
 /*
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index aaf9c419c3dd..96cd8b7d790e 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -136,13 +136,13 @@ struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
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
@@ -157,10 +157,8 @@ struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
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
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 3c65e52b014c..1948d064fc95 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -477,17 +477,18 @@ static unsigned int loopback_pos_update(struct loopback_cable *cable)
 			cable->streams[SNDRV_PCM_STREAM_PLAYBACK];
 	struct loopback_pcm *dpcm_capt =
 			cable->streams[SNDRV_PCM_STREAM_CAPTURE];
-	unsigned long delta_play = 0, delta_capt = 0;
+	unsigned long delta_play = 0, delta_capt = 0, cur_jiffies;
 	unsigned int running, count1, count2;
 
+	cur_jiffies = jiffies;
 	running = cable->running ^ cable->pause;
 	if (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) {
-		delta_play = jiffies - dpcm_play->last_jiffies;
+		delta_play = cur_jiffies - dpcm_play->last_jiffies;
 		dpcm_play->last_jiffies += delta_play;
 	}
 
 	if (running & (1 << SNDRV_PCM_STREAM_CAPTURE)) {
-		delta_capt = jiffies - dpcm_capt->last_jiffies;
+		delta_capt = cur_jiffies - dpcm_capt->last_jiffies;
 		dpcm_capt->last_jiffies += delta_capt;
 	}
 
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index 9f2b6097f486..623776b13f8d 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -137,7 +137,7 @@ static int snd_emu10k1_pcm_channel_alloc(struct snd_emu10k1_pcm * epcm, int voic
 	epcm->voices[0]->epcm = epcm;
 	if (voices > 1) {
 		for (i = 1; i < voices; i++) {
-			epcm->voices[i] = &epcm->emu->voices[epcm->voices[0]->number + i];
+			epcm->voices[i] = &epcm->emu->voices[(epcm->voices[0]->number + i) % NUM_G];
 			epcm->voices[i]->epcm = epcm;
 		}
 	}
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 9a950aaf5e35..1cfb30465df7 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1111,7 +1111,7 @@ int snd_usb_parse_audio_interface(struct snd_usb_audio *chip, int iface_no)
 	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
 	 * one misses syncpipe, and does not produce any sound.
 	 */
-	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201) && num >= 4)
 		num = 4;
 
 	for (i = 0; i < num; i++) {
