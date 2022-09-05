Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEF75ACFE8
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiIEKOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiIEKNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594DA5464F;
        Mon,  5 Sep 2022 03:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D88611E3;
        Mon,  5 Sep 2022 10:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D50C433D7;
        Mon,  5 Sep 2022 10:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372765;
        bh=TtpXJRfSxl9DGvWCQOMDh0bgoUxIPG4Lp5Q++OGtiEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d53tF0U1VJ+cIZ0R98gO/xceFLTTuESJ3QuNhtSRMbGhmkABYLnvg0YrleFcQBVN+
         jVgP2m9a66AWr2Htoecb2YIgGp3cflDRTDKeBm1fJTXdjgguVbqOkttS3m3hHKtF9n
         G7zfUUOED7ihQeNQReBLVRRfzO8vJY4L677rwqlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.65
Date:   Mon,  5 Sep 2022 12:12:26 +0200
Message-Id: <166237274515268@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166237274583179@kroah.com>
References: <166237274583179@kroah.com>
MIME-Version: 1.0
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

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 7c1750bcc5bd..46644736e583 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/Makefile b/Makefile
index b2b65f7c168c..9142dbf41f0d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 64
+SUBLEVEL = 65
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 69e7e293f72e..9d80c783142f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -666,6 +666,23 @@ config ARM64_ERRATUM_1508412
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2441009
+	bool "Cortex-A510: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	default y
+	select ARM64_WORKAROUND_REPEAT_TLBI
+	help
+	  This option adds a workaround for ARM Cortex-A510 erratum #2441009.
+
+	  Under very rare circumstances, affected Cortex-A510 CPUs
+	  may not handle a race between a break-before-make sequence on one
+	  CPU, and another CPU accessing the same page. This could allow a
+	  store to a page that has been unmapped.
+
+	  Work around this by adding the affected CPUs to the list that needs
+	  TLB sequences to be done twice.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 292a3091b5de..23c57e0a7fd1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -213,6 +213,12 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 		/* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2441009
+	{
+		/* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+	},
 #endif
 	{},
 };
@@ -429,7 +435,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 	{
-		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
+		.desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
 		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index f0bc4dc3e9bf..6511d15ace45 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -437,7 +437,7 @@ __init int hypfs_diag_init(void)
 	int rc;
 
 	if (diag204_probe()) {
-		pr_err("The hardware system does not support hypfs\n");
+		pr_info("The hardware system does not support hypfs\n");
 		return -ENODATA;
 	}
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5c97f48cea91..ee919bfc8186 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -496,9 +496,9 @@ static int __init hypfs_init(void)
 	hypfs_vm_exit();
 fail_hypfs_diag_exit:
 	hypfs_diag_exit();
+	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 fail_dbfs_exit:
 	hypfs_dbfs_exit();
-	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 	return rc;
 }
 device_initcall(hypfs_init)
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 95105db642b9..155bbabcc6f5 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1098,8 +1098,6 @@ static int acpi_thermal_resume(struct device *dev)
 		return -EINVAL;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
-		if (!(&tz->trips.active[i]))
-			break;
 		if (!tz->trips.active[i].flags.valid)
 			break;
 		tz->trips.active[i].flags.enabled = 1;
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index bd827533e7e8..f2d9587833d4 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -315,12 +315,19 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 {
 	unsigned long vm_start = 0;
 
+	/*
+	 * Allow clearing the vma with holding just the read lock to allow
+	 * munmapping downgrade of the write lock before freeing and closing the
+	 * file using binder_alloc_vma_close().
+	 */
 	if (vma) {
 		vm_start = vma->vm_start;
 		alloc->vma_vm_mm = vma->vm_mm;
+		mmap_assert_write_locked(alloc->vma_vm_mm);
+	} else {
+		mmap_assert_locked(alloc->vma_vm_mm);
 	}
 
