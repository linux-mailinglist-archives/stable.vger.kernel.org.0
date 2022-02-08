Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80494AE00B
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384562AbiBHRzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384531AbiBHRzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:55:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76AC0610C5;
        Tue,  8 Feb 2022 09:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C2E617EA;
        Tue,  8 Feb 2022 17:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E321C004E1;
        Tue,  8 Feb 2022 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342926;
        bh=hYt7VyAU1GEUNNofc7O36cecEpDnA+A7tO29P7zREgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEBGk7+Qi6pH+/diiWg/WJ94+wdoE2z/CsPExWm7ePQIe6a2b2ksbGQHIA61wwk1Z
         Gf9ZRjfLPA5xoIMAw6FwuIrxICw7B9R19yRbA8NA1ltlJzs2AnKM6iEGeiBO/d9SVr
         GYz1qNYB3b7XxeekAArdqjEpgzTTizYzLxl7FnQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.22
Date:   Tue,  8 Feb 2022 18:55:09 +0100
Message-Id: <164434290818191@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16443429086762@kroah.com>
References: <16443429086762@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index 12e61869939e..67de1e94fdf7 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -311,27 +311,6 @@ Contact: Daniel Vetter, Noralf Tronnes
 
 Level: Advanced
 
-Garbage collect fbdev scrolling acceleration
---------------------------------------------
-
-Scroll acceleration is disabled in fbcon by hard-wiring p->scrollmode =
-SCROLL_REDRAW. There's a ton of code this will allow us to remove:
-
-- lots of code in fbcon.c
-
-- a bunch of the hooks in fbcon_ops, maybe the remaining hooks could be called
-  directly instead of the function table (with a switch on p->rotate)
-
-- fb_copyarea is unused after this, and can be deleted from all drivers
-
-Note that not all acceleration code can be deleted, since clearing and cursor
-support is still accelerated, which might be good candidates for further
-deletion projects.
-
-Contact: Daniel Vetter
-
-Level: Intermediate
-
 idr_init_base()
 ---------------
 
diff --git a/Makefile b/Makefile
index b4770cdda9b6..5bddd6195484 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 21
+SUBLEVEL = 22
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9b328bb05596..f9c7e4e61b29 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -755,6 +755,24 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 			xfer_to_guest_mode_work_pending();
 }
 
+/*
+ * Actually run the vCPU, entering an RCU extended quiescent state (EQS) while
+ * the vCPU is running.
+ *
+ * This must be noinstr as instrumentation may make use of RCU, and this is not
+ * safe during the EQS.
+ */
+static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	guest_state_enter_irqoff();
+	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
+	guest_state_exit_irqoff();
+
+	return ret;
+}
+
 /**
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
@@ -845,9 +863,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Enter the guest
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
-		guest_enter_irqoff();
+		guest_timing_enter_irqoff();
 
-		ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
+		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
@@ -882,26 +900,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
 		/*
-		 * We may have taken a host interrupt in HYP mode (ie
-		 * while executing the guest). This interrupt is still
-		 * pending, as we haven't serviced it yet!
+		 * We must ensure that any pending interrupts are taken before
+		 * we exit guest timing so that timer ticks are accounted as
+		 * guest time. Transiently unmask interrupts so that any
+		 * pending interrupts are taken.
 		 *
-		 * We're now back in SVC mode, with interrupts
-		 * disabled.  Enabling the interrupts now will have
-		 * the effect of taking the interrupt again, in SVC
-		 * mode this time.
+		 * Per ARM DDI 0487G.b section D1.13.4, an ISB (or other
+		 * context synchronization event) is necessary to ensure that
+		 * pending interrupts are taken.
 		 */
 		local_irq_enable();
+		isb();
+		local_irq_disable();
+
+		guest_timing_exit_irqoff();
+
+		local_irq_enable();
 
-		/*
-		 * We do local_irq_enable() before calling guest_exit() so
-		 * that if a timer interrupt hits while running the guest we
-		 * account that tick as being spent in the guest.  We enable
-		 * preemption after calling guest_exit() so that if we get
-		 * preempted we make sure ticks after that is not counted as
-		 * guest time.
-		 */
-		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
 		/* Exit types that need handling before we can be preempted */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..a5ab5215094e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -226,6 +226,14 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (ARM_SERROR_PENDING(exception_index)) {
+		/*
+		 * The SError is handled by handle_exit_early(). If the guest
+		 * survives it will re-execute the original instruction.
+		 */
+		return 1;
+	}
+
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
 
 	switch (exception_index) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c75e84489f57..ecd41844eda0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -425,7 +425,8 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
