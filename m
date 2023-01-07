Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB01660E5F
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 12:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjAGLl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 06:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjAGLle (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 06:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D11631A5;
        Sat,  7 Jan 2023 03:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6832360AF4;
        Sat,  7 Jan 2023 11:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BA5C433EF;
        Sat,  7 Jan 2023 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673091654;
        bh=J3fYfEhA/544jV5AOeoyrTWOfwEL6LuA5KxWL4r7VKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jj/ixoamEFNa0cEQ9Dk8hEtgZCnuJ2b0ggiQyvYOqYi3eYgzt7JZg9OVMq/NIlpiT
         iNEFBU/1WIjUm6tay0Fn97TdX5W51/Nf7BzpNYM3XAVg+DUuNZybGyJdjXgaW64Eui
         Ff0zw4lOCKrAUlncu8otswy2DfdXJEW5yZtu5BRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.337
Date:   Sat,  7 Jan 2023 12:40:42 +0100
Message-Id: <1673091641215229@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167309164122758@kroah.com>
References: <167309164122758@kroah.com>
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
index a2c74e89f20e..7d0153202217 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 336
+SUBLEVEL = 337
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 98703d99b565..d752ccc53b24 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -468,8 +468,10 @@ entSys:
 #ifdef CONFIG_AUDITSYSCALL
 	lda     $6, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
 	and     $3, $6, $3
-#endif
 	bne     $3, strace
+#else
+	blbs    $3, strace		/* check for SYSCALL_TRACE in disguise */
+#endif
 	beq	$4, 1f
 	ldq	$27, 0($5)
 1:	jsr	$26, ($27), alpha_ni_syscall
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index b4258105e91f..b00e328b54a1 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -108,7 +108,7 @@
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
index 024f1b75b0a3..681c8458c8f2 100644
--- a/arch/arm/boot/dts/armada-375.dtsi
+++ b/arch/arm/boot/dts/armada-375.dtsi
@@ -618,7 +618,7 @@
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-380.dtsi b/arch/arm/boot/dts/armada-380.dtsi
index 5102d19cc8f4..43477ca6eaa3 100644
--- a/arch/arm/boot/dts/armada-380.dtsi
+++ b/arch/arm/boot/dts/armada-380.dtsi
@@ -115,7 +115,7 @@
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -133,7 +133,7 @@
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-385.dtsi b/arch/arm/boot/dts/armada-385.dtsi
index 8e67d2c083dd..0451bc14386c 100644
--- a/arch/arm/boot/dts/armada-385.dtsi
+++ b/arch/arm/boot/dts/armada-385.dtsi
@@ -126,7 +126,7 @@
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -144,7 +144,7 @@
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -165,7 +165,7 @@
 			 */
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x48000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-39x.dtsi b/arch/arm/boot/dts/armada-39x.dtsi
index aeecfa7e5ea3..3ca83e37112b 100644
--- a/arch/arm/boot/dts/armada-39x.dtsi
+++ b/arch/arm/boot/dts/armada-39x.dtsi
@@ -492,7 +492,7 @@
 			/* x1 port */
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x40000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -510,7 +510,7 @@
 			/* x1 port */
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x44000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -531,7 +531,7 @@
 			 */
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x48000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 6e6d0f04bf2b..b6e787b994ad 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -133,7 +133,7 @@
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -150,7 +150,7 @@
 
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -167,7 +167,7 @@
 
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -184,7 +184,7 @@
 
 			pcie@5,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index c5fdc99f0dbe..a4856b05440a 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -148,7 +148,7 @@
 
 			pcie@2,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -165,7 +165,7 @@
 
 			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
 				reg = <0x1800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -182,7 +182,7 @@
 
 			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
 				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -199,7 +199,7 @@
 
 			pcie@5,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
 				reg = <0x2800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -216,7 +216,7 @@
 
 			pcie@6,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x84000 0 0x2000>;
+				assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
 				reg = <0x3000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -233,7 +233,7 @@
 
 			pcie@7,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x88000 0 0x2000>;
+				assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
 				reg = <0x3800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -250,7 +250,7 @@
 
 			pcie@8,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x8c000 0 0x2000>;
+				assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
 				reg = <0x4000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
@@ -267,7 +267,7 @@
 
 			pcie@9,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
+				assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
 				reg = <0x4800 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 11342aeccb73..278c7321b1b9 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -127,7 +127,7 @@
 			pcie1: pcie-port@1 {
 				device_type = "pci";
 				status = "disabled";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				clocks = <&gate_clk 5>;
 				marvell,pcie-port = <1>;
diff --git a/arch/arm/boot/dts/spear600.dtsi b/arch/arm/boot/dts/spear600.dtsi
index bd379034993c..89318273d787 100644
--- a/arch/arm/boot/dts/spear600.dtsi
+++ b/arch/arm/boot/dts/spear600.dtsi
@@ -53,7 +53,7 @@
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0xfc200000 0x1000>;
 			interrupt-parent = <&vic1>;
-			interrupts = <12>;
+			interrupts = <13>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 3c2c92aaa0ae..f06220a4b2e2 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -52,18 +52,21 @@
 static void __iomem *mmp_timer_base = TIMERS_VIRT_BASE;
 
 /*
- * FIXME: the timer needs some delay to stablize the counter capture
+ * Read the timer through the CVWR register. Delay is required after requesting
+ * a read. The CR register cannot be directly read due to metastability issues
+ * documented in the PXA168 software manual.
  */
 static inline uint32_t timer_read(void)
 {
-	int delay = 100;
+	uint32_t val;
+	int delay = 3;
 
 	__raw_writel(1, mmp_timer_base + TMR_CVWR(1));
 
 	while (delay--)
-		cpu_relax();
+		val = __raw_readl(mmp_timer_base + TMR_CVWR(1));
 
-	return __raw_readl(mmp_timer_base + TMR_CVWR(1));
+	return val;
 }
 
 static u64 notrace mmp_read_sched_clock(void)
diff --git a/arch/arm/nwfpe/Makefile b/arch/arm/nwfpe/Makefile
index deb3a82ddbdf..99136e74ddd5 100644
--- a/arch/arm/nwfpe/Makefile
+++ b/arch/arm/nwfpe/Makefile
@@ -10,3 +10,9 @@ nwfpe-y				+= fpa11.o fpa11_cpdo.o fpa11_cpdt.o \
 				   entry.o
 
 nwfpe-$(CONFIG_FPE_NWFPE_XP)	+= extended_cpdo.o
+
+# Try really hard to avoid generating calls to __aeabi_uldivmod() from
+# float64_rem() due to loop elision.
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_softfloat.o	+= -mllvm -replexitval=never
+endif
diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index 3be875a45c83..0b718a94656a 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -316,6 +316,8 @@ static struct clk clk_periph = {
  */
 int clk_enable(struct clk *clk)
 {
+	if (!clk)
+		return 0;
 	mutex_lock(&clocks_mutex);
 	clk_enable_unlocked(clk);
 	mutex_unlock(&clocks_mutex);
diff --git a/arch/mips/kernel/vpe-cmp.c b/arch/mips/kernel/vpe-cmp.c
index 9268ebc0f61e..903c07bdc92d 100644
--- a/arch/mips/kernel/vpe-cmp.c
+++ b/arch/mips/kernel/vpe-cmp.c
@@ -75,7 +75,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -157,6 +156,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -169,7 +169,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index 2e003b11a098..9fd7cd48ea1d 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -313,7 +313,6 @@ ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
-	kfree(cd);
 }
 
 static struct class vpe_class = {
@@ -497,6 +496,7 @@ int __init vpe_module_init(void)
 	device_del(&vpe_device);
 
 out_class:
+	put_device(&vpe_device);
 	class_unregister(&vpe_class);
 
 out_chrdev:
@@ -509,7 +509,7 @@ void __exit vpe_module_exit(void)
 {
 	struct vpe *v, *n;
 
-	device_del(&vpe_device);
+	device_unregister(&vpe_device);
 	class_unregister(&vpe_class);
 	unregister_chrdev(major, VPE_MODULE_NAME);
 
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 641f3e4c3380..9a77778bd24a 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -733,10 +733,15 @@ void rtas_os_term(char *str)
 
 	snprintf(rtas_os_term_buf, 2048, "OS panic: %s", str);
 
+	/*
+	 * Keep calling as long as RTAS returns a "try again" status,
+	 * but don't use rtas_busy_delay(), which potentially
+	 * schedules.
+	 */
 	do {
 		status = rtas_call(rtas_token("ibm,os-term"), 1, 1, NULL,
 				   __pa(rtas_os_term_buf));
-	} while (rtas_busy_delay(status));
+	} while (rtas_busy_delay_time(status));
 
 	if (status != 0)
 		printk(KERN_EMERG "ibm,os-term call failed %d\n", status);
diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 0fc26714780a..a4c4685096f8 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -67,6 +67,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 		next_sp = fp[0];
 
 		if (next_sp == sp + STACK_INT_FRAME_SIZE &&
+		    validate_sp(sp, current, STACK_INT_FRAME_SIZE) &&
 		    fp[STACK_FRAME_MARKER] == STACK_FRAME_REGS_MARKER) {
 			/*
 			 * This looks like an interrupt frame for an
diff --git a/arch/powerpc/perf/hv-gpci-requests.h b/arch/powerpc/perf/hv-gpci-requests.h
index 5ea24d16a74a..2530dd0c3788 100644
--- a/arch/powerpc/perf/hv-gpci-requests.h
+++ b/arch/powerpc/perf/hv-gpci-requests.h
@@ -78,6 +78,7 @@ REQUEST(__field(0,	8,	partition_id)
 )
 #include I(REQUEST_END)
 
+#ifdef ENABLE_EVENTS_COUNTERINFO_V6
 /*
  * Not available for counter_info_version >= 0x8, use
  * run_instruction_cycles_by_partition(0x100) instead.
@@ -91,6 +92,7 @@ REQUEST(__field(0,	8,	partition_id)
 	__count(0x10,	8,	cycles)
 )
 #include I(REQUEST_END)
+#endif
 
 #define REQUEST_NAME system_performance_capabilities
 #define REQUEST_NUM 0x40
@@ -102,6 +104,7 @@ REQUEST(__field(0,	1,	perf_collect_privileged)
 )
 #include I(REQUEST_END)
 
+#ifdef ENABLE_EVENTS_COUNTERINFO_V6
 #define REQUEST_NAME processor_bus_utilization_abc_links
 #define REQUEST_NUM 0x50
 #define REQUEST_IDX_KIND "hw_chip_id=?"
@@ -193,6 +196,7 @@ REQUEST(__field(0,	4,	phys_processor_idx)
 	__count(0x28,	8,	instructions_completed)
 )
 #include I(REQUEST_END)
+#endif
 
 /* Processor_core_power_mode (0x95) skipped, no counters */
 /* Affinity_domain_information_by_virtual_processor (0xA0) skipped,
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 160b86d9d819..126409bb5626 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -74,7 +74,7 @@ static struct attribute_group format_group = {
 
 static struct attribute_group event_group = {
 	.name  = "events",
-	.attrs = hv_gpci_event_attrs,
+	/* .attrs is set in init */
 };
 
 #define HV_CAPS_ATTR(_name, _format)				\
@@ -292,6 +292,7 @@ static int hv_gpci_init(void)
 	int r;
 	unsigned long hret;
 	struct hv_perf_caps caps;
+	struct hv_gpci_request_buffer *arg;
 
 	hv_gpci_assert_offsets_correct();
 
@@ -310,6 +311,36 @@ static int hv_gpci_init(void)
 	/* sampling not supported */
 	h_gpci_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 
+	arg = (void *)get_cpu_var(hv_gpci_reqb);
+	memset(arg, 0, HGPCI_REQ_BUFFER_SIZE);
+
+	/*
+	 * hcall H_GET_PERF_COUNTER_INFO populates the output
+	 * counter_info_version value based on the system hypervisor.
+	 * Pass the counter request 0x10 corresponds to request type
+	 * 'Dispatch_timebase_by_processor', to get the supported
+	 * counter_info_version.
+	 */
+	arg->params.counter_request = cpu_to_be32(0x10);
+
+	r = plpar_hcall_norets(H_GET_PERF_COUNTER_INFO,
+			virt_to_phys(arg), HGPCI_REQ_BUFFER_SIZE);
+	if (r) {
+		pr_devel("hcall failed, can't get supported counter_info_version: 0x%x\n", r);
+		arg->params.counter_info_version_out = 0x8;
+	}
+
+	/*
+	 * Use counter_info_version_out value to assign
+	 * required hv-gpci event list.
+	 */
+	if (arg->params.counter_info_version_out >= 0x8)
+		event_group.attrs = hv_gpci_event_attrs;
+	else
+		event_group.attrs = hv_gpci_event_attrs_v6;
+
+	put_cpu_var(hv_gpci_reqb);
+
 	r = perf_pmu_register(&h_gpci_pmu, h_gpci_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-gpci.h b/arch/powerpc/perf/hv-gpci.h
index 86ede8275961..83300e73c398 100644
--- a/arch/powerpc/perf/hv-gpci.h
+++ b/arch/powerpc/perf/hv-gpci.h
@@ -52,6 +52,7 @@ enum {
 #define REQUEST_FILE "../hv-gpci-requests.h"
 #define NAME_LOWER hv_gpci
 #define NAME_UPPER HV_GPCI
+#define ENABLE_EVENTS_COUNTERINFO_V6
 #include "req-gen/perf.h"
 #undef REQUEST_FILE
 #undef NAME_LOWER
diff --git a/arch/powerpc/perf/req-gen/perf.h b/arch/powerpc/perf/req-gen/perf.h
index 1b122469323d..9628b57a8635 100644
--- a/arch/powerpc/perf/req-gen/perf.h
+++ b/arch/powerpc/perf/req-gen/perf.h
@@ -137,6 +137,26 @@ PMU_EVENT_ATTR_STRING(							\
 #define REQUEST_(r_name, r_value, r_idx_1, r_fields)			\
 	r_fields
 
+/* Generate event list for platforms with counter_info_version 0x6 or below */
+static __maybe_unused struct attribute *hv_gpci_event_attrs_v6[] = {
+#include REQUEST_FILE
+	NULL
+};
+
+/*
+ * Based on getPerfCountInfo v1.018 documentation, some of the hv-gpci
+ * events were deprecated for platform firmware that supports
+ * counter_info_version 0x8 or above.
+ * Those deprecated events are still part of platform firmware that
+ * support counter_info_version 0x6 and below. As per the getPerfCountInfo
+ * v1.018 documentation there is no counter_info_version 0x7.
+ * Undefining macro ENABLE_EVENTS_COUNTERINFO_V6, to disable the addition of
+ * deprecated events in "hv_gpci_event_attrs" attribute group, for platforms
+ * that supports counter_info_version 0x8 or above.
+ */
+#undef ENABLE_EVENTS_COUNTERINFO_V6
+
+/* Generate event list for platforms with counter_info_version 0x8 or above*/
 static __maybe_unused struct attribute *hv_gpci_event_attrs[] = {
 #include REQUEST_FILE
 	NULL
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index 7bb42a0100de..caaaaf2bea52 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -531,6 +531,7 @@ static int mpc52xx_lpbfifo_probe(struct platform_device *op)
  err_bcom_rx_irq:
 	bcom_gen_bd_rx_release(lpbfifo.bcom_rx_task);
  err_bcom_rx:
+	free_irq(lpbfifo.irq, &lpbfifo);
  err_irq:
 	iounmap(lpbfifo.regs);
 	lpbfifo.regs = NULL;
diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index d7c9b186954d..3e5e51de9a0d 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -111,7 +111,7 @@ static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 
 		goto next;
 unreg:
-		platform_device_del(pdev);
+		platform_device_put(pdev);
 err:
 		pr_err("%s: registration failed\n", np->full_name);
 next:
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 52bb7413f352..953ed5b5a218 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -718,8 +718,9 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	switch (opc1) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
-	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
 		break;
+	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
+		goto setup;
 
 	case 0xe8:	/* call relative */
 		branch_clear_offset(auprobe, insn);
@@ -748,6 +749,7 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 			return -ENOTSUPP;
 	}
 
+setup:
 	auprobe->branch.opc1 = opc1;
 	auprobe->branch.ilen = insn->length;
 	auprobe->branch.offs = insn->immediate.value;
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 44bf8a22c97b..4e540958ea36 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -80,6 +80,7 @@ void xen_init_lock_cpu(int cpu)
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	per_cpu(irq_name, cpu) = name;
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
@@ -90,7 +91,6 @@ void xen_init_lock_cpu(int cpu)
 	if (irq >= 0) {
 		disable_irq(irq); /* make sure it's never delivered */
 		per_cpu(lock_kicker_irq, cpu) = irq;
-		per_cpu(irq_name, cpu) = name;
 	}
 
 	printk("cpu %d spinlock event irq %d\n", cpu, irq);
@@ -103,6 +103,8 @@ void xen_uninit_lock_cpu(int cpu)
 	if (!xen_pvspin)
 		return;
 
+	kfree(per_cpu(irq_name, cpu));
+	per_cpu(irq_name, cpu) = NULL;
 	/*
 	 * When booting the kernel with 'mitigations=auto,nosmt', the secondary
 	 * CPUs are not activated, and lock_kicker_irq is not initialized.
@@ -113,8 +115,6 @@ void xen_uninit_lock_cpu(int cpu)
 
 	unbind_from_irqhandler(irq, NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
-	kfree(per_cpu(irq_name, cpu));
-	per_cpu(irq_name, cpu) = NULL;
 }
 
 
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 5b64d9d7d147..fc9362e0a118 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -380,7 +380,7 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct blk_mq_ctx *ctx;
-	int i, ret;
+	int i, j, ret;
 
 	if (!hctx->nr_ctx)
 		return 0;
@@ -392,9 +392,16 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 	hctx_for_each_ctx(hctx, ctx, i) {
 		ret = kobject_add(&ctx->kobj, &hctx->kobj, "cpu%u", ctx->cpu);
 		if (ret)
-			break;
+			goto out;
 	}
 
+	return 0;
+out:
+	hctx_for_each_ctx(hctx, ctx, j) {
+		if (j < i)
+			kobject_del(&ctx->kobj);
+	}
+	kobject_del(&hctx->kobj);
 	return ret;
 }
 
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 298c05f8b5e3..434c122cb958 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -254,6 +254,7 @@ void delete_partition(struct gendisk *disk, int partno)
 {
 	struct disk_part_tbl *ptbl = disk->part_tbl;
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	if (partno >= ptbl->len)
 		return;
@@ -267,6 +268,11 @@ void delete_partition(struct gendisk *disk, int partno)
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
+	bdev = bdget(part_devt(part));
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	hd_struct_kill(part);
 }
 
diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 2b3210f42a46..b77d6b86e3f9 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -547,7 +547,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
 	if (!info) {
 		status = AE_NO_MEMORY;
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	info->parameters = &this_walk_state->operands[0];
@@ -559,7 +559,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	ACPI_FREE(info);
 	if (ACPI_FAILURE(status)) {
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	/*
@@ -591,6 +591,12 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	return_ACPI_STATUS(status);
 
+pop_walk_state:
+
+	/* On error, pop the walk state to be deleted from thread */
+
+	acpi_ds_pop_walk_state(thread);
+
 cleanup:
 
 	/* On error, we must terminate the method properly */
diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index 82f971402d85..646e296e4c13 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -950,13 +950,6 @@ acpi_ut_copy_ipackage_to_ipackage(union acpi_operand_object *source_obj,
 	status = acpi_ut_walk_package_tree(source_obj, dest_obj,
 					   acpi_ut_copy_ielement_to_ielement,
 					   walk_state);
-	if (ACPI_FAILURE(status)) {
-
-		/* On failure, delete the destination package object */
-
-		acpi_ut_remove_reference(dest_obj);
-	}
-
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2069080191ee..532e492f92e0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -440,13 +440,13 @@ static inline void btusb_free_frags(struct btusb_data *data)
 
 	spin_lock_irqsave(&data->rxlock, flags);
 
-	kfree_skb(data->evt_skb);
+	dev_kfree_skb_irq(data->evt_skb);
 	data->evt_skb = NULL;
 
-	kfree_skb(data->acl_skb);
+	dev_kfree_skb_irq(data->acl_skb);
 	data->acl_skb = NULL;
 
-	kfree_skb(data->sco_skb);
+	dev_kfree_skb_irq(data->sco_skb);
 	data->sco_skb = NULL;
 
 	spin_unlock_irqrestore(&data->rxlock, flags);
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 26f9982bab26..2056d5c01afa 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -392,7 +392,7 @@ static void bcsp_pkt_cull(struct bcsp_struct *bcsp)
 		i++;
 
 		__skb_unlink(skb, &bcsp->unack);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 
 	if (skb_queue_empty(&bcsp->unack))
diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 0879d64b1caf..a947e3c0af18 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -266,7 +266,7 @@ static void h5_pkt_cull(struct h5 *h5)
 			break;
 
 		__skb_unlink(skb, &h5->unack);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 
 	if (skb_queue_empty(&h5->unack))
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 0986c324459f..af407cd8425f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -718,7 +718,7 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	default:
 		BT_ERR("Illegal tx state: %d (losing packet)",
 		       qca->tx_ibs_state);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	}
 
diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 9959c762da2f..db3dd467194c 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -143,15 +143,19 @@ static int __init mod_init(void)
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
 	if (err)
-		return err;
+		goto put_dev;
 
 	pmbase &= 0x0000FF00;
-	if (pmbase == 0)
-		return -EIO;
+	if (pmbase == 0) {
+		err = -EIO;
+		goto put_dev;
+	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
 
 	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
@@ -185,6 +189,8 @@ static int __init mod_init(void)
 	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -200,6 +206,8 @@ static void __exit mod_exit(void)
 
 	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 
+	pci_dev_put(priv->pcidev);
+
 	kfree(priv);
 }
 
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index e1d421a36a13..207272979f23 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -51,6 +51,10 @@ static const struct pci_device_id pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
+struct amd_geode_priv {
+	struct pci_dev *pcidev;
+	void __iomem *membase;
+};
 
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
@@ -90,6 +94,7 @@ static int __init mod_init(void)
 	const struct pci_device_id *ent;
 	void __iomem *mem;
 	unsigned long rng_base;
+	struct amd_geode_priv *priv;
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
@@ -97,17 +102,26 @@ static int __init mod_init(void)
 			goto found;
 	}
 	/* Device not found. */
-	goto out;
+	return err;
 
 found:
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
+
 	rng_base = pci_resource_start(pdev, 0);
 	if (rng_base == 0)
-		goto out;
+		goto free_priv;
 	err = -ENOMEM;
 	mem = ioremap(rng_base, 0x58);
 	if (!mem)
-		goto out;
-	geode_rng.priv = (unsigned long)mem;
+		goto free_priv;
+
+	geode_rng.priv = (unsigned long)priv;
+	priv->membase = mem;
+	priv->pcidev = pdev;
 
 	pr_info("AMD Geode RNG detected\n");
 	err = hwrng_register(&geode_rng);
@@ -116,20 +130,26 @@ static int __init mod_init(void)
 		       err);
 		goto err_unmap;
 	}
-out:
 	return err;
 
 err_unmap:
 	iounmap(mem);
-	goto out;
+free_priv:
+	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
+	return err;
 }
 
 static void __exit mod_exit(void)
 {
-	void __iomem *mem = (void __iomem *)geode_rng.priv;
+	struct amd_geode_priv *priv;
 
+	priv = (struct amd_geode_priv *)geode_rng.priv;
 	hwrng_unregister(&geode_rng);
-	iounmap(mem);
+	iounmap(priv->membase);
+	pci_dev_put(priv->pcidev);
+	kfree(priv);
 }
 
 module_init(mod_init);
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 74044b52d2c6..97d3c9d4ebc7 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2930,12 +2930,16 @@ static void deliver_smi_err_response(ipmi_smi_t intf,
 				     struct ipmi_smi_msg *msg,
 				     unsigned char err)
 {
+	int rv;
 	msg->rsp[0] = msg->data[0] | 4;
 	msg->rsp[1] = msg->data[1];
 	msg->rsp[2] = err;
 	msg->rsp_size = 3;
-	/* It's an error, so it will never requeue, no need to check return. */
-	handle_one_recv_msg(intf, msg);
+
+	/* This will never requeue, but it may ask us to free the message. */
+	rv = handle_one_recv_msg(intf, msg);
+	if (rv == 0)
+		ipmi_free_smi_msg(msg);
 }
 
 static void cleanup_smi_msgs(ipmi_smi_t intf)
diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index 9c1373e81683..347d659c8f34 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -957,6 +957,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	return mux_clk;
 
 err_pll:
+	kfree(pll->rate_table);
 	clk_unregister(mux_clk);
 	mux_clk = pll_clk;
 err_mux:
diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 14819d919df1..715c5d3a5cde 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -948,9 +948,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
 	clk = st_clk_register_quadfs_pll(pll_name, clk_parent_name, data,
 			reg, lock);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		kfree(lock);
 		goto err_exit;
-	else
+	} else
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
 			__clk_get_name(clk_get_parent(clk)),
diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
index ea11a33e7fff..1a79ac569770 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -218,6 +218,6 @@ int dt_init_idle_driver(struct cpuidle_driver *drv,
 	 * also be 0 on platforms with missing DT idle states or legacy DT
 	 * configuration predating the DT idle states bindings.
 	 */
-	return i;
+	return state_idx - start_idx;
 }
 EXPORT_SYMBOL_GPL(dt_init_idle_driver);
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index a2e77b87485b..157c8f5c879c 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -359,12 +359,16 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 static void img_hash_dma_task(unsigned long d)
 {
 	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
-	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
+	struct img_hash_request_ctx *ctx;
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
 	struct scatterlist tsg;
 
-	if (!hdev->req || !ctx->sg)
+	if (!hdev->req)
+		return;
+
+	ctx = ahash_request_ctx(hdev->req);
+	if (!ctx->sg)
 		return;
 
 	addr = sg_virt(ctx->sg);
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index b365ad78ac27..e06774968fbb 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1271,6 +1271,7 @@ struct n2_hash_tmpl {
 	const u32	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1302,6 +1303,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1310,6 +1312,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1318,6 +1321,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1326,6 +1330,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1465,6 +1470,7 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 55dd88d82d6d..e85895fc258d 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -109,6 +109,12 @@ static char dio_no_name[] = { 0 };
 
 #endif /* CONFIG_DIO_CONSTANTS */
 
+static void dio_dev_release(struct device *dev)
+{
+	struct dio_dev *ddev = container_of(dev, typeof(struct dio_dev), dev);
+	kfree(ddev);
+}
+
 int __init dio_find(int deviceid)
 {
 	/* Called to find a DIO device before the full bus scan has run.
@@ -234,6 +240,7 @@ static int __init dio_init(void)
 		dev->bus = &dio_bus;
 		dev->dev.parent = &dio_bus.dev;
 		dev->dev.bus = &dio_bus_type;
+		dev->dev.release = dio_dev_release;
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
@@ -261,6 +268,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 2b6afe123f3d..d6ecce5fe1a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -253,6 +253,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	adev->bios = kmalloc(size, GFP_KERNEL);
 	if (!adev->bios) {
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 0e934a9ac63c..86529c0b1ed4 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -363,6 +363,9 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 
diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
index e1dd75b18118..5993d6ac85e6 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
@@ -90,8 +90,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
 	return num_modes;
 }
 
-static int fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
-					    struct drm_display_mode *mode)
+static enum drm_mode_status
+fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
 {
 	if (mode->hdisplay & 0xf)
 		return MODE_ERROR;
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 21b6732425c5..82ea78fce748 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -215,6 +215,7 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	rdev->bios = kmalloc(size, GFP_KERNEL);
 	if (!rdev->bios) {
diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
index e8c1ed08a9f7..10e33a89b74c 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -296,7 +296,7 @@ static void sti_dvo_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&dvo->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&dvo->mode, mode);
 
 	/* According to the path used (main or aux), the dvo clocks should
 	 * have a different parent clock. */
@@ -354,8 +354,9 @@ static int sti_dvo_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_dvo_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_dvo_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 08808e3701de..1c36758660f5 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -528,7 +528,7 @@ static void sti_hda_set_mode(struct drm_bridge *bridge,
 
 	DRM_DEBUG_DRIVER("\n");
 
-	memcpy(&hda->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hda->mode, mode);
 
 	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
 		DRM_ERROR("Undefined mode\n");
@@ -606,8 +606,9 @@ static int sti_hda_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hda_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hda_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index a5412a6fbeca..28186bcc8139 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -848,7 +848,7 @@ static void sti_hdmi_set_mode(struct drm_bridge *bridge,
 	DRM_DEBUG_DRIVER("\n");
 
 	/* Copy the drm display mode in the connector local structure */
-	memcpy(&hdmi->mode, mode, sizeof(struct drm_display_mode));
+	drm_mode_copy(&hdmi->mode, mode);
 
 	/* Update clock framerate according to the selected mode */
 	ret = clk_set_rate(hdmi->clk_pix, mode->clock * 1000);
@@ -906,8 +906,9 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hdmi_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hdmi_connector_mode_valid(struct drm_connector *connector,
+			      struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 39ac7566b705..e6403311ff93 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -301,7 +301,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1f641870d860..4d69551dbc52 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -816,7 +816,10 @@
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index 460711c1124a..3b75cadd543f 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -201,9 +201,18 @@ static int plantronics_probe(struct hid_device *hdev,
 }
 
 static const struct hid_device_id plantronics_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
 					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES),
 		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };
diff --git a/drivers/hid/hid-sensor-custom.c b/drivers/hid/hid-sensor-custom.c
index 3a84aaf1418b..683bfcb41926 100644
--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -67,7 +67,7 @@ struct hid_sensor_sample {
 	u32 raw_len;
 } __packed;
 
-static struct attribute hid_custom_attrs[] = {
+static struct attribute hid_custom_attrs[HID_CUSTOM_TOTAL_ATTRS] = {
 	{.name = "name", .mode = S_IRUGO},
 	{.name = "units", .mode = S_IRUGO},
 	{.name = "unit-expo", .mode = S_IRUGO},
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index b74fcda49a22..9b7195283268 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -69,6 +69,9 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 
+	if (wacom->wacom_wac.features.type == BOOTLOADER)
+		return 0;
+
 	if (size > WACOM_PKGLEN_MAX)
 		return 1;
 
@@ -2409,6 +2412,11 @@ static int wacom_probe(struct hid_device *hdev,
 		goto fail;
 	}
 
+	if (features->type == BOOTLOADER) {
+		hid_warn(hdev, "Using device in hidraw-only mode");
+		return hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	}
+
 	error = wacom_parse_and_register(wacom, false);
 	if (error)
 		goto fail;
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index bfce62dbe0ac..2d9800edda92 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3550,6 +3550,9 @@ static const struct wacom_features wacom_features_0x343 =
 static const struct wacom_features wacom_features_HID_ANY_ID =
 	{ "Wacom HID", .type = HID_GENERIC, .oVid = HID_ANY_ID, .oPid = HID_ANY_ID };
 
+static const struct wacom_features wacom_features_0x94 =
+	{ "Wacom Bootloader", .type = BOOTLOADER };
+
 #define USB_DEVICE_WACOM(prod)						\
 	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -3623,6 +3626,7 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x84) },
 	{ USB_DEVICE_WACOM(0x90) },
 	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x94) },
 	{ USB_DEVICE_WACOM(0x97) },
 	{ USB_DEVICE_WACOM(0x9A) },
 	{ USB_DEVICE_WACOM(0x9F) },
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 324c40b0c119..ccdfe3c40708 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -154,6 +154,7 @@ enum {
 	MTTPC,
 	MTTPC_B,
 	HID_GENERIC,
+	BOOTLOADER,
 	MAX_TYPE
 };
 
diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 56de30c25063..c885c3bc2e85 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -540,8 +540,10 @@ static int ssi_probe(struct platform_device *pd)
 	platform_set_drvdata(pd, ssi);
 
 	err = ssi_add_controller(ssi, pd);
-	if (err < 0)
+	if (err < 0) {
+		hsi_put_controller(ssi);
 		goto out1;
+	}
 
 	pm_runtime_enable(&pd->dev);
 
@@ -574,9 +576,9 @@ static int ssi_probe(struct platform_device *pd)
 	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
 out2:
 	ssi_remove_controller(ssi);
+	pm_runtime_disable(&pd->dev);
 out1:
 	platform_set_drvdata(pd, NULL);
-	pm_runtime_disable(&pd->dev);
 
 	return err;
 }
@@ -667,7 +669,13 @@ static int __init ssi_init(void) {
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&ssi_port_pdriver);
+	ret = platform_driver_register(&ssi_port_pdriver);
+	if (ret) {
+		platform_driver_unregister(&ssi_pdriver);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(ssi_init);
 
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index b51adffa4841..e689c7acea62 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -495,6 +495,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 		if (read_write == I2C_SMBUS_WRITE) {
 			/* Block Write */
 			dev_dbg(dev, "I2C_SMBUS_BLOCK_DATA:  WRITE\n");
+			if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
+				return -EINVAL;
+
 			dma_size = data->block[0] + 1;
 			dma_direction = DMA_TO_DEVICE;
 			desc->wr_len_cmd = dma_size;
diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 417464e9ea2a..3113b06b4fc1 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -101,7 +101,7 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 	int i;
 	struct ce4100_devices *sds;
 
-	ret = pci_enable_device_mem(dev);
+	ret = pcim_enable_device(dev);
 	if (ret)
 		return ret;
 
@@ -110,10 +110,8 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 		return -EINVAL;
 	}
 	sds = kzalloc(sizeof(*sds), GFP_KERNEL);
-	if (!sds) {
-		ret = -ENOMEM;
-		goto err_mem;
-	}
+	if (!sds)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(sds->pdev); i++) {
 		sds->pdev[i] = add_i2c_device(dev, i);
@@ -129,8 +127,6 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 
 err_dev_add:
 	kfree(sds);
-err_mem:
-	pci_disable_device(dev);
 	return ret;
 }
 
diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 30f200ad6b97..0832402c964f 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -282,10 +282,10 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	unsigned int sample, raw_sample;
 	int ret = 0;
 
-	if (iio_buffer_enabled(indio_dev))
-		return -EBUSY;
+	ret = iio_device_claim_direct_mode(indio_dev);
+	if (ret)
+		return ret;
 
-	mutex_lock(&indio_dev->mlock);
 	ad_sigma_delta_set_channel(sigma_delta, chan->address);
 
 	spi_bus_lock(sigma_delta->spi->master);
@@ -319,7 +319,7 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->master);
-	mutex_unlock(&indio_dev->mlock);
+	iio_device_release_direct_mode(indio_dev);
 
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index cdc7df4fdb8a..20a6d1071014 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -42,6 +42,11 @@ static const struct nla_policy ipoib_policy[IFLA_IPOIB_MAX + 1] = {
 	[IFLA_IPOIB_UMCAST]	= { .type = NLA_U16 },
 };
 
+static unsigned int ipoib_get_max_num_queues(void)
+{
+	return min_t(unsigned int, num_possible_cpus(), 128);
+}
+
 static int ipoib_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -167,6 +172,8 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.dellink	= ipoib_unregister_child_dev,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
+	.get_num_rx_queues = ipoib_get_max_num_queues,
+	.get_num_tx_queues = ipoib_get_max_num_queues,
 };
 
 int __init ipoib_netlink_init(void)
diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index 3e6003d32e56..184310a2ba69 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -1088,14 +1088,12 @@ static int elants_i2c_power_on(struct elants_data *ts)
 	if (IS_ERR_OR_NULL(ts->reset_gpio))
 		return 0;
 
-	gpiod_set_value_cansleep(ts->reset_gpio, 1);
-
 	error = regulator_enable(ts->vcc33);
 	if (error) {
 		dev_err(&ts->client->dev,
 			"failed to enable vcc33 regulator: %d\n",
 			error);
-		goto release_reset_gpio;
+		return error;
 	}
 
 	error = regulator_enable(ts->vccio);
@@ -1104,7 +1102,7 @@ static int elants_i2c_power_on(struct elants_data *ts)
 			"failed to enable vccio regulator: %d\n",
 			error);
 		regulator_disable(ts->vcc33);