-	mmap_assert_write_locked(alloc->vma_vm_mm);
 	alloc->vma_addr = vm_start;
 }
 
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 9631f2fd2faf..38e8767ec371 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -368,7 +368,23 @@ static struct miscdevice udmabuf_misc = {
 
 static int __init udmabuf_dev_init(void)
 {
-	return misc_register(&udmabuf_misc);
+	int ret;
+
+	ret = misc_register(&udmabuf_misc);
+	if (ret < 0) {
+		pr_err("Could not initialize udmabuf device\n");
+		return ret;
+	}
+
+	ret = dma_coerce_mask_and_coherent(udmabuf_misc.this_device,
+					   DMA_BIT_MASK(64));
+	if (ret < 0) {
+		pr_err("Could not setup DMA mask for udmabuf device\n");
+		misc_deregister(&udmabuf_misc);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit udmabuf_dev_exit(void)
diff --git a/drivers/firmware/tegra/bpmp.c b/drivers/firmware/tegra/bpmp.c
index 5654c5e9862b..037db21de510 100644
--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -201,7 +201,7 @@ static ssize_t __tegra_bpmp_channel_read(struct tegra_bpmp_channel *channel,
 	int err;
 
 	if (data && size > 0)
-		memcpy(data, channel->ib->data, size);
+		memcpy_fromio(data, channel->ib->data, size);
 
 	err = tegra_bpmp_ack_response(channel);
 	if (err < 0)
@@ -245,7 +245,7 @@ static ssize_t __tegra_bpmp_channel_write(struct tegra_bpmp_channel *channel,
 	channel->ob->flags = flags;
 
 	if (data && size > 0)
-		memcpy(channel->ob->data, data, size);
+		memcpy_toio(channel->ob->data, data, size);
 
 	return tegra_bpmp_post_request(channel);
 }
@@ -420,7 +420,7 @@ void tegra_bpmp_mrq_return(struct tegra_bpmp_channel *channel, int code,
 	channel->ob->code = code;
 
 	if (data && size > 0)
-		memcpy(channel->ob->data, data, size);
+		memcpy_toio(channel->ob->data, data, size);
 
 	err = tegra_bpmp_post_response(channel);
 	if (WARN_ON(err < 0))
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 5f95d03fd46a..4f62f422bcb7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -312,7 +312,7 @@ enum amdgpu_kiq_irq {
 	AMDGPU_CP_KIQ_IRQ_DRIVER0 = 0,
 	AMDGPU_CP_KIQ_IRQ_LAST
 };
-
+#define SRIOV_USEC_TIMEOUT  1200000 /* wait 12 * 100ms for SRIOV */
 #define MAX_KIQ_REG_WAIT       5000 /* in usecs, 5ms */
 #define MAX_KIQ_REG_BAILOUT_INTERVAL   5 /* in msecs, 5ms */
 #define MAX_KIQ_REG_TRY 1000
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 93a4da4284ed..9c07ec8b9732 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -414,6 +414,7 @@ static int gmc_v10_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 	uint32_t seq;
 	uint16_t queried_pasid;
 	bool ret;
+	u32 usec_timeout = amdgpu_sriov_vf(adev) ? SRIOV_USEC_TIMEOUT : adev->usec_timeout;
 	struct amdgpu_ring *ring = &adev->gfx.kiq.ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq;
 
@@ -432,7 +433,7 @@ static int gmc_v10_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 
 		amdgpu_ring_commit(ring);
 		spin_unlock(&adev->gfx.kiq.ring_lock);
-		r = amdgpu_fence_wait_polling(ring, seq, adev->usec_timeout);
+		r = amdgpu_fence_wait_polling(ring, seq, usec_timeout);
 		if (r < 1) {
 			dev_err(adev->dev, "wait for kiq fence error: %ld.\n", r);
 			return -ETIME;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 0e731016921b..70d24b522df8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -863,6 +863,7 @@ static int gmc_v9_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 	uint32_t seq;
 	uint16_t queried_pasid;
 	bool ret;
+	u32 usec_timeout = amdgpu_sriov_vf(adev) ? SRIOV_USEC_TIMEOUT : adev->usec_timeout;
 	struct amdgpu_ring *ring = &adev->gfx.kiq.ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq;
 
@@ -902,7 +903,7 @@ static int gmc_v9_0_flush_gpu_tlb_pasid(struct amdgpu_device *adev,
 
 		amdgpu_ring_commit(ring);
 		spin_unlock(&adev->gfx.kiq.ring_lock);
-		r = amdgpu_fence_wait_polling(ring, seq, adev->usec_timeout);
+		r = amdgpu_fence_wait_polling(ring, seq, usec_timeout);
 		if (r < 1) {
 			dev_err(adev->dev, "wait for kiq fence error: %ld.\n", r);
 			up_read(&adev->reset_sem);
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 054823d12403..5f1b735da506 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -545,9 +545,11 @@ static void dce112_get_pix_clk_dividers_helper (
 		switch (pix_clk_params->color_depth) {
 		case COLOR_DEPTH_101010:
 			actual_pixel_clock_100hz = (actual_pixel_clock_100hz * 5) >> 2;
+			actual_pixel_clock_100hz -= actual_pixel_clock_100hz % 10;
 			break;
 		case COLOR_DEPTH_121212:
 			actual_pixel_clock_100hz = (actual_pixel_clock_100hz * 6) >> 2;
+			actual_pixel_clock_100hz -= actual_pixel_clock_100hz % 10;
 			break;
 		case COLOR_DEPTH_161616:
 			actual_pixel_clock_100hz = actual_pixel_clock_100hz * 2;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
index 11019c2c62cc..8192f1967e92 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
@@ -126,6 +126,12 @@ struct mpcc *mpc1_get_mpcc_for_dpp(struct mpc_tree *tree, int dpp_id)
 	while (tmp_mpcc != NULL) {
 		if (tmp_mpcc->dpp_id == dpp_id)
 			return tmp_mpcc;
+
+		/* avoid circular linked list */
+		ASSERT(tmp_mpcc != tmp_mpcc->mpcc_bot);
+		if (tmp_mpcc == tmp_mpcc->mpcc_bot)
+			break;
+
 		tmp_mpcc = tmp_mpcc->mpcc_bot;
 	}
 	return NULL;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
index 37848f4577b1..92fee47278e5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
@@ -480,6 +480,11 @@ void optc1_enable_optc_clock(struct timing_generator *optc, bool enable)
 				OTG_CLOCK_ON, 1,
 				1, 1000);
 	} else  {
+
+		//last chance to clear underflow, otherwise, it will always there due to clock is off.
+		if (optc->funcs->is_optc_underflow_occurred(optc) == true)
+			optc->funcs->clear_optc_underflow(optc);
+
 		REG_UPDATE_2(OTG_CLOCK_CONTROL,
 				OTG_CLOCK_GATE_DIS, 0,
 				OTG_CLOCK_EN, 0);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
index 947eb0df3f12..142fc0a3a536 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
@@ -532,6 +532,12 @@ struct mpcc *mpc2_get_mpcc_for_dpp(struct mpc_tree *tree, int dpp_id)
 	while (tmp_mpcc != NULL) {
 		if (tmp_mpcc->dpp_id == 0xf || tmp_mpcc->dpp_id == dpp_id)
 			return tmp_mpcc;
+
+		/* avoid circular linked list */
+		ASSERT(tmp_mpcc != tmp_mpcc->mpcc_bot);
+		if (tmp_mpcc == tmp_mpcc->mpcc_bot)
+			break;
+
 		tmp_mpcc = tmp_mpcc->mpcc_bot;
 	}
 	return NULL;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
index 36044cb8ec83..1c0f56d8ba8b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
@@ -67,9 +67,15 @@ static uint32_t convert_and_clamp(
 void dcn21_dchvm_init(struct hubbub *hubbub)
 {
 	struct dcn20_hubbub *hubbub1 = TO_DCN20_HUBBUB(hubbub);
-	uint32_t riommu_active;
+	uint32_t riommu_active, prefetch_done;
 	int i;
 
+	REG_GET(DCHVM_RIOMMU_STAT0, HOSTVM_PREFETCH_DONE, &prefetch_done);
+
+	if (prefetch_done) {
+		hubbub->riommu_active = true;
+		return;
+	}
 	//Init DCHVM block
 	REG_UPDATE(DCHVM_CTRL0, HOSTVM_INIT_REQ, 1);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
index f24612523248..33c2337c4edf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
@@ -86,7 +86,7 @@ bool hubp3_program_surface_flip_and_addr(
 			VMID, address->vmid);
 
 	if (address->type == PLN_ADDR_TYPE_GRPH_STEREO) {
-		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_MODE_FOR_STEREOSYNC, 0x1);
+		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_MODE_FOR_STEREOSYNC, 0);
 		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_IN_STEREOSYNC, 0x1);
 
 	} else {
diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index b99aa232bd8b..4bee6d018bfa 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -567,10 +567,6 @@ static void build_vrr_infopacket_data_v1(const struct mod_vrr_params *vrr,
 	 * Note: We should never go above the field rate of the mode timing set.
 	 */
 	infopacket->sb[8] = (unsigned char)((vrr->max_refresh_in_uhz + 500000) / 1000000);
-
-	/* FreeSync HDR */
-	infopacket->sb[9] = 0;
-	infopacket->sb[10] = 0;
 }
 
 static void build_vrr_infopacket_data_v3(const struct mod_vrr_params *vrr,
@@ -638,10 +634,6 @@ static void build_vrr_infopacket_data_v3(const struct mod_vrr_params *vrr,
 
 	/* PB16 : Reserved bits 7:1, FixedRate bit 0 */
 	infopacket->sb[16] = (vrr->state == VRR_STATE_ACTIVE_FIXED) ? 1 : 0;
-
-	//FreeSync HDR
-	infopacket->sb[9] = 0;
-	infopacket->sb[10] = 0;
 }
 
 static void build_vrr_infopacket_fs2_data(enum color_transfer_func app_tf,
@@ -726,8 +718,7 @@ static void build_vrr_infopacket_header_v2(enum signal_type signal,
 		/* HB2  = [Bits 7:5 = 0] [Bits 4:0 = Length = 0x09] */
 		infopacket->hb2 = 0x09;
 
-		*payload_size = 0x0A;
-
+		*payload_size = 0x09;
 	} else if (dc_is_dp_signal(signal)) {
 
 		/* HEADER */
@@ -776,9 +767,9 @@ static void build_vrr_infopacket_header_v3(enum signal_type signal,
 		infopacket->hb1 = version;
 
 		/* HB2  = [Bits 7:5 = 0] [Bits 4:0 = Length] */
-		*payload_size = 0x10;
-		infopacket->hb2 = *payload_size - 1; //-1 for checksum
+		infopacket->hb2 = 0x10;
 
+		*payload_size = 0x10;
 	} else if (dc_is_dp_signal(signal)) {
 
 		/* HEADER */
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 918d5c7c2328..79976921dc46 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -3915,6 +3915,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.dump_pptable = sienna_cichlid_dump_pptable,
 	.init_microcode = smu_v11_0_init_microcode,
 	.load_microcode = smu_v11_0_load_microcode,
+	.fini_microcode = smu_v11_0_fini_microcode,
 	.init_smc_tables = sienna_cichlid_init_smc_tables,
 	.fini_smc_tables = smu_v11_0_fini_smc_tables,
 	.init_power = smu_v11_0_init_power,
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 3a76000d15bf..ed8ad3b26395 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -949,6 +949,9 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
 		return;
 
+	if (intel_gt_is_wedged(gt))
+		return;
+
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);
diff --git a/drivers/gpu/drm/vc4/Kconfig b/drivers/gpu/drm/vc4/Kconfig
index 345a5570a3da..e2c147d4015e 100644
--- a/drivers/gpu/drm/vc4/Kconfig
+++ b/drivers/gpu/drm/vc4/Kconfig
@@ -5,6 +5,7 @@ config DRM_VC4
 	depends on DRM
 	depends on SND && SND_SOC
 	depends on COMMON_CLK
+	depends on PM
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 10cf623d2830..9b3e642a08e1 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2122,7 +2122,7 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	return 0;
 }
 
-static int __maybe_unused vc4_hdmi_runtime_suspend(struct device *dev)
+static int vc4_hdmi_runtime_suspend(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 
@@ -2219,17 +2219,15 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		goto err_put_ddc;
 
+	pm_runtime_enable(dev);
+
 	/*
-	 * We need to have the device powered up at this point to call
-	 * our reset hook and for the CEC init.
+	 *  We need to have the device powered up at this point to call
+	 *  our reset hook and for the CEC init.
 	 */
-	ret = vc4_hdmi_runtime_resume(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret)
-		goto err_put_ddc;
-
-	pm_runtime_get_noresume(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+		goto err_disable_runtime_pm;
 
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
@@ -2278,6 +2276,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 err_destroy_encoder:
 	drm_encoder_cleanup(encoder);
 	pm_runtime_put_sync(dev);
+err_disable_runtime_pm:
 	pm_runtime_disable(dev);
 err_put_ddc:
 	put_device(&vc4_hdmi->ddc->dev);
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 13a4db42cd7a..f17f061aeb79 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -281,11 +281,29 @@ static int amd_sfh_irq_init(struct amd_mp2_dev *privdata)
 	return 0;
 }
 
+static const struct dmi_system_id dmi_nodevs[] = {
+	{
+		/*
+		 * Google Chromebooks use Chrome OS Embedded Controller Sensor
+		 * Hub instead of Sensor Hub Fusion and leaves MP2
+		 * uninitialized, which disables all functionalities, even
+		 * including the registers necessary for feature detections.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+		},
+	},
+	{ }
+};
+
 static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct amd_mp2_dev *privdata;
 	int rc;
 
+	if (dmi_first_match(dmi_nodevs))
+		return -ENODEV;
+
 	privdata = devm_kzalloc(&pdev->dev, sizeof(*privdata), GFP_KERNEL);
 	if (!privdata)
 		return -ENOMEM;
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 08c9a9a60ae4..b59c3dafa6a4 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1212,6 +1212,13 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc = new_rdesc;
 	}
 
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD &&
+			*rsize == 331 && rdesc[190] == 0x85 && rdesc[191] == 0x5a &&
+			rdesc[204] == 0x95 && rdesc[205] == 0x05) {
+		hid_info(hdev, "Fixing up Asus N-KEY keyb report descriptor\n");
+		rdesc[205] = 0x01;
+	}
+
 	return rdesc;
 }
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ceaa36fc429e..cb2b48d6915e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -399,6 +399,7 @@
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 #define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
+#define I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN	0x279F
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 125043a28a35..f197aed6444a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -335,6 +335,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index a3b151b29bd7..fc616db4231b 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -134,6 +134,11 @@ static int steam_recv_report(struct steam_device *steam,
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 
@@ -165,6 +170,11 @@ static int steam_send_report(struct steam_device *steam,
 	int ret;
 
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
+	if (!r) {
+		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
+		return -EINVAL;
+	}
+
 	if (hid_report_len(r) < 64)
 		return -EINVAL;
 
diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index a28c3e575650..2221bc26e611 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -67,12 +67,13 @@ static const struct tm_wheel_info tm_wheels_infos[] = {
 	{0x0200, 0x0005, "Thrustmaster T300RS (Missing Attachment)"},
 	{0x0206, 0x0005, "Thrustmaster T300RS"},
 	{0x0209, 0x0005, "Thrustmaster T300RS (Open Wheel Attachment)"},
+	{0x020a, 0x0005, "Thrustmaster T300RS (Sparco R383 Mod)"},
 	{0x0204, 0x0005, "Thrustmaster T300 Ferrari Alcantara Edition"},
 	{0x0002, 0x0002, "Thrustmaster T500RS"}
 	//{0x0407, 0x0001, "Thrustmaster TMX"}
 };
 
-static const uint8_t tm_wheels_infos_length = 4;
+static const uint8_t tm_wheels_infos_length = 7;
 
 /*
  * This structs contains (in little endian) the response data
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 79faac87a06f..11b0ed4f3f8c 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -346,10 +346,13 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct hidraw_list *list = file->private_data;
 	unsigned long flags;
+	int i;
 
 	mutex_lock(&minors_lock);
 
 	spin_lock_irqsave(&hidraw_table[minor]->list_lock, flags);
+	for (i = list->tail; i < list->head; i++)
+		kfree(list->buffer[i].value);
 	list_del(&list->node);
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	kfree(list);
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 3cf334c46c31..3248b48f37f6 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/completion.h>
+#include <linux/count_zeros.h>
 #include <linux/memory_hotplug.h>
 #include <linux/memory.h>
 #include <linux/notifier.h>
@@ -1130,6 +1131,7 @@ static void post_status(struct hv_dynmem_device *dm)
 	struct dm_status status;
 	unsigned long now = jiffies;
 	unsigned long last_post = last_post_time;
+	unsigned long num_pages_avail, num_pages_committed;
 
 	if (pressure_report_delay > 0) {
 		--pressure_report_delay;
@@ -1154,16 +1156,21 @@ static void post_status(struct hv_dynmem_device *dm)
 	 * num_pages_onlined) as committed to the host, otherwise it can try
 	 * asking us to balloon them out.
 	 */
-	status.num_avail = si_mem_available();
-	status.num_committed = vm_memory_committed() +
+	num_pages_avail = si_mem_available();
+	num_pages_committed = vm_memory_committed() +
 		dm->num_pages_ballooned +
 		(dm->num_pages_added > dm->num_pages_onlined ?
 		 dm->num_pages_added - dm->num_pages_onlined : 0) +
 		compute_balloon_floor();
 
-	trace_balloon_status(status.num_avail, status.num_committed,
+	trace_balloon_status(num_pages_avail, num_pages_committed,
 			     vm_memory_committed(), dm->num_pages_ballooned,
 			     dm->num_pages_added, dm->num_pages_onlined);
+
+	/* Convert numbers of pages into numbers of HV_HYP_PAGEs. */
+	status.num_avail = num_pages_avail * NR_HV_HYP_PAGES_IN_PAGE;
+	status.num_committed = num_pages_committed * NR_HV_HYP_PAGES_IN_PAGE;
+
 	/*
 	 * If our transaction ID is no longer current, just don't
 	 * send the status. This can happen if we were interrupted
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index fccd1798445d..d22ce328a279 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2610,6 +2610,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
+		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);
diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index f9b2897569bb..99d8881a7d6c 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2345,6 +2345,9 @@ static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 	/* disable busy check */
 	sdr_clr_bits(host->base + MSDC_PATCH_BIT1, MSDC_PB1_BUSY_CHECK_SEL);
 
+	val = readl(host->base + MSDC_INT);
+	writel(val, host->base + MSDC_INT);
+
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
@@ -2785,11 +2788,14 @@ static int __maybe_unused msdc_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	int ret;
+	u32 val;
 
 	if (mmc->caps2 & MMC_CAP2_CQE) {
 		ret = cqhci_suspend(mmc);
 		if (ret)
 			return ret;
+		val = readl(((struct msdc_host *)mmc_priv(mmc))->base + MSDC_INT);
+		writel(val, ((struct msdc_host *)mmc_priv(mmc))->base + MSDC_INT);
 	}
 
 	return pm_runtime_force_suspend(dev);
diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index bac874ab0b33..335c88fd849c 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/reset.h>
 #include <linux/sizes.h>
 
 #include "sdhci-pltfm.h"
@@ -55,14 +56,15 @@
 #define DLL_LOCK_WO_TMOUT(x) \
 	((((x) & DWCMSHC_EMMC_DLL_LOCKED) == DWCMSHC_EMMC_DLL_LOCKED) && \
 	(((x) & DWCMSHC_EMMC_DLL_TIMEOUT) == 0))
-#define RK3568_MAX_CLKS 3
+#define RK35xx_MAX_CLKS 3
 
 #define BOUNDARY_OK(addr, len) \
 	((addr | (SZ_128M - 1)) == ((addr + len - 1) | (SZ_128M - 1)))
 
-struct rk3568_priv {
+struct rk35xx_priv {
 	/* Rockchip specified optional clocks */
-	struct clk_bulk_data rockchip_clks[RK3568_MAX_CLKS];
+	struct clk_bulk_data rockchip_clks[RK35xx_MAX_CLKS];
+	struct reset_control *reset;
 	u8 txclk_tapnum;
 };
 
@@ -176,7 +178,7 @@ static void dwcmshc_rk3568_set_clock(struct sdhci_host *host, unsigned int clock
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *dwc_priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *priv = dwc_priv->priv;
+	struct rk35xx_priv *priv = dwc_priv->priv;
 	u8 txclk_tapnum = DLL_TXCLK_TAPNUM_DEFAULT;
 	u32 extra, reg;
 	int err;
@@ -255,6 +257,21 @@ static void dwcmshc_rk3568_set_clock(struct sdhci_host *host, unsigned int clock
 	sdhci_writel(host, extra, DWCMSHC_EMMC_DLL_STRBIN);
 }
 
+static void rk35xx_sdhci_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct dwcmshc_priv *dwc_priv = sdhci_pltfm_priv(pltfm_host);
+	struct rk35xx_priv *priv = dwc_priv->priv;
+
+	if (mask & SDHCI_RESET_ALL && priv->reset) {
+		reset_control_assert(priv->reset);
+		udelay(1);
+		reset_control_deassert(priv->reset);
+	}
+
+	sdhci_reset(host, mask);
+}
+
 static const struct sdhci_ops sdhci_dwcmshc_ops = {
 	.set_clock		= sdhci_set_clock,
 	.set_bus_width		= sdhci_set_bus_width,
@@ -264,12 +281,12 @@ static const struct sdhci_ops sdhci_dwcmshc_ops = {
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 };
 
-static const struct sdhci_ops sdhci_dwcmshc_rk3568_ops = {
+static const struct sdhci_ops sdhci_dwcmshc_rk35xx_ops = {
 	.set_clock		= dwcmshc_rk3568_set_clock,
 	.set_bus_width		= sdhci_set_bus_width,
 	.set_uhs_signaling	= dwcmshc_set_uhs_signaling,
 	.get_max_clock		= sdhci_pltfm_clk_get_max_clock,
-	.reset			= sdhci_reset,
+	.reset			= rk35xx_sdhci_reset,
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 };
 
@@ -279,30 +296,46 @@ static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
-static const struct sdhci_pltfm_data sdhci_dwcmshc_rk3568_pdata = {
-	.ops = &sdhci_dwcmshc_rk3568_ops,
+#ifdef CONFIG_ACPI
+static const struct sdhci_pltfm_data sdhci_dwcmshc_bf3_pdata = {
+	.ops = &sdhci_dwcmshc_ops,
+	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_ACMD23_BROKEN,
+};
+#endif
+
+static const struct sdhci_pltfm_data sdhci_dwcmshc_rk35xx_pdata = {
+	.ops = &sdhci_dwcmshc_rk35xx_ops,
 	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_CLOCK_DIV_ZERO_BROKEN,
 };
 
-static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
+static int dwcmshc_rk35xx_init(struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
 {
 	int err;
-	struct rk3568_priv *priv = dwc_priv->priv;
+	struct rk35xx_priv *priv = dwc_priv->priv;
+
+	priv->reset = devm_reset_control_array_get_optional_exclusive(mmc_dev(host->mmc));
+	if (IS_ERR(priv->reset)) {
+		err = PTR_ERR(priv->reset);
+		dev_err(mmc_dev(host->mmc), "failed to get reset control %d\n", err);
+		return err;
+	}
 
 	priv->rockchip_clks[0].id = "axi";
 	priv->rockchip_clks[1].id = "block";
 	priv->rockchip_clks[2].id = "timer";
-	err = devm_clk_bulk_get_optional(mmc_dev(host->mmc), RK3568_MAX_CLKS,
+	err = devm_clk_bulk_get_optional(mmc_dev(host->mmc), RK35xx_MAX_CLKS,
 					 priv->rockchip_clks);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "failed to get clocks %d\n", err);
 		return err;
 	}
 
-	err = clk_bulk_prepare_enable(RK3568_MAX_CLKS, priv->rockchip_clks);
+	err = clk_bulk_prepare_enable(RK35xx_MAX_CLKS, priv->rockchip_clks);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "failed to enable clocks %d\n", err);
 		return err;
@@ -324,7 +357,7 @@ static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc
 static const struct of_device_id sdhci_dwcmshc_dt_ids[] = {
 	{
 		.compatible = "rockchip,rk3568-dwcmshc",
-		.data = &sdhci_dwcmshc_rk3568_pdata,
+		.data = &sdhci_dwcmshc_rk35xx_pdata,
 	},
 	{
 		.compatible = "snps,dwcmshc-sdhci",
@@ -336,7 +369,10 @@ MODULE_DEVICE_TABLE(of, sdhci_dwcmshc_dt_ids);
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id sdhci_dwcmshc_acpi_ids[] = {
-	{ .id = "MLNXBF30" },
+	{
+		.id = "MLNXBF30",
+		.driver_data = (kernel_ulong_t)&sdhci_dwcmshc_bf3_pdata,
+	},
 	{}
 };
 #endif
@@ -347,12 +383,12 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	struct sdhci_pltfm_host *pltfm_host;
 	struct sdhci_host *host;
 	struct dwcmshc_priv *priv;
-	struct rk3568_priv *rk_priv = NULL;
+	struct rk35xx_priv *rk_priv = NULL;
 	const struct sdhci_pltfm_data *pltfm_data;
 	int err;
 	u32 extra;
 
-	pltfm_data = of_device_get_match_data(&pdev->dev);
+	pltfm_data = device_get_match_data(&pdev->dev);
 	if (!pltfm_data) {
 		dev_err(&pdev->dev, "Error: No device match data found\n");
 		return -ENODEV;
@@ -402,8 +438,8 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	host->mmc_host_ops.request = dwcmshc_request;
 	host->mmc_host_ops.hs400_enhanced_strobe = dwcmshc_hs400_enhanced_strobe;
 
-	if (pltfm_data == &sdhci_dwcmshc_rk3568_pdata) {
-		rk_priv = devm_kzalloc(&pdev->dev, sizeof(struct rk3568_priv), GFP_KERNEL);
+	if (pltfm_data == &sdhci_dwcmshc_rk35xx_pdata) {
+		rk_priv = devm_kzalloc(&pdev->dev, sizeof(struct rk35xx_priv), GFP_KERNEL);
 		if (!rk_priv) {
 			err = -ENOMEM;
 			goto err_clk;
@@ -411,7 +447,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 
 		priv->priv = rk_priv;
 
-		err = dwcmshc_rk3568_init(host, priv);
+		err = dwcmshc_rk35xx_init(host, priv);
 		if (err)
 			goto err_clk;
 	}
@@ -428,7 +464,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_disable_unprepare(priv->bus_clk);
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 free_pltfm:
 	sdhci_pltfm_free(pdev);
@@ -440,14 +476,14 @@ static int dwcmshc_remove(struct platform_device *pdev)
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_disable_unprepare(priv->bus_clk);
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 	sdhci_pltfm_free(pdev);
 
@@ -460,7 +496,7 @@ static int dwcmshc_suspend(struct device *dev)
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 	int ret;
 
 	ret = sdhci_suspend_host(host);
@@ -472,7 +508,7 @@ static int dwcmshc_suspend(struct device *dev)
 		clk_disable_unprepare(priv->bus_clk);
 
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 
 	return ret;
@@ -483,7 +519,7 @@ static int dwcmshc_resume(struct device *dev)
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 	int ret;
 
 	ret = clk_prepare_enable(pltfm_host->clk);
@@ -497,7 +533,7 @@ static int dwcmshc_resume(struct device *dev)
 	}
 
 	if (rk_priv) {
-		ret = clk_bulk_prepare_enable(RK3568_MAX_CLKS,
+		ret = clk_bulk_prepare_enable(RK35xx_MAX_CLKS,
 					      rk_priv->rockchip_clks);
 		if (ret)
 			return ret;
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 1ac7fec47d6f..604feeb84ee4 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -222,8 +222,15 @@ static int get_port_device_capability(struct pci_dev *dev)
 
 #ifdef CONFIG_PCIEAER
 	if (dev->aer_cap && pci_aer_available() &&
-	    (pcie_ports_native || host->native_aer))
+	    (pcie_ports_native || host->native_aer)) {
 		services |= PCIE_PORT_SERVICE_AER;
+
+		/*
+		 * Disable AER on this port in case it's been enabled by the
+		 * BIOS (the AER service driver will enable it when necessary).
+		 */
+		pci_disable_pcie_error_reporting(dev);
+	}
 #endif
 
 	/* Root Ports and Root Complex Event Collectors may generate PMEs */
diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index c68725eebee3..cbcf112c88d3 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -617,6 +617,11 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		return -EINVAL;
 	}
 
+	if (!var->pixclock) {
+		DPRINTK("pixclock is zero\n");
+		return -EINVAL;
+	}
+
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 909cc00ef5ce..474dcc0540a8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -418,39 +418,26 @@ void btrfs_wait_block_group_cache_progress(struct btrfs_block_group *cache,
 	btrfs_put_caching_control(caching_ctl);
 }
 
-int btrfs_wait_block_group_cache_done(struct btrfs_block_group *cache)
+static int btrfs_caching_ctl_wait_done(struct btrfs_block_group *cache,
+				       struct btrfs_caching_control *caching_ctl)
+{
+	wait_event(caching_ctl->wait, btrfs_block_group_done(cache));
+	return cache->cached == BTRFS_CACHE_ERROR ? -EIO : 0;
+}
+
+static int btrfs_wait_block_group_cache_done(struct btrfs_block_group *cache)
 {
 	struct btrfs_caching_control *caching_ctl;
-	int ret = 0;
+	int ret;
 
 	caching_ctl = btrfs_get_caching_control(cache);
 	if (!caching_ctl)
 		return (cache->cached == BTRFS_CACHE_ERROR) ? -EIO : 0;
-
-	wait_event(caching_ctl->wait, btrfs_block_group_done(cache));
-	if (cache->cached == BTRFS_CACHE_ERROR)
-		ret = -EIO;
+	ret = btrfs_caching_ctl_wait_done(cache, caching_ctl);
 	btrfs_put_caching_control(caching_ctl);
 	return ret;
 }
 
-static bool space_cache_v1_done(struct btrfs_block_group *cache)
-{
-	bool ret;
-
-	spin_lock(&cache->lock);
-	ret = cache->cached != BTRFS_CACHE_FAST;
-	spin_unlock(&cache->lock);
-
-	return ret;
-}
-
-void btrfs_wait_space_cache_v1_finished(struct btrfs_block_group *cache,
-				struct btrfs_caching_control *caching_ctl)
-{
-	wait_event(caching_ctl->wait, space_cache_v1_done(cache));
-}
-
 #ifdef CONFIG_BTRFS_DEBUG
 static void fragment_free_space(struct btrfs_block_group *block_group)
 {
@@ -727,9 +714,8 @@ static noinline void caching_thread(struct btrfs_work *work)
 	btrfs_put_block_group(block_group);
 }
 
-int btrfs_cache_block_group(struct btrfs_block_group *cache, int load_cache_only)
+int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 {
-	DEFINE_WAIT(wait);
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_caching_control *caching_ctl = NULL;
 	int ret = 0;
@@ -762,10 +748,7 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, int load_cache_only
 	}
 	WARN_ON(cache->caching_ctl);
 	cache->caching_ctl = caching_ctl;
-	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		cache->cached = BTRFS_CACHE_FAST;
-	else
-		cache->cached = BTRFS_CACHE_STARTED;
+	cache->cached = BTRFS_CACHE_STARTED;
 	cache->has_caching_ctl = 1;
 	spin_unlock(&cache->lock);
 
@@ -778,8 +761,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, int load_cache_only
 
 	btrfs_queue_work(fs_info->caching_workers, &caching_ctl->work);
 out:
-	if (load_cache_only && caching_ctl)
-		btrfs_wait_space_cache_v1_finished(cache, caching_ctl);
+	if (wait && caching_ctl)
+		ret = btrfs_caching_ctl_wait_done(cache, caching_ctl);
 	if (caching_ctl)
 		btrfs_put_caching_control(caching_ctl);
 
@@ -3200,7 +3183,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		 * space back to the block group, otherwise we will leak space.
 		 */
 		if (!alloc && !btrfs_block_group_done(cache))
-			btrfs_cache_block_group(cache, 1);
+			btrfs_cache_block_group(cache, true);
 
 		byte_in_group = bytenr - cache->start;
 		WARN_ON(byte_in_group > cache->length);
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d73db0dfacb2..a15868d607a9 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -251,9 +251,7 @@ void btrfs_dec_nocow_writers(struct btrfs_fs_info *fs_info, u64 bytenr);
 void btrfs_wait_nocow_writers(struct btrfs_block_group *bg);
 void btrfs_wait_block_group_cache_progress(struct btrfs_block_group *cache,
 				           u64 num_bytes);
-int btrfs_wait_block_group_cache_done(struct btrfs_block_group *cache);
-int btrfs_cache_block_group(struct btrfs_block_group *cache,
-			    int load_cache_only);
+int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait);
 void btrfs_put_caching_control(struct btrfs_caching_control *ctl);
 struct btrfs_caching_control *btrfs_get_caching_control(
 		struct btrfs_block_group *cache);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 341ce90d24b1..fb7e331b6975 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1938,6 +1938,9 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 		if (!p->skip_locking) {
 			level = btrfs_header_level(b);
+
+			btrfs_maybe_reset_lockdep_class(root, b);
+
 			if (level <= write_lock_level) {
 				btrfs_tree_lock(b);
 				p->locks[level] = BTRFS_WRITE_LOCK;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1831135fef1a..02d3ee6c7d9b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -454,7 +454,6 @@ struct btrfs_free_cluster {
 enum btrfs_caching_type {
 	BTRFS_CACHE_NO,
 	BTRFS_CACHE_STARTED,
-	BTRFS_CACHE_FAST,
 	BTRFS_CACHE_FINISHED,
 	BTRFS_CACHE_ERROR,
 };
@@ -1105,6 +1104,8 @@ enum {
 	BTRFS_ROOT_QGROUP_FLUSHING,
 	/* This root has a drop operation that was started previously. */
 	BTRFS_ROOT_UNFINISHED_DROP,
+	/* This reloc root needs to have its buffers lockdep class reset. */
+	BTRFS_ROOT_RESET_LOCKDEP_CLASS,
 };
 
 static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
@@ -3166,7 +3167,6 @@ void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 247d7f9ced3b..c76c360bece5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -121,88 +121,6 @@ struct async_submit_bio {
 	blk_status_t status;
 };
 
-/*
- * Lockdep class keys for extent_buffer->lock's in this root.  For a given
- * eb, the lockdep key is determined by the btrfs_root it belongs to and
- * the level the eb occupies in the tree.
- *
- * Different roots are used for different purposes and may nest inside each
- * other and they require separate keysets.  As lockdep keys should be
- * static, assign keysets according to the purpose of the root as indicated
- * by btrfs_root->root_key.objectid.  This ensures that all special purpose
- * roots have separate keysets.
- *
- * Lock-nesting across peer nodes is always done with the immediate parent
- * node locked thus preventing deadlock.  As lockdep doesn't know this, use
- * subclass to avoid triggering lockdep warning in such cases.
- *
- * The key is set by the readpage_end_io_hook after the buffer has passed
- * csum validation but before the pages are unlocked.  It is also set by
- * btrfs_init_new_buffer on freshly allocated blocks.
- *
- * We also add a check to make sure the highest level of the tree is the
- * same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this code
- * needs update as well.
- */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# if BTRFS_MAX_LEVEL != 8
-#  error
-# endif
-
-#define DEFINE_LEVEL(stem, level)					\
-	.names[level] = "btrfs-" stem "-0" #level,
-
-#define DEFINE_NAME(stem)						\
-	DEFINE_LEVEL(stem, 0)						\
-	DEFINE_LEVEL(stem, 1)						\
-	DEFINE_LEVEL(stem, 2)						\
-	DEFINE_LEVEL(stem, 3)						\
-	DEFINE_LEVEL(stem, 4)						\
-	DEFINE_LEVEL(stem, 5)						\
-	DEFINE_LEVEL(stem, 6)						\
-	DEFINE_LEVEL(stem, 7)
-
-static struct btrfs_lockdep_keyset {
-	u64			id;		/* root objectid */
-	/* Longest entry: btrfs-free-space-00 */
-	char			names[BTRFS_MAX_LEVEL][20];
-	struct lock_class_key	keys[BTRFS_MAX_LEVEL];
-} btrfs_lockdep_keysets[] = {
-	{ .id = BTRFS_ROOT_TREE_OBJECTID,	DEFINE_NAME("root")	},
-	{ .id = BTRFS_EXTENT_TREE_OBJECTID,	DEFINE_NAME("extent")	},
-	{ .id = BTRFS_CHUNK_TREE_OBJECTID,	DEFINE_NAME("chunk")	},
-	{ .id = BTRFS_DEV_TREE_OBJECTID,	DEFINE_NAME("dev")	},
-	{ .id = BTRFS_CSUM_TREE_OBJECTID,	DEFINE_NAME("csum")	},
-	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	DEFINE_NAME("quota")	},
-	{ .id = BTRFS_TREE_LOG_OBJECTID,	DEFINE_NAME("log")	},
-	{ .id = BTRFS_TREE_RELOC_OBJECTID,	DEFINE_NAME("treloc")	},
-	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	DEFINE_NAME("dreloc")	},
-	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
-	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
-	{ .id = 0,				DEFINE_NAME("tree")	},
-};
-
-#undef DEFINE_LEVEL
-#undef DEFINE_NAME
-
-void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
-				    int level)
-{
-	struct btrfs_lockdep_keyset *ks;
-
-	BUG_ON(level >= ARRAY_SIZE(ks->keys));
-
-	/* find the matching keyset, id 0 is the default entry */
-	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
-		if (ks->id == objectid)
-			break;
-
-	lockdep_set_class_and_name(&eb->lock,
-				   &ks->keys[level], ks->names[level]);
-}
-
-#endif
-
 /*
  * Compute the csum of a btree block and store the result to provided buffer.
  */
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 0e7e9526b6a8..1b8fd3deafc9 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -140,14 +140,4 @@ int btrfs_init_root_free_objectid(struct btrfs_root *root);
 int __init btrfs_end_io_wq_init(void);
 void __cold btrfs_end_io_wq_exit(void);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-void btrfs_set_buffer_lockdep_class(u64 objectid,
-			            struct extent_buffer *eb, int level);
-#else
-static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
-					struct extent_buffer *eb, int level)
-{
-}
-#endif
-
 #endif
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 248ea15c9734..401a425a587c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2572,17 +2572,10 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 
 	/*
-	 * pull in the free space cache (if any) so that our pin
-	 * removes the free space from the cache.  We have load_only set
-	 * to one because the slow code to read in the free extents does check
-	 * the pinned extents.
+	 * Fully cache the free space first so that our pin removes the free space
+	 * from the cache.
 	 */
-	btrfs_cache_block_group(cache, 1);
-	/*
-	 * Make sure we wait until the cache is completely built in case it is
-	 * missing or is invalid and therefore needs to be rebuilt.
-	 */
-	ret = btrfs_wait_block_group_cache_done(cache);
+	ret = btrfs_cache_block_group(cache, true);
 	if (ret)
 		goto out;
 
@@ -2605,12 +2598,7 @@ static int __exclude_logged_extent(struct btrfs_fs_info *fs_info,
 	if (!block_group)
 		return -EINVAL;
 
-	btrfs_cache_block_group(block_group, 1);
-	/*
-	 * Make sure we wait until the cache is completely built in case it is
-	 * missing or is invalid and therefore needs to be rebuilt.
-	 */
-	ret = btrfs_wait_block_group_cache_done(block_group);
+	ret = btrfs_cache_block_group(block_group, true);
 	if (ret)
 		goto out;
 
@@ -4324,7 +4312,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ffe_ctl.cached = btrfs_block_group_done(block_group);
 		if (unlikely(!ffe_ctl.cached)) {
 			ffe_ctl.have_caching_bg = true;
-			ret = btrfs_cache_block_group(block_group, 0);
+			ret = btrfs_cache_block_group(block_group, false);
 
 			/*
 			 * If we get ENOMEM here or something else we want to
@@ -4781,6 +4769,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *buf;
+	u64 lockdep_owner = owner;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr, owner, level);
 	if (IS_ERR(buf))
@@ -4799,12 +4788,27 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		return ERR_PTR(-EUCLEAN);
 	}
 
+	/*
+	 * The reloc trees are just snapshots, so we need them to appear to be
+	 * just like any other fs tree WRT lockdep.
+	 *
+	 * The exception however is in replace_path() in relocation, where we
+	 * hold the lock on the original fs root and then search for the reloc
+	 * root.  At that point we need to make sure any reloc root buffers are
+	 * set to the BTRFS_TREE_RELOC_OBJECTID lockdep class in order to make
+	 * lockdep happy.
+	 */
+	if (lockdep_owner == BTRFS_TREE_RELOC_OBJECTID &&
+	    !test_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &root->state))
+		lockdep_owner = BTRFS_FS_TREE_OBJECTID;
+
 	/*
 	 * This needs to stay, because we could allocate a freed block from an
 	 * old tree into a new tree, so we need to make sure this new block is
 	 * set to the appropriate level and owner.
 	 */
-	btrfs_set_buffer_lockdep_class(owner, buf, level);
+	btrfs_set_buffer_lockdep_class(lockdep_owner, buf, level);
+
 	__btrfs_tree_lock(buf, nest);
 	btrfs_clean_tree_block(buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
@@ -6066,13 +6070,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 
 		if (end - start >= range->minlen) {
 			if (!btrfs_block_group_done(cache)) {
-				ret = btrfs_cache_block_group(cache, 0);
-				if (ret) {
-					bg_failed++;
-					bg_ret = ret;
-					continue;
-				}
-				ret = btrfs_wait_block_group_cache_done(cache);
+				ret = btrfs_cache_block_group(cache, true);
 				if (ret) {
 					bg_failed++;
 					bg_ret = ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a72a8d4d4a72..7bd704779a99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6109,6 +6109,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
+	u64 lockdep_owner = owner_root;
 	int uptodate = 1;
 	int ret;
 
@@ -6143,7 +6144,15 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (!eb)
 		return ERR_PTR(-ENOMEM);
-	btrfs_set_buffer_lockdep_class(owner_root, eb, level);
+
+	/*
+	 * The reloc trees are just snapshots, so we need them to appear to be
+	 * just like any other fs tree WRT lockdep.
+	 */
+	if (lockdep_owner == BTRFS_TREE_RELOC_OBJECTID)
+		lockdep_owner = BTRFS_FS_TREE_OBJECTID;
+
+	btrfs_set_buffer_lockdep_class(lockdep_owner, eb, level);
 
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++, index++) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 428a56f248bb..f8a01964a216 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4097,11 +4097,11 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
  * also drops the back refs in the inode to the directory
  */
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
 				const char *name, int name_len)
 {
+	struct btrfs_root *root = dir->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	int ret = 0;
@@ -4201,15 +4201,14 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len)
 {
 	int ret;
-	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
+	ret = __btrfs_unlink_inode(trans, dir, inode, name, name_len);
 	if (!ret) {
 		drop_nlink(&inode->vfs_inode);
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, inode->root, inode);
 	}
 	return ret;
 }
@@ -4238,7 +4237,6 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 
 static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
 	struct inode *inode = d_inode(dentry);
 	int ret;
@@ -4250,7 +4248,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 			0);
 
-	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
 	if (ret)
@@ -4264,7 +4262,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 out:
 	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty(root->fs_info);
+	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
 	return ret;
 }
 
@@ -4622,7 +4620,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	int err = 0;
-	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
 	u64 last_unlink_trans;
 
@@ -4647,7 +4644,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
 
 	/* now the directory is empty */
-	err = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+	err = btrfs_unlink_inode(trans, BTRFS_I(dir),
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
 	if (!err) {
@@ -4668,7 +4665,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	}
 out:
 	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty(root->fs_info);
+	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
 
 	return err;
 }
@@ -9571,7 +9568,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else { /* src is an inode */
-		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
 					   old_dentry->d_name.name,
 					   old_dentry->d_name.len);
@@ -9587,7 +9584,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 	} else { /* dest is an inode */
-		ret = __btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
 					   new_dentry->d_name.name,
 					   new_dentry->d_name.len);
@@ -9862,7 +9859,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		 */
 		btrfs_pin_log_trans(root);
 		log_pinned = true;
-		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					BTRFS_I(d_inode(old_dentry)),
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
@@ -9882,7 +9879,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 			ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 			BUG_ON(new_inode->i_nlink == 0);
 		} else {
-			ret = btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 33461b4f9c8b..9063072b399b 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -13,6 +13,93 @@
 #include "extent_io.h"
 #include "locking.h"
 
+/*
+ * Lockdep class keys for extent_buffer->lock's in this root.  For a given
+ * eb, the lockdep key is determined by the btrfs_root it belongs to and
+ * the level the eb occupies in the tree.
+ *
+ * Different roots are used for different purposes and may nest inside each
+ * other and they require separate keysets.  As lockdep keys should be
+ * static, assign keysets according to the purpose of the root as indicated
+ * by btrfs_root->root_key.objectid.  This ensures that all special purpose
+ * roots have separate keysets.
+ *
+ * Lock-nesting across peer nodes is always done with the immediate parent
+ * node locked thus preventing deadlock.  As lockdep doesn't know this, use
+ * subclass to avoid triggering lockdep warning in such cases.
+ *
+ * The key is set by the readpage_end_io_hook after the buffer has passed
+ * csum validation but before the pages are unlocked.  It is also set by
+ * btrfs_init_new_buffer on freshly allocated blocks.
+ *
+ * We also add a check to make sure the highest level of the tree is the
+ * same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this code
+ * needs update as well.
+ */
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if BTRFS_MAX_LEVEL != 8
+#error
+#endif
+
+#define DEFINE_LEVEL(stem, level)					\
+	.names[level] = "btrfs-" stem "-0" #level,
+
+#define DEFINE_NAME(stem)						\
+	DEFINE_LEVEL(stem, 0)						\
+	DEFINE_LEVEL(stem, 1)						\
+	DEFINE_LEVEL(stem, 2)						\
+	DEFINE_LEVEL(stem, 3)						\
+	DEFINE_LEVEL(stem, 4)						\
+	DEFINE_LEVEL(stem, 5)						\
+	DEFINE_LEVEL(stem, 6)						\
+	DEFINE_LEVEL(stem, 7)
+
+static struct btrfs_lockdep_keyset {
+	u64			id;		/* root objectid */
+	/* Longest entry: btrfs-free-space-00 */
+	char			names[BTRFS_MAX_LEVEL][20];
+	struct lock_class_key	keys[BTRFS_MAX_LEVEL];
+} btrfs_lockdep_keysets[] = {
+	{ .id = BTRFS_ROOT_TREE_OBJECTID,	DEFINE_NAME("root")	},
+	{ .id = BTRFS_EXTENT_TREE_OBJECTID,	DEFINE_NAME("extent")	},
+	{ .id = BTRFS_CHUNK_TREE_OBJECTID,	DEFINE_NAME("chunk")	},
+	{ .id = BTRFS_DEV_TREE_OBJECTID,	DEFINE_NAME("dev")	},
+	{ .id = BTRFS_CSUM_TREE_OBJECTID,	DEFINE_NAME("csum")	},
+	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	DEFINE_NAME("quota")	},
+	{ .id = BTRFS_TREE_LOG_OBJECTID,	DEFINE_NAME("log")	},
+	{ .id = BTRFS_TREE_RELOC_OBJECTID,	DEFINE_NAME("treloc")	},
+	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	DEFINE_NAME("dreloc")	},
+	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
+	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
+	{ .id = 0,				DEFINE_NAME("tree")	},
+};
+
+#undef DEFINE_LEVEL
+#undef DEFINE_NAME
+
+void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb, int level)
+{
+	struct btrfs_lockdep_keyset *ks;
+
+	BUG_ON(level >= ARRAY_SIZE(ks->keys));
+
+	/* Find the matching keyset, id 0 is the default entry */
+	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
+		if (ks->id == objectid)
+			break;
+
+	lockdep_set_class_and_name(&eb->lock, &ks->keys[level], ks->names[level]);
+}
+
+void btrfs_maybe_reset_lockdep_class(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	if (test_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &root->state))
+		btrfs_set_buffer_lockdep_class(root->root_key.objectid,
+					       eb, btrfs_header_level(eb));
+}
+
+#endif
+
 /*
  * Extent buffer locking
  * =====================
@@ -164,6 +251,8 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
 
 	while (1) {
 		eb = btrfs_root_node(root);
+
+		btrfs_maybe_reset_lockdep_class(root, eb);
 		btrfs_tree_lock(eb);
 		if (eb == root->node)
 			break;
@@ -185,6 +274,8 @@ struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
 
 	while (1) {
 		eb = btrfs_root_node(root);
+
+		btrfs_maybe_reset_lockdep_class(root, eb);
 		btrfs_tree_read_lock(eb);
 		if (eb == root->node)
 			break;
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index a2e1f1f5c6e3..26a2f962c268 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -130,4 +130,18 @@ void btrfs_drew_write_unlock(struct btrfs_drew_lock *lock);
 void btrfs_drew_read_lock(struct btrfs_drew_lock *lock);
 void btrfs_drew_read_unlock(struct btrfs_drew_lock *lock);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb, int level);
+void btrfs_maybe_reset_lockdep_class(struct btrfs_root *root, struct extent_buffer *eb);
+#else
+static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
+					struct extent_buffer *eb, int level)
+{
+}
+static inline void btrfs_maybe_reset_lockdep_class(struct btrfs_root *root,
+						   struct extent_buffer *eb)
+{
+}
+#endif
+
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 673e11fcf3fc..becf3396d533 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1326,7 +1326,9 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		btrfs_release_path(path);
 
 		path->lowest_level = level;
+		set_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &src->state);
 		ret = btrfs_search_slot(trans, src, &key, path, 0, 1);
+		clear_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &src->state);
 		path->lowest_level = 0;
 		if (ret) {
 			if (ret > 0)
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 51382d2be3d4..a84d2d489510 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1216,7 +1216,8 @@ static void extent_err(const struct extent_buffer *eb, int slot,
 }
 
 static int check_extent_item(struct extent_buffer *leaf,
-			     struct btrfs_key *key, int slot)
+			     struct btrfs_key *key, int slot,
+			     struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_extent_item *ei;
@@ -1436,6 +1437,26 @@ static int check_extent_item(struct extent_buffer *leaf,
 			   total_refs, inline_refs);
 		return -EUCLEAN;
 	}
+
+	if ((prev_key->type == BTRFS_EXTENT_ITEM_KEY) ||
+	    (prev_key->type == BTRFS_METADATA_ITEM_KEY)) {
+		u64 prev_end = prev_key->objectid;
+
+		if (prev_key->type == BTRFS_METADATA_ITEM_KEY)
+			prev_end += fs_info->nodesize;
+		else
+			prev_end += prev_key->offset;
+
+		if (unlikely(prev_end > key->objectid)) {
+			extent_err(leaf, slot,
+	"previous extent [%llu %u %llu] overlaps current extent [%llu %u %llu]",
+				   prev_key->objectid, prev_key->type,
+				   prev_key->offset, key->objectid, key->type,
+				   key->offset);
+			return -EUCLEAN;
+		}
+	}
+
 	return 0;
 }
 
@@ -1604,7 +1625,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
-		ret = check_extent_item(leaf, key, slot);
+		ret = check_extent_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_TREE_BLOCK_REF_KEY:
 	case BTRFS_SHARED_DATA_REF_KEY:
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d7e9812f55e..727289658730 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -884,6 +884,26 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int unlink_inode_for_log_replay(struct btrfs_trans_handle *trans,
+				       struct btrfs_inode *dir,
+				       struct btrfs_inode *inode,
+				       const char *name,
+				       int name_len)
+{
+	int ret;
+
+	ret = btrfs_unlink_inode(trans, dir, inode, name, name_len);
+	if (ret)
+		return ret;
+	/*
+	 * Whenever we need to check if a name exists or not, we check the
+	 * fs/subvolume tree. So after an unlink we must run delayed items, so
+	 * that future checks for a name during log replay see that the name
+	 * does not exists anymore.
+	 */
+	return btrfs_run_delayed_items(trans);
+}
+
 /*
  * when cleaning up conflicts between the directory names in the
  * subvolume, directory names in the log and directory names in the
@@ -926,12 +946,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_unlink_inode(trans, root, dir, BTRFS_I(inode), name,
+	ret = unlink_inode_for_log_replay(trans, dir, BTRFS_I(inode), name,
 			name_len);
-	if (ret)
-		goto out;
-	else
-		ret = btrfs_run_delayed_items(trans);
 out:
 	kfree(name);
 	iput(inode);
@@ -1091,12 +1107,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				inc_nlink(&inode->vfs_inode);
 				btrfs_release_path(path);
 
-				ret = btrfs_unlink_inode(trans, root, dir, inode,
+				ret = unlink_inode_for_log_replay(trans, dir, inode,
 						victim_name, victim_name_len);
 				kfree(victim_name);
-				if (ret)
-					return ret;
-				ret = btrfs_run_delayed_items(trans);
 				if (ret)
 					return ret;
 				*search_done = 1;
@@ -1165,14 +1178,11 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					inc_nlink(&inode->vfs_inode);
 					btrfs_release_path(path);
 
-					ret = btrfs_unlink_inode(trans, root,
+					ret = unlink_inode_for_log_replay(trans,
 							BTRFS_I(victim_parent),
 							inode,
 							victim_name,
 							victim_name_len);
-					if (!ret)
-						ret = btrfs_run_delayed_items(
-								  trans);
 				}
 				iput(victim_parent);
 				kfree(victim_name);
@@ -1327,19 +1337,10 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 				kfree(name);
 				goto out;
 			}
-			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+			ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir),
 						 inode, name, namelen);
 			kfree(name);
 			iput(dir);
-			/*
-			 * Whenever we need to check if a name exists or not, we
-			 * check the subvolume tree. So after an unlink we must
-			 * run delayed items, so that future checks for a name
-			 * during log replay see that the name does not exists
-			 * anymore.
-			 */
-			if (!ret)
-				ret = btrfs_run_delayed_items(trans);
 			if (ret)
 				goto out;
 			goto again;
@@ -1434,8 +1435,8 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		ret = -ENOENT;
 		goto out;
 	}
-	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(other_inode),
-				 name, namelen);
+	ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir), BTRFS_I(other_inode),
+					  name, namelen);
 	if (ret)
 		goto out;
 	/*
@@ -1443,11 +1444,7 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	 * on the inode will not free it. We will fixup the link count later.
 	 */
 	if (other_inode->i_nlink == 0)
-		inc_nlink(other_inode);
-
-	ret = btrfs_run_delayed_items(trans);
-	if (ret)
-		goto out;
+		set_nlink(other_inode, 1);
 add_link:
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     name, namelen, 0, ref_index);
@@ -1580,7 +1577,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			ret = btrfs_inode_ref_exists(inode, dir, key->type,
 						     name, namelen);
 			if (ret > 0) {
-				ret = btrfs_unlink_inode(trans, root,
+				ret = unlink_inode_for_log_replay(trans,
 							 BTRFS_I(dir),
 							 BTRFS_I(inode),
 							 name, namelen);
@@ -1590,16 +1587,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				 * free it. We will fixup the link count later.
 				 */
 				if (!ret && inode->i_nlink == 0)
-					inc_nlink(inode);
-				/*
-				 * Whenever we need to check if a name exists or
-				 * not, we check the subvolume tree. So after an
-				 * unlink we must run delayed items, so that future
-				 * checks for a name during log replay see that the
-				 * name does not exists anymore.
-				 */
-				if (!ret)
-					ret = btrfs_run_delayed_items(trans);
+					set_nlink(inode, 1);
 			}
 			if (ret < 0)
 				goto out;
@@ -2197,7 +2185,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
  */
 static noinline int find_dir_range(struct btrfs_root *root,
 				   struct btrfs_path *path,
-				   u64 dirid, int key_type,
+				   u64 dirid,
 				   u64 *start_ret, u64 *end_ret)
 {
 	struct btrfs_key key;
@@ -2210,7 +2198,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 		return 1;
 
 	key.objectid = dirid;
-	key.type = key_type;
+	key.type = BTRFS_DIR_LOG_INDEX_KEY;
 	key.offset = *start_ret;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -2224,7 +2212,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 	if (ret != 0)
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
-	if (key.type != key_type || key.objectid != dirid) {
+	if (key.type != BTRFS_DIR_LOG_INDEX_KEY || key.objectid != dirid) {
 		ret = 1;
 		goto next;
 	}
@@ -2251,7 +2239,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
-	if (key.type != key_type || key.objectid != dirid) {
+	if (key.type != BTRFS_DIR_LOG_INDEX_KEY || key.objectid != dirid) {
 		ret = 1;
 		goto out;
 	}
@@ -2282,95 +2270,75 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	int ret;
 	struct extent_buffer *eb;
 	int slot;
-	u32 item_size;
 	struct btrfs_dir_item *di;
-	struct btrfs_dir_item *log_di;
 	int name_len;
-	unsigned long ptr;
-	unsigned long ptr_end;
 	char *name;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	struct btrfs_key location;
 
-again:
+	/*
+	 * Currenly we only log dir index keys. Even if we replay a log created
+	 * by an older kernel that logged both dir index and dir item keys, all
+	 * we need to do is process the dir index keys, we (and our caller) can
+	 * safely ignore dir item keys (key type BTRFS_DIR_ITEM_KEY).
+	 */
+	ASSERT(dir_key->type == BTRFS_DIR_INDEX_KEY);
+
 	eb = path->nodes[0];
 	slot = path->slots[0];
-	item_size = btrfs_item_size_nr(eb, slot);
-	ptr = btrfs_item_ptr_offset(eb, slot);
-	ptr_end = ptr + item_size;
-	while (ptr < ptr_end) {
-		di = (struct btrfs_dir_item *)ptr;
-		name_len = btrfs_dir_name_len(eb, di);
-		name = kmalloc(name_len, GFP_NOFS);
-		if (!name) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		read_extent_buffer(eb, name, (unsigned long)(di + 1),
-				  name_len);
-		log_di = NULL;
-		if (log && dir_key->type == BTRFS_DIR_ITEM_KEY) {
-			log_di = btrfs_lookup_dir_item(trans, log, log_path,
-						       dir_key->objectid,
-						       name, name_len, 0);
-		} else if (log && dir_key->type == BTRFS_DIR_INDEX_KEY) {
-			log_di = btrfs_lookup_dir_index_item(trans, log,
-						     log_path,
-						     dir_key->objectid,
-						     dir_key->offset,
-						     name, name_len, 0);
-		}
-		if (!log_di) {
-			btrfs_dir_item_key_to_cpu(eb, di, &location);
-			btrfs_release_path(path);
-			btrfs_release_path(log_path);
-			inode = read_one_inode(root, location.objectid);
-			if (!inode) {
-				kfree(name);
-				return -EIO;
-			}
+	di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
+	name_len = btrfs_dir_name_len(eb, di);
+	name = kmalloc(name_len, GFP_NOFS);
+	if (!name) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-			ret = link_to_fixup_dir(trans, root,
-						path, location.objectid);
-			if (ret) {
-				kfree(name);
-				iput(inode);
-				goto out;
-			}
+	read_extent_buffer(eb, name, (unsigned long)(di + 1), name_len);
 
-			inc_nlink(inode);
-			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
-					BTRFS_I(inode), name, name_len);
-			if (!ret)
-				ret = btrfs_run_delayed_items(trans);
-			kfree(name);
-			iput(inode);
-			if (ret)
-				goto out;
+	if (log) {
+		struct btrfs_dir_item *log_di;
 
-			/* there might still be more names under this key
-			 * check and repeat if required
-			 */
-			ret = btrfs_search_slot(NULL, root, dir_key, path,
-						0, 0);
-			if (ret == 0)
-				goto again;
+		log_di = btrfs_lookup_dir_index_item(trans, log, log_path,
+						     dir_key->objectid,
+						     dir_key->offset,
+						     name, name_len, 0);
+		if (IS_ERR(log_di)) {
+			ret = PTR_ERR(log_di);
+			goto out;
+		} else if (log_di) {
+			/* The dentry exists in the log, we have nothing to do. */
 			ret = 0;
 			goto out;
-		} else if (IS_ERR(log_di)) {
-			kfree(name);
-			return PTR_ERR(log_di);
 		}
-		btrfs_release_path(log_path);
-		kfree(name);
+	}
 
-		ptr = (unsigned long)(di + 1);
-		ptr += name_len;
+	btrfs_dir_item_key_to_cpu(eb, di, &location);
+	btrfs_release_path(path);
+	btrfs_release_path(log_path);
+	inode = read_one_inode(root, location.objectid);
+	if (!inode) {
+		ret = -EIO;
+		goto out;
 	}
-	ret = 0;
+
+	ret = link_to_fixup_dir(trans, root, path, location.objectid);
+	if (ret)
+		goto out;
+
+	inc_nlink(inode);
+	ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir), BTRFS_I(inode),
+					  name, name_len);
+	/*
+	 * Unlike dir item keys, dir index keys can only have one name (entry) in
+	 * them, as there are no key collisions since each key has a unique offset
+	 * (an index number), so we're done.
+	 */
 out:
 	btrfs_release_path(path);
 	btrfs_release_path(log_path);
+	kfree(name);
+	iput(inode);
 	return ret;
 }
 
@@ -2490,7 +2458,6 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 {
 	u64 range_start;
 	u64 range_end;
-	int key_type = BTRFS_DIR_LOG_ITEM_KEY;
 	int ret = 0;
 	struct btrfs_key dir_key;
 	struct btrfs_key found_key;
@@ -2498,7 +2465,7 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 	struct inode *dir;
 
 	dir_key.objectid = dirid;
-	dir_key.type = BTRFS_DIR_ITEM_KEY;
+	dir_key.type = BTRFS_DIR_INDEX_KEY;
 	log_path = btrfs_alloc_path();
 	if (!log_path)
 		return -ENOMEM;
@@ -2512,14 +2479,14 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 		btrfs_free_path(log_path);
 		return 0;
 	}
-again:
+
 	range_start = 0;
 	range_end = 0;
 	while (1) {
 		if (del_all)
 			range_end = (u64)-1;
 		else {
-			ret = find_dir_range(log, path, dirid, key_type,
+			ret = find_dir_range(log, path, dirid,
 					     &range_start, &range_end);
 			if (ret < 0)
 				goto out;
@@ -2546,8 +2513,10 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 					      path->slots[0]);
 			if (found_key.objectid != dirid ||
-			    found_key.type != dir_key.type)
-				goto next_type;
+			    found_key.type != dir_key.type) {
+				ret = 0;
+				goto out;
+			}
 
 			if (found_key.offset > range_end)
 				break;
@@ -2566,15 +2535,7 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 			break;
 		range_start = range_end + 1;
 	}
-
-next_type:
 	ret = 0;
-	if (key_type == BTRFS_DIR_LOG_ITEM_KEY) {
-		key_type = BTRFS_DIR_LOG_INDEX_KEY;
-		dir_key.type = BTRFS_DIR_INDEX_KEY;
-		btrfs_release_path(path);
-		goto again;
-	}
 out:
 	btrfs_release_path(path);
 	btrfs_free_path(log_path);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2680e9756b1d..ed6abd74f386 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -486,8 +486,6 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
-	bool				done;
-	bool				canceled;
 	struct wait_queue_entry		wait;
 };
 
@@ -885,6 +883,9 @@ struct io_kiocb {
 
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
+	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
+	struct io_buffer		*kbuf;
+	atomic_t			poll_refs;
 };
 
 struct io_tctx_node {
@@ -1079,8 +1080,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
-static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
+
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1154,12 +1155,6 @@ static inline bool req_ref_put_and_test(struct io_kiocb *req)
 	return atomic_dec_and_test(&req->refs);
 }
 
-static inline void req_ref_put(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-	WARN_ON_ONCE(req_ref_put_and_test(req));
-}
-
 static inline void req_ref_get(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
@@ -1515,7 +1510,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req->ctx, req->user_data, status, 0);
+		io_fill_cqe_req(req, status, 0);
 		io_put_req_deferred(req);
 	}
 }
@@ -1763,7 +1758,7 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     long res, unsigned int cflags)
+				     s32 res, u32 cflags)
 {
 	struct io_overflow_cqe *ocqe;
 
@@ -1790,8 +1785,8 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1812,20 +1807,25 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
-/* not as hot to bloat with inlining */
-static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
-	return __io_cqring_fill_event(ctx, user_data, res, cflags);
+	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags)
+{
+	ctx->cq_extra++;
+	return __io_fill_cqe(ctx, user_data, res, cflags);
+}
+
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_cqring_fill_event(ctx, req->user_data, res, cflags);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1861,8 +1861,8 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
 	return req->flags & IO_REQ_CLEAN_FLAGS;
 }
 
-static void io_req_complete_state(struct io_kiocb *req, long res,
-				  unsigned int cflags)
+static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
+					 u32 cflags)
 {
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
@@ -1872,7 +1872,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
-				     long res, unsigned cflags)
+				     s32 res, u32 cflags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 		io_req_complete_state(req, res, cflags);
@@ -1880,12 +1880,12 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
 
-static inline void io_req_complete(struct io_kiocb *req, long res)
+static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	__io_req_complete(req, 0, res, 0);
 }
 
-static void io_req_complete_failed(struct io_kiocb *req, long res)
+static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
 	io_req_complete_post(req, res, 0);
@@ -2051,8 +2051,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
 		}
@@ -2076,7 +2075,7 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
+		io_fill_cqe_req(link, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2093,8 +2092,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_cqring_fill_event(link->ctx, link->user_data,
-					     -ECANCELED, 0);
+			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
 		}
@@ -2370,8 +2368,8 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2482,8 +2480,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
+		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -2707,7 +2704,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
-	long res = req->result;
+	int res = req->result;
 
 	if (*locked) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -5316,52 +5313,23 @@ struct io_poll_table {
 	int error;
 };
 
-static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
-			   __poll_t mask, io_req_tw_func_t func)
-{
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
-
-	list_del_init(&poll->wait.entry);
+#define IO_POLL_CANCEL_FLAG	BIT(31)
+#define IO_POLL_REF_MASK	GENMASK(30, 0)
 
-	req->result = mask;
-	req->io_task_work.func = func;
-
-	/*
-	 * If this fails, then the task is exiting. When a task exits, the
-	 * work gets canceled, so just cancel this request as well instead
-	 * of executing it. We can't safely execute it anyway, as we may not
-	 * have the needed state needed for it anyway.
-	 */
-	io_req_task_work_add(req);
-	return 1;
+/*
+ * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
+ * bump it and acquire ownership. It's disallowed to modify requests while not
+ * owning it, that prevents from races for enqueueing task_work's and b/w
+ * arming poll and wakeups.
+ */
+static inline bool io_poll_get_ownership(struct io_kiocb *req)
+{
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
-static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
-	__acquires(&req->ctx->completion_lock)
+static void io_poll_mark_cancelled(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
-		WRITE_ONCE(poll->canceled, true);
-
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		struct poll_table_struct pt = { ._key = poll->events };
-
-		req->result = vfs_poll(req->file, &pt) & poll->events;
-	}
-
-	spin_lock(&ctx->completion_lock);
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
-		return true;
-	}
-
-	return false;
+	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
 }
 
 static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
@@ -5379,141 +5347,231 @@ static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
 	return &req->apoll->poll;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
+static void io_poll_req_insert(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = io_poll_get_double(req);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hlist_head *list;
 
-	lockdep_assert_held(&req->ctx->completion_lock);
+	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	hlist_add_head(&req->hash_node, list);
+}
 
-	if (poll && poll->head) {
-		struct wait_queue_head *head = poll->head;
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
+	/* mask in events that we always want/need */
+	poll->events = events | IO_POLL_UNMASK;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
 
+static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
+{
+	struct wait_queue_head *head = smp_load_acquire(&poll->head);
+
+	if (head) {
 		spin_lock_irq(&head->lock);
 		list_del_init(&poll->wait.entry);
-		if (poll->wait.private)
-			req_ref_put(req);
 		poll->head = NULL;
 		spin_unlock_irq(&head->lock);
 	}
 }
 
-static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
+static void io_poll_remove_entries(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll_double = io_poll_get_double(req);
+
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	io_poll_remove_entry(poll);
+	if (poll_double)
+		io_poll_remove_entry(poll_double);
+	rcu_read_unlock();
+}
+
+/*
+ * All poll tw should go through this. Checks for poll events, manages
+ * references, does rewait, etc.
+ *
+ * Returns a negative error on failure. >0 when no action require, which is
+ * either spurious wakeup or multishot CQE is served. 0 when it's done with
+ * the request, then the mask is stored in req->result.
+ */
+static int io_poll_check_events(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned flags = IORING_CQE_F_MORE;
-	int error;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	int v;
+
+	/* req->task == current here, checking PF_EXITING is safe */
+	if (unlikely(req->task->flags & PF_EXITING))
+		io_poll_mark_cancelled(req);
+
+	do {
+		v = atomic_read(&req->poll_refs);
+
+		/* tw handler should be the owner, and so have some references */
+		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
+			return 0;
+		if (v & IO_POLL_CANCEL_FLAG)
+			return -ECANCELED;
+
+		if (!req->result) {
+			struct poll_table_struct pt = { ._key = poll->events };
+
+			req->result = vfs_poll(req->file, &pt) & poll->events;
+		}
+
+		/* multishot, just fill an CQE and proceed */
+		if (req->result && !(poll->events & EPOLLONESHOT)) {
+			__poll_t mask = mangle_poll(req->result & poll->events);
+			bool filled;
 
-	if (READ_ONCE(req->poll.canceled)) {
-		error = -ECANCELED;
-		req->poll.events |= EPOLLONESHOT;
+			spin_lock(&ctx->completion_lock);
+			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
+						 IORING_CQE_F_MORE);
+			io_commit_cqring(ctx);
+			spin_unlock(&ctx->completion_lock);
+			if (unlikely(!filled))
+				return -ECANCELED;
+			io_cqring_ev_posted(ctx);
+		} else if (req->result) {
+			return 0;
+		}
+
+		/*
+		 * Release all references, retry if someone tried to restart
+		 * task_work while we were executing it.
+		 */
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+
+	return 1;
+}
+
+static void io_poll_task_func(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
+
+	if (!ret) {
+		req->result = mangle_poll(req->result & req->poll.events);
 	} else {
-		error = mangle_poll(mask);
-	}
-	if (req->poll.events & EPOLLONESHOT)
-		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		req->poll.events |= EPOLLONESHOT;
-		flags = 0;
+		req->result = ret;
+		req_set_fail(req);
 	}
-	if (flags & IORING_CQE_F_MORE)
-		ctx->cq_extra++;
 
-	return !(flags & IORING_CQE_F_MORE);
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+	io_req_complete_post(req, req->result, 0);
 }
 
-static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
+static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 {
-	bool done;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
 
-	done = __io_poll_complete(req, mask);
-	io_commit_cqring(req->ctx);
-	return done;
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
+
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+
+	if (!ret)
+		io_req_task_submit(req, locked);
+	else
+		io_req_complete_failed(req, ret);
 }
 
-static void io_poll_task_func(struct io_kiocb *req, bool *locked)
+static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt;
+	req->result = mask;
+	if (req->opcode == IORING_OP_POLL_ADD)
+		req->io_task_work.func = io_poll_task_func;
+	else
+		req->io_task_work.func = io_apoll_task_func;
 
-	if (io_poll_rewait(req, &req->poll)) {
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		bool done;
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+	io_req_task_work_add(req);
+}
 
-		if (req->poll.done) {
-			spin_unlock(&ctx->completion_lock);
-			return;
-		}
-		done = __io_poll_complete(req, req->result);
-		if (done) {
-			io_poll_remove_double(req);
-			hash_del(&req->hash_node);
-			req->poll.done = true;
-		} else {
-			req->result = 0;
-			add_wait_queue(req->poll.head, &req->poll.wait);
-		}
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_ev_posted(ctx);
+static inline void io_poll_execute(struct io_kiocb *req, int res)
+{
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, res);
+}
 
-		if (done) {
-			nxt = io_put_req_find_next(req);
-			if (nxt)
-				io_req_task_submit(nxt, locked);
-		}
-	}
+static void io_poll_cancel_req(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	/* kick tw, which should complete the request */
+	io_poll_execute(req, 0);
 }
 
-static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
-			       int sync, void *key)
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
+						 wait);
 	__poll_t mask = key_to_poll(key);