-	if (ARM_SERROR_PENDING(*exit_code)) {
+	if (ARM_SERROR_PENDING(*exit_code) &&
+	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ) {
 		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
 		/*
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index dcf455525cfc..97ede6fb15f2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4654,6 +4654,19 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.lbr_read		= intel_pmu_lbr_read_64,
 	.lbr_save		= intel_pmu_lbr_save,
 	.lbr_restore		= intel_pmu_lbr_restore,
+
+	/*
+	 * SMM has access to all 4 rings and while traditionally SMM code only
+	 * ran in CPL0, 2021-era firmware is starting to make use of CPL3 in SMM.
+	 *
+	 * Since the EVENTSEL.{USR,OS} CPL filtering makes no distinction
+	 * between SMM or not, this results in what should be pure userspace
+	 * counters including SMM data.
+	 *
+	 * This is a clear privilege issue, therefore globally disable
+	 * counting SMM by default.
+	 */
+	.attr_freeze_on_smi	= 1,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 7f406c14715f..2d33bba9a144 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -897,8 +897,9 @@ static void pt_handle_status(struct pt *pt)
 		 * means we are already losing data; need to let the decoder
 		 * know.
 		 */
-		if (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) ||
-		    buf->output_off == pt_buffer_region_size(buf)) {
+		if (!buf->single &&
+		    (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) ||
+		     buf->output_off == pt_buffer_region_size(buf))) {
 			perf_aux_output_flag(&pt->handle,
 			                     PERF_AUX_FLAG_TRUNCATED);
 			advance++;
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6b47cddbbca1..4a7c33ed9a66 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -373,7 +373,7 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 56bf5ad01ad5..8f5848aa144f 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -14,6 +14,7 @@
 #include <linux/xarray.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/dma-heap.h>
@@ -135,6 +136,7 @@ static long dma_heap_ioctl(struct file *file, unsigned int ucmd,
 	if (nr >= ARRAY_SIZE(dma_heap_ioctl_cmds))
 		return -EINVAL;
 
+	nr = array_index_nospec(nr, ARRAY_SIZE(dma_heap_ioctl_cmds));
 	/* Get the kernel ioctl cmd that matches */
 	kcmd = dma_heap_ioctl_cmds[nr];
 
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 3a6d2416cb0f..5dd29789f97d 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -350,7 +350,7 @@ static int altr_sdram_probe(struct platform_device *pdev)
 	if (irq < 0) {
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "No irq %d in DT\n", irq);
-		return -ENODEV;
+		return irq;
 	}
 
 	/* Arria10 has a 2nd IRQ */
diff --git a/drivers/edac/xgene_edac.c b/drivers/edac/xgene_edac.c
index 2ccd1db5e98f..7197f9fa0245 100644
--- a/drivers/edac/xgene_edac.c
+++ b/drivers/edac/xgene_edac.c
@@ -1919,7 +1919,7 @@ static int xgene_edac_probe(struct platform_device *pdev)
 			irq = platform_get_irq_optional(pdev, i);
 			if (irq < 0) {
 				dev_err(&pdev->dev, "No IRQ resource\n");
-				rc = -EINVAL;
+				rc = irq;
 				goto out_err;
 			}
 			rc = devm_request_irq(&pdev->dev, irq,
diff --git a/drivers/gpio/gpio-idt3243x.c b/drivers/gpio/gpio-idt3243x.c
index 08493b05be2d..52b8b72ded77 100644
--- a/drivers/gpio/gpio-idt3243x.c
+++ b/drivers/gpio/gpio-idt3243x.c
@@ -132,7 +132,7 @@ static int idt_gpio_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct gpio_irq_chip *girq;
 	struct idt_gpio_ctrl *ctrl;
-	unsigned int parent_irq;
+	int parent_irq;
 	int ngpios;
 	int ret;
 
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 01634c8d27b3..a964e25ea620 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -47,7 +47,7 @@ struct mpc8xxx_gpio_chip {
 				unsigned offset, int value);
 
 	struct irq_domain *irq;
-	unsigned int irqn;
+	int irqn;
 };
 
 /*
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 41677f99c67b..30059b7db0b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1504,8 +1504,7 @@ static int amdgpu_pmops_prepare(struct device *dev)
 	 * DPM_FLAG_SMART_SUSPEND works properly
 	 */
 	if (amdgpu_device_supports_boco(drm_dev))
-		return pm_runtime_suspended(dev) &&
-			pm_suspend_via_firmware();
+		return pm_runtime_suspended(dev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
index 407e19412a94..8f6e6496ea78 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -324,38 +324,38 @@ static struct clk_bw_params dcn31_bw_params = {
 
 };
 
-static struct wm_table ddr4_wm_table = {
+static struct wm_table ddr5_wm_table = {
 	.entries = {
 		{
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 6.09,
-			.sr_enter_plus_exit_time_us = 7.14,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 	}
@@ -683,7 +683,7 @@ void dcn31_clk_mgr_construct(
 		if (ctx->dc_bios->integrated_info->memory_type == LpDdr5MemType) {
 			dcn31_bw_params.wm_table = lpddr5_wm_table;
 		} else {
-			dcn31_bw_params.wm_table = ddr4_wm_table;
+			dcn31_bw_params.wm_table = ddr5_wm_table;
 		}
 		/* Saved clocks configured at boot for debug purposes */
 		 dcn31_dump_clk_registers(&clk_mgr->base.base.boot_snapshot, &clk_mgr->base.base, &log_info);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 61c18637f84d..93c20844848c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3913,6 +3913,26 @@ static bool retrieve_link_cap(struct dc_link *link)
 		dp_hw_fw_revision.ieee_fw_rev,
 		sizeof(dp_hw_fw_revision.ieee_fw_rev));
 
+	/* Quirk for Apple MBP 2018 15" Retina panels: wrong DP_MAX_LINK_RATE */
+	{
+		uint8_t str_mbp_2018[] = { 101, 68, 21, 103, 98, 97 };
+		uint8_t fwrev_mbp_2018[] = { 7, 4 };
+		uint8_t fwrev_mbp_2018_vega[] = { 8, 4 };
+
+		/* We also check for the firmware revision as 16,1 models have an
+		 * identical device id and are incorrectly quirked otherwise.
+		 */
+		if ((link->dpcd_caps.sink_dev_id == 0x0010fa) &&
+		    !memcmp(link->dpcd_caps.sink_dev_id_str, str_mbp_2018,
+			     sizeof(str_mbp_2018)) &&
+		    (!memcmp(link->dpcd_caps.sink_fw_revision, fwrev_mbp_2018,
+			     sizeof(fwrev_mbp_2018)) ||
+		    !memcmp(link->dpcd_caps.sink_fw_revision, fwrev_mbp_2018_vega,
+			     sizeof(fwrev_mbp_2018_vega)))) {
+			link->reported_link_cap.link_rate = LINK_RATE_RBR2;
+		}
+	}
+
 	memset(&link->dpcd_caps.dsc_caps, '\0',
 			sizeof(link->dpcd_caps.dsc_caps));
 	memset(&link->dpcd_caps.fec_cap, '\0', sizeof(link->dpcd_caps.fec_cap));
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index ca57221e3962..f89bf49965fc 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -3728,14 +3728,14 @@ static ssize_t sienna_cichlid_get_gpu_metrics(struct smu_context *smu,
 
 static int sienna_cichlid_enable_mgpu_fan_boost(struct smu_context *smu)
 {
-	struct smu_table_context *table_context = &smu->smu_table;
-	PPTable_t *smc_pptable = table_context->driver_pptable;
+	uint16_t *mgpu_fan_boost_limit_rpm;
 
+	GET_PPTABLE_MEMBER(MGpuFanBoostLimitRpm, &mgpu_fan_boost_limit_rpm);
 	/*
 	 * Skip the MGpuFanBoost setting for those ASICs
 	 * which do not support it
 	 */
-	if (!smc_pptable->MGpuFanBoostLimitRpm)
+	if (*mgpu_fan_boost_limit_rpm == 0)
 		return 0;
 
 	return smu_cmn_send_smc_msg_with_param(smu,
diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 7e3f5c6ca484..dfa5f18171e3 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -959,6 +959,9 @@ static int check_overlay_dst(struct intel_overlay *overlay,
 	const struct intel_crtc_state *pipe_config =
 		overlay->crtc->config;
 
+	if (rec->dst_height == 0 || rec->dst_width == 0)
+		return -EINVAL;
+
 	if (rec->dst_x < pipe_config->pipe_src_w &&
 	    rec->dst_x + rec->dst_width <= pipe_config->pipe_src_w &&
 	    rec->dst_y < pipe_config->pipe_src_h &&
diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 3ffece568ed9..0e885440be24 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -291,10 +291,11 @@ static bool icl_tc_phy_status_complete(struct intel_digital_port *dig_port)
 static bool adl_tc_phy_status_complete(struct intel_digital_port *dig_port)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+	enum tc_port tc_port = intel_port_to_tc(i915, dig_port->base.port);
 	struct intel_uncore *uncore = &i915->uncore;
 	u32 val;
 
-	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(dig_port->tc_phy_fia_idx));
+	val = intel_uncore_read(uncore, TCSS_DDI_STATUS(tc_port));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
 			    "Port %s: PHY in TCCOLD, assuming not complete\n",
diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 1bbd09ad5287..1ad7259fb1f0 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -865,7 +865,7 @@ static const struct intel_device_info jsl_info = {
 	}, \
 	TGL_CURSOR_OFFSETS, \
 	.has_global_mocs = 1, \
-	.display.has_dsb = 1
+	.display.has_dsb = 0 /* FIXME: LUT load is broken with DSB */
 
 static const struct intel_device_info tgl_info = {
 	GEN12_FEATURES,
diff --git a/drivers/gpu/drm/kmb/kmb_plane.c b/drivers/gpu/drm/kmb/kmb_plane.c
index 00404ba4126d..2735b8eb3537 100644
--- a/drivers/gpu/drm/kmb/kmb_plane.c
+++ b/drivers/gpu/drm/kmb/kmb_plane.c
@@ -158,12 +158,6 @@ static void kmb_plane_atomic_disable(struct drm_plane *plane,
 	case LAYER_1:
 		kmb->plane_status[plane_id].ctrl = LCD_CTRL_VL2_ENABLE;
 		break;
-	case LAYER_2:
-		kmb->plane_status[plane_id].ctrl = LCD_CTRL_GL1_ENABLE;
-		break;
-	case LAYER_3:
-		kmb->plane_status[plane_id].ctrl = LCD_CTRL_GL2_ENABLE;
-		break;
 	}
 
 	kmb->plane_status[plane_id].disable = true;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
index d0f52d59fc2f..64e423dddd9e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
@@ -38,7 +38,7 @@ nvbios_addr(struct nvkm_bios *bios, u32 *addr, u8 size)
 		*addr += bios->imaged_addr;
 	}
 
-	if (unlikely(*addr + size >= bios->size)) {
+	if (unlikely(*addr + size > bios->size)) {
 		nvkm_error(&bios->subdev, "OOB %d %08x %08x\n", size, p, *addr);
 		return false;
 	}
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c903b74f46a4..35f0d5e7533d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3322,7 +3322,7 @@ static int cm_lap_handler(struct cm_work *work)
 	ret = cm_init_av_by_path(param->alternate_path, NULL, &alt_av);
 	if (ret) {
 		rdma_destroy_ah_attr(&ah_attr);
-		return -EINVAL;
+		goto deref;
 	}
 
 	spin_lock_irq(&cm_id_priv->lock);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3d419741e891..13679c7b6577 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -67,8 +67,8 @@ static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 = "timewait exit",
 };
 
-static void cma_set_mgid(struct rdma_id_private *id_priv, struct sockaddr *addr,
-			 union ib_gid *mgid);
+static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
+			      enum ib_gid_type gid_type);
 
 const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 {
@@ -1844,17 +1844,19 @@ static void destroy_mc(struct rdma_id_private *id_priv,
 		if (dev_addr->bound_dev_if)
 			ndev = dev_get_by_index(dev_addr->net,
 						dev_addr->bound_dev_if);
-		if (ndev) {
+		if (ndev && !send_only) {
+			enum ib_gid_type gid_type;
 			union ib_gid mgid;
 
-			cma_set_mgid(id_priv, (struct sockaddr *)&mc->addr,
-				     &mgid);
-
-			if (!send_only)
-				cma_igmp_send(ndev, &mgid, false);
-
-			dev_put(ndev);
+			gid_type = id_priv->cma_dev->default_gid_type
+					   [id_priv->id.port_num -
+					    rdma_start_port(
+						    id_priv->cma_dev->device)];
+			cma_iboe_set_mgid((struct sockaddr *)&mc->addr, &mgid,
+					  gid_type);
+			cma_igmp_send(ndev, &mgid, false);
 		}
+		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
 	}
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 2b72c4fa9550..9d6ac9dff39a 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -95,6 +95,7 @@ struct ucma_context {
 	u64			uid;
 
 	struct list_head	list;
+	struct list_head	mc_list;
 	struct work_struct	close_work;
 };
 
@@ -105,6 +106,7 @@ struct ucma_multicast {
 
 	u64			uid;
 	u8			join_state;
+	struct list_head	list;
 	struct sockaddr_storage	addr;
 };
 
@@ -198,6 +200,7 @@ static struct ucma_context *ucma_alloc_ctx(struct ucma_file *file)
 
 	INIT_WORK(&ctx->close_work, ucma_close_id);
 	init_completion(&ctx->comp);
+	INIT_LIST_HEAD(&ctx->mc_list);
 	/* So list_del() will work if we don't do ucma_finish_ctx() */
 	INIT_LIST_HEAD(&ctx->list);
 	ctx->file = file;
@@ -484,19 +487,19 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 
 static void ucma_cleanup_multicast(struct ucma_context *ctx)
 {
-	struct ucma_multicast *mc;
-	unsigned long index;
+	struct ucma_multicast *mc, *tmp;
 
-	xa_for_each(&multicast_table, index, mc) {
-		if (mc->ctx != ctx)
-			continue;
+	xa_lock(&multicast_table);
+	list_for_each_entry_safe(mc, tmp, &ctx->mc_list, list) {
+		list_del(&mc->list);
 		/*
 		 * At this point mc->ctx->ref is 0 so the mc cannot leave the
 		 * lock on the reader and this is enough serialization
 		 */
-		xa_erase(&multicast_table, index);
+		__xa_erase(&multicast_table, mc->id);
 		kfree(mc);
 	}
+	xa_unlock(&multicast_table);
 }
 
 static void ucma_cleanup_mc_events(struct ucma_multicast *mc)
@@ -1469,12 +1472,16 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 	mc->uid = cmd->uid;
 	memcpy(&mc->addr, addr, cmd->addr_size);
 
-	if (xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
+	xa_lock(&multicast_table);
+	if (__xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
 		     GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto err_free_mc;
 	}
 
+	list_add_tail(&mc->list, &ctx->mc_list);
+	xa_unlock(&multicast_table);
+
 	mutex_lock(&ctx->mutex);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
 				  join_state, mc);
@@ -1500,8 +1507,11 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 	mutex_unlock(&ctx->mutex);
 	ucma_cleanup_mc_events(mc);
 err_xa_erase:
-	xa_erase(&multicast_table, mc->id);
+	xa_lock(&multicast_table);
+	list_del(&mc->list);
+	__xa_erase(&multicast_table, mc->id);
 err_free_mc:
+	xa_unlock(&multicast_table);
 	kfree(mc);
 err_put_ctx:
 	ucma_put_ctx(ctx);
@@ -1569,15 +1579,17 @@ static ssize_t ucma_leave_multicast(struct ucma_file *file,
 		mc = ERR_PTR(-EINVAL);
 	else if (!refcount_inc_not_zero(&mc->ctx->ref))
 		mc = ERR_PTR(-ENXIO);
-	else
-		__xa_erase(&multicast_table, mc->id);
-	xa_unlock(&multicast_table);
 
 	if (IS_ERR(mc)) {
+		xa_unlock(&multicast_table);
 		ret = PTR_ERR(mc);
 		goto out;
 	}
 
+	list_del(&mc->list);
+	__xa_erase(&multicast_table, mc->id);
+	xa_unlock(&multicast_table);
+
 	mutex_lock(&mc->ctx->mutex);
 	rdma_leave_multicast(mc->ctx->cm_id, (struct sockaddr *) &mc->addr);
 	mutex_unlock(&mc->ctx->mutex);
diff --git a/drivers/infiniband/hw/hfi1/ipoib_main.c b/drivers/infiniband/hw/hfi1/ipoib_main.c
index e594a961f513..3e475814b6fa 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -22,26 +22,35 @@ static int hfi1_ipoib_dev_init(struct net_device *dev)
 	int ret;
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
 
 	ret = priv->netdev_ops->ndo_init(dev);
 	if (ret)
-		return ret;
+		goto out_ret;
 
 	ret = hfi1_netdev_add_data(priv->dd,
 				   qpn_from_mac(priv->netdev->dev_addr),
 				   dev);
 	if (ret < 0) {
 		priv->netdev_ops->ndo_uninit(dev);
-		return ret;
+		goto out_ret;
 	}
 
 	return 0;
+out_ret:
+	free_percpu(dev->tstats);
+	dev->tstats = NULL;
+	return ret;
 }
 
 static void hfi1_ipoib_dev_uninit(struct net_device *dev)
 {
 	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
 
+	free_percpu(dev->tstats);
+	dev->tstats = NULL;
+
 	hfi1_netdev_remove_data(priv->dd, qpn_from_mac(priv->netdev->dev_addr));
 
 	priv->netdev_ops->ndo_uninit(dev);
@@ -166,12 +175,7 @@ static void hfi1_ipoib_netdev_dtor(struct net_device *dev)
 	hfi1_ipoib_rxq_deinit(priv->netdev);
 
 	free_percpu(dev->tstats);
-}
-
-static void hfi1_ipoib_free_rdma_netdev(struct net_device *dev)
-{
-	hfi1_ipoib_netdev_dtor(dev);
-	free_netdev(dev);
+	dev->tstats = NULL;
 }
 
 static void hfi1_ipoib_set_id(struct net_device *dev, int id)
@@ -211,24 +215,23 @@ static int hfi1_ipoib_setup_rn(struct ib_device *device,
 	priv->port_num = port_num;
 	priv->netdev_ops = netdev->netdev_ops;
 
-	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
-
 	ib_query_pkey(device, port_num, priv->pkey_index, &priv->pkey);
 
 	rc = hfi1_ipoib_txreq_init(priv);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev TX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
 		return rc;
 	}
 
 	rc = hfi1_ipoib_rxq_init(netdev);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev RX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
+		hfi1_ipoib_txreq_deinit(priv);
 		return rc;
 	}
 
+	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
+
 	netdev->priv_destructor = hfi1_ipoib_netdev_dtor;
 	netdev->needs_free_netdev = true;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index aec2e1851fa7..53d83212cda8 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3249,7 +3249,7 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
 		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
 		if (!ew)
-			break;
+			return;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 3305f2744bfa..ae50b56e8913 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -3073,6 +3073,8 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC)))
 			goto inv_err;
+		if (unlikely(wqe->atomic_wr.remote_addr & (sizeof(u64) - 1)))
+			goto inv_err;
 		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, sizeof(u64),
 					  wqe->atomic_wr.remote_addr,
 					  wqe->atomic_wr.rkey,
diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index 368959ae9a8c..df03d84c6868 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -644,14 +644,9 @@ static inline struct siw_sqe *orq_get_current(struct siw_qp *qp)
 	return &qp->orq[qp->orq_get % qp->attrs.orq_size];
 }
 
-static inline struct siw_sqe *orq_get_tail(struct siw_qp *qp)
-{
-	return &qp->orq[qp->orq_put % qp->attrs.orq_size];
-}
-
 static inline struct siw_sqe *orq_get_free(struct siw_qp *qp)
 {
-	struct siw_sqe *orq_e = orq_get_tail(qp);
+	struct siw_sqe *orq_e = &qp->orq[qp->orq_put % qp->attrs.orq_size];
 
 	if (READ_ONCE(orq_e->flags) == 0)
 		return orq_e;
diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 60116f20653c..875ea6f1b04a 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1153,11 +1153,12 @@ static int siw_check_tx_fence(struct siw_qp *qp)
 
 	spin_lock_irqsave(&qp->orq_lock, flags);
 
-	rreq = orq_get_current(qp);
-
 	/* free current orq entry */
+	rreq = orq_get_current(qp);
 	WRITE_ONCE(rreq->flags, 0);
 
+	qp->orq_get++;
+
 	if (qp->tx_ctx.orq_fence) {
 		if (unlikely(tx_waiting->wr_status != SIW_WR_QUEUED)) {
 			pr_warn("siw: [QP %u]: fence resume: bad status %d\n",
@@ -1165,10 +1166,12 @@ static int siw_check_tx_fence(struct siw_qp *qp)
 			rv = -EPROTO;
 			goto out;
 		}
-		/* resume SQ processing */
+		/* resume SQ processing, if possible */
 		if (tx_waiting->sqe.opcode == SIW_OP_READ ||
 		    tx_waiting->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
-			rreq = orq_get_tail(qp);
+
+			/* SQ processing was stopped because of a full ORQ */
+			rreq = orq_get_free(qp);
 			if (unlikely(!rreq)) {
 				pr_warn("siw: [QP %u]: no ORQE\n", qp_id(qp));
 				rv = -EPROTO;
@@ -1181,15 +1184,14 @@ static int siw_check_tx_fence(struct siw_qp *qp)
 			resume_tx = 1;
 
 		} else if (siw_orq_empty(qp)) {
+			/*
+			 * SQ processing was stopped by fenced work request.
+			 * Resume since all previous Read's are now completed.
+			 */
 			qp->tx_ctx.orq_fence = 0;
 			resume_tx = 1;
-		} else {
-			pr_warn("siw: [QP %u]: fence resume: orq idx: %d:%d\n",
-				qp_id(qp), qp->orq_get, qp->orq_put);
-			rv = -EPROTO;
 		}
 	}
-	qp->orq_get++;
 out:
 	spin_unlock_irqrestore(&qp->orq_lock, flags);
 
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 1b36350601fa..aa3f60d54a70 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -311,7 +311,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 
 	if (atomic_inc_return(&sdev->num_qp) > SIW_MAX_QP) {
 		siw_dbg(base_dev, "too many QP's\n");
-		return -ENOMEM;
+		rv = -ENOMEM;
+		goto err_atomic;
 	}
 	if (attrs->qp_type != IB_QPT_RC) {
 		siw_dbg(base_dev, "only RC QP's supported\n");
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 50e5a728f12a..72cad85e5e5f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/apic.h>
@@ -832,6 +833,7 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
+		udelay(10);
 	}
 
 	if (WARN_ON(i >= LOOP_TIMEOUT))
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index f912fe45bea2..a67319597884 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -569,9 +569,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 					    fn, &intel_ir_domain_ops,
 					    iommu);
 	if (!iommu->ir_domain) {
-		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
-		goto out_free_bitmap;
+		goto out_free_fwnode;
 	}
 	iommu->ir_msi_domain =
 		arch_create_remap_msi_irq_domain(iommu->ir_domain,
@@ -595,7 +594,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 
 		if (dmar_enable_qi(iommu)) {
 			pr_err("Failed to enable queued invalidation\n");
-			goto out_free_bitmap;
+			goto out_free_ir_domain;
 		}
 	}
 
@@ -619,6 +618,14 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 
 	return 0;
 
+out_free_ir_domain:
+	if (iommu->ir_msi_domain)
+		irq_domain_remove(iommu->ir_msi_domain);
+	iommu->ir_msi_domain = NULL;
+	irq_domain_remove(iommu->ir_domain);
+	iommu->ir_domain = NULL;
+out_free_fwnode:
+	irq_domain_free_fwnode(fn);
 out_free_bitmap:
 	bitmap_free(bitmap);
 out_free_pages:
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index a5f1aa911fe2..9891b072b462 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_GE_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f089d33dd48e..ce507464f3d6 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -281,7 +281,7 @@ static int gve_adminq_parse_err(struct gve_priv *priv, u32 status)
  */
 static int gve_adminq_kick_and_wait(struct gve_priv *priv)
 {
-	u32 tail, head;
+	int tail, head;
 	int i;
 
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 3178efd98006..eb6961d901c1 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -114,7 +114,8 @@ enum e1000_boards {
 	board_pch_lpt,
 	board_pch_spt,
 	board_pch_cnp,
-	board_pch_tgp
+	board_pch_tgp,
+	board_pch_adp
 };
 
 struct e1000_ps_page {
@@ -501,6 +502,7 @@ extern const struct e1000_info e1000_pch_lpt_info;
 extern const struct e1000_info e1000_pch_spt_info;
 extern const struct e1000_info e1000_pch_cnp_info;
 extern const struct e1000_info e1000_pch_tgp_info;
+extern const struct e1000_info e1000_pch_adp_info;
 extern const struct e1000_info e1000_es2_info;
 
 void e1000e_ptp_init(struct e1000_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 5e4fc9b4e2ad..c908c84b86d2 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -6021,3 +6021,23 @@ const struct e1000_info e1000_pch_tgp_info = {
 	.phy_ops		= &ich8_phy_ops,
 	.nvm_ops		= &spt_nvm_ops,
 };
+
+const struct e1000_info e1000_pch_adp_info = {
+	.mac			= e1000_pch_adp,
+	.flags			= FLAG_IS_ICH
+				  | FLAG_HAS_WOL
+				  | FLAG_HAS_HW_TIMESTAMP
+				  | FLAG_HAS_CTRLEXT_ON_LOAD
+				  | FLAG_HAS_AMT
+				  | FLAG_HAS_FLASH
+				  | FLAG_HAS_JUMBO_FRAMES
+				  | FLAG_APME_IN_WUC,
+	.flags2			= FLAG2_HAS_PHY_STATS
+				  | FLAG2_HAS_EEE,
+	.pba			= 26,
+	.max_hw_frame_size	= 9022,
+	.get_variants		= e1000_get_variants_ich8lan,
+	.mac_ops		= &ich8_mac_ops,
+	.phy_ops		= &ich8_phy_ops,
+	.nvm_ops		= &spt_nvm_ops,
+};
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 276a0aa1ed4a..af2029bb43e3 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -52,6 +52,7 @@ static const struct e1000_info *e1000_info_tbl[] = {
 	[board_pch_spt]		= &e1000_pch_spt_info,
 	[board_pch_cnp]		= &e1000_pch_cnp_info,
 	[board_pch_tgp]		= &e1000_pch_tgp_info,
+	[board_pch_adp]		= &e1000_pch_adp_info,
 };
 
 struct e1000_reg_info {
@@ -7905,22 +7906,22 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_adp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 4578c64953ea..c27441c08dd6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -49,13 +49,15 @@ struct visconti_eth {
 	void __iomem *reg;
 	u32 phy_intf_sel;
 	struct clk *phy_ref_clk;
+	struct device *dev;
 	spinlock_t lock; /* lock to protect register update */
 };
 
 static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct visconti_eth *dwmac = priv;
-	unsigned int val, clk_sel_val;
+	struct net_device *netdev = dev_get_drvdata(dwmac->dev);
+	unsigned int val, clk_sel_val = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dwmac->lock, flags);
@@ -85,7 +87,9 @@ static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 		break;
 	default:
 		/* No bit control */
-		break;
+		netdev_err(netdev, "Unsupported speed request (%d)", speed);
+		spin_unlock_irqrestore(&dwmac->lock, flags);
+		return;
 	}
 
 	writel(val, dwmac->reg + MAC_CTRL_REG);
@@ -230,6 +234,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dwmac->lock);
 	dwmac->reg = stmmac_res.addr;
+	dwmac->dev = &pdev->dev;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = visconti_eth_fix_mac_speed;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index 1914ad698cab..acd70b9a3173 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -150,6 +150,7 @@
 
 #define NUM_DWMAC100_DMA_REGS	9
 #define NUM_DWMAC1000_DMA_REGS	23
+#define NUM_DWMAC4_DMA_REGS	27
 
 void dwmac_enable_dma_transmission(void __iomem *ioaddr);
 void dwmac_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d89455803bed..8f563b446d5c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -21,10 +21,18 @@
 #include "dwxgmac2.h"
 
 #define REG_SPACE_SIZE	0x1060
+#define GMAC4_REG_SPACE_SIZE	0x116C
 #define MAC100_ETHTOOL_NAME	"st_mac100"
 #define GMAC_ETHTOOL_NAME	"st_gmac"
 #define XGMAC_ETHTOOL_NAME	"st_xgmac"
 
+/* Same as DMA_CHAN_BASE_ADDR defined in dwmac4_dma.h
+ *
+ * It is here because dwmac_dma.h and dwmac4_dam.h can not be included at the
+ * same time due to the conflicting macro names.
+ */
+#define GMAC4_DMA_CHAN_BASE_ADDR  0x00001100
+
 #define ETHTOOL_DMA_OFFSET	55
 
 struct stmmac_stats {
@@ -435,6 +443,8 @@ static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 
 	if (priv->plat->has_xgmac)
 		return XGMAC_REGSIZE * 4;
+	else if (priv->plat->has_gmac4)
+		return GMAC4_REG_SPACE_SIZE;
 	return REG_SPACE_SIZE;
 }
 
@@ -447,8 +457,13 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	stmmac_dump_mac_regs(priv, priv->hw, reg_space);
 	stmmac_dump_dma_regs(priv, priv->ioaddr, reg_space);
 
-	if (!priv->plat->has_xgmac) {
-		/* Copy DMA registers to where ethtool expects them */
+	/* Copy DMA registers to where ethtool expects them */
+	if (priv->plat->has_gmac4) {
+		/* GMAC4 dumps its DMA registers at its DMA_CHAN_BASE_ADDR */
+		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
+		       &reg_space[GMAC4_DMA_CHAN_BASE_ADDR / 4],
+		       NUM_DWMAC4_DMA_REGS * 4);
+	} else if (!priv->plat->has_xgmac) {
 		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
 		       &reg_space[DMA_BUS_MODE / 4],
 		       NUM_DWMAC1000_DMA_REGS * 4);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 074e2cdfb0fa..a7ec9f4d46ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -145,15 +145,20 @@ static int adjust_systime(void __iomem *ioaddr, u32 sec, u32 nsec,
 
 static void get_systime(void __iomem *ioaddr, u64 *systime)
 {
-	u64 ns;
-
-	/* Get the TSSS value */
-	ns = readl(ioaddr + PTP_STNSR);
-	/* Get the TSS and convert sec time value to nanosecond */
-	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
+	u64 ns, sec0, sec1;
+
+	/* Get the TSS value */
+	sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	do {
+		sec0 = sec1;
+		/* Get the TSSS value */
+		ns = readl_relaxed(ioaddr + PTP_STNSR);
+		/* Get the TSS value */
+		sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	} while (sec0 != sec1);
 
 	if (systime)
-		*systime = ns;
+		*systime = ns + (sec1 * 1000000000ULL);
 }
 
 static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9f3d18abf62b..161e65333ed9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7120,6 +7120,10 @@ int stmmac_dvr_remove(struct device *dev)
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
+	pm_runtime_get_sync(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	stmmac_stop_all_dma(priv);
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
@@ -7138,8 +7142,6 @@ int stmmac_dvr_remove(struct device *dev)
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
 	reset_control_assert(priv->plat->stmmac_ahb_rst);
-	pm_runtime_put(dev);
-	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 3a2824f24caa..97fbe850de9b 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1771,6 +1771,7 @@ static int ca8210_async_xmit_complete(
 			status
 		);
 		if (status != MAC_TRANSACTION_OVERFLOW) {
+			dev_kfree_skb_any(priv->tx_skb);
 			ieee802154_wake_queue(priv->hw);
 			return 0;
 		}
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8caa61ec718f..36f1c5aa98fc 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 		goto err_pib;
 	}
 
+	pib->channel = 13;
 	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 8dc04e2590b1..383231b85464 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
 	phy->symbol_duration = 16;
-	phy->lifs_period = 40;
-	phy->sifs_period = 12;
+	phy->lifs_period = 40 * phy->symbol_duration;
+	phy->sifs_period = 12 * phy->symbol_duration;
 
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM |
 			IEEE802154_HW_AFILT |
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 93dc48b9b4f2..e53b40359fd1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3870,6 +3870,18 @@ static void macsec_common_dellink(struct net_device *dev, struct list_head *head
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			macsec_offload(ops->mdo_del_secy, &ctx);
+		}
+	}
+
 	unregister_netdevice_queue(dev, head);
 	list_del_rcu(&macsec->secys);
 	macsec_del_dev(macsec);
@@ -3884,18 +3896,6 @@ static void macsec_dellink(struct net_device *dev, struct list_head *head)
 	struct net_device *real_dev = macsec->real_dev;
 	struct macsec_rxh_data *rxd = macsec_data_rtnl(real_dev);
 
-	/* If h/w offloading is available, propagate to the device */
-	if (macsec_is_offloaded(macsec)) {
-		const struct macsec_ops *ops;
-		struct macsec_context ctx;
-
-		ops = macsec_get_ops(netdev_priv(dev), &ctx);
-		if (ops) {
-			ctx.secy = &macsec->secy;
-			macsec_offload(ops->mdo_del_secy, &ctx);
-		}
-	}
-
 	macsec_common_dellink(dev, head);
 
 	if (list_empty(&rxd->secys)) {
@@ -4018,6 +4018,15 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	    !macsec_check_offload(macsec->offload, macsec))
 		return -EOPNOTSUPP;
 
+	/* send_sci must be set to true when transmit sci explicitly is set */
+	if ((data && data[IFLA_MACSEC_SCI]) &&
+	    (data && data[IFLA_MACSEC_INC_SCI])) {
+		u8 send_sci = !!nla_get_u8(data[IFLA_MACSEC_INC_SCI]);
+
+		if (!send_sci)
+			return -EINVAL;
+	}
+
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
 	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a146cb903869..561c2abd3892 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -169,6 +169,7 @@ nvmf_ctlr_matches_baseopts(struct nvme_ctrl *ctrl,
 			struct nvmf_ctrl_options *opts)
 {
 	if (ctrl->state == NVME_CTRL_DELETING ||
+	    ctrl->state == NVME_CTRL_DELETING_NOIO ||
 	    ctrl->state == NVME_CTRL_DEAD ||
 	    strcmp(opts->subsysnqn, ctrl->opts->subsysnqn) ||
 	    strcmp(opts->host->nqn, ctrl->opts->host->nqn) ||
diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index cc39c0e18b47..cb339299adf9 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1263,16 +1263,18 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 				     sizeof(*girq->parents),
 				     GFP_KERNEL);
 	if (!girq->parents) {
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out_remove;
 	}
 
 	if (is_7211) {
 		pc->wake_irq = devm_kcalloc(dev, BCM2835_NUM_IRQS,
 					    sizeof(*pc->wake_irq),
 					    GFP_KERNEL);
-		if (!pc->wake_irq)
-			return -ENOMEM;
+		if (!pc->wake_irq) {
+			err = -ENOMEM;
+			goto out_remove;
+		}
 	}
 
 	/*
@@ -1300,8 +1302,10 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 
 		len = strlen(dev_name(pc->dev)) + 16;
 		name = devm_kzalloc(pc->dev, len, GFP_KERNEL);
-		if (!name)
-			return -ENOMEM;
+		if (!name) {
+			err = -ENOMEM;
+			goto out_remove;
+		}
 
 		snprintf(name, len, "%s:bank%d", dev_name(pc->dev), i);
 
@@ -1320,11 +1324,14 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	err = gpiochip_add_data(&pc->gpio_chip, pc);
 	if (err) {
 		dev_err(dev, "could not add GPIO chip\n");
-		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
-		return err;
+		goto out_remove;
 	}
 
 	return 0;
+
+out_remove:
+	pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
+	return err;
 }
 
 static struct platform_driver bcm2835_pinctrl_driver = {
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 85750974d182..826d494f3cc6 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -451,8 +451,8 @@ static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
 	value &= ~PADCFG0_PMODE_MASK;
 	value |= PADCFG0_PMODE_GPIO;
 
-	/* Disable input and output buffers */
-	value |= PADCFG0_GPIORXDIS;
+	/* Disable TX buffer and enable RX (this will be input) */
+	value &= ~PADCFG0_GPIORXDIS;
 	value |= PADCFG0_GPIOTXDIS;
 
 	/* Disable SCI/SMI/NMI generation */
@@ -497,9 +497,6 @@ static int intel_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	intel_gpio_set_gpio_mode(padcfg0);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(padcfg0, true);
-
 	raw_spin_unlock_irqrestore(&pctrl->lock, flags);
 
 	return 0;
@@ -1115,9 +1112,6 @@ static int intel_gpio_irq_type(struct irq_data *d, unsigned int type)
 
 	intel_gpio_set_gpio_mode(reg);
 
-	/* Disable TX buffer and enable RX (this will be input) */
-	__intel_gpio_set_direction(reg, true);
-
 	value = readl(reg);
 
 	value &= ~(PADCFG0_RXEVCFG_MASK | PADCFG0_RXINV);
@@ -1216,6 +1210,39 @@ static irqreturn_t intel_gpio_irq(int irq, void *data)
 	return IRQ_RETVAL(ret);
 }
 
+static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
+{
+	int i;
+
+	for (i = 0; i < pctrl->ncommunities; i++) {
+		const struct intel_community *community;
+		void __iomem *base;
+		unsigned int gpp;
+
+		community = &pctrl->communities[i];
+		base = community->regs;
+
+		for (gpp = 0; gpp < community->ngpps; gpp++) {
+			/* Mask and clear all interrupts */
+			writel(0, base + community->ie_offset + gpp * 4);
+			writel(0xffff, base + community->is_offset + gpp * 4);
+		}
+	}
+}
+
+static int intel_gpio_irq_init_hw(struct gpio_chip *gc)
+{
+	struct intel_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	/*
+	 * Make sure the interrupt lines are in a proper state before
+	 * further configuration.
+	 */
+	intel_gpio_irq_init(pctrl);
+
+	return 0;
+}
+
 static int intel_gpio_add_community_ranges(struct intel_pinctrl *pctrl,
 				const struct intel_community *community)
 {
@@ -1320,6 +1347,7 @@ static int intel_gpio_probe(struct intel_pinctrl *pctrl, int irq)
 	girq->num_parents = 0;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_bad_irq;
+	girq->init_hw = intel_gpio_irq_init_hw;
 
 	ret = devm_gpiochip_add_data(pctrl->dev, &pctrl->chip, pctrl);
 	if (ret) {
@@ -1695,26 +1723,6 @@ int intel_pinctrl_suspend_noirq(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(intel_pinctrl_suspend_noirq);
 
-static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
-{
-	size_t i;
-
-	for (i = 0; i < pctrl->ncommunities; i++) {
-		const struct intel_community *community;
-		void __iomem *base;
-		unsigned int gpp;
-
-		community = &pctrl->communities[i];
-		base = community->regs;
-
-		for (gpp = 0; gpp < community->ngpps; gpp++) {
-			/* Mask and clear all interrupts */
-			writel(0, base + community->ie_offset + gpp * 4);
-			writel(0xffff, base + community->is_offset + gpp * 4);
-		}
-	}
-}
-
 static bool intel_gpio_update_reg(void __iomem *reg, u32 mask, u32 value)
 {
 	u32 curr, updated;
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c
index ce1917e230f4..152b71226a80 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c
@@ -363,16 +363,16 @@ static const struct sunxi_desc_pin h616_pins[] = {
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
 		  SUNXI_FUNCTION(0x2, "uart2"),		/* CTS */
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DO0 */
+		  SUNXI_FUNCTION(0x3, "i2s3_dout0"),	/* DO0 */
 		  SUNXI_FUNCTION(0x4, "spi1"),		/* MISO */
-		  SUNXI_FUNCTION(0x5, "i2s3"),	/* DI1 */
+		  SUNXI_FUNCTION(0x5, "i2s3_din1"),	/* DI1 */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 6, 8)),	/* PH_EINT8 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 9),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DI0 */
+		  SUNXI_FUNCTION(0x3, "i2s3_din0"),	/* DI0 */
 		  SUNXI_FUNCTION(0x4, "spi1"),		/* CS1 */
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DO1 */
+		  SUNXI_FUNCTION(0x5, "i2s3_dout1"),	/* DO1 */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 6, 9)),	/* PH_EINT9 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 10),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index dcfaf09946ee..2065842f775d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -104,7 +104,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century > 20)
+	if (century > 19)
 		time->tm_year += (century - 19) * 100;
 
 	/*
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a8ce854c4684..e2586472ecad 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -508,7 +508,8 @@ static int bnx2fc_l2_rcv_thread(void *arg)
 
 static void bnx2fc_recv_frame(struct sk_buff *skb)
 {
-	u32 fr_len;
+	u64 crc_err;
+	u32 fr_len, fr_crc;
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
 	struct fc_stats *stats;
@@ -542,6 +543,11 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
+	stats = per_cpu_ptr(lport->stats, get_cpu());
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	put_cpu();
+
 	fp = (struct fc_frame *)skb;
 	fc_frame_init(fp);
 	fr_dev(fp) = lport;
@@ -624,16 +630,15 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 		return;
 	}
 
-	stats = per_cpu_ptr(lport->stats, smp_processor_id());
-	stats->RxFrames++;
-	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+	fr_crc = le32_to_cpu(fr_crc(fp));
 
-	if (le32_to_cpu(fr_crc(fp)) !=
-			~crc32(~0, skb->data, fr_len)) {
-		if (stats->InvalidCRCCount < 5)
+	if (unlikely(fr_crc != ~crc32(~0, skb->data, fr_len))) {
+		stats = per_cpu_ptr(lport->stats, get_cpu());
+		crc_err = (stats->InvalidCRCCount++);
+		put_cpu();
+		if (crc_err < 5)
 			printk(KERN_WARNING PFX "dropping frame with "
 			       "CRC error\n");
-		stats->InvalidCRCCount++;
 		kfree_skb(skb);
 		return;
 	}
diff --git a/drivers/soc/mediatek/mtk-scpsys.c b/drivers/soc/mediatek/mtk-scpsys.c
index 670cc82d17dc..ca75b14931ec 100644
--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -411,17 +411,12 @@ static int scpsys_power_off(struct generic_pm_domain *genpd)
 	return ret;
 }
 
-static int init_clks(struct platform_device *pdev, struct clk **clk)
+static void init_clks(struct platform_device *pdev, struct clk **clk)
 {
 	int i;
 
-	for (i = CLK_NONE + 1; i < CLK_MAX; i++) {
+	for (i = CLK_NONE + 1; i < CLK_MAX; i++)
 		clk[i] = devm_clk_get(&pdev->dev, clk_names[i]);
-		if (IS_ERR(clk[i]))
-			return PTR_ERR(clk[i]);
-	}
-
-	return 0;
 }
 
 static struct scp *init_scp(struct platform_device *pdev,
@@ -431,7 +426,7 @@ static struct scp *init_scp(struct platform_device *pdev,
 {
 	struct genpd_onecell_data *pd_data;
 	struct resource *res;
-	int i, j, ret;
+	int i, j;
 	struct scp *scp;
 	struct clk *clk[CLK_MAX];
 
@@ -486,9 +481,7 @@ static struct scp *init_scp(struct platform_device *pdev,
 
 	pd_data->num_domains = num;
 
-	ret = init_clks(pdev, clk);
-	if (ret)
-		return ERR_PTR(ret);
+	init_clks(pdev, clk);
 
 	for (i = 0; i < num; i++) {
 		struct scp_domain *scpd = &scp->domains[i];
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 151e154284bd..ae8c86be7786 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -552,7 +552,7 @@ static void bcm_qspi_chip_select(struct bcm_qspi *qspi, int cs)
 	u32 rd = 0;
 	u32 wr = 0;
 
-	if (qspi->base[CHIP_SELECT]) {
+	if (cs >= 0 && qspi->base[CHIP_SELECT]) {
 		rd = bcm_qspi_read(qspi, CHIP_SELECT, 0);
 		wr = (rd & ~0xff) | (1 << cs);
 		if (rd == wr)
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index c208efeadd18..0bc7daa7afc8 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -693,6 +693,11 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	writel_relaxed(0, spicc->base + SPICC_INTREG);
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto out_master;
+	}
+
 	ret = devm_request_irq(&pdev->dev, irq, meson_spicc_irq,
 			       0, NULL, spicc);
 	if (ret) {
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index a15de10ee286..753bd313e6fd 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -624,7 +624,7 @@ static irqreturn_t mtk_spi_interrupt(int irq, void *dev_id)
 	else
 		mdata->state = MTK_SPI_IDLE;
 
-	if (!master->can_dma(master, master->cur_msg->spi, trans)) {
+	if (!master->can_dma(master, NULL, trans)) {
 		if (trans->rx_buf) {
 			cnt = mdata->xfer_len / 4;
 			ioread32_rep(mdata->base + SPI_RX_DATA_REG,
diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 514337c86d2c..ffdc55f87e82 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 
-	ctrl = spi_alloc_master(dev, sizeof(*qspi));
+	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -697,58 +697,46 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi");
 	qspi->io_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(qspi->io_base)) {
-		ret = PTR_ERR(qspi->io_base);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->io_base))
+		return PTR_ERR(qspi->io_base);
 
 	qspi->phys_base = res->start;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi_mm");
 	qspi->mm_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(qspi->mm_base)) {
-		ret = PTR_ERR(qspi->mm_base);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->mm_base))
+		return PTR_ERR(qspi->mm_base);
 
 	qspi->mm_size = resource_size(res);
-	if (qspi->mm_size > STM32_QSPI_MAX_MMAP_SZ) {
-		ret = -EINVAL;
-		goto err_master_put;
-	}
+	if (qspi->mm_size > STM32_QSPI_MAX_MMAP_SZ)
+		return -EINVAL;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		ret = irq;
-		goto err_master_put;
-	}
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_irq(dev, irq, stm32_qspi_irq, 0,
 			       dev_name(dev), qspi);
 	if (ret) {
 		dev_err(dev, "failed to request irq\n");
-		goto err_master_put;
+		return ret;
 	}
 
 	init_completion(&qspi->data_completion);
 	init_completion(&qspi->match_completion);
 
 	qspi->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(qspi->clk)) {
-		ret = PTR_ERR(qspi->clk);
-		goto err_master_put;
-	}
+	if (IS_ERR(qspi->clk))
+		return PTR_ERR(qspi->clk);
 
 	qspi->clk_rate = clk_get_rate(qspi->clk);
-	if (!qspi->clk_rate) {
-		ret = -EINVAL;
-		goto err_master_put;
-	}
+	if (!qspi->clk_rate)
+		return -EINVAL;
 
 	ret = clk_prepare_enable(qspi->clk);
 	if (ret) {
 		dev_err(dev, "can not enable the clock\n");
-		goto err_master_put;
+		return ret;
 	}
 
 	rstc = devm_reset_control_get_exclusive(dev, NULL);
@@ -784,7 +772,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_noresume(dev);
 
-	ret = devm_spi_register_master(dev, ctrl);
+	ret = spi_register_master(ctrl);
 	if (ret)
 		goto err_pm_runtime_free;
 
@@ -806,8 +794,6 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	stm32_qspi_dma_free(qspi);
 err_clk_disable:
 	clk_disable_unprepare(qspi->clk);
-err_master_put:
-	spi_master_put(qspi->ctrl);
 
 	return ret;
 }
@@ -817,6 +803,7 @@ static int stm32_qspi_remove(struct platform_device *pdev)
 	struct stm32_qspi *qspi = platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(qspi->dev);
+	spi_unregister_master(qspi->ctrl);
 	/* disable qspi */
 	writel_relaxed(0, qspi->io_base + QSPI_CR);
 	stm32_qspi_dma_free(qspi);
diff --git a/drivers/spi/spi-uniphier.c b/drivers/spi/spi-uniphier.c
index 342ee8d2c476..cc0da4822231 100644
--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -726,7 +726,7 @@ static int uniphier_spi_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get TX DMA capacities: %d\n",
 				ret);
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		dma_tx_burst = caps.max_burst;
 	}
@@ -735,7 +735,7 @@ static int uniphier_spi_probe(struct platform_device *pdev)
 	if (IS_ERR_OR_NULL(master->dma_rx)) {
 		if (PTR_ERR(master->dma_rx) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		master->dma_rx = NULL;
 		dma_rx_burst = INT_MAX;
@@ -744,7 +744,7 @@ static int uniphier_spi_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev, "failed to get RX DMA capacities: %d\n",
 				ret);
-			goto out_disable_clk;
+			goto out_release_dma;
 		}
 		dma_rx_burst = caps.max_burst;
 	}
@@ -753,10 +753,20 @@ static int uniphier_spi_probe(struct platform_device *pdev)
 
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret)
-		goto out_disable_clk;
+		goto out_release_dma;
 
 	return 0;
 
+out_release_dma:
+	if (!IS_ERR_OR_NULL(master->dma_rx)) {
+		dma_release_channel(master->dma_rx);
+		master->dma_rx = NULL;
+	}
+	if (!IS_ERR_OR_NULL(master->dma_tx)) {
+		dma_release_channel(master->dma_tx);
+		master->dma_tx = NULL;
+	}
+
 out_disable_clk:
 	clk_disable_unprepare(priv->clk);
 
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 840d9813b0bc..fcc46380e7c9 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -78,6 +78,26 @@ config FRAMEBUFFER_CONSOLE
 	help
 	  Low-level framebuffer-based console driver.
 
+config FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	bool "Enable legacy fbcon hardware acceleration code"
+	depends on FRAMEBUFFER_CONSOLE
+	default y if PARISC
+	default n
+	help
+	  This option enables the fbcon (framebuffer text-based) hardware
+	  acceleration for graphics drivers which were written for the fbdev
+	  graphics interface.
+
+	  On modern machines, on mainstream machines (like x86-64) or when
+	  using a modern Linux distribution those fbdev drivers usually aren't used.
+	  So enabling this option wouldn't have any effect, which is why you want
+	  to disable this option on such newer machines.
+
+	  If you compile this kernel for older machines which still require the
+	  fbdev drivers, you may want to say Y.
+
+	  If unsure, select n.
+
 config FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
        bool "Map the console to the primary display device"
        depends on FRAMEBUFFER_CONSOLE
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 22bb3892f6bd..f7b7d35953e8 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1025,7 +1025,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	struct vc_data *svc = *default_mode;
 	struct fbcon_display *t, *p = &fb_display[vc->vc_num];
 	int logo = 1, new_rows, new_cols, rows, cols;
-	int ret;
+	int cap, ret;
 
 	if (WARN_ON(info_idx == -1))
 	    return;
@@ -1034,6 +1034,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con2fb_map[vc->vc_num] = info_idx;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
+	cap = info->flags;
 
 	if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
 		logo_shown = FBCON_LOGO_DONTSHOW;
@@ -1135,13 +1136,13 @@ static void fbcon_init(struct vc_data *vc, int init)
 
 	ops->graphics = 0;
 
-	/*
-	 * No more hw acceleration for fbcon.
-	 *
-	 * FIXME: Garbage collect all the now dead code after sufficient time
-	 * has passed.
-	 */
-	p->scrollmode = SCROLL_REDRAW;
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
+	    !(cap & FBINFO_HWACCEL_DISABLED))
+		p->scrollmode = SCROLL_MOVE;
+	else /* default to something safe */
+		p->scrollmode = SCROLL_REDRAW;
+#endif
 
 	/*
 	 *  ++guenther: console.c:vc_allocate() relies on initializing
@@ -1706,7 +1707,7 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 			count = vc->vc_rows;
 		if (logo_shown >= 0)
 			goto redraw_up;
-		switch (p->scrollmode) {
+		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
 				     count);
@@ -1796,7 +1797,7 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 			count = vc->vc_rows;
 		if (logo_shown >= 0)
 			goto redraw_down;
-		switch (p->scrollmode) {
+		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,
 				     -count);
@@ -1947,6 +1948,48 @@ static void fbcon_bmove_rec(struct vc_data *vc, struct fbcon_display *p, int sy,
 		   height, width);
 }
 
+static void updatescrollmode_accel(struct fbcon_display *p,
+					struct fb_info *info,
+					struct vc_data *vc)
+{
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	struct fbcon_ops *ops = info->fbcon_par;
+	int cap = info->flags;
+	u16 t = 0;
+	int ypan = FBCON_SWAP(ops->rotate, info->fix.ypanstep,
+				  info->fix.xpanstep);
+	int ywrap = FBCON_SWAP(ops->rotate, info->fix.ywrapstep, t);
+	int yres = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
+	int vyres = FBCON_SWAP(ops->rotate, info->var.yres_virtual,
+				   info->var.xres_virtual);
+	int good_pan = (cap & FBINFO_HWACCEL_YPAN) &&
+		divides(ypan, vc->vc_font.height) && vyres > yres;
+	int good_wrap = (cap & FBINFO_HWACCEL_YWRAP) &&
+		divides(ywrap, vc->vc_font.height) &&
+		divides(vc->vc_font.height, vyres) &&
+		divides(vc->vc_font.height, yres);
+	int reading_fast = cap & FBINFO_READS_FAST;
+	int fast_copyarea = (cap & FBINFO_HWACCEL_COPYAREA) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);
+	int fast_imageblit = (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);
+
+	if (good_wrap || good_pan) {
+		if (reading_fast || fast_copyarea)
+			p->scrollmode = good_wrap ?
+				SCROLL_WRAP_MOVE : SCROLL_PAN_MOVE;
+		else
+			p->scrollmode = good_wrap ? SCROLL_REDRAW :
+				SCROLL_PAN_REDRAW;
+	} else {
+		if (reading_fast || (fast_copyarea && !fast_imageblit))
+			p->scrollmode = SCROLL_MOVE;
+		else
+			p->scrollmode = SCROLL_REDRAW;
+	}
+#endif
+}
+
 static void updatescrollmode(struct fbcon_display *p,
 					struct fb_info *info,
 					struct vc_data *vc)
@@ -1962,6 +2005,9 @@ static void updatescrollmode(struct fbcon_display *p,
 		p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
 	if ((yres % fh) && (vyres % fh < yres % fh))
 		p->vrows--;
+
+	/* update scrollmode in case hardware acceleration is used */
+	updatescrollmode_accel(p, info, vc);
 }
 
 #define PITCH(w) (((w) + 7) >> 3)
@@ -2119,7 +2165,7 @@ static int fbcon_switch(struct vc_data *vc)
 
 	updatescrollmode(p, info, vc);
 
-	switch (p->scrollmode) {
+	switch (fb_scrollmode(p)) {
 	case SCROLL_WRAP_MOVE:
 		scrollback_phys_max = p->vrows - vc->vc_rows;
 		break;
diff --git a/drivers/video/fbdev/core/fbcon.h b/drivers/video/fbdev/core/fbcon.h
index 9315b360c898..0f16cbc99e6a 100644
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -29,7 +29,9 @@ struct fbcon_display {
     /* Filled in by the low-level console driver */
     const u_char *fontdata;
     int userfont;                   /* != 0 if fontdata kmalloc()ed */
-    u_short scrollmode;             /* Scroll Method */
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+    u_short scrollmode;             /* Scroll Method, use fb_scrollmode() */
+#endif
     u_short inverse;                /* != 0 text black on white as default */
     short yscroll;                  /* Hardware scrolling */
     int vrows;                      /* number of virtual rows */
@@ -208,6 +210,17 @@ static inline int attr_col_ec(int shift, struct vc_data *vc,
 #define SCROLL_REDRAW	   0x004
 #define SCROLL_PAN_REDRAW  0x005
 
+static inline u_short fb_scrollmode(struct fbcon_display *fb)
+{
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	return fb->scrollmode;
+#else
+	/* hardcoded to SCROLL_REDRAW if acceleration was disabled. */
+	return SCROLL_REDRAW;
+#endif
+}
+
+
 #ifdef CONFIG_FB_TILEBLITTING
 extern void fbcon_set_tileops(struct vc_data *vc, struct fb_info *info);
 #endif
diff --git a/drivers/video/fbdev/core/fbcon_ccw.c b/drivers/video/fbdev/core/fbcon_ccw.c
index 9cd2c4b05c32..2789ace79634 100644
--- a/drivers/video/fbdev/core/fbcon_ccw.c
+++ b/drivers/video/fbdev/core/fbcon_ccw.c
@@ -65,7 +65,7 @@ static void ccw_bmove(struct vc_data *vc, struct fb_info *info, int sy,
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	area.sx = sy * vc->vc_font.height;
 	area.sy = vyres - ((sx + width) * vc->vc_font.width);
@@ -83,7 +83,7 @@ static void ccw_clear(struct vc_data *vc, struct fb_info *info, int sy,
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = sy * vc->vc_font.height;
@@ -140,7 +140,7 @@ static void ccw_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -229,7 +229,7 @@ static void ccw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -387,7 +387,7 @@ static int ccw_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	u32 yoffset;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 	int err;
 
 	yoffset = (vyres - info->var.yres) - ops->var.xoffset;
diff --git a/drivers/video/fbdev/core/fbcon_cw.c b/drivers/video/fbdev/core/fbcon_cw.c
index 88d89fad3f05..86a254c1b2b7 100644
--- a/drivers/video/fbdev/core/fbcon_cw.c
+++ b/drivers/video/fbdev/core/fbcon_cw.c
@@ -50,7 +50,7 @@ static void cw_bmove(struct vc_data *vc, struct fb_info *info, int sy,
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	area.sx = vxres - ((sy + height) * vc->vc_font.height);
 	area.sy = sx * vc->vc_font.width;
@@ -68,7 +68,7 @@ static void cw_clear(struct vc_data *vc, struct fb_info *info, int sy,
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = vxres - ((sy + height) * vc->vc_font.height);
@@ -125,7 +125,7 @@ static void cw_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -212,7 +212,7 @@ static void cw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -369,7 +369,7 @@ static void cw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 static int cw_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 	u32 xoffset;
 	int err;
 
diff --git a/drivers/video/fbdev/core/fbcon_rotate.h b/drivers/video/fbdev/core/fbcon_rotate.h
index e233444cda66..01cbe303b8a2 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.h
+++ b/drivers/video/fbdev/core/fbcon_rotate.h
@@ -12,11 +12,11 @@
 #define _FBCON_ROTATE_H
 
 #define GETVYRES(s,i) ({                           \
-        (s == SCROLL_REDRAW || s == SCROLL_MOVE) ? \
+        (fb_scrollmode(s) == SCROLL_REDRAW || fb_scrollmode(s) == SCROLL_MOVE) ? \
         (i)->var.yres : (i)->var.yres_virtual; })
 
 #define GETVXRES(s,i) ({                           \
-        (s == SCROLL_REDRAW || s == SCROLL_MOVE || !(i)->fix.xpanstep) ? \
+        (fb_scrollmode(s) == SCROLL_REDRAW || fb_scrollmode(s) == SCROLL_MOVE || !(i)->fix.xpanstep) ? \
         (i)->var.xres : (i)->var.xres_virtual; })
 
 
diff --git a/drivers/video/fbdev/core/fbcon_ud.c b/drivers/video/fbdev/core/fbcon_ud.c
index 8d5e66b1bdfb..23bc045769d0 100644
--- a/drivers/video/fbdev/core/fbcon_ud.c
+++ b/drivers/video/fbdev/core/fbcon_ud.c
@@ -50,8 +50,8 @@ static void ud_bmove(struct vc_data *vc, struct fb_info *info, int sy,
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	area.sy = vyres - ((sy + height) * vc->vc_font.height);
 	area.sx = vxres - ((sx + width) * vc->vc_font.width);
@@ -69,8 +69,8 @@ static void ud_clear(struct vc_data *vc, struct fb_info *info, int sy,
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dy = vyres - ((sy + height) * vc->vc_font.height);
@@ -162,8 +162,8 @@ static void ud_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 mod = vc->vc_font.width % 8, cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -259,8 +259,8 @@ static void ud_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -410,8 +410,8 @@ static int ud_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	int xoffset, yoffset;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 	int err;
 
 	xoffset = vxres - info->var.xres - ops->var.xoffset;
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index b8863dd0de5c..e8a3b891b036 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -96,12 +96,8 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 		 dentry, dentry, from_kuid(&init_user_ns, uid),
 		 any);
 	ret = NULL;
-
-	if (d_inode(dentry))
-		ret = v9fs_fid_find_inode(d_inode(dentry), uid);
-
 	/* we'll recheck under lock if there's anything to look in */
-	if (!ret && dentry->d_fsdata) {
+	if (dentry->d_fsdata) {
 		struct hlist_head *h = (struct hlist_head *)&dentry->d_fsdata;
 		spin_lock(&dentry->d_lock);
 		hlist_for_each_entry(fid, h, dlist) {
@@ -112,6 +108,9 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, kuid_t uid, int any)
 			}
 		}
 		spin_unlock(&dentry->d_lock);
+	} else {
+		if (dentry->d_inode)
+			ret = v9fs_fid_find_inode(dentry->d_inode, uid);
 	}
 
 	return ret;
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a53ebc52bd51..d721c66d0b41 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2511,6 +2511,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	int ret;
 	bool dirty_bg_running;
 
+	/*
+	 * This can only happen when we are doing read-only scrub on read-only
+	 * mount.
+	 * In that case we should not start a new transaction on read-only fs.
+	 * Thus here we skip all chunk allocations.
+	 */
+	if (sb_rdonly(fs_info->sb)) {
+		mutex_lock(&fs_info->ro_block_group_mutex);
+		ret = inc_block_group_ro(cache, 0);
+		mutex_unlock(&fs_info->ro_block_group_mutex);
+		return ret;
+	}
+
 	do {
 		trans = btrfs_join_transaction(fs_info->extent_root);
 		if (IS_ERR(trans))
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b6b9c3283ff..6a863b3f6de0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -775,10 +775,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		goto fail;
 	}
 
-	spin_lock(&fs_info->trans_lock);
-	list_add(&pending_snapshot->list,
-		 &trans->transaction->pending_snapshots);
-	spin_unlock(&fs_info->trans_lock);
+	trans->pending_snapshot = pending_snapshot;
 
 	ret = btrfs_commit_transaction(trans);
 	if (ret)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7f6a05e670f5..24fb17d5b28f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1185,9 +1185,24 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
 
+	/*
+	 * We need to have subvol_sem write locked, to prevent races between
+	 * concurrent tasks trying to disable quotas, because we will unlock
+	 * and relock qgroup_ioctl_lock across BTRFS_FS_QUOTA_ENABLED changes.
+	 */
+	lockdep_assert_held_write(&fs_info->subvol_sem);
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
+
+	/*
+	 * Request qgroup rescan worker to complete and wait for it. This wait
+	 * must be done before transaction start for quota disable since it may
+	 * deadlock with transaction by the qgroup rescan worker.
+	 */
+	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	btrfs_qgroup_wait_for_completion(fs_info, false);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	/*
@@ -1205,14 +1220,13 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
+		set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 		goto out;
 	}
 
 	if (!fs_info->quota_root)
 		goto out;
 
-	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-	btrfs_qgroup_wait_for_completion(fs_info, false);
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
@@ -3379,6 +3393,9 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 			btrfs_warn(fs_info,
 			"qgroup rescan init failed, qgroup is not enabled");
 			ret = -EINVAL;
+		} else if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
+			/* Quota disable is in progress */
+			ret = -EBUSY;
 		}
 
 		if (ret) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 14b9fdc8aaa9..f1ae5a5b79c6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2033,6 +2033,27 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
+/*
+ * Add a pending snapshot associated with the given transaction handle to the
+ * respective handle. This must be called after the transaction commit started
+ * and while holding fs_info->trans_lock.
+ * This serves to guarantee a caller of btrfs_commit_transaction() that it can
+ * safely free the pending snapshot pointer in case btrfs_commit_transaction()
+ * returns an error.
+ */
+static void add_pending_snapshot(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_transaction *cur_trans = trans->transaction;
+
+	if (!trans->pending_snapshot)
+		return;
+
+	lockdep_assert_held(&trans->fs_info->trans_lock);
+	ASSERT(cur_trans->state >= TRANS_STATE_COMMIT_START);
+
+	list_add(&trans->pending_snapshot->list, &cur_trans->pending_snapshots);
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -2106,6 +2127,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		enum btrfs_trans_state want_state = TRANS_STATE_COMPLETED;
 
+		add_pending_snapshot(trans);
+
 		spin_unlock(&fs_info->trans_lock);
 		refcount_inc(&cur_trans->use_count);
 
@@ -2196,6 +2219,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * COMMIT_DOING so make sure to wait for num_writers to == 1 again.
 	 */
 	spin_lock(&fs_info->trans_lock);
+	add_pending_snapshot(trans);
 	cur_trans->state = TRANS_STATE_COMMIT_DOING;
 	spin_unlock(&fs_info->trans_lock);
 	wait_event(cur_trans->writer_wait,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index ba45065f9451..eba07b8119bb 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -123,6 +123,8 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	/* Set by a task that wants to create a snapshot. */
+	struct btrfs_pending_snapshot *pending_snapshot;
 	refcount_t use_count;
 	unsigned int type;
 	/*
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c97860ef322d..7ebc816ae39f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2935,6 +2935,9 @@ void ext4_fc_replay_cleanup(struct super_block *sb);
 int ext4_fc_commit(journal_t *journal, tid_t commit_tid);
 int __init ext4_fc_init_dentry_cache(void);
 void ext4_fc_destroy_dentry_cache(void);
+int ext4_fc_record_regions(struct super_block *sb, int ino,
+			   ext4_lblk_t lblk, ext4_fsblk_t pblk,
+			   int len, int replay);
 
 /* mballoc.c */
 extern const struct seq_operations ext4_mb_seq_groups_ops;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f9bd3231a141..c35cb6d9b7b5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6096,11 +6096,15 @@ int ext4_ext_clear_bb(struct inode *inode)
 
 					ext4_mb_mark_bb(inode->i_sb,
 							path[j].p_block, 1, 0);
+					ext4_fc_record_regions(inode->i_sb, inode->i_ino,
+							0, path[j].p_block, 1, 1);
 				}
 				ext4_ext_drop_refs(path);
 				kfree(path);
 			}
 			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, 0);
+			ext4_fc_record_regions(inode->i_sb, inode->i_ino,
+					map.m_lblk, map.m_pblk, map.m_len, 1);
 		}
 		cur = cur + map.m_len;
 	}
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index e0d393425cac..7bcd3be07ee4 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1433,14 +1433,15 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
 		if (state->fc_modified_inodes[i] == ino)
 			return 0;
 	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
-		state->fc_modified_inodes_size +=
-			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 		state->fc_modified_inodes = krealloc(
-					state->fc_modified_inodes, sizeof(int) *
-					state->fc_modified_inodes_size,
-					GFP_KERNEL);
+				state->fc_modified_inodes,
+				sizeof(int) * (state->fc_modified_inodes_size +
+				EXT4_FC_REPLAY_REALLOC_INCREMENT),
+				GFP_KERNEL);
 		if (!state->fc_modified_inodes)
 			return -ENOMEM;
+		state->fc_modified_inodes_size +=
+			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 	}
 	state->fc_modified_inodes[state->fc_modified_inodes_used++] = ino;
 	return 0;
@@ -1472,7 +1473,9 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	}
 	inode = NULL;
 
-	ext4_fc_record_modified_inode(sb, ino);
+	ret = ext4_fc_record_modified_inode(sb, ino);
+	if (ret)
+		goto out;
 
 	raw_fc_inode = (struct ext4_inode *)
 		(val + offsetof(struct ext4_fc_inode, fc_raw_inode));
@@ -1603,16 +1606,23 @@ static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
 }
 
 /*
- * Record physical disk regions which are in use as per fast commit area. Our
- * simple replay phase allocator excludes these regions from allocation.
+ * Record physical disk regions which are in use as per fast commit area,
+ * and used by inodes during replay phase. Our simple replay phase
+ * allocator excludes these regions from allocation.
  */
-static int ext4_fc_record_regions(struct super_block *sb, int ino,
-		ext4_lblk_t lblk, ext4_fsblk_t pblk, int len)
+int ext4_fc_record_regions(struct super_block *sb, int ino,
+		ext4_lblk_t lblk, ext4_fsblk_t pblk, int len, int replay)
 {
 	struct ext4_fc_replay_state *state;
 	struct ext4_fc_alloc_region *region;
 
 	state = &EXT4_SB(sb)->s_fc_replay_state;
+	/*
+	 * during replay phase, the fc_regions_valid may not same as
+	 * fc_regions_used, update it when do new additions.
+	 */
+	if (replay && state->fc_regions_used != state->fc_regions_valid)
+		state->fc_regions_used = state->fc_regions_valid;
 	if (state->fc_regions_used == state->fc_regions_size) {
 		state->fc_regions_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
@@ -1630,6 +1640,9 @@ static int ext4_fc_record_regions(struct super_block *sb, int ino,
 	region->pblk = pblk;
 	region->len = len;
 
+	if (replay)
+		state->fc_regions_valid++;
+
 	return 0;
 }
 
@@ -1661,6 +1674,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	start = le32_to_cpu(ex->ee_block);
 	start_pblk = ext4_ext_pblock(ex);
@@ -1678,18 +1693,14 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 		map.m_pblk = 0;
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 
-		if (ret < 0) {
-			iput(inode);
-			return 0;
-		}
+		if (ret < 0)
+			goto out;
 
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, NULL, 0);
-			if (IS_ERR(path)) {
-				iput(inode);
-				return 0;
-			}
+			if (IS_ERR(path))
+				goto out;
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -1703,10 +1714,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 			up_write((&EXT4_I(inode)->i_data_sem));
 			ext4_ext_drop_refs(path);
 			kfree(path);
-			if (ret) {
-				iput(inode);
-				return 0;
-			}
+			if (ret)
+				goto out;
 			goto next;
 		}
 
@@ -1719,10 +1728,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 			ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
 					ext4_ext_is_unwritten(ex),
 					start_pblk + cur - start);