-		goto release_reset_gpio;
+		return error;
 	}
 
 	/*
@@ -1113,7 +1111,6 @@ static int elants_i2c_power_on(struct elants_data *ts)
 	 */
 	udelay(ELAN_POWERON_DELAY_USEC);
 
-release_reset_gpio:
 	gpiod_set_value_cansleep(ts->reset_gpio, 0);
 	if (error)
 		return error;
@@ -1182,7 +1179,7 @@ static int elants_i2c_probe(struct i2c_client *client,
 		return error;
 	}
 
-	ts->reset_gpio = devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_LOW);
+	ts->reset_gpio = devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(ts->reset_gpio)) {
 		error = PTR_ERR(ts->reset_gpio);
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 03bf538eabda..9ebbd54f8f34 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2684,6 +2684,13 @@ static int __init parse_ivrs_acpihid(char *str)
 		return 1;
 	}
 
+	/*
+	 * Ignore leading zeroes after ':', so e.g., AMDI0095:00
+	 * will match AMDI0095:0 in the second strcmp in acpi_dev_hid_uid_match
+	 */
+	while (*uid == '0' && *(uid + 1))
+		uid++;
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index a34355fca37a..4d6bdc465dde 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -1131,7 +1131,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
 		if (ret) {
 			dev_err(dev, "could not create coherence subdomain\n");
-			return ret;
+			goto error;
 		}
 	}
 
diff --git a/drivers/irqchip/irq-gic-pm.c b/drivers/irqchip/irq-gic-pm.c
index ecafd295c31c..21c5decfc55b 100644
--- a/drivers/irqchip/irq-gic-pm.c
+++ b/drivers/irqchip/irq-gic-pm.c
@@ -112,7 +112,7 @@ static int gic_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		goto rpm_disable;
 
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 8feb8e9e29a6..decec530bdf4 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3234,6 +3234,7 @@ static int
 hfcm_l1callback(struct dchannel *dch, u_int cmd)
 {
 	struct hfc_multi	*hc = dch->hw;
+	struct sk_buff_head	free_queue;
 	u_long	flags;
 
 	switch (cmd) {
@@ -3262,6 +3263,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		l1_event(dch->l1, HW_POWERUP_IND);
 		break;
 	case HW_DEACT_REQ:
+		__skb_queue_head_init(&free_queue);
 		/* start deactivation */
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->ctype == HFC_TYPE_E1) {
@@ -3281,20 +3283,21 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 				plxsd_checksync(hc, 0);
 			}
 		}
