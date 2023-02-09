Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C662069058A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBIKrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBIKqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:46:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6735DC12;
        Thu,  9 Feb 2023 02:45:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25298B820F3;
        Thu,  9 Feb 2023 10:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C8DC433D2;
        Thu,  9 Feb 2023 10:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675939518;
        bh=tY8zUKuP89pfGXzLjRdDTm4rO/wpsoFOm5Y/ZlHL61g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgDbX0DzwECeKScL1MYO+fRTtDlJOD7HsEsbz0D1bh7Wk6dEmo5zO5HIYeV6EdR1Z
         wCgiFgPra3T1hmSgGog7mJw+nSl1fYrK/M53GvArFj5CQwtvRC0wwYEb7KaA7PK6gs
         VvhJalSpsO+gH3LJnspOgi3yb4LT8SpqOlL/sijY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.11
Date:   Thu,  9 Feb 2023 11:45:05 +0100
Message-Id: <167593950523571@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <1675939505479@kroah.com>
References: <1675939505479@kroah.com>
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
index 6e34c942744e..e039f2af1772 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 10
+SUBLEVEL = 11
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/imx7d-smegw01.dts b/arch/arm/boot/dts/imx7d-smegw01.dts
index 546268b8d0b1..c0f00f5db11e 100644
--- a/arch/arm/boot/dts/imx7d-smegw01.dts
+++ b/arch/arm/boot/dts/imx7d-smegw01.dts
@@ -198,6 +198,7 @@ &usbotg1 {
 &usbotg2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbotg2>;
+	over-current-active-low;
 	dr_mode = "host";
 	status = "okay";
 };