-			if (ret) {
-				iput(inode);
-				return 0;
-			}
+			if (ret)
+				goto out;
 			/*
 			 * Mark the old blocks as free since they aren't used
 			 * anymore. We maintain an array of all the modified
@@ -1742,10 +1749,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
 					ext4_ext_is_unwritten(ex), map.m_pblk);
-		if (ret) {
-			iput(inode);
-			return 0;
-		}
+		if (ret)
+			goto out;
 		/*
 		 * We may have split the extent tree while toggling the state.
 		 * Try to shrink the extent tree now.
@@ -1757,6 +1762,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+out:
 	iput(inode);
 	return 0;
 }
@@ -1786,6 +1792,8 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
@@ -1795,10 +1803,8 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 		map.m_len = remaining;
 
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
-		if (ret < 0) {
-			iput(inode);
-			return 0;
-		}
+		if (ret < 0)
+			goto out;
 		if (ret > 0) {
 			remaining -= ret;
 			cur += ret;
@@ -1810,18 +1816,17 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
-	ret = ext4_ext_remove_space(inode, lrange.fc_lblk,
-				lrange.fc_lblk + lrange.fc_len - 1);
+	ret = ext4_ext_remove_space(inode, le32_to_cpu(lrange.fc_lblk),
+				le32_to_cpu(lrange.fc_lblk) +
+				le32_to_cpu(lrange.fc_len) - 1);
 	up_write(&EXT4_I(inode)->i_data_sem);
-	if (ret) {
-		iput(inode);
-		return 0;
-	}
+	if (ret)
+		goto out;
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+out:
 	iput(inode);
-
 	return 0;
 }
 
@@ -1973,7 +1978,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			ret = ext4_fc_record_regions(sb,
 				le32_to_cpu(ext.fc_ino),
 				le32_to_cpu(ex->ee_block), ext4_ext_pblock(ex),
-				ext4_ext_get_actual_len(ex));
+				ext4_ext_get_actual_len(ex), 0);
 			if (ret < 0)
 				break;
 			ret = JBD2_FC_REPLAY_CONTINUE;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 39a1ab129fdc..d091133a4b46 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1133,7 +1133,15 @@ static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
 				     struct ext4_iloc *iloc,
 				     void *buf, int inline_size)
 {
-	ext4_create_inline_data(handle, inode, inline_size);
+	int ret;
+
+	ret = ext4_create_inline_data(handle, inode, inline_size);
+	if (ret) {
+		ext4_msg(inode->i_sb, KERN_EMERG,
+			"error restoring inline_data for inode -- potential data loss! (inode %lu, error %d)",
+			inode->i_ino, ret);
+		return;
+	}
 	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
 	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 }
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b05a83be8871..74e3286d0e26 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5753,7 +5753,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 	struct super_block *sb = ar->inode->i_sb;
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
-	int i = sb->s_blocksize;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_grpblk_t i = 0;
 	ext4_fsblk_t goal, block;
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
@@ -5775,19 +5776,26 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		ext4_get_group_no_and_offset(sb,
 			max(ext4_group_first_block_no(sb, group), goal),
 			NULL, &blkoff);
-		i = mb_find_next_zero_bit(bitmap_bh->b_data, sb->s_blocksize,
+		while (1) {
+			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
 						blkoff);
+			if (i >= max)
+				break;
+			if (ext4_fc_replay_check_excluded(sb,
+				ext4_group_first_block_no(sb, group) + i)) {
+				blkoff = i + 1;
+			} else
+				break;
+		}
 		brelse(bitmap_bh);
-		if (i >= sb->s_blocksize)
-			continue;
-		if (ext4_fc_replay_check_excluded(sb,
-			ext4_group_first_block_no(sb, group) + i))
-			continue;
-		break;
+		if (i < max)
+			break;
 	}
 
-	if (group >= ext4_get_groups_count(sb) && i >= sb->s_blocksize)
+	if (group >= ext4_get_groups_count(sb) || i >= max) {
+		*errp = -ENOSPC;
 		return 0;
+	}
 
 	block = ext4_group_first_block_no(sb, group) + i;
 	ext4_mb_mark_bb(sb, block, 1, 1);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 61301affb4c1..97090ddcfc94 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4112,8 +4112,10 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 			status = nfserr_clid_inuse;
 			if (client_has_state(old)
 					&& !same_creds(&unconf->cl_cred,
-							&old->cl_cred))
+							&old->cl_cred)) {
+				old = NULL;
 				goto out;
+			}
 			status = mark_client_expired_locked(old);
 			if (status) {
 				old = NULL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..926f60499c34 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -15,6 +15,8 @@
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/ftrace.h>
+#include <linux/instrumentation.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
 #include <linux/slab.h>
@@ -363,8 +365,11 @@ struct kvm_vcpu {
 	int last_used_slot;
 };
 
-/* must be called with irqs disabled */
-static __always_inline void guest_enter_irqoff(void)
+/*
+ * Start accounting time towards a guest.
+ * Must be called before entering guest context.
+ */
+static __always_inline void guest_timing_enter_irqoff(void)
 {
 	/*
 	 * This is running in ioctl context so its safe to assume that it's the
@@ -373,7 +378,18 @@ static __always_inline void guest_enter_irqoff(void)
 	instrumentation_begin();
 	vtime_account_guest_enter();
 	instrumentation_end();
+}
 
+/*
+ * Enter guest context and enter an RCU extended quiescent state.
+ *
+ * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
+ * unsafe to use any code which may directly or indirectly use RCU, tracing
+ * (including IRQ flag tracing), or lockdep. All code in this period must be
+ * non-instrumentable.
+ */
+static __always_inline void guest_context_enter_irqoff(void)
+{
 	/*
 	 * KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -389,16 +405,79 @@ static __always_inline void guest_enter_irqoff(void)
 	}
 }
 
-static __always_inline void guest_exit_irqoff(void)
+/*
+ * Deprecated. Architectures should move to guest_timing_enter_irqoff() and
+ * guest_state_enter_irqoff().
+ */
+static __always_inline void guest_enter_irqoff(void)
+{
+	guest_timing_enter_irqoff();
+	guest_context_enter_irqoff();
+}
+
+/**
+ * guest_state_enter_irqoff - Fixup state when entering a guest
+ *
+ * Entry to a guest will enable interrupts, but the kernel state is interrupts
+ * disabled when this is invoked. Also tell RCU about it.
+ *
+ * 1) Trace interrupts on state
+ * 2) Invoke context tracking if enabled to adjust RCU state
+ * 3) Tell lockdep that interrupts are enabled
+ *
+ * Invoked from architecture specific code before entering a guest.
+ * Must be called with interrupts disabled and the caller must be
+ * non-instrumentable.
+ * The caller has to invoke guest_timing_enter_irqoff() before this.
+ *
+ * Note: this is analogous to exit_to_user_mode().
+ */
+static __always_inline void guest_state_enter_irqoff(void)
+{
+	instrumentation_begin();
+	trace_hardirqs_on_prepare();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instrumentation_end();
+
+	guest_context_enter_irqoff();
+	lockdep_hardirqs_on(CALLER_ADDR0);
+}
+
+/*
+ * Exit guest context and exit an RCU extended quiescent state.
+ *
+ * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
+ * unsafe to use any code which may directly or indirectly use RCU, tracing
+ * (including IRQ flag tracing), or lockdep. All code in this period must be
+ * non-instrumentable.
+ */
+static __always_inline void guest_context_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
+}
 
+/*
+ * Stop accounting time towards a guest.
+ * Must be called after exiting guest context.
+ */
+static __always_inline void guest_timing_exit_irqoff(void)
+{
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
 	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
+/*
+ * Deprecated. Architectures should move to guest_state_exit_irqoff() and
+ * guest_timing_exit_irqoff().
+ */
+static __always_inline void guest_exit_irqoff(void)
+{
+	guest_context_exit_irqoff();
+	guest_timing_exit_irqoff();
+}
+
 static inline void guest_exit(void)
 {
 	unsigned long flags;
@@ -408,6 +487,33 @@ static inline void guest_exit(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * guest_state_exit_irqoff - Establish state when returning from guest mode
+ *
+ * Entry from a guest disables interrupts, but guest mode is traced as
+ * interrupts enabled. Also with NO_HZ_FULL RCU might be idle.
+ *
+ * 1) Tell lockdep that interrupts are disabled
+ * 2) Invoke context tracking if enabled to reactivate RCU
+ * 3) Trace interrupts off state
+ *
+ * Invoked from architecture specific code after exiting a guest.
+ * Must be invoked with interrupts disabled and the caller must be
+ * non-instrumentable.
+ * The caller has to invoke guest_timing_exit_irqoff() after this.
+ *
+ * Note: this is analogous to enter_from_user_mode().
+ */
+static __always_inline void guest_state_exit_irqoff(void)
+{
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	guest_context_exit_irqoff();
+
+	instrumentation_begin();
+	trace_hardirqs_off_finish();
+	instrumentation_end();
+}
+
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e24d2c992b11..d468efcf48f4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -62,6 +62,7 @@ static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
+#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)
diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 5859ca0a1439..93e40f91bd49 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -56,8 +56,10 @@
  *                                                                          *
  ****************************************************************************/
 
+#define AES_IEC958_STATUS_SIZE		24
+
 struct snd_aes_iec958 {
-	unsigned char status[24];	/* AES/IEC958 channel status bits */
+	unsigned char status[AES_IEC958_STATUS_SIZE]; /* AES/IEC958 channel status bits */
 	unsigned char subcode[147];	/* AES/IEC958 subcode bits */
 	unsigned char pad;		/* nothing */
 	unsigned char dig_subframe[4];	/* AES/IEC958 subframe bits */
diff --git a/ipc/sem.c b/ipc/sem.c
index 6693daf4fe11..0dbdb98fdf2d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
-
-success:
 	spin_unlock(&ulp->lock);
+success:
 	sem_unlock(sma, -1);
 out:
 	return un;
diff --git a/kernel/audit.c b/kernel/audit.c
index eab7282668ab..94ded5de9131 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -541,20 +541,22 @@ static void kauditd_printk_skb(struct sk_buff *skb)
 /**
  * kauditd_rehold_skb - Handle a audit record send failure in the hold queue
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * This should only be used by the kauditd_thread when it fails to flush the
  * hold queue.
  */
-static void kauditd_rehold_skb(struct sk_buff *skb)
+static void kauditd_rehold_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* put the record back in the queue at the same place */
-	skb_queue_head(&audit_hold_queue, skb);
+	/* put the record back in the queue */
+	skb_queue_tail(&audit_hold_queue, skb);
 }
 
 /**
  * kauditd_hold_skb - Queue an audit record, waiting for auditd
  * @skb: audit record
+ * @error: error code
  *
  * Description:
  * Queue the audit record, waiting for an instance of auditd.  When this
@@ -564,19 +566,31 @@ static void kauditd_rehold_skb(struct sk_buff *skb)
  * and queue it, if we have room.  If we want to hold on to the record, but we
  * don't have room, record a record lost message.
  */
-static void kauditd_hold_skb(struct sk_buff *skb)
+static void kauditd_hold_skb(struct sk_buff *skb, int error)
 {
 	/* at this point it is uncertain if we will ever send this to auditd so
 	 * try to send the message via printk before we go any further */
 	kauditd_printk_skb(skb);
 
 	/* can we just silently drop the message? */
-	if (!audit_default) {
-		kfree_skb(skb);
-		return;
+	if (!audit_default)
+		goto drop;
+
+	/* the hold queue is only for when the daemon goes away completely,
+	 * not -EAGAIN failures; if we are in a -EAGAIN state requeue the
+	 * record on the retry queue unless it's full, in which case drop it
+	 */
+	if (error == -EAGAIN) {
+		if (!audit_backlog_limit ||
+		    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+			skb_queue_tail(&audit_retry_queue, skb);
+			return;
+		}
+		audit_log_lost("kauditd retry queue overflow");
+		goto drop;
 	}
 
-	/* if we have room, queue the message */
+	/* if we have room in the hold queue, queue the message */
 	if (!audit_backlog_limit ||
 	    skb_queue_len(&audit_hold_queue) < audit_backlog_limit) {
 		skb_queue_tail(&audit_hold_queue, skb);
@@ -585,24 +599,32 @@ static void kauditd_hold_skb(struct sk_buff *skb)
 
 	/* we have no other options - drop the message */
 	audit_log_lost("kauditd hold queue overflow");
+drop:
 	kfree_skb(skb);
 }
 
 /**
  * kauditd_retry_skb - Queue an audit record, attempt to send again to auditd
  * @skb: audit record
+ * @error: error code (unused)
  *
  * Description:
  * Not as serious as kauditd_hold_skb() as we still have a connected auditd,
  * but for some reason we are having problems sending it audit records so
  * queue the given record and attempt to resend.
  */
-static void kauditd_retry_skb(struct sk_buff *skb)
+static void kauditd_retry_skb(struct sk_buff *skb, __always_unused int error)
 {
-	/* NOTE: because records should only live in the retry queue for a
-	 * short period of time, before either being sent or moved to the hold
-	 * queue, we don't currently enforce a limit on this queue */
-	skb_queue_tail(&audit_retry_queue, skb);
+	if (!audit_backlog_limit ||
+	    skb_queue_len(&audit_retry_queue) < audit_backlog_limit) {
+		skb_queue_tail(&audit_retry_queue, skb);
+		return;
+	}
+
+	/* we have to drop the record, send it via printk as a last effort */
+	kauditd_printk_skb(skb);
+	audit_log_lost("kauditd retry queue overflow");
+	kfree_skb(skb);
 }
 
 /**
@@ -640,7 +662,7 @@ static void auditd_reset(const struct auditd_connection *ac)
 	/* flush the retry queue to the hold queue, but don't touch the main
 	 * queue since we need to process that normally for multicast */
 	while ((skb = skb_dequeue(&audit_retry_queue)))
-		kauditd_hold_skb(skb);
+		kauditd_hold_skb(skb, -ECONNREFUSED);
 }
 
 /**
@@ -714,16 +736,18 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 			      struct sk_buff_head *queue,
 			      unsigned int retry_limit,
 			      void (*skb_hook)(struct sk_buff *skb),
-			      void (*err_hook)(struct sk_buff *skb))
+			      void (*err_hook)(struct sk_buff *skb, int error))
 {
 	int rc = 0;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	struct sk_buff *skb_tail;
 	unsigned int failed = 0;
 
 	/* NOTE: kauditd_thread takes care of all our locking, we just use
 	 *       the netlink info passed to us (e.g. sk and portid) */
 
-	while ((skb = skb_dequeue(queue))) {
+	skb_tail = skb_peek_tail(queue);
+	while ((skb != skb_tail) && (skb = skb_dequeue(queue))) {
 		/* call the skb_hook for each skb we touch */
 		if (skb_hook)
 			(*skb_hook)(skb);
@@ -731,7 +755,7 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 		/* can we send to anyone via unicast? */
 		if (!sk) {
 			if (err_hook)
-				(*err_hook)(skb);
+				(*err_hook)(skb, -ECONNREFUSED);
 			continue;
 		}
 
@@ -745,7 +769,7 @@ static int kauditd_send_queue(struct sock *sk, u32 portid,
 			    rc == -ECONNREFUSED || rc == -EPERM) {
 				sk = NULL;
 				if (err_hook)
-					(*err_hook)(skb);
+					(*err_hook)(skb, rc);
 				if (rc == -EAGAIN)
 					rc = 0;
 				/* continue to drain the queue */
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 9e0c10c6892a..f1c51c45667d 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	}
 
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
-		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
+		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
 		kmemleak_not_leak(pages);
 		rb->pages = pages;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1d9d3e4d4cbc..67eae4a4b724 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1512,10 +1512,15 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 	struct cpuset *sibling;
 	struct cgroup_subsys_state *pos_css;
 
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
 	/*
 	 * Check all its siblings and call update_cpumasks_hier()
 	 * if their use_parent_ecpus flag is set in order for them
 	 * to use the right effective_cpus value.
+	 *
+	 * The update_cpumasks_hier() function may sleep. So we have to
+	 * release the RCU read lock before calling it.
 	 */
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
@@ -1523,8 +1528,13 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 			continue;
 		if (!sibling->use_parent_ecpus)
 			continue;
+		if (!css_tryget_online(&sibling->css))
+			continue;
 
+		rcu_read_unlock();
 		update_cpumasks_hier(sibling, tmp);
+		rcu_read_lock();
+		css_put(&sibling->css);
 	}
 	rcu_read_unlock();
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c7581e3fb8ab..69c70767b5df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3234,6 +3234,15 @@ static int perf_event_modify_breakpoint(struct perf_event *bp,
 	return err;
 }
 
+/*
+ * Copy event-type-independent attributes that may be modified.
+ */
+static void perf_event_modify_copy_attr(struct perf_event_attr *to,
+					const struct perf_event_attr *from)
+{
+	to->sig_data = from->sig_data;
+}
+
 static int perf_event_modify_attr(struct perf_event *event,
 				  struct perf_event_attr *attr)
 {
@@ -3256,10 +3265,17 @@ static int perf_event_modify_attr(struct perf_event *event,
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 
 	mutex_lock(&event->child_mutex);
+	/*
+	 * Event-type-independent attributes must be copied before event-type
+	 * modification, which will validate that final attributes match the
+	 * source attributes after all relevant attributes have been copied.
+	 */
+	perf_event_modify_copy_attr(&event->attr, attr);
 	err = func(event, attr);
 	if (err)
 		goto out;
 	list_for_each_entry(child, &event->child_list, child_list) {
+		perf_event_modify_copy_attr(&child->attr, attr);
 		err = func(child, attr);
 		if (err)
 			goto out;
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 1403639302e4..718d0d3ad8c4 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -171,6 +171,8 @@ static void __init pte_advanced_tests(struct pgtable_debug_args *args)
 	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
+
+	ptep_get_and_clear_full(args->mm, args->vaddr, args->ptep, 1);
 }
 
 static void __init pte_savedwrite_tests(struct pgtable_debug_args *args)
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index b57383c17cf6..adbe5aa01184 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1403,7 +1403,8 @@ static void kmemleak_scan(void)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
-	int i;
+	struct zone *zone;
+	int __maybe_unused i;
 	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
@@ -1443,9 +1444,9 @@ static void kmemleak_scan(void)
 	 * Struct page scanning for each node.
 	 */
 	get_online_mems();
-	for_each_online_node(i) {
-		unsigned long start_pfn = node_start_pfn(i);
-		unsigned long end_pfn = node_end_pfn(i);
+	for_each_populated_zone(zone) {
+		unsigned long start_pfn = zone->zone_start_pfn;
+		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -1454,8 +1455,8 @@ static void kmemleak_scan(void)
 			if (!page)
 				continue;
 
-			/* only scan pages belonging to this node */
-			if (page_to_nid(page) != i)
+			/* only scan pages belonging to this zone */
+			if (page_zone(page) != zone)
 				continue;
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index eba0efe64d05..fbf858ddec35 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -49,7 +49,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -65,7 +65,7 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
@@ -81,7 +81,7 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -98,7 +98,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 277124f206e0..e0b072aecf0f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1441,7 +1441,7 @@ static int nl802154_send_key(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1634,7 +1634,7 @@ static int nl802154_send_device(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1812,7 +1812,7 @@ static int nl802154_send_devkey(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1988,7 +1988,7 @@ static int nl802154_send_seclevel(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d96860053816..2137b7460dea 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -459,6 +459,18 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	return i;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr(struct pm_nl_pernet *pernet, struct mptcp_addr_info *info)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, info, true))
+			return entry;
+	}
+	return NULL;
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -1725,17 +1737,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
 
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (addresses_equal(&entry->addr, &addr.addr, true)) {
-			mptcp_nl_addr_backup(net, &entry->addr, bkup);
-
-			if (bkup)
-				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-			else
-				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
-		}
+	spin_lock_bh(&pernet->lock);
+	entry = __lookup_addr(pernet, &addr.addr);
+	if (!entry) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
 	}
 
+	if (bkup)
+		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+	else
+		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+	addr = *entry;
+	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_addr_backup(net, &addr.addr, bkup);
 	return 0;
 }
 
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 34608369b426..96dee4a62385 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -548,17 +548,115 @@ static void smc_stat_fallback(struct smc_sock *smc)
 	mutex_unlock(&net->smc.mutex_fback_rsn);
 }
 
+/* must be called under rcu read lock */
+static void smc_fback_wakeup_waitqueue(struct smc_sock *smc, void *key)
+{
+	struct socket_wq *wq;
+	__poll_t flags;
+
+	wq = rcu_dereference(smc->sk.sk_wq);
+	if (!skwq_has_sleeper(wq))
+		return;
+
+	/* wake up smc sk->sk_wq */
+	if (!key) {
+		/* sk_state_change */
+		wake_up_interruptible_all(&wq->wait);
+	} else {
+		flags = key_to_poll(key);
+		if (flags & (EPOLLIN | EPOLLOUT))
+			/* sk_data_ready or sk_write_space */
+			wake_up_interruptible_sync_poll(&wq->wait, flags);
+		else if (flags & EPOLLERR)
+			/* sk_error_report */
+			wake_up_interruptible_poll(&wq->wait, flags);
+	}
+}
+
+static int smc_fback_mark_woken(wait_queue_entry_t *wait,
+				unsigned int mode, int sync, void *key)
+{
+	struct smc_mark_woken *mark =
+		container_of(wait, struct smc_mark_woken, wait_entry);
+
+	mark->woken = true;
+	mark->key = key;
+	return 0;
+}
+
+static void smc_fback_forward_wakeup(struct smc_sock *smc, struct sock *clcsk,
+				     void (*clcsock_callback)(struct sock *sk))
+{
+	struct smc_mark_woken mark = { .woken = false };
+	struct socket_wq *wq;
+
+	init_waitqueue_func_entry(&mark.wait_entry,
+				  smc_fback_mark_woken);
+	rcu_read_lock();
+	wq = rcu_dereference(clcsk->sk_wq);
+	if (!wq)
+		goto out;
+	add_wait_queue(sk_sleep(clcsk), &mark.wait_entry);
+	clcsock_callback(clcsk);
+	remove_wait_queue(sk_sleep(clcsk), &mark.wait_entry);
+
+	if (mark.woken)
+		smc_fback_wakeup_waitqueue(smc, mark.key);
+out:
+	rcu_read_unlock();
+}
+
+static void smc_fback_state_change(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_state_change);
+}
+
+static void smc_fback_data_ready(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_data_ready);
+}
+
+static void smc_fback_write_space(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_write_space);
+}
+
+static void smc_fback_error_report(struct sock *clcsk)
+{
+	struct smc_sock *smc =
+		smc_clcsock_user_data(clcsk);
+
+	if (!smc)
+		return;
+	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
+}
+
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
-	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
-	wait_queue_head_t *clc_wait;
-	unsigned long flags;
+	struct sock *clcsk;
 
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
 		mutex_unlock(&smc->clcsock_release_lock);
 		return -EBADF;
 	}
+	clcsk = smc->clcsock->sk;
+
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -568,16 +666,22 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->wq.fasync_list =
 			smc->sk.sk_socket->wq.fasync_list;
 
-		/* There may be some entries remaining in
-		 * smc socket->wq, which should be removed
-		 * to clcsocket->wq during the fallback.
+		/* There might be some wait entries remaining
+		 * in smc sk->sk_wq and they should be woken up
+		 * as clcsock's wait queue is woken up.
 		 */
-		clc_wait = sk_sleep(smc->clcsock->sk);
-		spin_lock_irqsave(&smc_wait->lock, flags);
-		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
-		list_splice_init(&smc_wait->head, &clc_wait->head);
-		spin_unlock(&clc_wait->lock);
-		spin_unlock_irqrestore(&smc_wait->lock, flags);
+		smc->clcsk_state_change = clcsk->sk_state_change;
+		smc->clcsk_data_ready = clcsk->sk_data_ready;
+		smc->clcsk_write_space = clcsk->sk_write_space;
+		smc->clcsk_error_report = clcsk->sk_error_report;
+
+		clcsk->sk_state_change = smc_fback_state_change;
+		clcsk->sk_data_ready = smc_fback_data_ready;
+		clcsk->sk_write_space = smc_fback_write_space;
+		clcsk->sk_error_report = smc_fback_error_report;
+
+		smc->clcsock->sk->sk_user_data =
+			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	}
 	mutex_unlock(&smc->clcsock_release_lock);
 	return 0;