-	unsigned long flags;
 
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-	if (!(poll->events & EPOLLONESHOT))
-		return poll->wait.func(&poll->wait, mode, sync, key);
+	if (unlikely(mask & POLLFREE)) {
+		io_poll_mark_cancelled(req);
+		/* we have to kick tw in case it's not already */
+		io_poll_execute(req, 0);
 
-	list_del_init(&wait->entry);
+		/*
+		 * If the waitqueue is being freed early but someone is already
+		 * holds ownership over it, we have to tear down the request as
+		 * best we can. That means immediately removing the request from
+		 * its waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.
+		 */
+		list_del_init(&poll->wait.entry);
 
-	if (poll->head) {
-		bool done;
-
-		spin_lock_irqsave(&poll->head->lock, flags);
-		done = list_empty(&poll->wait.entry);
-		if (!done)
-			list_del_init(&poll->wait.entry);
-		/* make sure double remove sees this as being gone */
-		wait->private = NULL;
-		spin_unlock_irqrestore(&poll->head->lock, flags);
-		if (!done) {
-			/* use wait func handler, so it matches the rq type */
-			poll->wait.func(&poll->wait, mode, sync, key);
-		}
+		/*
+		 * Careful: this *must* be the last step, since as soon
+		 * as req->head is NULL'ed out, the request can be
+		 * completed and freed, since aio_poll_complete_work()
+		 * will no longer need to take the waitqueue lock.
+		 */
+		smp_store_release(&poll->head, NULL);
+		return 1;
 	}
-	req_ref_put(req);
-	return 1;
-}
 