-		skb_queue_purge(&dch->squeue);
+		skb_queue_splice_init(&dch->squeue, &free_queue);
 		if (dch->tx_skb) {
-			dev_kfree_skb(dch->tx_skb);
+			__skb_queue_tail(&free_queue, dch->tx_skb);
 			dch->tx_skb = NULL;
 		}
 		dch->tx_idx = 0;
 		if (dch->rx_skb) {
-			dev_kfree_skb(dch->rx_skb);
+			__skb_queue_tail(&free_queue, dch->rx_skb);
 			dch->rx_skb = NULL;
 		}
 		test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
 		if (test_and_clear_bit(FLG_BUSY_TIMER, &dch->Flags))
 			del_timer(&dch->timer);
 		spin_unlock_irqrestore(&hc->lock, flags);
+		__skb_queue_purge(&free_queue);
 		break;
 	case HW_POWERUP_REQ:
 		spin_lock_irqsave(&hc->lock, flags);
@@ -3401,6 +3404,9 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 	case PH_DEACTIVATE_REQ:
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		if (dch->dev.D.protocol != ISDN_P_TE_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			spin_lock_irqsave(&hc->lock, flags);
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
@@ -3422,14 +3428,14 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 				/* deactivate */
 				dch->state = 1;
 			}
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -3441,6 +3447,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 #endif
 			ret = 0;
 			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else
 			ret = l1_event(dch->l1, hh->prim);
 		break;
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 89cf1d695a01..e33b58f560bf 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1631,16 +1631,19 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->hw.protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			/* prepare deactivation */
 			Write_hfc(hc, HFCPCI_STATES, 0x40);
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -1653,10 +1656,12 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			hc->hw.mst_m &= ~HFCPCI_MASTER;
 			Write_hfc(hc, HFCPCI_MST_MODE, hc->hw.mst_m);
 			ret = 0;
+			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else {
 			ret = l1_event(dch->l1, hh->prim);
+			spin_unlock_irqrestore(&hc->lock, flags);
 		}
-		spin_unlock_irqrestore(&hc->lock, flags);
 		break;
 	}
 	if (!ret)
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 726fba452f5f..4c49ef9fc391 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -337,20 +337,24 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 
 		if (hw->protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			hfcsusb_ph_command(hw, HFC_L1_DEACTIVATE_NT);
 			spin_lock_irqsave(&hw->lock, flags);
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
 			spin_unlock_irqrestore(&hw->lock, flags);
+			__skb_queue_purge(&free_queue);
 #ifdef FIXME
 			if (test_and_clear_bit(FLG_L1_BUSY, &dch->Flags))
 				dchannel_sched_event(&hc->dch, D_CLEARBUSY);
@@ -1340,7 +1344,7 @@ tx_iso_complete(struct urb *urb)
 					printk("\n");
 				}
 
-				dev_kfree_skb(tx_skb);
+				dev_consume_skb_irq(tx_skb);
 				tx_skb = NULL;
 				if (fifo->dch && get_next_dframe(fifo->dch))
 					tx_skb = fifo->dch->tx_skb;
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index 87de8d9bcfad..e620c50768cd 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -106,6 +106,10 @@ int macio_init(void)
 		return -ENXIO;
 	}
 	adb = ioremap(r.start, sizeof(struct adb_regs));
+	if (!adb) {
+		of_node_put(adbs);
+		return -ENOMEM;
+	}
 
 	out_8(&adb->ctrl.r, 0);
 	out_8(&adb->intr.r, 0);
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 3f041b187033..04da09af5531 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -425,7 +425,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	if (of_device_register(&dev->ofdev) != 0) {
 		printk(KERN_DEBUG"macio: device registration error for %s!\n",
 		       dev_name(&dev->ofdev.dev));
-		kfree(dev);
+		put_device(&dev->ofdev.dev);
 		return NULL;
 	}
 
diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index 96801137a144..80e70d9fd402 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -74,8 +74,10 @@ static int mcb_probe(struct device *dev)
 
 	get_device(dev);
 	ret = mdrv->probe(mdev, found_id);
-	if (ret)
+	if (ret) {
 		module_put(carrier_mod);
+		put_device(dev);
+	}
 
 	return ret;
 }
diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index 4ca2739b4fad..fdc35341ff6c 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -107,7 +107,7 @@ static int chameleon_parse_gdd(struct mcb_bus *bus,
 	return 0;
 
 err:
-	mcb_free_dev(mdev);
+	put_device(&mdev->dev);
 
 	return ret;
 }
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index a9208ab12708..16925d16906b 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -522,11 +522,13 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd)
+static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(cmd->metadata_sm);
 	dm_tm_destroy(cmd->tm);
-	dm_block_manager_destroy(cmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(cmd->bm);
 }
 
 typedef unsigned long (*flags_mutator)(unsigned long);
@@ -780,7 +782,7 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
 		cmd2 = lookup(bdev);
 		if (cmd2) {
 			mutex_unlock(&table_lock);
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 			kfree(cmd);
 			return cmd2;
 		}
@@ -827,7 +829,7 @@ void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 		mutex_unlock(&table_lock);
 
 		if (!cmd->fail_io)
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 		kfree(cmd);
 	}
 }
@@ -1551,14 +1553,53 @@ int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result)
 
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 {
-	int r;
+	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with cmd->root_lock held below */
+	if (unlikely(cmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
+	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 CACHE_METADATA_CACHE_SIZE,
+					 CACHE_MAX_CONCURRENT_LOCKS);
 
 	WRITE_LOCK(cmd);
-	__destroy_persistent_data_objects(cmd);
-	r = __create_persistent_data_objects(cmd, false);
+	if (cmd->fail_io) {
+		WRITE_UNLOCK(cmd);
+		goto out;
+	}
+
+	__destroy_persistent_data_objects(cmd, false);
+	old_bm = cmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		cmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	cmd->bm = new_bm;
+	r = __open_or_format_metadata(cmd, false);
+	if (r) {
+		cmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		cmd->fail_io = true;
 	WRITE_UNLOCK(cmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1b7d77080d6b..5979fc3c01d7 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1030,16 +1030,16 @@ static void abort_transaction(struct cache *cache)
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return;
 
-	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
-		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
-		set_cache_mode(cache, CM_FAIL);
-	}
-
 	DMERR_LIMIT("%s: aborting current metadata transaction", dev_name);
 	if (dm_cache_metadata_abort(cache->cmd)) {
 		DMERR("%s: failed to abort metadata transaction", dev_name);
 		set_cache_mode(cache, CM_FAIL);
 	}
+
+	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
+		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
+		set_cache_mode(cache, CM_FAIL);
+	}
 }
 
 static void metadata_operation_failed(struct cache *cache, const char *op, int r)
@@ -2321,6 +2321,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b5bf2ecfaf91..0b56c8412fdf 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -661,6 +661,15 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 		goto bad_cleanup_data_sm;
 	}
 
+	/*
+	 * For pool metadata opening process, root setting is redundant
+	 * because it will be set again in __begin_transaction(). But dm
+	 * pool aborting process really needs to get last transaction's
+	 * root to avoid accessing broken btree.
+	 */
+	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
+	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index dcb753dbf86e..eb359e507391 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2935,6 +2935,8 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9e8373e7e287..4d33f5fcfed6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -360,13 +360,14 @@ static void md_end_flush(struct bio *bio)
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
+	bio_put(bio);
+
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
-	bio_put(bio);
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -725,10 +726,12 @@ static void super_written(struct bio *bio)
 		md_error(mddev, rdev);
 	}
 
+	bio_put(bio);
+
+	rdev_dec_pending(rdev, mddev);
+
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
-	rdev_dec_pending(rdev, mddev);
-	bio_put(bio);
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8a50da4f148f..26ae749184da 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2964,6 +2964,7 @@ static int raid1_run(struct mddev *mddev)
 	 * RAID1 needs at least one disk in active
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
+		md_unregister_thread(&conf->thread);
 		ret = -EINVAL;
 		goto abort;
 	}
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index fb1284051d05..d3a0b293fddd 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -317,6 +317,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index bb698839e477..fc1dbdfb0cba 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -648,6 +648,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 		deb_info("firmware chunk, addr: 0x%04x, len: 0x%04x, total length: 0x%04zx\n",addr,len,fw->size);
 		if ((ret = bcm3510_write_ram(st,addr,&b[i+4],len)) < 0) {
 			err("firmware download failed: %d\n",ret);
+			release_firmware(fw);
 			return ret;
 		}
 		i += 4 + len;
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 2b8c75f28d2e..a79483c2771b 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -452,9 +452,8 @@ static int stv0288_set_frontend(struct dvb_frontend *fe)
 	struct stv0288_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	char tm;
-	unsigned char tda[3];
-	u8 reg, time_out = 0;
+	u8 tda[3], reg, time_out = 0;
+	s8 tm;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index beab2f381b81..84e378cbc726 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -320,18 +320,18 @@ static int ad5820_probe(struct i2c_client *client,
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
 	if (ret < 0)
-		goto cleanup2;
+		goto clean_mutex;
 
 	ret = v4l2_async_register_subdev(&coil->subdev);
 	if (ret < 0)
-		goto cleanup;
+		goto clean_entity;
 
 	return ret;
 
-cleanup2:
-	mutex_destroy(&coil->power_lock);
-cleanup:
+clean_entity:
 	media_entity_cleanup(&coil->subdev.entity);
+clean_mutex:
+	mutex_destroy(&coil->power_lock);
 	return ret;
 }
 
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 8bbd092fbe1d..d0ad0f5ba035 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1250,7 +1250,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	if (saa7164_dev_setup(dev) < 0) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_dev;
 	}
 
 	/* print pci info */
@@ -1422,6 +1422,8 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 fail_irq:
 	saa7164_dev_unregister(dev);
+fail_dev:
+	pci_disable_device(pci_dev);
 fail_free:
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index f50d07229236..fc45d4aeb77e 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -428,6 +428,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		     solo_dev->nr_chans);
 
 	if (device_register(dev)) {
+		put_device(dev);
 		dev->parent = NULL;
 		return -ENOMEM;
 	}
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 7b4c93619c3d..a933c0cb24de 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -595,7 +595,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		/* Only H.264BP and H.263P3 are considered */
 		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w64);
 		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w64);
-		if (!iram_info->buf_dbk_c_use)
+		if (!iram_info->buf_dbk_y_use || !iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
@@ -619,7 +619,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w128);
 		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w128);
-		if (!iram_info->buf_dbk_c_use)
+		if (!iram_info->buf_dbk_y_use || !iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
@@ -821,10 +821,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	if (dst_fourcc == V4L2_PIX_FMT_JPEG) {
-		if (!ctx->params.jpeg_qmat_tab[0])
+		if (!ctx->params.jpeg_qmat_tab[0]) {
 			ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
-		if (!ctx->params.jpeg_qmat_tab[1])
+			if (!ctx->params.jpeg_qmat_tab[0])
+				return -ENOMEM;
+		}
+		if (!ctx->params.jpeg_qmat_tab[1]) {
 			ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+			if (!ctx->params.jpeg_qmat_tab[1])
+				return -ENOMEM;
+		}
 		coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
 	}
 
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 8f89ca21b631..b86d6f724618 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1245,7 +1245,7 @@ int __init fimc_register_driver(void)
 	return platform_driver_register(&fimc_driver);
 }
 
-void __exit fimc_unregister_driver(void)
+void fimc_unregister_driver(void)
 {
 	platform_driver_unregister(&fimc_driver);
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a1599659b88b..75f6f7acc46b 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1559,7 +1559,11 @@ static int __init fimc_md_init(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&fimc_md_driver);
+	ret = platform_driver_register(&fimc_md_driver);
+	if (ret)
+		fimc_unregister_driver();
+
+	return ret;
 }
 
 static void __exit fimc_md_exit(void)
diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 06e2cfd09855..c79dcc497e13 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -953,6 +953,7 @@ static int configure_channels(struct c8sectpfei *fei)
 		if (ret) {
 			dev_err(fei->dev,
 				"configure_memdma_and_inputblock failed\n");
+			of_node_put(child);
 			goto err_unmap;
 		}
 		index++;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 198b26687b57..b7bda691fa57 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -915,6 +915,7 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			if (dev->has_compose_cap) {
 				v4l2_rect_set_min_size(compose, &min_rect);
 				v4l2_rect_set_max_size(compose, &max_rect);
+				v4l2_rect_map_inside(compose, &fmt);
 			}
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index a8a0ff9a1f83..6724c5287cc3 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -741,8 +741,10 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 
 	/* start radio */
 	retval = si470x_start_usb(radio);
-	if (retval < 0)
+	if (retval < 0 && !radio->int_in_running)
 		goto err_buf;
+	else if (retval < 0)	/* in case of radio->int_in_running == 1 */
+		goto err_all;
 
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 0b386fd518cc..9c644b4fb22d 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -622,15 +622,14 @@ static int send_packet(struct imon_context *ictx)
 		pr_err_ratelimited("error submitting urb(%d)\n", retval);
 	} else {
 		/* Wait for transmission to complete (or abort) */
-		mutex_unlock(&ictx->lock);
 		retval = wait_for_completion_interruptible(
 				&ictx->tx.finished);
 		if (retval) {
 			usb_kill_urb(ictx->tx_urb);
 			pr_err_ratelimited("task interrupted\n");
 		}
-		mutex_lock(&ictx->lock);
 
+		ictx->tx.busy = false;
 		retval = ictx->tx.status;
 		if (retval)
 			pr_err_ratelimited("packet tx failed (%d)\n", retval);
@@ -939,7 +938,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 		return -ENODEV;
 	}
 
-	mutex_lock(&ictx->lock);
+	if (mutex_lock_interruptible(&ictx->lock))
+		return -ERESTARTSYS;
 
 	if (!ictx->dev_present_intf0) {
 		pr_err_ratelimited("no iMON device present\n");
diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 382c8075ef52..f2b5ba1d2809 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -978,6 +978,10 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 		if (msg[i].addr == 0x99) {
 			req = 0xBE;
 			index = 0;
+			if (msg[i].len < 1) {
+				i = -EOPNOTSUPP;
+				break;
+			}
 			value = msg[i].buf[0] & 0x00ff;
 			length = 1;
 			az6027_usb_out_op(d, req, value, index, data, length);
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 690c1e06fbfa..28077f3c9edf 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -84,7 +84,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 		ret = dvb_usb_adapter_stream_init(adap);
 		if (ret)
-			return ret;
+			goto stream_init_err;
 
 		ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs);
 		if (ret)
@@ -117,6 +117,8 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	dvb_usb_adapter_dvb_exit(adap);
 dvb_init_err:
 	dvb_usb_adapter_stream_exit(adap);
+stream_init_err:
+	kfree(adap->priv);
 	return ret;
 }
 
diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index d08509cd978a..2cefe1f3ce7e 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -969,10 +969,10 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/*
 	 * pHyp doesn't expose the programming models supported by the
@@ -988,7 +988,7 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 		afu->modes_supported = CXL_MODE_DIRECTED;
 
 	if ((rc = cxl_afu_select_best_mode(afu)))
-		goto err_put2;
+		goto err_remove_sysfs;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1008,10 +1008,12 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 
 	return 0;
 
-err_put2:
+err_remove_sysfs:
 	cxl_sysfs_afu_remove(afu);
-err_put1:
-	device_unregister(&afu->dev);
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
+	put_device(&afu->dev);
 	free = false;
 	guest_release_serr_irq(afu);
 err2:
@@ -1145,18 +1147,20 @@ struct cxl *cxl_guest_init_adapter(struct device_node *np, struct platform_devic
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* release the context lock as the adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
-	device_unregister(&adapter->dev);
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
+	put_device(&adapter->dev);
 	free = false;
 	cxl_guest_remove_chardev(adapter);
 err1:
diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index a5422f483ad5..f7417033a7a8 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -1187,10 +1187,10 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1199,10 +1199,12 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 
 	return 0;
 
-err_put1:
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
 	pci_deconfigure_afu(afu);
 	cxl_debugfs_afu_remove(afu);
-	device_unregister(&afu->dev);
+	put_device(&afu->dev);
 	return rc;
 
 err_free_native:
@@ -1589,23 +1591,25 @@ static struct cxl *cxl_pci_init_adapter(struct pci_dev *dev)
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* Release the context lock as adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
 	/* This should mirror cxl_remove_adapter, except without the
 	 * sysfs parts
 	 */
 	cxl_debugfs_adapter_remove(adapter);
 	cxl_deconfigure_adapter(adapter);
-	device_unregister(&adapter->dev);
+	put_device(&adapter->dev);
 	return ERR_PTR(rc);
 
 err_release:
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 6fb773dbcd0c..a43a496ca9b9 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -656,6 +656,7 @@ int gru_handle_user_call_os(unsigned long cb)
 	if ((cb & (GRU_HANDLE_STRIDE - 1)) || ucbnum >= GRU_NUM_CB)
 		return -EINVAL;
 
+again:
 	gts = gru_find_lock_gts(cb);
 	if (!gts)
 		return -EINVAL;
@@ -664,7 +665,11 @@ int gru_handle_user_call_os(unsigned long cb)
 	if (ucbnum >= gts->ts_cbr_au_count * GRU_CBR_AU_SIZE)
 		goto exit;
 
-	gru_check_context_placement(gts);
+	if (gru_check_context_placement(gts)) {
+		gru_unlock_gts(gts);
+		gru_unload_context(gts, 1);
+		goto again;
+	}
 
 	/*
 	 * CCH may contain stale data if ts_force_cch_reload is set.
@@ -882,7 +887,11 @@ int gru_set_context_option(unsigned long arg)
 		} else {
 			gts->ts_user_blade_id = req.val1;
 			gts->ts_user_chiplet_id = req.val0;
-			gru_check_context_placement(gts);
+			if (gru_check_context_placement(gts)) {
+				gru_unlock_gts(gts);
+				gru_unload_context(gts, 1);
+				return ret;
+			}
 		}
 		break;
 	case sco_gseg_owner:
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index 33741ad4a74a..bc2d5233660c 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -729,9 +729,10 @@ static int gru_check_chiplet_assignment(struct gru_state *gru,
  * chiplet. Misassignment can occur if the process migrates to a different
  * blade or if the user changes the selected blade/chiplet.
  */
-void gru_check_context_placement(struct gru_thread_state *gts)
+int gru_check_context_placement(struct gru_thread_state *gts)
 {
 	struct gru_state *gru;
+	int ret = 0;
 
 	/*
 	 * If the current task is the context owner, verify that the
@@ -739,15 +740,23 @@ void gru_check_context_placement(struct gru_thread_state *gts)
 	 * references. Pthread apps use non-owner references to the CBRs.
 	 */
 	gru = gts->ts_gru;
+	/*
+	 * If gru or gts->ts_tgid_owner isn't initialized properly, return
+	 * success to indicate that the caller does not need to unload the
+	 * gru context.The caller is responsible for their inspection and
+	 * reinitialization if needed.
+	 */
 	if (!gru || gts->ts_tgid_owner != current->tgid)
-		return;
+		return ret;
 
 	if (!gru_check_chiplet_assignment(gru, gts)) {
 		STAT(check_context_unload);
-		gru_unload_context(gts, 1);
+		ret = -EINVAL;
 	} else if (gru_retarget_intr(gts)) {
 		STAT(check_context_retarget_intr);
 	}
+
+	return ret;
 }
 
 
@@ -946,7 +955,12 @@ int gru_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	mutex_lock(&gts->ts_ctxlock);
 	preempt_disable();
 