@@ -1909,10 +2013,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 {
-	struct smc_sock *lsmc;
+	struct smc_sock *lsmc =
+		smc_clcsock_user_data(listen_clcsock);
 
-	lsmc = (struct smc_sock *)
-	       ((uintptr_t)listen_clcsock->sk_user_data & ~SK_USER_DATA_NOCOPY);
 	if (!lsmc)
 		return;
 	lsmc->clcsk_data_ready(listen_clcsock);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index e6919fe31617..930544f7b2e2 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -129,6 +129,12 @@ enum smc_urg_state {
 	SMC_URG_READ	= 3,			/* data was already read */
 };
 
+struct smc_mark_woken {
+	bool woken;
+	void *key;
+	wait_queue_entry_t wait_entry;
+};
+
 struct smc_connection {
 	struct rb_node		alert_node;
 	struct smc_link_group	*lgr;		/* link group of connection */
@@ -217,8 +223,14 @@ struct smc_connection {
 struct smc_sock {				/* smc sock container */
 	struct sock		sk;
 	struct socket		*clcsock;	/* internal tcp socket */
+	void			(*clcsk_state_change)(struct sock *sk);
+						/* original stat_change fct. */
 	void			(*clcsk_data_ready)(struct sock *sk);
-						/* original data_ready fct. **/
+						/* original data_ready fct. */
+	void			(*clcsk_write_space)(struct sock *sk);
+						/* original write_space fct. */
+	void			(*clcsk_error_report)(struct sock *sk);
+						/* original error_report fct. */
 	struct smc_connection	conn;		/* smc connection */
 	struct smc_sock		*listen_smc;	/* listen parent */
 	struct work_struct	connect_work;	/* handle non-blocking connect*/
@@ -253,6 +265,12 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+static inline struct smc_sock *smc_clcsock_user_data(struct sock *clcsk)
+{
+	return (struct smc_sock *)
+	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
+}
+
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index 2ec6e5cd25d9..feb206f3acb4 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -152,6 +152,8 @@ static void cond_list_destroy(struct policydb *p)
 	for (i = 0; i < p->cond_list_len; i++)
 		cond_node_destroy(&p->cond_list[i]);
 	kfree(p->cond_list);
+	p->cond_list = NULL;
+	p->cond_list_len = 0;
 }
 
 void cond_policydb_destroy(struct policydb *p)
@@ -441,7 +443,6 @@ int cond_read_list(struct policydb *p, void *fp)
 	return 0;
 err:
 	cond_list_destroy(p);
-	p->cond_list = NULL;
 	return rc;
 }
 
diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
index 4a854475a0e6..500d0d474d27 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -985,7 +985,7 @@ void snd_hda_pick_fixup(struct hda_codec *codec,
 	int id = HDA_FIXUP_ID_NOT_SET;
 	const char *name = NULL;
 	const char *type = NULL;
-	int vendor, device;
+	unsigned int vendor, device;
 
 	if (codec->fixup_id != HDA_FIXUP_ID_NOT_SET)
 		return;
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 7016b48227bf..f552785d301e 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3000,6 +3000,10 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 {
 	struct hda_pcm *cpcm;
 
+	/* Skip the shutdown if codec is not registered */
+	if (!codec->registered)
+		return;
+
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
 
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 3bf5e3410703..fc114e522480 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -91,6 +91,12 @@ static void snd_hda_gen_spec_free(struct hda_gen_spec *spec)
 	free_kctls(spec);
 	snd_array_free(&spec->paths);
 	snd_array_free(&spec->loopback_list);
+#ifdef CONFIG_SND_HDA_GENERIC_LEDS
+	if (spec->led_cdevs[LED_AUDIO_MUTE])
+		led_classdev_unregister(spec->led_cdevs[LED_AUDIO_MUTE]);
+	if (spec->led_cdevs[LED_AUDIO_MICMUTE])
+		led_classdev_unregister(spec->led_cdevs[LED_AUDIO_MICMUTE]);
+#endif
 }
 
 /*
@@ -3922,7 +3928,10 @@ static int create_mute_led_cdev(struct hda_codec *codec,
 						enum led_brightness),
 				bool micmute)
 {
+	struct hda_gen_spec *spec = codec->spec;
 	struct led_classdev *cdev;
+	int idx = micmute ? LED_AUDIO_MICMUTE : LED_AUDIO_MUTE;
+	int err;
 
 	cdev = devm_kzalloc(&codec->core.dev, sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
@@ -3932,10 +3941,14 @@ static int create_mute_led_cdev(struct hda_codec *codec,
 	cdev->max_brightness = 1;
 	cdev->default_trigger = micmute ? "audio-micmute" : "audio-mute";
 	cdev->brightness_set_blocking = callback;
-	cdev->brightness = ledtrig_audio_get(micmute ? LED_AUDIO_MICMUTE : LED_AUDIO_MUTE);
+	cdev->brightness = ledtrig_audio_get(idx);
 	cdev->flags = LED_CORE_SUSPENDRESUME;
 
-	return devm_led_classdev_register(&codec->core.dev, cdev);
+	err = led_classdev_register(&codec->core.dev, cdev);
+	if (err < 0)
+		return err;
+	spec->led_cdevs[idx] = cdev;
+	return 0;
 }
 
 /**
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index c43bd0f0338e..362ddcaea15b 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -294,6 +294,9 @@ struct hda_gen_spec {
 				   struct hda_jack_callback *cb);
 	void (*mic_autoswitch_hook)(struct hda_codec *codec,
 				    struct hda_jack_callback *cb);
+
+	/* leds */
+	struct led_classdev *led_cdevs[NUM_AUDIO_LEDS];
 };
 
 /* values for add_stereo_mix_input flag */
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index fa80a79e9f96..18f04137f61c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -97,6 +97,7 @@ struct alc_spec {
 	unsigned int gpio_mic_led_mask;
 	struct alc_coef_led mute_led_coef;
 	struct alc_coef_led mic_led_coef;
+	struct mutex coef_mutex;
 
 	hda_nid_t headset_mic_pin;
 	hda_nid_t headphone_mic_pin;
@@ -132,8 +133,8 @@ struct alc_spec {
  * COEF access helper functions
  */
 
-static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
-			       unsigned int coef_idx)
+static int __alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				 unsigned int coef_idx)
 {
 	unsigned int val;
 
@@ -142,28 +143,61 @@ static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 	return val;
 }
 
+static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+			       unsigned int coef_idx)
+{
+	struct alc_spec *spec = codec->spec;
+	unsigned int val;
+
+	mutex_lock(&spec->coef_mutex);
+	val = __alc_read_coefex_idx(codec, nid, coef_idx);
+	mutex_unlock(&spec->coef_mutex);
+	return val;
+}
+
 #define alc_read_coef_idx(codec, coef_idx) \
 	alc_read_coefex_idx(codec, 0x20, coef_idx)
 
-static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
-				 unsigned int coef_idx, unsigned int coef_val)
+static void __alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				   unsigned int coef_idx, unsigned int coef_val)
 {
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_COEF_INDEX, coef_idx);
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PROC_COEF, coef_val);
 }
 