-static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
-			      wait_queue_func_t wake_func)
-{
-	poll->head = NULL;
-	poll->done = false;
-	poll->canceled = false;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
-	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
+	/* for instances that support it check for an event match first */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, mask);
+	return 1;
 }
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
@@ -5528,10 +5586,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 * if this happens.
 	 */
 	if (unlikely(pt->nr_entries)) {
-		struct io_poll_iocb *poll_one = poll;
+		struct io_poll_iocb *first = poll;
 
 		/* double add on the same waitqueue head, ignore */
-		if (poll_one->head == head)
+		if (first->head == head)
 			return;
 		/* already have a 2nd entry, fail a third attempt */
 		if (*poll_ptr) {
@@ -5540,25 +5598,19 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -EINVAL;
 			return;
 		}
-		/*
-		 * Can't handle multishot for double wait for now, turn it
-		 * into one-shot mode.
-		 */
-		if (!(poll_one->events & EPOLLONESHOT))
-			poll_one->events |= EPOLLONESHOT;
+
 		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
 		if (!poll) {
 			pt->error = -ENOMEM;
 			return;
 		}
-		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
-		req_ref_get(req);
-		poll->wait.private = req;
+		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
 	}
 
 	pt->nr_entries++;
 	poll->head = head;
+	poll->wait.private = req;
 
 	if (poll->events & EPOLLEXCLUSIVE)
 		add_wait_queue_exclusive(head, &poll->wait);