-	gru_check_context_placement(gts);
+	if (gru_check_context_placement(gts)) {
+		preempt_enable();
+		mutex_unlock(&gts->ts_ctxlock);
+		gru_unload_context(gts, 1);
+		return VM_FAULT_NOPAGE;
+	}
 
 	if (!gts->ts_gru) {
 		STAT(load_user_context);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 5c3ce2459675..a1dfca557fc3 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -651,7 +651,7 @@ extern int gru_user_flush_tlb(unsigned long arg);
 extern int gru_user_unload_context(unsigned long arg);
 extern int gru_get_exception_detail(unsigned long arg);
 extern int gru_set_context_option(unsigned long address);
-extern void gru_check_context_placement(struct gru_thread_state *gts);
+extern int gru_check_context_placement(struct gru_thread_state *gts);
 extern int gru_cpu_fault_map_id(void);
 extern struct vm_area_struct *gru_find_vma(unsigned long vaddr);
 extern void gru_flush_all_tlb(struct gru_state *gru);
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index a37a42f67088..8498282d1212 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -194,7 +194,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 				spin_unlock_irqrestore(&fm->lock, flags);
 			}
 			if (sock)
-				tifm_free_device(&sock->dev);
+				put_device(&sock->dev);
 		}
 		spin_lock_irqsave(&fm->lock, flags);
 	}
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index df990bb8c873..347dffaea105 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1718,7 +1718,9 @@ static int mmci_probe(struct amba_device *dev,
 	pm_runtime_set_autosuspend_delay(&dev->dev, 50);
 	pm_runtime_use_autosuspend(&dev->dev);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto clk_disable;
 
 	pm_runtime_put(&dev->dev);
 	return 0;
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 4f8588c3bf53..48645b736ba5 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -662,7 +662,9 @@ static int moxart_probe(struct platform_device *pdev)
 		goto out;
 
 	dev_set_drvdata(dev, mmc);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out;
 
 	dev_dbg(dev, "IRQ=%d, FIFO is %d bytes\n", irq, host->fifo_width);
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index fb3ca8296273..2c57cccb0fa1 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1159,7 +1159,9 @@ static int mxcmci_probe(struct platform_device *pdev)
 	host->watchdog.function = &mxcmci_watchdog;
 	host->watchdog.data = (unsigned long)mmc;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out_free_dma;
 
 	return 0;
 
diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 6e9c0f8fddb1..817fbf510d1e 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1355,6 +1355,7 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 #ifdef RTSX_USB_USE_LEDS_CLASS
 	int err;
 #endif
+	int ret;
 
 	ucr = usb_get_intfdata(to_usb_interface(pdev->dev.parent));
 	if (!ucr)
@@ -1391,7 +1392,15 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 	INIT_WORK(&host->led_work, rtsx_usb_update_led);
 
 #endif
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+#ifdef RTSX_USB_USE_LEDS_CLASS
+		led_classdev_unregister(&host->led);
+#endif
+		mmc_free_host(mmc);
+		pm_runtime_disable(&pdev->dev);
+		return ret;
+	}
 
 	return 0;
 }
diff --git a/drivers/mmc/host/sdhci_f_sdh30.c b/drivers/mmc/host/sdhci_f_sdh30.c
index 111b66f5439b..43e787954293 100644
--- a/drivers/mmc/host/sdhci_f_sdh30.c
+++ b/drivers/mmc/host/sdhci_f_sdh30.c
@@ -180,6 +180,9 @@ static int sdhci_f_sdh30_probe(struct platform_device *pdev)
 	if (reg & SDHCI_CAN_DO_8BIT)
 		priv->vendor_hs200 = F_SDH30_EMMC_HS200;
 
+	if (!(reg & SDHCI_TIMEOUT_CLK_MASK))
+		host->quirks |= SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto err_add_host;
diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
index 553ef41bb806..c0d3b289d8d4 100644
--- a/drivers/mmc/host/toshsd.c
+++ b/drivers/mmc/host/toshsd.c
@@ -655,7 +655,9 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto unmap;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto free_irq;
 
 	base = pci_resource_start(pdev, 0);
 	dev_dbg(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);
@@ -664,6 +666,8 @@ static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+free_irq:
+	free_irq(pdev->irq, host);
 unmap:
 	pci_iounmap(pdev, host->ioaddr);
 release:
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index a3472127bea3..74ac1ac55f42 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1162,7 +1162,9 @@ static int via_sd_probe(struct pci_dev *pcidev,
 	    pcidev->subsystem_device == 0x3891)
 		sdhost->quirks = VIA_CRDR_QUIRK_300MS_PWRDELAY;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto unmap;
 
 	return 0;
 
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 875e438ab973..58d3a22ba8dc 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2056,6 +2056,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 		return;
 	kref_get(&vub300->kref);
 	if (enable) {
+		set_current_state(TASK_RUNNING);
 		mutex_lock(&vub300->irq_mutex);
 		if (vub300->irqs_queued) {
 			vub300->irqs_queued -= 1;
@@ -2071,6 +2072,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 			vub300_queue_poll_work(vub300, 0);
 		}
 		mutex_unlock(&vub300->irq_mutex);
+		set_current_state(TASK_INTERRUPTIBLE);
 	} else {
 		vub300->irq_enabled = 0;
 	}
@@ -2312,14 +2314,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error4;
+		goto error5;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
 		vub300->read_only =
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
-		goto error4;
+		goto error5;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2345,8 +2347,13 @@ static int vub300_probe(struct usb_interface *interface,
 			 "USB vub300 remote SDIO host controller[%d]"
 			 "connected with no SD/SDIO card inserted\n",
 			 interface_to_InterfaceNumber(interface));
-	mmc_add_host(mmc);
+	retval = mmc_add_host(mmc);
+	if (retval)
+		goto error6;
+
 	return 0;
+error6:
+	del_timer_sync(&vub300->inactivity_timer);
 error5:
 	mmc_free_host(mmc);
 	/*
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index c3fd16d997ca..402b044c9a0b 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1712,7 +1712,17 @@ static int wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	wbsd_init_device(host);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		if (!pnp)
+			wbsd_chip_poweroff(host);
+
+		wbsd_release_resources(host);
+		wbsd_free_mmc(dev);
+
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	pr_info("%s: W83L51xD", mmc_hostname(mmc));
 	if (host->chip_id != 0)
diff --git a/drivers/mtd/lpddr/lpddr2_nvm.c b/drivers/mtd/lpddr/lpddr2_nvm.c
index 5e36366d9b36..19b00225c7ef 100644
--- a/drivers/mtd/lpddr/lpddr2_nvm.c
+++ b/drivers/mtd/lpddr/lpddr2_nvm.c
@@ -448,6 +448,8 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 
 	/* lpddr2_nvm address range */
 	add_range = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!add_range)
+		return -ENODEV;
 
 	/* Populate map_info data structure */
 	*map = (struct map_info) {
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 2cde28ed95c9..59d2fe1f46e1 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -69,6 +69,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 	if (!info->map.virt) {
 		printk(KERN_WARNING "Failed to ioremap %s\n",
 		       info->map.name);
+		kfree(info);
 		return -ENOMEM;
 	}
 	info->map.cached =
@@ -91,6 +92,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		iounmap((void *)info->map.virt);
 		if (info->map.cached)
 			iounmap(info->map.cached);
+		kfree(info);
 		return -EIO;
 	}
 	info->mtd->dev.parent = &pdev->dev;
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index d46e4adf6d2b..4cf97cdbdefe 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -552,8 +552,10 @@ int add_mtd_device(struct mtd_info *mtd)
 	dev_set_drvdata(&mtd->dev, mtd);
 	of_node_get(mtd_get_of_node(mtd));
 	error = device_register(&mtd->dev);
-	if (error)
+	if (error) {
+		put_device(&mtd->dev);
 		goto fail_added;
+	}
 
 	device_create(&mtd_class, mtd->dev.parent, MTD_DEVT(i) + 1, NULL,
 		      "mtd%dro", i);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 33843b89ab04..d606e0a6b335 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2052,10 +2052,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 35a9f252ceb6..421e47f8b54a 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -826,7 +826,7 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	lp->memcpy_f( PKTBUF_ADDR(head), (void *)skb->data, skb->len );
 	head->flag = TMD1_OWN_CHIP | TMD1_ENP | TMD1_STP;
 	dev->stats.tx_bytes += skb->len;
-	dev_kfree_skb( skb );
+	dev_consume_skb_irq(skb);
 	lp->cur_tx++;
 	while( lp->cur_tx >= TX_RING_SIZE && lp->dirty_tx >= TX_RING_SIZE ) {
 		lp->cur_tx -= TX_RING_SIZE;
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index abb1ba228b26..3495e0b4d3ef 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -998,7 +998,7 @@ static netdev_tx_t lance_start_xmit(struct sk_buff *skb,
 		skb_copy_from_linear_data(skb, &lp->tx_bounce_buffs[entry], skb->len);
 		lp->tx_ring[entry].base =
 			((u32)isa_virt_to_bus((lp->tx_bounce_buffs + entry)) & 0xffffff) | 0x83000000;
-		dev_kfree_skb(skb);
+		dev_consume_skb_irq(skb);
 	} else {
 		lp->tx_skbuff[entry] = skb;
 		lp->tx_ring[entry].base = ((u32)isa_virt_to_bus(skb->data) & 0xffffff) | 0x83000000;
diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index ffa7e7e6d18d..01874e1dbb8b 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1518,7 +1518,7 @@ static void bmac_tx_timeout(unsigned long data)
 	i = bp->tx_empty;
 	++dev->stats.tx_errors;
 	if (i != bp->tx_fill) {
-		dev_kfree_skb(bp->tx_bufs[i]);
+		dev_kfree_skb_irq(bp->tx_bufs[i]);
 		bp->tx_bufs[i] = NULL;
 		if (++i >= N_TX_RING) i = 0;
 		bp->tx_empty = i;
diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index e58a7c73766e..ea6199425b67 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -843,7 +843,7 @@ static void mace_tx_timeout(unsigned long data)
     if (mp->tx_bad_runt) {
 	mp->tx_bad_runt = 0;
     } else if (i != mp->tx_fill) {
-	dev_kfree_skb(mp->tx_bufs[i]);
+	dev_kfree_skb_irq(mp->tx_bufs[i]);
 	if (++i >= N_TX_RING)
 	    i = 0;
 	mp->tx_empty = i;
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index c3b64cdd0dec..62fcedd6f732 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -558,11 +558,11 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	/* free the buffer */
 	dev_kfree_skb(skb);
 
-	spin_unlock_irqrestore(&bp->lock, flags);
-
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2e713e5f75cd..bbca786f0427 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1219,8 +1219,12 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 	if (!q_vector) {
 		q_vector = kzalloc(size, GFP_KERNEL);
 	} else if (size > ksize(q_vector)) {
-		kfree_rcu(q_vector, rcu);
-		q_vector = kzalloc(size, GFP_KERNEL);
+		struct igb_q_vector *new_q_vector;
+
+		new_q_vector = kzalloc(size, GFP_KERNEL);
+		if (new_q_vector)
+			kfree_rcu(q_vector, rcu);
+		q_vector = new_q_vector;
 	} else {
 		memset(q_vector, 0, size);
 	}
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 5eeba263b5f8..d50cee7aae4d 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -4152,6 +4152,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_free_slices(mgp);
 
 abort_with_firmware:
+	kfree(mgp->msix_vectors);
 	myri10ge_dummy_rdma(mgp, 0);
 
 abort_with_ioremap:
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index a66f4b867e3a..a66b797cdbbe 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2384,7 +2384,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
 			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
 			if (skb) {
 				swstats->mem_freed += skb->truesize;
-				dev_kfree_skb(skb);
+				dev_kfree_skb_irq(skb);
 				cnt++;
 			}
 		}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 44caa7c2077e..d89d9247b7b9 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -222,6 +222,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
 	return 0;
 
 qlcnic_destroy_async_wq:
+	while (i--)
+		kfree(sriov->vf_info[i].vp);
 	destroy_workqueue(bc->bc_async_wq);
 
 qlcnic_destroy_trans_wq:
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 065a63123863..4a963b4ec0eb 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1185,10 +1185,12 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register net device\n");
-		goto err_out_mdio_unregister;
+		goto err_out_phy_disconnect;
 	}
 	return 0;
 
+err_out_phy_disconnect:
+	phy_disconnect(dev->phydev);
 err_out_mdio_unregister:
 	mdiobus_unregister(lp->mii_bus);
 err_out_mdio:
@@ -1212,6 +1214,7 @@ static void r6040_remove_one(struct pci_dev *pdev)
 	struct r6040_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
+	phy_disconnect(dev->phydev);
 	mdiobus_unregister(lp->mii_bus);
 	mdiobus_free(lp->mii_bus);
 	netif_napi_del(&lp->napi);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 5b91a95476de..c925a8fb1993 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -57,7 +57,8 @@ static u32 stmmac_config_sub_second_increment(void __iomem *ioaddr,
 	if (!(value & PTP_TCR_TSCTRLSSR))
 		data = (data * 1000) / 465;
 
-	data &= PTP_SSIR_SSINC_MASK;
+	if (data > PTP_SSIR_SSINC_MAX)
+		data = PTP_SSIR_SSINC_MAX;
 
 	reg_value = data;
 	if (gmac4)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index 174777cd888e..06fd27fc9a08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -69,7 +69,7 @@
 #define	PTP_TCR_TSENMACADDR	BIT(18)
 
 /* SSIR defines */
-#define	PTP_SSIR_SSINC_MASK		0xff
+#define	PTP_SSIR_SSINC_MAX		0xff
 #define	GMAC4_PTP_SSIR_SSINC_SHIFT	16
 
 #endif	/* __STMMAC_PTP_H__ */
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index c17967b23d3c..957701d48712 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1237,7 +1237,7 @@ static int netcp_tx_submit_skb(struct netcp_intf *netcp,
 }
 
 /* Submit the packet */
-static int netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
 	int subqueue = skb_get_queue_mapping(skb);
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index cdcc86060749..99c7872504fe 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -537,7 +537,7 @@ static void xemaclite_tx_timeout(struct net_device *dev)
 	xemaclite_enable_interrupts(lp);
 
 	if (lp->deferred_skb) {
-		dev_kfree_skb(lp->deferred_skb);
+		dev_kfree_skb_irq(lp->deferred_skb);
 		lp->deferred_skb = NULL;
 		dev->stats.tx_errors++;
 	}
diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index bdcf4aa34566..bb3c7781cdfa 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -3844,10 +3844,24 @@ static int dfx_init(void)
 	int status;
 
 	status = pci_register_driver(&dfx_pci_driver);
-	if (!status)
-		status = eisa_driver_register(&dfx_eisa_driver);
-	if (!status)
-		status = tc_register_driver(&dfx_tc_driver);
+	if (status)
+		goto err_pci_register;
+
+	status = eisa_driver_register(&dfx_eisa_driver);
+	if (status)
+		goto err_eisa_register;
+
+	status = tc_register_driver(&dfx_tc_driver);
+	if (status)
+		goto err_tc_register;
+
+	return 0;
+
+err_tc_register:
+	eisa_driver_unregister(&dfx_eisa_driver);
+err_eisa_register:
+	pci_unregister_driver(&dfx_pci_driver);
+err_pci_register:
 	return status;
 }
 
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 78dbc44540f6..b7831d0fd084 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -768,7 +768,7 @@ static void epp_bh(struct work_struct *work)
  * ===================== network driver interface =========================
  */
 
-static int baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index b8083161ef46..9b9daf45adad 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -299,12 +299,12 @@ static inline void scc_discard_buffers(struct scc_channel *scc)
 	spin_lock_irqsave(&scc->lock, flags);	
 	if (scc->tx_buff != NULL)
 	{
-		dev_kfree_skb(scc->tx_buff);
+		dev_kfree_skb_irq(scc->tx_buff);
 		scc->tx_buff = NULL;
 	}
 	
 	while (!skb_queue_empty(&scc->tx_queue))
-		dev_kfree_skb(skb_dequeue(&scc->tx_queue));
+		dev_kfree_skb_irq(skb_dequeue(&scc->tx_queue));
 
 	spin_unlock_irqrestore(&scc->lock, flags);
 }
@@ -1666,7 +1666,7 @@ static netdev_tx_t scc_net_tx(struct sk_buff *skb, struct net_device *dev)
 	if (skb_queue_len(&scc->tx_queue) > scc->dev->tx_queue_len) {
 		struct sk_buff *skb_del;
 		skb_del = skb_dequeue(&scc->tx_queue);
-		dev_kfree_skb(skb_del);
+		dev_kfree_skb_irq(skb_del);
 	}
 	skb_queue_tail(&scc->tx_queue, skb);
 	netif_trans_update(dev);
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 1b65f0f975cf..f04f9a87840e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -194,7 +194,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index bd6c19ceab30..c4a3143cef25 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -140,7 +140,7 @@ static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
 enqueue_again:
 	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
 	if (rc) {
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		ndev->stats.rx_errors++;
 		ndev->stats.rx_fifo_errors++;
 	}
@@ -195,7 +195,7 @@ static void ntb_netdev_tx_handler(struct ntb_transport_qp *qp, void *qp_data,
 		ndev->stats.tx_aborted_errors++;
 	}
 
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 
 	if (ntb_transport_tx_free_entry(dev->qp) >= tx_start) {
 		/* Make sure anybody stopping the queue after this sees the new
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 6287d2ad77c6..f6cf25cba16e 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1541,6 +1541,8 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	int len;
 	unsigned char *cp;
 
+	skb->dev = ppp->dev;
+
 	if (proto < 0x8000) {
 #ifdef CONFIG_PPP_FILTER
 		/* check if we should pass this packet */
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 3c9cbf908ec7..e8522014a67a 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2620,6 +2620,7 @@ fst_remove_one(struct pci_dev *pdev)
 	for (i = 0; i < card->nports; i++) {
 		struct net_device *dev = port_to_dev(&card->ports[i]);
 		unregister_hdlc_device(dev);
+		free_netdev(dev);
 	}
 
 	fst_disable_intr(card);
@@ -2640,6 +2641,7 @@ fst_remove_one(struct pci_dev *pdev)
 				    card->tx_dma_handle_card);
 	}
 	fst_card_array[card->card_no] = NULL;
+	kfree(card);
 }
 
 static struct pci_driver fst_driver = {
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 0c6b33c464cd..187061a43f7f 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -241,6 +241,11 @@ static void ar5523_cmd_tx_cb(struct urb *urb)
 	}
 }
 
+static void ar5523_cancel_tx_cmd(struct ar5523 *ar)
+{
+	usb_kill_urb(ar->tx_cmd.urb_tx);
+}
+
 static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 		      int ilen, void *odata, int olen, int flags)
 {
@@ -280,6 +285,7 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 	}
 
 	if (!wait_for_completion_timeout(&cmd->done, 2 * HZ)) {
+		ar5523_cancel_tx_cmd(ar);
 		cmd->odata = NULL;
 		ar5523_err(ar, "timeout waiting for command %02x reply\n",
 			   code);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d96e062647fd..450eb7b31256 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3381,18 +3381,22 @@ static struct pci_driver ath10k_pci_driver = {
 
 static int __init ath10k_pci_init(void)
 {
-	int ret;
+	int ret1, ret2;
 
-	ret = pci_register_driver(&ath10k_pci_driver);
-	if (ret)
+	ret1 = pci_register_driver(&ath10k_pci_driver);
+	if (ret1)
 		printk(KERN_ERR "failed to register ath10k pci driver: %d\n",
-		       ret);
+		       ret1);
 
-	ret = ath10k_ahb_init();
-	if (ret)
-		printk(KERN_ERR "ahb init failed: %d\n", ret);
+	ret2 = ath10k_ahb_init();
+	if (ret2)
+		printk(KERN_ERR "ahb init failed: %d\n", ret2);
 
-	return ret;
+	if (ret1 && ret2)
+		return ret1;
+
+	/* registered to at least one bus */
+	return 0;
 }
 module_init(ath10k_pci_init);
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 33a6be0f21ca..438323182d07 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -707,14 +707,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
 	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
 	struct sk_buff *skb = rx_buf->skb;
-	struct sk_buff *nskb;
 	int ret;
 
 	if (!skb)
 		return;
 
 	if (!hif_dev)
-		goto free;
+		goto free_skb;
 
 	switch (urb->status) {
 	case 0:
@@ -723,7 +722,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ECONNRESET:
 	case -ENODEV:
 	case -ESHUTDOWN:
-		goto free;
+		goto free_skb;
 	default:
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
@@ -734,25 +733,27 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		/* Process the command first */
+		/*
+		 * Process the command first.
+		 * skb is either freed here or passed to be
+		 * managed to another callback function.
+		 */
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
 				 skb->len, USB_REG_IN_PIPE);
 
-
-		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
-		if (!nskb) {
+		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		if (!skb) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: REG_IN memory allocation failure\n");
-			urb->context = NULL;
-			return;
+			goto free_rx_buf;
 		}
 
-		rx_buf->skb = nskb;
+		rx_buf->skb = skb;
 
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
-				 nskb->data, MAX_REG_IN_BUF_SIZE,
+				 skb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 	}
 