@@ -374,7 +375,7 @@ MX7D_PAD_LPSR_GPIO1_IO05__GPIO1_IO5	0x04
 
 	pinctrl_usbotg2: usbotg2grp {
 		fsl,pins = <
-			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x04
+			MX7D_PAD_UART3_RTS_B__USB_OTG2_OC	0x5c
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
index 5ddbda0b4def..f2c4d13b2f3c 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -157,7 +157,7 @@ rtc: rtc {
 
 		sc_pwrkey: keys {
 			compatible = "fsl,imx8qxp-sc-key", "fsl,imx-sc-key";
-			linux,keycode = <KEY_POWER>;
+			linux,keycodes = <KEY_POWER>;
 			wakeup-source;
 		};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
index 83c8f715cd90..b1f11098d248 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
@@ -602,7 +602,7 @@
 #define MX8MM_IOMUXC_UART1_RXD_GPIO5_IO22                                   0x234 0x49C 0x000 0x5 0x0
 #define MX8MM_IOMUXC_UART1_RXD_TPSMP_HDATA24                                0x234 0x49C 0x000 0x7 0x0
 #define MX8MM_IOMUXC_UART1_TXD_UART1_DCE_TX                                 0x238 0x4A0 0x000 0x0 0x0
-#define MX8MM_IOMUXC_UART1_TXD_UART1_DTE_RX                                 0x238 0x4A0 0x4F4 0x0 0x0
+#define MX8MM_IOMUXC_UART1_TXD_UART1_DTE_RX                                 0x238 0x4A0 0x4F4 0x0 0x1
 #define MX8MM_IOMUXC_UART1_TXD_ECSPI3_MOSI                                  0x238 0x4A0 0x000 0x1 0x0
 #define MX8MM_IOMUXC_UART1_TXD_GPIO5_IO23                                   0x238 0x4A0 0x000 0x5 0x0
 #define MX8MM_IOMUXC_UART1_TXD_TPSMP_HDATA25                                0x238 0x4A0 0x000 0x7 0x0
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
index 3ea73a6886ff..f6ad1a4b8b66 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x-rs232-rts.dts
@@ -33,7 +33,6 @@ &uart2 {
 	pinctrl-0 = <&pinctrl_uart2>;
 	rts-gpios = <&gpio5 29 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio5 28 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
index 2fa635e1c1a8..1f8ea20dfafc 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x-rs232-rts.dts
@@ -33,7 +33,6 @@ &uart2 {
 	pinctrl-0 = <&pinctrl_uart2>;
 	rts-gpios = <&gpio5 29 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio5 28 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
index 244ef8d6cc68..7761d5671cb1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -222,7 +222,6 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_bten>;
 	cts-gpios = <&gpio5 8 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
index 72311b55f06d..5a770c8b777e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
@@ -721,7 +721,6 @@ &uart1 {
 	dtr-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio1 11 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -737,7 +736,6 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	cts-gpios = <&gpio4 10 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio4 9 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -746,7 +744,6 @@ &uart4 {
 	pinctrl-0 = <&pinctrl_uart4>, <&pinctrl_uart4_gpio>;
 	cts-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio5 12 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
index 31f4c735fe4f..ba0b3f507855 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dts
@@ -651,7 +651,6 @@ &uart1 {
 	pinctrl-0 = <&pinctrl_uart1>, <&pinctrl_uart1_gpio>;
 	rts-gpios = <&gpio4 10 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio4 24 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -668,7 +667,6 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	rts-gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
@@ -686,7 +684,6 @@ &uart4 {
 	dtr-gpios = <&gpio4 3 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio4 4 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio4 6 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
index 19f6d2943d26..8e861b920d09 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7903.dts
@@ -572,7 +572,6 @@ &uart1 {
 	dtr-gpios = <&gpio1 0 GPIO_ACTIVE_LOW>;
 	dsr-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
 	dcd-gpios = <&gpio3 24 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index bcab830c6e95..59445f916d7f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -98,6 +98,7 @@ reg_ethphy: regulator-ethphy {
 		off-on-delay = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
+		regulator-always-on;
 		regulator-boot-on;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
index dd4302ac1de4..e7362d7615bd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dts
@@ -631,7 +631,6 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	rts-gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
 	cts-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 06b4c93c5876..d68ef4f0726f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -611,7 +611,6 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>, <&pinctrl_uart3_gpio>;
 	cts-gpios = <&gpio3 21 GPIO_ACTIVE_LOW>;
 	rts-gpios = <&gpio3 22 GPIO_ACTIVE_LOW>;
-	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 215bf3f8cb20..4f24910cfe73 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -170,6 +170,9 @@ ia64_mremap (unsigned long addr, unsigned long old_len, unsigned long new_len, u
 asmlinkage long
 ia64_clock_getres(const clockid_t which_clock, struct __kernel_timespec __user *tp)
 {
+	struct timespec64 rtn_tp;
+	s64 tick_ns;
+
 	/*
 	 * ia64's clock_gettime() syscall is implemented as a vdso call
 	 * fsys_clock_gettime(). Currently it handles only
@@ -185,8 +188,8 @@ ia64_clock_getres(const clockid_t which_clock, struct __kernel_timespec __user *
 	switch (which_clock) {
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
-		s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
-		struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
+		tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
+		rtn_tp = ns_to_timespec64(tick_ns);
 		return put_timespec64(&rtn_tp, tp);
 	}
 
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index a115315d88e6..bd325f2b5349 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1303,7 +1303,7 @@ static char iodc_dbuf[4096] __page_aligned_bss;
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	unsigned int i;
+	unsigned int i, found = 0;
 	unsigned long flags;
 
 	count = min_t(unsigned int, count, sizeof(iodc_dbuf));
@@ -1315,6 +1315,7 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
+			found = 1;
 			goto print;
 		default:
 			iodc_dbuf[i] = str[i];
@@ -1330,7 +1331,7 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 		__pa(pdc_result), 0, __pa(iodc_dbuf), i, 0);
 	spin_unlock_irqrestore(&pdc_lock, flags);
 
-	return i;
+	return i - found;
 }
 
 #if !defined(BOOTLOADER)
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 96ef6a6b66e5..9af11abeee4f 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -126,6 +126,12 @@ long arch_ptrace(struct task_struct *child, long request,
 	unsigned long tmp;
 	long ret = -EIO;
 
+	unsigned long user_regs_struct_size = sizeof(struct user_regs_struct);
+#ifdef CONFIG_64BIT
+	if (is_compat_task())
+		user_regs_struct_size /= 2;
+#endif
+
 	switch (request) {
 
 	/* Read the word at location addr in the USER area.  For ptraced
@@ -166,7 +172,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		     addr >= sizeof(struct pt_regs))
 			break;
 		if (addr == PT_IAOQ0 || addr == PT_IAOQ1) {
-			data |= 3; /* ensure userspace privilege */
+			data |= PRIV_USER; /* ensure userspace privilege */
 		}
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
@@ -181,14 +187,14 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child,
 					   task_user_regset_view(current),
 					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct),
+					   0, user_regs_struct_size,
 					   datap);
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		return copy_regset_from_user(child,
 					     task_user_regset_view(current),
 					     REGSET_GENERAL,
-					     0, sizeof(struct user_regs_struct),
+					     0, user_regs_struct_size,
 					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
@@ -285,7 +291,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			if (addr >= sizeof(struct pt_regs))
 				break;
 			if (addr == PT_IAOQ0+4 || addr == PT_IAOQ1+4) {
-				data |= 3; /* ensure userspace privilege */
+				data |= PRIV_USER; /* ensure userspace privilege */
 			}
 			if (addr >= PT_FR0 && addr <= PT_FR31 + 4) {
 				/* Special case, fp regs are 64 bits anyway */
@@ -302,6 +308,11 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			}
 		}
 		break;
+	case PTRACE_GETREGS:
+	case PTRACE_SETREGS:
+	case PTRACE_GETFPREGS:
+	case PTRACE_SETFPREGS:
+		return arch_ptrace(child, request, addr, data);
 
 	default:
 		ret = compat_ptrace_request(child, request, addr, data);
@@ -483,7 +494,7 @@ static void set_reg(struct pt_regs *regs, int num, unsigned long val)
 	case RI(iaoq[0]):
 	case RI(iaoq[1]):
 			/* set 2 lowest bits to ensure userspace privilege: */
-			regs->iaoq[num - RI(iaoq[0])] = val | 3;
+			regs->iaoq[num - RI(iaoq[0])] = val | PRIV_USER;
 			return;
 	case RI(sar):	regs->sar = val;
 			return;
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 77fa88c2aed0..0b7d01d408ac 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -192,7 +192,7 @@ static inline void arch_local_irq_enable(void)
 
 static inline unsigned long arch_local_irq_save(void)
 {
-	return irq_soft_mask_set_return(IRQS_DISABLED);
+	return irq_soft_mask_or_return(IRQS_DISABLED);
 }
 
 static inline bool arch_irqs_disabled_flags(unsigned long flags)
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cac727b01799..5a2384ed1727 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -262,6 +262,17 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
 static unsigned long next_boundary(unsigned long addr, unsigned long end)
 {
 #ifdef CONFIG_STRICT_KERNEL_RWX
+	unsigned long stext_phys;
+
+	stext_phys = __pa_symbol(_stext);
+
+	// Relocatable kernel running at non-zero real address
+	if (stext_phys != 0) {
+		// Start of relocated kernel text is a rodata boundary
+		if (addr < stext_phys)
+			return stext_phys;
+	}
+
 	if (addr < __pa_symbol(__srwx_boundary))
 		return __pa_symbol(__srwx_boundary);
 #endif
diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index 100e97daf76b..9d229ef7f86e 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -22,7 +22,7 @@
  * Used to avoid races in counting the nest-pmu units during hotplug
  * register and unregister
  */
-static DEFINE_SPINLOCK(nest_init_lock);
+static DEFINE_MUTEX(nest_init_lock);
 static DEFINE_PER_CPU(struct imc_pmu_ref *, local_nest_imc_refc);
 static struct imc_pmu **per_nest_pmu_arr;
 static cpumask_t nest_imc_cpumask;
@@ -1629,7 +1629,7 @@ static void imc_common_mem_free(struct imc_pmu *pmu_ptr)
 static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 {
 	if (pmu_ptr->domain == IMC_DOMAIN_NEST) {
-		spin_lock(&nest_init_lock);
+		mutex_lock(&nest_init_lock);
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
@@ -1639,7 +1639,7 @@ static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 
 		if (nest_pmus > 0)
 			nest_pmus--;
-		spin_unlock(&nest_init_lock);
+		mutex_unlock(&nest_init_lock);
 	}
 
 	/* Free core_imc memory */
@@ -1796,11 +1796,11 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 		* rest. To handle the cpuhotplug callback unregister, we track
 		* the number of nest pmus in "nest_pmus".
 		*/
-		spin_lock(&nest_init_lock);
+		mutex_lock(&nest_init_lock);
 		if (nest_pmus == 0) {
 			ret = init_nest_pmu_ref();
 			if (ret) {
-				spin_unlock(&nest_init_lock);
+				mutex_unlock(&nest_init_lock);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
 				goto err_free_mem;
@@ -1808,7 +1808,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 			/* Register for cpu hotplug notification. */
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
-				spin_unlock(&nest_init_lock);
+				mutex_unlock(&nest_init_lock);
 				kfree(nest_imc_refc);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
@@ -1816,7 +1816,7 @@ int init_imc_pmu(struct device_node *parent, struct imc_pmu *pmu_ptr, int pmu_id
 			}
 		}
 		nest_pmus++;
-		spin_unlock(&nest_init_lock);
+		mutex_unlock(&nest_init_lock);
 		break;
 	case IMC_DOMAIN_CORE:
 		ret = core_imc_pmu_cpumask_init();
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 0d13b597cb55..c8187867c5f4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -80,6 +80,9 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
         KBUILD_CFLAGS += -fno-omit-frame-pointer
 endif
 
+# Avoid generating .eh_frame sections.
+KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
+
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
 KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index e6e950b7cf32..388ecada500c 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -48,6 +48,21 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
 	post_kprobe_handler(p, kcb, regs);
 }
 
+static bool __kprobes arch_check_kprobe(struct kprobe *p)
+{
+	unsigned long tmp  = (unsigned long)p->addr - p->offset;
+	unsigned long addr = (unsigned long)p->addr;
+
+	while (tmp <= addr) {
+		if (tmp == addr)
+			return true;
+
+		tmp += GET_INSN_LENGTH(*(u16 *)tmp);
+	}
+
+	return false;
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	unsigned long probe_addr = (unsigned long)p->addr;
@@ -55,6 +70,9 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (probe_addr & 0x1)
 		return -EILSEQ;
 
+	if (!arch_check_kprobe(p))
+		return -EILSEQ;
+
 	/* copy instruction */
 	p->opcode = *p->addr;
 
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index e4ef67e4da0a..c13b1455ec8c 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -153,7 +153,7 @@ int copy_oldmem_kernel(void *dst, unsigned long src, size_t count)
 
 	kvec.iov_base = dst;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 	if (copy_oldmem_iter(&iter, src, count) < count)
 		return -EFAULT;
 	return 0;
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 1571cdcb0c50..4824d1cd33d8 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -128,7 +128,7 @@ int memcpy_real(void *dest, unsigned long src, size_t count)
 
 	kvec.iov_base = dest;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 	if (memcpy_real_iter(&iter, src, count) < count)
 		return -EFAULT;
 	return 0;
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 415a5d138de4..3419ffa2a350 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -14,13 +14,13 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
-RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
 endif
+RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 
 ifdef CONFIG_RETHUNK
 RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1b92bf05fd65..5a1d0ea402e4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6342,6 +6342,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 		pmem = true;
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, spr_hw_cache_event_ids, sizeof(hw_cache_event_ids));
diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 3019fb1926e3..551741e79e03 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -677,6 +677,7 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&icx_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&icx_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&icx_cstates),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&icx_cstates),
 
 	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&icl_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&icl_cstates),
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index cfdf307ddc01..9ed8343c9b3c 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -39,7 +39,20 @@ static __always_inline unsigned long native_get_debugreg(int regno)
 		asm("mov %%db6, %0" :"=r" (val));
 		break;
 	case 7:
-		asm("mov %%db7, %0" :"=r" (val));
+		/*
+		 * Apply __FORCE_ORDER to DR7 reads to forbid re-ordering them
+		 * with other code.
+		 *
+		 * This is needed because a DR7 access can cause a #VC exception
+		 * when running under SEV-ES. Taking a #VC exception is not a
+		 * safe thing to do just anywhere in the entry code and
+		 * re-ordering might place the access into an unsafe location.
+		 *
+		 * This happened in the NMI handler, where the DR7 read was
+		 * re-ordered to happen before the call to sev_es_ist_enter(),
+		 * causing stack recursion.
+		 */
+		asm volatile("mov %%db7, %0" : "=r" (val) : __FORCE_ORDER);
 		break;
 	default:
 		BUG();
@@ -66,7 +79,16 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 		asm("mov %0, %%db6"	::"r" (value));
 		break;
 	case 7:
-		asm("mov %0, %%db7"	::"r" (value));
+		/*
+		 * Apply __FORCE_ORDER to DR7 writes to forbid re-ordering them
+		 * with other code.
+		 *
+		 * While is didn't happen with a DR7 write (see the DR7 read
+		 * comment above which explains where it happened), add the
+		 * __FORCE_ORDER here too to avoid similar problems in the
+		 * future.
+		 */
+		asm volatile("mov %0, %%db7"	::"r" (value), __FORCE_ORDER);
 		break;
 	default:
 		BUG();
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 1f60a2b27936..fdbb5f07448f 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -330,7 +330,16 @@ static void __init bp_init_freq_invariance(void)
 
 static void disable_freq_invariance_workfn(struct work_struct *work)
 {
+	int cpu;
+
 	static_branch_disable(&arch_scale_freq_key);
+
+	/*
+	 * Set arch_freq_scale to a default value on all cpus
+	 * This negates the effect of scaling
+	 */
+	for_each_possible_cpu(cpu)
+		per_cpu(arch_freq_scale, cpu) = SCHED_CAPACITY_SCALE;
 }
 
 static DECLARE_WORK(disable_freq_invariance_work,
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 048e38ec99e7..1def66118b03 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -902,7 +902,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
 
 	kvec.iov_base = (void *)firmware->data;
 	kvec.iov_len = firmware->size;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, firmware->size);
+	iov_iter_kvec(&iter, ITER_SOURCE, &kvec, 1, firmware->size);
 	ret = generic_load_microcode(cpu, &iter);
 
 	release_firmware(firmware);
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index e75bc2f217ff..32d710f7eb84 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -57,7 +57,7 @@ ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 	struct kvec kvec = { .iov_base = buf, .iov_len = count };
 	struct iov_iter iter;
 
-	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 
 	return read_from_oldmem(&iter, count, ppos,
 				cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT));
diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 7d624a3a3f0f..60b4299bec8e 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -718,15 +718,15 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				     struct bfq_io_cq *bic,
 				     struct bfq_group *bfqg)
 {
-	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
-	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
+	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, false);
+	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, true);
 	struct bfq_entity *entity;
 
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
 		if (entity->sched_data != &bfqg->sched_data) {
-			bic_set_bfqq(bic, NULL, 0);
+			bic_set_bfqq(bic, NULL, false);
 			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
@@ -761,8 +761,8 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 * request from the old cgroup.
 				 */
 				bfq_put_cooperator(sync_bfqq);
+				bic_set_bfqq(bic, NULL, true);
 				bfq_release_process_ref(bfqd, sync_bfqq);
-				bic_set_bfqq(bic, NULL, 1);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7b894df32e32..ff9d23889415 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3180,7 +3180,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	/*
 	 * Merge queues (that is, let bic redirect its requests to new_bfqq)
 	 */
-	bic_set_bfqq(bic, new_bfqq, 1);
+	bic_set_bfqq(bic, new_bfqq, true);
 	bfq_mark_bfqq_coop(new_bfqq);
 	/*
 	 * new_bfqq now belongs to at least two bics (it is a shared queue):
@@ -5491,9 +5491,11 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		bfq_release_process_ref(bfqd, bfqq);
+		struct bfq_queue *old_bfqq = bfqq;
+
 		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
+		bfq_release_process_ref(bfqd, old_bfqq);
 	}
 
 	bfqq = bic_to_bfqq(bic, true);
@@ -6627,7 +6629,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 		return bfqq;
 	}
 
-	bic_set_bfqq(bic, NULL, 1);
+	bic_set_bfqq(bic, NULL, true);
 
 	bfq_put_cooperator(bfqq);
 
diff --git a/certs/Makefile b/certs/Makefile
index 9486ed924731..799ad7b9e68a 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -23,8 +23,8 @@ $(obj)/blacklist_hash_list: $(CONFIG_SYSTEM_BLACKLIST_HASH_LIST) FORCE
 targets += blacklist_hash_list
 
 quiet_cmd_extract_certs  = CERT    $@
-      cmd_extract_certs  = $(obj)/extract-cert $(extract-cert-in) $@
-extract-cert-in = $(or $(filter-out $(obj)/extract-cert, $(real-prereqs)),"")
+      cmd_extract_certs  = $(obj)/extract-cert "$(extract-cert-in)" $@
+extract-cert-in = $(filter-out $(obj)/extract-cert, $(real-prereqs))
 
 $(obj)/system_certificates.o: $(obj)/x509_certificate_list
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bcd059caa1c8..814d2dc87d7e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -766,7 +766,7 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
 	struct iov_iter input;
 	int err;
 
-	iov_iter_kvec(&input, WRITE, inputs, nr_inputs, src_total_len);
+	iov_iter_kvec(&input, ITER_SOURCE, inputs, nr_inputs, src_total_len);
 	err = build_test_sglist(&tsgls->src, cfg->src_divs, alignmask,
 				cfg->inplace_mode != OUT_OF_PLACE ?
 					max(dst_total_len, src_total_len) :
@@ -1180,7 +1180,7 @@ static int build_hash_sglist(struct test_sglist *tsgl,
 
 	kv.iov_base = (void *)vec->plaintext;
 	kv.iov_len = vec->psize;
-	iov_iter_kvec(&input, WRITE, &kv, 1, vec->psize);
+	iov_iter_kvec(&input, ITER_SOURCE, &kv, 1, vec->psize);
 	return build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
 				 &input, divs);
 }
diff --git a/drivers/acpi/pfr_update.c b/drivers/acpi/pfr_update.c
index 9d2bdc13253a..98267f163e2b 100644
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -455,7 +455,7 @@ static ssize_t pfru_write(struct file *file, const char __user *buf,
 
 	iov.iov_base = (void __user *)buf;
 	iov.iov_len = len;
-	iov_iter_init(&iter, WRITE, &iov, 1, len);
+	iov_iter_init(&iter, ITER_SOURCE, &iov, 1, len);
 
 	/* map the communication buffer */
 	phy_addr = (phys_addr_t)((buf_info.addr_hi << 32) | buf_info.addr_lo);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d3ce5c383f3a..26a75f5cce95 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3108,7 +3108,7 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 	 */
 	if (spd > 1)
 		mask &= (1 << (spd - 1)) - 1;
-	else
+	else if (link->sata_spd)
 		return -EINVAL;
 
 	/* were we already at the bottom? */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 677240232684..590d1b50ab5d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1816,7 +1816,7 @@ int drbd_send(struct drbd_connection *connection, struct socket *sock,
 
 	/* THINK  if (signal_pending) return ... ? */
 
-	iov_iter_kvec(&msg.msg_iter, WRITE, &iov, 1, size);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iov, 1, size);
 
 	if (sock == connection->data.socket) {
 		rcu_read_lock();
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ee69d50ba4fd..54010eac6ca9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -507,7 +507,7 @@ static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flag
 	struct msghdr msg = {
 		.msg_flags = (flags ? flags : MSG_WAITALL | MSG_NOSIGNAL)
 	};
-	iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, size);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, size);
 	return sock_recvmsg(sock, &msg, msg.msg_flags);
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d12d3d171ec4..df628e30bca4 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -243,7 +243,7 @@ static int lo_write_bvec(struct file *file, struct bio_vec *bvec, loff_t *ppos)
 	struct iov_iter i;
 	ssize_t bw;
 
-	iov_iter_bvec(&i, WRITE, bvec, 1, bvec->bv_len);
+	iov_iter_bvec(&i, ITER_SOURCE, bvec, 1, bvec->bv_len);
 
 	file_start_write(file);
 	bw = vfs_iter_write(file, &i, ppos, 0);
@@ -286,7 +286,7 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
 	ssize_t len;
 
 	rq_for_each_segment(bvec, rq, iter) {
-		iov_iter_bvec(&i, READ, &bvec, 1, bvec.bv_len);
+		iov_iter_bvec(&i, ITER_DEST, &bvec, 1, bvec.bv_len);
 		len = vfs_iter_read(lo->lo_backing_file, &i, &pos, 0);
 		if (len < 0)
 			return len;
@@ -392,7 +392,7 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret)
 }
 
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
-		     loff_t pos, bool rw)
+		     loff_t pos, int rw)
 {
 	struct iov_iter iter;
 	struct req_iterator rq_iter;
@@ -448,7 +448,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_flags = IOCB_DIRECT;
 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
 
-	if (rw == WRITE)
+	if (rw == ITER_SOURCE)
 		ret = call_write_iter(file, &cmd->iocb, &iter);
 	else
 		ret = call_read_iter(file, &cmd->iocb, &iter);
@@ -490,12 +490,12 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, WRITE);
+			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
 		else
 			return lo_write_simple(lo, rq, pos);
 	case REQ_OP_READ:
 		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, READ);
+			return lo_rw_aio(lo, cmd, pos, ITER_DEST);
 		else
 			return lo_read_simple(lo, rq, pos);
 	default:
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5cffd96ef2d7..e379ccc63c52 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -563,7 +563,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	u32 nbd_cmd_flags = 0;
 	int sent = nsock->sent, skip = 0;
 
-	iov_iter_kvec(&from, WRITE, &iov, 1, sizeof(request));
+	iov_iter_kvec(&from, ITER_SOURCE, &iov, 1, sizeof(request));
 
 	type = req_to_nbd_cmd_type(req);
 	if (type == U32_MAX)
@@ -649,7 +649,7 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 
 			dev_dbg(nbd_to_dev(nbd), "request %p: sending %d bytes data\n",
 				req, bvec.bv_len);
-			iov_iter_bvec(&from, WRITE, &bvec, 1, bvec.bv_len);
+			iov_iter_bvec(&from, ITER_SOURCE, &bvec, 1, bvec.bv_len);
 			if (skip) {
 				if (skip >= iov_iter_count(&from)) {
 					skip -= iov_iter_count(&from);
@@ -701,7 +701,7 @@ static int nbd_read_reply(struct nbd_device *nbd, int index,
 	int result;
 
 	reply->magic = 0;
-	iov_iter_kvec(&to, READ, &iov, 1, sizeof(*reply));
+	iov_iter_kvec(&to, ITER_DEST, &iov, 1, sizeof(*reply));
 	result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
 	if (result < 0) {
 		if (!nbd_disconnected(nbd->config))
@@ -790,7 +790,7 @@ static struct nbd_cmd *nbd_handle_reply(struct nbd_device *nbd, int index,
 		struct iov_iter to;
 
 		rq_for_each_segment(bvec, req, iter) {
-			iov_iter_bvec(&to, READ, &bvec, 1, bvec.bv_len);
+			iov_iter_bvec(&to, ITER_DEST, &bvec, 1, bvec.bv_len);
 			result = sock_xmit(nbd, index, 0, &to, MSG_WAITALL, NULL);
 			if (result < 0) {
 				dev_err(disk_to_dev(nbd->disk), "Receive data failed (result %d)\n",
@@ -1267,7 +1267,7 @@ static void send_disconnects(struct nbd_device *nbd)
 	for (i = 0; i < config->num_connections; i++) {
 		struct nbd_sock *nsock = config->socks[i];
 
-		iov_iter_kvec(&from, WRITE, &iov, 1, sizeof(request));
+		iov_iter_kvec(&from, ITER_SOURCE, &iov, 1, sizeof(request));
 		mutex_lock(&nsock->tx_lock);
 		ret = sock_xmit(nbd, i, 1, &from, 0, NULL);
 		if (ret < 0)
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e54693204630..6368b56eacf1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -137,7 +137,7 @@ struct ublk_device {
 
 	char	*__queues;
 
-	unsigned short  queue_size;
+	unsigned int	queue_size;
 	struct ublksrv_ctrl_dev_info	dev_info;
 
 	struct blk_mq_tag_set	tag_set;
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 3aa91aed3bf7..226e87b85116 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -857,7 +857,13 @@ static int __init sunxi_rsb_init(void)
 		return ret;
 	}
 
-	return platform_driver_register(&sunxi_rsb_driver);
+	ret = platform_driver_register(&sunxi_rsb_driver);
+	if (ret) {
+		bus_unregister(&sunxi_rsb_bus);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(sunxi_rsb_init);
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index f5868dddbb61..5d1c8e1c99b5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1329,7 +1329,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags
 			return ret;
 	}
 
-	ret = import_single_range(READ, ubuf, len, &iov, &iter);
+	ret = import_single_range(ITER_DEST, ubuf, len, &iov, &iter);
 	if (unlikely(ret))
 		return ret;
 	return get_random_bytes_user(&iter);
@@ -1447,7 +1447,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EINVAL;
 		if (get_user(len, p++))
 			return -EFAULT;
-		ret = import_single_range(WRITE, p, len, &iov, &iter);
+		ret = import_single_range(ITER_SOURCE, p, len, &iov, &iter);
 		if (unlikely(ret))
 			return ret;
 		ret = write_pool_user(&iter);
diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 406b4e26f538..0de0482cd36e 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -167,7 +167,7 @@ struct dma_fence *dma_fence_allocate_private_stub(void)
 		       0, 0);
 
 	set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-		&dma_fence_stub.flags);
+		&fence->flags);
 
 	dma_fence_signal(fence);
 
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 9c89f7d53e99..958aa4662ccb 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -819,8 +819,10 @@ static int ioctl_send_response(struct client *client, union ioctl_arg *arg)
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (is_fcp_request(r->request))
+	if (is_fcp_request(r->request)) {
+		kfree(r->data);
 		goto out;
+	}
 
 	if (a->length != fw_get_response_length(r->request)) {
 		ret = -EINVAL;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 033aac6be7da..b43e5e6ddaf6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -984,6 +984,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	/* first try to find a slot in an existing linked list entry */
 	for (prsv = efi_memreserve_root->next; prsv; ) {
 		rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
+		if (!rsv)
+			return -ENOMEM;
 		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
 		if (index < rsv->size) {
 			rsv->entry[index].base = addr;
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 0a9aba5f9cef..f178b2984dfb 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -33,7 +33,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;
diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index 79d48852825e..03f1bd81c434 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -574,20 +574,27 @@ static int m10bmc_sec_probe(struct platform_device *pdev)
 	len = scnprintf(buf, SEC_UPDATE_LEN_MAX, "secure-update%d",
 			sec->fw_name_id);
 	sec->fw_name = kmemdup_nul(buf, len, GFP_KERNEL);
-	if (!sec->fw_name)
-		return -ENOMEM;
+	if (!sec->fw_name) {
+		ret = -ENOMEM;
+		goto fw_name_fail;
+	}
 
 	fwl = firmware_upload_register(THIS_MODULE, sec->dev, sec->fw_name,
 				       &m10bmc_ops, sec);
 	if (IS_ERR(fwl)) {
 		dev_err(sec->dev, "Firmware Upload driver failed to start\n");
-		kfree(sec->fw_name);
-		xa_erase(&fw_upload_xa, sec->fw_name_id);
-		return PTR_ERR(fwl);
+		ret = PTR_ERR(fwl);
+		goto fw_uploader_fail;
 	}
 
 	sec->fwl = fwl;
 	return 0;
+
+fw_uploader_fail:
+	kfree(sec->fw_name);
+fw_name_fail:
+	xa_erase(&fw_upload_xa, sec->fw_name_id);
+	return ret;
 }
 
 static int m10bmc_sec_remove(struct platform_device *pdev)
diff --git a/drivers/fpga/stratix10-soc.c b/drivers/fpga/stratix10-soc.c
index 357cea58ec98..f7f01982a512 100644
--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -213,9 +213,9 @@ static int s10_ops_write_init(struct fpga_manager *mgr,
 	/* Allocate buffers from the service layer's pool. */
 	for (i = 0; i < NUM_SVC_BUFS; i++) {
 		kbuf = stratix10_svc_allocate_memory(priv->chan, SVC_BUF_SIZE);
-		if (!kbuf) {
+		if (IS_ERR(kbuf)) {
 			s10_free_buffers(mgr);
-			ret = -ENOMEM;
+			ret = PTR_ERR(kbuf);
 			goto init_done;
 		}
 
diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index 5f93a53846aa..9912b7a6a4b9 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -659,7 +659,7 @@ static void sbefifo_collect_async_ffdc(struct sbefifo *sbefifo)
 	}
         ffdc_iov.iov_base = ffdc;
 	ffdc_iov.iov_len = SBEFIFO_MAX_FFDC_SIZE;
-        iov_iter_kvec(&ffdc_iter, WRITE, &ffdc_iov, 1, SBEFIFO_MAX_FFDC_SIZE);
+        iov_iter_kvec(&ffdc_iter, ITER_DEST, &ffdc_iov, 1, SBEFIFO_MAX_FFDC_SIZE);
 	cmd[0] = cpu_to_be32(2);
 	cmd[1] = cpu_to_be32(SBEFIFO_CMD_GET_SBE_FFDC);
 	rc = sbefifo_do_command(sbefifo, cmd, 2, &ffdc_iter);
@@ -756,7 +756,7 @@ int sbefifo_submit(struct device *dev, const __be32 *command, size_t cmd_len,
 	rbytes = (*resp_len) * sizeof(__be32);
 	resp_iov.iov_base = response;
 	resp_iov.iov_len = rbytes;
-        iov_iter_kvec(&resp_iter, WRITE, &resp_iov, 1, rbytes);
+        iov_iter_kvec(&resp_iter, ITER_DEST, &resp_iov, 1, rbytes);
 
 	/* Perform the command */
 	rc = mutex_lock_interruptible(&sbefifo->lock);
@@ -839,7 +839,7 @@ static ssize_t sbefifo_user_read(struct file *file, char __user *buf,
 	/* Prepare iov iterator */
 	resp_iov.iov_base = buf;
 	resp_iov.iov_len = len;
-	iov_iter_init(&resp_iter, WRITE, &resp_iov, 1, len);
+	iov_iter_init(&resp_iter, ITER_DEST, &resp_iov, 1, len);
 
 	/* Perform the command */
 	rc = mutex_lock_interruptible(&sbefifo->lock);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 3bf4f2edc108..90e739d9aeee 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -790,8 +790,8 @@ static void gfx_v11_0_read_wave_data(struct amdgpu_device *adev, uint32_t simd,
 	 * zero here */
 	WARN_ON(simd != 0);
 
-	/* type 2 wave data */
-	dst[(*no_fields)++] = 2;
+	/* type 3 wave data */
+	dst[(*no_fields)++] = 3;
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_STATUS);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_LO);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_HI);
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
index 15eb3658d70e..09fdcd20cb91 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
@@ -337,7 +337,13 @@ const struct nbio_hdp_flush_reg nbio_v4_3_hdp_flush_reg = {
 
 static void nbio_v4_3_init_registers(struct amdgpu_device *adev)
 {
-	return;
+	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(4, 3, 0)) {
+		uint32_t data;
+
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF2_STRAP2);
+		data &= ~RCC_DEV0_EPF2_STRAP2__STRAP_NO_SOFT_RESET_DEV0_F2_MASK;
+		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF2_STRAP2, data);
+	}
 }
 
 static u32 nbio_v4_3_get_rom_offset(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 85bd1f18259c..b425ec00817c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8784,6 +8784,13 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		if (!dm_old_crtc_state->stream)
 			goto skip_modeset;
 
+		/* Unset freesync video if it was active before */
+		if (dm_old_crtc_state->freesync_config.state == VRR_STATE_ACTIVE_FIXED) {
+			dm_new_crtc_state->freesync_config.state = VRR_STATE_INACTIVE;
+			dm_new_crtc_state->freesync_config.fixed_refresh_in_uhz = 0;
+		}
+
+		/* Now check if we should set freesync video mode */
 		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
 						     old_crtc_state)) {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 2875f6bc3a6a..ed36088ebcfd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1498,6 +1498,20 @@ static int smu_disable_dpms(struct smu_context *smu)
 		}
 	}
 
+	/*
+	 * For SMU 13.0.4/11, PMFW will handle the features disablement properly
+	 * for gpu reset case. Driver involvement is unnecessary.
+	 */
+	if (amdgpu_in_reset(adev)) {
+		switch (adev->ip_versions[MP1_HWIP][0]) {
+		case IP_VERSION(13, 0, 4):
+		case IP_VERSION(13, 0, 11):
+			return 0;
+		default:
+			break;
+		}
+	}
+
 	/*
 	 * For gpu reset, runpm and hibernation through BACO,
 	 * BACO feature has to be kept enabled.
diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index ed05070b7307..92925f0f7239 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -1323,7 +1323,7 @@ static const struct intel_cdclk_vals adlp_cdclk_table[] = {
 	{ .refclk = 24000, .cdclk = 192000, .divider = 2, .ratio = 16 },
 	{ .refclk = 24000, .cdclk = 312000, .divider = 2, .ratio = 26 },
 	{ .refclk = 24000, .cdclk = 552000, .divider = 2, .ratio = 46 },
-	{ .refclk = 24400, .cdclk = 648000, .divider = 2, .ratio = 54 },
+	{ .refclk = 24000, .cdclk = 648000, .divider = 2, .ratio = 54 },
 
 	{ .refclk = 38400, .cdclk = 179200, .divider = 3, .ratio = 14 },
 	{ .refclk = 38400, .cdclk = 192000, .divider = 2, .ratio = 10 },
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 2353723ca1bd..598028870124 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1861,11 +1861,19 @@ static int get_ppgtt(struct drm_i915_file_private *file_priv,
 	vm = ctx->vm;
 	GEM_BUG_ON(!vm);
 
+	/*
+	 * Get a reference for the allocated handle.  Once the handle is
+	 * visible in the vm_xa table, userspace could try to close it
+	 * from under our feet, so we need to hold the extra reference
+	 * first.
+	 */
+	i915_vm_get(vm);
+
 	err = xa_alloc(&file_priv->vm_xa, &id, vm, xa_limit_32b, GFP_KERNEL);
-	if (err)
+	if (err) {
+		i915_vm_put(vm);
 		return err;
-
-	i915_vm_get(vm);
+	}
 
 	GEM_BUG_ON(id == 0); /* reserved for invalid/unassigned ppgtt */
 	args->value = id;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_tiling.c b/drivers/gpu/drm/i915/gem/i915_gem_tiling.c
index fd42b89b7162..bc21b1c2350a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_tiling.c
@@ -305,10 +305,6 @@ i915_gem_object_set_tiling(struct drm_i915_gem_object *obj,
 	spin_unlock(&obj->vma.lock);
 
 	obj->tiling_and_stride = tiling | stride;
-	i915_gem_object_unlock(obj);
-
-	/* Force the fence to be reacquired for GTT access */
-	i915_gem_object_release_mmap_gtt(obj);
 
 	/* Try to preallocate memory required to save swizzling on put-pages */
 	if (i915_gem_object_needs_bit17_swizzle(obj)) {
@@ -321,6 +317,11 @@ i915_gem_object_set_tiling(struct drm_i915_gem_object *obj,
 		obj->bit_17 = NULL;
 	}
 
+	i915_gem_object_unlock(obj);
+
+	/* Force the fence to be reacquired for GTT access */
+	i915_gem_object_release_mmap_gtt(obj);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index e94365b08f1e..2aa63ec521b8 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -528,7 +528,7 @@ struct i915_request *intel_context_create_request(struct intel_context *ce)
 	return rq;
 }
 
-struct i915_request *intel_context_find_active_request(struct intel_context *ce)
+struct i915_request *intel_context_get_active_request(struct intel_context *ce)
 {
 	struct intel_context *parent = intel_context_to_parent(ce);
 	struct i915_request *rq, *active = NULL;
@@ -552,6 +552,8 @@ struct i915_request *intel_context_find_active_request(struct intel_context *ce)
 
 		active = rq;
 	}
+	if (active)
+		active = i915_request_get_rcu(active);
 	spin_unlock_irqrestore(&parent->guc_state.lock, flags);
 
 	return active;
diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index be09fb2e883a..4ab6c8ddd6ec 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -268,8 +268,7 @@ int intel_context_prepare_remote_request(struct intel_context *ce,
 
 struct i915_request *intel_context_create_request(struct intel_context *ce);
 
-struct i915_request *
-intel_context_find_active_request(struct intel_context *ce);
+struct i915_request *intel_context_get_active_request(struct intel_context *ce);
 
 static inline bool intel_context_is_barrier(const struct intel_context *ce)
 {
diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index cbc8b857d5f7..7a4504ea35c3 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -248,8 +248,8 @@ void intel_engine_dump_active_requests(struct list_head *requests,
 ktime_t intel_engine_get_busy_time(struct intel_engine_cs *engine,
 				   ktime_t *now);
 
-struct i915_request *
-intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine);
+void intel_engine_get_hung_entity(struct intel_engine_cs *engine,
+				  struct intel_context **ce, struct i915_request **rq);
 
 u32 intel_engine_context_size(struct intel_gt *gt, u8 class);
 struct intel_context *
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index fcbccd8d244e..b458547e1fc6 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -2078,17 +2078,6 @@ static void print_request_ring(struct drm_printer *m, struct i915_request *rq)
 	}
 }
 
-static unsigned long list_count(struct list_head *list)
-{
-	struct list_head *pos;
-	unsigned long count = 0;
-
-	list_for_each(pos, list)
-		count++;
-
-	return count;
-}
-
 static unsigned long read_ul(void *p, size_t x)
 {
 	return *(unsigned long *)(p + x);
@@ -2180,11 +2169,11 @@ void intel_engine_dump_active_requests(struct list_head *requests,
 	}
 }
 
-static void engine_dump_active_requests(struct intel_engine_cs *engine, struct drm_printer *m)
+static void engine_dump_active_requests(struct intel_engine_cs *engine,
+					struct drm_printer *m)
 {
+	struct intel_context *hung_ce = NULL;
 	struct i915_request *hung_rq = NULL;
-	struct intel_context *ce;
-	bool guc;
 
 	/*
 	 * No need for an engine->irq_seqno_barrier() before the seqno reads.
@@ -2193,27 +2182,22 @@ static void engine_dump_active_requests(struct intel_engine_cs *engine, struct d
 	 * But the intention here is just to report an instantaneous snapshot
 	 * so that's fine.
 	 */
-	lockdep_assert_held(&engine->sched_engine->lock);
+	intel_engine_get_hung_entity(engine, &hung_ce, &hung_rq);
 
 	drm_printf(m, "\tRequests:\n");
 
-	guc = intel_uc_uses_guc_submission(&engine->gt->uc);
-	if (guc) {
-		ce = intel_engine_get_hung_context(engine);
-		if (ce)
-			hung_rq = intel_context_find_active_request(ce);
-	} else {
-		hung_rq = intel_engine_execlist_find_hung_request(engine);
-	}
-
 	if (hung_rq)
 		engine_dump_request(hung_rq, m, "\t\thung");
+	else if (hung_ce)
+		drm_printf(m, "\t\tGot hung ce but no hung rq!\n");
 
-	if (guc)
+	if (intel_uc_uses_guc_submission(&engine->gt->uc))
 		intel_guc_dump_active_requests(engine, hung_rq, m);
 	else
-		intel_engine_dump_active_requests(&engine->sched_engine->requests,
-						  hung_rq, m);
+		intel_execlists_dump_active_requests(engine, hung_rq, m);
+
+	if (hung_rq)
+		i915_request_put(hung_rq);
 }
 
 void intel_engine_dump(struct intel_engine_cs *engine,
@@ -2223,7 +2207,6 @@ void intel_engine_dump(struct intel_engine_cs *engine,
 	struct i915_gpu_error * const error = &engine->i915->gpu_error;
 	struct i915_request *rq;
 	intel_wakeref_t wakeref;
-	unsigned long flags;
 	ktime_t dummy;
 
 	if (header) {
@@ -2260,13 +2243,8 @@ void intel_engine_dump(struct intel_engine_cs *engine,
 		   i915_reset_count(error));
 	print_properties(engine, m);
 
-	spin_lock_irqsave(&engine->sched_engine->lock, flags);
 	engine_dump_active_requests(engine, m);
 
-	drm_printf(m, "\tOn hold?: %lu\n",
-		   list_count(&engine->sched_engine->hold));
-	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
-
 	drm_printf(m, "\tMMIO base:  0x%08x\n", engine->mmio_base);
 	wakeref = intel_runtime_pm_get_if_in_use(engine->uncore->rpm);
 	if (wakeref) {
@@ -2312,8 +2290,7 @@ intel_engine_create_virtual(struct intel_engine_cs **siblings,
 	return siblings[0]->cops->create_virtual(siblings, count, flags);
 }
 
-struct i915_request *
-intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine)
+static struct i915_request *engine_execlist_find_hung_request(struct intel_engine_cs *engine)
 {
 	struct i915_request *request, *active = NULL;
 
@@ -2365,6 +2342,33 @@ intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine)
 	return active;
 }
 
+void intel_engine_get_hung_entity(struct intel_engine_cs *engine,
+				  struct intel_context **ce, struct i915_request **rq)
+{
+	unsigned long flags;
+
+	*ce = intel_engine_get_hung_context(engine);
+	if (*ce) {
+		intel_engine_clear_hung_context(engine);
+
+		*rq = intel_context_get_active_request(*ce);
+		return;
+	}
+
+	/*
+	 * Getting here with GuC enabled means it is a forced error capture
+	 * with no actual hang. So, no need to attempt the execlist search.
+	 */
+	if (intel_uc_uses_guc_submission(&engine->gt->uc))
+		return;
+
+	spin_lock_irqsave(&engine->sched_engine->lock, flags);
+	*rq = engine_execlist_find_hung_request(engine);
+	if (*rq)
+		*rq = i915_request_get_rcu(*rq);
+	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
+}
+
 void xehp_enable_ccs_engines(struct intel_engine_cs *engine)
 {
 	/*
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index c718e6dc40b5..bfd1ffc71a48 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -4144,6 +4144,33 @@ void intel_execlists_show_requests(struct intel_engine_cs *engine,
 	spin_unlock_irqrestore(&sched_engine->lock, flags);
 }
 
+static unsigned long list_count(struct list_head *list)
+{
+	struct list_head *pos;
+	unsigned long count = 0;
+
+	list_for_each(pos, list)
+		count++;
+
+	return count;
+}
+
+void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
+					  struct i915_request *hung_rq,
+					  struct drm_printer *m)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&engine->sched_engine->lock, flags);
+
+	intel_engine_dump_active_requests(&engine->sched_engine->requests, hung_rq, m);
+
+	drm_printf(m, "\tOn hold?: %lu\n",
+		   list_count(&engine->sched_engine->hold));
+
+	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_execlists.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.h b/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
index a1aa92c983a5..d2c7d45ea062 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
@@ -32,6 +32,10 @@ void intel_execlists_show_requests(struct intel_engine_cs *engine,
 							int indent),
 				   unsigned int max);
 
+void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
+					  struct i915_request *hung_rq,
+					  struct drm_printer *m);
+
 bool
 intel_engine_in_execlists_submission_mode(const struct intel_engine_cs *engine);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 1a23e901cc66..0ec07dad1dcf 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1685,7 +1685,7 @@ static void __guc_reset_context(struct intel_context *ce, intel_engine_mask_t st
 			goto next_context;
 
 		guilty = false;
-		rq = intel_context_find_active_request(ce);
+		rq = intel_context_get_active_request(ce);
 		if (!rq) {
 			head = ce->ring->tail;
 			goto out_replay;
@@ -1698,6 +1698,7 @@ static void __guc_reset_context(struct intel_context *ce, intel_engine_mask_t st
 		head = intel_ring_wrap(ce->ring, rq->head);
 
 		__i915_request_reset(rq, guilty);
+		i915_request_put(rq);
 out_replay:
 		guc_reset_state(ce, head, guilty);
 next_context:
@@ -4587,6 +4588,8 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 
 	xa_lock_irqsave(&guc->context_lookup, flags);
 	xa_for_each(&guc->context_lookup, index, ce) {
+		bool found;
+
 		if (!kref_get_unless_zero(&ce->ref))
 			continue;
 
@@ -4603,10 +4606,18 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 				goto next;
 		}
 
+		found = false;
+		spin_lock(&ce->guc_state.lock);
 		list_for_each_entry(rq, &ce->guc_state.requests, sched.link) {
 			if (i915_test_request_state(rq) != I915_REQUEST_ACTIVE)
 				continue;
 
+			found = true;
+			break;
+		}
+		spin_unlock(&ce->guc_state.lock);
+
+		if (found) {
 			intel_engine_set_hung_context(engine, ce);
 
 			/* Can only cope with one hang at a time... */
@@ -4614,6 +4625,7 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 			xa_lock(&guc->context_lookup);
 			goto done;
 		}
+
 next:
 		intel_context_put(ce);
 		xa_lock(&guc->context_lookup);
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index 9ea2fe34e7d3..847b9e6af1a1 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1592,43 +1592,20 @@ capture_engine(struct intel_engine_cs *engine,
 {
 	struct intel_engine_capture_vma *capture = NULL;
 	struct intel_engine_coredump *ee;
-	struct intel_context *ce;
+	struct intel_context *ce = NULL;
 	struct i915_request *rq = NULL;
-	unsigned long flags;
 
 	ee = intel_engine_coredump_alloc(engine, ALLOW_FAIL, dump_flags);
 	if (!ee)
 		return NULL;
 
-	ce = intel_engine_get_hung_context(engine);
-	if (ce) {
-		intel_engine_clear_hung_context(engine);
-		rq = intel_context_find_active_request(ce);
-		if (!rq || !i915_request_started(rq))
-			goto no_request_capture;
-	} else {
-		/*
-		 * Getting here with GuC enabled means it is a forced error capture
-		 * with no actual hang. So, no need to attempt the execlist search.
-		 */
-		if (!intel_uc_uses_guc_submission(&engine->gt->uc)) {
-			spin_lock_irqsave(&engine->sched_engine->lock, flags);
-			rq = intel_engine_execlist_find_hung_request(engine);
-			spin_unlock_irqrestore(&engine->sched_engine->lock,
-					       flags);
-		}
-	}
-	if (rq)
-		rq = i915_request_get_rcu(rq);
-
-	if (!rq)
+	intel_engine_get_hung_entity(engine, &ce, &rq);
+	if (!rq || !i915_request_started(rq))
 		goto no_request_capture;
 
 	capture = intel_engine_coredump_add_request(ee, rq, ATOMIC_MAYFAIL);
-	if (!capture) {
-		i915_request_put(rq);
+	if (!capture)
 		goto no_request_capture;
-	}
 	if (dump_flags & CORE_DUMP_FLAG_IS_GUC_CAPTURE)
 		intel_guc_capture_get_matching_node(engine->gt, ee, ce);
 
@@ -1638,6 +1615,8 @@ capture_engine(struct intel_engine_cs *engine,
 	return ee;
 
 no_request_capture:
+	if (rq)
+		i915_request_put(rq);
 	kfree(ee);
 	return NULL;
 }
diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 857a2f0420d7..c924f1124ebc 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1193,14 +1193,11 @@ static int boe_panel_enter_sleep_mode(struct boe_panel *boe)
 	return 0;
 }
 
-static int boe_panel_unprepare(struct drm_panel *panel)
+static int boe_panel_disable(struct drm_panel *panel)
 {
 	struct boe_panel *boe = to_boe_panel(panel);
 	int ret;
 
-	if (!boe->prepared)
-		return 0;
-
 	ret = boe_panel_enter_sleep_mode(boe);
 	if (ret < 0) {
 		dev_err(panel->dev, "failed to set panel off: %d\n", ret);
@@ -1209,6 +1206,16 @@ static int boe_panel_unprepare(struct drm_panel *panel)
 
 	msleep(150);
 
+	return 0;
+}
+
+static int boe_panel_unprepare(struct drm_panel *panel)
+{
+	struct boe_panel *boe = to_boe_panel(panel);
+
+	if (!boe->prepared)
+		return 0;
+
 	if (boe->desc->discharge_on_disable) {
 		regulator_disable(boe->avee);
 		regulator_disable(boe->avdd);
@@ -1528,6 +1535,7 @@ static enum drm_panel_orientation boe_panel_get_orientation(struct drm_panel *pa
 }
 
 static const struct drm_panel_funcs boe_panel_funcs = {
+	.disable = boe_panel_disable,
 	.unprepare = boe_panel_unprepare,
 	.prepare = boe_panel_prepare,
 	.enable = boe_panel_enable,
diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index bc41a5ae810a..4bb3a247732d 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -665,18 +665,8 @@ static const struct drm_crtc_helper_funcs ssd130x_crtc_helper_funcs = {
 	.atomic_check = ssd130x_crtc_helper_atomic_check,
 };
 
-static void ssd130x_crtc_reset(struct drm_crtc *crtc)
-{
-	struct drm_device *drm = crtc->dev;
-	struct ssd130x_device *ssd130x = drm_to_ssd130x(drm);
-
-	ssd130x_init(ssd130x);
-
-	drm_atomic_helper_crtc_reset(crtc);
-}
-
 static const struct drm_crtc_funcs ssd130x_crtc_funcs = {
-	.reset = ssd130x_crtc_reset,
+	.reset = drm_atomic_helper_crtc_reset,
 	.destroy = drm_crtc_cleanup,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
@@ -695,6 +685,12 @@ static void ssd130x_encoder_helper_atomic_enable(struct drm_encoder *encoder,
 	if (ret)
 		return;
 
+	ret = ssd130x_init(ssd130x);
+	if (ret) {
+		ssd130x_power_off(ssd130x);
+		return;
+	}
+
 	ssd130x_write_cmd(ssd130x, 1, SSD130X_DISPLAY_ON);
 
 	backlight_enable(ssd130x->bl_dev);
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 470432c8fd70..c4b73d9dd040 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -3009,7 +3009,8 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	}
 
 	vc4_hdmi->cec_adap = cec_allocate_adapter(&vc4_hdmi_cec_adap_ops,
-						  vc4_hdmi, "vc4",
+						  vc4_hdmi,
+						  vc4_hdmi->variant->card_name,
 						  CEC_CAP_DEFAULTS |
 						  CEC_CAP_CONNECTOR_INFO, 1);
 	ret = PTR_ERR_OR_ZERO(vc4_hdmi->cec_adap);
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 6c127f061f06..f98c849096f7 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1911,7 +1911,7 @@ static void  hv_balloon_debugfs_init(struct hv_dynmem_device *b)
 
 static void  hv_balloon_debugfs_exit(struct hv_dynmem_device *b)
 {
-	debugfs_remove(debugfs_lookup("hv-balloon", NULL));
+	debugfs_lookup_and_remove("hv-balloon", NULL);
 }
 
 #else
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index e499f96506c5..782fe1ef3ca1 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -396,6 +396,8 @@ static const struct pci_device_id i2_designware_pci_ids[] = {
 	{ PCI_VDEVICE(ATI,  0x73a4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73e4), navi_amd },
 	{ PCI_VDEVICE(ATI,  0x73c4), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7444), navi_amd },
+	{ PCI_VDEVICE(ATI,  0x7464), navi_amd },
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 5af5cffc444e..d113bed79545 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -826,8 +826,8 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	/* Setup the DMA */
 	i2c->dmach = dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
-		dev_err(dev, "Failed to request dma\n");
-		return PTR_ERR(i2c->dmach);
+		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
+				     "Failed to request dma\n");
 	}
 
 	platform_set_drvdata(pdev, i2c);
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index d1658ed76562..b31cf4f18f85 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -80,7 +80,7 @@ enum {
 #define DEFAULT_SCL_RATE  (100 * 1000) /* Hz */
 
 /**
- * struct i2c_spec_values:
+ * struct i2c_spec_values - I2C specification values for various modes
  * @min_hold_start_ns: min hold time (repeated) START condition
  * @min_low_ns: min LOW period of the SCL clock
  * @min_high_ns: min HIGH period of the SCL cloc
@@ -136,7 +136,7 @@ static const struct i2c_spec_values fast_mode_plus_spec = {
 };
 
 /**
- * struct rk3x_i2c_calced_timings:
+ * struct rk3x_i2c_calced_timings - calculated V1 timings
  * @div_low: Divider output for low
  * @div_high: Divider output for high
  * @tuning: Used to adjust setup/hold data time,
@@ -159,7 +159,7 @@ enum rk3x_i2c_state {
 };
 
 /**
- * struct rk3x_i2c_soc_data:
+ * struct rk3x_i2c_soc_data - SOC-specific data
  * @grf_offset: offset inside the grf regmap for setting the i2c type
  * @calc_timings: Callback function for i2c timing information calculated
  */
@@ -239,7 +239,8 @@ static inline void rk3x_i2c_clean_ipd(struct rk3x_i2c *i2c)
 }
 
 /**
- * Generate a START condition, which triggers a REG_INT_START interrupt.
+ * rk3x_i2c_start - Generate a START condition, which triggers a REG_INT_START interrupt.
+ * @i2c: target controller data
  */
 static void rk3x_i2c_start(struct rk3x_i2c *i2c)
 {
@@ -258,8 +259,8 @@ static void rk3x_i2c_start(struct rk3x_i2c *i2c)
 }
 
 /**
- * Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
- *
+ * rk3x_i2c_stop - Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
+ * @i2c: target controller data
  * @error: Error code to return in rk3x_i2c_xfer
  */
 static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
@@ -298,7 +299,8 @@ static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
 }
 
 /**
- * Setup a read according to i2c->msg
+ * rk3x_i2c_prepare_read - Setup a read according to i2c->msg
+ * @i2c: target controller data
  */
 static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
 {
@@ -329,7 +331,8 @@ static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
 }
 
 /**
- * Fill the transmit buffer with data from i2c->msg
+ * rk3x_i2c_fill_transmit_buf - Fill the transmit buffer with data from i2c->msg
+ * @i2c: target controller data
  */
 static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
 {
@@ -532,11 +535,10 @@ static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
 }
 
 /**
- * Get timing values of I2C specification
- *
+ * rk3x_i2c_get_spec - Get timing values of I2C specification
  * @speed: Desired SCL frequency
  *
- * Returns: Matched i2c spec values.
+ * Return: Matched i2c_spec_values.
  */
 static const struct i2c_spec_values *rk3x_i2c_get_spec(unsigned int speed)
 {
@@ -549,13 +551,12 @@ static const struct i2c_spec_values *rk3x_i2c_get_spec(unsigned int speed)
 }
 
 /**
- * Calculate divider values for desired SCL frequency
- *
+ * rk3x_i2c_v0_calc_timings - Calculate divider values for desired SCL frequency
  * @clk_rate: I2C input clock rate
  * @t: Known I2C timing information
  * @t_calc: Caculated rk3x private timings that would be written into regs
  *
- * Returns: 0 on success, -EINVAL if the goal SCL rate is too slow. In that case
+ * Return: %0 on success, -%EINVAL if the goal SCL rate is too slow. In that case
  * a best-effort divider value is returned in divs. If the target rate is
  * too high, we silently use the highest possible rate.
  */
@@ -710,13 +711,12 @@ static int rk3x_i2c_v0_calc_timings(unsigned long clk_rate,
 }
 
 /**
- * Calculate timing values for desired SCL frequency
- *
+ * rk3x_i2c_v1_calc_timings - Calculate timing values for desired SCL frequency
  * @clk_rate: I2C input clock rate
  * @t: Known I2C timing information
  * @t_calc: Caculated rk3x private timings that would be written into regs
  *
- * Returns: 0 on success, -EINVAL if the goal SCL rate is too slow. In that case
+ * Return: %0 on success, -%EINVAL if the goal SCL rate is too slow. In that case
  * a best-effort divider value is returned in divs. If the target rate is
  * too high, we silently use the highest possible rate.
  * The following formulas are v1's method to calculate timings.
@@ -960,14 +960,14 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
 }
 
 /**
- * Setup I2C registers for an I2C operation specified by msgs, num.
- *
- * Must be called with i2c->lock held.
- *
+ * rk3x_i2c_setup - Setup I2C registers for an I2C operation specified by msgs, num.
+ * @i2c: target controller data
  * @msgs: I2C msgs to process
  * @num: Number of msgs
  *
- * returns: Number of I2C msgs processed or negative in case of error
+ * Must be called with i2c->lock held.
+ *
+ * Return: Number of I2C msgs processed or negative in case of error
  */
 static int rk3x_i2c_setup(struct rk3x_i2c *i2c, struct i2c_msg *msgs, int num)
 {
diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index a2def6f9380a..5eac7ea19993 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -280,6 +280,7 @@ static int accel_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 			hid_sensor_convert_timestamp(
 					&accel_state->common_attributes,
 					*(int64_t *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;
diff --git a/drivers/iio/adc/berlin2-adc.c b/drivers/iio/adc/berlin2-adc.c
index 3d2e8b4db61a..a4e7c7eff5ac 100644
--- a/drivers/iio/adc/berlin2-adc.c
+++ b/drivers/iio/adc/berlin2-adc.c
@@ -298,8 +298,10 @@ static int berlin2_adc_probe(struct platform_device *pdev)
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*priv));
-	if (!indio_dev)
+	if (!indio_dev) {
+		of_node_put(parent_np);
 		return -ENOMEM;
+	}
 
 	priv = iio_priv(indio_dev);
 
diff --git a/drivers/iio/adc/imx8qxp-adc.c b/drivers/iio/adc/imx8qxp-adc.c
index 36777b827165..f5a0fc9e64c5 100644
--- a/drivers/iio/adc/imx8qxp-adc.c
+++ b/drivers/iio/adc/imx8qxp-adc.c
@@ -86,6 +86,8 @@
 
 #define IMX8QXP_ADC_TIMEOUT		msecs_to_jiffies(100)
 
+#define IMX8QXP_ADC_MAX_FIFO_SIZE		16
+
 struct imx8qxp_adc {
 	struct device *dev;
 	void __iomem *regs;
@@ -95,6 +97,7 @@ struct imx8qxp_adc {
 	/* Serialise ADC channel reads */
 	struct mutex lock;
 	struct completion completion;
+	u32 fifo[IMX8QXP_ADC_MAX_FIFO_SIZE];
 };
 
 #define IMX8QXP_ADC_CHAN(_idx) {				\
@@ -238,8 +241,7 @@ static int imx8qxp_adc_read_raw(struct iio_dev *indio_dev,
 			return ret;
 		}
 
-		*val = FIELD_GET(IMX8QXP_ADC_RESFIFO_VAL_MASK,
-				 readl(adc->regs + IMX8QXP_ADR_ADC_RESFIFO));
+		*val = adc->fifo[0];
 
 		mutex_unlock(&adc->lock);
 		return IIO_VAL_INT;
@@ -265,10 +267,15 @@ static irqreturn_t imx8qxp_adc_isr(int irq, void *dev_id)
 {
 	struct imx8qxp_adc *adc = dev_id;
 	u32 fifo_count;
+	int i;
 
 	fifo_count = FIELD_GET(IMX8QXP_ADC_FCTRL_FCOUNT_MASK,
 			       readl(adc->regs + IMX8QXP_ADR_ADC_FCTRL));
 
+	for (i = 0; i < fifo_count; i++)
+		adc->fifo[i] = FIELD_GET(IMX8QXP_ADC_RESFIFO_VAL_MASK,
+				readl_relaxed(adc->regs + IMX8QXP_ADR_ADC_RESFIFO));
+
 	if (fifo_count)
 		complete(&adc->completion);
 
diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 6d21ea84fa82..a428bdb567d5 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1520,6 +1520,7 @@ static const struct of_device_id stm32_dfsdm_adc_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, stm32_dfsdm_adc_match);
 
 static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 {
diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index f53e8558b560..32873fb5f367 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -57,6 +57,18 @@
 #define TWL6030_GPADCS				BIT(1)
 #define TWL6030_GPADCR				BIT(0)
 
+#define USB_VBUS_CTRL_SET			0x04
+#define USB_ID_CTRL_SET				0x06
+
+#define TWL6030_MISC1				0xE4
+#define VBUS_MEAS				0x01
+#define ID_MEAS					0x01
+
+#define VAC_MEAS                0x04
+#define VBAT_MEAS               0x02
+#define BB_MEAS                 0x01
+
+
 /**
  * struct twl6030_chnl_calib - channel calibration
  * @gain:		slope coefficient for ideal curve
@@ -927,6 +939,26 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, VBUS_MEAS, USB_VBUS_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, ID_MEAS, USB_ID_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
+				VBAT_MEAS | BB_MEAS | VAC_MEAS,
+				TWL6030_MISC1);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
 	indio_dev->name = DRIVER_NAME;
 	indio_dev->info = &twl6030_gpadc_iio_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index 5b4bdf3a26bb..a507d2e17079 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1329,7 +1329,7 @@ static int ams_parse_firmware(struct iio_dev *indio_dev)
 
 	dev_channels = devm_krealloc(dev, ams_channels, dev_size, GFP_KERNEL);
 	if (!dev_channels)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	indio_dev->channels = dev_channels;
 	indio_dev->num_channels = num_channels;
diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index 8f0ad022c7f1..698c50da1f10 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -231,6 +231,7 @@ static int gyro_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 		gyro_state->timestamp =
 			hid_sensor_convert_timestamp(&gyro_state->common_attributes,
 						     *(s64 *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;
diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 423cfe526f2a..6d189c4b9ff9 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -10,6 +10,7 @@
 #include <linux/regmap.h>
 #include <linux/acpi.h>
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -144,9 +145,8 @@
 #define FXOS8700_NVM_DATA_BNK0      0xa7
 
 /* Bit definitions for FXOS8700_CTRL_REG1 */
-#define FXOS8700_CTRL_ODR_MSK       0x38
 #define FXOS8700_CTRL_ODR_MAX       0x00
-#define FXOS8700_CTRL_ODR_MIN       GENMASK(4, 3)
+#define FXOS8700_CTRL_ODR_MSK       GENMASK(5, 3)
 
 /* Bit definitions for FXOS8700_M_CTRL_REG1 */
 #define FXOS8700_HMS_MASK           GENMASK(1, 0)
@@ -320,7 +320,7 @@ static enum fxos8700_sensor fxos8700_to_sensor(enum iio_chan_type iio_type)
 	switch (iio_type) {
 	case IIO_ACCEL:
 		return FXOS8700_ACCEL;
-	case IIO_ANGL_VEL:
+	case IIO_MAGN:
 		return FXOS8700_MAGN;
 	default:
 		return -EINVAL;
@@ -345,15 +345,35 @@ static int fxos8700_set_active_mode(struct fxos8700_data *data,
 static int fxos8700_set_scale(struct fxos8700_data *data,
 			      enum fxos8700_sensor t, int uscale)
 {
-	int i;
+	int i, ret, val;
+	bool active_mode;
 	static const int scale_num = ARRAY_SIZE(fxos8700_accel_scale);
 	struct device *dev = regmap_get_device(data->regmap);
 
 	if (t == FXOS8700_MAGN) {
-		dev_err(dev, "Magnetometer scale is locked at 1200uT\n");
+		dev_err(dev, "Magnetometer scale is locked at 0.001Gs\n");
 		return -EINVAL;
 	}
 
+	/*
+	 * When device is in active mode, it failed to set an ACCEL
+	 * full-scale range(2g/4g/8g) in FXOS8700_XYZ_DATA_CFG.
+	 * This is not align with the datasheet, but it is a fxos8700
+	 * chip behavier. Set the device in standby mode before setting
+	 * an ACCEL full-scale range.
+	 */
+	ret = regmap_read(data->regmap, FXOS8700_CTRL_REG1, &val);
+	if (ret)
+		return ret;
+
+	active_mode = val & FXOS8700_ACTIVE;
+	if (active_mode) {
+		ret = regmap_write(data->regmap, FXOS8700_CTRL_REG1,
+				   val & ~FXOS8700_ACTIVE);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; i < scale_num; i++)
 		if (fxos8700_accel_scale[i].uscale == uscale)
 			break;
@@ -361,8 +381,12 @@ static int fxos8700_set_scale(struct fxos8700_data *data,
 	if (i == scale_num)
 		return -EINVAL;
 
-	return regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG,
+	ret = regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG,
 			    fxos8700_accel_scale[i].bits);
+	if (ret)
+		return ret;
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1,
+				  active_mode);
 }
 
 static int fxos8700_get_scale(struct fxos8700_data *data,
@@ -372,7 +396,7 @@ static int fxos8700_get_scale(struct fxos8700_data *data,
 	static const int scale_num = ARRAY_SIZE(fxos8700_accel_scale);
 
 	if (t == FXOS8700_MAGN) {
-		*uscale = 1200; /* Magnetometer is locked at 1200uT */
+		*uscale = 1000; /* Magnetometer is locked at 0.001Gs */
 		return 0;
 	}
 
@@ -394,22 +418,61 @@ static int fxos8700_get_data(struct fxos8700_data *data, int chan_type,
 			     int axis, int *val)
 {
 	u8 base, reg;
+	s16 tmp;
 	int ret;
-	enum fxos8700_sensor type = fxos8700_to_sensor(chan_type);
 
-	base = type ? FXOS8700_OUT_X_MSB : FXOS8700_M_OUT_X_MSB;
+	/*
+	 * Different register base addresses varies with channel types.
+	 * This bug hasn't been noticed before because using an enum is
+	 * really hard to read. Use an a switch statement to take over that.
+	 */
+	switch (chan_type) {
+	case IIO_ACCEL:
+		base = FXOS8700_OUT_X_MSB;
+		break;
+	case IIO_MAGN:
+		base = FXOS8700_M_OUT_X_MSB;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Block read 6 bytes of device output registers to avoid data loss */
 	ret = regmap_bulk_read(data->regmap, base, data->buf,
-			       FXOS8700_DATA_BUF_SIZE);
+			       sizeof(data->buf));
 	if (ret)
 		return ret;
 
 	/* Convert axis to buffer index */
 	reg = axis - IIO_MOD_X;
 
+	/*
+	 * Convert to native endianness. The accel data and magn data
+	 * are signed, so a forced type conversion is needed.
+	 */
+	tmp = be16_to_cpu(data->buf[reg]);
+
+	/*
+	 * ACCEL output data registers contain the X-axis, Y-axis, and Z-axis
+	 * 14-bit left-justified sample data and MAGN output data registers
+	 * contain the X-axis, Y-axis, and Z-axis 16-bit sample data. Apply
+	 * a signed 2 bits right shift to the readback raw data from ACCEL
+	 * output data register and keep that from MAGN sensor as the origin.
+	 * Value should be extended to 32 bit.
+	 */
+	switch (chan_type) {
+	case IIO_ACCEL:
+		tmp = tmp >> 2;
+		break;
+	case IIO_MAGN:
+		/* Nothing to do */
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* Convert to native endianness */
-	*val = sign_extend32(be16_to_cpu(data->buf[reg]), 15);
+	*val = sign_extend32(tmp, 15);
 
 	return 0;
 }
@@ -445,10 +508,9 @@ static int fxos8700_set_odr(struct fxos8700_data *data, enum fxos8700_sensor t,
 	if (i >= odr_num)
 		return -EINVAL;
 
-	return regmap_update_bits(data->regmap,
-				  FXOS8700_CTRL_REG1,
-				  FXOS8700_CTRL_ODR_MSK + FXOS8700_ACTIVE,
-				  fxos8700_odr[i].bits << 3 | active_mode);
+	val &= ~FXOS8700_CTRL_ODR_MSK;
+	val |= FIELD_PREP(FXOS8700_CTRL_ODR_MSK, fxos8700_odr[i].bits) | FXOS8700_ACTIVE;
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1, val);
 }
 
 static int fxos8700_get_odr(struct fxos8700_data *data, enum fxos8700_sensor t,
@@ -461,7 +523,7 @@ static int fxos8700_get_odr(struct fxos8700_data *data, enum fxos8700_sensor t,
 	if (ret)
 		return ret;
 
-	val &= FXOS8700_CTRL_ODR_MSK;
+	val = FIELD_GET(FXOS8700_CTRL_ODR_MSK, val);
 
 	for (i = 0; i < odr_num; i++)
 		if (val == fxos8700_odr[i].bits)
@@ -526,7 +588,7 @@ static IIO_CONST_ATTR(in_accel_sampling_frequency_available,
 static IIO_CONST_ATTR(in_magn_sampling_frequency_available,
 		      "1.5625 6.25 12.5 50 100 200 400 800");
 static IIO_CONST_ATTR(in_accel_scale_available, "0.000244 0.000488 0.000976");
-static IIO_CONST_ATTR(in_magn_scale_available, "0.000001200");
+static IIO_CONST_ATTR(in_magn_scale_available, "0.001000");
 
 static struct attribute *fxos8700_attrs[] = {
 	&iio_const_attr_in_accel_sampling_frequency_available.dev_attr.attr,
@@ -592,14 +654,19 @@ static int fxos8700_chip_init(struct fxos8700_data *data, bool use_spi)
 	if (ret)
 		return ret;
 
-	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
-	ret = regmap_write(data->regmap, FXOS8700_CTRL_REG1,
-			   FXOS8700_CTRL_ODR_MAX | FXOS8700_ACTIVE);
+	/*
+	 * Set max full-scale range (+/-8G) for ACCEL sensor in chip
+	 * initialization then activate the device.
+	 */
+	ret = regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG, MODE_8G);
 	if (ret)
 		return ret;
 
-	/* Set for max full-scale range (+/-8G) */
-	return regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG, MODE_8G);
+	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
+	return regmap_update_bits(data->regmap, FXOS8700_CTRL_REG1,
+				FXOS8700_CTRL_ODR_MSK | FXOS8700_ACTIVE,
+				FIELD_PREP(FXOS8700_CTRL_ODR_MSK, FXOS8700_CTRL_ODR_MAX) |
+				FXOS8700_ACTIVE);
 }
 
 static void fxos8700_chip_uninit(void *data)
diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
index 001055d09750..b1674a5bfa36 100644
--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -440,6 +440,8 @@ static int cm32181_probe(struct i2c_client *client)
 	if (!indio_dev)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, indio_dev);
+
 	/*
 	 * Some ACPI systems list 2 I2C resources for the CM3218 sensor, the
 	 * SMBus Alert Response Address (ARA, 0x0c) and the actual I2C address.
@@ -460,8 +462,6 @@ static int cm32181_probe(struct i2c_client *client)
 			return PTR_ERR(client);
 	}
 
-	i2c_set_clientdata(client, indio_dev);
-
 	cm32181 = iio_priv(indio_dev);
 	cm32181->client = client;
 	cm32181->dev = dev;
@@ -490,7 +490,8 @@ static int cm32181_probe(struct i2c_client *client)
 
 static int cm32181_suspend(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	struct i2c_client *client = cm32181->client;
 
 	return i2c_smbus_write_word_data(client, CM32181_REG_ADDR_CMD,
 					 CM32181_CMD_ALS_DISABLE);
@@ -498,8 +499,8 @@ static int cm32181_suspend(struct device *dev)
 
 static int cm32181_resume(struct device *dev)
 {
-	struct i2c_client *client = to_i2c_client(dev);
 	struct cm32181_chip *cm32181 = iio_priv(dev_get_drvdata(dev));
+	struct i2c_client *client = cm32181->client;
 
 	return i2c_smbus_write_word_data(client, CM32181_REG_ADDR_CMD,
 					 cm32181->conf_regs[CM32181_REG_ADDR_CMD]);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 8546b8816524..730f2f1e09bb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -966,7 +966,7 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 	refcount_set(&req->ref, 1);
 	req->mp_policy = clt_path->clt->mp_policy;
 
-	iov_iter_kvec(&iter, READ, vec, 1, usr_len);
+	iov_iter_kvec(&iter, ITER_SOURCE, vec, 1, usr_len);
 	len = _copy_from_iter(req->iu->buf, usr_len, &iter);
 	WARN_ON(len != usr_len);
 
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index a77195e378b7..c24771336f61 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -706,7 +706,7 @@ l1oip_socket_thread(void *data)
 		printk(KERN_DEBUG "%s: socket created and open\n",
 		       __func__);
 	while (!signal_pending(current)) {
-		iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, recvbuf_size);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, recvbuf_size);
 		recvlen = sock_recvmsg(socket, &msg, 0);
 		if (recvlen > 0) {
 			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 97413586195b..f96034e0ba4f 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -106,7 +106,8 @@ static inline unsigned long bkey_bytes(const struct bkey *k)
 	return bkey_u64s(k) * sizeof(__u64);
 }
 
-#define bkey_copy(_dest, _src)	memcpy(_dest, _src, bkey_bytes(_src))
+#define bkey_copy(_dest, _src)	unsafe_memcpy(_dest, _src, bkey_bytes(_src), \
+					/* bkey is always padded */)
 
 static inline void bkey_copy_key(struct bkey *dest, const struct bkey *src)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e5da469a4235..c182c21de2e8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -149,7 +149,8 @@ reread:		left = ca->sb.bucket_size - offset;
 				    bytes, GFP_KERNEL);
 			if (!i)
 				return -ENOMEM;
-			memcpy(&i->j, j, bytes);
+			unsafe_memcpy(&i->j, j, bytes,
+				/* "bytes" was calculated by set_bytes() above */);
 			/* Add to the location after 'where' points to */
 			list_add(&i->list, where);
 			ret = 1;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
index 3d3b6dc24ca6..002ea6588edf 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -150,8 +150,8 @@ static int user_to_new(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
 			 * then return an error.
 			 */
 			if (strlen(ctrl->p_new.p_char) == ctrl->maximum && last)
-			ctrl->is_new = 1;
 				return -ERANGE;
+			ctrl->is_new = 1;
 		}
 		return ret;
 	default:
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 844264e1b88c..73d71c4ec139 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -3044,7 +3044,7 @@ ssize_t vmci_qpair_enqueue(struct vmci_qp *qpair,
 	if (!qpair || !buf)
 		return VMCI_ERROR_INVALID_ARGS;
 
-	iov_iter_kvec(&from, WRITE, &v, 1, buf_size);
+	iov_iter_kvec(&from, ITER_SOURCE, &v, 1, buf_size);
 
 	qp_lock(qpair);
 
@@ -3088,7 +3088,7 @@ ssize_t vmci_qpair_dequeue(struct vmci_qp *qpair,
 	if (!qpair || !buf)
 		return VMCI_ERROR_INVALID_ARGS;
 
-	iov_iter_kvec(&to, READ, &v, 1, buf_size);
+	iov_iter_kvec(&to, ITER_DEST, &v, 1, buf_size);
 
 	qp_lock(qpair);
 
@@ -3133,7 +3133,7 @@ ssize_t vmci_qpair_peek(struct vmci_qp *qpair,
 	if (!qpair || !buf)
 		return VMCI_ERROR_INVALID_ARGS;
 
-	iov_iter_kvec(&to, READ, &v, 1, buf_size);
+	iov_iter_kvec(&to, ITER_DEST, &v, 1, buf_size);
 
 	qp_lock(qpair);
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
index 3585f02575df..57eeb066a945 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
@@ -48,6 +48,7 @@ mcp251xfd_ring_set_ringparam(struct net_device *ndev,
 	priv->rx_obj_num = layout.cur_rx;
 	priv->rx_obj_num_coalesce_irq = layout.rx_coalesce;
 	priv->tx->obj_num = layout.cur_tx;
+	priv->tx_obj_num_coalesce_irq = layout.tx_coalesce;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index fc68a32ce2f7..d8fb7d4ebd51 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2400,6 +2400,9 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 
 	cleaned = qman_p_poll_dqrr(np->p, budget);
 
+	if (np->xdp_act & XDP_REDIRECT)
+		xdp_do_flush();
+
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
@@ -2407,9 +2410,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
 
-	if (np->xdp_act & XDP_REDIRECT)
-		xdp_do_flush();
-
 	return cleaned;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8d029addddad..6383d9805dac 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1868,10 +1868,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		if (rx_cleaned >= budget ||
 		    txconf_cleaned >= DPAA2_ETH_TXCONF_PER_NAPI) {
 			work_done = budget;
+			if (ch->xdp.res & XDP_REDIRECT)
+				xdp_do_flush();
 			goto out;
 		}
 	} while (store_cleaned);
 
+	if (ch->xdp.res & XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Update NET DIM with the values for this CDAN */
 	dpaa2_io_update_net_dim(ch->dpio, ch->stats.frames_per_cdan,
 				ch->stats.bytes_per_cdan);
@@ -1902,9 +1907,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		txc_fq->dq_bytes = 0;
 	}
 
-	if (ch->xdp.res & XDP_REDIRECT)
-		xdp_do_flush_map();
-	else if (rx_cleaned && ch->xdp.res & XDP_TX)
+	if (rx_cleaned && ch->xdp.res & XDP_TX)
 		dpaa2_eth_xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 001500afc4a6..e04871379baa 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -856,7 +856,7 @@ void ice_set_ethtool_repr_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index add90e75f05c..9aa0437aa598 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -434,7 +434,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		goto out;
 	}
 
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 out:
 	/* enable previously downed VSIs */
@@ -724,12 +724,13 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 /**
  * ice_pf_dcb_recfg - Reconfigure all VEBs and VSIs
  * @pf: pointer to the PF struct
+ * @locked: is adev device lock held
  *
  * Assumed caller has already disabled all VSIs before
  * calling this function. Reconfiguring DCB based on
  * local_dcbx_cfg.
  */
-void ice_pf_dcb_recfg(struct ice_pf *pf)
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
 	struct iidc_event *event;
@@ -776,14 +777,16 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
-	/* Notify the AUX drivers that TC change is finished */
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return;
+	if (!locked) {
+		/* Notify the AUX drivers that TC change is finished */
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (!event)
+			return;
 
-	set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	kfree(event);
+		set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
+		ice_send_event_to_aux(pf, event);
+		kfree(event);
+	}
 }
 
 /**
@@ -1034,7 +1037,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	}
 
 	/* changes in configuration update VSI */
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 	/* enable previously downed VSIs */
 	ice_dcb_ena_dis_vsi(pf, true, true);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 4c421c842a13..800879a88c5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -23,7 +23,7 @@ u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
 int ice_dcb_bwchk(struct ice_pf *pf, struct ice_dcbx_cfg *dcbcfg);
-void ice_pf_dcb_recfg(struct ice_pf *pf);
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -128,7 +128,7 @@ static inline u8 ice_get_pfc_mode(struct ice_pf *pf)
 	return 0;
 }
 
-static inline void ice_pf_dcb_recfg(struct ice_pf *pf) { }
+static inline void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked) { }
 static inline void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi) { }
 static inline void ice_update_dcb_stats(struct ice_pf *pf) { }
 static inline void
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b7be84bbe72d..e1f6373a3a2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3472,7 +3472,9 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int new_rx = 0, new_tx = 0;
+	bool locked = false;
 	u32 curr_combined;
+	int ret = 0;
 
 	/* do not support changing channels in Safe Mode */
 	if (ice_is_safe_mode(pf)) {
@@ -3536,15 +3538,33 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
-	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
+	if (pf->adev) {
+		mutex_lock(&pf->adev_mutex);
+		device_lock(&pf->adev->dev);
+		locked = true;
+		if (pf->adev->dev.driver) {
+			netdev_err(dev, "Cannot change channels when RDMA is active\n");
+			ret = -EBUSY;
+			goto adev_unlock;
+		}
+	}
+
+	ice_vsi_recfg_qs(vsi, new_rx, new_tx, locked);
 
-	if (!netif_is_rxfh_configured(dev))
-		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+	if (!netif_is_rxfh_configured(dev)) {
+		ret = ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+		goto adev_unlock;
+	}
 
 	/* Update rss_size due to change in Rx queues */
 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
 
-	return 0;
+adev_unlock:
+	if (locked) {
+		device_unlock(&pf->adev->dev);
+		mutex_unlock(&pf->adev_mutex);
+	}
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ca2898467dcb..1ac5f0018c7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4192,12 +4192,13 @@ bool ice_is_wol_supported(struct ice_hw *hw)
  * @vsi: VSI being changed
  * @new_rx: new number of Rx queues
  * @new_tx: new number of Tx queues
+ * @locked: is adev device_lock held
  *
  * Only change the number of queues if new_tx, or new_rx is non-0.
  *
  * Returns 0 on success.
  */
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 {
 	struct ice_pf *pf = vsi->back;
 	int err = 0, timeout = 50;
@@ -4226,7 +4227,7 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 
 	ice_vsi_close(vsi);
 	ice_vsi_rebuild(vsi, false);
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
 	clear_bit(ICE_CFG_BUSY, pf->state);
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index c34734d432e0..4e10ced736db 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -417,10 +417,12 @@ static int igc_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
  *
  * We need to convert the system time value stored in the RX/TXSTMP registers
  * into a hwtstamp which can be used by the upper level timestamping functions.
+ *
+ * Returns 0 on success.
  **/
-static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
-				       struct skb_shared_hwtstamps *hwtstamps,
-				       u64 systim)
+static int igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
+				      struct skb_shared_hwtstamps *hwtstamps,
+				      u64 systim)
 {
 	switch (adapter->hw.mac.type) {
 	case igc_i225:
@@ -430,8 +432,9 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
 						systim & 0xFFFFFFFF);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
+	return 0;
 }
 
 /**
@@ -652,7 +655,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 
 	regval = rd32(IGC_TXSTMPL);
 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
-	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
+	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))
+		return;
 
 	switch (adapter->link_speed) {
 	case SPEED_10:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 88dee589cb21..dc7bd2ce78f7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1500,6 +1500,9 @@ static const struct devlink_param rvu_af_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+};
+
+static const struct devlink_param rvu_af_dl_param_exact_match[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
@@ -1563,7 +1566,6 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
-	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1585,21 +1587,32 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
+	err = devlink_params_register(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+	if (err) {
+		dev_err(rvu->dev,
+			"devlink params register failed with error %d", err);
+		goto err_dl_health;
+	}
+
 	/* Register exact match devlink only for CN10K-B */
-	size = ARRAY_SIZE(rvu_af_dl_params);
 	if (!rvu_npc_exact_has_match_table(rvu))
-		size -= 1;
+		goto done;
 
-	err = devlink_params_register(dl, rvu_af_dl_params, size);
+	err = devlink_params_register(dl, rvu_af_dl_param_exact_match,
+				      ARRAY_SIZE(rvu_af_dl_param_exact_match));
 	if (err) {
 		dev_err(rvu->dev,
-			"devlink params register failed with error %d", err);
-		goto err_dl_health;
+			"devlink exact match params register failed with error %d", err);
+		goto err_dl_exact_match;
 	}
 
+done:
 	devlink_register(dl);
 	return 0;
 
+err_dl_exact_match:
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
 err_dl_health:
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
@@ -1612,8 +1625,14 @@ void rvu_unregister_dl(struct rvu *rvu)
 	struct devlink *dl = rvu_dl->dl;
 
 	devlink_unregister(dl);
-	devlink_params_unregister(dl, rvu_af_dl_params,
-				  ARRAY_SIZE(rvu_af_dl_params));
+
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
+	/* Unregister exact match devlink only for CN10K-B */
+	if (rvu_npc_exact_has_match_table(rvu))
+		devlink_params_unregister(dl, rvu_af_dl_param_exact_match,
+					  ARRAY_SIZE(rvu_af_dl_param_exact_match));
+
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
 }
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 7c2af482192d..cb1746bc0e0c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1438,6 +1438,10 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
+
+	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Handle case where we are called by netpoll with a budget of 0 */
 	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
@@ -1457,9 +1461,6 @@ int qede_poll(struct napi_struct *napi, int budget)
 		qede_update_tx_producer(fp->xdp_tx);
 	}
 
-	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
-		xdp_do_flush_map();
-
 	return rx_work_done;
 }
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 0556542d7a6b..3a86f1213a05 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1003,8 +1003,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
 		net_dev->features |= NETIF_F_TSO6;
+		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
+			net_dev->hw_enc_features |= NETIF_F_TSO6;
+	}
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9352dad58996..e02d1e3ef672 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -987,9 +987,6 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 void netvsc_dma_unmap(struct hv_device *hv_dev,
 		      struct hv_netvsc_packet *packet)
 {
-	u32 page_count = packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
 	int i;
 
 	if (!hv_is_isolation_supported())
@@ -998,7 +995,7 @@ void netvsc_dma_unmap(struct hv_device *hv_dev,
 	if (!packet->dma_range)
 		return;
 
-	for (i = 0; i < page_count; i++)
+	for (i = 0; i < packet->page_buf_cnt; i++)
 		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
 				 packet->dma_range[i].mapping_size,
 				 DMA_TO_DEVICE);
@@ -1028,9 +1025,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 			  struct hv_netvsc_packet *packet,
 			  struct hv_page_buffer *pb)
 {
-	u32 page_count =  packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
+	u32 page_count = packet->page_buf_cnt;
 	dma_addr_t dma;
 	int i;
 
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index b60db8b6f477..267e6fd3d444 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -233,7 +233,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_COMPLETE_INT_EN |
 				       DP83822_DUP_MODE_CHANGE_INT_EN |
 				       DP83822_SPEED_CHANGED_INT_EN;
@@ -253,7 +254,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_PAGE_RX_INT_EN |
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad72c6..5e41658b1e2f 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	},
 };
 
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index d4c821c8cf57..1d71f5276241 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -480,7 +480,7 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 	ret = -EFAULT;
 	iov.iov_base = buf;
 	iov.iov_len = count;
-	iov_iter_init(&to, READ, &iov, 1, count);
+	iov_iter_init(&to, ITER_DEST, &iov, 1, count);
 	if (skb_copy_datagram_iter(skb, 0, &to, skb->len))
 		goto outf;
 	ret = skb->len;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3cd15f16090f..20b1b34a092a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1673,13 +1673,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
 
+	if (xdp_xmit & VIRTIO_XDP_REDIR)
+		xdp_do_flush();
+
 	/* Out of packets? */
 	if (received < budget)
 		virtqueue_napi_complete(napi, rq->vq, received);
 
-	if (xdp_xmit & VIRTIO_XDP_REDIR)
-		xdp_do_flush();
-
 	if (xdp_xmit & VIRTIO_XDP_TX) {
 		sq = virtnet_xdp_get_sq(vi);
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
@@ -2154,8 +2154,8 @@ static int virtnet_close(struct net_device *dev)
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		napi_disable(&vi->rq[i].napi);
+		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		virtnet_napi_tx_disable(&vi->sq[i].napi);
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index dfcfb3333369..ea8409e0e70e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -91,6 +91,9 @@
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
+#define BRCMF_MAX_CHANSPEC_LIST \
+	(BRCMF_DCMD_MEDLEN / sizeof(__le32) - 1)
+
 static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 {
 	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
@@ -6556,6 +6559,13 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			band->channels[i].flags = IEEE80211_CHAN_DISABLED;
 
 	total = le32_to_cpu(list->count);
+	if (total > BRCMF_MAX_CHANSPEC_LIST) {
+		bphy_err(drvr, "Invalid count of channel Spec. (%u)\n",
+			 total);
+		err = -EINVAL;
+		goto fail_pbuf;
+	}
+
 	for (i = 0; i < total; i++) {
 		ch.chspec = (u16)le32_to_cpu(list->element[i]);
 		cfg->d11inf.decchspec(&ch);
@@ -6701,6 +6711,13 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 		band = cfg_to_wiphy(cfg)->bands[NL80211_BAND_2GHZ];
 		list = (struct brcmf_chanspec_list *)pbuf;
 		num_chan = le32_to_cpu(list->count);
+		if (num_chan > BRCMF_MAX_CHANSPEC_LIST) {
+			bphy_err(drvr, "Invalid count of channel Spec. (%u)\n",
+				 num_chan);
+			kfree(pbuf);
+			return -EINVAL;
+		}
+
 		for (i = 0; i < num_chan; i++) {
 			ch.chspec = (u16)le32_to_cpu(list->element[i]);
 			cfg->d11inf.decchspec(&ch);
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 871f2a27a398..226fc1703e90 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -121,6 +121,8 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 	iowrite32(T7XX_L1_BIT(0), IREG_BASE(t7xx_dev) + ENABLE_ASPM_LOWPWR);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
 
+	pm_runtime_mark_last_busy(&t7xx_dev->pdev->dev);
+	pm_runtime_allow(&t7xx_dev->pdev->dev);
 	pm_runtime_put_noidle(&t7xx_dev->pdev->dev);
 }
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index eacd445b5333..4c052c261517 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -301,7 +301,7 @@ static inline void nvme_tcp_advance_req(struct nvme_tcp_request *req,
 	if (!iov_iter_count(&req->iter) &&
 	    req->data_sent < req->data_len) {
 		req->curr_bio = req->curr_bio->bi_next;
-		nvme_tcp_init_iter(req, WRITE);
+		nvme_tcp_init_iter(req, ITER_SOURCE);
 	}
 }
 
@@ -781,7 +781,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 				nvme_tcp_init_recv_ctx(queue);
 				return -EIO;
 			}
-			nvme_tcp_init_iter(req, READ);
+			nvme_tcp_init_iter(req, ITER_DEST);
 		}
 
 		/* we can read only from what is left in this bio */
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index e55ec6fefd7f..871c4f32f443 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -92,10 +92,10 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
 		if (req->cmd->rw.control & cpu_to_le16(NVME_RW_FUA))
 			ki_flags |= IOCB_DSYNC;
 		call_iter = req->ns->file->f_op->write_iter;
-		rw = WRITE;
+		rw = ITER_SOURCE;
 	} else {
 		call_iter = req->ns->file->f_op->read_iter;
-		rw = READ;
+		rw = ITER_DEST;
 	}
 
 	iov_iter_bvec(&iter, rw, req->f.bvec, nr_segs, count);
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 6c1476e086ef..cc05c094de22 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -331,7 +331,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 		sg_offset = 0;
 	}
 
-	iov_iter_bvec(&cmd->recv_msg.msg_iter, READ, cmd->iov,
+	iov_iter_bvec(&cmd->recv_msg.msg_iter, ITER_DEST, cmd->iov,
 		      nr_pages, cmd->pdu_len);
 }
 
diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 4441daa20965..7bd65fc2942e 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -97,6 +97,9 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	len = le32_to_cpu(header.len);
 
 	data = kzalloc(len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy_fromio(data, priv->base, len);
 	data[len - 1] = '\0';
 
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 321d7d63e068..34ee9d36ee7b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -770,31 +770,32 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		return ERR_PTR(rval);
 	}
 
-	if (config->wp_gpio)
-		nvmem->wp_gpio = config->wp_gpio;
-	else if (!config->ignore_wp)
+	nvmem->id = rval;
+
+	nvmem->dev.type = &nvmem_provider_type;
+	nvmem->dev.bus = &nvmem_bus_type;
+	nvmem->dev.parent = config->dev;
+
+	device_initialize(&nvmem->dev);
+
+	if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
-		ida_free(&nvmem_ida, nvmem->id);
 		rval = PTR_ERR(nvmem->wp_gpio);
-		kfree(nvmem);
-		return ERR_PTR(rval);
+		nvmem->wp_gpio = NULL;
+		goto err_put_device;
 	}
 
 	kref_init(&nvmem->refcnt);
 	INIT_LIST_HEAD(&nvmem->cells);
 
-	nvmem->id = rval;
 	nvmem->owner = config->owner;
 	if (!nvmem->owner && config->dev->driver)
 		nvmem->owner = config->dev->driver->owner;
 	nvmem->stride = config->stride ?: 1;
 	nvmem->word_size = config->word_size ?: 1;
 	nvmem->size = config->size;
-	nvmem->dev.type = &nvmem_provider_type;
-	nvmem->dev.bus = &nvmem_bus_type;
-	nvmem->dev.parent = config->dev;
 	nvmem->root_only = config->root_only;
 	nvmem->priv = config->priv;
 	nvmem->type = config->type;
@@ -822,11 +823,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		break;
 	}
 
-	if (rval) {
-		ida_free(&nvmem_ida, nvmem->id);
-		kfree(nvmem);
-		return ERR_PTR(rval);
-	}
+	if (rval)
+		goto err_put_device;
 
 	nvmem->read_only = device_property_present(config->dev, "read-only") ||
 			   config->read_only || !nvmem->reg_write;
@@ -835,28 +833,22 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->dev.groups = nvmem_dev_groups;
 #endif
 
-	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-
-	rval = device_register(&nvmem->dev);
-	if (rval)
-		goto err_put_device;
-
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
 		if (rval)
-			goto err_device_del;
+			goto err_put_device;
 	}
 
 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)
-			goto err_device_del;
+			goto err_put_device;
 	}
 
 	if (config->cells) {
 		rval = nvmem_add_cells(nvmem, config->cells, config->ncells);
 		if (rval)
-			goto err_teardown_compat;
+			goto err_remove_cells;
 	}
 
 	rval = nvmem_add_cells_from_table(nvmem);
@@ -867,17 +859,20 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (rval)
 		goto err_remove_cells;
 
+	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
+
+	rval = device_add(&nvmem->dev);
+	if (rval)
+		goto err_remove_cells;
+
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
 
 	return nvmem;
 
 err_remove_cells:
 	nvmem_device_remove_all_cells(nvmem);
-err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
-err_device_del:
-	device_del(&nvmem->dev);
 err_put_device:
 	put_device(&nvmem->dev);
 
@@ -1242,16 +1237,21 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 	if (!cell_np)
 		return ERR_PTR(-ENOENT);
 
-	nvmem_np = of_get_next_parent(cell_np);
-	if (!nvmem_np)
+	nvmem_np = of_get_parent(cell_np);
+	if (!nvmem_np) {
+		of_node_put(cell_np);
 		return ERR_PTR(-EINVAL);
+	}
 
 	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
 	of_node_put(nvmem_np);
-	if (IS_ERR(nvmem))
+	if (IS_ERR(nvmem)) {
+		of_node_put(cell_np);
 		return ERR_CAST(nvmem);
+	}
 
 	cell_entry = nvmem_find_cell_entry_by_node(nvmem, cell_np);
+	of_node_put(cell_np);
 	if (!cell_entry) {
 		__nvmem_device_put(nvmem);
 		return ERR_PTR(-ENOENT);
diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
index 4fcb63507ecd..8499892044b7 100644
--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -166,6 +166,7 @@ static const struct of_device_id sdam_match_table[] = {
 	{ .compatible = "qcom,spmi-sdam" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sdam_match_table);
 
 static struct platform_driver sdam_driver = {
 	.driver = {
diff --git a/drivers/nvmem/sunxi_sid.c b/drivers/nvmem/sunxi_sid.c
index 5750e1f4bcdb..92dfe4cb10e3 100644
--- a/drivers/nvmem/sunxi_sid.c
+++ b/drivers/nvmem/sunxi_sid.c
@@ -41,8 +41,21 @@ static int sunxi_sid_read(void *context, unsigned int offset,
 			  void *val, size_t bytes)
 {
 	struct sunxi_sid *sid = context;
+	u32 word;
+
+	/* .stride = 4 so offset is guaranteed to be aligned */
+	__ioread32_copy(val, sid->base + sid->value_offset + offset, bytes / 4);
 
-	memcpy_fromio(val, sid->base + sid->value_offset + offset, bytes);
+	val += round_down(bytes, 4);
+	offset += round_down(bytes, 4);
+	bytes = bytes % 4;
+
+	if (!bytes)
+		return 0;
+
+	/* Handle any trailing bytes */
+	word = readl_relaxed(sid->base + sid->value_offset + offset);
+	memcpy(val, &word, bytes);
 
 	return 0;
 }
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f08b25195ae7..d1a68b6d03b3 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -26,7 +26,6 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
-#include <linux/kmemleak.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -525,12 +524,9 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
 		if (size &&
-		    early_init_dt_reserve_memory(base, size, nomap) == 0) {
+		    early_init_dt_reserve_memory(base, size, nomap) == 0)
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
-			if (!nomap)
-				kmemleak_alloc_phys(base, size, 0);
-		}
 		else
 			pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 			       uname, &base, (unsigned long)(size / SZ_1M));
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index adcda7762acf..816829105135 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2296,15 +2296,11 @@ static void qmp_combo_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
@@ -2321,16 +2317,12 @@ static int __maybe_unused qmp_combo_runtime_suspend(struct device *dev)
 static int __maybe_unused qmp_combo_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
diff --git a/drivers/platform/x86/amd/Kconfig b/drivers/platform/x86/amd/Kconfig
index a825af8126c8..2ce8cb2170df 100644
--- a/drivers/platform/x86/amd/Kconfig
+++ b/drivers/platform/x86/amd/Kconfig
@@ -8,6 +8,7 @@ source "drivers/platform/x86/amd/pmf/Kconfig"
 config AMD_PMC
 	tristate "AMD SoC PMC driver"
 	depends on ACPI && PCI && RTC_CLASS
+	select SERIO
 	help
 	  The driver provides support for AMD Power Management Controller
 	  primarily responsible for S2Idle transactions that are driven from
diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 8d924986381b..be1b49824edb 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/serio.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -653,6 +654,33 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 	return -EINVAL;
 }
 
+static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
+{
+	struct device *d;
+	int rc;
+
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
+		return 0;
+
+	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
+	if (!d)
+		return 0;
+	if (device_may_wakeup(d)) {
+		dev_info_once(d, "Disabling IRQ1 wakeup source to avoid platform firmware bug\n");
+		disable_irq_wake(1);
+		device_set_wakeup_enable(d, false);
+	}
+	put_device(d);
+
+	return 0;
+}
+
 static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 {
 	struct rtc_device *rtc_device;
@@ -782,6 +810,25 @@ static struct acpi_s2idle_dev_ops amd_pmc_s2idle_dev_ops = {
 	.check = amd_pmc_s2idle_check,
 	.restore = amd_pmc_s2idle_restore,
 };
+
+static int __maybe_unused amd_pmc_suspend_handler(struct device *dev)
+{
+	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
+
+	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
+		int rc = amd_pmc_czn_wa_irq1(pdev);
+
+		if (rc) {
+			dev_err(pdev->dev, "failed to adjust keyboard wakeup: %d\n", rc);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(amd_pmc_pm, amd_pmc_suspend_handler, NULL);
+
 #endif
 
 static const struct pci_device_id pmc_pci_ids[] = {
@@ -980,6 +1027,9 @@ static struct platform_driver amd_pmc_driver = {
 		.name = "amd_pmc",
 		.acpi_match_table = amd_pmc_acpi_ids,
 		.dev_groups = pmc_groups,
+#ifdef CONFIG_SUSPEND
+		.pm = &amd_pmc_pm,
+#endif
 	},
 	.probe = amd_pmc_probe,
 	.remove = amd_pmc_remove,
diff --git a/drivers/platform/x86/amd/pmf/auto-mode.c b/drivers/platform/x86/amd/pmf/auto-mode.c
index 644af42e07cf..96a8e1832c05 100644
--- a/drivers/platform/x86/amd/pmf/auto-mode.c
+++ b/drivers/platform/x86/amd/pmf/auto-mode.c
@@ -275,13 +275,8 @@ int amd_pmf_reset_amt(struct amd_pmf_dev *dev)
 	 */
 
 	if (is_apmf_func_supported(dev, APMF_FUNC_STATIC_SLIDER_GRANULAR)) {
-		int mode = amd_pmf_get_pprof_modes(dev);
-
-		if (mode < 0)
-			return mode;
-
 		dev_dbg(dev->dev, "resetting AMT thermals\n");
-		amd_pmf_update_slider(dev, SLIDER_OP_SET, mode, NULL);
+		amd_pmf_set_sps_power_limits(dev);
 	}
 	return 0;
 }
@@ -299,7 +294,5 @@ void amd_pmf_deinit_auto_mode(struct amd_pmf_dev *dev)
 void amd_pmf_init_auto_mode(struct amd_pmf_dev *dev)
 {
 	amd_pmf_load_defaults_auto_mode(dev);
-	/* update the thermal limits for Automode */
-	amd_pmf_set_automode(dev, config_store.current_mode, NULL);
 	amd_pmf_init_metrics_table(dev);
 }
diff --git a/drivers/platform/x86/amd/pmf/cnqf.c b/drivers/platform/x86/amd/pmf/cnqf.c
index 668c7c0fea83..f39275ec5cc9 100644
--- a/drivers/platform/x86/amd/pmf/cnqf.c
+++ b/drivers/platform/x86/amd/pmf/cnqf.c
@@ -103,7 +103,7 @@ int amd_pmf_trans_cnqf(struct amd_pmf_dev *dev, int socket_power, ktime_t time_l
 
 	src = amd_pmf_cnqf_get_power_source(dev);
 
-	if (dev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (is_pprof_balanced(dev)) {
 		amd_pmf_set_cnqf(dev, src, config_store.current_mode, NULL);
 	} else {
 		/*
@@ -307,13 +307,9 @@ static ssize_t cnqf_enable_store(struct device *dev,
 				 const char *buf, size_t count)
 {
 	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
-	int mode, result, src;
+	int result, src;
 	bool input;
 
-	mode = amd_pmf_get_pprof_modes(pdev);
-	if (mode < 0)
-		return mode;
-
 	result = kstrtobool(buf, &input);
 	if (result)
 		return result;
@@ -321,11 +317,11 @@ static ssize_t cnqf_enable_store(struct device *dev,
 	src = amd_pmf_cnqf_get_power_source(pdev);
 	pdev->cnqf_enabled = input;
 
-	if (pdev->cnqf_enabled && pdev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (pdev->cnqf_enabled && is_pprof_balanced(pdev)) {
 		amd_pmf_set_cnqf(pdev, src, config_store.current_mode, NULL);
 	} else {
 		if (is_apmf_func_supported(pdev, APMF_FUNC_STATIC_SLIDER_GRANULAR))
-			amd_pmf_update_slider(pdev, SLIDER_OP_SET, mode, NULL);
+			amd_pmf_set_sps_power_limits(pdev);
 	}
 
 	dev_dbg(pdev->dev, "Received CnQF %s\n", input ? "on" : "off");
@@ -386,7 +382,7 @@ int amd_pmf_init_cnqf(struct amd_pmf_dev *dev)
 	dev->cnqf_enabled = amd_pmf_check_flags(dev);
 
 	/* update the thermal for CnQF */
-	if (dev->cnqf_enabled && dev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (dev->cnqf_enabled && is_pprof_balanced(dev)) {
 		src = amd_pmf_cnqf_get_power_source(dev);
 		amd_pmf_set_cnqf(dev, src, config_store.current_mode, NULL);
 	}
diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index a5f5a4bcff6d..da23639071d7 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -58,6 +58,25 @@ static bool force_load;
 module_param(force_load, bool, 0444);
 MODULE_PARM_DESC(force_load, "Force load this driver on supported older platforms (experimental)");
 
+static int amd_pmf_pwr_src_notify_call(struct notifier_block *nb, unsigned long event, void *data)
+{
+	struct amd_pmf_dev *pmf = container_of(nb, struct amd_pmf_dev, pwr_src_notifier);
+
+	if (event != PSY_EVENT_PROP_CHANGED)
+		return NOTIFY_OK;
+
+	if (is_apmf_func_supported(pmf, APMF_FUNC_AUTO_MODE) ||
+	    is_apmf_func_supported(pmf, APMF_FUNC_DYN_SLIDER_DC) ||
+	    is_apmf_func_supported(pmf, APMF_FUNC_DYN_SLIDER_AC)) {
+		if ((pmf->amt_enabled || pmf->cnqf_enabled) && is_pprof_balanced(pmf))
+			return NOTIFY_DONE;
+	}
+
+	amd_pmf_set_sps_power_limits(pmf);
+
+	return NOTIFY_OK;
+}
+
 static int current_power_limits_show(struct seq_file *seq, void *unused)
 {
 	struct amd_pmf_dev *dev = seq->private;
@@ -366,14 +385,18 @@ static int amd_pmf_probe(struct platform_device *pdev)
 	if (!dev->regbase)
 		return -ENOMEM;
 
+	mutex_init(&dev->lock);
+	mutex_init(&dev->update_mutex);
+
 	apmf_acpi_init(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmf_init_features(dev);
 	apmf_install_handler(dev);
 	amd_pmf_dbgfs_register(dev);
 
-	mutex_init(&dev->lock);
-	mutex_init(&dev->update_mutex);
+	dev->pwr_src_notifier.notifier_call = amd_pmf_pwr_src_notify_call;
+	power_supply_reg_notifier(&dev->pwr_src_notifier);
+
 	dev_info(dev->dev, "registered PMF device successfully\n");
 
 	return 0;
@@ -383,11 +406,12 @@ static int amd_pmf_remove(struct platform_device *pdev)
 {
 	struct amd_pmf_dev *dev = platform_get_drvdata(pdev);
 
-	mutex_destroy(&dev->lock);
-	mutex_destroy(&dev->update_mutex);
+	power_supply_unreg_notifier(&dev->pwr_src_notifier);
 	amd_pmf_deinit_features(dev);
 	apmf_acpi_deinit(dev);
 	amd_pmf_dbgfs_unregister(dev);
+	mutex_destroy(&dev->lock);
+	mutex_destroy(&dev->update_mutex);
 	kfree(dev->buf);
 	return 0;
 }
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index 84bbe2c6ea61..06c30cdc0573 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -169,6 +169,7 @@ struct amd_pmf_dev {
 	struct mutex update_mutex; /* protects race between ACPI handler and metrics thread */
 	bool cnqf_enabled;
 	bool cnqf_supported;
+	struct notifier_block pwr_src_notifier;
 };
 
 struct apmf_sps_prop_granular {
@@ -391,9 +392,11 @@ int amd_pmf_init_sps(struct amd_pmf_dev *dev);
 void amd_pmf_deinit_sps(struct amd_pmf_dev *dev);
 int apmf_get_static_slider_granular(struct amd_pmf_dev *pdev,
 				    struct apmf_static_slider_granular_output *output);
+bool is_pprof_balanced(struct amd_pmf_dev *pmf);
 
 
 int apmf_update_fan_idx(struct amd_pmf_dev *pdev, bool manual, u32 idx);
+int amd_pmf_set_sps_power_limits(struct amd_pmf_dev *pmf);
 
 /* Auto Mode Layer */
 int apmf_get_auto_mode_def(struct amd_pmf_dev *pdev, struct apmf_auto_mode *data);
diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index dba7e36962dc..bed762d47a14 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -70,6 +70,24 @@ void amd_pmf_update_slider(struct amd_pmf_dev *dev, bool op, int idx,
 	}
 }
 
+int amd_pmf_set_sps_power_limits(struct amd_pmf_dev *pmf)
+{
+	int mode;
+
+	mode = amd_pmf_get_pprof_modes(pmf);
+	if (mode < 0)
+		return mode;
+
+	amd_pmf_update_slider(pmf, SLIDER_OP_SET, mode, NULL);
+
+	return 0;
+}
+
+bool is_pprof_balanced(struct amd_pmf_dev *pmf)
+{
+	return (pmf->current_profile == PLATFORM_PROFILE_BALANCED) ? true : false;
+}
+
 static int amd_pmf_profile_get(struct platform_profile_handler *pprof,
 			       enum platform_profile_option *profile)
 {
@@ -105,15 +123,10 @@ static int amd_pmf_profile_set(struct platform_profile_handler *pprof,
 			       enum platform_profile_option profile)
 {
 	struct amd_pmf_dev *pmf = container_of(pprof, struct amd_pmf_dev, pprof);
-	int mode;
 
 	pmf->current_profile = profile;
-	mode = amd_pmf_get_pprof_modes(pmf);
-	if (mode < 0)
-		return mode;
 
-	amd_pmf_update_slider(pmf, SLIDER_OP_SET, mode, NULL);
-	return 0;
+	return amd_pmf_set_sps_power_limits(pmf);
 }
 
 int amd_pmf_init_sps(struct amd_pmf_dev *dev)
@@ -123,6 +136,9 @@ int amd_pmf_init_sps(struct amd_pmf_dev *dev)
 	dev->current_profile = PLATFORM_PROFILE_BALANCED;
 	amd_pmf_load_defaults_sps(dev);
 
+	/* update SPS balanced power mode thermals */
+	amd_pmf_set_sps_power_limits(dev);
+
 	dev->pprof.profile_get = amd_pmf_profile_get;
 	dev->pprof.profile_set = amd_pmf_profile_set;
 
diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 0a259a27459f..502783a7adb1 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -261,6 +261,9 @@ static const struct key_entry dell_wmi_keymap_type_0010[] = {
 	{ KE_KEY,    0x57, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY,    0x58, { KEY_BRIGHTNESSUP } },
 
+	/*Speaker Mute*/
+	{ KE_KEY, 0x109, { KEY_MUTE} },
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 5e7e6659a849..322cfaeda17b 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 0a99058be813..4a3851332ef2 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -90,6 +90,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_OMEN_KEY			= 0x1D,
 	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
@@ -216,6 +217,8 @@ static const struct key_entry hp_wmi_keymap[] = {
 	{ KE_KEY, 0x213b,  { KEY_INFO } },
 	{ KE_KEY, 0x2169,  { KEY_ROTATE_DISPLAY } },
 	{ KE_KEY, 0x216a,  { KEY_SETUP } },
+	{ KE_KEY, 0x21a5,  { KEY_PROG2 } }, /* HP Omen Key */
+	{ KE_KEY, 0x21a7,  { KEY_FN_ESC } },
 	{ KE_KEY, 0x21a9,  { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY, 0x121a9, { KEY_TOUCHPAD_ON } },
 	{ KE_KEY, 0x231b,  { KEY_HELP } },
@@ -810,6 +813,7 @@ static void hp_wmi_notify(u32 value, void *context)
 	case HPWMI_SMART_ADAPTER:
 		break;
 	case HPWMI_BEZEL_BUTTON:
+	case HPWMI_OMEN_KEY:
 		key_code = hp_wmi_read_int(HPWMI_HOTKEY_QUERY);
 		if (key_code < 0)
 			break;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7fd735c67a8e..2a48a2d880d8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5566,7 +5566,7 @@ static int light_sysfs_set(struct led_classdev *led_cdev,
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
-	return (light_get_status() == 1) ? LED_FULL : LED_OFF;
+	return (light_get_status() == 1) ? LED_ON : LED_OFF;
 }
 
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 11850c2880ad..491b830d0818 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -188,9 +188,10 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 
 static int efi_procfs(struct device *dev, struct seq_file *seq)
 {
-	efi_time_t      eft, alm;
-	efi_time_cap_t  cap;
-	efi_bool_t      enabled, pending;
+	efi_time_t        eft, alm;
+	efi_time_cap_t    cap;
+	efi_bool_t        enabled, pending;
+	struct rtc_device *rtc = dev_get_drvdata(dev);
 
 	memset(&eft, 0, sizeof(eft));
 	memset(&alm, 0, sizeof(alm));
@@ -213,23 +214,25 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
 		/* XXX fixme: convert to string? */
 		seq_printf(seq, "Timezone\t: %u\n", eft.timezone);
 
-	seq_printf(seq,
-		   "Alarm Time\t: %u:%u:%u.%09u\n"
-		   "Alarm Date\t: %u-%u-%u\n"
-		   "Alarm Daylight\t: %u\n"
-		   "Enabled\t\t: %s\n"
-		   "Pending\t\t: %s\n",
-		   alm.hour, alm.minute, alm.second, alm.nanosecond,
-		   alm.year, alm.month, alm.day,
-		   alm.daylight,
-		   enabled == 1 ? "yes" : "no",
-		   pending == 1 ? "yes" : "no");
-
-	if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
-		seq_puts(seq, "Timezone\t: unspecified\n");
-	else
-		/* XXX fixme: convert to string? */
-		seq_printf(seq, "Timezone\t: %u\n", alm.timezone);
+	if (test_bit(RTC_FEATURE_ALARM, rtc->features)) {
+		seq_printf(seq,
+			   "Alarm Time\t: %u:%u:%u.%09u\n"
+			   "Alarm Date\t: %u-%u-%u\n"
+			   "Alarm Daylight\t: %u\n"
+			   "Enabled\t\t: %s\n"
+			   "Pending\t\t: %s\n",
+			   alm.hour, alm.minute, alm.second, alm.nanosecond,
+			   alm.year, alm.month, alm.day,
+			   alm.daylight,
+			   enabled == 1 ? "yes" : "no",
+			   pending == 1 ? "yes" : "no");
+
+		if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
+			seq_puts(seq, "Timezone\t: unspecified\n");
+		else
+			/* XXX fixme: convert to string? */
+			seq_printf(seq, "Timezone\t: %u\n", alm.timezone);
+	}
 
 	/*
 	 * now prints the capabilities
@@ -269,7 +272,10 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 
 	rtc->ops = &efi_rtc_ops;
 	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->features);
-	set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_WAKEUP_SERVICES))
+		set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
+	else
+		clear_bit(RTC_FEATURE_ALARM, rtc->features);
 
 	return devm_rtc_register_device(rtc);
 }
diff --git a/drivers/rtc/rtc-sunplus.c b/drivers/rtc/rtc-sunplus.c
index e8e2ab1103fc..4b578e4d44f6 100644
--- a/drivers/rtc/rtc-sunplus.c
+++ b/drivers/rtc/rtc-sunplus.c
@@ -240,8 +240,8 @@ static int sp_rtc_probe(struct platform_device *plat_dev)
 	if (IS_ERR(sp_rtc->reg_base))
 		return dev_err_probe(&plat_dev->dev, PTR_ERR(sp_rtc->reg_base),
 					    "%s devm_ioremap_resource fail\n", RTC_REG_NAME);
-	dev_dbg(&plat_dev->dev, "res = 0x%x, reg_base = 0x%lx\n",
-		sp_rtc->res->start, (unsigned long)sp_rtc->reg_base);
+	dev_dbg(&plat_dev->dev, "res = %pR, reg_base = %p\n",
+		sp_rtc->res, sp_rtc->reg_base);
 
 	sp_rtc->irq = platform_get_irq(plat_dev, 0);
 	if (sp_rtc->irq < 0)
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 6165e6aae762..a41833557d55 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -103,7 +103,7 @@ static inline int memcpy_hsa_kernel(void *dst, unsigned long src, size_t count)
 
 	kvec.iov_base = dst;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 	if (memcpy_hsa_iter(&iter, src, count) < count)
 		return -EIO;
 	return 0;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5fb1f364e815..c3ad04ad66e0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -848,7 +848,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -858,6 +858,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -958,11 +959,13 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
-	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->session = session;
 
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
+
+	/* We are now fully setup so expose the session to sysfs. */
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 	return cls_session;
 
 remove_session:
@@ -982,10 +985,17 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
+	iscsi_session_remove(cls_session);
+	/*
+	 * Our get_host_param needs to access the session, so remove the
+	 * host from sysfs before freeing the session to make sure userspace
+	 * is no longer accessing the callout.
+	 */
+	iscsi_host_remove(shost, false);
+
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost, false);
+	iscsi_session_free(cls_session);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d95f4bcdeb2e..6e811d753cb1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3104,17 +3104,32 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
-/**
- * iscsi_session_teardown - destroy session, host, and cls_session
- * @cls_session: iscsi session
+/*
+ * issi_session_remove - Remove session from iSCSI class.
  */
-void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+void iscsi_session_remove(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
-	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
 	iscsi_remove_session(cls_session);
+	/*
+	 * host removal only has to wait for its children to be removed from
+	 * sysfs, and iscsi_tcp needs to do iscsi_host_remove before freeing
+	 * the session, so drop the session count here.
+	 */
+	iscsi_host_dec_session_cnt(shost);
+}
+EXPORT_SYMBOL_GPL(iscsi_session_remove);
+
+/**
+ * iscsi_session_free - Free iscsi session and it's resources
+ * @cls_session: iscsi session
+ */
+void iscsi_session_free(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct module *owner = cls_session->transport->owner;
 
 	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
@@ -3132,10 +3147,19 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->discovery_parent_type);
 
 	iscsi_free_session(cls_session);
-
-	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
+EXPORT_SYMBOL_GPL(iscsi_session_free);
+
+/**
+ * iscsi_session_teardown - destroy session and cls_session
+ * @cls_session: iscsi session
+ */
+void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_remove(cls_session);
+	iscsi_session_free(cls_session);
+}
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
 /**
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..d149b218715e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1233,8 +1233,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * that no LUN is present, so don't add sdev in these cases.
 	 * Two specific examples are:
 	 * 1) NetApp targets: return PQ=1, PDT=0x1f
-	 * 2) IBM/2145 targets: return PQ=1, PDT=0
-	 * 3) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
+	 * 2) USB UFI: returns PDT=0x1f, with the PQ bits being "reserved"
 	 *    in the UFI 1.0 spec (we cannot rely on reserved bits).
 	 *
 	 * References:
@@ -1248,8 +1247,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=00h Direct-access device (floppy)
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
-	if (((result[0] >> 5) == 1 ||
-	    (starget->pdt_1f_for_no_lun && (result[0] & 0x1f) == 0x1f)) &&
+	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
+	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 					"scsi scan: peripheral device type"
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ce34a8ad53b4..12344be14232 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1726,7 +1726,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	struct rq_map_data *md, map_data;
-	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? ITER_SOURCE : ITER_DEST;
 	struct scsi_cmnd *scmd;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 8d9f21372b67..26dc8ed3045b 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1225,7 +1225,7 @@ int rx_data(
 		return -1;
 
 	memset(&msg, 0, sizeof(struct msghdr));
-	iov_iter_kvec(&msg.msg_iter, READ, iov, iov_count, data);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, iov, iov_count, data);
 
 	while (msg_data_left(&msg)) {
 		rx_loop = sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
@@ -1261,7 +1261,7 @@ int tx_data(
 
 	memset(&msg, 0, sizeof(struct msghdr));
 
-	iov_iter_kvec(&msg.msg_iter, WRITE, iov, iov_count, data);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, iov, iov_count, data);
 
 	while (msg_data_left(&msg)) {
 		int tx_loop = sock_sendmsg(conn->sock, &msg);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 28aa643be5d5..7e81a53dbf3c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -337,7 +337,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		len += sg->length;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, sgl_nents, len);
+	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
 	if (is_write)
 		ret = vfs_iter_write(fd, &iter, &pos, 0);
 	else
@@ -473,7 +473,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		len += se_dev->dev_attrib.block_size;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, nolb, len);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, nolb, len);
 	ret = vfs_iter_write(fd_dev->fd_file, &iter, &pos, 0);
 
 	kfree(bvec);
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..2b95b4550a63 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -73,8 +73,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index b85c82616e8c..a442f0dfd28e 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -44,19 +44,39 @@ static void __dma_rx_complete(void *param)
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
+	enum dma_status		dma_status;
 	int			count;
 
-	dma->rx_running = 0;
-	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	/*
+	 * New DMA Rx can be started during the completion handler before it
+	 * could acquire port's lock and it might still be ongoing. Don't to
+	 * anything in such case.
+	 */
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	if (dma_status == DMA_IN_PROGRESS)
+		return;
 
 	count = dma->rx_size - state.residue;
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	dma->rx_running = 0;
 
 	tty_flip_buffer_push(tty_port);
 }
 
+static void dma_rx_complete(void *param)
+{
+	struct uart_8250_port *p = param;
+	struct uart_8250_dma *dma = p->dma;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->port.lock, flags);
+	if (dma->rx_running)
+		__dma_rx_complete(p);
+	spin_unlock_irqrestore(&p->port.lock, flags);
+}
+
 int serial8250_tx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
@@ -130,7 +150,7 @@ int serial8250_rx_dma(struct uart_8250_port *p)
 		return -EBUSY;
 
 	dma->rx_running = 1;
-	desc->callback = __dma_rx_complete;
+	desc->callback = dma_rx_complete;
 	desc->callback_param = p;
 
 	dma->rx_cookie = dmaengine_submit(desc);
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index b8aed28b8f17..0e6ef24419c8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -798,25 +798,11 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 		spin_unlock(&port->lock);
 	}
 
-	if (stm32_usart_rx_dma_enabled(port))
-		return IRQ_WAKE_THREAD;
-	else
-		return IRQ_HANDLED;
-}
-
-static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
-{
-	struct uart_port *port = ptr;
-	struct tty_port *tport = &port->state->port;
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	unsigned int size;
-	unsigned long flags;
-
 	/* Receiver timeout irq for DMA RX */
-	if (!stm32_port->throttled) {
-		spin_lock_irqsave(&port->lock, flags);
+	if (stm32_usart_rx_dma_enabled(port) && !stm32_port->throttled) {
+		spin_lock(&port->lock);
 		size = stm32_usart_receive_chars(port, false);
-		uart_unlock_and_check_sysrq_irqrestore(port, flags);
+		uart_unlock_and_check_sysrq(port);
 		if (size)
 			tty_flip_buffer_push(tport);
 	}
@@ -1016,10 +1002,8 @@ static int stm32_usart_startup(struct uart_port *port)
 	u32 val;
 	int ret;
 
-	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
-				   stm32_usart_threaded_interrupt,
-				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
-				   name, port);
+	ret = request_irq(port->irq, stm32_usart_interrupt,
+			  IRQF_NO_SUSPEND, name, port);
 	if (ret)
 		return ret;
 
@@ -1602,13 +1586,6 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 	struct dma_slave_config config;
 	int ret;
 
-	/*
-	 * Using DMA and threaded handler for the console could lead to
-	 * deadlocks.
-	 */
-	if (uart_console(port))
-		return -ENODEV;
-
 	stm32port->rx_buf = dma_alloc_coherent(dev, RX_BUF_L,
 					       &stm32port->rx_dma_buf,
 					       GFP_KERNEL);
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 1850bacdb5b0..f566eb1839dc 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -386,10 +386,6 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	uni_mode = use_unicode(inode);
 	attr = use_attributes(inode);
-	ret = -ENXIO;
-	vc = vcs_vc(inode, &viewed);
-	if (!vc)
-		goto unlock_out;
 
 	ret = -EINVAL;
 	if (pos < 0)
@@ -407,6 +403,11 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		unsigned int this_round, skip = 0;
 		int size;
 
+		ret = -ENXIO;
+		vc = vcs_vc(inode, &viewed);
+		if (!vc)
+			goto unlock_out;
+
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop
 		 * could sleep.
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index b0a0351d2d8b..959fc925ca7c 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -901,7 +901,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 	qcom->mode = usb_get_dr_mode(&qcom->dwc3->dev);
 
 	/* enable vbus override for device mode */
-	if (qcom->mode == USB_DR_MODE_PERIPHERAL)
+	if (qcom->mode != USB_DR_MODE_HOST)
 		dwc3_qcom_vbus_override_enable(qcom, true);
 
 	/* register extcon to override sw_vbus on Vbus change later */
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 523a961b910b..8ad354741380 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -279,8 +279,10 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
-	if (!req)
+	if (!req) {
+		spin_unlock_irq(&ffs->ev.waitq.lock);
 		return -EINVAL;
+	}
 
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 08726e4c68a5..0219cd79493a 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1142,6 +1142,7 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 		}
 		std_as_out_if0_desc.bInterfaceNumber = ret;
 		std_as_out_if1_desc.bInterfaceNumber = ret;
+		std_as_out_if1_desc.bNumEndpoints = 1;
 		uac2->as_out_intf = ret;
 		uac2->as_out_alt = 0;
 
diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/udc/bcm63xx_udc.c
index 2cdb07905bde..d04d72f5816e 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -1830,7 +1830,6 @@ static int bcm63xx_udc_start(struct usb_gadget *gadget,
 	bcm63xx_select_phy_mode(udc, true);
 
 	udc->driver = driver;
-	driver->driver.bus = NULL;
 	udc->gadget.dev.of_node = udc->dev->of_node;
 
 	spin_unlock_irqrestore(&udc->lock, flags);
diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index d0e051beb3af..693c73e5f61e 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -1009,7 +1009,6 @@ static int fotg210_udc_start(struct usb_gadget *g,
 	u32 value;
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	fotg210->driver = driver;
 
 	/* enable device global interrupt */
diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
index bf745358e28e..3b1cc8fa30c8 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -2285,7 +2285,6 @@ static int fsl_qe_start(struct usb_gadget *gadget,
 	/* lock is needed but whether should use this lock or another */
 	spin_lock_irqsave(&udc->lock, flags);
 
-	driver->driver.bus = NULL;
 	/* hook up the driver */
 	udc->driver = driver;
 	udc->gadget.speed = driver->max_speed;
diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 50435e804118..a67873a074b7 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -1943,7 +1943,6 @@ static int fsl_udc_start(struct usb_gadget *g,
 	/* lock is needed but whether should use this lock or another */
 	spin_lock_irqsave(&udc_controller->lock, flags);
 
-	driver->driver.bus = NULL;
 	/* hook up the driver */
 	udc_controller->driver = driver;
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index 9af8b415f303..5954800d652c 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1311,7 +1311,6 @@ static int fusb300_udc_start(struct usb_gadget *g,
 	struct fusb300 *fusb300 = to_fusb300(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	fusb300->driver = driver;
 
 	return 0;
diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index bdc56b24b5c9..5ffb3d5c635b 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1375,7 +1375,6 @@ static int goku_udc_start(struct usb_gadget *g,
 	struct goku_udc	*dev = to_goku_udc(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/*
diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 22096f8505de..85cdc0af3bf9 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -1906,7 +1906,6 @@ static int gr_udc_start(struct usb_gadget *gadget,
 	spin_lock(&dev->lock);
 
 	/* Hook up the driver */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* Get ready for host detection */
diff --git a/drivers/usb/gadget/udc/m66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c
index 931e6362a13d..d88871e71662 100644
--- a/drivers/usb/gadget/udc/m66592-udc.c
+++ b/drivers/usb/gadget/udc/m66592-udc.c
@@ -1454,7 +1454,6 @@ static int m66592_udc_start(struct usb_gadget *g,
 	struct m66592 *m66592 = to_m66592(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	m66592->driver = driver;
 
 	m66592_bset(m66592, M66592_VBSE | M66592_URST, M66592_INTENB0);
diff --git a/drivers/usb/gadget/udc/max3420_udc.c b/drivers/usb/gadget/udc/max3420_udc.c
index 3074da00c3df..ddf0ed3eb4f2 100644
--- a/drivers/usb/gadget/udc/max3420_udc.c
+++ b/drivers/usb/gadget/udc/max3420_udc.c
@@ -1108,7 +1108,6 @@ static int max3420_udc_start(struct usb_gadget *gadget,
 
 	spin_lock_irqsave(&udc->lock, flags);
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 	udc->gadget.speed = USB_SPEED_FULL;
 
diff --git a/drivers/usb/gadget/udc/mv_u3d_core.c b/drivers/usb/gadget/udc/mv_u3d_core.c
index 598654a3cb41..411b6179782c 100644
--- a/drivers/usb/gadget/udc/mv_u3d_core.c
+++ b/drivers/usb/gadget/udc/mv_u3d_core.c
@@ -1243,7 +1243,6 @@ static int mv_u3d_start(struct usb_gadget *g,
 	}
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	u3d->driver = driver;
 
 	u3d->ep0_dir = USB_DIR_OUT;
diff --git a/drivers/usb/gadget/udc/mv_udc_core.c b/drivers/usb/gadget/udc/mv_udc_core.c
index fdb17d86cd65..b397f3a848cf 100644
--- a/drivers/usb/gadget/udc/mv_udc_core.c
+++ b/drivers/usb/gadget/udc/mv_udc_core.c
@@ -1359,7 +1359,6 @@ static int mv_udc_start(struct usb_gadget *gadget,
 	spin_lock_irqsave(&udc->lock, flags);
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 
 	udc->usb_state = USB_STATE_ATTACHED;
diff --git a/drivers/usb/gadget/udc/net2272.c b/drivers/usb/gadget/udc/net2272.c
index 84605a4d0715..538c1b9a2883 100644
--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -1451,7 +1451,6 @@ static int net2272_start(struct usb_gadget *_gadget,
 		dev->ep[i].irqs = 0;
 	/* hook up the driver ... */
 	dev->softconnect = 1;
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* ... then enable host detection and ep0; and we're ready
diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index d6a68631354a..1b929c519cd7 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2423,7 +2423,6 @@ static int net2280_start(struct usb_gadget *_gadget,
 		dev->ep[i].irqs = 0;
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	retval = device_create_file(&dev->pdev->dev, &dev_attr_function);
diff --git a/drivers/usb/gadget/udc/omap_udc.c b/drivers/usb/gadget/udc/omap_udc.c
index bea346e362b2..f660ebfa1379 100644
--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -2066,7 +2066,6 @@ static int omap_udc_start(struct usb_gadget *g,
 	udc->softconnect = 1;
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index 9bb7a9d7a2fb..4f8617210d85 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -2908,7 +2908,6 @@ static int pch_udc_start(struct usb_gadget *g,
 {
 	struct pch_udc_dev	*dev = to_pch_udc(g);
 
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* get ready for ep0 traffic */
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index 52ea4dcf6a92..2fc5d4d277bc 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -1933,7 +1933,6 @@ static int amd5536_udc_start(struct usb_gadget *g,
 	struct udc *dev = to_amd5536_udc(g);
 	u32 tmp;
 
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* Some gadget drivers use both ep0 directions.
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1292241d581a..1cf8947c6d66 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1269,6 +1269,9 @@ static int ucsi_init(struct ucsi *ucsi)
 		con->port = NULL;
 	}
 
+	kfree(ucsi->connector);
+	ucsi->connector = NULL;
+
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
@@ -1300,7 +1303,8 @@ static void ucsi_resume_work(struct work_struct *work)
 
 int ucsi_resume(struct ucsi *ucsi)
 {
-	queue_work(system_long_wq, &ucsi->resume_work);
+	if (ucsi->connector)
+		queue_work(system_long_wq, &ucsi->resume_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ucsi_resume);
@@ -1420,6 +1424,9 @@ void ucsi_unregister(struct ucsi *ucsi)
 	/* Disable notifications */
 	ucsi->ops->async_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
 
+	if (!ucsi->connector)
+		return;
+
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
 		ucsi_unregister_partner(&ucsi->connector[i]);
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 053a2bca4c47..f8b326eed54d 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -309,7 +309,7 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 	if (!sock || !buf || !size)
 		return -EINVAL;
 
-	iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, size);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, size);
 
 	usbip_dbg_xmit("enter\n");
 
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 20265393aee7..4c538b30fd76 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -611,7 +611,7 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 	/* Skip header. TODO: support TSO. */
 	size_t len = iov_length(vq->iov, out);
 
-	iov_iter_init(iter, WRITE, vq->iov, out, len);
+	iov_iter_init(iter, ITER_SOURCE, vq->iov, out, len);
 	iov_iter_advance(iter, hdr_size);
 
 	return iov_iter_count(iter);
@@ -1184,14 +1184,14 @@ static void handle_rx(struct vhost_net *net)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
-			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
+			iov_iter_init(&msg.msg_iter, ITER_DEST, vq->iov, 1, 1);
 			err = sock->ops->recvmsg(sock, &msg,
 						 1, MSG_DONTWAIT | MSG_TRUNC);
 			pr_debug("Discarded rx packet: len %zd\n", sock_len);
 			continue;
 		}
 		/* We don't need to be notified again. */
-		iov_iter_init(&msg.msg_iter, READ, vq->iov, in, vhost_len);
+		iov_iter_init(&msg.msg_iter, ITER_DEST, vq->iov, in, vhost_len);
 		fixup = msg.msg_iter;
 		if (unlikely((vhost_hlen))) {
 			/* We will supply the header ourselves
@@ -1511,6 +1511,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	nvq = &n->vqs[index];
 	mutex_lock(&vq->mutex);
 
+	if (fd == -1)
+		vhost_clear_msg(&n->dev);
+
 	/* Verify that ring has been setup correctly. */
 	if (!vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7ebf106d50c1..d5ecb8876fc9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -80,7 +80,7 @@ struct vhost_scsi_cmd {
 	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
 	/* Pointer to response header iovec */
-	struct iovec tvc_resp_iov;
+	struct iovec *tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
@@ -563,7 +563,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
 
-		iov_iter_init(&iov_iter, READ, &cmd->tvc_resp_iov,
+		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
@@ -594,6 +594,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
+	struct iovec *tvc_resp_iov;
 	struct page **pages;
 	int tag;
 
@@ -613,6 +614,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
+	tvc_resp_iov = cmd->tvc_resp_iov;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
@@ -625,6 +627,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_data_direction = data_direction;
 	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
+	cmd->tvc_resp_iov = tvc_resp_iov;
 
 	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
 
@@ -864,7 +867,7 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	 * point at the start of the outgoing WRITE payload, if
 	 * DMA_TO_DEVICE is set.
 	 */
-	iov_iter_init(&vc->out_iter, WRITE, vq->iov, vc->out, vc->out_size);
+	iov_iter_init(&vc->out_iter, ITER_SOURCE, vq->iov, vc->out, vc->out_size);
 	ret = 0;
 
 done:
@@ -935,7 +938,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	int ret, prot_bytes, c = 0;
+	int ret, prot_bytes, i, c = 0;
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
@@ -1016,7 +1019,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			data_direction = DMA_FROM_DEVICE;
 			exp_data_len = vc.in_size - vc.rsp_size;
 
-			iov_iter_init(&in_iter, READ, &vq->iov[vc.out], vc.in,
+			iov_iter_init(&in_iter, ITER_DEST, &vq->iov[vc.out], vc.in,
 				      vc.rsp_size + exp_data_len);
 			iov_iter_advance(&in_iter, vc.rsp_size);
 			data_iter = in_iter;
@@ -1092,7 +1095,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		}
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp_iov = vq->iov[vc.out];
+		for (i = 0; i < vc.in ; i++)
+			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
 		cmd->tvc_in_iovs = vc.in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
@@ -1146,7 +1150,7 @@ vhost_scsi_send_tmf_resp(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = tmf_resp_code;
 
-	iov_iter_init(&iov_iter, READ, resp_iov, in_iovs, sizeof(rsp));
+	iov_iter_init(&iov_iter, ITER_DEST, resp_iov, in_iovs, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
@@ -1238,7 +1242,7 @@ vhost_scsi_send_an_resp(struct vhost_scsi *vs,
 	memset(&rsp, 0, sizeof(rsp));	/* event_actual = 0 */
 	rsp.response = VIRTIO_SCSI_S_OK;
 
-	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
@@ -1461,6 +1465,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
+		kfree(tv_cmd->tvc_resp_iov);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
@@ -1508,6 +1513,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			goto out;
 		}
 
+		tv_cmd->tvc_resp_iov = kcalloc(UIO_MAXIOV,
+					       sizeof(struct iovec),
+					       GFP_KERNEL);
+		if (!tv_cmd->tvc_resp_iov) {
+			pr_err("Unable to allocate tv_cmd->tvc_resp_iov\n");
+			goto out;
+		}
+
 		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
 					       sizeof(struct scatterlist),
 					       GFP_KERNEL);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3c2359570df9..43c9770b86e5 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -661,7 +661,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_stop);
 
-static void vhost_clear_msg(struct vhost_dev *dev)
+void vhost_clear_msg(struct vhost_dev *dev)
 {
 	struct vhost_msg_node *node, *n;
 
@@ -679,6 +679,7 @@ static void vhost_clear_msg(struct vhost_dev *dev)
 
 	spin_unlock(&dev->iotlb_lock);
 }
+EXPORT_SYMBOL_GPL(vhost_clear_msg);
 
 void vhost_dev_cleanup(struct vhost_dev *dev)
 {
@@ -832,7 +833,7 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 				     VHOST_ACCESS_WO);
 		if (ret < 0)
 			goto out;
-		iov_iter_init(&t, WRITE, vq->iotlb_iov, ret, size);
+		iov_iter_init(&t, ITER_DEST, vq->iotlb_iov, ret, size);
 		ret = copy_to_iter(from, size, &t);
 		if (ret == size)
 			ret = 0;
@@ -871,7 +872,7 @@ static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 			       (unsigned long long) size);
 			goto out;
 		}
-		iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
+		iov_iter_init(&f, ITER_SOURCE, vq->iotlb_iov, ret, size);
 		ret = copy_from_iter(to, size, &f);
 		if (ret == size)
 			ret = 0;
@@ -2135,7 +2136,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
 			vq_err(vq, "Translation failure %d in indirect.\n", ret);
 		return ret;
 	}
-	iov_iter_init(&from, READ, vq->indirect, ret, len);
+	iov_iter_init(&from, ITER_SOURCE, vq->indirect, ret, len);
 	count = len / sizeof desc;
 	/* Buffers are chained via a 16 bit next field, so
 	 * we can have at most 2^16 of these. */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..790b296271f1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -181,6 +181,7 @@ long vhost_dev_ioctl(struct vhost_dev *, unsigned int ioctl, void __user *argp);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
+void vhost_clear_msg(struct vhost_dev *dev);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 828c29306565..33eb941fcf15 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1161,7 +1161,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, READ, iov, ret, translated);
+		iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
 
 		ret = copy_from_iter(dst, translated, &iter);
 		if (ret < 0)
@@ -1194,7 +1194,7 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, WRITE, iov, ret, translated);
+		iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
 
 		ret = copy_to_iter(src, translated, &iter);
 		if (ret < 0)
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 10a7d23731fe..a2b374372363 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -165,7 +165,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
+		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
 		payload_len = pkt->len - pkt->off;
 
 		/* If the packet is greater than the space available in the
@@ -371,7 +371,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 
 	len = iov_length(vq->iov, out);
-	iov_iter_init(&iov_iter, WRITE, vq->iov, out, len);
+	iov_iter_init(&iov_iter, ITER_SOURCE, vq->iov, out, len);
 
 	nbytes = copy_from_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
 	if (nbytes != sizeof(pkt->hdr)) {
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 14a7d404062c..1b14c21af2b7 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2495,9 +2495,12 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
 	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
 		return -EINVAL;
 
+	if (font->width > 32 || font->height > 32)
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
-	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
-	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+	if (!(info->pixmap.blit_x & BIT(font->width - 1)) ||
+	    !(info->pixmap.blit_y & BIT(font->height - 1)))
 		return -EINVAL;
 
 	/* Make sure driver can handle the font length */
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 9343b7a4ac89..2ad6e98ce10d 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1622,7 +1622,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	struct usb_device *usbdev;
 	struct ufx_data *dev;
 	struct fb_info *info;
-	int retval;
+	int retval = -ENOMEM;
 	u32 id_rev, fpga_rev;
 
 	/* usb initialization */
@@ -1654,15 +1654,17 @@ static int ufx_usb_probe(struct usb_interface *interface,
 
 	if (!ufx_alloc_urb_list(dev, WRITES_IN_FLIGHT, MAX_TRANSFER)) {
 		dev_err(dev->gdev, "ufx_alloc_urb_list failed\n");
-		goto e_nomem;
+		goto put_ref;
 	}
 
 	/* We don't register a new USB class. Our client interface is fbdev */
 
 	/* allocates framebuffer driver structure, not framebuffer memory */
 	info = framebuffer_alloc(0, &usbdev->dev);
-	if (!info)
-		goto e_nomem;
+	if (!info) {
+		dev_err(dev->gdev, "framebuffer_alloc failed\n");
+		goto free_urb_list;
+	}
 
 	dev->info = info;
 	info->par = dev;
@@ -1705,22 +1707,34 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	check_warn_goto_error(retval, "unable to find common mode for display and adapter");
 
 	retval = ufx_reg_set_bits(dev, 0x4000, 0x00000001);
-	check_warn_goto_error(retval, "error %d enabling graphics engine", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d enabling graphics engine", retval);
+		goto setup_modes;
+	}
 
 	/* ready to begin using device */
 	atomic_set(&dev->usb_active, 1);
 
 	dev_dbg(dev->gdev, "checking var");
 	retval = ufx_ops_check_var(&info->var, info);
-	check_warn_goto_error(retval, "error %d ufx_ops_check_var", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d ufx_ops_check_var", retval);
+		goto reset_active;
+	}
 
 	dev_dbg(dev->gdev, "setting par");
 	retval = ufx_ops_set_par(info);
-	check_warn_goto_error(retval, "error %d ufx_ops_set_par", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d ufx_ops_set_par", retval);
+		goto reset_active;
+	}
 
 	dev_dbg(dev->gdev, "registering framebuffer");
 	retval = register_framebuffer(info);
-	check_warn_goto_error(retval, "error %d register_framebuffer", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d register_framebuffer", retval);
+		goto reset_active;
+	}
 
 	dev_info(dev->gdev, "SMSC UDX USB device /dev/fb%d attached. %dx%d resolution."
 		" Using %dK framebuffer memory\n", info->node,
@@ -1728,21 +1742,23 @@ static int ufx_usb_probe(struct usb_interface *interface,
 
 	return 0;
 
-error:
-	fb_dealloc_cmap(&info->cmap);
-destroy_modedb:
+reset_active:
+	atomic_set(&dev->usb_active, 0);
+setup_modes:
 	fb_destroy_modedb(info->monspecs.modedb);
 	vfree(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
+error:
+	fb_dealloc_cmap(&info->cmap);
+destroy_modedb:
 	framebuffer_release(info);
+free_urb_list:
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 put_ref:
 	kref_put(&dev->kref, ufx_free); /* ref for framebuffer */
 	kref_put(&dev->kref, ufx_free); /* last ref from kref_init */
 	return retval;
-
-e_nomem:
-	retval = -ENOMEM;
-	goto put_ref;
 }
 
 static void ufx_usb_disconnect(struct usb_interface *interface)
diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
index 4cb10877017c..6ca5d9515d85 100644
--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -86,7 +86,7 @@ static int __diag288(unsigned int func, unsigned int timeout,
 		"1:\n"
 		EX_TABLE(0b, 1b)
 		: "+d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__action), "d"(__len) : "1", "cc");
+		  "d"(__action), "d"(__len) : "1", "cc", "memory");
 	return err;
 }
 
@@ -268,12 +268,21 @@ static int __init diag288_init(void)
 	char ebc_begin[] = {
 		194, 197, 199, 201, 213
 	};
+	char *ebc_cmd;
 
 	watchdog_set_nowayout(&wdt_dev, nowayout_info);
 
 	if (MACHINE_IS_VM) {
-		if (__diag288_vm(WDT_FUNC_INIT, 15,
-				 ebc_begin, sizeof(ebc_begin)) != 0) {
+		ebc_cmd = kmalloc(sizeof(ebc_begin), GFP_KERNEL);
+		if (!ebc_cmd) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -ENOMEM;
+		}
+		memcpy(ebc_cmd, ebc_begin, sizeof(ebc_begin));
+		ret = __diag288_vm(WDT_FUNC_INIT, 15,
+				   ebc_cmd, sizeof(ebc_begin));
+		kfree(ebc_cmd);
+		if (ret != 0) {
 			pr_err("The watchdog cannot be initialized\n");
 			return -EINVAL;
 		}
diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index d6f945fd4147..28b2a1fa25ab 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -129,13 +129,13 @@ static bool pvcalls_conn_back_read(void *opaque)
 	if (masked_prod < masked_cons) {
 		vec[0].iov_base = data->in + masked_prod;
 		vec[0].iov_len = wanted;
-		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 1, wanted);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, vec, 1, wanted);
 	} else {
 		vec[0].iov_base = data->in + masked_prod;
 		vec[0].iov_len = array_size - masked_prod;
 		vec[1].iov_base = data->in;
 		vec[1].iov_len = wanted - vec[0].iov_len;
-		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 2, wanted);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, vec, 2, wanted);
 	}
 
 	atomic_set(&map->read, 0);
@@ -188,13 +188,13 @@ static bool pvcalls_conn_back_write(struct sock_mapping *map)
 	if (pvcalls_mask(prod, array_size) > pvcalls_mask(cons, array_size)) {
 		vec[0].iov_base = data->out + pvcalls_mask(cons, array_size);
 		vec[0].iov_len = size;
-		iov_iter_kvec(&msg.msg_iter, READ, vec, 1, size);
+		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 1, size);
 	} else {
 		vec[0].iov_base = data->out + pvcalls_mask(cons, array_size);
 		vec[0].iov_len = array_size - pvcalls_mask(cons, array_size);
 		vec[1].iov_base = data->out;
 		vec[1].iov_len = size - vec[0].iov_len;
-		iov_iter_kvec(&msg.msg_iter, READ, vec, 2, size);
+		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 2, size);
 	}
 
 	atomic_set(&map->write, 0);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 47b9a1122f34..a19891015f19 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -40,7 +40,7 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 	size_t len = subreq->len   - subreq->transferred;
 	int total, err;
 
-	iov_iter_xarray(&to, READ, &rreq->mapping->i_pages, pos, len);
+	iov_iter_xarray(&to, ITER_DEST, &rreq->mapping->i_pages, pos, len);
 
 	total = p9_client_read(fid, pos, &to, &err);
 
@@ -172,7 +172,7 @@ static int v9fs_vfs_write_folio_locked(struct folio *folio)
 
 	len = min_t(loff_t, i_size - start, len);
 
-	iov_iter_xarray(&from, WRITE, &folio_mapping(folio)->i_pages, start, len);
+	iov_iter_xarray(&from, ITER_SOURCE, &folio_mapping(folio)->i_pages, start, len);
 
 	/* We should have writeback_fid always set */
 	BUG_ON(!v9inode->writeback_fid);
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 000fbaae9b18..3bb95adc9619 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -109,7 +109,7 @@ static int v9fs_dir_readdir(struct file *file, struct dir_context *ctx)
 			struct iov_iter to;
 			int n;
 
-			iov_iter_kvec(&to, READ, &kvec, 1, buflen);
+			iov_iter_kvec(&to, ITER_DEST, &kvec, 1, buflen);
 			n = p9_client_read(file->private_data, ctx->pos, &to,
 					   &err);
 			if (err)
diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 1f9298a4bd42..2807bb63f780 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -24,7 +24,7 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
 	struct iov_iter to;
 	int err;
 
-	iov_iter_kvec(&to, READ, &kvec, 1, buffer_size);
+	iov_iter_kvec(&to, ITER_DEST, &kvec, 1, buffer_size);
 
 	attr_fid = p9_client_xattrwalk(fid, name, &attr_size);
 	if (IS_ERR(attr_fid)) {
@@ -109,7 +109,7 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
 	struct iov_iter from;
 	int retval, err;
 
-	iov_iter_kvec(&from, WRITE, &kvec, 1, value_len);
+	iov_iter_kvec(&from, ITER_SOURCE, &kvec, 1, value_len);
 
 	p9_debug(P9_DEBUG_VFS, "name = %s value_len = %zu flags = %d\n",
 		 name, value_len, flags);
diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 0a090d614e76..7dcd59693a0c 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -298,7 +298,7 @@ static int afs_deliver_cb_callback(struct afs_call *call)
 		if (call->count2 != call->count && call->count2 != 0)
 			return afs_protocol_error(call, afs_eproto_cb_count);
 		call->iter = &call->def_iter;
-		iov_iter_discard(&call->def_iter, READ, call->count2 * 3 * 4);
+		iov_iter_discard(&call->def_iter, ITER_DEST, call->count2 * 3 * 4);
 		call->unmarshall++;
 
 		fallthrough;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 230c2d19116d..104df2964225 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -305,7 +305,7 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	req->actual_len = i_size; /* May change */
 	req->len = nr_pages * PAGE_SIZE; /* We can ask for more than there is */
 	req->data_version = dvnode->status.data_version; /* May change */
-	iov_iter_xarray(&req->def_iter, READ, &dvnode->netfs.inode.i_mapping->i_pages,
+	iov_iter_xarray(&req->def_iter, ITER_DEST, &dvnode->netfs.inode.i_mapping->i_pages,
 			0, i_size);
 	req->iter = &req->def_iter;
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index d1cfb235c4b9..2eeab57df133 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -324,7 +324,7 @@ static void afs_issue_read(struct netfs_io_subrequest *subreq)
 	fsreq->vnode	= vnode;
 	fsreq->iter	= &fsreq->def_iter;
 
-	iov_iter_xarray(&fsreq->def_iter, READ,
+	iov_iter_xarray(&fsreq->def_iter, ITER_DEST,
 			&fsreq->vnode->netfs.inode.i_mapping->i_pages,
 			fsreq->pos, fsreq->len);
 
@@ -346,7 +346,7 @@ static int afs_symlink_read_folio(struct file *file, struct folio *folio)
 	fsreq->len	= folio_size(folio);
 	fsreq->vnode	= vnode;
 	fsreq->iter	= &fsreq->def_iter;
-	iov_iter_xarray(&fsreq->def_iter, READ, &folio->mapping->i_pages,
+	iov_iter_xarray(&fsreq->def_iter, ITER_DEST, &folio->mapping->i_pages,
 			fsreq->pos, fsreq->len);
 
 	ret = afs_fetch_data(fsreq->vnode, fsreq);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 723d162078a3..9ba7b68375c9 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1301,7 +1301,7 @@ static inline void afs_extract_begin(struct afs_call *call, void *buf, size_t si
 	call->iov_len = size;
 	call->kvec[0].iov_base = buf;
 	call->kvec[0].iov_len = size;
-	iov_iter_kvec(&call->def_iter, READ, call->kvec, 1, size);
+	iov_iter_kvec(&call->def_iter, ITER_DEST, call->kvec, 1, size);
 }
 
 static inline void afs_extract_to_tmp(struct afs_call *call)
@@ -1319,7 +1319,7 @@ static inline void afs_extract_to_tmp64(struct afs_call *call)
 static inline void afs_extract_discard(struct afs_call *call, size_t size)
 {
 	call->iov_len = size;
-	iov_iter_discard(&call->def_iter, READ, size);
+	iov_iter_discard(&call->def_iter, ITER_DEST, size);
 }
 
 static inline void afs_extract_to_buf(struct afs_call *call, size_t size)
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index eccc3cd0cb70..c62939e5ea1f 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -359,7 +359,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 
 	msg.msg_name		= NULL;
 	msg.msg_namelen		= 0;
-	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, call->request_size);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, iov, 1, call->request_size);
 	msg.msg_control		= NULL;
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= MSG_WAITALL | (call->write_iter ? MSG_MORE : 0);
@@ -400,7 +400,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 					RX_USER_ABORT, ret, "KSD");
 	} else {
 		len = 0;
-		iov_iter_kvec(&msg.msg_iter, READ, NULL, 0, 0);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
 				       &msg.msg_iter, &len, false,
 				       &call->abort_code, &call->service_id);
@@ -485,7 +485,7 @@ static void afs_deliver_to_call(struct afs_call *call)
 	       ) {
 		if (state == AFS_CALL_SV_AWAIT_ACK) {
 			len = 0;
-			iov_iter_kvec(&call->def_iter, READ, NULL, 0, 0);
+			iov_iter_kvec(&call->def_iter, ITER_DEST, NULL, 0, 0);
 			ret = rxrpc_kernel_recv_data(call->net->socket,
 						     call->rxcall, &call->def_iter,
 						     &len, false, &remote_abort,
@@ -822,7 +822,7 @@ void afs_send_empty_reply(struct afs_call *call)
 
 	msg.msg_name		= NULL;
 	msg.msg_namelen		= 0;
-	iov_iter_kvec(&msg.msg_iter, WRITE, NULL, 0, 0);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, NULL, 0, 0);
 	msg.msg_control		= NULL;
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
@@ -862,7 +862,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	iov[0].iov_len		= len;
 	msg.msg_name		= NULL;
 	msg.msg_namelen		= 0;
-	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, iov, 1, len);
 	msg.msg_control		= NULL;
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 9ebdd36eaf2f..08fd456dde67 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -609,7 +609,7 @@ static ssize_t afs_write_back_from_locked_folio(struct address_space *mapping,
 		 */
 		afs_write_to_cache(vnode, start, len, i_size, caching);
 
-		iov_iter_xarray(&iter, WRITE, &mapping->i_pages, start, len);
+		iov_iter_xarray(&iter, ITER_SOURCE, &mapping->i_pages, start, len);
 		ret = afs_store_data(vnode, &iter, start, false);
 	} else {
 		_debug("write discard %x @%llx [%llx]", len, start, i_size);
@@ -1000,7 +1000,7 @@ int afs_launder_folio(struct folio *folio)
 		bv[0].bv_page = &folio->page;
 		bv[0].bv_offset = f;
 		bv[0].bv_len = t - f;
-		iov_iter_bvec(&iter, WRITE, bv, 1, bv[0].bv_len);
+		iov_iter_bvec(&iter, ITER_SOURCE, bv, 1, bv[0].bv_len);
 
 		trace_afs_folio_dirty(vnode, tracepoint_string("launder"), folio);
 		ret = afs_store_data(vnode, &iter, folio_pos(folio) + f, true);
diff --git a/fs/aio.c b/fs/aio.c
index 5b2ff20ad322..562916d85cba 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1552,7 +1552,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->read_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(READ, iocb, &iovec, vectored, compat, &iter);
+	ret = aio_setup_rw(ITER_DEST, iocb, &iovec, vectored, compat, &iter);
 	if (ret < 0)
 		return ret;
 	ret = rw_verify_area(READ, file, &req->ki_pos, iov_iter_count(&iter));
@@ -1580,7 +1580,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->write_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(WRITE, iocb, &iovec, vectored, compat, &iter);
+	ret = aio_setup_rw(ITER_SOURCE, iocb, &iovec, vectored, compat, &iter);
 	if (ret < 0)
 		return ret;
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd1902573cde..c05f16a35bca 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5283,7 +5283,7 @@ static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp,
 		goto out_acct;
 	}
 
-	ret = import_iovec(READ, args.iov, args.iovcnt, ARRAY_SIZE(iovstack),
+	ret = import_iovec(ITER_DEST, args.iov, args.iovcnt, ARRAY_SIZE(iovstack),
 			   &iov, &iter);
 	if (ret < 0)
 		goto out_acct;
@@ -5382,7 +5382,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 	if (args.len > args.unencoded_len - args.unencoded_offset)
 		goto out_acct;
 
-	ret = import_iovec(WRITE, args.iov, args.iovcnt, ARRAY_SIZE(iovstack),
+	ret = import_iovec(ITER_SOURCE, args.iov, args.iovcnt, ARRAY_SIZE(iovstack),
 			   &iov, &iter);
 	if (ret < 0)
 		goto out_acct;
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index dcf701b05cc1..61f47debec5a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -288,7 +288,7 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 	}
 
 	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
+	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
 	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);
 	if (err == 0)
 		err = -EFAULT;
@@ -327,7 +327,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
+	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
 	err = iov_iter_get_pages_alloc2(&iter, &pages, len, &page_off);
 	if (err < 0) {
 		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 04fd34557de8..6f9580defb2b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1161,7 +1161,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 				aio_req->total_len = rc + zlen;
 			}
 
-			iov_iter_bvec(&i, READ, osd_data->bvec_pos.bvecs,
+			iov_iter_bvec(&i, ITER_DEST, osd_data->bvec_pos.bvecs,
 				      osd_data->num_bvecs, len);
 			iov_iter_advance(&i, rc);
 			iov_iter_zero(zlen, &i);
@@ -1400,7 +1400,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 				int zlen = min_t(size_t, len - ret,
 						 size - pos - ret);
 
-				iov_iter_bvec(&i, READ, bvecs, num_pages, len);
+				iov_iter_bvec(&i, ITER_DEST, bvecs, num_pages, len);
 				iov_iter_advance(&i, ret);
 				iov_iter_zero(zlen, &i);
 				ret += zlen;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index eab36e4ea130..384c7c0e1088 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -761,7 +761,7 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 {
 	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
-	iov_iter_kvec(&smb_msg.msg_iter, READ, &iov, 1, to_read);
+	iov_iter_kvec(&smb_msg.msg_iter, ITER_DEST, &iov, 1, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
 }
@@ -776,7 +776,7 @@ cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
 	 *  and cifs_readv_from_socket sets msg_control and msg_controllen
 	 *  so little to initialize in struct msghdr
 	 */
-	iov_iter_discard(&smb_msg.msg_iter, READ, to_read);
+	iov_iter_discard(&smb_msg.msg_iter, ITER_DEST, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
 }
@@ -788,7 +788,7 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	struct msghdr smb_msg = {};
 	struct bio_vec bv = {
 		.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
-	iov_iter_bvec(&smb_msg.msg_iter, READ, &bv, 1, to_read);
+	iov_iter_bvec(&smb_msg.msg_iter, ITER_DEST, &bv, 1, to_read);
 	return cifs_readv_from_socket(server, &smb_msg);
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cd9698209930..209dfc06fd6d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3532,7 +3532,7 @@ static ssize_t __cifs_writev(
 		ctx->iter = *from;
 		ctx->len = len;
 	} else {
-		rc = setup_aio_ctx_iter(ctx, from, WRITE);
+		rc = setup_aio_ctx_iter(ctx, from, ITER_SOURCE);
 		if (rc) {
 			kref_put(&ctx->refcount, cifs_aio_ctx_release);
 			return rc;
@@ -4276,7 +4276,7 @@ static ssize_t __cifs_readv(
 		ctx->iter = *to;
 		ctx->len = len;
 	} else {
-		rc = setup_aio_ctx_iter(ctx, to, READ);
+		rc = setup_aio_ctx_iter(ctx, to, ITER_DEST);
 		if (rc) {
 			kref_put(&ctx->refcount, cifs_aio_ctx_release);
 			return rc;
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index a1751b956318..f6f3a6b75601 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -150,7 +150,7 @@ static int fscache_fallback_read_page(struct inode *inode, struct page *page)
 	bvec[0].bv_page		= page;
 	bvec[0].bv_offset	= 0;
 	bvec[0].bv_len		= PAGE_SIZE;
-	iov_iter_bvec(&iter, READ, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
+	iov_iter_bvec(&iter, ITER_DEST, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
 
 	ret = fscache_begin_read_operation(&cres, cookie);
 	if (ret < 0)
@@ -180,7 +180,7 @@ static int fscache_fallback_write_page(struct inode *inode, struct page *page,
 	bvec[0].bv_page		= page;
 	bvec[0].bv_offset	= 0;
 	bvec[0].bv_len		= PAGE_SIZE;
-	iov_iter_bvec(&iter, WRITE, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
 
 	ret = fscache_begin_write_operation(&cres, cookie);
 	if (ret < 0)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1ff5b6b0e07a..78c2d618eb51 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4737,13 +4737,13 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			return 0;
 		}
 
-		iov_iter_bvec(&iter, WRITE, bvec, npages, data_len);
+		iov_iter_bvec(&iter, ITER_SOURCE, bvec, npages, data_len);
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */
 		WARN_ONCE(npages > 0, "read data can be either in buf or in pages");
 		iov.iov_base = buf + data_offset;
 		iov.iov_len = data_len;
-		iov_iter_kvec(&iter, WRITE, &iov, 1, data_len);
+		iov_iter_kvec(&iter, ITER_SOURCE, &iov, 1, data_len);
 	} else {
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 575fa8f58342..3851d0aaa288 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -347,7 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			.iov_base = &rfc1002_marker,
 			.iov_len  = 4
 		};
-		iov_iter_kvec(&smb_msg.msg_iter, WRITE, &hiov, 1, 4);
+		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, &hiov, 1, 4);
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
 			goto unmask;
@@ -368,7 +368,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			size += iov[i].iov_len;
 		}
 
-		iov_iter_kvec(&smb_msg.msg_iter, WRITE, iov, n_vec, size);
+		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, iov, n_vec, size);
 
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
@@ -384,7 +384,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			rqst_page_get_length(&rqst[j], i, &bvec.bv_len,
 					     &bvec.bv_offset);
 
-			iov_iter_bvec(&smb_msg.msg_iter, WRITE,
+			iov_iter_bvec(&smb_msg.msg_iter, ITER_SOURCE,
 				      &bvec, 1, bvec.bv_len);
 			rc = smb_send_kvec(server, &smb_msg, &sent);
 			if (rc < 0)
diff --git a/fs/coredump.c b/fs/coredump.c
index 7bad7785e8e6..095ed821c8ac 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -853,7 +853,7 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	if (dump_interrupted())
 		return 0;
 	pos = file->f_pos;
-	iov_iter_bvec(&iter, WRITE, &bvec, 1, PAGE_SIZE);
+	iov_iter_bvec(&iter, ITER_SOURCE, &bvec, 1, PAGE_SIZE);
 	n = __kernel_write_iter(cprm->file, &iter, &pos);
 	if (n != PAGE_SIZE)
 		return 0;
diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 6a792a513d6b..b04f93bc062a 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -194,7 +194,7 @@ static int erofs_fscache_read_folios_async(struct fscache_cookie *cookie,
 
 		atomic_inc(&rreq->nr_outstanding);
 
-		iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages,
+		iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages,
 				start + done, subreq->len);
 
 		ret = fscache_read(cres, subreq->start, &iter,
@@ -290,7 +290,7 @@ static int erofs_fscache_data_read(struct address_space *mapping,
 		if (IS_ERR(src))
 			return PTR_ERR(src);
 
-		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, PAGE_SIZE);
+		iov_iter_xarray(&iter, ITER_DEST, &mapping->i_pages, pos, PAGE_SIZE);
 		if (copy_to_iter(src + offset, size, &iter) != size) {
 			erofs_put_metabuf(&buf);
 			return -EFAULT;
@@ -302,7 +302,7 @@ static int erofs_fscache_data_read(struct address_space *mapping,
 
 	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
 		count = len;
-		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, count);
+		iov_iter_xarray(&iter, ITER_DEST, &mapping->i_pages, pos, count);
 		iov_iter_zero(count, &iter);
 		return count;
 	}
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b3184d8b1ce8..ee6836478efe 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1078,7 +1078,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 {
 	struct page *node_page;
 	nid_t nid;
-	unsigned int ofs_in_node, max_addrs;
+	unsigned int ofs_in_node, max_addrs, base;
 	block_t source_blkaddr;
 
 	nid = le32_to_cpu(sum->nid);
@@ -1104,11 +1104,17 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		return false;
 	}
 
-	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
-						DEF_ADDRS_PER_BLOCK;
-	if (ofs_in_node >= max_addrs) {
-		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
-			ofs_in_node, dni->ino, dni->nid, max_addrs);
+	if (IS_INODE(node_page)) {
+		base = offset_in_addr(F2FS_INODE(node_page));
+		max_addrs = DEF_ADDRS_PER_INODE;
+	} else {
+		base = 0;
+		max_addrs = DEF_ADDRS_PER_BLOCK;
+	}
+
+	if (base + ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent blkaddr offset: base:%u, ofs_in_node:%u, max:%u, ino:%u, nid:%u",
+			base, ofs_in_node, max_addrs, dni->ino, dni->nid);
 		f2fs_put_page(node_page, 1);
 		return false;
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 67d51f527606..eaabb85cb4dd 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4095,6 +4095,24 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->sb = sb;
 
+	/* initialize locks within allocated memory */
+	init_f2fs_rwsem(&sbi->gc_lock);
+	mutex_init(&sbi->writepages);
+	init_f2fs_rwsem(&sbi->cp_global_sem);
+	init_f2fs_rwsem(&sbi->node_write);
+	init_f2fs_rwsem(&sbi->node_change);
+	spin_lock_init(&sbi->stat_lock);
+	init_f2fs_rwsem(&sbi->cp_rwsem);
+	init_f2fs_rwsem(&sbi->quota_sem);
+	init_waitqueue_head(&sbi->cp_wait);
+	spin_lock_init(&sbi->error_lock);
+
+	for (i = 0; i < NR_INODE_TYPE; i++) {
+		INIT_LIST_HEAD(&sbi->inode_list[i]);
+		spin_lock_init(&sbi->inode_lock[i]);
+	}
+	mutex_init(&sbi->flush_lock);
+
 	/* Load the checksum driver */
 	sbi->s_chksum_driver = crypto_alloc_shash("crc32", 0, 0);
 	if (IS_ERR(sbi->s_chksum_driver)) {
@@ -4118,6 +4136,8 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 	sbi->raw_super = raw_super;
 
+	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
+
 	/* precompute checksum seed for metadata */
 	if (f2fs_sb_has_inode_chksum(sbi))
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
@@ -4174,26 +4194,14 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* init f2fs-specific super block info */
 	sbi->valid_super_block = valid_super_block;
-	init_f2fs_rwsem(&sbi->gc_lock);
-	mutex_init(&sbi->writepages);
-	init_f2fs_rwsem(&sbi->cp_global_sem);
-	init_f2fs_rwsem(&sbi->node_write);
-	init_f2fs_rwsem(&sbi->node_change);
 
 	/* disallow all the data/node/meta page writes */
 	set_sbi_flag(sbi, SBI_POR_DOING);
-	spin_lock_init(&sbi->stat_lock);
 
 	err = f2fs_init_write_merge_io(sbi);
 	if (err)
 		goto free_bio_info;
 
-	spin_lock_init(&sbi->error_lock);
-	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
-
-	init_f2fs_rwsem(&sbi->cp_rwsem);
-	init_f2fs_rwsem(&sbi->quota_sem);
-	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
 
 	err = f2fs_init_iostat(sbi);
@@ -4271,12 +4279,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	limit_reserve_root(sbi);
 	adjust_unusable_cap_perc(sbi);
 
-	for (i = 0; i < NR_INODE_TYPE; i++) {
-		INIT_LIST_HEAD(&sbi->inode_list[i]);
-		spin_lock_init(&sbi->inode_lock[i]);
-	}
-	mutex_init(&sbi->flush_lock);
-
 	f2fs_init_extent_cache_info(sbi);
 
 	f2fs_init_ino_entry_info(sbi);
diff --git a/fs/fscache/io.c b/fs/fscache/io.c
index 3af3b08a9bb3..0d2b8dec8f82 100644
--- a/fs/fscache/io.c
+++ b/fs/fscache/io.c
@@ -286,7 +286,7 @@ void __fscache_write_to_cache(struct fscache_cookie *cookie,
 	 * taken into account.
 	 */
 
-	iov_iter_xarray(&iter, WRITE, &mapping->i_pages, start, len);
+	iov_iter_xarray(&iter, ITER_SOURCE, &mapping->i_pages, start, len);
 	fscache_write(cres, start, &iter, fscache_wreq_done, wreq);
 	return;
 
diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index ab8ceddf9efa..903af9d85f8b 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -141,13 +141,14 @@ static bool fscache_is_acquire_pending(struct fscache_volume *volume)
 static void fscache_wait_on_volume_collision(struct fscache_volume *candidate,
 					     unsigned int collidee_debug_id)
 {
-	wait_var_event_timeout(&candidate->flags,
-			       !fscache_is_acquire_pending(candidate), 20 * HZ);
+	wait_on_bit_timeout(&candidate->flags, FSCACHE_VOLUME_ACQUIRE_PENDING,
+			    TASK_UNINTERRUPTIBLE, 20 * HZ);
 	if (fscache_is_acquire_pending(candidate)) {
 		pr_notice("Potential volume collision new=%08x old=%08x",
 			  candidate->debug_id, collidee_debug_id);
 		fscache_stat(&fscache_n_volumes_collision);
-		wait_var_event(&candidate->flags, !fscache_is_acquire_pending(candidate));
+		wait_on_bit(&candidate->flags, FSCACHE_VOLUME_ACQUIRE_PENDING,
+			    TASK_UNINTERRUPTIBLE);
 	}
 }
 
@@ -347,8 +348,8 @@ static void fscache_wake_pending_volume(struct fscache_volume *volume,
 	hlist_bl_for_each_entry(cursor, p, h, hash_link) {
 		if (fscache_volume_same(cursor, volume)) {
 			fscache_see_volume(cursor, fscache_volume_see_hash_wake);
-			clear_bit(FSCACHE_VOLUME_ACQUIRE_PENDING, &cursor->flags);
-			wake_up_bit(&cursor->flags, FSCACHE_VOLUME_ACQUIRE_PENDING);
+			clear_and_wake_up_bit(FSCACHE_VOLUME_ACQUIRE_PENDING,
+					      &cursor->flags);
 			return;
 		}
 	}
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 61d8afcb10a3..fcce94ace2c2 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -255,7 +255,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		ap.args.in_pages = true;
 
 		err = -EFAULT;
-		iov_iter_init(&ii, WRITE, in_iov, in_iovs, in_size);
+		iov_iter_init(&ii, ITER_SOURCE, in_iov, in_iovs, in_size);
 		for (i = 0; iov_iter_count(&ii) && !WARN_ON(i >= ap.num_pages); i++) {
 			c = copy_page_from_iter(ap.pages[i], 0, PAGE_SIZE, &ii);
 			if (c != PAGE_SIZE && iov_iter_count(&ii))
@@ -324,7 +324,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		goto out;
 
 	err = -EFAULT;
-	iov_iter_init(&ii, READ, out_iov, out_iovs, transferred);
+	iov_iter_init(&ii, ITER_DEST, out_iov, out_iovs, transferred);
 	for (i = 0; iov_iter_count(&ii) && !WARN_ON(i >= ap.num_pages); i++) {
 		c = copy_page_to_iter(ap.pages[i], 0, PAGE_SIZE, &ii);
 		if (c != PAGE_SIZE && iov_iter_count(&ii))
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 05bee80ac7de..e782b4f1d104 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -427,8 +427,6 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 3bdb2c668a71..e7537fd305dd 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -61,9 +61,6 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 49210a2e7ce7..d78b61ecc1cd 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -397,38 +397,39 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	struct timespec64 atime;
 	u16 height, depth;
 	umode_t mode = be32_to_cpu(str->di_mode);
-	bool is_new = ip->i_inode.i_state & I_NEW;
+	struct inode *inode = &ip->i_inode;
+	bool is_new = inode->i_state & I_NEW;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
 		goto corrupt;
-	if (unlikely(!is_new && inode_wrong_type(&ip->i_inode, mode)))
+	if (unlikely(!is_new && inode_wrong_type(inode, mode)))
 		goto corrupt;
 	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
-	ip->i_inode.i_mode = mode;
+	inode->i_mode = mode;
 	if (is_new) {
-		ip->i_inode.i_rdev = 0;
+		inode->i_rdev = 0;
 		switch (mode & S_IFMT) {
 		case S_IFBLK:
 		case S_IFCHR:
-			ip->i_inode.i_rdev = MKDEV(be32_to_cpu(str->di_major),
-						   be32_to_cpu(str->di_minor));
+			inode->i_rdev = MKDEV(be32_to_cpu(str->di_major),
+					      be32_to_cpu(str->di_minor));
 			break;
 		}
 	}
 
-	i_uid_write(&ip->i_inode, be32_to_cpu(str->di_uid));
-	i_gid_write(&ip->i_inode, be32_to_cpu(str->di_gid));
-	set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
-	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
-	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
+	i_uid_write(inode, be32_to_cpu(str->di_uid));
+	i_gid_write(inode, be32_to_cpu(str->di_gid));
+	set_nlink(inode, be32_to_cpu(str->di_nlink));
+	i_size_write(inode, be64_to_cpu(str->di_size));
+	gfs2_set_inode_blocks(inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
-	if (timespec64_compare(&ip->i_inode.i_atime, &atime) < 0)
-		ip->i_inode.i_atime = atime;
-	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
-	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
-	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
-	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
+	if (timespec64_compare(&inode->i_atime, &atime) < 0)
+		inode->i_atime = atime;
+	inode->i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
+	inode->i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
+	inode->i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
+	inode->i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
 
 	ip->i_goal = be64_to_cpu(str->di_goal_meta);
 	ip->i_generation = be64_to_cpu(str->di_generation);
@@ -436,7 +437,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_diskflags = be32_to_cpu(str->di_flags);
 	ip->i_eattr = be64_to_cpu(str->di_eattr);
 	/* i_diskflags and i_eattr must be set before gfs2_set_inode_flags() */
-	gfs2_set_inode_flags(&ip->i_inode);
+	gfs2_set_inode_flags(inode);
 	height = be16_to_cpu(str->di_height);
 	if (unlikely(height > GFS2_MAX_META_HEIGHT))
 		goto corrupt;
@@ -448,8 +449,11 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (S_ISREG(ip->i_inode.i_mode))
-		gfs2_set_aops(&ip->i_inode);
+	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
+	if (S_ISREG(inode->i_mode))
+		gfs2_set_aops(inode);
 
 	return 0;
 corrupt:
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 723639376ae2..61323deb80bc 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -80,6 +80,15 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 	brelse(bd->bd_bh);
 }
 
+static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
+		       void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 /**
  * gfs2_ail1_start_one - Start I/O on a transaction
  * @sdp: The superblock
@@ -131,7 +140,7 @@ __acquires(&sdp->sd_ail_lock)
 		if (!mapping)
 			continue;
 		spin_unlock(&sdp->sd_ail_lock);
-		ret = filemap_fdatawrite_wbc(mapping, wbc);
+		ret = write_cache_pages(mapping, wbc, __gfs2_writepage, mapping);
 		if (need_resched()) {
 			blk_finish_plug(plug);
 			cond_resched();
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b018957a1bb2..011f9e7660ef 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -379,6 +379,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp)
 
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 {
+	const struct inode *inode = &ip->i_inode;
 	struct gfs2_dinode *str = buf;
 
 	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
@@ -386,15 +387,15 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
 	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
 	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
-	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	str->di_uid = cpu_to_be32(i_uid_read(&ip->i_inode));
-	str->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
-	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
-	str->di_size = cpu_to_be64(i_size_read(&ip->i_inode));
-	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
-	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
-	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
+	str->di_mode = cpu_to_be32(inode->i_mode);
+	str->di_uid = cpu_to_be32(i_uid_read(inode));
+	str->di_gid = cpu_to_be32(i_gid_read(inode));
+	str->di_nlink = cpu_to_be32(inode->i_nlink);
+	str->di_size = cpu_to_be64(i_size_read(inode));
+	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(inode));
+	str->di_atime = cpu_to_be64(inode->i_atime.tv_sec);
+	str->di_mtime = cpu_to_be64(inode->i_mtime.tv_sec);
+	str->di_ctime = cpu_to_be64(inode->i_ctime.tv_sec);
 
 	str->di_goal_meta = cpu_to_be64(ip->i_goal);
 	str->di_goal_data = cpu_to_be64(ip->i_goal);
@@ -402,16 +403,16 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 
 	str->di_flags = cpu_to_be32(ip->i_diskflags);
 	str->di_height = cpu_to_be16(ip->i_height);
-	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
+	str->di_payload_format = cpu_to_be32(S_ISDIR(inode->i_mode) &&
 					     !(ip->i_diskflags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
 	str->di_depth = cpu_to_be16(ip->i_depth);
 	str->di_entries = cpu_to_be32(ip->i_entries);
 
 	str->di_eattr = cpu_to_be64(ip->i_eattr);
-	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
-	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
-	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
+	str->di_atime_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
+	str->di_mtime_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
+	str->di_ctime_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
 }
 
 /**
diff --git a/fs/netfs/io.c b/fs/netfs/io.c
index e374767d1b68..7f753380e047 100644
--- a/fs/netfs/io.c
+++ b/fs/netfs/io.c
@@ -23,7 +23,7 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
 {
 	struct iov_iter iter;
 
-	iov_iter_xarray(&iter, READ, &subreq->rreq->mapping->i_pages,
+	iov_iter_xarray(&iter, ITER_DEST, &subreq->rreq->mapping->i_pages,
 			subreq->start + subreq->transferred,
 			subreq->len   - subreq->transferred);
 	iov_iter_zero(iov_iter_count(&iter), &iter);
@@ -49,7 +49,7 @@ static void netfs_read_from_cache(struct netfs_io_request *rreq,
 	struct iov_iter iter;
 
 	netfs_stat(&netfs_n_rh_read);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages,
+	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages,
 			subreq->start + subreq->transferred,
 			subreq->len   - subreq->transferred);
 
@@ -208,7 +208,7 @@ static void netfs_rreq_do_write_to_cache(struct netfs_io_request *rreq)
 			continue;
 		}
 
-		iov_iter_xarray(&iter, WRITE, &rreq->mapping->i_pages,
+		iov_iter_xarray(&iter, ITER_SOURCE, &rreq->mapping->i_pages,
 				subreq->start, subreq->len);
 
 		atomic_inc(&rreq->nr_copy_ops);
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index e861d7bae305..e731c00a9fcb 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -252,7 +252,7 @@ static int fscache_fallback_read_page(struct inode *inode, struct page *page)
 	bvec[0].bv_page		= page;
 	bvec[0].bv_offset	= 0;
 	bvec[0].bv_len		= PAGE_SIZE;
-	iov_iter_bvec(&iter, READ, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
+	iov_iter_bvec(&iter, ITER_DEST, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
 
 	ret = fscache_begin_read_operation(&cres, cookie);
 	if (ret < 0)
@@ -282,7 +282,7 @@ static int fscache_fallback_write_page(struct inode *inode, struct page *page,
 	bvec[0].bv_page		= page;
 	bvec[0].bv_offset	= 0;
 	bvec[0].bv_len		= PAGE_SIZE;
-	iov_iter_bvec(&iter, WRITE, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, ARRAY_SIZE(bvec), PAGE_SIZE);
 
 	ret = fscache_begin_write_operation(&cres, cookie);
 	if (ret < 0)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 2934ab1d9862..0d49c6bb22eb 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -943,7 +943,7 @@ __be32 nfsd_readv(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	ssize_t host_err;
 
 	trace_nfsd_read_vector(rqstp, fhp, offset, *count);
-	iov_iter_kvec(&iter, READ, vec, vlen, *count);
+	iov_iter_kvec(&iter, ITER_DEST, vec, vlen, *count);
 	host_err = vfs_iter_read(file, &iter, &ppos, 0);
 	return nfsd_finish_read(rqstp, fhp, file, offset, count, eof, host_err);
 }
@@ -1033,7 +1033,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	if (stable && !use_wgather)
 		flags |= RWF_SYNC;
 
-	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
+	iov_iter_kvec(&iter, ITER_SOURCE, vec, vlen, *cnt);
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
 		nfsd_copy_write_verifier(verf, nn);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index e352aa37330c..22152300e60c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -132,6 +132,13 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	if (le16_to_cpu(attr->name_off) + attr->name_len > asize)
 		goto out;
 
+	if (attr->non_res) {
+		t64 = le64_to_cpu(attr->nres.alloc_size);
+		if (le64_to_cpu(attr->nres.data_size) > t64 ||
+		    le64_to_cpu(attr->nres.valid_size) > t64)
+			goto out;
+	}
+
 	switch (attr->type) {
 	case ATTR_STD:
 		if (attr->non_res ||
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f660c0dbdb63..785cabd71d67 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -900,7 +900,7 @@ static int o2net_recv_tcp_msg(struct socket *sock, void *data, size_t len)
 {
 	struct kvec vec = { .iov_len = len, .iov_base = data, };
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT, };
-	iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, len);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &vec, 1, len);
 	return sock_recvmsg(sock, &msg, MSG_DONTWAIT);
 }
 
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 7a8c0c6e698d..b3bbb5a5787a 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -53,7 +53,7 @@ static int orangefs_writepage_locked(struct page *page,
 	bv.bv_len = wlen;
 	bv.bv_offset = off % PAGE_SIZE;
 	WARN_ON(wlen == 0);
-	iov_iter_bvec(&iter, WRITE, &bv, 1, wlen);
+	iov_iter_bvec(&iter, ITER_SOURCE, &bv, 1, wlen);
 
 	ret = wait_for_direct_io(ORANGEFS_IO_WRITE, inode, &off, &iter, wlen,
 	    len, wr, NULL, NULL);
@@ -112,7 +112,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
 		else
 			ow->bv[i].bv_offset = 0;
 	}
-	iov_iter_bvec(&iter, WRITE, ow->bv, ow->npages, ow->len);
+	iov_iter_bvec(&iter, ITER_SOURCE, ow->bv, ow->npages, ow->len);
 
 	WARN_ON(ow->off >= len);
 	if (ow->off + ow->len > len)
@@ -270,7 +270,7 @@ static void orangefs_readahead(struct readahead_control *rac)
 	offset = readahead_pos(rac);
 	i_pages = &rac->mapping->i_pages;
 
-	iov_iter_xarray(&iter, READ, i_pages, offset, readahead_length(rac));
+	iov_iter_xarray(&iter, ITER_DEST, i_pages, offset, readahead_length(rac));
 
 	/* read in the pages. */
 	if ((ret = wait_for_direct_io(ORANGEFS_IO_READ, inode,
@@ -303,7 +303,7 @@ static int orangefs_read_folio(struct file *file, struct folio *folio)
 	bv.bv_page = &folio->page;
 	bv.bv_len = folio_size(folio);
 	bv.bv_offset = 0;
-	iov_iter_bvec(&iter, READ, &bv, 1, folio_size(folio));
+	iov_iter_bvec(&iter, ITER_DEST, &bv, 1, folio_size(folio));
 
 	ret = wait_for_direct_io(ORANGEFS_IO_READ, inode, &off, &iter,
 			folio_size(folio), inode->i_size, NULL, NULL, file);
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e065a5b9a442..ac9c3ad04016 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -796,7 +796,7 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy unaligned inner fh into aligned buffer */
-	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
+	memcpy(fh->buf, fid, buflen - OVL_FH_WIRE_OFFSET);
 	return fh;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index eee8f08d32b6..e74a610a117e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -108,7 +108,7 @@ struct ovl_fh {
 	u8 padding[3];	/* make sure fb.fid is 32bit aligned */
 	union {
 		struct ovl_fb fb;
-		u8 buf[0];
+		DECLARE_FLEX_ARRAY(u8, buf);
 	};
 } __packed;
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8a74cdcc9af0..a954305fbc31 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -737,9 +737,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index f2aa86c421f2..5aa527ca6dbe 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -199,7 +199,7 @@ ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 	struct kvec kvec = { .iov_base = buf, .iov_len = count };
 	struct iov_iter iter;
 
-	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 
 	return read_from_oldmem(&iter, count, ppos, false);
 }
@@ -212,7 +212,7 @@ ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
 	struct kvec kvec = { .iov_base = buf, .iov_len = count };
 	struct iov_iter iter;
 
-	iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, count);
 
 	return read_from_oldmem(&iter, count, ppos,
 			cc_platform_has(CC_ATTR_MEM_ENCRYPT));
@@ -437,7 +437,7 @@ static vm_fault_t mmap_vmcore_fault(struct vm_fault *vmf)
 		offset = (loff_t) index << PAGE_SHIFT;
 		kvec.iov_base = page_address(page);
 		kvec.iov_len = PAGE_SIZE;
-		iov_iter_kvec(&iter, READ, &kvec, 1, PAGE_SIZE);
+		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, PAGE_SIZE);
 
 		rc = __read_vmcore(&iter, &offset);
 		if (rc < 0) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 24b9668d6377..7a2ff6157eda 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -384,7 +384,7 @@ static ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, lo
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = (ppos ? *ppos : 0);
-	iov_iter_ubuf(&iter, READ, buf, len);
+	iov_iter_ubuf(&iter, ITER_DEST, buf, len);
 
 	ret = call_read_iter(filp, &kiocb, &iter);
 	BUG_ON(ret == -EIOCBQUEUED);
@@ -424,7 +424,7 @@ ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t *pos)
 
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = pos ? *pos : 0;
-	iov_iter_kvec(&iter, READ, &iov, 1, iov.iov_len);
+	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
 	ret = file->f_op->read_iter(&kiocb, &iter);
 	if (ret > 0) {
 		if (pos)
@@ -486,7 +486,7 @@ static ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = (ppos ? *ppos : 0);
-	iov_iter_ubuf(&iter, WRITE, (void __user *)buf, len);
+	iov_iter_ubuf(&iter, ITER_SOURCE, (void __user *)buf, len);
 
 	ret = call_write_iter(filp, &kiocb, &iter);
 	BUG_ON(ret == -EIOCBQUEUED);
@@ -533,7 +533,7 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 		.iov_len	= min_t(size_t, count, MAX_RW_COUNT),
 	};
 	struct iov_iter iter;
-	iov_iter_kvec(&iter, WRITE, &iov, 1, iov.iov_len);
+	iov_iter_kvec(&iter, ITER_SOURCE, &iov, 1, iov.iov_len);
 	return __kernel_write_iter(file, &iter, pos);
 }
 /*
@@ -911,7 +911,7 @@ static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	ret = import_iovec(ITER_DEST, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
 		kfree(iov);
@@ -928,7 +928,7 @@ static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = import_iovec(WRITE, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	ret = import_iovec(ITER_SOURCE, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret >= 0) {
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 9456a2032224..f5fdaf3b1572 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -156,7 +156,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, file);
-	iov_iter_init(&iter, READ, &iov, 1, size);
+	iov_iter_init(&iter, ITER_DEST, &iov, 1, size);
 
 	kiocb.ki_pos = *ppos;
 	ret = seq_read_iter(&kiocb, &iter);
diff --git a/fs/splice.c b/fs/splice.c
index 0878b852b355..5969b7a1d353 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -303,7 +303,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 	struct kiocb kiocb;
 	int ret;
 
-	iov_iter_pipe(&to, READ, pipe, len);
+	iov_iter_pipe(&to, ITER_DEST, pipe, len);
 	init_sync_kiocb(&kiocb, in);
 	kiocb.ki_pos = *ppos;
 	ret = call_read_iter(in, &kiocb, &to);
@@ -682,7 +682,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			n++;
 		}
 
-		iov_iter_bvec(&from, WRITE, array, n, sd.total_len - left);
+		iov_iter_bvec(&from, ITER_SOURCE, array, n, sd.total_len - left);
 		ret = vfs_iter_write(out, &from, &sd.pos, 0);
 		if (ret <= 0)
 			break;
@@ -1263,9 +1263,9 @@ static int vmsplice_type(struct fd f, int *type)
 	if (!f.file)
 		return -EBADF;
 	if (f.file->f_mode & FMODE_WRITE) {
-		*type = WRITE;
+		*type = ITER_SOURCE;
 	} else if (f.file->f_mode & FMODE_READ) {
-		*type = READ;
+		*type = ITER_DEST;
 	} else {
 		fdput(f);
 		return -EBADF;
@@ -1314,7 +1314,7 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 
 	if (!iov_iter_count(&iter))
 		error = 0;
-	else if (iov_iter_rw(&iter) == WRITE)
+	else if (type == ITER_SOURCE)
 		error = vmsplice_to_pipe(f.file, &iter, flags);
 	else
 		error = vmsplice_to_user(f.file, &iter, flags);
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index b3fdc8212c5f..95f8e8901768 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -183,7 +183,7 @@ static inline int squashfs_block_size(__le32 raw)
 #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
 					sizeof(u64))
 /* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
 #define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 1e90c2575f9b..0c1ae9789731 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -63,7 +63,7 @@ struct squashfs_sb_info {
 	long long				bytes_used;
 	unsigned int				inodes;
 	unsigned int				fragments;
-	int					xattr_ids;
+	unsigned int				xattr_ids;
 	unsigned int				ids;
 	bool					panic_on_errors;
 };
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index d8a270d3ac4c..f1a463d8bfa0 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -10,12 +10,12 @@
 
 #ifdef CONFIG_SQUASHFS_XATTR
 extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
-		u64 *, int *);
+		u64 *, unsigned int *);
 extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
 		unsigned int *, unsigned long long *);
 #else
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
-		u64 start, u64 *xattr_table_start, int *xattr_ids)
+		u64 start, u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_xattr_id_table *id_table;
 
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 087cab8c78f4..b88d19e9581e 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -56,7 +56,7 @@ int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
-		u64 *xattr_table_start, int *xattr_ids)
+		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	unsigned int len, indexes;
@@ -76,7 +76,7 @@ __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids == 0)
+	if (*xattr_ids <= 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
diff --git a/include/kunit/test.h b/include/kunit/test.h
index b1ab6b32216d..ebcdbddf8344 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -299,7 +299,6 @@ static inline int kunit_run_all_tests(void)
  */
 #define kunit_test_init_section_suites(__suites...)			\
 	__kunit_test_suites(CONCATENATE(__UNIQUE_ID(array), _probe),	\
-			    CONCATENATE(__UNIQUE_ID(suites), _probe),	\
 			    ##__suites)
 
 #define kunit_test_init_section_suite(suite)	\
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4aa1dbc7b064..4e1bfee9675d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -668,7 +668,8 @@ extern struct efi {
 
 #define EFI_RT_SUPPORTED_ALL					0x3fff
 
-#define EFI_RT_SUPPORTED_TIME_SERVICES				0x000f
+#define EFI_RT_SUPPORTED_TIME_SERVICES				0x0003
+#define EFI_RT_SUPPORTED_WAKEUP_SERVICES			0x000c
 #define EFI_RT_SUPPORTED_VARIABLE_SERVICES			0x0070
 
 extern struct mm_struct efi_mm;
diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 034b1106d022..e098f38422af 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -200,7 +200,7 @@ static inline void *kmap_local_pfn(unsigned long pfn)
 static inline void __kunmap_local(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
@@ -227,7 +227,7 @@ static inline void *kmap_atomic_pfn(unsigned long pfn)
 static inline void __kunmap_atomic(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 	pagefault_enable();
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8b4f93e84868..770650d1ff84 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/pgtable.h>
@@ -1182,6 +1183,18 @@ static inline __init void hugetlb_cma_reserve(int order)
 }
 #endif
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return page_count(virt_to_page(pte)) > 1;
+}
+#else
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return false;
+}
+#endif
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
 
 #ifndef __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1644a24009c..e03976302956 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1655,10 +1655,13 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 						  struct bdi_writeback *wb)
 {
+	struct mem_cgroup *memcg;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&folio_memcg(folio)->css != wb->memcg_css))
+	memcg = folio_memcg(folio);
+	if (unlikely(memcg && &memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
 }
 
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 50caa117cb62..bb15c9234e21 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -70,7 +70,6 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:	Write protect pin
  * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
@@ -85,7 +84,6 @@ struct nvmem_config {
 	const char		*name;
 	int			id;
 	struct module		*owner;
-	struct gpio_desc	*wp_gpio;
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	const struct nvmem_keepout *keepout;
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2e3134b14ffd..87fc3d0dda98 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -29,6 +29,9 @@ enum iter_type {
 	ITER_UBUF,
 };
 
+#define ITER_SOURCE	1	// == WRITE
+#define ITER_DEST	0	// == READ
+
 struct iov_iter_state {
 	size_t iov_offset;
 	size_t count;
diff --git a/include/linux/util_macros.h b/include/linux/util_macros.h
index 72299f261b25..43db6e47503c 100644
--- a/include/linux/util_macros.h
+++ b/include/linux/util_macros.h
@@ -38,4 +38,16 @@
  */
 #define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
 
+/**
+ * is_insidevar - check if the @ptr points inside the @var memory range.
+ * @ptr:	the pointer to a memory address.
+ * @var:	the variable which address and size identify the memory range.
+ *
+ * Evaluates to true if the address in @ptr lies within the memory
+ * range allocated to @var.
+ */
+#define is_insidevar(ptr, var)						\
+	((uintptr_t)(ptr) >= (uintptr_t)(var) &&			\
+	 (uintptr_t)(ptr) <  (uintptr_t)(var) + sizeof(var))
+
 #endif
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 654cc3918c94..7fb3cb787df4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -422,6 +422,8 @@ extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
 		    uint16_t, int, int, uint32_t, unsigned int);
+void iscsi_session_remove(struct iscsi_cls_session *cls_session);
+void iscsi_session_free(struct iscsi_cls_session *cls_session);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
diff --git a/io_uring/net.c b/io_uring/net.c
index 9046e269e5a5..520a73b5a448 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -364,7 +364,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	ret = import_single_range(ITER_SOURCE, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
 
@@ -450,7 +450,7 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 		}
 	} else {
 		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(READ, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
+		ret = __import_iovec(ITER_DEST, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
 				     &iomsg->free_iov, &iomsg->msg.msg_iter,
 				     false);
 		if (ret > 0)
@@ -503,7 +503,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		}
 	} else {
 		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(READ, (struct iovec __user *)uiov, msg.msg_iovlen,
+		ret = __import_iovec(ITER_DEST, (struct iovec __user *)uiov, msg.msg_iovlen,
 				   UIO_FASTIOV, &iomsg->free_iov,
 				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
@@ -763,7 +763,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 		kmsg->fast_iov[0].iov_base = buf;
 		kmsg->fast_iov[0].iov_len = len;
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
+		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, kmsg->fast_iov, 1,
 				len);
 	}
 
@@ -857,7 +857,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		sr->buf = buf;
 	}
 
-	ret = import_single_range(READ, sr->buf, len, &iov, &msg.msg_iter);
+	ret = import_single_range(ITER_DEST, sr->buf, len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -1097,13 +1097,13 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		return io_setup_async_addr(req, &__address, issue_flags);
 
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
-		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
+		ret = io_import_fixed(ITER_SOURCE, &msg.msg_iter, req->imu,
 					(u64)(uintptr_t)zc->buf, zc->len);
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter = io_sg_from_iter;
 	} else {
-		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
+		ret = import_single_range(ITER_SOURCE, zc->buf, zc->len, &iov,
 					  &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 6223472095d2..0218fae12edd 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -548,12 +548,12 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 
 int io_readv_prep_async(struct io_kiocb *req)
 {
-	return io_rw_prep_async(req, READ);
+	return io_rw_prep_async(req, ITER_DEST);
 }
 
 int io_writev_prep_async(struct io_kiocb *req)
 {
-	return io_rw_prep_async(req, WRITE);
+	return io_rw_prep_async(req, ITER_SOURCE);
 }
 
 /*
@@ -704,7 +704,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	loff_t *ppos;
 
 	if (!req_has_async_data(req)) {
-		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
+		ret = io_import_iovec(ITER_DEST, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
@@ -716,7 +716,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * buffers, as we dropped the selected one before retry.
 		 */
 		if (io_do_buffer_select(req)) {
-			ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
+			ret = io_import_iovec(ITER_DEST, req, &iovec, s, issue_flags);
 			if (unlikely(ret < 0))
 				return ret;
 		}
@@ -851,7 +851,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	loff_t *ppos;
 
 	if (!req_has_async_data(req)) {
-		ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
+		ret = io_import_iovec(ITER_SOURCE, req, &iovec, s, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index d6c9b3705f24..e6a76da4bca7 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -51,7 +51,6 @@ BTF_SET_END(bpf_lsm_current_hooks)
  */
 BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
 #ifdef CONFIG_SECURITY_NETWORK
-BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
 BTF_ID(func, bpf_lsm_sock_graft)
 BTF_ID(func, bpf_lsm_inet_csk_clone)
 BTF_ID(func, bpf_lsm_inet_conn_established)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index efdbba2a0230..a7c2f0c3fc19 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7607,9 +7607,9 @@ int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_c
 
 	sort(tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func, NULL);
 
-	return 0;
 end:
-	btf_free_dtor_kfunc_tab(btf);
+	if (ret)
+		btf_free_dtor_kfunc_tab(btf);
 	btf_put(btf);
 	return ret;
 }
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 4901fa1048cd..6187c28d266f 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -71,7 +71,7 @@ static int bpf_mem_cache_idx(size_t size)
 	if (size <= 192)
 		return size_index[(size - 1) / 8] - 1;
 
-	return fls(size - 1) - 1;
+	return fls(size - 1) - 2;
 }
 
 #define NUM_CACHES 11
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 398a0008aff7..ea21e008bf85 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2664,6 +2664,12 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 		if (opcode == BPF_CALL) {
 			if (insn->src_reg == BPF_PSEUDO_CALL)
 				return -ENOTSUPP;
+			/* kfunc with imm==0 is invalid and fixup_kfunc_call will
+			 * catch this error later. Make backtracking conservative
+			 * with ENOTSUPP.
+			 */
+			if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL && insn->imm == 0)
+				return -ENOTSUPP;
 			/* regular helper call sets R0 */
 			*reg_mask &= ~1;
 			if (*reg_mask & 0x3f) {
@@ -3011,13 +3017,24 @@ static bool __is_pointer_value(bool allow_ptr_leaks,
 	return reg->type != SCALAR_VALUE;
 }
 
+/* Copy src state preserving dst->parent and dst->live fields */
+static void copy_register_state(struct bpf_reg_state *dst, const struct bpf_reg_state *src)
+{
+	struct bpf_reg_state *parent = dst->parent;
+	enum bpf_reg_liveness live = dst->live;
+
+	*dst = *src;
+	dst->parent = parent;
+	dst->live = live;
+}
+
 static void save_register_state(struct bpf_func_state *state,
 				int spi, struct bpf_reg_state *reg,
 				int size)
 {
 	int i;
 
-	state->stack[spi].spilled_ptr = *reg;
+	copy_register_state(&state->stack[spi].spilled_ptr, reg);
 	if (size == BPF_REG_SIZE)
 		state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
 
@@ -3345,7 +3362,7 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 				 */
 				s32 subreg_def = state->regs[dst_regno].subreg_def;
 
-				state->regs[dst_regno] = *reg;
+				copy_register_state(&state->regs[dst_regno], reg);
 				state->regs[dst_regno].subreg_def = subreg_def;
 			} else {
 				for (i = 0; i < size; i++) {
@@ -3366,7 +3383,7 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 
 		if (dst_regno >= 0) {
 			/* restore register state from stack */
-			state->regs[dst_regno] = *reg;
+			copy_register_state(&state->regs[dst_regno], reg);
 			/* mark reg as written since spilled pointer state likely
 			 * has its liveness marks cleared by is_state_visited()
 			 * which resets stack/reg liveness for state transitions
@@ -8085,7 +8102,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	 */
 	if (!ptr_is_dst_reg) {
 		tmp = *dst_reg;
-		*dst_reg = *ptr_reg;
+		copy_register_state(dst_reg, ptr_reg);
 	}
 	ret = sanitize_speculative_path(env, NULL, env->insn_idx + 1,
 					env->insn_idx);
@@ -9338,7 +9355,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 					 * to propagate min/max range.
 					 */
 					src_reg->id = ++env->id_gen;
-				*dst_reg = *src_reg;
+				copy_register_state(dst_reg, src_reg);
 				dst_reg->live |= REG_LIVE_WRITTEN;
 				dst_reg->subreg_def = DEF_NOT_SUBREG;
 			} else {
@@ -9349,7 +9366,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 						insn->src_reg);
 					return -EACCES;
 				} else if (src_reg->type == SCALAR_VALUE) {
-					*dst_reg = *src_reg;
+					copy_register_state(dst_reg, src_reg);
 					/* Make sure ID is cleared otherwise
 					 * dst_reg min/max could be incorrectly
 					 * propagated into src_reg by find_equal_scalars()
@@ -10145,7 +10162,7 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 
 	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
 		if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
-			*reg = *known_reg;
+			copy_register_state(reg, known_reg);
 	}));
 }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..a753adcbc7c7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1342,7 +1342,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
 		 */
-		if (!cpumask_intersects(cs->cpus_allowed, parent->effective_cpus) &&
+		if (cpumask_subset(parent->effective_cpus, cs->cpus_allowed) &&
 		    partition_is_populated(parent, cs))
 			return PERR_NOCPUS;
 
@@ -2320,6 +2320,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		new_prs = -new_prs;
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
+	WRITE_ONCE(cs->prs_err, err);
 	spin_unlock_irq(&callback_lock);
 	/*
 	 * Update child cpusets, if present.
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8fe1da9614ee..e2096b51c004 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1915,7 +1915,7 @@ static void debugfs_add_domain_dir(struct irq_domain *d)
 
 static void debugfs_remove_domain_dir(struct irq_domain *d)
 {
-	debugfs_remove(debugfs_lookup(d->name, domain_dir));
+	debugfs_lookup_and_remove(d->name, domain_dir);
 }
 
 void __init irq_domain_debugfs_init(struct dentry *root)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index eb8c117cc8b6..9d4163abadf4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -832,6 +832,7 @@ static void do_bpf_send_signal(struct irq_work *entry)
 
 	work = container_of(entry, struct send_signal_irq_work, irq_work);
 	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, work->type);
+	put_task_struct(work->task);
 }
 
 static int bpf_send_signal_common(u32 sig, enum pid_type type)
@@ -866,7 +867,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		 * to the irq_work. The current task may change when queued
 		 * irq works get executed.
 		 */
-		work->task = current;
+		work->task = get_task_struct(current);
 		work->sig = sig;
 		work->type = type;
 		irq_work_queue(&work->irq_work);
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 9cb53182bb31..908e8a13c675 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1489,7 +1489,7 @@ static ssize_t user_events_write(struct file *file, const char __user *ubuf,
 	if (unlikely(*ppos != 0))
 		return -EFAULT;
 
-	if (unlikely(import_single_range(WRITE, (char __user *)ubuf,
+	if (unlikely(import_single_range(ITER_SOURCE, (char __user *)ubuf,
 					 count, &iov, &i)))
 		return -EFAULT;
 
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fe21bf276d91..69cb44b035ec 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -665,12 +665,13 @@ static inline unsigned long mte_pivot(const struct maple_enode *mn,
 				 unsigned char piv)
 {
 	struct maple_node *node = mte_to_node(mn);
+	enum maple_type type = mte_node_type(mn);
 
-	if (piv >= mt_pivots[piv]) {
+	if (piv >= mt_pivots[type]) {
 		WARN_ON(1);
 		return 0;
 	}
-	switch (mte_node_type(mn)) {
+	switch (type) {
 	case maple_arange_64:
 		return node->ma64.pivot[piv];
 	case maple_range_64:
@@ -4882,7 +4883,7 @@ static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
 	unsigned long *pivots, *gaps;
 	void __rcu **slots;
 	unsigned long gap = 0;
-	unsigned long max, min, index;
+	unsigned long max, min;
 	unsigned char offset;
 
 	if (unlikely(mas_is_err(mas)))
@@ -4904,8 +4905,7 @@ static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
 		min = mas_safe_min(mas, pivots, --offset);
 
 	max = mas_safe_pivot(mas, pivots, offset, type);
-	index = mas->index;
-	while (index <= max) {
+	while (mas->index <= max) {
 		gap = 0;
 		if (gaps)
 			gap = gaps[offset];
@@ -4936,10 +4936,8 @@ static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
 		min = mas_safe_min(mas, pivots, offset);
 	}
 
-	if (unlikely(index > max)) {
-		mas_set_err(mas, -EBUSY);
-		return false;
-	}
+	if (unlikely((mas->index > max) || (size - 1 > max - mas->index)))
+		goto no_space;
 
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset = offset;
@@ -4956,9 +4954,11 @@ static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
 	return false;
 
 ascend:
-	if (mte_is_root(mas->node))
-		mas_set_err(mas, -EBUSY);
+	if (!mte_is_root(mas->node))
+		return false;
 
+no_space:
+	mas_set_err(mas, -EBUSY);
 	return false;
 }
 
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 497fc93ccf9e..ec847bf4dcb4 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2517,6 +2517,91 @@ static noinline void check_bnode_min_spanning(struct maple_tree *mt)
 	mt_set_non_kernel(0);
 }
 
+static noinline void check_empty_area_window(struct maple_tree *mt)
+{
+	unsigned long i, nr_entries = 20;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 1; i <= nr_entries; i++)
+		mtree_store_range(mt, i*10, i*10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	/* Create another hole besides the one at 0 */
+	mtree_store_range(mt, 160, 169, NULL, GFP_KERNEL);
+
+	/* Check lower bounds that don't fit */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 10) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 6, 90, 5) != -EBUSY);
+
+	/* Check lower bound that does fit */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 5) != 0);
+	MT_BUG_ON(mt, mas.index != 5);
+	MT_BUG_ON(mt, mas.last != 9);
+	rcu_read_unlock();
+
+	/* Check one gap that doesn't fit and one that does */
+	rcu_read_lock();
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 217, 9) != 0);
+	MT_BUG_ON(mt, mas.index != 161);
+	MT_BUG_ON(mt, mas.last != 169);
+
+	/* Check one gap that does fit above the min */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 3) != 0);
+	MT_BUG_ON(mt, mas.index != 216);
+	MT_BUG_ON(mt, mas.last != 218);
+
+	/* Check size that doesn't fit any gap */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 16) != -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the lower end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 167, 200, 4) != -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the upper end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 162, 4) != -EBUSY);
+
+	/* Check mas_empty_area forward */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 9) != 0);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 8);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 4) != 0);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 11) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 5, 100, 6) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 8, 10) != -EBUSY);
+
+	mas_reset(&mas);
+	mas_empty_area(&mas, 100, 165, 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 100, 163, 6) != -EBUSY);
+	rcu_read_unlock();
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2765,6 +2850,10 @@ static int maple_tree_seed(void)
 	check_bnode_min_spanning(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_window(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c982b250aa31..e0c7bbd69b33 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -847,6 +847,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	return SCAN_SUCCEED;
 }
 
+/*
+ * See pmd_trans_unstable() for how the result may change out from
+ * underneath us, even if we hold mmap_lock in read.
+ */
 static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 				   unsigned long address,
 				   pmd_t **pmd)
@@ -865,8 +869,12 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 #endif
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
+	if (!pmd_present(pmde))
+		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
+	if (pmd_devmap(pmde))
+		return SCAN_PMD_NULL;
 	if (pmd_bad(pmde))
 		return SCAN_PMD_NULL;
 	return SCAN_SUCCEED;
@@ -1649,7 +1657,7 @@ static int retract_page_tables(struct address_space *mapping, pgoff_t pgoff,
 		 * has higher cost too. It would also probably require locking
 		 * the anon_vma.
 		 */
-		if (vma->anon_vma) {
+		if (READ_ONCE(vma->anon_vma)) {
 			result = SCAN_PAGE_ANON;
 			goto next;
 		}
@@ -1677,6 +1685,18 @@ static int retract_page_tables(struct address_space *mapping, pgoff_t pgoff,
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
+			/*
+			 * Re-check whether we have an ->anon_vma, because
+			 * collapse_and_free_pmd() requires that either no
+			 * ->anon_vma exists or the anon_vma is locked.
+			 * We already checked ->anon_vma above, but that check
+			 * is racy because ->anon_vma can be populated under the
+			 * mmap lock in read mode.
+			 */
+			if (vma->anon_vma) {
+				result = SCAN_PAGE_ANON;
+				goto unlock_next;
+			}
 			/*
 			 * When a vma is registered with uffd-wp, we can't
 			 * recycle the pmd pgtable because there can be pte
diff --git a/mm/madvise.c b/mm/madvise.c
index b913ba6efc10..d03e149ffe6e 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1459,7 +1459,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 		goto out;
 	}
 
-	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	ret = import_iovec(ITER_DEST, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret < 0)
 		goto out;
 
diff --git a/mm/memory.c b/mm/memory.c
index 8c8420934d60..f6f93e5b6b02 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -875,12 +875,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
-		/*
-		 * We're copying the pgtable should only because dst_vma has
-		 * uffd-wp enabled, do sanity check.
-		 */
-		WARN_ON_ONCE(!userfaultfd_wp(dst_vma));
-		set_pte_at(dst_mm, addr, dst_pte, pte);
+		if (userfaultfd_wp(dst_vma))
+			set_pte_at(dst_mm, addr, dst_pte, pte);
 		return 0;
 	}
 	if (!userfaultfd_wp(dst_vma))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 02c8a712282f..f940395667c8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
diff --git a/mm/mremap.c b/mm/mremap.c
index fe587c5d6591..930f65c315c0 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1027,16 +1027,29 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			}
 
 			/*
-			 * Function vma_merge() is called on the extension we are adding to
-			 * the already existing vma, vma_merge() will merge this extension with
-			 * the already existing vma (expand operation itself) and possibly also
-			 * with the next vma if it becomes adjacent to the expanded vma and
-			 * otherwise compatible.
+			 * Function vma_merge() is called on the extension we
+			 * are adding to the already existing vma, vma_merge()
+			 * will merge this extension with the already existing
+			 * vma (expand operation itself) and possibly also with
+			 * the next vma if it becomes adjacent to the expanded
+			 * vma and  otherwise compatible.
+			 *
+			 * However, vma_merge() can currently fail due to
+			 * is_mergeable_vma() check for vm_ops->close (see the
+			 * comment there). Yet this should not prevent vma
+			 * expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done
+			 * when a vma would be actually removed due to a merge.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
+			if (!vma->vm_ops || !vma->vm_ops->close) {
+				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
+				   vma->vm_pgoff, NULL)) {
+				vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
diff --git a/mm/page_io.c b/mm/page_io.c
index 2af34dd8fa4d..3a5f921b932e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -376,7 +376,7 @@ void swap_write_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, WRITE, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -530,7 +530,7 @@ void __swap_read_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, READ, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 4bcc11958089..78dfaf9e8990 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -263,7 +263,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	struct iovec *iov_r;
 	struct iov_iter iter;
 	ssize_t rc;
-	int dir = vm_write ? WRITE : READ;
+	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
 
 	if (flags != 0)
 		return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 72e481aacd5d..b72908df52ac 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1101,6 +1101,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
+		cond_resched();
 
 		spin_lock(&swap_avail_lock);
 nextsi:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8fcc5fa768c0..96eb9da372cd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3290,13 +3290,16 @@ void lru_gen_migrate_mm(struct mm_struct *mm)
 	if (mem_cgroup_disabled())
 		return;
 
+	/* migration can happen before addition */
+	if (!mm->lru_gen.memcg)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(task);
 	rcu_read_unlock();
 	if (memcg == mm->lru_gen.memcg)
 		return;
 
-	VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
 	VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
 
 	lru_gen_del_mm(mm);
diff --git a/net/9p/client.c b/net/9p/client.c
index b5aa25f82b78..554a4b11f4fe 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -2049,7 +2049,7 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 	struct kvec kv = {.iov_base = data, .iov_len = count};
 	struct iov_iter to;
 
-	iov_iter_kvec(&to, READ, &kv, 1, count);
+	iov_iter_kvec(&to, ITER_DEST, &kv, 1, count);
 
 	p9_debug(P9_DEBUG_9P, ">>> TREADDIR fid %d offset %llu count %d\n",
 		 fid->fid, offset, count);
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index c57d643afb10..4eb1b3ced0d2 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -441,7 +441,7 @@ static int send_pkt(struct l2cap_chan *chan, struct sk_buff *skb,
 	iv.iov_len = skb->len;
 
 	memset(&msg, 0, sizeof(msg));
-	iov_iter_kvec(&msg.msg_iter, WRITE, &iv, 1, skb->len);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iv, 1, skb->len);
 
 	err = l2cap_chan_send(chan, &msg, skb->len);
 	if (err > 0) {
diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index 1fcc482397c3..e7adb8a98cf9 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -56,7 +56,7 @@ static void a2mp_send(struct amp_mgr *mgr, u8 code, u8 ident, u16 len, void *dat
 
 	memset(&msg, 0, sizeof(msg));
 
-	iov_iter_kvec(&msg.msg_iter, WRITE, &iv, 1, total_len);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iv, 1, total_len);
 
 	l2cap_chan_send(chan, &msg, total_len);
 
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 11f853d0500f..70663229b3cc 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -605,7 +605,7 @@ static void smp_send_cmd(struct l2cap_conn *conn, u8 code, u16 len, void *data)
 
 	memset(&msg, 0, sizeof(msg));
 
-	iov_iter_kvec(&msg.msg_iter, WRITE, iv, 2, 1 + len);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, iv, 2, 1 + len);
 
 	l2cap_chan_send(chan, &msg, 1 + len);
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..9554abcfd5b4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -871,6 +871,7 @@ static unsigned int ip_sabotage_in(void *priv,
 	if (nf_bridge && !nf_bridge->in_prerouting &&
 	    !netif_is_l3_master(skb->dev) &&
 	    !netif_is_l3_slave(skb->dev)) {
+		nf_bridge_info_free(skb);
 		state->okfn(state->net, state->sk, skb);
 		return NF_STOLEN;
 	}
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 608f8c24ae46..fc81d77724a1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -140,7 +140,7 @@ struct isotp_sock {
 	canid_t rxid;
 	ktime_t tx_gap;
 	ktime_t lastrxcf_tstamp;
-	struct hrtimer rxtimer, txtimer;
+	struct hrtimer rxtimer, txtimer, txfrtimer;
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
@@ -871,7 +871,7 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 	}
 
 	/* start timer to send next consecutive frame with correct delay */
-	hrtimer_start(&so->txtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
+	hrtimer_start(&so->txfrtimer, so->tx_gap, HRTIMER_MODE_REL_SOFT);
 }
 
 static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
@@ -879,49 +879,39 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
 					     txtimer);
 	struct sock *sk = &so->sk;
-	enum hrtimer_restart restart = HRTIMER_NORESTART;
 
-	switch (so->tx.state) {
-	case ISOTP_SENDING:
-
-		/* cfecho should be consumed by isotp_rcv_echo() here */
-		if (!so->cfecho) {
-			/* start timeout for unlikely lost echo skb */
-			hrtimer_set_expires(&so->txtimer,
-					    ktime_add(ktime_get(),
-						      ktime_set(ISOTP_ECHO_TIMEOUT, 0)));
-			restart = HRTIMER_RESTART;
+	/* don't handle timeouts in IDLE state */
+	if (so->tx.state == ISOTP_IDLE)
+		return HRTIMER_NORESTART;
 
-			/* push out the next consecutive frame */
-			isotp_send_cframe(so);
-			break;
-		}
+	/* we did not get any flow control or echo frame in time */
 
-		/* cfecho has not been cleared in isotp_rcv_echo() */
-		pr_notice_once("can-isotp: cfecho %08X timeout\n", so->cfecho);
-		fallthrough;
+	/* report 'communication error on send' */
+	sk->sk_err = ECOMM;
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk_error_report(sk);
 
-	case ISOTP_WAIT_FC:
-	case ISOTP_WAIT_FIRST_FC:
+	/* reset tx state */
+	so->tx.state = ISOTP_IDLE;
+	wake_up_interruptible(&so->wait);
 
-		/* we did not get any flow control frame in time */
+	return HRTIMER_NORESTART;
+}
 
-		/* report 'communication error on send' */
-		sk->sk_err = ECOMM;
-		if (!sock_flag(sk, SOCK_DEAD))
-			sk_error_report(sk);
+static enum hrtimer_restart isotp_txfr_timer_handler(struct hrtimer *hrtimer)
+{
+	struct isotp_sock *so = container_of(hrtimer, struct isotp_sock,
+					     txfrtimer);
 
-		/* reset tx state */
-		so->tx.state = ISOTP_IDLE;
-		wake_up_interruptible(&so->wait);
-		break;
+	/* start echo timeout handling and cover below protocol error */
+	hrtimer_start(&so->txtimer, ktime_set(ISOTP_ECHO_TIMEOUT, 0),
+		      HRTIMER_MODE_REL_SOFT);
 
-	default:
-		WARN_ONCE(1, "can-isotp: tx timer state %08X cfecho %08X\n",
-			  so->tx.state, so->cfecho);
-	}
+	/* cfecho should be consumed by isotp_rcv_echo() here */
+	if (so->tx.state == ISOTP_SENDING && !so->cfecho)
+		isotp_send_cframe(so);
 
-	return restart;
+	return HRTIMER_NORESTART;
 }
 
 static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -1162,6 +1152,10 @@ static int isotp_release(struct socket *sock)
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occurred */
+	so->tx.state = ISOTP_IDLE;
+	so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);
@@ -1194,6 +1188,7 @@ static int isotp_release(struct socket *sock)
 		}
 	}
 
+	hrtimer_cancel(&so->txfrtimer);
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);
 
@@ -1597,6 +1592,8 @@ static int isotp_init(struct sock *sk)
 	so->rxtimer.function = isotp_rx_timer_handler;
 	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
 	so->txtimer.function = isotp_tx_timer_handler;
+	hrtimer_init(&so->txfrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
+	so->txfrtimer.function = isotp_txfr_timer_handler;
 
 	init_waitqueue_head(&so->wait);
 	spin_lock_init(&so->rx_lock);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 55f29c9f9e08..4177e9617070 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1092,10 +1092,6 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	bool active;
 
 	j1939_session_list_lock(priv);
-	/* This function should be called with a session ref-count of at
-	 * least 2.
-	 */
-	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(priv);
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 3eb7d3e2b541..4abab2c3011a 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -132,8 +132,8 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		return;
 
 	/* make sure to not pass oversized frames to the socket */
-	if ((can_is_canfd_skb(oskb) && !ro->fd_frames && !ro->xl_frames) ||
-	    (can_is_canxl_skb(oskb) && !ro->xl_frames))
+	if ((!ro->fd_frames && can_is_canfd_skb(oskb)) ||
+	    (!ro->xl_frames && can_is_canxl_skb(oskb)))
 		return;
 
 	/* eliminate multiple filter matches for the same skb */
@@ -670,6 +670,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->fd_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames && !ro->fd_frames) {
+			ro->fd_frames = ro->xl_frames;
+			return -EINVAL;
+		}
 		break;
 
 	case CAN_RAW_XL_FRAMES:
@@ -679,6 +684,9 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->xl_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames)
+			ro->fd_frames = ro->xl_frames;
 		break;
 
 	case CAN_RAW_JOIN_FILTERS:
@@ -786,6 +794,25 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 	return 0;
 }
 
+static bool raw_bad_txframe(struct raw_sock *ro, struct sk_buff *skb, int mtu)
+{
+	/* Classical CAN -> no checks for flags and device capabilities */
+	if (can_is_can_skb(skb))
+		return false;
+
+	/* CAN FD -> needs to be enabled and a CAN FD or CAN XL device */
+	if (ro->fd_frames && can_is_canfd_skb(skb) &&
+	    (mtu == CANFD_MTU || can_is_canxl_dev_mtu(mtu)))
+		return false;
+
+	/* CAN XL -> needs to be enabled and a CAN XL device */
+	if (ro->xl_frames && can_is_canxl_skb(skb) &&
+	    can_is_canxl_dev_mtu(mtu))
+		return false;
+
+	return true;
+}
+
 static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
@@ -833,20 +860,8 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		goto free_skb;
 
 	err = -EINVAL;
-	if (ro->xl_frames && can_is_canxl_dev_mtu(dev->mtu)) {
-		/* CAN XL, CAN FD and Classical CAN */
-		if (!can_is_canxl_skb(skb) && !can_is_canfd_skb(skb) &&
-		    !can_is_can_skb(skb))
-			goto free_skb;
-	} else if (ro->fd_frames && dev->mtu == CANFD_MTU) {
-		/* CAN FD and Classical CAN */
-		if (!can_is_canfd_skb(skb) && !can_is_can_skb(skb))
-			goto free_skb;
-	} else {
-		/* Classical CAN */
-		if (!can_is_can_skb(skb))
-			goto free_skb;
-	}
+	if (raw_bad_txframe(ro, skb, dev->mtu))
+		goto free_skb;
 
 	sockcm_init(&sockc, sk);
 	if (msg->msg_controllen) {
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 3ddbde87e4d6..d1787d7d33ef 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -30,7 +30,7 @@ static int ceph_tcp_recvmsg(struct socket *sock, void *buf, size_t len)
 	if (!buf)
 		msg.msg_flags |= MSG_TRUNC;
 
-	iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, len);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, len);
 	r = sock_recvmsg(sock, &msg, msg.msg_flags);
 	if (r == -EAGAIN)
 		r = 0;
@@ -49,7 +49,7 @@ static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
 	int r;
 
 	BUG_ON(page_offset + length > PAGE_SIZE);
-	iov_iter_bvec(&msg.msg_iter, READ, &bvec, 1, length);
+	iov_iter_bvec(&msg.msg_iter, ITER_DEST, &bvec, 1, length);
 	r = sock_recvmsg(sock, &msg, msg.msg_flags);
 	if (r == -EAGAIN)
 		r = 0;
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index cc8ff81a50b7..3009028c4fa2 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -168,7 +168,7 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
 						  bv.bv_offset, bv.bv_len,
 						  CEPH_MSG_FLAGS);
 		} else {
-			iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, bv.bv_len);
+			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, bv.bv_len);
 			ret = sock_sendmsg(sock, &msg);
 		}
 		if (ret <= 0) {
@@ -225,7 +225,7 @@ static void reset_in_kvecs(struct ceph_connection *con)
 	WARN_ON(iov_iter_count(&con->v2.in_iter));
 
 	con->v2.in_kvec_cnt = 0;
-	iov_iter_kvec(&con->v2.in_iter, READ, con->v2.in_kvecs, 0, 0);
+	iov_iter_kvec(&con->v2.in_iter, ITER_DEST, con->v2.in_kvecs, 0, 0);
 }
 
 static void set_in_bvec(struct ceph_connection *con, const struct bio_vec *bv)
@@ -233,7 +233,7 @@ static void set_in_bvec(struct ceph_connection *con, const struct bio_vec *bv)
 	WARN_ON(iov_iter_count(&con->v2.in_iter));
 
 	con->v2.in_bvec = *bv;
-	iov_iter_bvec(&con->v2.in_iter, READ, &con->v2.in_bvec, 1, bv->bv_len);
+	iov_iter_bvec(&con->v2.in_iter, ITER_DEST, &con->v2.in_bvec, 1, bv->bv_len);
 }
 
 static void set_in_skip(struct ceph_connection *con, int len)
@@ -241,7 +241,7 @@ static void set_in_skip(struct ceph_connection *con, int len)
 	WARN_ON(iov_iter_count(&con->v2.in_iter));
 
 	dout("%s con %p len %d\n", __func__, con, len);
-	iov_iter_discard(&con->v2.in_iter, READ, len);
+	iov_iter_discard(&con->v2.in_iter, ITER_DEST, len);
 }
 
 static void add_out_kvec(struct ceph_connection *con, void *buf, int len)
@@ -265,7 +265,7 @@ static void reset_out_kvecs(struct ceph_connection *con)
 
 	con->v2.out_kvec_cnt = 0;
 
-	iov_iter_kvec(&con->v2.out_iter, WRITE, con->v2.out_kvecs, 0, 0);
+	iov_iter_kvec(&con->v2.out_iter, ITER_SOURCE, con->v2.out_kvecs, 0, 0);
 	con->v2.out_iter_sendpage = false;
 }
 
@@ -277,7 +277,7 @@ static void set_out_bvec(struct ceph_connection *con, const struct bio_vec *bv,
 
 	con->v2.out_bvec = *bv;
 	con->v2.out_iter_sendpage = zerocopy;
-	iov_iter_bvec(&con->v2.out_iter, WRITE, &con->v2.out_bvec, 1,
+	iov_iter_bvec(&con->v2.out_iter, ITER_SOURCE, &con->v2.out_bvec, 1,
 		      con->v2.out_bvec.bv_len);
 }
 
@@ -290,7 +290,7 @@ static void set_out_bvec_zero(struct ceph_connection *con)
 	con->v2.out_bvec.bv_offset = 0;
 	con->v2.out_bvec.bv_len = min(con->v2.out_zero, (int)PAGE_SIZE);
 	con->v2.out_iter_sendpage = true;
-	iov_iter_bvec(&con->v2.out_iter, WRITE, &con->v2.out_bvec, 1,
+	iov_iter_bvec(&con->v2.out_iter, ITER_SOURCE, &con->v2.out_bvec, 1,
 		      con->v2.out_bvec.bv_len);
 }
 
diff --git a/net/compat.c b/net/compat.c
index 385f04a6be2f..161b7bea1f62 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -95,7 +95,8 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	if (err)
 		return err;
 
-	err = import_iovec(save_addr ? READ : WRITE, compat_ptr(msg.msg_iov), msg.msg_iovlen,
+	err = import_iovec(save_addr ? ITER_DEST : ITER_SOURCE,
+			   compat_ptr(msg.msg_iov), msg.msg_iovlen,
 			   UIO_FASTIOV, iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
diff --git a/net/core/gro.c b/net/core/gro.c
index 1b4abfb9a7a1..352f966cb1da 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
 
+	/* Do not splice page pool based packets w/ non-page pool
+	 * packets. This can result in reference count issues as page
+	 * pool pages will not decrement the reference count and will
+	 * instead be immediately returned to the pool or have frag
+	 * count decremented.
+	 */
+	if (p->pp_recycle != skb->pp_recycle)
+		return -ETOOMANYREFS;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ec19ed722453..6667c3538f2a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2001,7 +2001,7 @@ static int receive_fallback_to_copy(struct sock *sk,
 	if (copy_address != zc->copybuf_address)
 		return -EINVAL;
 
-	err = import_single_range(READ, (void __user *)copy_address,
+	err = import_single_range(ITER_DEST, (void __user *)copy_address,
 				  inq, &iov, &msg.msg_iter);
 	if (err)
 		return err;
@@ -2035,7 +2035,7 @@ static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 	if (copy_address != zc->copybuf_address)
 		return -EINVAL;
 
-	err = import_single_range(READ, (void __user *)copy_address,
+	err = import_single_range(ITER_DEST, (void __user *)copy_address,
 				  copylen, &iov, &msg.msg_iter);
 	if (err)
 		return err;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 94aad3870c5f..cf26d65ca389 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -6,6 +6,7 @@
 #include <linux/bpf.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/util_macros.h>
 
 #include <net/inet_common.h>
 #include <net/tls.h>
@@ -639,10 +640,9 @@ EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
  */
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	struct proto *prot = newsk->sk_prot;
 
-	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
+	if (is_insidevar(prot, tcp_bpf_prots))
 		newsk->sk_prot = sk->sk_prot_creator;
 }
 #endif /* CONFIG_BPF_SYSCALL */
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9c3f5202a97b..e6c7edcf6834 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3127,17 +3127,17 @@ static void add_v4_addrs(struct inet6_dev *idev)
 		offset = sizeof(struct in6_addr) - 4;
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
-	if (idev->dev->flags&IFF_POINTOPOINT) {
+	if (!(idev->dev->flags & IFF_POINTOPOINT) && idev->dev->type == ARPHRD_SIT) {
+		scope = IPV6_ADDR_COMPATv4;
+		plen = 96;
+		pflags |= RTF_NONEXTHOP;
+	} else {
 		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
 			return;
 
 		addr.s6_addr32[0] = htonl(0xfe800000);
 		scope = IFA_LINK;
 		plen = 64;
-	} else {
-		scope = IPV6_ADDR_COMPATv4;
-		plen = 96;
-		pflags |= RTF_NONEXTHOP;
 	}
 
 	if (addr.s6_addr32[3]) {
@@ -3447,6 +3447,30 @@ static void addrconf_gre_config(struct net_device *dev)
 }
 #endif
 
+static void addrconf_init_auto_addrs(struct net_device *dev)
+{
+	switch (dev->type) {
+#if IS_ENABLED(CONFIG_IPV6_SIT)
+	case ARPHRD_SIT:
+		addrconf_sit_config(dev);
+		break;
+#endif
+#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
+	case ARPHRD_IP6GRE:
+	case ARPHRD_IPGRE:
+		addrconf_gre_config(dev);
+		break;
+#endif
+	case ARPHRD_LOOPBACK:
+		init_loopback(dev);
+		break;
+
+	default:
+		addrconf_dev_config(dev);
+		break;
+	}
+}
+
 static int fixup_permanent_addr(struct net *net,
 				struct inet6_dev *idev,
 				struct inet6_ifaddr *ifp)
@@ -3615,26 +3639,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			run_pending = 1;
 		}
 
-		switch (dev->type) {
-#if IS_ENABLED(CONFIG_IPV6_SIT)
-		case ARPHRD_SIT:
-			addrconf_sit_config(dev);
-			break;
-#endif
-#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
-		case ARPHRD_IP6GRE:
-		case ARPHRD_IPGRE:
-			addrconf_gre_config(dev);
-			break;
-#endif
-		case ARPHRD_LOOPBACK:
-			init_loopback(dev);
-			break;
-
-		default:
-			addrconf_dev_config(dev);
-			break;
-		}
+		addrconf_init_auto_addrs(dev);
 
 		if (!IS_ERR_OR_NULL(idev)) {
 			if (run_pending)
@@ -6397,7 +6402,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl_table *ctl, int write,
 
 			if (idev->cnf.addr_gen_mode != new_val) {
 				idev->cnf.addr_gen_mode = new_val;
-				addrconf_dev_config(idev->dev);
+				addrconf_init_auto_addrs(idev->dev);
 			}
 		} else if (&net->ipv6.devconf_all->addr_gen_mode == ctl->data) {
 			struct net_device *dev;
@@ -6408,7 +6413,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl_table *ctl, int write,
 				if (idev &&
 				    idev->cnf.addr_gen_mode != new_val) {
 					idev->cnf.addr_gen_mode = new_val;
-					addrconf_dev_config(idev->dev);
+					addrconf_init_auto_addrs(idev->dev);
 				}
 			}
 		}
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index a56fd0b5a430..4963fec815da 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1617,7 +1617,7 @@ ip_vs_receive(struct socket *sock, char *buffer, const size_t buflen)
 	EnterFunction(7);
 
 	/* Receive a packet */
-	iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, buflen);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, buflen);
 	len = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
 	if (len < 0)
 		return len;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6f7f4392cffb..5a4cb796150f 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -400,6 +400,11 @@ static int nr_listen(struct socket *sock, int backlog)
 	struct sock *sk = sock->sk;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&nr_sk(sk)->user_addr, 0, AX25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fa0f1952d763..5920fdca1287 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -979,14 +979,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key) {
 		error = -ENOMEM;
-		goto err_kfree_key;
+		goto err_kfree_flow;
 	}
 
 	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
 
@@ -994,14 +994,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
 				       key, log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
 	if (error) {
 		OVS_NLERR(log, "Flow actions may not be safe on all matching packets.");
-		goto err_kfree_flow;
+		goto err_kfree_key;
 	}
 
 	reply = ovs_flow_cmd_alloc_info(acts, &new_flow->id, info, false,
@@ -1101,10 +1101,10 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	kfree_skb(reply);
 err_kfree_acts:
 	ovs_nla_free_flow_actions(acts);
-err_kfree_flow:
-	ovs_flow_free(new_flow, false);
 err_kfree_key:
 	kfree(key);
+err_kfree_flow:
+	ovs_flow_free(new_flow, false);
 error:
 	return error;
 }
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 1990d496fcfc..e595079c2caf 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -83,7 +83,10 @@ static struct qrtr_node *node_get(unsigned int node_id)
 
 	node->id = node_id;
 
-	radix_tree_insert(&nodes, node_id, node);
+	if (radix_tree_insert(&nodes, node_id, node)) {
+		kfree(node);
+		return NULL;
+	}
 
 	return node;
 }
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index f8fd98784977..b3f1a91e9a07 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -196,9 +196,7 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if ((time_before(transport->hb_timer.expires, expires) ||
-	     !timer_pending(&transport->hb_timer)) &&
-	    !mod_timer(&transport->hb_timer,
+	if (!mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
 }
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 1472f31480d8..dfb9797f7bc6 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -673,7 +673,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 	 */
 	krflags = MSG_PEEK | MSG_WAITALL;
 	clc_sk->sk_rcvtimeo = timeout;
-	iov_iter_kvec(&msg.msg_iter, READ, &vec, 1,
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &vec, 1,
 			sizeof(struct smc_clc_msg_hdr));
 	len = sock_recvmsg(smc->clcsock, &msg, krflags);
 	if (signal_pending(current)) {
@@ -720,7 +720,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 	} else {
 		recvlen = datlen;
 	}
-	iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, recvlen);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &vec, 1, recvlen);
 	krflags = MSG_WAITALL;
 	len = sock_recvmsg(smc->clcsock, &msg, krflags);
 	if (len < recvlen || !smc_clc_msg_hdr_valid(clcm, check_trl)) {
@@ -737,7 +737,7 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 		/* receive remaining proposal message */
 		recvlen = datlen > SMC_CLC_RECV_BUF_LEN ?
 						SMC_CLC_RECV_BUF_LEN : datlen;
-		iov_iter_kvec(&msg.msg_iter, READ, &vec, 1, recvlen);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &vec, 1, recvlen);
 		len = sock_recvmsg(smc->clcsock, &msg, krflags);
 		datlen -= len;
 	}
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 64dedffe9d26..f4b6a71ac488 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -308,7 +308,7 @@ int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
 
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
-	iov_iter_kvec(&msg.msg_iter, WRITE, &iov, 1, size);
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iov, 1, size);
 	rc = smc_tx_sendmsg(smc, &msg, size);
 	kunmap(page);
 	return rc;
diff --git a/net/socket.c b/net/socket.c
index 00da9ce3dba0..73463c7c3702 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -750,7 +750,7 @@ EXPORT_SYMBOL(sock_sendmsg);
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size)
 {
-	iov_iter_kvec(&msg->msg_iter, WRITE, vec, num, size);
+	iov_iter_kvec(&msg->msg_iter, ITER_SOURCE, vec, num, size);
 	return sock_sendmsg(sock, msg);
 }
 EXPORT_SYMBOL(kernel_sendmsg);
@@ -776,7 +776,7 @@ int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 	if (!sock->ops->sendmsg_locked)
 		return sock_no_sendmsg_locked(sk, msg, size);
 
-	iov_iter_kvec(&msg->msg_iter, WRITE, vec, num, size);
+	iov_iter_kvec(&msg->msg_iter, ITER_SOURCE, vec, num, size);
 
 	return sock->ops->sendmsg_locked(sk, msg, msg_data_left(msg));
 }
@@ -1034,7 +1034,7 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size, int flags)
 {
 	msg->msg_control_is_user = false;
-	iov_iter_kvec(&msg->msg_iter, READ, vec, num, size);
+	iov_iter_kvec(&msg->msg_iter, ITER_DEST, vec, num, size);
 	return sock_recvmsg(sock, msg, flags);
 }
 EXPORT_SYMBOL(kernel_recvmsg);
@@ -2092,7 +2092,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	struct iovec iov;
 	int fput_needed;
 
-	err = import_single_range(WRITE, buff, len, &iov, &msg.msg_iter);
+	err = import_single_range(ITER_SOURCE, buff, len, &iov, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
@@ -2157,7 +2157,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	int err, err2;
 	int fput_needed;
 
-	err = import_single_range(READ, ubuf, size, &iov, &msg.msg_iter);
+	err = import_single_range(ITER_DEST, ubuf, size, &iov, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
@@ -2417,7 +2417,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	if (err)
 		return err;
 
-	err = import_iovec(save_addr ? READ : WRITE,
+	err = import_iovec(save_addr ? ITER_DEST : ITER_SOURCE,
 			    msg.msg_iov, msg.msg_iovlen,
 			    UIO_FASTIOV, iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
index 71ba4cf513bc..1b2b84feeec6 100644
--- a/net/sunrpc/socklib.c
+++ b/net/sunrpc/socklib.c
@@ -214,14 +214,14 @@ static inline int xprt_sendmsg(struct socket *sock, struct msghdr *msg,
 static int xprt_send_kvec(struct socket *sock, struct msghdr *msg,
 			  struct kvec *vec, size_t seek)
 {
-	iov_iter_kvec(&msg->msg_iter, WRITE, vec, 1, vec->iov_len);
+	iov_iter_kvec(&msg->msg_iter, ITER_SOURCE, vec, 1, vec->iov_len);
 	return xprt_sendmsg(sock, msg, seek);
 }
 
 static int xprt_send_pagedata(struct socket *sock, struct msghdr *msg,
 			      struct xdr_buf *xdr, size_t base)
 {
-	iov_iter_bvec(&msg->msg_iter, WRITE, xdr->bvec, xdr_buf_pagecount(xdr),
+	iov_iter_bvec(&msg->msg_iter, ITER_SOURCE, xdr->bvec, xdr_buf_pagecount(xdr),
 		      xdr->page_len + xdr->page_base);
 	return xprt_sendmsg(sock, msg, base + xdr->page_base);
 }
@@ -244,7 +244,7 @@ static int xprt_send_rm_and_kvec(struct socket *sock, struct msghdr *msg,
 	};
 	size_t len = iov[0].iov_len + iov[1].iov_len;
 
-	iov_iter_kvec(&msg->msg_iter, WRITE, iov, 2, len);
+	iov_iter_kvec(&msg->msg_iter, ITER_SOURCE, iov, 2, len);
 	return xprt_sendmsg(sock, msg, base);
 }
 
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index e833103f4629..815baf308236 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -260,7 +260,7 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqstp, size_t buflen,
 	rqstp->rq_respages = &rqstp->rq_pages[i];
 	rqstp->rq_next_page = rqstp->rq_respages + 1;
 
-	iov_iter_bvec(&msg.msg_iter, READ, bvec, i, buflen);
+	iov_iter_bvec(&msg.msg_iter, ITER_DEST, bvec, i, buflen);
 	if (seek) {
 		iov_iter_advance(&msg.msg_iter, seek);
 		buflen -= seek;
@@ -874,7 +874,7 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *svsk,
 		want = sizeof(rpc_fraghdr) - svsk->sk_tcplen;
 		iov.iov_base = ((char *)&svsk->sk_marker) + svsk->sk_tcplen;
 		iov.iov_len  = want;
-		iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, want);
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, want);
 		len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
 		if (len < 0)
 			return len;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 915b9902f673..b3ab6d9d752e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -364,7 +364,7 @@ static ssize_t
 xs_read_kvec(struct socket *sock, struct msghdr *msg, int flags,
 		struct kvec *kvec, size_t count, size_t seek)
 {
-	iov_iter_kvec(&msg->msg_iter, READ, kvec, 1, count);
+	iov_iter_kvec(&msg->msg_iter, ITER_DEST, kvec, 1, count);
 	return xs_sock_recvmsg(sock, msg, flags, seek);
 }
 
@@ -373,7 +373,7 @@ xs_read_bvec(struct socket *sock, struct msghdr *msg, int flags,
 		struct bio_vec *bvec, unsigned long nr, size_t count,
 		size_t seek)
 {
-	iov_iter_bvec(&msg->msg_iter, READ, bvec, nr, count);
+	iov_iter_bvec(&msg->msg_iter, ITER_DEST, bvec, nr, count);
 	return xs_sock_recvmsg(sock, msg, flags, seek);
 }
 
@@ -381,7 +381,7 @@ static ssize_t
 xs_read_discard(struct socket *sock, struct msghdr *msg, int flags,
 		size_t count)
 {
-	iov_iter_discard(&msg->msg_iter, READ, count);
+	iov_iter_discard(&msg->msg_iter, ITER_DEST, count);
 	return sock_recvmsg(sock, msg, flags);
 }
 
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index e3b427a70398..69c88cc03887 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -396,7 +396,7 @@ static int tipc_conn_rcv_from_sock(struct tipc_conn *con)
 	iov.iov_base = &s;
 	iov.iov_len = sizeof(s);
 	msg.msg_name = NULL;
-	iov_iter_kvec(&msg.msg_iter, READ, &iov, 1, iov.iov_len);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, iov.iov_len);
 	ret = sock_recvmsg(con->sock, &msg, MSG_DONTWAIT);
 	if (ret == -EWOULDBLOCK)
 		return -EWOULDBLOCK;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a03d66046ca3..6c593788dc25 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -620,7 +620,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 	kaddr = kmap(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
-	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
+	iov_iter_kvec(&msg_iter, ITER_SOURCE, &iov, 1, size);
 	iter_offset.msg_iter = &msg_iter;
 	rc = tls_push_data(sk, iter_offset, size, flags, TLS_RECORD_TYPE_DATA,
 			   NULL);
@@ -697,7 +697,7 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
 	union tls_iter_offset iter;
 	struct iov_iter msg_iter;
 
-	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
+	iov_iter_kvec(&msg_iter, ITER_SOURCE, NULL, 0, 0);
 	iter.msg_iter = &msg_iter;
 	return tls_push_data(sk, iter, 0, flags, TLS_RECORD_TYPE_DATA, NULL);
 }
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..a83d2b4275fa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2427,7 +2427,7 @@ static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
 {
 	struct tls_rec *rec;
 
-	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
+	rec = list_first_entry_or_null(&ctx->tx_list, struct tls_rec, list);
 	if (!rec)
 		return false;
 
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3b55502b2965..5c7ad301d742 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -482,6 +482,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		rc = -EINVAL;
+		release_sock(sk);
+		return rc;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&x25_sk(sk)->dest_addr, 0, X25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 29a540dcb5a7..d6fece1ed982 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -354,7 +354,7 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	*((__be16 *)buf) = cpu_to_be16(msglen);
 	pfx_iov.iov_base = buf;
 	pfx_iov.iov_len = sizeof(buf);
-	iov_iter_kvec(&pfx_iter, WRITE, &pfx_iov, 1, pfx_iov.iov_len);
+	iov_iter_kvec(&pfx_iter, ITER_SOURCE, &pfx_iov, 1, pfx_iov.iov_len);
 
 	err = sk_msg_memcopy_from_iter(sk, &pfx_iter, &emsg->skmsg,
 				       pfx_iov.iov_len);
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index a4c987c23750..10df89b9ef67 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -66,9 +66,13 @@ endif
 # Don't stop modules_install even if we can't sign external modules.
 #
 ifeq ($(CONFIG_MODULE_SIG_ALL),y)
+ifeq ($(filter pkcs11:%, $(CONFIG_MODULE_SIG_KEY)),)
 sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(srctree)/)$(CONFIG_MODULE_SIG_KEY)
+else
+sig-key := $(CONFIG_MODULE_SIG_KEY)
+endif
 quiet_cmd_sign = SIGN    $@
-      cmd_sign = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(sig-key) certs/signing_key.x509 $@ \
+      cmd_sign = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) "$(sig-key)" certs/signing_key.x509 $@ \
                  $(if $(KBUILD_EXTMOD),|| true)
 else
 quiet_cmd_sign :=
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 96a92a645216..d54f73c558f7 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1251,7 +1251,7 @@ long keyctl_instantiate_key(key_serial_t id,
 		struct iov_iter from;
 		int ret;
 
-		ret = import_single_range(WRITE, (void __user *)_payload, plen,
+		ret = import_single_range(ITER_SOURCE, (void __user *)_payload, plen,
 					  &iov, &from);
 		if (unlikely(ret))
 			return ret;
@@ -1283,7 +1283,7 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = import_iovec(WRITE, _payload_iov, ioc,
+	ret = import_iovec(ITER_SOURCE, _payload_iov, ioc,
 				    ARRAY_SIZE(iovstack), &iov, &from);
 	if (ret < 0)
 		return ret;
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 7268304009ad..11ff1ee51345 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -542,16 +542,15 @@ static void *snd_dma_noncontig_alloc(struct snd_dma_buffer *dmab, size_t size)
 	struct sg_table *sgt;
 	void *p;
 
+#ifdef CONFIG_SND_DMA_SGBUF
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return snd_dma_sg_fallback_alloc(dmab, size);
+#endif
 	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
 				      DEFAULT_GFP, 0);
 #ifdef CONFIG_SND_DMA_SGBUF
-	if (!sgt && !get_dma_ops(dmab->dev.dev)) {
-		if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
-			dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
-		else
-			dmab->dev.type = SNDRV_DMA_TYPE_DEV_SG_FALLBACK;
+	if (!sgt && !get_dma_ops(dmab->dev.dev))
 		return snd_dma_sg_fallback_alloc(dmab, size);
-	}
 #endif
 	if (!sgt)
 		return NULL;
@@ -718,19 +717,38 @@ static const struct snd_malloc_ops snd_dma_sg_wc_ops = {
 
 /* Fallback SG-buffer allocations for x86 */
 struct snd_dma_sg_fallback {
+	bool use_dma_alloc_coherent;
 	size_t count;
 	struct page **pages;
+	/* DMA address array; the first page contains #pages in ~PAGE_MASK */
+	dma_addr_t *addrs;
 };
 
 static void __snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab,
 				       struct snd_dma_sg_fallback *sgbuf)
 {
-	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
-	size_t i;
-
-	for (i = 0; i < sgbuf->count && sgbuf->pages[i]; i++)
-		do_free_pages(page_address(sgbuf->pages[i]), PAGE_SIZE, wc);
+	size_t i, size;
+
+	if (sgbuf->pages && sgbuf->addrs) {
+		i = 0;
+		while (i < sgbuf->count) {
+			if (!sgbuf->pages[i] || !sgbuf->addrs[i])
+				break;
+			size = sgbuf->addrs[i] & ~PAGE_MASK;
+			if (WARN_ON(!size))
+				break;
+			if (sgbuf->use_dma_alloc_coherent)
+				dma_free_coherent(dmab->dev.dev, size << PAGE_SHIFT,
+						  page_address(sgbuf->pages[i]),
+						  sgbuf->addrs[i] & PAGE_MASK);
+			else
+				do_free_pages(page_address(sgbuf->pages[i]),
+					      size << PAGE_SHIFT, false);
+			i += size;
+		}
+	}
 	kvfree(sgbuf->pages);
+	kvfree(sgbuf->addrs);
 	kfree(sgbuf);
 }
 
@@ -739,24 +757,36 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 	struct snd_dma_sg_fallback *sgbuf;
 	struct page **pagep, *curp;
 	size_t chunk, npages;
+	dma_addr_t *addrp;
 	dma_addr_t addr;
 	void *p;
-	bool wc = dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
+
+	/* correct the type */
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_SG)
+		dmab->dev.type = SNDRV_DMA_TYPE_DEV_SG_FALLBACK;
+	else if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
+		dmab->dev.type = SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK;
 
 	sgbuf = kzalloc(sizeof(*sgbuf), GFP_KERNEL);
 	if (!sgbuf)
 		return NULL;
+	sgbuf->use_dma_alloc_coherent = cpu_feature_enabled(X86_FEATURE_XENPV);
 	size = PAGE_ALIGN(size);
 	sgbuf->count = size >> PAGE_SHIFT;
 	sgbuf->pages = kvcalloc(sgbuf->count, sizeof(*sgbuf->pages), GFP_KERNEL);
-	if (!sgbuf->pages)
+	sgbuf->addrs = kvcalloc(sgbuf->count, sizeof(*sgbuf->addrs), GFP_KERNEL);
+	if (!sgbuf->pages || !sgbuf->addrs)
 		goto error;
 
 	pagep = sgbuf->pages;
-	chunk = size;
+	addrp = sgbuf->addrs;
+	chunk = (PAGE_SIZE - 1) << PAGE_SHIFT; /* to fit in low bits in addrs */
 	while (size > 0) {
 		chunk = min(size, chunk);
-		p = do_alloc_pages(dmab->dev.dev, chunk, &addr, wc);
+		if (sgbuf->use_dma_alloc_coherent)
+			p = dma_alloc_coherent(dmab->dev.dev, chunk, &addr, DEFAULT_GFP);
+		else
+			p = do_alloc_pages(dmab->dev.dev, chunk, &addr, false);
 		if (!p) {
 			if (chunk <= PAGE_SIZE)
 				goto error;
@@ -768,17 +798,25 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 		size -= chunk;
 		/* fill pages */
 		npages = chunk >> PAGE_SHIFT;
+		*addrp = npages; /* store in lower bits */
 		curp = virt_to_page(p);
-		while (npages--)
+		while (npages--) {
 			*pagep++ = curp++;
+			*addrp++ |= addr;
+			addr += PAGE_SIZE;
+		}
 	}
 
 	p = vmap(sgbuf->pages, sgbuf->count, VM_MAP, PAGE_KERNEL);
 	if (!p)
 		goto error;
+
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
+		set_pages_array_wc(sgbuf->pages, sgbuf->count);
+
 	dmab->private_data = sgbuf;
 	/* store the first page address for convenience */
-	dmab->addr = snd_sgbuf_get_addr(dmab, 0);
+	dmab->addr = sgbuf->addrs[0] & PAGE_MASK;
 	return p;
 
  error:
@@ -788,10 +826,23 @@ static void *snd_dma_sg_fallback_alloc(struct snd_dma_buffer *dmab, size_t size)
 
 static void snd_dma_sg_fallback_free(struct snd_dma_buffer *dmab)
 {
+	struct snd_dma_sg_fallback *sgbuf = dmab->private_data;
+
+	if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG_FALLBACK)
+		set_pages_array_wb(sgbuf->pages, sgbuf->count);
 	vunmap(dmab->area);
 	__snd_dma_sg_fallback_free(dmab, dmab->private_data);
 }
 
+static dma_addr_t snd_dma_sg_fallback_get_addr(struct snd_dma_buffer *dmab,
+					       size_t offset)
+{
+	struct snd_dma_sg_fallback *sgbuf = dmab->private_data;
+	size_t index = offset >> PAGE_SHIFT;
+
+	return (sgbuf->addrs[index] & PAGE_MASK) | (offset & ~PAGE_MASK);
+}
+
 static int snd_dma_sg_fallback_mmap(struct snd_dma_buffer *dmab,
 				    struct vm_area_struct *area)
 {
@@ -806,8 +857,8 @@ static const struct snd_malloc_ops snd_dma_sg_fallback_ops = {
 	.alloc = snd_dma_sg_fallback_alloc,
 	.free = snd_dma_sg_fallback_free,
 	.mmap = snd_dma_sg_fallback_mmap,
+	.get_addr = snd_dma_sg_fallback_get_addr,
 	/* reuse vmalloc helpers */
-	.get_addr = snd_dma_vmalloc_get_addr,
 	.get_page = snd_dma_vmalloc_get_page,
 	.get_chunk_size = snd_dma_vmalloc_get_chunk_size,
 };
diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index a900fc0e7644..88d1f4b56e4b 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -87,6 +87,10 @@ static long hwdep_read(struct snd_hwdep *hwdep, char __user *buf, long count,
 			return -EFAULT;
 
 		count = consumed;
+	} else {
+		spin_unlock_irq(&motu->lock);
+
+		count = 0;
 	}
 
 	return count;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6fab7c8fc19a..db9518de9343 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9202,6 +9202,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
@@ -9432,6 +9433,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index aea7fae2ca4b..2994f85bc1b9 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -819,6 +819,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
 		return 0;
 	nums = snd_hda_get_connections(codec, spec->gen.mixer_nid, conn,
 				       ARRAY_SIZE(conn) - 1);
+	if (nums < 0)
+		return nums;
+
 	for (i = 0; i < nums; i++) {
 		if (get_wcaps_type(get_wcaps(codec, conn[i])) == AC_WID_AUD_OUT)
 			return 0;
diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 2fe8df86053a..89499542c803 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -198,9 +198,11 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	int ret;
 
 	adev = acpi_dev_get_first_match_dev("ESSX8336", NULL, -1);
-	if (adev)
-		put_device(&adev->dev);
+	if (!adev)
+		return -ENODEV;
+
 	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		dev_err(card->dev, "can not find codec dev\n");
 
diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 0ddb6362fcc5..2533d0973529 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1359,8 +1359,8 @@ static struct snd_soc_dai_driver wsa883x_dais[] = {
 			.stream_name = "SPKR Playback",
 			.rates = WSA883X_RATES | WSA883X_FRAC_RATES,
 			.formats = WSA883X_FORMATS,
-			.rate_max = 8000,
-			.rate_min = 352800,
+			.rate_min = 8000,
+			.rate_max = 352800,
 			.channels_min = 1,
 			.channels_max = 1,
 		},
diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 4f93639ce488..5bb3eee2f783 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -476,6 +476,29 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	return ret;
 }
 
+static void avs_pci_shutdown(struct pci_dev *pci)
+{
+	struct hdac_bus *bus = pci_get_drvdata(pci);
+	struct avs_dev *adev = hdac_to_avs(bus);
+
+	cancel_work_sync(&adev->probe_work);
+	avs_ipc_block(adev->ipc);
+
+	snd_hdac_stop_streams(bus);
+	avs_dsp_op(adev, int_control, false);
+	snd_hdac_ext_bus_ppcap_int_enable(bus, false);
+	snd_hdac_ext_bus_link_power_down_all(bus);
+
+	snd_hdac_bus_stop_chip(bus);
+	snd_hdac_display_power(bus, HDA_CODEC_IDX_CONTROLLER, false);
+
+	if (avs_platattr_test(adev, CLDMA))
+		pci_free_irq(pci, 0, &code_loader);
+	pci_free_irq(pci, 0, adev);
+	pci_free_irq(pci, 0, bus);
+	pci_free_irq_vectors(pci);
+}
+
 static void avs_pci_remove(struct pci_dev *pci)
 {
 	struct hdac_device *hdev, *save;
@@ -679,6 +702,7 @@ static struct pci_driver avs_pci_driver = {
 	.id_table = avs_ids,
 	.probe = avs_pci_probe,
 	.remove = avs_pci_remove,
+	.shutdown = avs_pci_shutdown,
 	.driver = {
 		.pm = &avs_dev_pm,
 	},
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index a935c5fd9edb..4dd37848b30e 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -497,21 +497,28 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(codec_name, sizeof(codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_cht_es8316_dais[dai_index].codecs->name = codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
 		return -ENXIO;
 	}
 
+	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
+	if (!codec_dev)
+		return -EPROBE_DEFER;
+	priv->codec_dev = get_device(codec_dev);
+
 	/* override platform name, if required */
 	byt_cht_es8316_card.dev = dev;
 	platform_name = mach->mach_params.platform;
 
 	ret = snd_soc_fixup_dai_links_platform_name(&byt_cht_es8316_card,
 						    platform_name);
-	if (ret)
+	if (ret) {
+		put_device(codec_dev);
 		return ret;
+	}
 
 	/* Check for BYTCR or other platform and setup quirks */
 	dmi_id = dmi_first_match(byt_cht_es8316_quirk_table);
@@ -539,13 +546,10 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 
 	/* get the clock */
 	priv->mclk = devm_clk_get(dev, "pmc_plt_clk_3");
-	if (IS_ERR(priv->mclk))
+	if (IS_ERR(priv->mclk)) {
+		put_device(codec_dev);
 		return dev_err_probe(dev, PTR_ERR(priv->mclk), "clk_get pmc_plt_clk_3 failed\n");
-
-	codec_dev = acpi_get_first_physical_node(adev);
-	if (!codec_dev)
-		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
+	}
 
 	if (quirk & BYT_CHT_ES8316_JD_INVERTED)
 		props[cnt++] = PROPERTY_ENTRY_BOOL("everest,jack-detect-inverted");
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index ddd2625bed90..4f46f52c38e4 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1626,13 +1626,18 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(byt_rt5640_codec_name, sizeof(byt_rt5640_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_rt5640_dais[dai_index].codecs->name = byt_rt5640_codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
 		return -ENXIO;
 	}
 
+	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
+	if (!codec_dev)
+		return -EPROBE_DEFER;
+	priv->codec_dev = get_device(codec_dev);
+
 	/*
 	 * swap SSP0 if bytcr is detected
 	 * (will be overridden if DMI quirk is detected)
@@ -1707,11 +1712,6 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		byt_rt5640_quirk = quirk_override;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
-	if (!codec_dev)
-		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
-
 	if (byt_rt5640_quirk & BYT_RT5640_JD_HP_ELITEP_1000G2) {
 		acpi_dev_add_driver_gpios(ACPI_COMPANION(priv->codec_dev),
 					  byt_rt5640_hp_elitepad_1000g2_gpios);
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 2beb686768f2..d74d184e1c7f 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -922,7 +922,6 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(byt_rt5651_codec_name, sizeof(byt_rt5651_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_rt5651_dais[dai_index].codecs->name = byt_rt5651_codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
@@ -930,6 +929,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 	priv->codec_dev = get_device(codec_dev);
diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index 45a6805787f5..f8da1bcd010e 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -411,9 +411,9 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 	snprintf(codec_name, sizeof(codec_name), "spi-%s", acpi_dev_name(adev));
-	put_device(&adev->dev);
 
 	codec_dev = bus_find_device_by_name(&spi_bus_type, NULL, codec_name);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 
diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 773e5d1d87d4..894b6610b9e2 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -681,7 +681,6 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(codec_name, sizeof(codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		dai_links[0].codecs->name = codec_name;
 
 		/* also fixup codec dai name if relevant */
@@ -692,16 +691,19 @@ static int sof_es8336_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	ret = snd_soc_fixup_dai_links_platform_name(&sof_es8336_card,
-						    mach->mach_params.platform);
-	if (ret)
-		return ret;
-
 	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 	priv->codec_dev = get_device(codec_dev);
 
+	ret = snd_soc_fixup_dai_links_platform_name(&sof_es8336_card,
+						    mach->mach_params.platform);
+	if (ret) {
+		put_device(codec_dev);
+		return ret;
+	}
+
 	if (quirk & SOF_ES8336_JD_INVERTED)
 		props[cnt++] = PROPERTY_ENTRY_BOOL("everest,jack-detect-inverted");
 
diff --git a/sound/soc/sof/ipc4-mtrace.c b/sound/soc/sof/ipc4-mtrace.c
index 70dea8ae706e..0ec6ef681012 100644
--- a/sound/soc/sof/ipc4-mtrace.c
+++ b/sound/soc/sof/ipc4-mtrace.c
@@ -344,9 +344,10 @@ static ssize_t sof_ipc4_priority_mask_dfs_write(struct file *file,
 						size_t count, loff_t *ppos)
 {
 	struct sof_mtrace_priv *priv = file->private_data;
-	int id, ret;
+	unsigned int id;
 	char *buf;
 	u32 mask;
+	int ret;
 
 	/*
 	 * To update Nth mask entry, write:
@@ -357,9 +358,9 @@ static ssize_t sof_ipc4_priority_mask_dfs_write(struct file *file,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ret = sscanf(buf, "%d,0x%x", &id, &mask);
+	ret = sscanf(buf, "%u,0x%x", &id, &mask);
 	if (ret != 2) {
-		ret = sscanf(buf, "%d,%x", &id, &mask);
+		ret = sscanf(buf, "%u,%x", &id, &mask);
 		if (ret != 2) {
 			ret = -EINVAL;
 			goto out;
diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 62092e2d609c..2df433c6ef55 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -271,9 +271,9 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 	struct snd_sof_widget *swidget = widget->dobj.private;
 	struct snd_soc_dapm_path *p;
 
-	/* return if the widget is in use or if it is already unprepared */
-	if (!swidget->prepared || swidget->use_count > 1)
-		return;
+	/* skip if the widget is in use or if it is already unprepared */
+	if (!swidget || !swidget->prepared || swidget->use_count > 0)
+		goto sink_unprepare;
 
 	if (widget_ops[widget->id].ipc_unprepare)
 		/* unprepare the source widget */
@@ -281,6 +281,7 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 
 	swidget->prepared = false;
 
+sink_unprepare:
 	/* unprepare all widgets in the sink paths */
 	snd_soc_dapm_widget_for_each_sink_path(widget, p) {
 		if (!p->walking && p->sink->dobj.private) {
@@ -303,7 +304,7 @@ sof_prepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget
 	struct snd_soc_dapm_path *p;
 	int ret;
 
-	if (!widget_ops[widget->id].ipc_prepare || swidget->prepared)
+	if (!swidget || !widget_ops[widget->id].ipc_prepare || swidget->prepared)
 		goto sink_prepare;
 
 	/* prepare the source widget */
@@ -326,7 +327,8 @@ sof_prepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget
 			p->walking = false;
 			if (ret < 0) {
 				/* unprepare the source widget */
-				if (widget_ops[widget->id].ipc_unprepare && swidget->prepared) {
+				if (widget_ops[widget->id].ipc_unprepare &&
+				    swidget && swidget->prepared) {
 					widget_ops[widget->id].ipc_unprepare(swidget);
 					swidget->prepared = false;
 				}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 526d2c42d870..a503244852e4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -254,6 +254,7 @@ TEST_MATRIX=(
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"  S+ C2-3:P1:S+  C3:P1  .      .      T     C2-3    .      .     0 A1:2-3,A2:2-3 A1:P1,A2:P-1"
+	"  S+  C3:P1:S+    C3    .      .      T      P1     .      .     0 A1:3,A2:3 A1:P1,A2:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    .    T:C2-3   .      .      .     0 A1:2-3,A2:2-3,A3:3 A1:P1,A2:P-1,A3:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    . T:C2-3:C1-3 .      .      .     0 A1:1,A2:2,A3:3 A1:P1,A2:P1,A3:P1"
 
diff --git a/tools/testing/selftests/filesystems/fat/run_fat_tests.sh b/tools/testing/selftests/filesystems/fat/run_fat_tests.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index dc932fd65363..640bc43452fa 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -7,6 +7,7 @@ readonly GREEN='\033[0;92m'
 readonly YELLOW='\033[0;33m'
 readonly RED='\033[0;31m'
 readonly NC='\033[0m' # No Color
+readonly TESTPORT=8000
 
 readonly KSFT_PASS=0
 readonly KSFT_FAIL=1
@@ -56,11 +57,26 @@ trap wake_children EXIT
 
 run_one() {
 	local -r args=$@
+	local nr_socks=0
+	local i=0
+	local -r timeout=10
+
+	./udpgso_bench_rx -p "$TESTPORT" &
+	./udpgso_bench_rx -p "$TESTPORT" -t &
+
+	# Wait for the above test program to get ready to receive connections.
+	while [ "$i" -lt "$timeout" ]; do
+		nr_socks="$(ss -lnHi | grep -c "\*:${TESTPORT}")"
+		[ "$nr_socks" -eq 2 ] && break
+		i=$((i + 1))
+		sleep 1
+	done
+	if [ "$nr_socks" -ne 2 ]; then
+		echo "timed out while waiting for udpgso_bench_rx"
+		exit 1
+	fi
 
-	./udpgso_bench_rx &
-	./udpgso_bench_rx -t &
-
-	./udpgso_bench_tx ${args}
+	./udpgso_bench_tx -p "$TESTPORT" ${args}
 }
 
 run_in_netns() {
diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 6a193425c367..4058c7451e70 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -250,7 +250,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 static void do_flush_udp(int fd)
 {
 	static char rbuf[ETH_MAX_MTU];
-	int ret, len, gso_size, budget = 256;
+	int ret, len, gso_size = 0, budget = 256;
 
 	len = cfg_read_all ? sizeof(rbuf) : 0;
 	while (budget--) {
@@ -336,6 +336,8 @@ static void parse_opts(int argc, char **argv)
 			cfg_verify = true;
 			cfg_read_all = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index f1fdaa270291..477392715a9a 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -62,6 +62,7 @@ static int	cfg_payload_len	= (1472 * 42);
 static int	cfg_port	= 8000;
 static int	cfg_runtime_ms	= -1;
 static bool	cfg_poll;
+static int	cfg_poll_loop_timeout_ms = 2000;
 static bool	cfg_segment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
@@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
 	}
 }
 
-static void flush_errqueue(int fd, const bool do_poll)
+static void flush_errqueue(int fd, const bool do_poll,
+			   unsigned long poll_timeout, const bool poll_err)
 {
 	if (do_poll) {
 		struct pollfd fds = {0};
 		int ret;
 
 		fds.fd = fd;
-		ret = poll(&fds, 1, 500);
+		ret = poll(&fds, 1, poll_timeout);
 		if (ret == 0) {
-			if (cfg_verbose)
+			if ((cfg_verbose) && (poll_err))
 				fprintf(stderr, "poll timeout\n");
 		} else if (ret < 0) {
 			error(1, errno, "poll");
@@ -254,6 +256,20 @@ static void flush_errqueue(int fd, const bool do_poll)
 	flush_errqueue_recv(fd);
 }
 
+static void flush_errqueue_retry(int fd, unsigned long num_sends)
+{
+	unsigned long tnow, tstop;
+	bool first_try = true;
+
+	tnow = gettimeofday_ms();
+	tstop = tnow + cfg_poll_loop_timeout_ms;
+	do {
+		flush_errqueue(fd, true, tstop - tnow, first_try);
+		first_try = false;
+		tnow = gettimeofday_ms();
+	} while ((stat_zcopies != num_sends) && (tnow < tstop));
+}
+
 static int send_tcp(int fd, char *data)
 {
 	int ret, done = 0, count = 0;
@@ -413,7 +429,8 @@ static int send_udp_segment(int fd, char *data)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
+	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
+		    "[-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
 		    filepath);
 }
 
@@ -423,7 +440,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:PS:tTuvz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:D:Hl:L:mM:p:s:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -452,6 +469,9 @@ static void parse_opts(int argc, char **argv)
 		case 'l':
 			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
 			break;
+		case 'L':
+			cfg_poll_loop_timeout_ms = strtoul(optarg, NULL, 10) * 1000;
+			break;
 		case 'm':
 			cfg_sendmmsg = true;
 			break;
@@ -490,6 +510,8 @@ static void parse_opts(int argc, char **argv)
 		case 'z':
 			cfg_zerocopy = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
@@ -677,7 +699,7 @@ int main(int argc, char **argv)
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
 		if ((cfg_zerocopy && ((num_msgs & 0xF) == 0)) || cfg_tx_tstamp)
-			flush_errqueue(fd, cfg_poll);
+			flush_errqueue(fd, cfg_poll, 500, true);
 
 		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
 			break;
@@ -696,7 +718,7 @@ int main(int argc, char **argv)
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
 	if (cfg_zerocopy || cfg_tx_tstamp)
-		flush_errqueue(fd, true);
+		flush_errqueue_retry(fd, num_sends);
 
 	if (close(fd))
 		error(1, errno, "close");