@@ -5566,70 +5618,24 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		add_wait_queue(head, &poll->wait);
 }
 
-static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-	struct async_poll *apoll = pt->req->apoll;
-
-	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
-}
-
-static void io_async_task_func(struct io_kiocb *req, bool *locked)
-{
-	struct async_poll *apoll = req->apoll;
-	struct io_ring_ctx *ctx = req->ctx;
-
-	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
 
-	if (io_poll_rewait(req, &apoll->poll)) {
-		spin_unlock(&ctx->completion_lock);
-		return;
-	}
-
-	hash_del(&req->hash_node);
-	io_poll_remove_double(req);
-	apoll->poll.done = true;
-	spin_unlock(&ctx->completion_lock);
-
-	if (!READ_ONCE(apoll->poll.canceled))
-		io_req_task_submit(req, locked);
-	else
-		io_req_complete_failed(req, -ECANCELED);
-}
-
-static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
-{
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = &req->apoll->poll;
-
-	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
-					key_to_poll(key));
-
-	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
+	__io_queue_proc(&pt->req->poll, pt, head,
+			(struct io_poll_iocb **) &pt->req->async_data);
 }
 
-static void io_poll_req_insert(struct io_kiocb *req)
+static int __io_arm_poll_handler(struct io_kiocb *req,
+				 struct io_poll_iocb *poll,
+				 struct io_poll_table *ipt, __poll_t mask)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
-
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
-}
-
-static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
-				      struct io_poll_iocb *poll,
-				      struct io_poll_table *ipt, __poll_t mask,
-				      wait_queue_func_t wake_func)
-	__acquires(&ctx->completion_lock)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	bool cancel = false;
+	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
-	io_init_poll_iocb(poll, mask, wake_func);
+	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 	poll->wait.private = req;
 