@@ -761,12 +762,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		goto free;
+		goto free_skb;
 	}
 
 	return;
-free:
+free_skb:
 	kfree_skb(skb);
+free_rx_buf:
 	kfree(rx_buf);
 	urb->context = NULL;
 }
@@ -779,14 +781,10 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
-		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
@@ -1327,10 +1325,24 @@ static int send_eject_command(struct usb_interface *interface)
 static int ath9k_hif_usb_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;
 	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_host_interface *alt;
 	struct hif_device_usb *hif_dev;
 	int ret = 0;
 
+	/* Verify the expected endpoints are present */
+	alt = interface->cur_altsetting;
+	if (usb_find_common_endpoints(alt, &bulk_in, &bulk_out, &int_in, &int_out) < 0 ||
+	    usb_endpoint_num(bulk_in) != USB_WLAN_RX_PIPE ||
+	    usb_endpoint_num(bulk_out) != USB_WLAN_TX_PIPE ||
+	    usb_endpoint_num(int_in) != USB_REG_IN_PIPE ||
+	    usb_endpoint_num(int_out) != USB_REG_OUT_PIPE) {
+		dev_err(&udev->dev,
+			"ath9k_htc: Device endpoint numbers are not the expected ones\n");
+		return -ENODEV;
+	}
+
 	if (id->driver_info == STORAGE_DEVICE)
 		return send_eject_command(interface);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 33a7378164b8..6675de16e3b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -572,6 +572,11 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 	u32 i;
 	char end;
 
+	if (chiprev >= BITS_PER_TYPE(u32)) {
+		brcmf_err("Invalid chip revision %u\n", chiprev);
+		return NULL;
+	}
+
 	for (i = 0; i < table_size; i++) {
 		if (mapping_table[i].chipid == chip &&
 		    mapping_table[i].revmask & BIT(chiprev))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 9e90737f4d49..45464bcd0960 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -578,7 +578,7 @@ static int brcmf_pcie_exit_download_state(struct brcmf_pciedev_info *devinfo,
 	}
 
 	if (!brcmf_chip_set_active(devinfo->ci, resetintr))
-		return -EINVAL;
+		return -EIO;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index d8f34883c096..d80aee2f5802 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3310,6 +3310,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	/* Take arm out of reset */
 	if (!brcmf_chip_set_active(bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
+		bcmerror = -EIO;
 		goto err;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 9143b173935d..c2c0e5635795 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1191,7 +1191,7 @@ struct rtl8723bu_c2h {
 			u8 dummy3_0;
 		} __packed ra_report;
 	};
-};
+} __packed;
 
 struct rtl8xxxu_fileops;
 
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 806309ee4165..fe81946a9ab4 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1294,6 +1294,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);
 
+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;
 
 	rc = rsp->status & PN533_CMD_RET_MASK;
@@ -1776,6 +1778,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 
 		dev_dbg(dev->dev, "Creating new target\n");
 
+		memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
 		nfc_target.nfcid1_len = 10;
 		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 3a91e06926ad..e800e83fa225 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -141,6 +141,9 @@ static int start_task(void)
 
 	/* Create the work queue and queue the LED task */
 	led_wq = create_singlethread_workqueue("led_wq");	
+	if (!led_wq)
+		return -ENOMEM;
+
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 717540161223..faec4ae77ee2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1167,11 +1167,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 
 	sysfs_bin_attr_init(res_attr);
 	if (write_combine) {
-		pdev->res_attr_wc[num] = res_attr;
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
 	} else {
-		pdev->res_attr[num] = res_attr;
 		sprintf(res_attr_name, "resource%d", num);
 		res_attr->mmap = pci_mmap_resource_uc;
 	}
@@ -1184,10 +1182,17 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = &pdev->resource[num];
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-	if (retval)
+	if (retval) {
 		kfree(res_attr);
+		return retval;
+	}
 
-	return retval;
+	if (write_combine)
+		pdev->res_attr_wc[num] = res_attr;
+	else
+		pdev->res_attr[num] = res_attr;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 074a7e044e25..b0e41fb3623d 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -384,8 +384,10 @@ int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 	for_each_child_of_node(np_config, np) {
 		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
 					&reserved_maps, num_maps, type);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(np);
 			goto exit;
+		}
 	}
 	return 0;
 
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index b54620e53830..3d5865c7694b 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -159,14 +159,14 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id,
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	dev->dev.release = &pnp_release_device;
 
-	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
-
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
 		kfree(dev);
 		return NULL;
 	}
 
+	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
+
 	return dev;
 }
 
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index bb7b817cca59..a695c87ae459 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -971,6 +971,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
 err_list_del:
+	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
 	return ret;
 }
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index cb0b3d3d132f..af156b7f346f 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -807,8 +807,8 @@ __power_supply_register(struct device *parent,
 register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
-	device_del(dev);
 wakeup_init_failed:
+	device_del(dev);
 device_add_failed:
 check_supplies_failed:
 dev_set_name_failed:
diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index c246d3a2fc5f..2c232217fd35 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1864,8 +1864,11 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
 		rio_init_dbell_res(&rdev->riores[RIO_DOORBELL_RESOURCE],
 				   0, 0xffff);
 	err = rio_add_device(rdev);
-	if (err)
-		goto cleanup;
+	if (err) {
+		put_device(&rdev->dev);
+		return err;
+	}
+
 	rio_dev_get(rdev);
 
 	return 0;
@@ -1961,10 +1964,6 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 
 	priv->md = chdev;
 
-	mutex_lock(&chdev->file_mutex);
-	list_add_tail(&priv->list, &chdev->file_list);
-	mutex_unlock(&chdev->file_mutex);
-
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
 	spin_lock_init(&priv->fifo_lock);
@@ -1973,6 +1972,7 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
 			  GFP_KERNEL);
 	if (ret < 0) {
+		put_device(&chdev->dev);
 		dev_err(&chdev->dev, DRV_NAME ": kfifo_alloc failed\n");
 		ret = -ENOMEM;
 		goto err_fifo;
@@ -1984,6 +1984,9 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 	spin_lock_init(&priv->req_lock);
 	mutex_init(&priv->dma_lock);
 #endif
+	mutex_lock(&chdev->file_mutex);
+	list_add_tail(&priv->list, &chdev->file_list);
+	mutex_unlock(&chdev->file_mutex);
 
 	filp->private_data = priv;
 	goto out;
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 23429bdaca84..26ab8c463dae 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -460,8 +460,12 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 				   0, 0xffff);
 
 	ret = rio_add_device(rdev);
-	if (ret)
-		goto cleanup;
+	if (ret) {
+		if (rswitch)
+			kfree(rswitch->route_table);
+		put_device(&rdev->dev);
+		return NULL;
+	}
 
 	rio_dev_get(rdev);
 
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 37042858c2db..4710286096dc 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2275,11 +2275,16 @@ int rio_register_mport(struct rio_mport *port)
 	atomic_set(&port->state, RIO_DEVICE_RUNNING);
 
 	res = device_register(&port->dev);
-	if (res)
+	if (res) {
 		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
 			port->id, res);
-	else
+		mutex_lock(&rio_mport_list_lock);
+		list_del(&port->node);
+		mutex_unlock(&rio_mport_list_lock);
+		put_device(&port->dev);
+	} else {
 		dev_dbg(&port->dev, "RIO: registered mport%d\n", port->id);
+	}
 
 	return res;
 }
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 23323add5b0b..cbc3397258f6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1157,6 +1157,7 @@ static int set_supply(struct regulator_dev *rdev,
 
 	rdev->supply = create_regulator(supply_rdev, &rdev->dev, "SUPPLY");
 	if (rdev->supply == NULL) {
+		module_put(supply_rdev->owner);
 		err = -ENOMEM;
 		return err;
 	}
@@ -1471,6 +1472,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 		node = of_get_regulator(dev, supply);
 		if (node) {
 			r = of_find_regulator_by_node(node);
+			of_node_put(node);
 			if (r)
 				return r;
 			*ret = -EPROBE_DEFER;
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index 71eee39520f0..792089ffc274 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -39,6 +39,14 @@
 #define SNVS_LPPGDR_INIT	0x41736166
 #define CNTR_TO_SECS_SH		15
 
+/* The maximum RTC clock cycles that are allowed to pass between two
+ * consecutive clock counter register reads. If the values are corrupted a
+ * bigger difference is expected. The RTC frequency is 32kHz. With 320 cycles
+ * we end at 10ms which should be enough for most cases. If it once takes
+ * longer than expected we do a retry.
+ */
+#define MAX_RTC_READ_DIFF_CYCLES	320
+
 struct snvs_rtc_data {
 	struct rtc_device *rtc;
 	struct regmap *regmap;
@@ -63,6 +71,7 @@ static u64 rtc_read_lpsrt(struct snvs_rtc_data *data)
 static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 {
 	u64 read1, read2;
+	s64 diff;
 	unsigned int timeout = 100;
 
 	/* As expected, the registers might update between the read of the LSB
@@ -73,7 +82,8 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 	do {
 		read2 = read1;
 		read1 = rtc_read_lpsrt(data);
-	} while (read1 != read2 && --timeout);
+		diff = read1 - read2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout)
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 
@@ -85,13 +95,15 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 static int rtc_read_lp_counter_lsb(struct snvs_rtc_data *data, u32 *lsb)
 {
 	u32 count1, count2;
+	s32 diff;
 	unsigned int timeout = 100;
 
 	regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
 	do {
 		count2 = count1;
 		regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
-	} while (count1 != count2 && --timeout);
+		diff = count1 - count2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout) {
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 		return -ETIMEDOUT;
diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
index 74c0a336ceea..85756ef63c22 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -249,6 +249,7 @@ static int st_rtc_probe(struct platform_device *pdev)
 
 	rtc->clkrate = clk_get_rate(rtc->clk);
 	if (!rtc->clkrate) {
+		clk_disable_unprepare(rtc->clk);
 		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
 		return -EINVAL;
 	}
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e22b9ac3e564..ab48eef72d4f 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -866,16 +866,9 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 /**
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- *  skb		Pointer to buffer containing the packet.
- *  dev		Pointer to interface struct.
- *
- * returns 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
 /* first merge version - leaving both functions separated */
-static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ctcm_priv *priv = dev->ml_priv;
 
@@ -918,7 +911,7 @@ static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* unmerged MPC variant of ctcm_tx */
-static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int len = 0;
 	struct ctcm_priv *priv = dev->ml_priv;
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 4d3caad7e981..3bd2241c13e8 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1544,9 +1544,8 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 /**
  * Packet transmit function called by network stack
  */
-static int
-__lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
-		 struct net_device *dev)
+static netdev_tx_t __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
+				    struct net_device *dev)
 {
 	struct lcs_header *header;
 	int rc = NETDEV_TX_OK;
@@ -1607,8 +1606,7 @@ __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
 	return rc;
 }
 
-static int
-lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lcs_card *card;
 	int rc;
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index b0e8ffdf864b..3465ea3d667b 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1361,15 +1361,8 @@ static int netiucv_pm_restore_thaw(struct device *dev)
 /**
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- * @param skb Pointer to buffer containing the packet.
- * @param dev Pointer to interface struct.
- *
- * @return 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
-static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct netiucv_priv *privptr = netdev_priv(dev);
 	int rc;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9bd41a35a78a..42b00b9f4be8 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2518,6 +2518,7 @@ static int __init fcoe_init(void)
 
 out_free:
 	mutex_unlock(&fcoe_config_mutex);
+	fcoe_transport_detach(&fcoe_sw_transport);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 0675fd128734..17a45131a379 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -752,14 +752,15 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 
 	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
 	error = device_register(&ctlr->dev);
-	if (error)
-		goto out_del_q2;
+	if (error) {
+		destroy_workqueue(ctlr->devloss_work_q);
+		destroy_workqueue(ctlr->work_q);
+		put_device(&ctlr->dev);
+		return NULL;
+	}
 
 	return ctlr;
 
-out_del_q2:
-	destroy_workqueue(ctlr->devloss_work_q);
-	ctlr->devloss_work_q = NULL;
 out_del_q:
 	destroy_workqueue(ctlr->work_q);
 	ctlr->work_q = NULL;
@@ -958,16 +959,16 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->selected = new_fcf->selected;
 
 	error = device_register(&fcf->dev);
-	if (error)
-		goto out_del;
+	if (error) {
+		put_device(&fcf->dev);
+		goto out;
+	}
 
 	fcf->state = FCOE_FCF_STATE_CONNECTED;
 	list_add_tail(&fcf->peers, &ctlr->fcfs);
 
 	return fcf;
 
-out_del:
-	kfree(fcf);
 out:
 	return NULL;
 }
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f1d6d52d48b..aa1e388e86f2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9837,7 +9837,8 @@ static int hpsa_add_sas_host(struct ctlr_info *h)
 	return 0;
 
 free_sas_phy:
-	hpsa_free_sas_phy(hpsa_sas_phy);
+	sas_phy_free(hpsa_sas_phy->phy);
+	kfree(hpsa_sas_phy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 free_sas_node:
@@ -9873,10 +9874,12 @@ static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
 
 	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
 	if (rc)
-		goto free_sas_port;
+		goto free_sas_rphy;
 
 	return 0;
 
+free_sas_rphy:
+	sas_rphy_free(rphy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 	device->sas_port = NULL;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7760b9a1e0ae..96c45cc091a6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10772,11 +10772,19 @@ static struct notifier_block ipr_notifier = {
  **/
 static int __init ipr_init(void)
 {
+	int rc;
+
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
 	register_reboot_notifier(&ipr_notifier);
-	return pci_register_driver(&ipr_driver);
+	rc = pci_register_driver(&ipr_driver);
+	if (rc) {
+		unregister_reboot_notifier(&ipr_notifier);
+		return rc;
+	}
+
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index b106596cc0cf..69c5e26a9d5b 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -317,6 +317,9 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
+		spin_lock_irqsave(snic->shost->host_lock, flags);
+		list_del(&tgt->list);
+		spin_unlock_irqrestore(snic->shost->host_lock, flags);
 		kfree(tgt);
 		tgt = NULL;
 
diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 5248649b0b41..5faafe677341 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -72,7 +72,7 @@ static DEFINE_MUTEX(knav_dev_lock);
  * Newest followed by older ones. Search is done from start of the array
  * until a firmware file is found.
  */
-const char *knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
+static const char * const knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
 
 /**
  * knav_queue_notify: qmss queue notfier call
diff --git a/drivers/soc/ux500/ux500-soc-id.c b/drivers/soc/ux500/ux500-soc-id.c
index 6c1be74e5fcc..86a1a3c408df 100644
--- a/drivers/soc/ux500/ux500-soc-id.c
+++ b/drivers/soc/ux500/ux500-soc-id.c
@@ -159,20 +159,18 @@ static ssize_t ux500_get_process(struct device *dev,
 static const char *db8500_read_soc_id(struct device_node *backupram)
 {
 	void __iomem *base;
-	void __iomem *uid;
 	const char *retstr;
+	u32 uid[5];
 
 	base = of_iomap(backupram, 0);
 	if (!base)
 		return NULL;
-	uid = base + 0x1fc0;
+	memcpy_fromio(uid, base + 0x1fc0, sizeof(uid));
 
 	/* Throw these device-specific numbers into the entropy pool */
-	add_device_randomness(uid, 0x14);
+	add_device_randomness(uid, sizeof(uid));
 	retstr = kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+0),
-			 readl((u32 *)uid+1), readl((u32 *)uid+2),
-			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+			   uid[0], uid[1], uid[2], uid[3], uid[4]);
 	iounmap(base);
 	return retstr;
 }
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 247475aa522e..23c917342943 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1508,9 +1508,9 @@ static int rtllib_rx_Monitor(struct rtllib_device *ieee, struct sk_buff *skb,
 		hdrlen += 4;
 	}
 
-	rtllib_monitor_rx(ieee, skb, rx_stats, hdrlen);
 	ieee->stats.rx_packets++;
 	ieee->stats.rx_bytes += skb->len;
+	rtllib_monitor_rx(ieee, skb, rx_stats, hdrlen);
 
 	return 1;
 }
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 89cbc077a48d..085cc86e7c32 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -965,9 +965,11 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 #endif
 
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
+		unsigned int len = skb->len;
+
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
-		stats->rx_bytes += skb->len;
+		stats->rx_bytes += len;
 		return 1;
 	}
 
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index ad1d665e9962..59092f1d2856 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1048,6 +1048,9 @@ static void pl011_dma_rx_callback(void *data)
  */
 static inline void pl011_dma_rx_stop(struct uart_amba_port *uap)
 {
+	if (!uap->using_rx_dma)
+		return;
+
 	/* FIXME.  Just disable the DMA enable */
 	uap->dmacr &= ~UART011_RXDMAE;
 	pl011_write(uap->dmacr, uap, REG_DMACR);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 30b577384a1d..e8d450fdbb04 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -753,6 +753,7 @@ static void pch_request_dma(struct uart_port *port)
 	if (!chan) {
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Tx)\n",
 			__func__);
+		pci_dev_put(dma_dev);
 		return;
 	}
 	priv->chan_tx = chan;
@@ -769,6 +770,7 @@ static void pch_request_dma(struct uart_port *port)
 			__func__);
 		dma_release_channel(priv->chan_tx);
 		priv->chan_tx = NULL;
+		pci_dev_put(dma_dev);
 		return;
 	}
 
@@ -776,6 +778,8 @@ static void pch_request_dma(struct uart_port *port)
 	priv->rx_buf_virt = dma_alloc_coherent(port->dev, port->fifosize,
 				    &priv->rx_buf_dma, GFP_KERNEL);
 	priv->chan_rx = chan;
+
+	pci_dev_put(dma_dev);
 }
 
 static void pch_dma_rx_complete(void *arg)
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5e3195b3697..60fc4ed3f042 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -1138,7 +1138,13 @@ static int __init sunsab_init(void)
 		}
 	}
 
-	return platform_driver_register(&sab_driver);
+	err = platform_driver_register(&sab_driver);
+	if (err) {
+		kfree(sunsab_ports);
+		sunsab_ports = NULL;
+	}
+
+	return err;
 }
 
 static void __exit sunsab_exit(void)
diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index a00b4aee6c79..b4b7fa05b29b 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -113,8 +113,10 @@ static irqreturn_t uio_dmem_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
+	spin_lock(&priv->lock);
 	if (!test_and_set_bit(0, &priv->flags))
 		disable_irq_nosync(irq);
+	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
 }
