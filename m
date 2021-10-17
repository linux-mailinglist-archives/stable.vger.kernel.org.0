Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D843075B
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245130AbhJQIu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 04:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245134AbhJQIuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 04:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C88660F44;
        Sun, 17 Oct 2021 08:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634460490;
        bh=VLR9VekzDEUnZkWcj9IsvLHGhSQUY0UaNovDBeZzO3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeixPiTywyz2I/KcM5H41TaMLHRKnJMyIMjrsLIEzSKXR6VcJi43PRbKSr44ouN3E
         plJuj4NwAvgCA7kWj0avGFN+sJrhmxfDvwIu3EHJwrHUBdPHQ8DTod4ryZS4orZjII
         q2Z3JuDIPwlVoBIIkhghP4VXLxu1OZJUCrldDRMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.251
Date:   Sun, 17 Oct 2021 10:48:01 +0200
Message-Id: <163446048011108@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <1634460480217245@kroah.com>
References: <1634460480217245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 7fed41bc6a4f..184089eb1bdb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 250
+SUBLEVEL = 251
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
index 908951eb5943..e4ee935f7b38 100644
--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -104,7 +104,7 @@
 
 	nand@1,0 {
 		compatible = "ti,omap2-nand";
-		reg = <0 0 4>; /* CS0, offset 0, IO size 4 */
+		reg = <1 0 4>; /* CS1, offset 0, IO size 4 */
 		interrupt-parent = <&gpmc>;
 		interrupts = <0 IRQ_TYPE_NONE>, /* fifoevent */
 			     <1 IRQ_TYPE_NONE>;	/* termcount */
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index eef243998392..459358b54ab4 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1114,7 +1114,7 @@
 		};
 
 		gpu: adreno-3xx@4300000 {
-			compatible = "qcom,adreno-3xx";
+			compatible = "qcom,adreno-320.2", "qcom,adreno";
 			reg = <0x04300000 0x20000>;
 			reg-names = "kgsl_3d0_reg_memory";
 			interrupts = <GIC_SPI 80 0>;
@@ -1129,7 +1129,6 @@
 			    <&mmcc GFX3D_AHB_CLK>,
 			    <&mmcc GFX3D_AXI_CLK>,
 			    <&mmcc MMSS_IMEM_AHB_CLK>;
-			qcom,chipid = <0x03020002>;
 
 			iommus = <&gfx3d 0
 				  &gfx3d 1
diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index c7dcb0b20730..5182b04ac878 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/genalloc.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of.h>
@@ -608,6 +609,7 @@ static void __init imx6_pm_common_init(const struct imx6_pm_socdata
 
 static void imx6_pm_stby_poweroff(void)
 {
+	gic_cpu_if_down(0);
 	imx6_set_lpm(STOP_POWER_OFF);
 	imx6q_suspend_finish(0);
 
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index e79421f5b9cd..20a3ff41d0d5 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -448,7 +448,7 @@ static inline void save_fpu_state(struct sigcontext *sc, struct pt_regs *regs)
 
 	if (CPU_IS_060 ? sc->sc_fpstate[2] : sc->sc_fpstate[0]) {
 		fpu_version = sc->sc_fpstate[0];
-		if (CPU_IS_020_OR_030 &&
+		if (CPU_IS_020_OR_030 && !regs->stkadj &&
 		    regs->vector >= (VEC_FPBRUC * 4) &&
 		    regs->vector <= (VEC_FPNAN * 4)) {
 			/* Clear pending exception in 68882 idle frame */
@@ -511,7 +511,7 @@ static inline int rt_save_fpu_state(struct ucontext __user *uc, struct pt_regs *
 		if (!(CPU_IS_060 || CPU_IS_COLDFIRE))
 			context_size = fpstate[1];
 		fpu_version = fpstate[0];
-		if (CPU_IS_020_OR_030 &&
+		if (CPU_IS_020_OR_030 && !regs->stkadj &&
 		    regs->vector >= (VEC_FPBRUC * 4) &&
 		    regs->vector <= (VEC_FPNAN * 4)) {
 			/* Clear pending exception in 68882 idle frame */
@@ -765,18 +765,24 @@ asmlinkage int do_rt_sigreturn(struct pt_regs *regs, struct switch_stack *sw)
 	return 0;
 }
 
+static inline struct pt_regs *rte_regs(struct pt_regs *regs)
+{
+	return (void *)regs + regs->stkadj;
+}
+
 static void setup_sigcontext(struct sigcontext *sc, struct pt_regs *regs,
 			     unsigned long mask)
 {
+	struct pt_regs *tregs = rte_regs(regs);
 	sc->sc_mask = mask;
 	sc->sc_usp = rdusp();
 	sc->sc_d0 = regs->d0;
 	sc->sc_d1 = regs->d1;
 	sc->sc_a0 = regs->a0;
 	sc->sc_a1 = regs->a1;
-	sc->sc_sr = regs->sr;
-	sc->sc_pc = regs->pc;
-	sc->sc_formatvec = regs->format << 12 | regs->vector;
+	sc->sc_sr = tregs->sr;
+	sc->sc_pc = tregs->pc;
+	sc->sc_formatvec = tregs->format << 12 | tregs->vector;
 	save_a5_state(sc, regs);
 	save_fpu_state(sc, regs);
 }
@@ -784,6 +790,7 @@ static void setup_sigcontext(struct sigcontext *sc, struct pt_regs *regs,
 static inline int rt_setup_ucontext(struct ucontext __user *uc, struct pt_regs *regs)
 {
 	struct switch_stack *sw = (struct switch_stack *)regs - 1;
+	struct pt_regs *tregs = rte_regs(regs);
 	greg_t __user *gregs = uc->uc_mcontext.gregs;
 	int err = 0;
 
@@ -804,9 +811,9 @@ static inline int rt_setup_ucontext(struct ucontext __user *uc, struct pt_regs *
 	err |= __put_user(sw->a5, &gregs[13]);
 	err |= __put_user(sw->a6, &gregs[14]);
 	err |= __put_user(rdusp(), &gregs[15]);
-	err |= __put_user(regs->pc, &gregs[16]);
-	err |= __put_user(regs->sr, &gregs[17]);
-	err |= __put_user((regs->format << 12) | regs->vector, &uc->uc_formatvec);
+	err |= __put_user(tregs->pc, &gregs[16]);
+	err |= __put_user(tregs->sr, &gregs[17]);
+	err |= __put_user((tregs->format << 12) | tregs->vector, &uc->uc_formatvec);
 	err |= rt_save_fpu_state(uc, regs);
 	return err;
 }
@@ -823,13 +830,14 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 			struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int fsize = frame_extra_sizes(regs->format);
+	struct pt_regs *tregs = rte_regs(regs);
+	int fsize = frame_extra_sizes(tregs->format);
 	struct sigcontext context;
 	int err = 0, sig = ksig->sig;
 
 	if (fsize < 0) {
 		pr_debug("setup_frame: Unknown frame format %#x\n",
-			 regs->format);
+			 tregs->format);
 		return -EFAULT;
 	}
 
@@ -840,7 +848,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 
 	err |= __put_user(sig, &frame->sig);
 
-	err |= __put_user(regs->vector, &frame->code);
+	err |= __put_user(tregs->vector, &frame->code);
 	err |= __put_user(&frame->sc, &frame->psc);
 
 	if (_NSIG_WORDS > 1)
@@ -865,34 +873,28 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 
 	push_cache ((unsigned long) &frame->retcode);
 
-	/*
-	 * Set up registers for signal handler.  All the state we are about
-	 * to destroy is successfully copied to sigframe.
-	 */
-	wrusp ((unsigned long) frame);
-	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
-	adjustformat(regs);
-
 	/*
 	 * This is subtle; if we build more than one sigframe, all but the
 	 * first one will see frame format 0 and have fsize == 0, so we won't
 	 * screw stkadj.
 	 */
-	if (fsize)
+	if (fsize) {
 		regs->stkadj = fsize;
-
-	/* Prepare to skip over the extra stuff in the exception frame.  */
-	if (regs->stkadj) {
-		struct pt_regs *tregs =
-			(struct pt_regs *)((ulong)regs + regs->stkadj);
+		tregs = rte_regs(regs);
 		pr_debug("Performing stackadjust=%04lx\n", regs->stkadj);
-		/* This must be copied with decreasing addresses to
-                   handle overlaps.  */
 		tregs->vector = 0;
 		tregs->format = 0;
-		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
+
+	/*
+	 * Set up registers for signal handler.  All the state we are about
+	 * to destroy is successfully copied to sigframe.
+	 */
+	wrusp ((unsigned long) frame);
+	tregs->pc = (unsigned long) ksig->ka.sa.sa_handler;
+	adjustformat(regs);
+
 	return 0;
 }
 
@@ -900,7 +902,8 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			   struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int fsize = frame_extra_sizes(regs->format);
+	struct pt_regs *tregs = rte_regs(regs);
+	int fsize = frame_extra_sizes(tregs->format);
 	int err = 0, sig = ksig->sig;
 
 	if (fsize < 0) {
@@ -949,34 +952,27 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 
 	push_cache ((unsigned long) &frame->retcode);
 
-	/*
-	 * Set up registers for signal handler.  All the state we are about
-	 * to destroy is successfully copied to sigframe.
-	 */
-	wrusp ((unsigned long) frame);
-	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
-	adjustformat(regs);
-
 	/*
 	 * This is subtle; if we build more than one sigframe, all but the
 	 * first one will see frame format 0 and have fsize == 0, so we won't
 	 * screw stkadj.
 	 */
-	if (fsize)
+	if (fsize) {
 		regs->stkadj = fsize;
-
-	/* Prepare to skip over the extra stuff in the exception frame.  */
-	if (regs->stkadj) {
-		struct pt_regs *tregs =
-			(struct pt_regs *)((ulong)regs + regs->stkadj);
+		tregs = rte_regs(regs);
 		pr_debug("Performing stackadjust=%04lx\n", regs->stkadj);
-		/* This must be copied with decreasing addresses to
-                   handle overlaps.  */
 		tregs->vector = 0;
 		tregs->format = 0;
-		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
+
+	/*
+	 * Set up registers for signal handler.  All the state we are about
+	 * to destroy is successfully copied to sigframe.
+	 */
+	wrusp ((unsigned long) frame);
+	tregs->pc = (unsigned long) ksig->ka.sa.sa_handler;
+	adjustformat(regs);
 	return 0;
 }
 
diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 4d8cb9bb8365..43e6597c720c 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -662,6 +662,11 @@ static void build_epilogue(struct jit_ctx *ctx)
 	((int)K < 0 ? ((int)K >= SKF_LL_OFF ? func##_negative : func) : \
 	 func##_positive)
 
+static bool is_bad_offset(int b_off)
+{
+	return b_off > 0x1ffff || b_off < -0x20000;
+}
+
 static int build_body(struct jit_ctx *ctx)
 {
 	const struct bpf_prog *prog = ctx->skf;
@@ -728,7 +733,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load return register on DS for failures */
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* Return with error */
-			emit_b(b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_LD | BPF_W | BPF_IND:
@@ -775,8 +783,10 @@ static int build_body(struct jit_ctx *ctx)
 			emit_jalr(MIPS_R_RA, r_s0, ctx);
 			emit_reg_move(MIPS_R_A0, r_skb, ctx); /* delay slot */
 			/* Check the error value */
-			emit_bcond(MIPS_COND_NE, r_ret, 0,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_NE, r_ret, 0, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* We are good */
 			/* X <- P[1:K] & 0xf */
@@ -855,8 +865,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A /= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_div(r_A, r_X, ctx);
 			break;
@@ -864,8 +876,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A %= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_mod(r_A, r_X, ctx);
 			break;
@@ -926,7 +940,10 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_JMP | BPF_JA:
 			/* pc += K */
-			emit_b(b_imm(i + k + 1, ctx), ctx);
+			b_off = b_imm(i + k + 1, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_JMP | BPF_JEQ | BPF_K:
@@ -1056,12 +1073,16 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_RET | BPF_A:
 			ctx->flags |= SEEN_A;
-			if (i != prog->len - 1)
+			if (i != prog->len - 1) {
 				/*
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
+			}
 			emit_reg_move(r_ret, r_A, ctx); /* delay slot */
 			break;
 		case BPF_RET | BPF_K:
@@ -1075,7 +1096,10 @@ static int build_body(struct jit_ctx *ctx)
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
 				emit_nop(ctx);
 			}
 			break;
@@ -1133,8 +1157,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load *dev pointer */
 			emit_load_ptr(r_s0, r_skb, off, ctx);
 			/* error (0) in the delay slot */
-			emit_bcond(MIPS_COND_EQ, r_s0, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_s0, r_zero, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			if (code == (BPF_ANC | SKF_AD_IFINDEX)) {
 				BUILD_BUG_ON(FIELD_SIZEOF(struct net_device, ifindex) != 4);
@@ -1244,7 +1270,10 @@ void bpf_jit_compile(struct bpf_prog *fp)
 
 	/* Generate the actual JIT code */
 	build_prologue(&ctx);
-	build_body(&ctx);
+	if (build_body(&ctx)) {
+		module_memfree(ctx.target);
+		goto out;
+	}
 	build_epilogue(&ctx);
 
 	/* Update the icache */
diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
index 5ba6fbfca274..f82f85c65964 100644
--- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
@@ -154,7 +154,7 @@
 
 			fm1mac3: ethernet@e4000 {
 				phy-handle = <&sgmii_aqr_phy3>;
-				phy-connection-type = "sgmii-2500";
+				phy-connection-type = "2500base-x";
 				sleep = <&rcpm 0x20000000>;
 			};
 
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index c1f7b3cb84a9..39c298afa2ea 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2094,6 +2094,7 @@ static int x86_pmu_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
+		event->destroy = NULL;
 	}
 
 	if (ACCESS_ONCE(x86_pmu.attr_rdpmc))
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 18e4ef34ac45..4182189b29de 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -145,7 +145,7 @@ unsigned xtensa_get_ext_irq_no(unsigned irq)
 
 void __init init_IRQ(void)
 {
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 	irqchip_init();
 #else
 #ifdef CONFIG_HAVE_SMP
diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 4561a786fab0..cce4833a6083 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -185,6 +185,7 @@ static const struct file_operations nouveau_pstate_fops = {
 	.open = nouveau_debugfs_pstate_open,
 	.read = seq_read,
 	.write = nouveau_debugfs_pstate_set,
+	.release = single_release,
 };
 
 static struct drm_info_list nouveau_debugfs_list[] = {
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index b58ab769aa7b..4e3dd3f55a96 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -304,12 +304,19 @@ static int apple_event(struct hid_device *hdev, struct hid_field *field,
 
 /*
  * MacBook JIS keyboard has wrong logical maximum
+ * Magic Keyboard JIS has wrong logical maximum
  */
 static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	struct apple_sc *asc = hid_get_drvdata(hdev);
 
+	if(*rsize >=71 && rdesc[70] == 0x65 && rdesc[64] == 0x65) {
+		hid_info(hdev,
+			 "fixing up Magic Keyboard JIS report descriptor\n");
+		rdesc[64] = rdesc[70] = 0xe7;
+	}
+
 	if ((asc->quirks & APPLE_RDESC_JIS) && *rsize >= 60 &&
 			rdesc[53] == 0x65 && rdesc[59] == 0x65) {
 		hid_info(hdev,
diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 52ae674ebf5b..6f42856c1507 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -395,6 +395,7 @@ static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
 			break;
 
 		i2c_acpi_register_device(adapter, adev, &info);
+		put_device(&adapter->dev);
 		break;
 	case ACPI_RECONFIG_DEVICE_REMOVE:
 		if (!acpi_device_enumerated(adev))
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 65c17e39c405..1555d32ddb96 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6958,7 +6958,7 @@ static int i40e_get_capabilities(struct i40e_pf *pf)
 		if (pf->hw.aq.asq_last_status == I40E_AQ_RC_ENOMEM) {
 			/* retry with a larger buffer */
 			buf_len = data_size;
-		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK) {
+		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK || err) {
 			dev_info(&pf->pdev->dev,
 				 "capability discovery failed, err %s aq_err %s\n",
 				 i40e_stat_str(&pf->hw, err),
diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index b2caf5132bd2..eea4179e63eb 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -72,6 +72,7 @@ config CASSINI
 config SUNVNET_COMMON
 	tristate "Common routines to support Sun Virtual Networking"
 	depends on SUN_LDOMS
+	depends on INET
 	default m
 
 config SUNVNET
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 3c5b2a2e2fcc..11f5a7116adb 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -30,7 +30,12 @@
 #define MII_BCM7XXX_SHD_2_ADDR_CTRL	0xe
 #define MII_BCM7XXX_SHD_2_CTRL_STAT	0xf
 #define MII_BCM7XXX_SHD_2_BIAS_TRIM	0x1a
+#define MII_BCM7XXX_SHD_3_PCS_CTRL	0x0
+#define MII_BCM7XXX_SHD_3_PCS_STATUS	0x1
+#define MII_BCM7XXX_SHD_3_EEE_CAP	0x2
 #define MII_BCM7XXX_SHD_3_AN_EEE_ADV	0x3
+#define MII_BCM7XXX_SHD_3_EEE_LP	0x4
+#define MII_BCM7XXX_SHD_3_EEE_WK_ERR	0x5
 #define MII_BCM7XXX_SHD_3_PCS_CTRL_2	0x6
 #define  MII_BCM7XXX_PCS_CTRL_2_DEF	0x4400
 #define MII_BCM7XXX_SHD_3_AN_STAT	0xb
@@ -462,6 +467,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+#define MII_BCM7XXX_REG_INVALID	0xff
+
+static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
+{
+	switch (regnum) {
+	case MDIO_CTRL1:
+		return MII_BCM7XXX_SHD_3_PCS_CTRL;
+	case MDIO_STAT1:
+		return MII_BCM7XXX_SHD_3_PCS_STATUS;
+	case MDIO_PCS_EEE_ABLE:
+		return MII_BCM7XXX_SHD_3_EEE_CAP;
+	case MDIO_AN_EEE_ADV:
+		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
+	case MDIO_AN_EEE_LPABLE:
+		return MII_BCM7XXX_SHD_3_EEE_LP;
+	case MDIO_PCS_EEE_WK_ERR:
+		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
+	default:
+		return MII_BCM7XXX_REG_INVALID;
+	}
+}
+
+static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
+{
+	return devnum == MDIO_MMD_AN || devnum == MDIO_MMD_PCS;
+}
+
+static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
+				      int devnum, u16 regnum)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	ret = phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+			 MII_BCM7XXX_SHD_MODE_2);
+	return ret;
+}
+
+static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
+				       int devnum, u16 regnum, u16 val)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	/* Write the desired value in the shadow register */
+	phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	return phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+				MII_BCM7XXX_SHD_MODE_2);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -637,6 +729,8 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5fc7b6c1a442..5ef9bbbab3db 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -344,6 +344,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	/* We need to set state to MDIOBUS_UNREGISTERED to correctly release
+	 * the device in mdiobus_free()
+	 *
+	 * State will be updated later in this function in case of success
+	 */
+	bus->state = MDIOBUS_UNREGISTERED;
+
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index b3285175f20f..8461d7f92d31 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -698,6 +698,7 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	 },
 	{0}
 };
+MODULE_DEVICE_TABLE(pci, pch_ieee1588_pcidev_id);
 
 static struct pci_driver pch_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 4b993607887c..84b234bbd07d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -134,7 +134,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	u32 result;
+	int result;
 
 	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1f4bd7d0154d..2839701ffab5 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -336,7 +336,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -389,7 +389,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 		virtscsi_handle_param_change(vscsi, event);
 		break;
 	default:
-		pr_err("Unsupport virtio scsi event %x\n", event->event);
+		pr_err("Unsupported virtio scsi event %x\n", event->event);
 	}
 	virtscsi_kick_event(vscsi, event_node);
 }
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 72eb3e41e3b6..5923ebcffcdf 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -174,8 +174,7 @@ source "drivers/usb/typec/Kconfig"
 
 config USB_LED_TRIG
 	bool "USB LED Triggers"
-	depends on LEDS_CLASS && LEDS_TRIGGERS
-	select USB_COMMON
+	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
 	help
 	  This option adds LED triggers for USB host and/or gadget activity.
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index bd9a11782e15..c653635ce5c2 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -351,6 +351,9 @@ static void acm_process_notification(struct acm *acm, unsigned char *buf)
 			acm->iocount.overrun++;
 		spin_unlock(&acm->read_lock);
 
+		if (newctrl & ACM_CTRL_BRK)
+			tty_flip_buffer_push(&acm->port);
+
 		if (difference)
 			wake_up_all(&acm->wioctl);
 
@@ -486,11 +489,16 @@ static int acm_submit_read_urbs(struct acm *acm, gfp_t mem_flags)
 
 static void acm_process_read_urb(struct acm *acm, struct urb *urb)
 {
+	unsigned long flags;
+
 	if (!urb->actual_length)
 		return;
 
+	spin_lock_irqsave(&acm->read_lock, flags);
 	tty_insert_flip_string(&acm->port, urb->transfer_buffer,
 			urb->actual_length);
+	spin_unlock_irqrestore(&acm->read_lock, flags);
+
 	tty_flip_buffer_push(&acm->port);
 }
 
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a697c64a6506..92bb71c040f9 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -571,12 +571,12 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 }
 
 /*
- * Stop waiting if either state is not BP_EAGAIN and ballooning action is
- * needed, or if the credit has changed while state is BP_EAGAIN.
+ * Stop waiting if either state is BP_DONE and ballooning action is
+ * needed, or if the credit has changed while state is not BP_DONE.
  */
 static bool balloon_thread_cond(enum bp_state state, long credit)
 {
-	if (state != BP_EAGAIN)
+	if (state == BP_DONE)
 		credit = 0;
 
 	return current_credit() != credit || kthread_should_stop();
@@ -596,10 +596,19 @@ static int balloon_thread(void *unused)
 
 	set_freezable();
 	for (;;) {
-		if (state == BP_EAGAIN)
-			timeout = balloon_stats.schedule_delay * HZ;
-		else
+		switch (state) {
+		case BP_DONE:
+		case BP_ECANCELED:
 			timeout = 3600 * HZ;
+			break;
+		case BP_EAGAIN:
+			timeout = balloon_stats.schedule_delay * HZ;
+			break;
+		case BP_WAIT:
+			timeout = HZ;
+			break;
+		}
+
 		credit = current_credit();
 
 		wait_event_freezable_timeout(balloon_thread_wq,
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c1e923334012..2e7349b2dd4d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3082,15 +3082,18 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 		goto fail;
 	cd->rd_maxcount -= entry_bytes;
 	/*
-	 * RFC 3530 14.2.24 describes rd_dircount as only a "hint", so
-	 * let's always let through the first entry, at least:
+	 * RFC 3530 14.2.24 describes rd_dircount as only a "hint", and
+	 * notes that it could be zero. If it is zero, then the server
+	 * should enforce only the rd_maxcount value.
 	 */
-	if (!cd->rd_dircount)
-		goto fail;
-	name_and_cookie = 4 + 4 * XDR_QUADLEN(namlen) + 8;
-	if (name_and_cookie > cd->rd_dircount && cd->cookie_offset)
-		goto fail;
-	cd->rd_dircount -= min(cd->rd_dircount, name_and_cookie);
+	if (cd->rd_dircount) {
+		name_and_cookie = 4 + 4 * XDR_QUADLEN(namlen) + 8;
+		if (name_and_cookie > cd->rd_dircount && cd->cookie_offset)
+			goto fail;
+		cd->rd_dircount -= min(cd->rd_dircount, name_and_cookie);
+		if (!cd->rd_dircount)
+			cd->rd_maxcount = 0;
+	}
 
 	cd->cookie_offset = cookie_offset;
 skip_entry:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5bdc85ad13a2..4869fa508616 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1032,9 +1032,13 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 				goto out_dput;
 		}
 	} else {
-		if (!d_is_negative(newdentry) &&
-		    (!new_opaque || !ovl_is_whiteout(newdentry)))
-			goto out_dput;
+		if (!d_is_negative(newdentry)) {
+			if (!new_opaque || !ovl_is_whiteout(newdentry))
+				goto out_dput;
+		} else {
+			if (flags & RENAME_EXCHANGE)
+				goto out_dput;
+		}
 	}
 
 	if (olddentry == trap)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 99650f05c271..914cc8b180ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1390,7 +1390,7 @@ extern struct pid *cad_pid;
 #define tsk_used_math(p)			((p)->flags & PF_USED_MATH)
 #define used_math()				tsk_used_math(current)
 
-static inline bool is_percpu_thread(void)
+static __always_inline bool is_percpu_thread(void)
 {
 #ifdef CONFIG_SMP
 	return (current->flags & PF_NO_SETAFFINITY) &&
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1d4c3fba0f8c..099dc780a92f 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -28,7 +28,8 @@ struct bpf_stack_map {
 
 static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 {
-	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
+	u64 elem_size = sizeof(struct stack_map_bucket) +
+			(u64)smap->map.value_size;
 	int err;
 
 	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 9a8f957ad86e..724674c421ca 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -355,6 +355,52 @@ static int bpf_fill_maxinsns11(struct bpf_test *self)
 	return __bpf_fill_ja(self, BPF_MAXINSNS, 68);
 }
 
+static int bpf_fill_maxinsns12(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[0] = __BPF_JUMP(BPF_JMP | BPF_JA, len - 2, 0, 0);
+
+	for (i = 1; i < len - 1; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_K, 0xabababab);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
+static int bpf_fill_maxinsns13(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	for (i = 0; i < len - 3; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 3] = __BPF_STMT(BPF_LD | BPF_IMM, 0xabababab);
+	insn[len - 2] = __BPF_STMT(BPF_ALU | BPF_XOR | BPF_X, 0);
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_A, 0);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
 static int bpf_fill_ja(struct bpf_test *self)
 {
 	/* Hits exactly 11 passes on x86_64 JIT. */
@@ -5437,6 +5483,23 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_maxinsns11,
 		.expected_errcode = -ENOTSUPP,
 	},
+	{
+		"BPF_MAXINSNS: jump over MSH",
+		{ },
+		CLASSIC | FLAG_EXPECTED_FAIL,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xabababab } },
+		.fill_helper = bpf_fill_maxinsns12,
+		.expected_errcode = -EINVAL,
+	},
+	{
+		"BPF_MAXINSNS: exec all MSH",
+		{ },
+		CLASSIC,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xababab83 } },
+		.fill_helper = bpf_fill_maxinsns13,
+	},
 	{
 		"BPF_MAXINSNS: ld_abs+get_processor_id",
 		{ },
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 08190db0a2dc..79e306ec1416 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1437,7 +1437,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 	}
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
-	       nla_total_size(sizeof(struct br_mcast_stats)) +
+	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
 	       nla_total_size(0);
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3bcaecc7ba69..d7e2cb7ae1fa 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4053,7 +4053,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
 				  u32 filter_mask)
 {
-	size_t size = 0;
+	size_t size = NLMSG_ALIGN(sizeof(struct if_stats_msg));
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_64, 0))
 		size += nla_total_size_64bit(sizeof(struct rtnl_link_stats64));
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d0d5e4372730..93f444154728 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -275,6 +275,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
+	acpar.fragoff = 0;
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 87926c6fe0bf..cbe1177d95f9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3714,7 +3714,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!bssid)
 			return false;
 		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
-		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2) ||
+		    !is_valid_ether_addr(hdr->addr2))
 			return false;
 		if (ieee80211_is_beacon(hdr->frame_control))
 			return true;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 955041c54702..d1fd9f7c867e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -567,7 +567,10 @@ static int netlink_insert(struct sock *sk, u32 portid)
 
 	/* We need to ensure that the socket is hashed and visible. */
 	smp_wmb();
-	nlk_sk(sk)->bound = portid;
+	/* Paired with lockless reads from netlink_bind(),
+	 * netlink_connect() and netlink_sendmsg().
+	 */
+	WRITE_ONCE(nlk_sk(sk)->bound, portid);
 
 err:
 	release_sock(sk);
@@ -986,7 +989,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	else if (nlk->ngroups < 8*sizeof(groups))
 		groups &= (1UL << nlk->ngroups) - 1;
 
-	bound = nlk->bound;
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	bound = READ_ONCE(nlk->bound);
 	if (bound) {
 		/* Ensure nlk->portid is up-to-date. */
 		smp_rmb();
@@ -1072,8 +1076,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
+	 * Paired with WRITE_ONCE() in netlink_insert().
 	 */
-	if (!nlk->bound)
+	if (!READ_ONCE(nlk->bound))
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
@@ -1839,7 +1844,8 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		dst_group = nlk->dst_group;
 	}
 
-	if (!nlk->bound) {
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	if (!READ_ONCE(nlk->bound)) {
 		err = netlink_autobind(sock);
 		if (err)
 			goto out;
diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index 1e37247656f8..8b7110cbcce4 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -151,6 +151,9 @@ int fifo_set_limit(struct Qdisc *q, unsigned int limit)
 	if (strncmp(q->ops->id + 1, "fifo", 4) != 0)
 		return 0;
 
+	if (!q->ops->change)
+		return 0;
+
 	nla = kmalloc(nla_attr_size(sizeof(struct tc_fifo_qopt)), GFP_KERNEL);
 	if (nla) {
 		nla->nla_type = RTM_NEWQDISC;
