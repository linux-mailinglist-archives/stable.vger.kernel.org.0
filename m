Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8954768B666
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjBFH17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjBFH1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A750A1C5BA;
        Sun,  5 Feb 2023 23:27:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD3CB80D79;
        Mon,  6 Feb 2023 07:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA8CC4339B;
        Mon,  6 Feb 2023 07:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668435;
        bh=USDQLwQW9tX0kqvjY9a1W08akDccvwUNjn/eH+JYm6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhgJIqyMl7vELsbsm0hnidbve8woiRxWHNO1RDobRYrE+t20hS6YZ12HJlRDcLyr0
         0zZ0KTYwP0Liga7tSeefk1qK7zJSr9OhU80Tp23BhiZVF4L2TOp0OckAZWOzywUuQs
         gfoNjOxaFBBJkJ4rMmBDpDxRzUnKojIez5rIGaPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.10
Date:   Mon,  6 Feb 2023 08:27:01 +0100
Message-Id: <167566842022239@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167566842014820@kroah.com>
References: <167566842014820@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3778b422fa11..6e34c942744e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 37d0cffea99c..70c4a4852256 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -488,7 +488,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 42ed4a04a12e..6280c5e86a12 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -345,7 +345,7 @@ gpio6: io-expander@22 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index de79dcfd32e6..ba2001f37315 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -340,7 +340,7 @@ eeprom@50 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index c675f11de99d..61fa26efd865 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -11,6 +11,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/soc/ti/omap1-soc.h>
+#include <asm/irq.h>
 
 #include "irqs.h"
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
index 5a8d85a7d161..bbdf989058ff 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
@@ -110,7 +110,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
index 9b726c2a4842..dda27ed7aaf2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
@@ -89,7 +89,7 @@ fpga: board-control@2,0 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
index b2fcbba60d3a..3b0ed9305f2b 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
@@ -88,7 +88,7 @@ &duart1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
index 41d8b15f25a5..aa52ff73ff9e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
@@ -53,7 +53,7 @@ flash@2 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 1bfbce69cc8b..ee8e932628d1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -136,7 +136,7 @@ mdio2_aquantia_phy: ethernet-phy@0 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
index ef6c8967533e..d4867d6cf47c 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -245,7 +245,7 @@ rx8035: rtc@32 {
 &i2c3 {
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
index f598669e742f..52c5a43b30a0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
@@ -103,7 +103,7 @@ mdio0_phy15: mdio-phy3@1f {
 
 &i2c0 {
 	status = "okay";
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
index 3d9647b3da14..537cecb13dd0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@75 {
+	i2c-mux@75 {
 		compatible = "nxp,pca9547";
 		reg = <0x75>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
index afb455210bd0..d32a52ab00a4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
@@ -54,7 +54,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
index 74c09891600f..6357078185ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -214,7 +214,7 @@ &i2c3 {
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
index 9dda2a1554c3..8614c18b5998 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
@@ -133,7 +133,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_i2c1_pca9546>;
@@ -216,7 +216,7 @@ &i2c4 {
 	pinctrl-0 = <&pinctrl_i2c4>;
 	status = "okay";
 
-	pca9546: i2cmux@70 {
+	pca9546: i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts b/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
index 5d5aa6537225..6e6182709d22 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
@@ -339,7 +339,7 @@ &usdhc1 {
 	bus-width = <4>;
 	non-removable;
 	no-sd;
-	no-emmc;
+	no-mmc;
 	status = "okay";
 
 	brcmf: wifi@1 {
@@ -359,7 +359,7 @@ &usdhc2 {
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	bus-width = <4>;
 	no-sdio;
-	no-emmc;
+	no-mmc;
 	disable-wp;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 07d8dd8160f6..afa883389456 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -61,7 +61,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_lpi2c1 &pinctrl_ioexp_rst>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9646", "nxp,pca9546";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
index dbfbb77e9ff5..7e2c0dcc11ab 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -8,9 +8,6 @@
 
 #include "msm8994.dtsi"
 
-/* Angler's firmware does not report where the memory is allocated */
-/delete-node/ &cont_splash_mem;
-
 / {
 	model = "Huawei Nexus 6P";
 	compatible = "huawei,angler", "qcom,msm8994";
@@ -27,6 +24,22 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		tzapp_mem: tzapp@4800000 {
+			reg = <0 0x04800000 0 0x1900000>;
+			no-map;
+		};
+
+		removed_region: reserved@6300000 {
+			reg = <0 0x06300000 0 0xD00000>;
+			no-map;
+		};
+	};
 };
 
 &blsp1_uart2 {
diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index ddb8ba4eb399..90a5de746332 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -185,20 +185,14 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 unsigned long __get_wchan(struct task_struct *task)
 {
-	unsigned long pc;
+	unsigned long pc = 0;
 	struct unwind_state state;
 
 	if (!try_get_task_stack(task))
 		return 0;
 
-	unwind_start(&state, task, NULL);
-	state.sp = thread_saved_fp(task);
-	get_stack_info(state.sp, state.task, &state.stack_info);
-	state.pc = thread_saved_ra(task);
-#ifdef CONFIG_UNWINDER_PROLOGUE
-	state.type = UNWINDER_PROLOGUE;
-#endif
-	for (; !unwind_done(&state); unwind_next_frame(&state)) {
+	for (unwind_start(&state, task, NULL);
+	     !unwind_done(&state); unwind_next_frame(&state)) {
 		pc = unwind_get_return_address(&state);
 		if (!pc)
 			break;
diff --git a/arch/loongarch/kernel/unwind_guess.c b/arch/loongarch/kernel/unwind_guess.c
index 5afa6064d73e..0c20e5184de6 100644
--- a/arch/loongarch/kernel/unwind_guess.c
+++ b/arch/loongarch/kernel/unwind_guess.c
@@ -25,6 +25,12 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 	if (regs) {
 		state->sp = regs->regs[3];
 		state->pc = regs->csr_era;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
 	}
 
 	state->task = task;
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 4571c3c87cd4..1c5b65756144 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -111,12 +111,22 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs)
 {
 	memset(state, 0, sizeof(*state));
+	state->type = UNWINDER_PROLOGUE;
 
-	if (regs &&  __kernel_text_address(regs->csr_era)) {
-		state->pc = regs->csr_era;
+	if (regs) {
 		state->sp = regs->regs[3];
+		state->pc = regs->csr_era;
 		state->ra = regs->regs[1];
-		state->type = UNWINDER_PROLOGUE;
+		if (!__kernel_text_address(state->pc))
+			state->type = UNWINDER_GUESS;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+		state->ra = 0;
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
+		state->ra = 0;
 	}
 
 	state->task = task;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index ab19ddb09d65..2ec5f1e0312f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -507,6 +507,7 @@ static void __init setup_lowcore_dat_on(void)
 {
 	struct lowcore *abs_lc;
 	unsigned long flags;
+	int i;
 
 	__ctl_clear_bit(0, 28);
 	S390_lowcore.external_new_psw.mask |= PSW_MASK_DAT;
@@ -521,8 +522,8 @@ static void __init setup_lowcore_dat_on(void)
 	abs_lc = get_abs_lowcore(&flags);
 	abs_lc->restart_flags = RESTART_FLAG_CTLREGS;
 	abs_lc->program_new_psw = S390_lowcore.program_new_psw;
-	memcpy(abs_lc->cregs_save_area, S390_lowcore.cregs_save_area,
-	       sizeof(abs_lc->cregs_save_area));
+	for (i = 0; i < 16; i++)
+		abs_lc->cregs_save_area[i] = S390_lowcore.cregs_save_area[i];
 	put_abs_lowcore(abs_lc, flags);
 }
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fcf9cf49f5de..7c91d9195da8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1408,6 +1408,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 63abbe342b28..83fbc7c54617 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2858,6 +2858,7 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		struct blk_plug *plug, struct bio **bio, unsigned int nsegs)
 {
 	struct request *rq;
+	enum hctx_type type, hctx_type;
 
 	if (!plug)
 		return NULL;
@@ -2870,7 +2871,10 @@ static inline struct request *blk_mq_get_cached_request(struct request_queue *q,
 		return NULL;
 	}
 
-	if (blk_mq_get_hctx_type((*bio)->bi_opf) != rq->mq_hctx->type)
+	type = blk_mq_get_hctx_type((*bio)->bi_opf);
+	hctx_type = rq->mq_hctx->type;
+	if (type != hctx_type &&
+	    !(type == HCTX_TYPE_READ && hctx_type == HCTX_TYPE_DEFAULT))
 		return NULL;
 	if (op_is_flush(rq->cmd_flags) != op_is_flush((*bio)->bi_opf))
 		return NULL;
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 5c32b318c173..b48f85c3791e 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -493,6 +493,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Acer Aspire 4810T */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4810T"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Acer Aspire 5738z */
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fbea5f62dd98..b926abe4fa43 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1521,10 +1521,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
 		sdma_config_ownership(sdmac, false, true, false);
 
 	if (sdma_load_context(sdmac))
-		goto err_desc_out;
+		goto err_bd_out;
 
 	return desc;
 
+err_bd_out:
+	sdma_free_bd(desc);
 err_desc_out:
 	kfree(desc);
 err_out:
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f818d00bb2c6..ffdad59ec81f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -910,6 +910,8 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 			      xfer->hdr.protocol_id, xfer->hdr.seq,
 			      xfer->hdr.poll_completion);
 
+	/* Clear any stale status */
+	xfer->hdr.status = SCMI_SUCCESS;
 	xfer->state = SCMI_XFER_SENT_OK;
 	/*
 	 * Even though spinlocking is not needed here since no race is possible
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index a7d2358736fe..fa3de3c3010c 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -361,7 +361,7 @@ static bool acpi_gpio_in_ignore_list(const char *ignore_list, const char *contro
 }
 
 static bool acpi_gpio_irq_is_wake(struct device *parent,
-				  struct acpi_resource_gpio *agpio)
+				  const struct acpi_resource_gpio *agpio)
 {
 	unsigned int pin = agpio->pin_table[0];
 
@@ -754,7 +754,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.debounce = agpio->debounce_timeout;
 		lookup->info.gpioint = gpioint;
-		lookup->info.wake_capable = agpio->wake_capable == ACPI_WAKE_CAPABLE;
+		lookup->info.wake_capable = acpi_gpio_irq_is_wake(&lookup->info.adev->dev, agpio);
 
 		/*
 		 * Polarity and triggering are only specified for GpioInt
@@ -1080,7 +1080,8 @@ int acpi_dev_gpio_irq_wake_get_by(struct acpi_device *adev, const char *name, in
 				dev_dbg(&adev->dev, "IRQ %d already in use\n", irq);
 			}
 
-			if (wake_capable)
+			/* avoid suspend issues with GPIOs when systems are using S3 */
+			if (wake_capable && acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0)
 				*wake_capable = info.wake_capable;
 
 			return irq;
@@ -1599,6 +1600,19 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
 			.ignore_interrupt = "AMDI0030:00@18",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 1.7.8
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1720627
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "ELAN0415:00@9",
+		},
+	},
 	{} /* Terminating entry */
 };
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c3735848ed5d..0f8c11842a3a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1294,6 +1294,7 @@
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_G540	0x0075
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_G640	0x0094
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01	0x0042
+#define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2	0x0905
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L	0x0935
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S	0x0909
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06	0x0078
diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 0b58763bfd30..2228f6e4ba23 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -712,6 +712,7 @@ ATTRIBUTE_GROUPS(ps_device);
 
 static int dualsense_get_calibration_data(struct dualsense *ds)
 {
+	struct hid_device *hdev = ds->base.hdev;
 	short gyro_pitch_bias, gyro_pitch_plus, gyro_pitch_minus;
 	short gyro_yaw_bias, gyro_yaw_plus, gyro_yaw_minus;
 	short gyro_roll_bias, gyro_roll_plus, gyro_roll_minus;
@@ -722,6 +723,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	int speed_2x;
 	int range_2g;
 	int ret = 0;
+	int i;
 	uint8_t *buf;
 
 	buf = kzalloc(DS_FEATURE_REPORT_CALIBRATION_SIZE, GFP_KERNEL);
@@ -773,6 +775,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->gyro_calib_data[2].sens_numer = speed_2x*DS_GYRO_RES_PER_DEG_S;
 	ds->gyro_calib_data[2].sens_denom = gyro_roll_plus - gyro_roll_minus;
 
+	/*
+	 * Sanity check gyro calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing
+	 * calibration data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->gyro_calib_data); i++) {
+		if (ds->gyro_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid gyro calibration data for axis (%d), disabling calibration.",
+					ds->gyro_calib_data[i].abs_code);
+			ds->gyro_calib_data[i].bias = 0;
+			ds->gyro_calib_data[i].sens_numer = DS_GYRO_RANGE;
+			ds->gyro_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 	/*
 	 * Set accelerometer calibration and normalization parameters.
 	 * Data values will be normalized to 1/DS_ACC_RES_PER_G g.
@@ -795,6 +812,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->accel_calib_data[2].sens_numer = 2*DS_ACC_RES_PER_G;
 	ds->accel_calib_data[2].sens_denom = range_2g;
 
+	/*
+	 * Sanity check accelerometer calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing calibration
+	 * data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->accel_calib_data); i++) {
+		if (ds->accel_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid accelerometer calibration data for axis (%d), disabling calibration.",
+					ds->accel_calib_data[i].abs_code);
+			ds->accel_calib_data[i].bias = 0;
+			ds->accel_calib_data[i].sens_numer = DS_ACC_RANGE;
+			ds->accel_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 err_free:
 	kfree(buf);
 	return ret;
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 7fa6fe04f1b2..cfbbc39807a6 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -525,6 +525,8 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_G640) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
+				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index cd1233d7e253..3c5eea3df328 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1655,6 +1655,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		break;
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_PARBLO_A610_PRO):
+	case VID_PID(USB_VENDOR_ID_UGEE,
+		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L):
 	case VID_PID(USB_VENDOR_ID_UGEE,
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index ff8b083dc5c6..262d2b60ac6d 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -987,11 +987,11 @@ static void apple_nvme_reset_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (anv->ctrl.ctrl_config & NVME_CC_ENABLE)
-		apple_nvme_disable(anv, false);
-
 	/* RTKit must be shut down cleanly for the (soft)-reset to work */
 	if (apple_rtkit_is_running(anv->rtk)) {
+		/* reset the controller if it is enabled */
+		if (anv->ctrl.ctrl_config & NVME_CC_ENABLE)
+			apple_nvme_disable(anv, false);
 		dev_dbg(anv->dev, "Trying to shut down RTKit before reset.");
 		ret = apple_rtkit_shutdown(anv->rtk);
 		if (ret)
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 4302dc75843c..3bc1d3494be3 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1050,10 +1050,10 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
-	int rc;
-	const char *npath;
-	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
+	struct cache_entry *ce;
+	const char *npath;
+	int rc = 0;
 
 	npath = dfs_cache_canonical_path(path, cp, remap);
 	if (IS_ERR(npath))
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 481788c24a68..626a615dafc2 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -577,26 +577,25 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		}
 		++ctx->devs->extra_devices;
 		break;
-	case Opt_fsid:
 #ifdef CONFIG_EROFS_FS_ONDEMAND
+	case Opt_fsid:
 		kfree(ctx->fsid);
 		ctx->fsid = kstrdup(param->string, GFP_KERNEL);
 		if (!ctx->fsid)
 			return -ENOMEM;
-#else
-		errorfc(fc, "fsid option not supported");
-#endif
 		break;
 	case Opt_domain_id:
-#ifdef CONFIG_EROFS_FS_ONDEMAND
 		kfree(ctx->domain_id);
 		ctx->domain_id = kstrdup(param->string, GFP_KERNEL);
 		if (!ctx->domain_id)
 			return -ENOMEM;
+		break;
 #else
-		errorfc(fc, "domain_id option not supported");
-#endif
+	case Opt_fsid:
+	case Opt_domain_id:
+		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
 		break;
+#endif
 	default:
 		return -ENOPARAM;
 	}
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e6d5d7a18fb0..39cc014dba40 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -793,12 +793,16 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
 		/*
-		 * No strict rule how to describe extents for post EOF, yet
-		 * we need do like below. Otherwise, iomap itself will get
+		 * No strict rule on how to describe extents for post EOF, yet
+		 * we need to do like below. Otherwise, iomap itself will get
 		 * into an endless loop on post EOF.
+		 *
+		 * Calculate the effective offset by subtracting extent start
+		 * (map.m_la) from the requested offset, and add it to length.
+		 * (NB: offset >= map.m_la always)
 		 */
 		if (iomap->offset >= inode->i_size)
-			iomap->length = length + map.m_la - offset;
+			iomap->length = length + offset - map.m_la;
 	}
 	iomap->flags = 0;
 	return 0;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1ed08967fb97..eb8c117cc8b6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -847,6 +847,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
+	/* Task should not be pid=1 to avoid kernel panic. */
+	if (unlikely(is_global_init(current)))
+		return -EPERM;
 
 	if (irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 759bede0b3dd..51db260f471f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4034,7 +4034,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -4080,8 +4080,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3262ebb24092..8f0d7c666df7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4859,6 +4859,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		 */
 		shwt = skb_hwtstamps(rx->skb);
 		shwt->hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+		/* Update the hdr pointer to the new skb for translation below */
+		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
 	if (unlikely(rx->sta && rx->sta->sta.mlo)) {
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 45bbe3e54cc2..3150f3f0c872 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -587,6 +587,11 @@ static void mctp_sk_unhash(struct sock *sk)
 	del_timer_sync(&msk->key_expiry);
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -623,6 +628,7 @@ static int mctp_pf_create(struct net *net, struct socket *sock,
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index 55db5a1ba752..97ff086ba22e 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -115,17 +115,24 @@ pub unsafe fn call_printk(
 macro_rules! print_macro (
     // The non-continuation cases (most of them, e.g. `INFO`).
     ($format_string:path, $($arg:tt)+) => (
-        // SAFETY: This hidden macro should only be called by the documented
-        // printing macros which ensure the format string is one of the fixed
-        // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
-        // by the `module!` proc macro or fixed values defined in a kernel
-        // crate.
-        unsafe {
-            $crate::print::call_printk(
-                &$format_string,
-                crate::__LOG_PREFIX,
-                format_args!($($arg)+),
-            );
+        // To remain sound, `arg`s must be expanded outside the `unsafe` block.
+        // Typically one would use a `let` binding for that; however, `format_args!`
+        // takes borrows on the arguments, but does not extend the scope of temporaries.
+        // Therefore, a `match` expression is used to keep them around, since
+        // the scrutinee is kept until the end of the `match`.
+        match format_args!($($arg)+) {
+            // SAFETY: This hidden macro should only be called by the documented
+            // printing macros which ensure the format string is one of the fixed
+            // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
+            // by the `module!` proc macro or fixed values defined in a kernel
+            // crate.
+            args => unsafe {
+                $crate::print::call_printk(
+                    &$format_string,
+                    crate::__LOG_PREFIX,
+                    args,
+                );
+            }
         }
     );
 );
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 291144c284fb..f7900e75d230 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -20,7 +20,7 @@ CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
 
 ifeq ($(CROSS_COMPILE),)
 ifeq ($(CLANG_TARGET_FLAGS),)
-$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk
+$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk)
 else
 CLANG_FLAGS     += --target=$(CLANG_TARGET_FLAGS)
 endif # CLANG_TARGET_FLAGS