+static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				 unsigned int coef_idx, unsigned int coef_val)
+{
+	struct alc_spec *spec = codec->spec;
+
+	mutex_lock(&spec->coef_mutex);
+	__alc_write_coefex_idx(codec, nid, coef_idx, coef_val);
+	mutex_unlock(&spec->coef_mutex);
+}
+
 #define alc_write_coef_idx(codec, coef_idx, coef_val) \
 	alc_write_coefex_idx(codec, 0x20, coef_idx, coef_val)
 
+static void __alc_update_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
+				    unsigned int coef_idx, unsigned int mask,
+				    unsigned int bits_set)
+{
+	unsigned int val = __alc_read_coefex_idx(codec, nid, coef_idx);
+
+	if (val != -1)
+		__alc_write_coefex_idx(codec, nid, coef_idx,
+				       (val & ~mask) | bits_set);
+}
+
 static void alc_update_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				  unsigned int coef_idx, unsigned int mask,
 				  unsigned int bits_set)
 {
-	unsigned int val = alc_read_coefex_idx(codec, nid, coef_idx);
+	struct alc_spec *spec = codec->spec;
 
-	if (val != -1)
-		alc_write_coefex_idx(codec, nid, coef_idx,
-				     (val & ~mask) | bits_set);
+	mutex_lock(&spec->coef_mutex);
+	__alc_update_coefex_idx(codec, nid, coef_idx, mask, bits_set);
+	mutex_unlock(&spec->coef_mutex);
 }
 
 #define alc_update_coef_idx(codec, coef_idx, mask, bits_set)	\