@@ -5638,31 +5644,56 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	ipt->error = 0;
 	ipt->nr_entries = 0;
 
+	/*
+	 * Take the ownership to delay any tw execution up until we're done
+	 * with poll arming. see io_poll_get_ownership().
+	 */
+	atomic_set(&req->poll_refs, 1);
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
-	if (unlikely(!ipt->nr_entries) && !ipt->error)
-		ipt->error = -EINVAL;
+
+	if (mask && (poll->events & EPOLLONESHOT)) {
+		io_poll_remove_entries(req);
+		/* no one else has access to the req, forget about the ref */
+		return mask;
+	}
+	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
+		io_poll_remove_entries(req);
+		if (!ipt->error)
+			ipt->error = -EINVAL;
+		return 0;
+	}
 
 	spin_lock(&ctx->completion_lock);
-	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
-		io_poll_remove_double(req);
-	if (likely(poll->head)) {
-		spin_lock_irq(&poll->head->lock);
-		if (unlikely(list_empty(&poll->wait.entry))) {
-			if (ipt->error)
-				cancel = true;
+	io_poll_req_insert(req);
+	spin_unlock(&ctx->completion_lock);
+
+	if (mask) {
+		/* can't multishot if failed, just queue the event we've got */
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
+			poll->events |= EPOLLONESHOT;
 			ipt->error = 0;
-			mask = 0;
 		}
-		if ((mask && (poll->events & EPOLLONESHOT)) || ipt->error)
-			list_del_init(&poll->wait.entry);
-		else if (cancel)
-			WRITE_ONCE(poll->canceled, true);
-		else if (!poll->done) /* actually waiting for an event */
-			io_poll_req_insert(req);
-		spin_unlock_irq(&poll->head->lock);
+		__io_poll_execute(req, mask);
+		return 0;
 	}
 
-	return mask;
+	/*
+	 * Release ownership. If someone tried to queue a tw while it was
+	 * locked, kick it off for them.
+	 */
+	v = atomic_dec_return(&req->poll_refs);
+	if (unlikely(v & IO_POLL_REF_MASK))
+		__io_poll_execute(req, 0);
+	return 0;
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
+
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
 enum {
@@ -5677,7 +5708,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	int ret;
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
@@ -5704,11 +5736,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
-	io_req_set_refcount(req);
 
-	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
-					io_async_wake);
-	spin_unlock(&ctx->completion_lock);
+	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
 	if (ret || ipt.error)
 		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
 
@@ -5717,43 +5746,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	return IO_APOLL_OK;
 }
 
-static bool __io_poll_remove_one(struct io_kiocb *req,
-				 struct io_poll_iocb *poll, bool do_cancel)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete = false;
-
-	if (!poll->head)
-		return false;
-	spin_lock_irq(&poll->head->lock);
-	if (do_cancel)
-		WRITE_ONCE(poll->canceled, true);
-	if (!list_empty(&poll->wait.entry)) {
-		list_del_init(&poll->wait.entry);
-		do_complete = true;
-	}
-	spin_unlock_irq(&poll->head->lock);
-	hash_del(&req->hash_node);
-	return do_complete;
-}
-
-static bool io_poll_remove_one(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete;
-
-	io_poll_remove_double(req);
-	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
-
-	if (do_complete) {
-		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
-		io_commit_cqring(req->ctx);
-		req_set_fail(req);
-		io_put_req_deferred(req);
-	}
-	return do_complete;
-}
-
 /*
  * Returns true if we found and killed one or more poll requests
  */
@@ -5762,7 +5754,8 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
-	int posted = 0, i;
+	bool found = false;
+	int i;
 
 	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
@@ -5770,16 +5763,15 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task_safe(req, tsk, cancel_all))
-				posted += io_poll_remove_one(req);
+			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
+				io_poll_cancel_req(req);
+				found = true;
+			}
 		}
 	}
 	spin_unlock(&ctx->completion_lock);
-
-	if (posted)
-		io_cqring_ev_posted(ctx);
-
-	return posted != 0;
+	return found;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
@@ -5800,19 +5792,26 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
 	return NULL;
 }
 
+static bool io_poll_disarm(struct io_kiocb *req)
+	__must_hold(&ctx->completion_lock)
+{
+	if (!io_poll_get_ownership(req))
+		return false;
+	io_poll_remove_entries(req);
+	hash_del(&req->hash_node);
+	return true;
+}
+
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
 			  bool poll_only)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req;
+	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
 
-	req = io_poll_find(ctx, sqe_addr, poll_only);
 	if (!req)
 		return -ENOENT;
-	if (io_poll_remove_one(req))
-		return 0;
-
-	return -EALREADY;
+	io_poll_cancel_req(req);
+	return 0;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
@@ -5862,23 +5861,6 @@ static int io_poll_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
-{
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = &req->poll;
-
-	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
-}
-
-static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-
-	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
-}
-
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
@@ -5900,90 +5882,57 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
-	__poll_t mask;
-	bool done;
+	int ret;
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
-	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
-					io_poll_wake);
-
-	if (mask) { /* no async, we'd stolen it */
-		ipt.error = 0;
-		done = io_poll_complete(req, mask);
-	}
-	spin_unlock(&ctx->completion_lock);
-
-	if (mask) {
-		io_cqring_ev_posted(ctx);
-		if (done)
-			io_put_req(req);
-	}
-	return ipt.error;
+	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
+	ret = ret ?: ipt.error;
+	if (ret)
+		__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
 }
 
 static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
-	bool completing;
-	int ret;
+	int ret2, ret = 0;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
-	if (!preq) {
-		ret = -ENOENT;
-		goto err;
+	if (!preq || !io_poll_disarm(preq)) {
+		spin_unlock(&ctx->completion_lock);
+		ret = preq ? -EALREADY : -ENOENT;
+		goto out;
 	}
+	spin_unlock(&ctx->completion_lock);
 
-	if (!req->poll_update.update_events && !req->poll_update.update_user_data) {
-		completing = true;
-		ret = io_poll_remove_one(preq) ? 0 : -EALREADY;
-		goto err;
-	}
+	if (req->poll_update.update_events || req->poll_update.update_user_data) {
+		/* only mask one event flags, keep behavior flags */
+		if (req->poll_update.update_events) {
+			preq->poll.events &= ~0xffff;
+			preq->poll.events |= req->poll_update.events & 0xffff;
+			preq->poll.events |= IO_POLL_UNMASK;
+		}
+		if (req->poll_update.update_user_data)
+			preq->user_data = req->poll_update.new_user_data;
 
-	/*
-	 * Don't allow racy completion with singleshot, as we cannot safely
-	 * update those. For multishot, if we're racing with completion, just
-	 * let completion re-add it.
-	 */
-	io_poll_remove_double(preq);
-	completing = !__io_poll_remove_one(preq, &preq->poll, false);
-	if (completing && (preq->poll.events & EPOLLONESHOT)) {
-		ret = -EALREADY;
-		goto err;
+		ret2 = io_poll_add(preq, issue_flags);
+		/* successfully updated, don't complete poll request */
+		if (!ret2)
+			goto out;
 	}
-	/* we now have a detached poll request. reissue. */
-	ret = 0;
-err:
-	if (ret < 0) {
-		spin_unlock(&ctx->completion_lock);
+	req_set_fail(preq);
+	io_req_complete(preq, -ECANCELED);
+out:
+	if (ret < 0)
 		req_set_fail(req);
-		io_req_complete(req, ret);
-		return 0;
-	}
-	/* only mask one event flags, keep behavior flags */
-	if (req->poll_update.update_events) {
-		preq->poll.events &= ~0xffff;
-		preq->poll.events |= req->poll_update.events & 0xffff;
-		preq->poll.events |= IO_POLL_UNMASK;
-	}
-	if (req->poll_update.update_user_data)
-		preq->user_data = req->poll_update.new_user_data;
-	spin_unlock(&ctx->completion_lock);
-
 	/* complete update request, we're done with it */
 	io_req_complete(req, ret);
-
-	if (!completing) {
-		ret = io_poll_add(preq, issue_flags);
-		if (ret < 0) {
-			req_set_fail(preq);
-			io_req_complete(preq, ret);
-		}
-	}
 	return 0;
 }
 
@@ -6045,7 +5994,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 		return PTR_ERR(req);
 
 	req_set_fail(req);
-	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
+	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
 	return 0;
 }
@@ -8271,8 +8220,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock(&ctx->completion_lock);
-			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
-			ctx->cq_extra++;
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index 0d28e723a28c..940385c6a913 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -18,7 +18,7 @@
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name)
 {
-	struct ksmbd_tree_conn_status status = {-EINVAL, NULL};
+	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
 	struct ksmbd_share_config *sc;
 	struct ksmbd_tree_connect *tree_conn = NULL;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 28b5d20c8766..55ee639703ff 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1932,8 +1932,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_SUCCESS;
 		rc = 0;
 		break;
+	case -ENOENT:
 	case KSMBD_TREE_CONN_STATUS_NO_SHARE:
-		rsp->hdr.Status = STATUS_BAD_NETWORK_PATH;
+		rsp->hdr.Status = STATUS_BAD_NETWORK_NAME;
 		break;
 	case -ENOMEM:
 	case KSMBD_TREE_CONN_STATUS_NOMEM:
@@ -2318,15 +2319,15 @@ static int smb2_remove_smb_xattrs(struct path *path)
 			name += strlen(name) + 1) {
 		ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
 
-		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], DOS_ATTRIBUTE_PREFIX,
-			    DOS_ATTRIBUTE_PREFIX_LEN) &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX, STREAM_PREFIX_LEN))
-			continue;
-
-		err = ksmbd_vfs_remove_xattr(user_ns, path->dentry, name);
-		if (err)
-			ksmbd_debug(SMB, "remove xattr failed : %s\n", name);
+		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
+		    !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
+			     STREAM_PREFIX_LEN)) {
+			err = ksmbd_vfs_remove_xattr(user_ns, path->dentry,
+						     name);
+			if (err)
+				ksmbd_debug(SMB, "remove xattr failed : %s\n",
+					    name);
+		}
 	}
 out:
 	kvfree(xattr_list);
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index e8bfa709270d..4652b9796995 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -118,7 +118,7 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 
 		run_init(&run);
 