@@ -128,20 +130,19 @@ static int uio_dmem_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	 * in the interrupt controller, but keep track of the
 	 * state to prevent per-irq depth damage.
 	 *
-	 * Serialize this operation to support multiple tasks.
+	 * Serialize this operation to support multiple tasks and concurrency
+	 * with irq handler on SMP systems.
 	 */
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (irq_on) {
 		if (test_and_clear_bit(0, &priv->flags))
 			enable_irq(dev_info->irq);
-		spin_unlock_irqrestore(&priv->lock, flags);
 	} else {
-		if (!test_and_set_bit(0, &priv->flags)) {
-			spin_unlock_irqrestore(&priv->lock, flags);
-			disable_irq(dev_info->irq);
-		}
+		if (!test_and_set_bit(0, &priv->flags))
+			disable_irq_nosync(dev_info->irq);
 	}
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 89da34ef7b3f..83d2db09ae7c 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -220,8 +220,9 @@ uvc_function_ep0_complete(struct usb_ep *ep, struct usb_request *req)
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_DATA;
-		uvc_event->data.length = req->actual;
-		memcpy(&uvc_event->data.data, req->buf, req->actual);
+		uvc_event->data.length = min_t(unsigned int, req->actual,
+			sizeof(uvc_event->data.data));
+		memcpy(&uvc_event->data.data, req->buf, uvc_event->data.length);
 		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 	}
 }
diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index 9e102ba9cf66..88415a3a9b43 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -636,10 +636,10 @@ static void fotg210_request_error(struct fotg210_udc *fotg210)
 static void fotg210_set_address(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
-	if (ctrl->wValue >= 0x0100) {
+	if (le16_to_cpu(ctrl->wValue) >= 0x0100) {
 		fotg210_request_error(fotg210);
 	} else {
-		fotg210_set_dev_addr(fotg210, ctrl->wValue);
+		fotg210_set_dev_addr(fotg210, le16_to_cpu(ctrl->wValue));
 		fotg210_set_cxdone(fotg210);
 	}
 }
@@ -720,17 +720,17 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
 
 	switch (ctrl->bRequestType & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
-		fotg210->ep0_data = 1 << USB_DEVICE_SELF_POWERED;
+		fotg210->ep0_data = cpu_to_le16(1 << USB_DEVICE_SELF_POWERED);
 		break;
 	case USB_RECIP_INTERFACE:
-		fotg210->ep0_data = 0;
+		fotg210->ep0_data = cpu_to_le16(0);
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK;
 		if (epnum)
 			fotg210->ep0_data =
-				fotg210_is_epnstall(fotg210->ep[epnum])
-				<< USB_ENDPOINT_HALT;
+				cpu_to_le16(fotg210_is_epnstall(fotg210->ep[epnum])
+					    << USB_ENDPOINT_HALT);
 		else
 			fotg210_request_error(fotg210);
 		break;
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ddb795a5cd75..7cfa0529a4b2 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -193,6 +193,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0011) }, /* Kamstrup 444 MHz RF sniffer */
+	{ USB_DEVICE(0x17A8, 0x0013) }, /* Kamstrup 870 MHz RF sniffer */
 	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
 	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 878b4b8761f5..3dbd60540372 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -450,6 +450,8 @@ static int alauda_init_media(struct us_data *us)
 		+ MEDIA_INFO(us).blockshift + MEDIA_INFO(us).pageshift);
 	MEDIA_INFO(us).pba_to_lba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
 	MEDIA_INFO(us).lba_to_pba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