@@ -196,13 +230,17 @@ struct coef_fw {
 static void alc_process_coef_fw(struct hda_codec *codec,
 				const struct coef_fw *fw)
 {
+	struct alc_spec *spec = codec->spec;
+
+	mutex_lock(&spec->coef_mutex);
 	for (; fw->nid; fw++) {
 		if (fw->mask == (unsigned short)-1)
-			alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
+			__alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
 		else
-			alc_update_coefex_idx(codec, fw->nid, fw->idx,
-					      fw->mask, fw->val);
+			__alc_update_coefex_idx(codec, fw->nid, fw->idx,
+						fw->mask, fw->val);
 	}
+	mutex_unlock(&spec->coef_mutex);
 }
 
 /*
@@ -1148,6 +1186,7 @@ static int alc_alloc_spec(struct hda_codec *codec, hda_nid_t mixer_nid)
 	codec->spdif_status_reset = 1;
 	codec->forced_resume = 1;
 	codec->patch_ops = alc_patch_ops;
+	mutex_init(&spec->coef_mutex);
 
 	err = alc_codec_rename_from_preset(codec);
 	if (err < 0) {
@@ -2120,6 +2159,7 @@ static void alc1220_fixup_gb_x570(struct hda_codec *codec,
 {
 	static const hda_nid_t conn1[] = { 0x0c };
 	static const struct coef_fw gb_x570_coefs[] = {
+		WRITE_COEF(0x07, 0x03c0),
 		WRITE_COEF(0x1a, 0x01c1),
 		WRITE_COEF(0x1b, 0x0202),
 		WRITE_COEF(0x43, 0x3005),
@@ -2546,7 +2586,8 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_GB_X570),
-	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_GB_X570),
+	SND_PCI_QUIRK(0x1458, 0xa0d5, "Gigabyte X570S Aorus Master", ALC1220_FIXUP_GB_X570),
 	SND_PCI_QUIRK(0x1462, 0x11f7, "MSI-GE63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1229, "MSI-GP73", ALC1220_FIXUP_CLEVO_P950),
@@ -2621,6 +2662,7 @@ static const struct hda_model_fixup alc882_fixup_models[] = {
 	{.id = ALC882_FIXUP_NO_PRIMARY_HP, .name = "no-primary-hp"},
 	{.id = ALC887_FIXUP_ASUS_BASS, .name = "asus-bass"},
 	{.id = ALC1220_FIXUP_GB_DUAL_CODECS, .name = "dual-codecs"},
+	{.id = ALC1220_FIXUP_GB_X570, .name = "gb-x570"},
 	{.id = ALC1220_FIXUP_CLEVO_P950, .name = "clevo-p950"},
 	{}
 };
@@ -8815,6 +8857,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),
diff --git a/sound/soc/codecs/cpcap.c b/sound/soc/codecs/cpcap.c
index 05bbacd0d174..f1c13f42e1c1 100644
--- a/sound/soc/codecs/cpcap.c
+++ b/sound/soc/codecs/cpcap.c
@@ -1667,6 +1667,8 @@ static int cpcap_codec_probe(struct platform_device *pdev)
 {
 	struct device_node *codec_node =
 		of_get_child_by_name(pdev->dev.parent->of_node, "audio-codec");
+	if (!codec_node)
+		return -ENODEV;
 
 	pdev->dev.of_node = codec_node;
 
diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index b61f980cabdc..b07607a9ecea 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -277,7 +277,7 @@ struct hdmi_codec_priv {
 	bool busy;
 	struct snd_soc_jack *jack;
 	unsigned int jack_status;
-	u8 iec_status[5];
+	u8 iec_status[AES_IEC958_STATUS_SIZE];
 };
 
 static const struct snd_soc_dapm_widget hdmi_widgets[] = {
diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 07894ec5e7a6..1c0409350e86 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -2688,8 +2688,8 @@ static uint32_t get_iir_band_coeff(struct snd_soc_component *component,
 	int reg, b2_reg;
 
 	/* Address does not automatically update if reading */
-	reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 16 * iir_idx;
-	b2_reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 16 * iir_idx;
+	reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 0x80 * iir_idx;
+	b2_reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 0x80 * iir_idx;
 
 	snd_soc_component_write(component, reg,
 				((band_idx * BAND_MAX + coeff_idx) *
@@ -2718,7 +2718,7 @@ static uint32_t get_iir_band_coeff(struct snd_soc_component *component,
 static void set_iir_band_coeff(struct snd_soc_component *component,
 			       int iir_idx, int band_idx, uint32_t value)
 {
-	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 16 * iir_idx;
+	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 0x80 * iir_idx;
 
 	snd_soc_component_write(component, reg, (value & 0xFF));
 	snd_soc_component_write(component, reg, (value >> 8) & 0xFF);
@@ -2739,7 +2739,7 @@ static int rx_macro_put_iir_band_audio_mixer(
 	int iir_idx = ctl->iir_idx;
 	int band_idx = ctl->band_idx;
 	u32 coeff[BAND_MAX];
-	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 16 * iir_idx;
+	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 0x80 * iir_idx;
 
 	memcpy(&coeff[0], ucontrol->value.bytes.data, params->max);
 
diff --git a/sound/soc/codecs/max9759.c b/sound/soc/codecs/max9759.c
index 00e9d4fd1651..0c261335c8a1 100644
--- a/sound/soc/codecs/max9759.c
+++ b/sound/soc/codecs/max9759.c
@@ -64,7 +64,8 @@ static int speaker_gain_control_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *c = snd_soc_kcontrol_component(kcontrol);
 	struct max9759 *priv = snd_soc_component_get_drvdata(c);
 
-	if (ucontrol->value.integer.value[0] > 3)
+	if (ucontrol->value.integer.value[0] < 0 ||
+	    ucontrol->value.integer.value[0] > 3)
 		return -EINVAL;
 
 	priv->gain = ucontrol->value.integer.value[0];
diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 67151c7770c6..bbc261ab2025 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -1432,14 +1432,10 @@ static int wcd938x_sdw_connect_port(struct wcd938x_sdw_ch_info *ch_info,
 	return 0;
 }
 
-static int wcd938x_connect_port(struct wcd938x_sdw_priv *wcd, u8 ch_id, u8 enable)
+static int wcd938x_connect_port(struct wcd938x_sdw_priv *wcd, u8 port_num, u8 ch_id, u8 enable)
 {
-	u8 port_num;
-
-	port_num = wcd->ch_info[ch_id].port_num;
-
 	return wcd938x_sdw_connect_port(&wcd->ch_info[ch_id],
-					&wcd->port_config[port_num],
+					&wcd->port_config[port_num - 1],
 					enable);
 }
 
@@ -2563,7 +2559,7 @@ static int wcd938x_ear_pa_put_gain(struct snd_kcontrol *kcontrol,
 				      WCD938X_EAR_GAIN_MASK,
 				      ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 static int wcd938x_get_compander(struct snd_kcontrol *kcontrol,
@@ -2593,6 +2589,7 @@ static int wcd938x_set_compander(struct snd_kcontrol *kcontrol,
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 	struct wcd938x_sdw_priv *wcd;
 	int value = ucontrol->value.integer.value[0];
+	int portidx;
 	struct soc_mixer_control *mc;
 	bool hphr;
 
@@ -2606,12 +2603,14 @@ static int wcd938x_set_compander(struct snd_kcontrol *kcontrol,
 	else
 		wcd938x->comp1_enable = value;
 
+	portidx = wcd->ch_info[mc->reg].port_num;
+
 	if (value)
-		wcd938x_connect_port(wcd, mc->reg, true);
+		wcd938x_connect_port(wcd, portidx, mc->reg, true);
 	else
-		wcd938x_connect_port(wcd, mc->reg, false);
+		wcd938x_connect_port(wcd, portidx, mc->reg, false);
 
-	return 0;
+	return 1;
 }
 
 static int wcd938x_ldoh_get(struct snd_kcontrol *kcontrol,
@@ -2882,9 +2881,11 @@ static int wcd938x_get_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd938x_sdw_priv *wcd;
 	struct soc_mixer_control *mixer = (struct soc_mixer_control *)kcontrol->private_value;
 	int dai_id = mixer->shift;
-	int portidx = mixer->reg;
+	int portidx, ch_idx = mixer->reg;
+
 
 	wcd = wcd938x->sdw_priv[dai_id];
+	portidx = wcd->ch_info[ch_idx].port_num;
 
 	ucontrol->value.integer.value[0] = wcd->port_enable[portidx];
 
@@ -2899,12 +2900,14 @@ static int wcd938x_set_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd938x_sdw_priv *wcd;
 	struct soc_mixer_control *mixer =
 		(struct soc_mixer_control *)kcontrol->private_value;
-	int portidx = mixer->reg;
+	int ch_idx = mixer->reg;
+	int portidx;
 	int dai_id = mixer->shift;
 	bool enable;
 
 	wcd = wcd938x->sdw_priv[dai_id];
 
+	portidx = wcd->ch_info[ch_idx].port_num;
 	if (ucontrol->value.integer.value[0])
 		enable = true;
 	else
@@ -2912,9 +2915,9 @@ static int wcd938x_set_swr_port(struct snd_kcontrol *kcontrol,
 
 	wcd->port_enable[portidx] = enable;
 
-	wcd938x_connect_port(wcd, portidx, enable);
+	wcd938x_connect_port(wcd, portidx, ch_idx, enable);
 
-	return 0;
+	return 1;
 
 }
 
diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index af3c3b90c0ac..83b4a22bf15a 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -93,16 +93,21 @@ static int pcm030_fabric_probe(struct platform_device *op)
 		dev_err(&op->dev, "platform_device_alloc() failed\n");
 
 	ret = platform_device_add(pdata->codec_device);
-	if (ret)
+	if (ret) {
 		dev_err(&op->dev, "platform_device_add() failed: %d\n", ret);
+		platform_device_put(pdata->codec_device);
+	}
 
 	ret = snd_soc_register_card(card);
-	if (ret)
+	if (ret) {
 		dev_err(&op->dev, "snd_soc_register_card() failed: %d\n", ret);
+		platform_device_del(pdata->codec_device);
+		platform_device_put(pdata->codec_device);
+	}
 
 	platform_set_drvdata(op, pdata);
-
 	return ret;
+
 }
 
 static int pcm030_fabric_remove(struct platform_device *op)
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index a3a7990b5cb6..bc3e24c6a28a 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -28,6 +28,30 @@ static const struct snd_soc_ops simple_ops = {
 	.hw_params	= asoc_simple_hw_params,
 };
 
+static int asoc_simple_parse_platform(struct device_node *node,
+				      struct snd_soc_dai_link_component *dlc)
+{
+	struct of_phandle_args args;
+	int ret;
+
+	if (!node)
+		return 0;
+
+	/*
+	 * Get node via "sound-dai = <&phandle port>"
+	 * it will be used as xxx_of_node on soc_bind_dai_link()
+	 */
+	ret = of_parse_phandle_with_args(node, DAI, CELL, 0, &args);
+	if (ret)
+		return ret;
+
+	/* dai_name is not required and may not exist for plat component */
+
+	dlc->of_node = args.np;
+
+	return 0;
+}
+
 static int asoc_simple_parse_dai(struct device_node *node,
 				 struct snd_soc_dai_link_component *dlc,
 				 int *is_single_link)
@@ -289,7 +313,7 @@ static int simple_dai_link_of(struct asoc_simple_priv *priv,
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	ret = asoc_simple_parse_dai(plat, platforms, NULL);
+	ret = asoc_simple_parse_platform(plat, platforms);
 	if (ret < 0)
 		goto dai_link_of_err;
 
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 08eaa9ddf191..dc0e7c8d31f3 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -316,13 +316,27 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	if (sign_bit)
 		mask = BIT(sign_bit + 1) - 1;
 
-	val = ((ucontrol->value.integer.value[0] + min) & mask);
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
+	val = (val + min) & mask;
 	if (invert)
 		val = max - val;
 	val_mask = mask << shift;
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val2 = ((ucontrol->value.integer.value[1] + min) & mask);
+		val2 = ucontrol->value.integer.value[1];
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max - min)
+			return -EINVAL;
+		if (val2 < 0)
+			return -EINVAL;
+		val2 = (val2 + min) & mask;
 		if (invert)
 			val2 = max - val2;
 		if (reg == reg2) {
@@ -409,8 +423,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	int err = 0;
 	unsigned int val, val_mask;
 
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
 	val_mask = mask << shift;
-	val = (ucontrol->value.integer.value[0] + min) & mask;
+	val = (val + min) & mask;
 	val = val << shift;
 
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
@@ -858,6 +879,8 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	long val = ucontrol->value.integer.value[0];
 	unsigned int i;
 
+	if (val < mc->min || val > mc->max)
+		return -EINVAL;
 	if (invert)
 		val = max - val;
 	val &= mask;
diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index 91afea9d5de6..ce19a6058b27 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -37,6 +37,7 @@
 #define XLNX_AUD_XFER_COUNT	0x28
 #define XLNX_AUD_CH_STS_START	0x2C
 #define XLNX_BYTES_PER_CH	0x44
+#define XLNX_AUD_ALIGN_BYTES	64
 
 #define AUD_STS_IOC_IRQ_MASK	BIT(31)
 #define AUD_STS_CH_STS_MASK	BIT(29)
@@ -368,12 +369,32 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	snd_soc_set_runtime_hwparams(substream, &xlnx_pcm_hardware);
 	runtime->private_data = stream_data;
 
-	/* Resize the period size divisible by 64 */
+	/* Resize the period bytes as divisible by 64 */
 	err = snd_pcm_hw_constraint_step(runtime, 0,
-					 SNDRV_PCM_HW_PARAM_PERIOD_BYTES, 64);
+					 SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
+					 XLNX_AUD_ALIGN_BYTES);
 	if (err) {
 		dev_err(component->dev,
-			"unable to set constraint on period bytes\n");
+			"Unable to set constraint on period bytes\n");
+		return err;
+	}
+
+	/* Resize the buffer bytes as divisible by 64 */
+	err = snd_pcm_hw_constraint_step(runtime, 0,
+					 SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+					 XLNX_AUD_ALIGN_BYTES);
+	if (err) {
+		dev_err(component->dev,
+			"Unable to set constraint on buffer bytes\n");
+		return err;
+	}
+
+	/* Set periods as integer multiple */
+	err = snd_pcm_hw_constraint_integer(runtime,
+					    SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0) {
+		dev_err(component->dev,
+			"Unable to set constraint on periods to be integer\n");
 		return err;
 	}
 
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 8e030b1c061a..567514832b0d 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1496,6 +1496,10 @@ static int get_connector_value(struct usb_mixer_elem_info *cval,
 		usb_audio_err(chip,
 			"cannot get connectors status: req = %#x, wValue = %#x, wIndex = %#x, type = %d\n",
 			UAC_GET_CUR, validx, idx, cval->val_type);
+
+		if (val)
+			*val = 0;
+
 		return filter_error(cval, ret);
 	}
 
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index b1522e43173e..0ea39565e623 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -84,7 +84,7 @@
  * combination.
  */
 {
-	USB_DEVICE(0x041e, 0x4095),
+	USB_AUDIO_DEVICE(0x041e, 0x4095),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_COMPOSITE,
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index bb9fa8de7e62..af9f9d3534c9 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -9,7 +9,11 @@ ifeq ($(V),1)
   msg =
 else
   Q = @
-  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  ifeq ($(silent),1)
+    msg =
+  else
+    msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  endif
   MAKEFLAGS=--no-print-directory
 endif
 
diff --git a/tools/include/uapi/sound/asound.h b/tools/include/uapi/sound/asound.h
index 5859ca0a1439..93e40f91bd49 100644
--- a/tools/include/uapi/sound/asound.h
+++ b/tools/include/uapi/sound/asound.h
@@ -56,8 +56,10 @@
  *                                                                          *
  ****************************************************************************/
 
+#define AES_IEC958_STATUS_SIZE		24
+
 struct snd_aes_iec958 {
-	unsigned char status[24];	/* AES/IEC958 channel status bits */
+	unsigned char status[AES_IEC958_STATUS_SIZE]; /* AES/IEC958 channel status bits */
 	unsigned char subcode[147];	/* AES/IEC958 subcode bits */
 	unsigned char pad;		/* nothing */
 	unsigned char dig_subframe[4];	/* AES/IEC958 subframe bits */
diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 588601000f3f..db00ca6a67de 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -584,15 +584,16 @@ static void collect_all_aliases(struct perf_stat_config *config, struct evsel *c
 
 	alias = list_prepare_entry(counter, &(evlist->core.entries), core.node);
 	list_for_each_entry_continue (alias, &evlist->core.entries, core.node) {
-		if (strcmp(evsel__name(alias), evsel__name(counter)) ||
-		    alias->scale != counter->scale ||
-		    alias->cgrp != counter->cgrp ||
-		    strcmp(alias->unit, counter->unit) ||
-		    evsel__is_clock(alias) != evsel__is_clock(counter) ||
-		    !strcmp(alias->pmu_name, counter->pmu_name))
-			break;
-		alias->merged_stat = true;
-		cb(config, alias, data, false);
+		/* Merge events with the same name, etc. but on different PMUs. */
+		if (!strcmp(evsel__name(alias), evsel__name(counter)) &&
+			alias->scale == counter->scale &&
+			alias->cgrp == counter->cgrp &&
+			!strcmp(alias->unit, counter->unit) &&
+			evsel__is_clock(alias) == evsel__is_clock(counter) &&
+			strcmp(alias->pmu_name, counter->pmu_name)) {
+			alias->merged_stat = true;
+			cb(config, alias, data, false);
+		}
 	}
 }
 
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index dd61118df66e..12c5e27d32c1 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -D_GNU_SOURCE
 
 TEST_PROGS := binfmt_script non-regular
 TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216
-TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir pipe
+TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
 
diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/selftests/futex/Makefile
index 12631f0076a1..11e157d7533b 100644
--- a/tools/testing/selftests/futex/Makefile
+++ b/tools/testing/selftests/futex/Makefile
@@ -11,7 +11,7 @@ all:
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 		if [ -e $$DIR/$(TEST_PROGS) ]; then \
 			rsync -a $$DIR/$(TEST_PROGS) $$BUILD_TARGET/; \
 		fi \
@@ -32,6 +32,6 @@ override define CLEAN
 	@for DIR in $(SUBDIRS); do		\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;	\
 		mkdir $$BUILD_TARGET  -p;	\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;\
 	done
 endef
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index 5a4938d6dcf2..9313fa32bef1 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add"
+BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -337,6 +337,23 @@ TYPE_flush_remove_add="
 display		Add two elements, flush, re-add
 "
 
+TYPE_reload="
+display		net,mac with reload
+type_spec	ipv4_addr . ether_addr
+chain_spec	ip daddr . ether saddr
+dst		addr4
+src		mac
+start		1
+count		1
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1455,6 +1472,59 @@ test_bug_flush_remove_add() {
 	nft flush ruleset
 }
 
+# - add ranged element, check that packets match it
+# - reload the set, check packets still match
+test_bug_reload() {
+	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	rstart=${start}
+
+	range_size=1
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		add "$(format)" || return 1
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	# check kernel does allocate pcpu sctrach map
+	# for reload with no elemet add/delete
+	( echo flush set inet filter test ;
+	  nft list set inet filter test ) | nft -f -
+
+	start=${rstart}
+	range_size=1
+
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_match "${j}" $((j + src_delta)) || return 1
+		done
+
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	nft flush ruleset
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index da1c1e4b6c86..781fa2d9ea9d 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -885,6 +885,144 @@ EOF
 	ip netns exec "$ns0" nft delete table $family nat
 }
 
+test_stateless_nat_ip()
+{
+	local lret=0
+
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 before loading stateless rules"
+		return 1
+	fi
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table ip stateless {
+	map xlate_in {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth1" . 10.0.2.99 . 10.0.1.99 : 10.0.2.2,
+		}
+	}
+	map xlate_out {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth0" . 10.0.1.99 . 10.0.2.2 : 10.0.2.99
+		}
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr set meta iifname . ip saddr . ip daddr map @xlate_in
+		ip daddr set meta iifname . ip saddr . ip daddr map @xlate_out
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add ip statless rules"
+		return $ksft_skip
+	fi
+
+	reset_counters
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 with stateless rules"
+		lret=1
+	fi
+
+	# ns1 should have seen packets from .2.2, due to stateless rewrite.
+	expect="packets 1 bytes 84"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 1"
+		lret=1
+	fi
+
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns2" ns1$dir "$expect" "test_stateless 2"
+			lret=1
+		fi
+	done
+
+	# ns1 should not have seen packets from ns2, due to masquerade
+	expect="packets 0 bytes 0"
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns1" ns0$dir "$expect" "test_stateless 3"
+			lret=1
+		fi
+
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns0" ns1$dir "$expect" "test_stateless 4"
+			lret=1
+		fi
+	done
+
+	reset_counters
+
+	socat -h > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run stateless nat frag test without socat tool"
+		if [ $lret -eq 0 ]; then
+			return $ksft_skip
+		fi
+
+		ip netns exec "$ns0" nft delete table ip stateless
+		return $lret
+	fi
+
+	local tmpfile=$(mktemp)
+	dd if=/dev/urandom of=$tmpfile bs=4096 count=1 2>/dev/null
+
+	local outfile=$(mktemp)
+	ip netns exec "$ns1" timeout 3 socat -u UDP4-RECV:4233 OPEN:$outfile < /dev/null &
+	sc_r=$!
+
+	sleep 1
+	# re-do with large ping -> ip fragmentation
+	ip netns exec "$ns2" timeout 3 socat - UDP4-SENDTO:"10.0.1.99:4233" < "$tmpfile" > /dev/null
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: failed to test udp $ns1 to $ns2 with stateless ip nat" 1>&2
+		lret=1
+	fi
+
+	wait
+
+	cmp "$tmpfile" "$outfile"
+	if [ $? -ne 0 ]; then
+		ls -l "$tmpfile" "$outfile"
+		echo "ERROR: in and output file mismatch when checking udp with stateless nat" 1>&2
+		lret=1
+	fi
+
+	rm -f "$tmpfile" "$outfile"
+
+	# ns1 should have seen packets from 2.2, due to stateless rewrite.
+	expect="packets 3 bytes 4164"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 5"
+		lret=1
+	fi
+
+	ip netns exec "$ns0" nft delete table ip stateless
+	if [ $? -ne 0 ]; then
+		echo "ERROR: Could not delete table ip stateless" 1>&2
+		lret=1
+	fi
+
+	test $lret -eq 0 && echo "PASS: IP statless for $ns2"
+
+	return $lret
+}
+
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in 0 1 2; do
 ip netns exec ns$i-$sfx nft -f /dev/stdin <<EOF
@@ -951,6 +1089,19 @@ table inet filter {
 EOF
 done
 
+# special case for stateless nat check, counter needs to
+# be done before (input) ip defragmentation
+ip netns exec ns1-$sfx nft -f /dev/stdin <<EOF
+table inet filter {
+	counter ns0insl {}
+
+	chain pre {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr 10.0.2.2 counter name "ns0insl"
+	}
+}
+EOF
+
 sleep 3
 # test basic connectivity
 for i in 1 2; do
@@ -1005,6 +1156,7 @@ $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
 test_port_shadowing
+test_stateless_nat_ip
 
 if [ $ret -ne 0 ];then
 	echo -n "FAIL: "