-		err = attr_load_runs(attr_ea, ni, &run, NULL);
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &run, 0, size);
 		if (!err)
 			err = ntfs_read_run_nb(sbi, &run, 0, ea_p, size, NULL);
 		run_close(&run);
@@ -443,6 +443,11 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 		/* Delete xattr, ATTR_EA */
 		ni_remove_attr_le(ni, attr, mi, le);
 	} else if (attr->non_res) {
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &ea_run, 0,
+					   size);
+		if (err)
+			goto out;
+
 		err = ntfs_sb_write_run(sbi, &ea_run, 0, ea_all, size, 0);
 		if (err)
 			goto out;
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 9cdbd209388e..1648ce265cba 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -911,9 +911,20 @@ struct drm_bridge *devm_drm_panel_bridge_add(struct device *dev,
 struct drm_bridge *devm_drm_panel_bridge_add_typed(struct device *dev,
 						   struct drm_panel *panel,
 						   u32 connector_type);
+struct drm_connector *drm_panel_bridge_connector(struct drm_bridge *bridge);
+#endif
+
+#if defined(CONFIG_OF) && defined(CONFIG_DRM_PANEL_BRIDGE)
 struct drm_bridge *devm_drm_of_get_bridge(struct device *dev, struct device_node *node,
 					  u32 port, u32 endpoint);
-struct drm_connector *drm_panel_bridge_connector(struct drm_bridge *bridge);
+#else
+static inline struct drm_bridge *devm_drm_of_get_bridge(struct device *dev,
+							struct device_node *node,
+							u32 port,
+							u32 endpoint)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif
 
 #endif
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index c976cc6de257..c29d9c13378b 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -39,12 +39,15 @@ struct anon_vma {
 	atomic_t refcount;
 
 	/*
-	 * Count of child anon_vmas and VMAs which points to this anon_vma.
+	 * Count of child anon_vmas. Equals to the count of all anon_vmas that
+	 * have ->parent pointing to this one, including itself.
 	 *
 	 * This counter is used for making decision about reusing anon_vma
 	 * instead of forking new one. See comments in function anon_vma_clone.
 	 */
-	unsigned degree;
+	unsigned long num_children;
+	/* Count of VMAs whose ->anon_vma pointer points to this object. */
+	unsigned long num_active_vmas;
 
 	struct anon_vma *parent;	/* Parent of this anon_vma */
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index cbd719e5329a..ae598ed86b50 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2328,6 +2328,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
 
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_assert_len(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+	if (WARN_ONCE(!skb->len, "%s\n", __func__))
+		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
+#endif /* CONFIG_DEBUG_NET */
+}
+
 /*
  *	Add data to an sk_buff
  */
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 73bedd128d52..0c742cdf413c 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -283,7 +283,8 @@ static inline void sk_msg_sg_copy_clear(struct sk_msg *msg, u32 start)
 
 static inline struct sk_psock *sk_psock(const struct sock *sk)
 {
-	return rcu_dereference_sk_user_data(sk);
+	return __rcu_dereference_sk_user_data_with_flags(sk,
+							 SK_USER_DATA_PSOCK);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 49a6315d521f..cb1a1bb64ed8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -543,14 +543,26 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
-/* Pointer stored in sk_user_data might not be suitable for copying
- * when cloning the socket. For instance, it can point to a reference
- * counted object. sk_user_data bottom bit is set if pointer must not
- * be copied.
+/* flag bits in sk_user_data
+ *
+ * - SK_USER_DATA_NOCOPY:      Pointer stored in sk_user_data might
+ *   not be suitable for copying when cloning the socket. For instance,
+ *   it can point to a reference counted object. sk_user_data bottom
+ *   bit is set if pointer must not be copied.
+ *
+ * - SK_USER_DATA_BPF:         Mark whether sk_user_data field is
+ *   managed/owned by a BPF reuseport array. This bit should be set
+ *   when sk_user_data's sk is added to the bpf's reuseport_array.
+ *
+ * - SK_USER_DATA_PSOCK:       Mark whether pointer stored in
+ *   sk_user_data points to psock type. This bit should be set
+ *   when sk_user_data is assigned to a psock object.
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
+#define SK_USER_DATA_BPF	2UL
+#define SK_USER_DATA_PSOCK	4UL
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF |\
+				  SK_USER_DATA_PSOCK)
 
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
@@ -563,24 +575,40 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
+/**
+ * __rcu_dereference_sk_user_data_with_flags - return the pointer
+ * only if argument flags all has been set in sk_user_data. Otherwise
+ * return NULL
+ *
+ * @sk: socket
+ * @flags: flag bits
+ */
+static inline void *
+__rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
+					  uintptr_t flags)
+{
+	uintptr_t sk_user_data = (uintptr_t)rcu_dereference(__sk_user_data(sk));
+
+	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
+
+	if ((sk_user_data & flags) == flags)
+		return (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
+	return NULL;
+}
+
 #define rcu_dereference_sk_user_data(sk)				\
+	__rcu_dereference_sk_user_data_with_flags(sk, 0)
+#define __rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\
 ({									\
-	void *__tmp = rcu_dereference(__sk_user_data((sk)));		\
-	(void *)((uintptr_t)__tmp & SK_USER_DATA_PTRMASK);		\
-})
-#define rcu_assign_sk_user_data(sk, ptr)				\
-({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
-	rcu_assign_pointer(__sk_user_data((sk)), __tmp);		\
-})
-#define rcu_assign_sk_user_data_nocopy(sk, ptr)				\
-({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
+	uintptr_t __tmp1 = (uintptr_t)(ptr),				\
+		  __tmp2 = (uintptr_t)(flags);				\
+	WARN_ON_ONCE(__tmp1 & ~SK_USER_DATA_PTRMASK);			\
+	WARN_ON_ONCE(__tmp2 & SK_USER_DATA_PTRMASK);			\
 	rcu_assign_pointer(__sk_user_data((sk)),			\
-			   __tmp | SK_USER_DATA_NOCOPY);		\
+			   __tmp1 | __tmp2);				\
 })
+#define rcu_assign_sk_user_data(sk, ptr)				\
+	__rcu_assign_sk_user_data_with_flags(sk, ptr, 0)
 
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index e1c4c732aaba..5416f1f1a77a 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -146,7 +146,9 @@
 
 /*
  * dir items are the name -> inode pointers in a directory.  There is one
- * for every name in a directory.
+ * for every name in a directory.  BTRFS_DIR_LOG_ITEM_KEY is no longer used
+ * but it's still defined here for documentation purposes and to help avoid
+ * having its numerical value reused in the future.
  */
 #define BTRFS_DIR_LOG_ITEM_KEY  60
 #define BTRFS_DIR_LOG_INDEX_KEY 72
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3a3c0166bd1f..ed3f24a81549 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1705,11 +1705,12 @@ static struct kprobe *__disable_kprobe(struct kprobe *p)
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
 			/*
-			 * If kprobes_all_disarmed is set, orig_p
-			 * should have already been disarmed, so
-			 * skip unneed disarming process.
+			 * Don't be lazy here.  Even if 'kprobes_all_disarmed'
+			 * is false, 'orig_p' might not have been armed yet.
+			 * Note arm_all_kprobes() __tries__ to arm all kprobes
+			 * on the best effort basis.
 			 */
-			if (!kprobes_all_disarmed) {
+			if (!kprobes_all_disarmed && !kprobe_disabled(orig_p)) {
 				ret = disarm_kprobe(orig_p, true);
 				if (ret) {
 					p->flags &= ~KPROBE_FLAG_DISABLED;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e215a9c96971..e10cf1b54812 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2901,6 +2901,16 @@ int ftrace_startup(struct ftrace_ops *ops, int command)
 
 	ftrace_startup_enable(command);
 
+	/*
+	 * If ftrace is in an undefined state, we just remove ops from list
+	 * to prevent the NULL pointer, instead of totally rolling it back and
+	 * free trampoline, because those actions could cause further damage.
+	 */
+	if (unlikely(ftrace_disabled)) {
+		__unregister_ftrace_function(ops);
+		return -ENODEV;
+	}
+
 	ops->flags &= ~FTRACE_OPS_FL_ADDING;
 
 	return 0;
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 5056663c2aff..a29eff4f969e 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -33,7 +33,6 @@ config CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
-	select XOR_BLOCKS
 	help
 	  This symbol can be depended upon by arch implementations of the
 	  ChaCha library interface that require the generic code as a
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 405793b8cf0d..d61b665c45d6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5371,7 +5371,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);
diff --git a/mm/mmap.c b/mm/mmap.c
index b63336f6984c..cd1d2680ac58 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2643,6 +2643,18 @@ static void unmap_region(struct mm_struct *mm,
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
+
+	/*
+	 * Ensure we have no stale TLB entries by the time this mapping is
+	 * removed from the rmap.
+	 * Note that we don't have to worry about nested flushes here because
+	 * we're holding the mm semaphore for removing the mapping - so any
+	 * concurrent flush in this region has to be coming through the rmap,
+	 * and we synchronize against that using the rmap lock.
+	 */
+	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
+		tlb_flush_mmu(&tlb);
+
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
diff --git a/mm/rmap.c b/mm/rmap.c
index 3e340ee380cb..330b361a460e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -90,7 +90,8 @@ static inline struct anon_vma *anon_vma_alloc(void)
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
 		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->degree = 1;	/* Reference for first vma */
+		anon_vma->num_children = 0;
+		anon_vma->num_active_vmas = 0;
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -198,6 +199,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 		anon_vma = anon_vma_alloc();
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
+		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
 	}
 
@@ -207,8 +209,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_link(vma, avc, anon_vma);
-		/* vma reference or self-parent link for new root */
-		anon_vma->degree++;
+		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
 	}
@@ -293,19 +294,19 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
-		 * Reuse existing anon_vma if its degree lower than two,
-		 * that means it has no vma and only one anon_vma child.
+		 * Reuse existing anon_vma if it has no vma and only one
+		 * anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
-		 * will always reuse it. Root anon_vma is never reused:
+		 * Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
 		if (!dst->anon_vma && src->anon_vma &&
-		    anon_vma != src->anon_vma && anon_vma->degree < 2)
+		    anon_vma->num_children < 2 &&
+		    anon_vma->num_active_vmas == 0)
 			dst->anon_vma = anon_vma;
 	}
 	if (dst->anon_vma)
-		dst->anon_vma->degree++;
+		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
 
@@ -355,6 +356,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma = anon_vma_alloc();
 	if (!anon_vma)
 		goto out_error;
+	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
@@ -375,7 +377,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->degree++;
+	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
@@ -407,7 +409,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		 * to free them outside the lock.
 		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root.rb_root)) {
-			anon_vma->parent->degree--;
+			anon_vma->parent->num_children--;
 			continue;
 		}
 
@@ -415,7 +417,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma) {
-		vma->anon_vma->degree--;
+		vma->anon_vma->num_active_vmas--;
 
 		/*
 		 * vma would still be needed after unlink, and anon_vma will be prepared
@@ -433,7 +435,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		VM_WARN_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->num_children);
+		VM_WARN_ON(anon_vma->num_active_vmas);
 		put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a0e0c2bdbb49..e8de1e7d6ff4 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1992,11 +1992,11 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				c = l2cap_chan_hold_unless_zero(c);
-				if (c) {
-					read_unlock(&chan_list_lock);
-					return c;
-				}
+				if (!l2cap_chan_hold_unless_zero(c))
+					continue;
+
+				read_unlock(&chan_list_lock);
+				return c;
 			}
 
 			/* Closest match */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 655ee0e2de86..a9fb16b9c735 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -469,6 +469,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
+	if (!skb->len)
+		return -EINVAL;
+
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 276cca563325..be51644e95da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4147,6 +4147,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	bool again = false;
 
 	skb_reset_mac_header(skb);
+	skb_assert_len(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ff049733ccee..b3556c5c1c08 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -279,11 +279,26 @@ static int neigh_del_timer(struct neighbour *n)
 	return 0;
 }
 
-static void pneigh_queue_purge(struct sk_buff_head *list)
+static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 {
+	struct sk_buff_head tmp;
+	unsigned long flags;
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(list)) != NULL) {
+	skb_queue_head_init(&tmp);
+	spin_lock_irqsave(&list->lock, flags);
+	skb = skb_peek(list);
+	while (skb != NULL) {
+		struct sk_buff *skb_next = skb_peek_next(skb, list);
+		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
+			__skb_unlink(skb, list);
+			__skb_queue_tail(&tmp, skb);
+		}
+		skb = skb_next;
+	}
+	spin_unlock_irqrestore(&list->lock, flags);
+
+	while ((skb = __skb_dequeue(&tmp))) {
 		dev_put(skb->dev);
 		kfree_skb(skb);
 	}
@@ -357,9 +372,9 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
 	pneigh_ifdown_and_unlock(tbl, dev);
-
-	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
+	if (skb_queue_empty_lockless(&tbl->proxy_queue))
+		del_timer_sync(&tbl->proxy_timer);
 	return 0;
 }
 
@@ -1735,7 +1750,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	/* It is not clean... Fix it to unload IPv6 module safely */
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
-	pneigh_queue_purge(&tbl->proxy_queue);
+	pneigh_queue_purge(&tbl->proxy_queue, NULL);
 	neigh_ifdown(tbl, NULL);
 	if (atomic_read(&tbl->entries))
 		pr_crit("neighbour leakage\n");
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f50f8d95b628..4ddcfac34498 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -731,7 +731,9 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
 	refcount_set(&psock->refcnt, 1);
 
-	rcu_assign_sk_user_data_nocopy(sk, psock);
+	__rcu_assign_sk_user_data_with_flags(sk, psock,
+					     SK_USER_DATA_NOCOPY |
+					     SK_USER_DATA_PSOCK);
 	sock_hold(sk);
 
 out:
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 92a747896f80..4f645d51c257 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -133,7 +133,6 @@ config NF_CONNTRACK_ZONES
 
 config NF_CONNTRACK_PROCFS
 	bool "Supply CT list in procfs (OBSOLETE)"
-	default y
 	depends on PROC_FS
 	help
 	This option enables for the list of known conntrack entries
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 88c3b5cf8d94..968dac3fcf58 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2989,8 +2989,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (err)
 		goto out_free;
 