+	if (MEDIA_INFO(us).pba_to_lba == NULL || MEDIA_INFO(us).lba_to_pba == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	if (alauda_reset_media(us) != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 9b1b6c1e218d..d5b15630050b 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -77,12 +77,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
 				  const char **extra_dbg)
 {
 #ifdef CONFIG_ACPI
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct device *dev = vdev->device;
 	acpi_handle handle = ACPI_HANDLE(dev);
 	acpi_status acpi_ret;
 
-	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
+	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
 	if (ACPI_FAILURE(acpi_ret)) {
 		if (extra_dbg)
 			*extra_dbg = acpi_format_exception(acpi_ret);
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index c0d4e645f3b5..e2c51e2ffc80 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2471,7 +2471,6 @@ config FB_SSD1307
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_DEFERRED_IO
-	select PWM
 	select FB_BACKLIGHT
 	help
 	  This driver implements support for the Solomon SSD1307
diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 9b32b9fc44a5..6e8bd281ee0f 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1527,8 +1527,10 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	info = framebuffer_alloc(sizeof(struct pm2fb_par), &pdev->dev);
-	if (!info)
-		return -ENOMEM;
+	if (!info) {
+		err = -ENOMEM;
+		goto err_exit_disable;
+	}
 	default_par = info->par;
 
 	switch (pdev->device) {
@@ -1709,6 +1711,8 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
  err_exit_neither:
 	framebuffer_release(info);
+ err_exit_disable:
+	pci_disable_device(pdev);
 	return retval;
 }
 
@@ -1735,6 +1739,7 @@ static void pm2fb_remove(struct pci_dev *pdev)
 	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
 	framebuffer_release(info);
+	pci_disable_device(pdev);
 }
 
 static struct pci_device_id pm2fb_id_table[] = {
diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 9fe0d0bcdf62..01a3d9931348 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1776,6 +1776,7 @@ static int uvesafb_probe(struct platform_device *dev)
 out_unmap:
 	iounmap(info->screen_base);
 out_mem:
+	arch_phys_wc_del(par->mtrr_handle);
 	release_mem_region(info->fix.smem_start, info->fix.smem_len);
 out_reg:
 	release_region(0x3c0, 32);
diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index 1c1e95a0b8fa..9774e9513ad0 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -291,8 +291,10 @@ static int vmlfb_get_gpu(struct vml_par *par)
 
 	mutex_unlock(&vml_mutex);
 
-	if (pci_enable_device(par->gpu) < 0)
+	if (pci_enable_device(par->gpu) < 0) {
+		pci_dev_put(par->gpu);
 		return -ENODEV;
+	}
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/via/via-core.c b/drivers/video/fbdev/via/via-core.c
index 1d28e16888e9..84f7835956a9 100644
--- a/drivers/video/fbdev/via/via-core.c
+++ b/drivers/video/fbdev/via/via-core.c
@@ -775,7 +775,14 @@ static int __init via_core_init(void)
 		return ret;
 	viafb_i2c_init();
 	viafb_gpio_init();
-	return pci_register_driver(&via_driver);
+	ret = pci_register_driver(&via_driver);
+	if (ret) {
+		viafb_gpio_exit();
+		viafb_i2c_exit();
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit via_core_exit(void)
diff --git a/drivers/vme/bridges/vme_fake.c b/drivers/vme/bridges/vme_fake.c
index e81ec763b555..150ee8b3507f 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -1077,6 +1077,8 @@ static int __init fake_init(void)
 
 	/* We need a fake parent device */
 	vme_root = __root_device_register("vme", THIS_MODULE);
+	if (IS_ERR(vme_root))
+		return PTR_ERR(vme_root);
 
 	/* If we want to support more than one bridge at some point, we need to
 	 * dynamically allocate this so we get one per device.
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index fc1b634b969a..2058403f8806 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1778,6 +1778,7 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 	return 0;
 
 err_dma:
+	list_del(&entry->list);
 err_dest:
 err_source:
 err_align:
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 2bda9245cabe..558e4007131e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -42,10 +42,10 @@ static LIST_HEAD(entries);
 static int enabled = 1;
 
 enum {Enabled, Magic};
-#define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
-#define MISC_FMT_OPEN_BINARY (1 << 30)
-#define MISC_FMT_CREDENTIALS (1 << 29)
-#define MISC_FMT_OPEN_FILE (1 << 28)
+#define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
+#define MISC_FMT_OPEN_BINARY (1UL << 30)
+#define MISC_FMT_CREDENTIALS (1UL << 29)
+#define MISC_FMT_OPEN_FILE (1UL << 28)
 
 typedef struct {
 	struct list_head list;
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 1bbb966c0783..9f79fd345e79 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -528,7 +528,7 @@ int cdev_device_add(struct cdev *cdev, struct device *dev)
 	}
 
 	rc = device_add(dev);
-	if (rc)
+	if (rc && dev->devt)
 		cdev_del(cdev);
 
 	return rc;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a4a76f1d275c..3d71b37073ce 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2599,7 +2599,7 @@ cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2641,6 +2641,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1b62bd9e7312..75372afe2525 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -476,7 +476,7 @@ enum {
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1U << EXT4_INODE_##FLAG))
 #define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
 
 static inline void ext4_check_flag_values(void)
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index ff7e1ac6ee53..30165eb46c32 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -147,6 +147,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	unsigned int key;
 	int ret = -EIO;
 
 	*err = 0;
@@ -155,7 +156,13 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		key = le32_to_cpu(p->key);
+		if (key > ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+			/* the block was out of range */
+			ret = -EFSCORRUPTED;
+			goto failure;
+		}
+		bh = sb_getblk(sb, key);
 		if (unlikely(!bh)) {
 			ret = -ENOMEM;
 			goto failure;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f1bcf89e1ae6..83360503d4d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4321,9 +4321,17 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((inode->i_ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
-	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
+	block = ext4_inode_table(sb, gdp);
+	if ((block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) ||
+	    (block >= ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+		ext4_error(sb, "Invalid inode table block %llu in "
+			   "block_group %u", block, iloc->block_group);
+		return -EFSCORRUPTED;
+	}
+	block += (inode_offset / inodes_per_block);
+
 	bh = sb_getblk(sb, block);
 	if (unlikely(!bh))
 		return -ENOMEM;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e7384a6e6a08..ac9f678ac4ae 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -134,7 +134,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
 
-	if (inode_bl->i_nlink == 0) {
+	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
 		/* this inode has never been used as a BOOT_LOADER */
 		set_nlink(inode_bl, 1);
 		i_uid_write(inode_bl, 0);
@@ -333,6 +333,10 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	if (IS_NOQUOTA(inode))
 		goto out_unlock;
 
+	err = dquot_initialize(inode);
+	if (err)
+		goto out_unlock;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		goto out_unlock;
@@ -345,10 +349,6 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	}
 	brelse(iloc.bh);
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1281181215aa..1ed95357eb52 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3862,6 +3862,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EXDEV;
 
 	retval = dquot_initialize(old.dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(old.inode);
 	if (retval)
 		return retval;
 	retval = dquot_initialize(new.dir);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 6b14ecb382df..e6e9225c881d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -974,19 +974,11 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-
-			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
-
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			if (error)
 				goto cleanup;
 
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
-
 			ea_idebug(inode, "creating block %llu",
 				  (unsigned long long)block);
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index de0d6d4c46b6..cd4eee5b8358 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -452,6 +452,8 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		/* panic? */
 		return -EIO;
 
+	if (HFS_I(main_inode)->cat_key.CName.len > HFS_NAMELEN)
+		return -EIO;
 	fd.search_key->cat = HFS_I(main_inode)->cat_key;
 	if (hfs_brec_find(&fd))
 		/* panic? */
diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index 39f5e343bf4d..fdb0edb8a607 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -109,7 +109,7 @@ void hfs_asc2mac(struct super_block *sb, struct hfs_name *out, const struct qstr
 	if (nls_io) {
 		wchar_t ch;
 
-		while (srclen > 0) {
+		while (srclen > 0 && dstlen > 0) {
 			size = nls_io->char2uni(src, srclen, &ch);
 			if (size < 0) {
 				ch = '?';
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 35cd703c6604..bbc72087dd4c 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index cfd380e2743d..f5ed9269c276 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -186,11 +186,11 @@ static void hfsplus_get_perms(struct inode *inode,
 	mode = be16_to_cpu(perms->mode);
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mode))
 		inode->i_uid = sbi->uid;
 
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || (!i_gid_read(inode) && !mode))
 		inode->i_gid = sbi->gid;
 
 	if (dir) {
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index bb806e58c977..f7465e0a9247 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -139,6 +139,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -150,6 +152,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a07fbb60ac3c..0ca1ad2610df 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -168,7 +168,7 @@ int dbMount(struct inode *ipbmap)
 	struct bmap *bmp;
 	struct dbmap_disk *dbmp_le;
 	struct metapage *mp;
-	int i;
+	int i, err;
 
 	/*
 	 * allocate/initialize the in-memory bmap descriptor
@@ -183,8 +183,8 @@ int dbMount(struct inode *ipbmap)
 			   BMAPBLKNO << JFS_SBI(ipbmap->i_sb)->l2nbperpage,
 			   PSIZE, 0);
 	if (mp == NULL) {
-		kfree(bmp);
-		return -EIO;
+		err = -EIO;
+		goto err_kfree_bmp;
 	}
 
 	/* copy the on-disk bmap descriptor to its in-memory version. */
@@ -194,9 +194,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
 	if (!bmp->db_numag) {
-		release_metapage(mp);
-		kfree(bmp);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_release_metapage;
 	}
 
 	bmp->db_maxlevel = le32_to_cpu(dbmp_le->dn_maxlevel);
@@ -207,6 +206,16 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
+	if (((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
 	for (i = 0; i < MAXAG; i++)
 		bmp->db_agfree[i] = le64_to_cpu(dbmp_le->dn_agfree[i]);
 	bmp->db_agsize = le64_to_cpu(dbmp_le->dn_agsize);
@@ -227,6 +236,12 @@ int dbMount(struct inode *ipbmap)
 	BMAP_LOCK_INIT(bmp);
 
 	return (0);
+
+err_release_metapage:
+	release_metapage(mp);
+err_kfree_bmp:
+	kfree(bmp);
+	return err;
 }
 
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 835d25e33509..75eeddc35b57 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -861,8 +861,8 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 EXPORT_SYMBOL_GPL(simple_attr_read);
 
 /* interpret the buffer as a number to call the set function with */
-ssize_t simple_attr_write(struct file *file, const char __user *buf,
-			  size_t len, loff_t *ppos)
+static ssize_t simple_attr_write_xsigned(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos, bool is_signed)
 {
 	struct simple_attr *attr;
 	unsigned long long val;
@@ -883,7 +883,10 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	ret = kstrtoull(attr->set_buf, 0, &val);
+	if (is_signed)
+		ret = kstrtoll(attr->set_buf, 0, &val);
+	else
+		ret = kstrtoull(attr->set_buf, 0, &val);
 	if (ret)
 		goto out;
 	ret = attr->set(attr->data, val);
@@ -893,8 +896,21 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
+
+ssize_t simple_attr_write(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, false);
+}
 EXPORT_SYMBOL_GPL(simple_attr_write);
 
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, true);
+}
+EXPORT_SYMBOL_GPL(simple_attr_write_signed);
+
 /**
  * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
  * @sb:		filesystem to do the file handle conversion on
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5baf6ed7732d..4771fc16d7d1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1822,18 +1822,18 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 }
 
 static int nfs4_open_recover_helper(struct nfs4_opendata *opendata,
-		fmode_t fmode)
+				    fmode_t fmode)
 {
 	struct nfs4_state *newstate;
+	struct nfs_server *server = NFS_SB(opendata->dentry->d_sb);
+	int openflags = opendata->o_arg.open_flags;
 	int ret;
 
 	if (!nfs4_mode_match_open_stateid(opendata->state, fmode))
 		return 0;
-	opendata->o_arg.open_flags = 0;
 	opendata->o_arg.fmode = fmode;
-	opendata->o_arg.share_access = nfs4_map_atomic_open_share(
-			NFS_SB(opendata->dentry->d_sb),
-			fmode, 0);
+	opendata->o_arg.share_access =
+		nfs4_map_atomic_open_share(server, fmode, openflags);
 	memset(&opendata->o_res, 0, sizeof(opendata->o_res));
 	memset(&opendata->c_res, 0, sizeof(opendata->c_res));
 	nfs4_init_opendata_res(opendata);
@@ -2411,10 +2411,15 @@ static int _nfs4_open_expired(struct nfs_open_context *ctx, struct nfs4_state *s
 	struct nfs4_opendata *opendata;
 	int ret;
 
-	opendata = nfs4_open_recoverdata_alloc(ctx, state,
-			NFS4_OPEN_CLAIM_FH);
+	opendata = nfs4_open_recoverdata_alloc(ctx, state, NFS4_OPEN_CLAIM_FH);
 	if (IS_ERR(opendata))
 		return PTR_ERR(opendata);
+	/*
+	 * We're not recovering a delegation, so ask for no delegation.
+	 * Otherwise the recovery thread could deadlock with an outstanding
+	 * delegation return.
+	 */
+	opendata->o_arg.open_flags = O_DIRECT;
 	ret = nfs4_open_recover(opendata, state);
 	if (ret == -ESTALE)
 		d_drop(ctx->dentry);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index b50c97c6aecb..fc5583531fc0 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4160,12 +4160,10 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		if (unlikely(!p))
 			goto out_overflow;
 		if (len < NFS4_MAXLABELLEN) {
-			if (label) {
-				if (label->len) {
-					if (label->len < len)
-						return -ERANGE;
-					memcpy(label->label, p, len);
-				}
+			if (label && label->len) {
+				if (label->len < len)
+					return -ERANGE;
+				memcpy(label->label, p, len);
 				label->len = len;
 				label->pi = pi;
 				label->lfs = lfs;
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 172f697864ab..39d6b5c53131 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -808,7 +808,6 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 	} else {
 		if (!conn->cb_xprt)
 			return -EINVAL;
-		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
 		args.prognumber = clp->cl_cb_session->se_cb_prog;
@@ -828,6 +827,9 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		rpc_shutdown_client(client);
 		return PTR_ERR(cred);
 	}
+
+	if (clp->cl_minorversion != 0)
+		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
 	clp->cl_cb_client = client;
 	clp->cl_cb_cred = cred;
 	return 0;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9bbdd152c296..3e143c2da06d 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/random.h>
+#include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -457,11 +458,33 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
 	return crc == le32_to_cpu(sbp->s_sum);
 }
 
-static int nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
+/**
+ * nilfs_sb2_bad_offset - check the location of the second superblock
+ * @sbp: superblock raw data buffer
+ * @offset: byte offset of second superblock calculated from device size
+ *
+ * nilfs_sb2_bad_offset() checks if the position on the second
+ * superblock is valid or not based on the filesystem parameters
+ * stored in @sbp.  If @offset points to a location within the segment
+ * area, or if the parameters themselves are not normal, it is
+ * determined to be invalid.
+ *
+ * Return Value: true if invalid, false if valid.
+ */
+static bool nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
 {
-	return offset < ((le64_to_cpu(sbp->s_nsegments) *
-			  le32_to_cpu(sbp->s_blocks_per_segment)) <<
-			 (le32_to_cpu(sbp->s_log_block_size) + 10));
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+	u32 blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
+	u64 nsegments = le64_to_cpu(sbp->s_nsegments);
+	u64 index;
+
+	if (blocks_per_segment < NILFS_SEG_MIN_BLOCKS ||
+	    shift_bits > ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)
+		return true;
+
+	index = offset >> (shift_bits + BLOCK_SIZE_BITS);
+	do_div(index, blocks_per_segment);
+	return index < nsegments;
 }
 
 static void nilfs_release_super_block(struct the_nilfs *nilfs)
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 03e1c6cd6f3c..52ee7c90dc5c 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -715,6 +715,8 @@ static struct ctl_table_header *ocfs2_table_header;
 
 static int __init ocfs2_stack_glue_init(void)
 {
+	int ret;
+
 	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
@@ -724,7 +726,11 @@ static int __init ocfs2_stack_glue_init(void)
 		return -ENOMEM; /* or something. */
 	}
 
-	return ocfs2_sysfs_init();
+	ret = ocfs2_sysfs_init();
+	if (ret)
+		unregister_sysctl_table(ocfs2_table_header);
+
+	return ret;
 }
 
 static void __exit ocfs2_stack_glue_exit(void)
diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 7d7df003f9d8..401d70944e49 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -253,6 +253,8 @@ static int orangefs_kernel_debug_init(void)
 void orangefs_debugfs_cleanup(void)
 {
 	debugfs_remove_recursive(debug_dir);
+	kfree(debug_help_string);
+	debug_help_string = NULL;
 }
 
 /* open ORANGEFS_KMOD_DEBUG_HELP_FILE */
@@ -706,6 +708,7 @@ int orangefs_prepare_debugfs_help_string(int at_boot)
 		memset(debug_help_string, 0, DEBUG_HELP_STRING_SIZE);
 		strlcat(debug_help_string, new, string_size);
 		mutex_unlock(&orangefs_help_file_lock);
+		kfree(new);
 	}
 
 	rc = 0;
diff --git a/fs/orangefs/orangefs-mod.c b/fs/orangefs/orangefs-mod.c
index 4113eb0495bf..74b8ee19e167 100644
--- a/fs/orangefs/orangefs-mod.c
+++ b/fs/orangefs/orangefs-mod.c
@@ -147,7 +147,7 @@ static int __init orangefs_init(void)
 		gossip_err("%s: could not initialize device subsystem %d!\n",
 			   __func__,
 			   ret);
-		goto cleanup_device;
+		goto cleanup_sysfs;
 	}
 
 	ret = register_filesystem(&orangefs_fs_type);
@@ -159,11 +159,11 @@ static int __init orangefs_init(void)
 		goto out;
 	}
 
-	orangefs_sysfs_exit();
-
-cleanup_device:
 	orangefs_dev_cleanup();
 
+cleanup_sysfs:
+	orangefs_sysfs_exit();
+
 sysfs_init_failed:
 
 debugfs_init_failed:
diff --git a/fs/pnode.c b/fs/pnode.c
index 64e9a401d67d..7cb21856de2c 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -247,7 +247,7 @@ static int propagate_one(struct mount *m)
 		}
 		do {
 			struct mount *parent = last_source->mnt_parent;
-			if (last_source == first_source)
+			if (peers(last_source, first_source))
 				break;
 			done = parent->mnt_master == p;
 			if (done && peers(n, parent))
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 11e558efd61e..b56cf56ae926 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -418,7 +418,11 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size,
 		phys_addr_t addr = page_start + i * PAGE_SIZE;
 		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
 	}
-	vaddr = vmap(pages, page_count, VM_MAP, prot);
+	/*
+	 * VM_IOREMAP used here to bypass this region during vread()
+	 * and kmap_atomic() (i.e. kcore) to avoid __va() failures.
+	 */
+	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
 	kfree(pages);
 
 	/*
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 1c900f322089..c58aafadd784 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -695,6 +695,7 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mod
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -778,6 +779,7 @@ static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -876,6 +878,7 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -1191,6 +1194,7 @@ static int reiserfs_symlink(struct inode *parent_dir,
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(parent_dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index e4cbb7719906..ae241b94ba93 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -48,6 +48,7 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
 	int error;
 
 	sec->name = NULL;
+	sec->value = NULL;
 
 	/* Don't add selinux attributes on xattrs - they'll never get used */
 	if (IS_PRIVATE(dir))
@@ -93,7 +94,6 @@ int reiserfs_security_write(struct reiserfs_transaction_handle *th,
 
 void reiserfs_security_free(struct reiserfs_security_handle *sec)
 {
-	kfree(sec->name);
 	kfree(sec->value);
 	sec->name = NULL;
 	sec->value = NULL;
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 08d3e630b49c..f5b0837511cf 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -437,7 +437,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
 		res += blocks;
 		direct = 1;
 	}
-	return blocks;
+	return res;
 }
 
 int sysv_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index e0fd65fe73e8..6f2bfbf248c9 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -531,8 +531,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			udf_write_aext(table, &epos, &eloc,
 					(etype << 30) | elen, 1);
 		} else
-			udf_delete_aext(table, epos, eloc,
-					(etype << 30) | elen);
+			udf_delete_aext(table, epos);
 	} else {
 		alloc_count = 0;
 	}
@@ -627,7 +626,7 @@ static int udf_table_new_block(struct super_block *sb,
 	if (goal_elen)
 		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
 	else
-		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
+		udf_delete_aext(table, goal_epos);
 	brelse(goal_epos.bh);
 
 	udf_add_free_space(sb, partition, -1);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fab5a9506bcf..750e797a7d65 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -442,6 +442,12 @@ static int udf_get_block(struct inode *inode, sector_t block,
 		iinfo->i_next_alloc_goal++;
 	}
 
+	/*
+	 * Block beyond EOF and prealloc extents? Just discard preallocation
+	 * as it is not useful and complicates things.
+	 */
+	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
@@ -491,8 +497,6 @@ static int udf_do_extend_file(struct inode *inode,
 	uint32_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	struct kernel_lb_addr prealloc_loc = {};
-	int prealloc_len = 0;
 	struct udf_inode_info *iinfo;
 	int err;
 
@@ -513,19 +517,6 @@ static int udf_do_extend_file(struct inode *inode,
 			~(sb->s_blocksize - 1);
 	}
 
-	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-						EXT_NOT_RECORDED_ALLOCATED) {
-		/* Save the extent so that we can reattach it to the end */
-		prealloc_loc = last_ext->extLocation;
-		prealloc_len = last_ext->extLength;
-		/* Mark the extent as a hole */
-		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
-		last_ext->extLocation.logicalBlockNum = 0;
-		last_ext->extLocation.partitionReferenceNum = 0;
-	}
-
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
@@ -553,7 +544,7 @@ static int udf_do_extend_file(struct inode *inode,
 		 * more extents, we may need to enter possible following
 		 * empty indirect extent.
 		 */
-		if (new_block_bytes || prealloc_len)
+		if (new_block_bytes)
 			udf_next_aext(inode, last_pos, &tmploc, &tmplen, 0);
 	}
 
@@ -587,17 +578,6 @@ static int udf_do_extend_file(struct inode *inode,
 	}
 
 out:
-	/* Do we have some preallocated blocks saved? */
-	if (prealloc_len) {
-		err = udf_add_aext(inode, last_pos, &prealloc_loc,
-				   prealloc_len, 1);
-		if (err)
-			return err;
-		last_ext->extLocation = prealloc_loc;
-		last_ext->extLength = prealloc_len;
-		count++;
-	}
-
 	/* last_pos should point to the last written extent... */
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(struct short_ad);
@@ -613,13 +593,17 @@ static int udf_do_extend_file(struct inode *inode,
 static void udf_do_extend_final_block(struct inode *inode,
 				      struct extent_position *last_pos,
 				      struct kernel_long_ad *last_ext,
-				      uint32_t final_block_len)
+				      uint32_t new_elen)
 {
-	struct super_block *sb = inode->i_sb;
 	uint32_t added_bytes;
 
-	added_bytes = final_block_len -
-		      (last_ext->extLength & (sb->s_blocksize - 1));
+	/*
+	 * Extent already large enough? It may be already rounded up to block
+	 * size...
+	 */
+	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
+		return;
+	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
@@ -636,12 +620,12 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
 	sector_t first_block = newsize >> sb->s_blocksize_bits, offset;
-	unsigned long partial_final_block;
+	loff_t new_elen;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct kernel_long_ad extent;
 	int err = 0;
-	int within_final_block;
+	bool within_last_ext;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -650,8 +634,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 	else
 		BUG();
 
+	/*
+	 * When creating hole in file, just don't bother with preserving
+	 * preallocation. It likely won't be very useful anyway.
+	 */
+	udf_discard_prealloc(inode);
+
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	within_final_block = (etype != -1);
+	within_last_ext = (etype != -1);
+	/* We don't expect extents past EOF... */
+	WARN_ON_ONCE(within_last_ext &&
+		     elen > ((loff_t)offset + 1) << inode->i_blkbits);
 
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
 	    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
@@ -667,19 +660,17 @@ static int udf_extend_file(struct inode *inode, loff_t newsize)
 		extent.extLength |= etype << 30;
 	}
 
-	partial_final_block = newsize & (sb->s_blocksize - 1);
+	new_elen = ((loff_t)offset << inode->i_blkbits) |
+					(newsize & (sb->s_blocksize - 1));
 
 	/* File has extent covering the new size (could happen when extending
 	 * inside a block)?
 	 */
-	if (within_final_block) {
+	if (within_last_ext) {
 		/* Extending file within the last file block */
-		udf_do_extend_final_block(inode, &epos, &extent,
-					  partial_final_block);
+		udf_do_extend_final_block(inode, &epos, &extent, new_elen);
 	} else {
-		loff_t add = ((loff_t)offset << sb->s_blocksize_bits) |
-			     partial_final_block;
-		err = udf_do_extend_file(inode, &epos, &extent, add);
+		err = udf_do_extend_file(inode, &epos, &extent, new_elen);
 	}
 
 	if (err < 0)
@@ -783,10 +774,11 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		return newblock;
 	}
 
-	/* Are we beyond EOF? */
+	/* Are we beyond EOF and preallocated extent? */
 	if (etype == -1) {
 		int ret;
 		loff_t hole_len;
+
 		isBeyondEOF = true;
 		if (count) {
 			if (c)
@@ -1200,8 +1192,7 @@ static void udf_update_extents(struct inode *inode,
 
 	if (startnum > endnum) {
 		for (i = 0; i < (startnum - endnum); i++)
-			udf_delete_aext(inode, *epos, laarr[i].extLocation,
-					laarr[i].extLength);
+			udf_delete_aext(inode, *epos);
 	} else if (startnum < endnum) {
 		for (i = 0; i < (endnum - startnum); i++) {
 			udf_insert_aext(inode, *epos, laarr[i].extLocation,
@@ -2235,14 +2226,15 @@ static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
 	return (nelen >> 30);
 }
 
-int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
-		       struct kernel_lb_addr eloc, uint32_t elen)
+int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)
 {
 	struct extent_position oepos;
 	int adsize;
 	int8_t etype;
 	struct allocExtDesc *aed;
 	struct udf_inode_info *iinfo;
+	struct kernel_lb_addr eloc;
+	uint32_t elen;
 
 	if (epos.bh) {
 		get_bh(epos.bh);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index aefa939176e1..0ab842460ed3 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1112,8 +1112,9 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EINVAL;
 
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
-	if (IS_ERR(ofi)) {
-		retval = PTR_ERR(ofi);
+	if (!ofi || IS_ERR(ofi)) {
+		if (IS_ERR(ofi))
+			retval = PTR_ERR(ofi);
 		goto end_rename;
 	}
 
@@ -1122,8 +1123,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	brelse(ofibh.sbh);
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
-	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, &tloc, 0)
-	    != old_inode->i_ino)
+	if (udf_get_lb_pblock(old_dir->i_sb, &tloc, 0) != old_inode->i_ino)
 		goto end_rename;
 
 	nfi = udf_find_entry(new_dir, &new_dentry->d_name, &nfibh, &ncfi);
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index c6ce7503a329..d2e53b668977 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -120,60 +120,42 @@ void udf_truncate_tail_extent(struct inode *inode)
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
+	struct extent_position prev_epos = {};
 	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
-	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == iinfo->i_lenExtents)
+	    ALIGN(inode->i_size, bsize) == ALIGN(iinfo->i_lenExtents, bsize))
 		return;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(struct short_ad);
-	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(struct long_ad);
-	else
-		adsize = 0;
-
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		etype = netype;
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		brelse(prev_epos.bh);
+		prev_epos = epos;
+		if (prev_epos.bh)
+			get_bh(prev_epos.bh);
+
+		etype = udf_next_aext(inode, &epos, &eloc, &elen, 1);
 		lbcount += elen;
 	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
-		if (!epos.bh) {
-			iinfo->i_lenAlloc =
-				epos.offset -
-				udf_file_entry_alloc_offset(inode);
-			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs =
-				cpu_to_le32(epos.offset -
-					    sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data, epos.offset);
-			else
-				udf_update_tag(epos.bh->b_data,
-					       sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		udf_delete_aext(inode, prev_epos);
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
+				DIV_ROUND_UP(elen, 1 << inode->i_blkbits));
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
 	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
+	brelse(prev_epos.bh);
 }
 
 static void udf_update_alloc_ext_desc(struct inode *inode,
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 263829ef1873..c46f75d528bb 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -160,8 +160,7 @@ extern int udf_add_aext(struct inode *, struct extent_position *,
 			struct kernel_lb_addr *, uint32_t, int);
 extern void udf_write_aext(struct inode *, struct extent_position *,
 			   struct kernel_lb_addr *, uint32_t, int);
-extern int8_t udf_delete_aext(struct inode *, struct extent_position,
-			      struct kernel_lb_addr, uint32_t);
+extern int8_t udf_delete_aext(struct inode *, struct extent_position);
 extern int8_t udf_next_aext(struct inode *, struct extent_position *,
 			    struct kernel_lb_addr *, uint32_t *, int);
 extern int8_t udf_current_aext(struct inode *, struct extent_position *,
diff --git a/fs/xattr.c b/fs/xattr.c
index c0fd99c95aa1..d66983d1e57c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1017,7 +1017,7 @@ static int xattr_list_one(char **buffer, ssize_t *remaining_size,
 ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 			  char *buffer, size_t size)
 {
-	bool trusted = capable(CAP_SYS_ADMIN);
+	bool trusted = ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	struct simple_xattr *xattr;
 	ssize_t remaining_size = size;
 	int err = 0;
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index e9851100c0f7..4b1c142be08c 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -60,6 +60,12 @@ struct mmu_table_batch {
 extern void tlb_table_flush(struct mmu_gather *tlb);
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+void tlb_remove_table_sync_one(void);
+
+#else
+
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif
 
 /*
diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 93570b61ec6c..919f3329d822 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -13,7 +13,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index ff0b981f078e..c5a383162c0b 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -56,7 +56,7 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	return -ENOSYS;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9e4a75005280..a794954e2c8e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3132,7 +3132,7 @@ void simple_transaction_set(struct file *file, size_t n);
  * All attributes contain a text representation of a numeric value
  * that are accessed with the get() and set() functions.
  */
-#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, __is_signed)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
@@ -3143,10 +3143,16 @@ static const struct file_operations __fops = {				\
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
-	.write	 = simple_attr_write,					\
+	.write	 = (__is_signed) ? simple_attr_write_signed : simple_attr_write,	\
 	.llseek	 = generic_file_llseek,					\
 }
 
+#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, false)
+
+#define DEFINE_SIMPLE_ATTRIBUTE_SIGNED(__fops, __get, __set, __fmt)	\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, true)
+
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
 {
@@ -3161,6 +3167,8 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 			 size_t len, loff_t *ppos);
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+				 size_t len, loff_t *ppos);
 
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 42868a9b4365..df7841c6fdf4 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -34,7 +34,7 @@ struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
 	struct rb_node *leftmost = rb_first_cached(&head->rb_root);
 
-	return rb_entry(leftmost, struct timerqueue_node, node);
+	return rb_entry_safe(leftmost, struct timerqueue_node, node);
 }
 
 static inline void timerqueue_init(struct timerqueue_node *node)
diff --git a/include/net/mrp.h b/include/net/mrp.h
index 31912c3be772..9338d6305159 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -119,6 +119,7 @@ struct mrp_applicant {
 	struct sk_buff		*pdu;
 	struct rb_root		mad;
 	struct rcu_head		rcu;
+	bool			active;
 };
 
 struct mrp_port {
diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 51502eabdb05..0915a8781eae 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -2,7 +2,7 @@
 #define _UAPI_LINUX_SWAB_H
 
 #include <linux/types.h>
-#include <linux/compiler.h>
+#include <linux/stddef.h>
 #include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
diff --git a/include/uapi/sound/asequencer.h b/include/uapi/sound/asequencer.h
index 7b7659a79ac4..98c8f6b56dff 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -343,10 +343,10 @@ typedef int __bitwise snd_seq_client_type_t;
 #define	KERNEL_CLIENT	((__force snd_seq_client_type_t) 2)
                         
 	/* event filter flags */
-#define SNDRV_SEQ_FILTER_BROADCAST	(1<<0)	/* accept broadcast messages */
-#define SNDRV_SEQ_FILTER_MULTICAST	(1<<1)	/* accept multicast messages */
-#define SNDRV_SEQ_FILTER_BOUNCE		(1<<2)	/* accept bounce event in error */
-#define SNDRV_SEQ_FILTER_USE_EVENT	(1<<31)	/* use event filter */
+#define SNDRV_SEQ_FILTER_BROADCAST	(1U<<0)	/* accept broadcast messages */
+#define SNDRV_SEQ_FILTER_MULTICAST	(1U<<1)	/* accept multicast messages */
+#define SNDRV_SEQ_FILTER_BOUNCE		(1U<<2)	/* accept bounce event in error */
+#define SNDRV_SEQ_FILTER_USE_EVENT	(1U<<31)	/* use event filter */
 
 struct snd_seq_client_info {
 	int client;			/* client number to inquire */
diff --git a/kernel/acct.c b/kernel/acct.c
index 37f1dc696fbd..928ed84f50df 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -328,6 +328,8 @@ static comp_t encode_comp_t(unsigned long value)
 		exp++;
 	}
 
+	if (exp > (((comp_t) ~0U) >> MANTSIZE))
+		return (comp_t) ~0U;
 	/*
 	 * Clean it up and polish it off.
 	 */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 58ef731d52c7..a25b5a8182ec 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8864,13 +8864,15 @@ static int pmu_dev_alloc(struct pmu *pmu)
 
 	pmu->dev->groups = pmu->attr_groups;
 	device_initialize(pmu->dev);
-	ret = dev_set_name(pmu->dev, "%s", pmu->name);
-	if (ret)
-		goto free_dev;
 
 	dev_set_drvdata(pmu->dev, pmu);
 	pmu->dev->bus = &pmu_bus;
 	pmu->dev->release = pmu_dev_release;
+
+	ret = dev_set_name(pmu->dev, "%s", pmu->name);
+	if (ret)
+		goto free_dev;
+
 	ret = device_add(pmu->dev);
 	if (ret)
 		goto free_dev;
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index a221c118f381..65bf44cf4090 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -84,6 +84,7 @@ struct gcov_fn_info {
  * @version: gcov version magic indicating the gcc version used for compilation
  * @next: list head for a singly-linked list
  * @stamp: uniquifying time stamp
+ * @checksum: unique object checksum
  * @filename: name of the associated gcov data file
  * @merge: merge functions (null for unused counter type)
  * @n_functions: number of instrumented functions
@@ -96,6 +97,10 @@ struct gcov_info {
 	unsigned int version;
 	struct gcov_info *next;
 	unsigned int stamp;
+ /* Since GCC 12.1 a checksum field is added. */
+#if (__GNUC__ >= 12)
+	unsigned int checksum;
+#endif
 	const char *filename;
 	void (*merge[GCOV_COUNTERS])(gcov_type *, unsigned int);
 	unsigned int n_functions;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 5dfac92521fa..b02850cfc8ee 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1677,8 +1677,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 056107787f4a..c6b58ff8ea72 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1517,7 +1517,8 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+	if ((iter->ent->type != TRACE_BLK) ||
+	    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
 	return print_one_line(iter, true);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index de1638df2b09..f614a5fee614 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5226,7 +5226,20 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			/* don't print partial lines */
+			/*
+			 * If one print_trace_line() fills entire trace_seq in one shot,
+			 * trace_seq_to_user() will returns -EBUSY because save_len == 0,
+			 * In this case, we need to consume it, otherwise, loop will peek
+			 * this event next time, resulting in an infinite loop.
+			 */
+			if (save_len == 0) {
+				iter->seq.full = 0;
+				trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+				trace_consume(iter);
+				break;
+			}
+
+			/* In other cases, don't print partial lines */
 			iter->seq.seq.len = save_len;
 			break;
 		}
diff --git a/lib/notifier-error-inject.c b/lib/notifier-error-inject.c
index eb4a04afea80..125ea8ce23a4 100644
--- a/lib/notifier-error-inject.c
+++ b/lib/notifier-error-inject.c
@@ -14,7 +14,7 @@ static int debugfs_errno_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_errno, debugfs_errno_get, debugfs_errno_set,
+DEFINE_SIMPLE_ATTRIBUTE_SIGNED(fops_errno, debugfs_errno_get, debugfs_errno_set,
 			"%lld\n");
 
 static struct dentry *debugfs_create_errno(const char *name, umode_t mode,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0f1bdbae45e2..04080415b47d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -20,6 +20,19 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+/* gross hack for <=4.19 stable */
+#if defined(CONFIG_S390) || defined(CONFIG_ARM)
+static void tlb_remove_table_smp_sync(void *arg)
+{
+        /* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_sync_one(void)
+{
+        smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+#endif
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
@@ -1044,6 +1057,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1288,12 +1302,20 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
+				spinlock_t *ptl;
+				unsigned long end = addr + HPAGE_PMD_SIZE;
+
+				mmu_notifier_invalidate_range_start(mm, addr,
+								    end);
+				ptl = pmd_lock(mm, pmd);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				atomic_long_dec(&mm->nr_ptes);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(mm, addr,
+								  end);
 			}
 			up_write(&mm->mmap_sem);
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 36d46e19df96..a93ea671b8f1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -349,6 +349,11 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
+void tlb_remove_table_sync_one(void)
+{
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+
 static void tlb_remove_table_one(void *table)
 {
 	/*
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 4ee3af3d400b..ac6b6374a1fc 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -610,7 +610,10 @@ static void mrp_join_timer(unsigned long data)
 	spin_unlock(&app->lock);
 
 	mrp_queue_xmit(app);
-	mrp_join_timer_arm(app);
+	spin_lock(&app->lock);
+	if (likely(app->active))
+		mrp_join_timer_arm(app);
+	spin_unlock(&app->lock);
 }
 
 static void mrp_periodic_timer_arm(struct mrp_applicant *app)
@@ -624,11 +627,12 @@ static void mrp_periodic_timer(unsigned long data)
 	struct mrp_applicant *app = (struct mrp_applicant *)data;
 
 	spin_lock(&app->lock);
-	mrp_mad_event(app, MRP_EVENT_PERIODIC);
-	mrp_pdu_queue(app);
+	if (likely(app->active)) {
+		mrp_mad_event(app, MRP_EVENT_PERIODIC);
+		mrp_pdu_queue(app);
+		mrp_periodic_timer_arm(app);
+	}
 	spin_unlock(&app->lock);
-
-	mrp_periodic_timer_arm(app);
 }
 
 static int mrp_pdu_parse_end_mark(struct sk_buff *skb, int *offset)
@@ -876,6 +880,7 @@ int mrp_init_applicant(struct net_device *dev, struct mrp_application *appl)
 	app->dev = dev;
 	app->app = appl;
 	app->mad = RB_ROOT;
+	app->active = true;
 	spin_lock_init(&app->lock);
 	skb_queue_head_init(&app->queue);
 	rcu_assign_pointer(dev->mrp_port->applicants[appl->type], app);
@@ -905,6 +910,9 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 
 	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
 
+	spin_lock_bh(&app->lock);
+	app->active = false;
+	spin_unlock_bh(&app->lock);
 	/* Delete timer and generate a final TX event to flush out
 	 * all pending messages before the applicant is gone.
 	 */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6f99da11d207..61ffa0f12925 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4181,7 +4181,7 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
 			*req_complete_skb = bt_cb(skb)->hci.req_complete_skb;
 		else
 			*req_complete = bt_cb(skb)->hci.req_complete;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 	spin_unlock_irqrestore(&hdev->cmd_q.lock, flags);
 }
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 5e7fb30b2320..cbf0a9d5aabc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4183,7 +4183,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5dcdbffdee49..0186fbe06281 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1693,6 +1693,9 @@ unsigned char *__pskb_pull_tail(struct sk_buff *skb, int delta)
 				insp = list;
 			} else {
 				/* Eaten partially. */
+				if (skb_is_gso(skb) && !list->head_frag &&
+				    skb_headlen(list))
+					skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
 
 				if (skb_shared(list)) {
 					/* Sucks! We need to fork list. :-( */
diff --git a/net/core/stream.c b/net/core/stream.c
index 05b63feac7e5..6f5979c6f2b0 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -193,6 +193,12 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
+	/* Next, the error queue.
+	 * We need to use queue lock, because other threads might
+	 * add packets to the queue without socket lock being held.
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
+
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
 
diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel.c
index 58bd39fb14b4..1f530a9b0357 100644
--- a/net/ipv4/udp_tunnel.c
+++ b/net/ipv4/udp_tunnel.c
@@ -163,6 +163,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
 void udp_tunnel_sock_release(struct socket *sock)
 {
 	rcu_assign_sk_user_data(sock->sk, NULL);
+	synchronize_rcu();
 	kernel_sock_shutdown(sock, SHUT_RDWR);
 	sock_release(sock);
 }
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 56999d8528a4..e4404f5053ae 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -944,6 +944,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct sw_flow_mask mask;
 	struct sk_buff *reply;
 	struct datapath *dp;
+	struct sw_flow_key *key;
 	struct sw_flow_actions *acts;
 	struct sw_flow_match match;
 	u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
@@ -971,24 +972,26 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Extract key. */
-	ovs_match_init(&match, &new_flow->key, false, &mask);
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	if (!key) {
+		error = -ENOMEM;
+		goto err_kfree_key;
+	}
+
+	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
 		goto err_kfree_flow;
 
+	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
+
 	/* Extract flow identifier. */
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
-				       &new_flow->key, log);
+				       key, log);
 	if (error)
 		goto err_kfree_flow;
 
-	/* unmasked key is needed to match when ufid is not used. */
-	if (ovs_identifier_is_key(&new_flow->id))
-		match.key = new_flow->id.unmasked_key;
-
-	ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
-
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
@@ -1015,7 +1018,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (ovs_identifier_is_ufid(&new_flow->id))
 		flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
 	if (!flow)
-		flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
+		flow = ovs_flow_tbl_lookup(&dp->table, key);
 	if (likely(!flow)) {
 		rcu_assign_pointer(new_flow->sf_acts, acts);
 
@@ -1085,6 +1088,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	if (reply)
 		ovs_notify(&dp_flow_genl_family, reply, info);
+
+	kfree(key);
 	return 0;
 
 err_unlock_ovs:
@@ -1094,6 +1099,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_nla_free_flow_actions(acts);
 err_kfree_flow:
 	ovs_flow_free(new_flow, false);
+err_kfree_key:
+	kfree(key);
 error:
 	return error;
 }
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index d4d6f9c91e8c..59340d633253 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -259,6 +259,8 @@ static int tcf_em_validate(struct tcf_proto *tp,
 			 * the value carried.
 			 */
 			if (em_hdr->flags & TCF_EM_SIMPLE) {
+				if (em->ops->datalen > 0)
+					goto errout;
 				if (data_len < sizeof(u32))
 					goto errout;
 				em->data = *(u32 *) data;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index eef2f732fbe3..9447670b5a63 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1275,7 +1275,7 @@ static int rpc_sockname(struct net *net, struct sockaddr *sap, size_t salen,
 		break;
 	default:
 		err = -EAFNOSUPPORT;
-		goto out;
+		goto out_release;
 	}
 	if (err < 0) {
 		dprintk("RPC:       can't bind UDP socket (%d)\n", err);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index c09efcdf72d2..d096ef9d1c89 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1738,7 +1738,11 @@ static int vmci_transport_dgram_enqueue(
 	if (!dg)
 		return -ENOMEM;
 
-	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	err = memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	if (err) {
+		kfree(dg);
+		return err;
+	}
 
 	dg->dst = vmci_make_handle(remote_addr->svm_cid,
 				   remote_addr->svm_port);
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index db3bdc91c520..22856d9e1102 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -87,6 +87,17 @@ static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 	return -ENOMEM;
 }
 
+static void dev_exceptions_move(struct list_head *dest, struct list_head *orig)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	lockdep_assert_held(&devcgroup_mutex);
+
+	list_for_each_entry_safe(ex, tmp, orig, list) {
+		list_move_tail(&ex->list, dest);
+	}
+}
+
 /*
  * called under devcgroup_mutex
  */
@@ -608,11 +619,13 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
+	struct dev_cgroup tmp_devcgrp;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	memset(&ex, 0, sizeof(ex));
+	memset(&tmp_devcgrp, 0, sizeof(tmp_devcgrp));
 	b = buffer;
 
 	switch (*b) {
@@ -624,15 +637,27 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
-			if (!parent)
+			if (!parent) {
+				devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+				dev_exception_clean(devcgroup);
 				break;
+			}
 
+			INIT_LIST_HEAD(&tmp_devcgrp.exceptions);
+			rc = dev_exceptions_copy(&tmp_devcgrp.exceptions,
+						 &devcgroup->exceptions);
+			if (rc)
+				return rc;
+			dev_exception_clean(devcgroup);
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
-			if (rc)
+			if (rc) {
+				dev_exceptions_move(&devcgroup->exceptions,
+						    &tmp_devcgrp.exceptions);
 				return rc;
+			}
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			dev_exception_clean(&tmp_devcgrp);
 			break;
 		case DEVCG_DENY:
 			if (css_has_online_children(&devcgroup->css))
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index febd12ed9b55..fdba86fa90ee 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -171,11 +171,11 @@ static int template_desc_init_fields(const char *template_fmt,
 	}
 
 	if (fields && num_fields) {
-		*fields = kmalloc_array(i, sizeof(*fields), GFP_KERNEL);
+		*fields = kmalloc_array(i, sizeof(**fields), GFP_KERNEL);
 		if (*fields == NULL)
 			return -ENOMEM;
 
-		memcpy(*fields, found_fields, i * sizeof(*fields));
+		memcpy(*fields, found_fields, i * sizeof(**fields));
 		*num_fields = i;
 	}
 
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index fd4d18df84d3..03b1b49c1afe 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -830,6 +830,9 @@ static void snd_mts64_interrupt(void *private)
 	u8 status, data;
 	struct snd_rawmidi_substream *substream;
 
+	if (!mts)
+		return;
+
 	spin_lock(&mts->lock);
 	ret = mts64_read(mts->pardev->port);
 	data = ret & 0x00ff;
diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 0d5ff00cdabc..90245f9d6c36 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -355,7 +355,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->device, pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
-	if (pci_enable_device(pci_dev) < 0) {
+	if (pcim_enable_device(pci_dev) < 0) {
 		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index c0807b82399a..614d39258e40 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1475,7 +1475,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-in\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_in = val;
 		}
@@ -1484,7 +1484,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			if (val > 6) {
 				dev_err(dev, "Invalid pll-out\n");
 				ret = -EINVAL;
-				goto err_clk;
+				goto err_pm;
 			}
 			pcm512x->pll_out = val;
 		}
@@ -1493,12 +1493,12 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 			dev_err(dev,
 				"Error: both pll-in and pll-out, or none\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 		if (pcm512x->pll_in && pcm512x->pll_in == pcm512x->pll_out) {
 			dev_err(dev, "Error: pll-in == pll-out\n");
 			ret = -EINVAL;
-			goto err_clk;
+			goto err_pm;
 		}
 	}
 #endif
diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index fdc14e50d3b9..13b944bcde71 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -3028,8 +3028,6 @@ static int rt5670_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
-	pm_runtime_put(&i2c->dev);
-
 	return 0;
 err:
 	pm_runtime_disable(&i2c->dev);
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index f289762cd676..1feeeed4bfb2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3704,7 +3704,12 @@ static irqreturn_t wm1811_jackdet_irq(int irq, void *data)
 	} else {
 		dev_dbg(codec->dev, "Jack not detected\n");
 
+		/* Release wm8994->accdet_lock to avoid deadlock:
+		 * cancel_delayed_work_sync() takes wm8994->mic_work internal
+		 * lock and wm1811_mic_work takes wm8994->accdet_lock */
+		mutex_unlock(&wm8994->accdet_lock);
 		cancel_delayed_work_sync(&wm8994->mic_work);
+		mutex_lock(&wm8994->accdet_lock);
 
 		snd_soc_update_bits(codec, WM8958_MICBIAS2,
 				    WM8958_MICB2_DISCH, WM8958_MICB2_DISCH);
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
index 52fdd766ee82..8fbc59199d58 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
@@ -209,14 +209,16 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5514_codecs[0].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	mt8173_rt5650_rt5514_codecs[1].of_node =
 		of_parse_phandle(pdev->dev.of_node, "mediatek,audio-codec", 1);
 	if (!mt8173_rt5650_rt5514_codecs[1].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	mt8173_rt5650_rt5514_codec_conf[0].of_node =
 		mt8173_rt5650_rt5514_codecs[1].of_node;
@@ -229,6 +231,7 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+out:
 	of_node_put(platform_node);
 	return ret;
 }
diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index 96df9b2d8fc4..d32a276e9205 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -88,7 +88,7 @@ static bool filter(struct dma_chan *chan, void *param)
 
 	devname = kasprintf(GFP_KERNEL, "%s.%d", dma_data->dma_res->name,
 		dma_data->ssp_id);
-	if ((strcmp(dev_name(chan->device->dev), devname) == 0) &&
+	if (devname && (strcmp(dev_name(chan->device->dev), devname) == 0) &&
 		(chan->chan_id == dma_data->dma_res->start)) {
 		found = true;
 	}
diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index f387d7bae3d4..e4073c48faf6 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -85,6 +85,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(spdif->hclk);
 	if (ret) {
+		clk_disable_unprepare(spdif->mclk);
 		dev_err(spdif->dev, "hclk clock enable failed %d\n", ret);
 		return ret;
 	}
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 5479927391d4..b1d4dd47f999 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -463,8 +463,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		val2 = ucontrol->value.integer.value[1];
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
+
 		val_mask = mask << rshift;
-		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+		val2 = (val2 + min) & mask;
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 8cca0befcf01..de8bb9c91474 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -304,7 +304,8 @@ static void line6_data_received(struct urb *urb)
 		for (;;) {
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
-						LINE6_MIDI_MESSAGE_MAXLEN);
+						   LINE6_MIDI_MESSAGE_MAXLEN,
+						   LINE6_MIDIBUF_READ_RX);
 
 			if (done <= 0)
 				break;
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
index 4f4ebe90f1a8..b908be4d347b 100644
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -48,7 +48,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 	int req, done;
 
 	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		req = min3(line6_midibuf_bytes_free(mb), line6->max_packet_size,
+			   LINE6_FALLBACK_MAXPACKETSIZE);
 		done = snd_rawmidi_transmit_peek(substream, chunk, req);
 
 		if (done == 0)
@@ -60,7 +61,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 
 	for (;;) {
 		done = line6_midibuf_read(mb, chunk,
-					  LINE6_FALLBACK_MAXPACKETSIZE);
+					  LINE6_FALLBACK_MAXPACKETSIZE,
+					  LINE6_MIDIBUF_READ_TX);
 
 		if (done == 0)
 			break;
diff --git a/sound/usb/line6/midibuf.c b/sound/usb/line6/midibuf.c
index c931d48801eb..4622234723a6 100644
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -13,6 +13,7 @@
 
 #include "midibuf.h"
 
+
 static int midibuf_message_length(unsigned char code)
 {
 	int message_length;
@@ -24,12 +25,7 @@ static int midibuf_message_length(unsigned char code)
 
 		message_length = length[(code >> 4) - 8];
 	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line 6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+		static const int length[] = { -1, 2, 2, 2, -1, -1, 1, 1, 1, -1,
 			1, 1, 1, -1, 1, 1
 		};
 		message_length = length[code & 0x0f];
@@ -129,7 +125,7 @@ int line6_midibuf_write(struct midi_buffer *this, unsigned char *data,
 }
 
 int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
-		       int length)
+		       int length, int read_type)
 {
 	int bytes_used;
 	int length1, length2;
@@ -152,9 +148,22 @@ int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
 
 	length1 = this->size - this->pos_read;
 
-	/* check MIDI command length */
 	command = this->buf[this->pos_read];
+	/*
+	   PODxt always has status byte lower nibble set to 0010,
+	   when it means to send 0000, so we correct if here so
+	   that control/program changes come on channel 1 and
+	   sysex message status byte is correct
+	 */
+	if (read_type == LINE6_MIDIBUF_READ_RX) {
+		if (command == 0xb2 || command == 0xc2 || command == 0xf2) {
+			unsigned char fixed = command & 0xf0;
+			this->buf[this->pos_read] = fixed;
+			command = fixed;
+		}
+	}
 
+	/* check MIDI command length */
 	if (command & 0x80) {
 		midi_length = midibuf_message_length(command);
 		this->command_prev = command;
diff --git a/sound/usb/line6/midibuf.h b/sound/usb/line6/midibuf.h
index 6ea21ffb6627..187f49c975c2 100644
--- a/sound/usb/line6/midibuf.h
+++ b/sound/usb/line6/midibuf.h
@@ -12,6 +12,9 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
+#define LINE6_MIDIBUF_READ_TX 0
+#define LINE6_MIDIBUF_READ_RX 1
+
 struct midi_buffer {
 	unsigned char *buf;
 	int size;
@@ -27,7 +30,7 @@ extern void line6_midibuf_destroy(struct midi_buffer *mb);
 extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
 extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
 extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
-			      int length);
+			      int length, int read_type);
 extern void line6_midibuf_reset(struct midi_buffer *mb);
 extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
diff --git a/sound/usb/line6/pod.c b/sound/usb/line6/pod.c
index aaa192aee883..81c2abacc612 100644
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -169,8 +169,9 @@ static struct line6_pcm_properties pod_pcm_properties = {
 	.bytes_per_channel = 3 /* SNDRV_PCM_FMTBIT_S24_3LE */
 };
 
+
 static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
+	0xf0, 0x7e, 0x7f, 0x06, 0x02
 };
 
 /* forward declarations: */
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 223d88e25e05..74b4455c8839 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3751,9 +3751,10 @@ sub test_this_config {
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-    delete $configs{$config};
+    $configs{$config} = "# $config is not set";
     make_new_config ((values %configs), (values %keep_configs));
     make_oldconfig;
+    delete $configs{$config};
     undef %configs;
     assign_configs \%configs, $output_config;
 
diff --git a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
index 17fb1b43c320..d6fb6f1125f9 100644
--- a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
+++ b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
@@ -27,6 +27,7 @@ static int check_cpu_dscr_default(char *file, unsigned long val)
 	rc = read(fd, buf, sizeof(buf));
 	if (rc == -1) {
 		perror("read() failed");
+		close(fd);
 		return 1;
 	}
 	close(fd);
@@ -64,8 +65,10 @@ static int check_all_cpu_dscr_defaults(unsigned long val)
 		if (access(file, F_OK))
 			continue;
 
-		if (check_cpu_dscr_default(file, val))
+		if (check_cpu_dscr_default(file, val)) {
+			closedir(sysfs);
 			return 1;
+		}
 	}
 	closedir(sysfs);
 	return 0;