-	if (sock->type == SOCK_RAW &&
-	    !dev_validate_header(dev, skb->data, len)) {
+	if ((sock->type == SOCK_RAW &&
+	     !dev_validate_header(dev, skb->data, len)) || !skb->len) {
 		err = -EINVAL;
 		goto out_free;
 	}
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 48585c4d04ad..0273bf7375e2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -87,8 +87,7 @@ obj := $(KBUILD_EXTMOD)
 src := $(obj)
 
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
-include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
-             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
 
 # modpost option for external modules
 MODPOST += -e
diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 6d794eaaf4c3..2e33a1fa0a6f 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -1022,32 +1022,36 @@ static int rz_ssi_probe(struct platform_device *pdev)
 
 	ssi->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 	if (IS_ERR(ssi->rstc)) {
-		rz_ssi_release_dma_channels(ssi);
-		return PTR_ERR(ssi->rstc);
+		ret = PTR_ERR(ssi->rstc);
+		goto err_reset;
 	}
 
 	reset_control_deassert(ssi->rstc);
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
-		rz_ssi_release_dma_channels(ssi);
-		pm_runtime_disable(ssi->dev);
-		reset_control_assert(ssi->rstc);
-		return dev_err_probe(ssi->dev, ret, "pm_runtime_resume_and_get failed\n");
+		dev_err(&pdev->dev, "pm_runtime_resume_and_get failed\n");
+		goto err_pm;
 	}
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &rz_ssi_soc_component,
 					      rz_ssi_soc_dai,
 					      ARRAY_SIZE(rz_ssi_soc_dai));
 	if (ret < 0) {
-		rz_ssi_release_dma_channels(ssi);
-
-		pm_runtime_put(ssi->dev);
-		pm_runtime_disable(ssi->dev);
-		reset_control_assert(ssi->rstc);
 		dev_err(&pdev->dev, "failed to register snd component\n");
+		goto err_snd_soc;
 	}
 
+	return 0;
+
+err_snd_soc:
+	pm_runtime_put(ssi->dev);
+err_pm:
+	pm_runtime_disable(ssi->dev);
+	reset_control_assert(ssi->rstc);
+err_reset:
+	rz_ssi_release_dma_channels(ssi);
+
 	return ret;
 }
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 168fd802d70b..9bfead5efc4c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1903,6 +1903,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
+		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d4ffebb989f8..c336e6c148d1 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -14,6 +14,11 @@
 # nft_flowtable.sh -o8000 -l1500 -r2000
 #
 
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+nsr1="nsr1-$sfx"
+nsr2="nsr2-$sfx"
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -36,18 +41,17 @@ checktool (){
 checktool "nft --version" "run test without nft tool"
 checktool "ip -Version" "run test without ip tool"
 checktool "which nc" "run test without nc (netcat)"
-checktool "ip netns add nsr1" "create net namespace"
+checktool "ip netns add $nsr1" "create net namespace $nsr1"
 
-ip netns add ns1
-ip netns add ns2
-
-ip netns add nsr2
+ip netns add $ns1
+ip netns add $ns2
+ip netns add $nsr2
 
 cleanup() {
-	for i in 1 2; do
-		ip netns del ns$i
-		ip netns del nsr$i
-	done
+	ip netns del $ns1
+	ip netns del $ns2
+	ip netns del $nsr1
+	ip netns del $nsr2
 
 	rm -f "$ns1in" "$ns1out"
 	rm -f "$ns2in" "$ns2out"
@@ -59,22 +63,21 @@ trap cleanup EXIT
 
 sysctl -q net.netfilter.nf_log_all_netns=1
 
-ip link add veth0 netns nsr1 type veth peer name eth0 netns ns1
-ip link add veth1 netns nsr1 type veth peer name veth0 netns nsr2
+ip link add veth0 netns $nsr1 type veth peer name eth0 netns $ns1
+ip link add veth1 netns $nsr1 type veth peer name veth0 netns $nsr2
 
-ip link add veth1 netns nsr2 type veth peer name eth0 netns ns2
+ip link add veth1 netns $nsr2 type veth peer name eth0 netns $ns2
 
 for dev in lo veth0 veth1; do
-  for i in 1 2; do
-    ip -net nsr$i link set $dev up
-  done
+    ip -net $nsr1 link set $dev up
+    ip -net $nsr2 link set $dev up
 done
 
-ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net nsr1 addr add dead:1::1/64 dev veth0
+ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net $nsr1 addr add dead:1::1/64 dev veth0
 
-ip -net nsr2 addr add 10.0.2.1/24 dev veth1
-ip -net nsr2 addr add dead:2::1/64 dev veth1
+ip -net $nsr2 addr add 10.0.2.1/24 dev veth1
+ip -net $nsr2 addr add dead:2::1/64 dev veth1
 
 # set different MTUs so we need to push packets coming from ns1 (large MTU)
 # to ns2 (smaller MTU) to stack either to perform fragmentation (ip_no_pmtu_disc=1),
@@ -106,49 +109,56 @@ do
 	esac
 done
 
-if ! ip -net nsr1 link set veth0 mtu $omtu; then
+if ! ip -net $nsr1 link set veth0 mtu $omtu; then
 	exit 1
 fi
 
-ip -net ns1 link set eth0 mtu $omtu
+ip -net $ns1 link set eth0 mtu $omtu
 
-if ! ip -net nsr2 link set veth1 mtu $rmtu; then
+if ! ip -net $nsr2 link set veth1 mtu $rmtu; then
 	exit 1
 fi
 
-ip -net ns2 link set eth0 mtu $rmtu
+ip -net $ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
-ip -net nsr1 addr add 192.168.10.1/24 dev veth1
-ip -net nsr1 addr add fee1:2::1/64 dev veth1
-
-ip -net nsr2 addr add 192.168.10.2/24 dev veth0
-ip -net nsr2 addr add fee1:2::2/64 dev veth0
-
-for i in 1 2; do
-  ip netns exec nsr$i sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
-  ip netns exec nsr$i sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
-
-  ip -net ns$i link set lo up
-  ip -net ns$i link set eth0 up
-  ip -net ns$i addr add 10.0.$i.99/24 dev eth0
-  ip -net ns$i route add default via 10.0.$i.1
-  ip -net ns$i addr add dead:$i::99/64 dev eth0
-  ip -net ns$i route add default via dead:$i::1
-  if ! ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
+ip -net $nsr1 addr add 192.168.10.1/24 dev veth1
+ip -net $nsr1 addr add fee1:2::1/64 dev veth1
+
+ip -net $nsr2 addr add 192.168.10.2/24 dev veth0
+ip -net $nsr2 addr add fee1:2::2/64 dev veth0
+
+for i in 0 1; do
+  ip netns exec $nsr1 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+  ip netns exec $nsr2 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+done
+
+for ns in $ns1 $ns2;do
+  ip -net $ns link set lo up
+  ip -net $ns link set eth0 up
+
+  if ! ip netns exec $ns sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
 	echo "ERROR: Check Originator/Responder values (problem during address addition)"
 	exit 1
   fi
-
   # don't set ip DF bit for first two tests
-  ip netns exec ns$i sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
+  ip netns exec $ns sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
 done
 
-ip -net nsr1 route add default via 192.168.10.2
-ip -net nsr2 route add default via 192.168.10.1
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0
+ip -net $ns2 addr add 10.0.2.99/24 dev eth0
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns2 route add default via 10.0.2.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0
+ip -net $ns2 addr add dead:2::99/64 dev eth0
+ip -net $ns1 route add default via dead:1::1
+ip -net $ns2 route add default via dead:2::1
+
+ip -net $nsr1 route add default via 192.168.10.2
+ip -net $nsr2 route add default via 192.168.10.1
 
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 table inet filter {
   flowtable f1 {
      hook ingress priority 0
@@ -197,18 +207,18 @@ if [ $? -ne 0 ]; then
 fi
 
 # test basic connectivity
-if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
-  echo "ERROR: ns1 cannot reach ns2" 1>&2
+if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
+  echo "ERROR: $ns1 cannot reach ns2" 1>&2
   exit 1
 fi
 
-if ! ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
-  echo "ERROR: ns2 cannot reach ns1" 1>&2
+if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
+  echo "ERROR: $ns2 cannot reach $ns1" 1>&2
   exit 1
 fi
 
 if [ $ret -eq 0 ];then
-	echo "PASS: netns routing/connectivity: ns1 can reach ns2"
+	echo "PASS: netns routing/connectivity: $ns1 can reach $ns2"
 fi
 
 ns1in=$(mktemp)
@@ -312,24 +322,24 @@ make_file "$ns2in"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
-if test_tcp_forwarding ns1 ns2; then
+if test_tcp_forwarding $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
-ip -net ns2 route del default via 10.0.2.1
-ip -net ns2 route del default via dead:2::1
-ip -net ns2 route add 192.168.10.1 via 10.0.2.1
+ip -net $ns2 route del default via 10.0.2.1
+ip -net $ns2 route del default via dead:2::1
+ip -net $ns2 route add 192.168.10.1 via 10.0.2.1
 
 # Second test:
 # Same, but with NAT enabled.
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 table ip nat {
    chain prerouting {
       type nat hook prerouting priority 0; policy accept;
@@ -343,47 +353,47 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # Third test:
 # Same as second test, but with PMTU discovery enabled.
-handle=$(ip netns exec nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
+handle=$(ip netns exec $nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
 
-if ! ip netns exec nsr1 nft delete rule inet filter forward $handle; then
+if ! ip netns exec $nsr1 nft delete rule inet filter forward $handle; then
 	echo "FAIL: Could not delete large-packet accept rule"
 	exit 1
 fi
 
-ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
-ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec $ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec $ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 fi
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT enabled.
-ip -net nsr1 link add name br0 type bridge
-ip -net nsr1 addr flush dev veth0
-ip -net nsr1 link set up dev veth0
-ip -net nsr1 link set veth0 master br0
-ip -net nsr1 addr add 10.0.1.1/24 dev br0
-ip -net nsr1 addr add dead:1::1/64 dev br0
-ip -net nsr1 link set up dev br0
+ip -net $nsr1 link add name br0 type bridge
+ip -net $nsr1 addr flush dev veth0
+ip -net $nsr1 link set up dev veth0
+ip -net $nsr1 link set veth0 master br0
+ip -net $nsr1 addr add 10.0.1.1/24 dev br0
+ip -net $nsr1 addr add dead:1::1/64 dev br0
+ip -net $nsr1 link set up dev br0
 
-ip netns exec nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
+ip netns exec $nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
 
 # br0 with NAT enabled.
-ip netns exec nsr1 nft -f - <<EOF
+ip netns exec $nsr1 nft -f - <<EOF
 flush table ip nat
 table ip nat {
    chain prerouting {
@@ -398,59 +408,59 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat ns1 ns2; then
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT and VLAN.
-ip -net nsr1 link set veth0 nomaster
-ip -net nsr1 link set down dev veth0
-ip -net nsr1 link add link veth0 name veth0.10 type vlan id 10
-ip -net nsr1 link set up dev veth0
-ip -net nsr1 link set up dev veth0.10
-ip -net nsr1 link set veth0.10 master br0
-
-ip -net ns1 addr flush dev eth0
-ip -net ns1 link add link eth0 name eth0.10 type vlan id 10
-ip -net ns1 link set eth0 up
-ip -net ns1 link set eth0.10 up
-ip -net ns1 addr add 10.0.1.99/24 dev eth0.10
-ip -net ns1 route add default via 10.0.1.1
-ip -net ns1 addr add dead:1::99/64 dev eth0.10
-
-if test_tcp_forwarding_nat ns1 ns2; then
+ip -net $nsr1 link set veth0 nomaster
+ip -net $nsr1 link set down dev veth0
+ip -net $nsr1 link add link veth0 name veth0.10 type vlan id 10
+ip -net $nsr1 link set up dev veth0
+ip -net $nsr1 link set up dev veth0.10
+ip -net $nsr1 link set veth0.10 master br0
+
+ip -net $ns1 addr flush dev eth0
+ip -net $ns1 link add link eth0 name eth0.10 type vlan id 10
+ip -net $ns1 link set eth0 up
+ip -net $ns1 link set eth0.10 up
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0.10
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0.10
+
+if test_tcp_forwarding_nat $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT and VLAN"
 else
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
-	ip netns exec nsr1 nft list ruleset
+	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # restore test topology (remove bridge and VLAN)
-ip -net nsr1 link set veth0 nomaster
-ip -net nsr1 link set veth0 down
-ip -net nsr1 link set veth0.10 down
-ip -net nsr1 link delete veth0.10 type vlan
-ip -net nsr1 link delete br0 type bridge
-ip -net ns1 addr flush dev eth0.10
-ip -net ns1 link set eth0.10 down
-ip -net ns1 link set eth0 down
-ip -net ns1 link delete eth0.10 type vlan
+ip -net $nsr1 link set veth0 nomaster
+ip -net $nsr1 link set veth0 down
+ip -net $nsr1 link set veth0.10 down
+ip -net $nsr1 link delete veth0.10 type vlan
+ip -net $nsr1 link delete br0 type bridge
+ip -net $ns1 addr flush dev eth0.10
+ip -net $ns1 link set eth0.10 down
+ip -net $ns1 link set eth0 down
+ip -net $ns1 link delete eth0.10 type vlan
 
 # restore address in ns1 and nsr1
-ip -net ns1 link set eth0 up
-ip -net ns1 addr add 10.0.1.99/24 dev eth0
-ip -net ns1 route add default via 10.0.1.1
-ip -net ns1 addr add dead:1::99/64 dev eth0
-ip -net ns1 route add default via dead:1::1
-ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net nsr1 addr add dead:1::1/64 dev veth0
-ip -net nsr1 link set up dev veth0
+ip -net $ns1 link set eth0 up
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns1 addr add dead:1::99/64 dev eth0
+ip -net $ns1 route add default via dead:1::1
+ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net $nsr1 addr add dead:1::1/64 dev veth0
+ip -net $nsr1 link set up dev veth0
 
 KEY_SHA="0x"$(ps -xaf | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -xaf | md5sum | cut -d " " -f 1)
@@ -480,23 +490,23 @@ do_esp() {
 
 }
 
-do_esp nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
+do_esp $nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
 
-do_esp nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
+do_esp $nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
 
-ip netns exec nsr1 nft delete table ip nat
+ip netns exec $nsr1 nft delete table ip nat
 
 # restore default routes
-ip -net ns2 route del 192.168.10.1 via 10.0.2.1
-ip -net ns2 route add default via 10.0.2.1
-ip -net ns2 route add default via dead:2::1
+ip -net $ns2 route del 192.168.10.1 via 10.0.2.1
+ip -net $ns2 route add default via 10.0.2.1
+ip -net $ns2 route add default via dead:2::1
 
-if test_tcp_forwarding ns1 ns2; then
+if test_tcp_forwarding $ns1 $ns2; then
 	echo "PASS: ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-	ip netns exec nsr1 nft list ruleset 1>&2
-	ip netns exec nsr1 cat /proc/net/xfrm_stat 1>&2
+	ip netns exec $nsr1 nft list ruleset 1>&2
+	ip netns exec $nsr1 cat /proc/net/xfrm_stat 1>&2
 fi
 
 exit $ret
