Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BBB43C527
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhJ0IcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240928AbhJ0IbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CDA61073;
        Wed, 27 Oct 2021 08:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635323339;
        bh=7Jys1PYJKGArWEYR0BcnBux6qj5JFzDINpySUDkLQaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dx6S7YTLzTyLjB+g8/v8qxSkFcVHe9FyoWlGSZCukzLdWeSBuZmWyRaUE+n1xywHS
         wAY6giFvxB5qBPBNTkjLlPaHoTF9Ci31FXRfG6dbTSTBk5X2Irnp3N82eX4ucoFzV/
         /QwK49HvNuPb30w5Qj1HLzdMe1SimMb61NGE9j6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.76
Date:   Wed, 27 Oct 2021 10:28:49 +0200
Message-Id: <16353233284419@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <163532332876161@kroah.com>
References: <163532332876161@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 74318cf964b8..605bd943b224 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 75
+SUBLEVEL = 76
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 002e0cf025f5..a0eac00e2c81 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -87,6 +87,7 @@ config ARM
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_IDE if PCI || ISA || PCMCIA
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index 9a18453d7842..0a53f21a8903 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -71,7 +71,6 @@ apb {
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			qspi1: spi@f0024000 {
diff --git a/arch/arm/boot/dts/spear3xx.dtsi b/arch/arm/boot/dts/spear3xx.dtsi
index f266b7b03482..cc88ebe7a60c 100644
--- a/arch/arm/boot/dts/spear3xx.dtsi
+++ b/arch/arm/boot/dts/spear3xx.dtsi
@@ -47,7 +47,7 @@ dma@fc400000 {
 		};
 
 		gmac: eth@e0800000 {
-			compatible = "st,spear600-gmac";
+			compatible = "snps,dwmac-3.40a";
 			reg = <0xe0800000 0x8000>;
 			interrupts = <23 22>;
 			interrupt-names = "macirq", "eth_wake_irq";
diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index 2ac41ed3a57c..659dcf4004b4 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -19,7 +19,7 @@
  */
 
 / {
-	bus@4000000 {
+	bus@40000000 {
 		motherboard {
 			model = "V2M-P1";
 			arm,hbi = <0x190>;
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
index 4c5847955856..1317f0f58d53 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -295,7 +295,7 @@ power-vd10-s3 {
 		};
 	};
 
-	smb: bus@4000000 {
+	smb: bus@40000000 {
 		compatible = "simple-bus";
 
 		#address-cells = <2>;
diff --git a/arch/nios2/include/asm/irqflags.h b/arch/nios2/include/asm/irqflags.h
index b3ec3e510706..25acf27862f9 100644
--- a/arch/nios2/include/asm/irqflags.h
+++ b/arch/nios2/include/asm/irqflags.h
@@ -9,7 +9,7 @@
 
 static inline unsigned long arch_local_save_flags(void)
 {
-	return RDCTL(CTL_STATUS);
+	return RDCTL(CTL_FSTATUS);
 }
 
 /*
@@ -18,7 +18,7 @@ static inline unsigned long arch_local_save_flags(void)
  */
 static inline void arch_local_irq_restore(unsigned long flags)
 {
-	WRCTL(CTL_STATUS, flags);
+	WRCTL(CTL_FSTATUS, flags);
 }
 
 static inline void arch_local_irq_disable(void)
diff --git a/arch/nios2/include/asm/registers.h b/arch/nios2/include/asm/registers.h
index 183c720e454d..95b67dd16f81 100644
--- a/arch/nios2/include/asm/registers.h
+++ b/arch/nios2/include/asm/registers.h
@@ -11,7 +11,7 @@
 #endif
 
 /* control register numbers */
-#define CTL_STATUS	0
+#define CTL_FSTATUS	0
 #define CTL_ESTATUS	1
 #define CTL_BSTATUS	2
 #define CTL_IENABLE	3
diff --git a/arch/parisc/math-emu/fpudispatch.c b/arch/parisc/math-emu/fpudispatch.c
index 7c46969ead9b..01ed133227c2 100644
--- a/arch/parisc/math-emu/fpudispatch.c
+++ b/arch/parisc/math-emu/fpudispatch.c
@@ -310,12 +310,15 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1];
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 3: /* FABS */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -325,13 +328,16 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and clear sign bit */
 					fpregs[t] = fpregs[r1] & 0x7fffffff;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 6: /* FNEG */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -341,13 +347,16 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and invert sign bit */
 					fpregs[t] = fpregs[r1] ^ 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 7: /* FNEGABS */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -357,13 +366,16 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and set sign bit */
 					fpregs[t] = fpregs[r1] | 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 4: /* FSQRT */
 				switch (fmt) {
 				    case 0:
@@ -376,6 +388,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 5: /* FRND */
 				switch (fmt) {
 				    case 0:
@@ -389,7 +402,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(MAJOR_0C_EXCP);
 				}
 		} /* end of switch (subop) */
-
+		BUG();
 	case 1: /* class 1 */
 		df = extru(ir,fpdfpos,2); /* get dest format */
 		if ((df & 2) || (fmt & 2)) {
@@ -419,6 +432,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* dbl/dbl */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FCNVXF */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -434,6 +448,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvxf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FCNVFX */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -449,6 +464,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvfx(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 3: /* FCNVFXT */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -464,6 +480,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvfxt(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 5: /* FCNVUF (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -479,6 +496,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvuf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 6: /* FCNVFU (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -494,6 +512,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvfu(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 7: /* FCNVFUT (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -509,10 +528,11 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 					return(dbl_to_dbl_fcnvfut(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* undefined */
 				return(MAJOR_0C_EXCP);
 		} /* end of switch subop */
-
+		BUG();
 	case 2: /* class 2 */
 		fpu_type_flags=fpregs[FPU_TYPE_FLAG_POS];
 		r2 = extru(ir, fpr2pos, 5) * sizeof(double)/sizeof(u_int);
@@ -590,6 +610,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FTEST */
 				switch (fmt) {
 				    case 0:
@@ -609,8 +630,10 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3:
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 		    } /* end of switch subop */
 		} /* end of else for PA1.0 & PA1.1 */
+		BUG();
 	case 3: /* class 3 */
 		r2 = extru(ir,fpr2pos,5) * sizeof(double)/sizeof(u_int);
 		if (r2 == 0)
@@ -633,6 +656,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FSUB */
 				switch (fmt) {
 				    case 0:
@@ -645,6 +669,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 2: /* FMPY */
 				switch (fmt) {
 				    case 0:
@@ -657,6 +682,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 3: /* FDIV */
 				switch (fmt) {
 				    case 0:
@@ -669,6 +695,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 4: /* FREM */
 				switch (fmt) {
 				    case 0:
@@ -681,6 +708,7 @@ decode_0c(u_int ir, u_int class, u_int subop, u_int fpregs[])
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 		} /* end of class 3 switch */
 	} /* end of switch(class) */
 
@@ -736,10 +764,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1];
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 3: /* FABS */
 				switch (fmt) {
 				    case 2:
@@ -747,10 +777,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] & 0x7fffffff;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 6: /* FNEG */
 				switch (fmt) {
 				    case 2:
@@ -758,10 +790,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] ^ 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 7: /* FNEGABS */
 				switch (fmt) {
 				    case 2:
@@ -769,10 +803,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] | 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 4: /* FSQRT */
 				switch (fmt) {
 				    case 0:
@@ -785,6 +821,7 @@ u_int fpregs[];
 				    case 3:
 					return(MAJOR_0E_EXCP);
 				}
+				BUG();
 			case 5: /* FRMD */
 				switch (fmt) {
 				    case 0:
@@ -798,7 +835,7 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				}
 		} /* end of switch (subop */
-	
+		BUG();
 	case 1: /* class 1 */
 		df = extru(ir,fpdfpos,2); /* get dest format */
 		/*
@@ -826,6 +863,7 @@ u_int fpregs[];
 				    case 3: /* dbl/dbl */
 					return(MAJOR_0E_EXCP);
 				}
+				BUG();
 			case 1: /* FCNVXF */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -841,6 +879,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvxf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FCNVFX */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -856,6 +895,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfx(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 3: /* FCNVFXT */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -871,6 +911,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfxt(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 5: /* FCNVUF (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -886,6 +927,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvuf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 6: /* FCNVFU (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -901,6 +943,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfu(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 7: /* FCNVFUT (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -916,9 +959,11 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfut(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* undefined */
 				return(MAJOR_0C_EXCP);
 		} /* end of switch subop */
+		BUG();
 	case 2: /* class 2 */
 		/*
 		 * Be careful out there.
@@ -994,6 +1039,7 @@ u_int fpregs[];
 				}
 		    } /* end of switch subop */
 		} /* end of else for PA1.0 & PA1.1 */
+		BUG();
 	case 3: /* class 3 */
 		/*
 		 * Be careful out there.
@@ -1026,6 +1072,7 @@ u_int fpregs[];
 					return(dbl_fadd(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 1: /* FSUB */
 				switch (fmt) {
 				    case 0:
@@ -1035,6 +1082,7 @@ u_int fpregs[];
 					return(dbl_fsub(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FMPY or XMPYU */
 				/*
 				 * check for integer multiply (x bit set)
@@ -1071,6 +1119,7 @@ u_int fpregs[];
 					       &fpregs[r2],&fpregs[t],status));
 				    }
 				}
+				BUG();
 			case 3: /* FDIV */
 				switch (fmt) {
 				    case 0:
@@ -1080,6 +1129,7 @@ u_int fpregs[];
 					return(dbl_fdiv(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* FREM */
 				switch (fmt) {
 				    case 0:
diff --git a/arch/powerpc/kernel/idle_book3s.S b/arch/powerpc/kernel/idle_book3s.S
index 22f249b6f58d..b16aecaaa912 100644
--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -52,28 +52,32 @@ _GLOBAL(isa300_idle_stop_mayloss)
 	std	r1,PACAR1(r13)
 	mflr	r4
 	mfcr	r5
-	/* use stack red zone rather than a new frame for saving regs */
-	std	r2,-8*0(r1)
-	std	r14,-8*1(r1)
-	std	r15,-8*2(r1)
-	std	r16,-8*3(r1)
-	std	r17,-8*4(r1)
-	std	r18,-8*5(r1)
-	std	r19,-8*6(r1)
-	std	r20,-8*7(r1)
-	std	r21,-8*8(r1)
-	std	r22,-8*9(r1)
-	std	r23,-8*10(r1)
-	std	r24,-8*11(r1)
-	std	r25,-8*12(r1)
-	std	r26,-8*13(r1)
-	std	r27,-8*14(r1)
-	std	r28,-8*15(r1)
-	std	r29,-8*16(r1)
-	std	r30,-8*17(r1)
-	std	r31,-8*18(r1)
-	std	r4,-8*19(r1)
-	std	r5,-8*20(r1)
+	/*
+	 * Use the stack red zone rather than a new frame for saving regs since
+	 * in the case of no GPR loss the wakeup code branches directly back to
+	 * the caller without deallocating the stack frame first.
+	 */
+	std	r2,-8*1(r1)
+	std	r14,-8*2(r1)
+	std	r15,-8*3(r1)
+	std	r16,-8*4(r1)
+	std	r17,-8*5(r1)
+	std	r18,-8*6(r1)
+	std	r19,-8*7(r1)
+	std	r20,-8*8(r1)
+	std	r21,-8*9(r1)
+	std	r22,-8*10(r1)
+	std	r23,-8*11(r1)
+	std	r24,-8*12(r1)
+	std	r25,-8*13(r1)
+	std	r26,-8*14(r1)
+	std	r27,-8*15(r1)
+	std	r28,-8*16(r1)
+	std	r29,-8*17(r1)
+	std	r30,-8*18(r1)
+	std	r31,-8*19(r1)
+	std	r4,-8*20(r1)
+	std	r5,-8*21(r1)
 	/* 168 bytes */
 	PPC_STOP
 	b	.	/* catch bugs */
@@ -89,8 +93,8 @@ _GLOBAL(isa300_idle_stop_mayloss)
  */
 _GLOBAL(idle_return_gpr_loss)
 	ld	r1,PACAR1(r13)
-	ld	r4,-8*19(r1)
-	ld	r5,-8*20(r1)
+	ld	r4,-8*20(r1)
+	ld	r5,-8*21(r1)
 	mtlr	r4
 	mtcr	r5
 	/*
@@ -98,38 +102,40 @@ _GLOBAL(idle_return_gpr_loss)
 	 * from PACATOC. This could be avoided for that less common case
 	 * if KVM saved its r2.
 	 */
-	ld	r2,-8*0(r1)
-	ld	r14,-8*1(r1)
-	ld	r15,-8*2(r1)
-	ld	r16,-8*3(r1)
-	ld	r17,-8*4(r1)
-	ld	r18,-8*5(r1)
-	ld	r19,-8*6(r1)
-	ld	r20,-8*7(r1)
-	ld	r21,-8*8(r1)
-	ld	r22,-8*9(r1)
-	ld	r23,-8*10(r1)
-	ld	r24,-8*11(r1)
-	ld	r25,-8*12(r1)
-	ld	r26,-8*13(r1)
-	ld	r27,-8*14(r1)
-	ld	r28,-8*15(r1)
-	ld	r29,-8*16(r1)
-	ld	r30,-8*17(r1)
-	ld	r31,-8*18(r1)
+	ld	r2,-8*1(r1)
+	ld	r14,-8*2(r1)
+	ld	r15,-8*3(r1)
+	ld	r16,-8*4(r1)
+	ld	r17,-8*5(r1)
+	ld	r18,-8*6(r1)
+	ld	r19,-8*7(r1)
+	ld	r20,-8*8(r1)
+	ld	r21,-8*9(r1)
+	ld	r22,-8*10(r1)
+	ld	r23,-8*11(r1)
+	ld	r24,-8*12(r1)
+	ld	r25,-8*13(r1)
+	ld	r26,-8*14(r1)
+	ld	r27,-8*15(r1)
+	ld	r28,-8*16(r1)
+	ld	r29,-8*17(r1)
+	ld	r30,-8*18(r1)
+	ld	r31,-8*19(r1)
 	blr
 
 /*
  * This is the sequence required to execute idle instructions, as
  * specified in ISA v2.07 (and earlier). MSR[IR] and MSR[DR] must be 0.
- *
- * The 0(r1) slot is used to save r2 in isa206, so use that here.
+ * We have to store a GPR somewhere, ptesync, then reload it, and create
+ * a false dependency on the result of the load. It doesn't matter which
+ * GPR we store, or where we store it. We have already stored r2 to the
+ * stack at -8(r1) in isa206_idle_insn_mayloss, so use that.
  */
 #define IDLE_STATE_ENTER_SEQ_NORET(IDLE_INST)			\
 	/* Magic NAP/SLEEP/WINKLE mode enter sequence */	\
-	std	r2,0(r1);					\
+	std	r2,-8(r1);					\
 	ptesync;						\
-	ld	r2,0(r1);					\
+	ld	r2,-8(r1);					\
 236:	cmpd	cr0,r2,r2;					\
 	bne	236b;						\
 	IDLE_INST;						\
@@ -154,28 +160,32 @@ _GLOBAL(isa206_idle_insn_mayloss)
 	std	r1,PACAR1(r13)
 	mflr	r4
 	mfcr	r5
-	/* use stack red zone rather than a new frame for saving regs */
-	std	r2,-8*0(r1)
-	std	r14,-8*1(r1)
-	std	r15,-8*2(r1)
-	std	r16,-8*3(r1)
-	std	r17,-8*4(r1)
-	std	r18,-8*5(r1)
-	std	r19,-8*6(r1)
-	std	r20,-8*7(r1)
-	std	r21,-8*8(r1)
-	std	r22,-8*9(r1)
-	std	r23,-8*10(r1)
-	std	r24,-8*11(r1)
-	std	r25,-8*12(r1)
-	std	r26,-8*13(r1)
-	std	r27,-8*14(r1)
-	std	r28,-8*15(r1)
-	std	r29,-8*16(r1)
-	std	r30,-8*17(r1)
-	std	r31,-8*18(r1)
-	std	r4,-8*19(r1)
-	std	r5,-8*20(r1)
+	/*
+	 * Use the stack red zone rather than a new frame for saving regs since
+	 * in the case of no GPR loss the wakeup code branches directly back to
+	 * the caller without deallocating the stack frame first.
+	 */
+	std	r2,-8*1(r1)
+	std	r14,-8*2(r1)
+	std	r15,-8*3(r1)
+	std	r16,-8*4(r1)
+	std	r17,-8*5(r1)
+	std	r18,-8*6(r1)
+	std	r19,-8*7(r1)
+	std	r20,-8*8(r1)
+	std	r21,-8*9(r1)
+	std	r22,-8*10(r1)
+	std	r23,-8*11(r1)
+	std	r24,-8*12(r1)
+	std	r25,-8*13(r1)
+	std	r26,-8*14(r1)
+	std	r27,-8*15(r1)
+	std	r28,-8*16(r1)
+	std	r29,-8*17(r1)
+	std	r30,-8*18(r1)
+	std	r31,-8*19(r1)
+	std	r4,-8*20(r1)
+	std	r5,-8*21(r1)
 	cmpwi	r3,PNV_THREAD_NAP
 	bne	1f
 	IDLE_STATE_ENTER_SEQ_NORET(PPC_NAP)
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 91f274134884..452cbf98bfd7 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1578,8 +1578,6 @@ void __cpu_die(unsigned int cpu)
 
 void arch_cpu_idle_dead(void)
 {
-	sched_preempt_enable_no_resched();
-
 	/*
 	 * Disable on the down path. This will be re-enabled by
 	 * start_secondary() via start_secondary_resume() below
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5777b72bb8b6..db78123166a8 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -292,13 +292,16 @@ kvm_novcpu_exit:
  * r3 contains the SRR1 wakeup value, SRR1 is trashed.
  */
 _GLOBAL(idle_kvm_start_guest)
-	ld	r4,PACAEMERGSP(r13)
 	mfcr	r5
 	mflr	r0
-	std	r1,0(r4)
-	std	r5,8(r4)
-	std	r0,16(r4)
-	subi	r1,r4,STACK_FRAME_OVERHEAD
+	std	r5, 8(r1)	// Save CR in caller's frame
+	std	r0, 16(r1)	// Save LR in caller's frame
+	// Create frame on emergency stack
+	ld	r4, PACAEMERGSP(r13)
+	stdu	r1, -SWITCH_FRAME_SIZE(r4)
+	// Switch to new frame on emergency stack
+	mr	r1, r4
+	std	r3, 32(r1)	// Save SRR1 wakeup value
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -350,6 +353,10 @@ kvm_unsplit_wakeup:
 
 kvm_secondary_got_guest:
 
+	// About to go to guest, clear saved SRR1
+	li	r0, 0
+	std	r0, 32(r1)
+
 	/* Set HSTATE_DSCR(r13) to something sensible */
 	ld	r6, PACA_DSCR_DEFAULT(r13)
 	std	r6, HSTATE_DSCR(r13)
@@ -441,13 +448,12 @@ kvm_no_guest:
 	mfspr	r4, SPRN_LPCR
 	rlwimi	r4, r3, 0, LPCR_PECE0 | LPCR_PECE1
 	mtspr	SPRN_LPCR, r4
-	/* set up r3 for return */
-	mfspr	r3,SPRN_SRR1
+	// Return SRR1 wakeup value, or 0 if we went into the guest
+	ld	r3, 32(r1)
 	REST_NVGPRS(r1)
-	addi	r1, r1, STACK_FRAME_OVERHEAD
-	ld	r0, 16(r1)
-	ld	r5, 8(r1)
-	ld	r1, 0(r1)
+	ld	r1, 0(r1)	// Switch back to caller stack
+	ld	r0, 16(r1)	// Reload LR
+	ld	r5, 8(r1)	// Reload CR
 	mtlr	r0
 	mtcr	r5
 	blr
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index a75d94a9bcb2..1226971533fe 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -205,6 +205,9 @@ int zpci_create_device(u32 fid, u32 fh, enum zpci_state state);
 void zpci_remove_device(struct zpci_dev *zdev, bool set_error);
 int zpci_enable_device(struct zpci_dev *);
 int zpci_disable_device(struct zpci_dev *);
+void zpci_device_reserved(struct zpci_dev *zdev);
+bool zpci_is_device_configured(struct zpci_dev *zdev);
+
 int zpci_register_ioat(struct zpci_dev *, u8, u64, u64, u64);
 int zpci_unregister_ioat(struct zpci_dev *, u8);
 void zpci_remove_reserved_devices(void);
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index f5ddbc625c1a..e14e4a3a647a 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -92,7 +92,7 @@ void zpci_remove_reserved_devices(void)
 	spin_unlock(&zpci_list_lock);
 
 	list_for_each_entry_safe(zdev, tmp, &remove, entry)
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 }
 
 int pci_domain_nr(struct pci_bus *bus)
@@ -787,6 +787,39 @@ int zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
 	return rc;
 }
 
+bool zpci_is_device_configured(struct zpci_dev *zdev)
+{
+	enum zpci_state state = zdev->state;
+
+	return state != ZPCI_FN_STATE_RESERVED &&
+		state != ZPCI_FN_STATE_STANDBY;
+}
+
+/**
+ * zpci_device_reserved() - Mark device as resverved
+ * @zdev: the zpci_dev that was reserved
+ *
+ * Handle the case that a given zPCI function was reserved by another system.
+ * After a call to this function the zpci_dev can not be found via
+ * get_zdev_by_fid() anymore but may still be accessible via existing
+ * references though it will not be functional anymore.
+ */
+void zpci_device_reserved(struct zpci_dev *zdev)
+{
+	if (zdev->has_hp_slot)
+		zpci_exit_slot(zdev);
+	/*
+	 * Remove device from zpci_list as it is going away. This also
+	 * makes sure we ignore subsequent zPCI events for this device.
+	 */
+	spin_lock(&zpci_list_lock);
+	list_del(&zdev->entry);
+	spin_unlock(&zpci_list_lock);
+	zdev->state = ZPCI_FN_STATE_RESERVED;
+	zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+	zpci_zdev_put(zdev);
+}
+
 void zpci_release_device(struct kref *kref)
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
@@ -802,6 +835,12 @@ void zpci_release_device(struct kref *kref)
 	case ZPCI_FN_STATE_STANDBY:
 		if (zdev->has_hp_slot)
 			zpci_exit_slot(zdev);
+		spin_lock(&zpci_list_lock);
+		list_del(&zdev->entry);
+		spin_unlock(&zpci_list_lock);
+		zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
+		fallthrough;
+	case ZPCI_FN_STATE_RESERVED:
 		zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
 		zpci_destroy_iommu(zdev);
@@ -809,10 +848,6 @@ void zpci_release_device(struct kref *kref)
 	default:
 		break;
 	}
-
-	spin_lock(&zpci_list_lock);
-	list_del(&zdev->entry);
-	spin_unlock(&zpci_list_lock);
 	zpci_dbg(3, "rem fid:%x\n", zdev->fid);
 	kfree(zdev);
 }
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index ac0c65cdd69d..b7cfde7e80a8 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -146,7 +146,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 		zdev->state = ZPCI_FN_STATE_STANDBY;
 		if (!clp_get_state(ccdf->fid, &state) &&
 		    state == ZPCI_FN_STATE_RESERVED) {
-			zpci_zdev_put(zdev);
+			zpci_device_reserved(zdev);
 		}
 		break;
 	case 0x0306: /* 0x308 or 0x302 for multiple devices */
@@ -156,7 +156,7 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	case 0x0308: /* Standby -> Reserved */
 		if (!zdev)
 			break;
-		zpci_zdev_put(zdev);
+		zpci_device_reserved(zdev);
 		break;
 	default:
 		break;
diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 4be8f9cabd07..ca8ce64df2ce 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -68,6 +68,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_D:
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0dba0037a85..f77d98973782 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6316,18 +6316,13 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 
 		/*
 		 * If we are running L2 and L1 has a new pending interrupt
-		 * which can be injected, we should re-evaluate
-		 * what should be done with this new L1 interrupt.
-		 * If L1 intercepts external-interrupts, we should
-		 * exit from L2 to L1. Otherwise, interrupt should be
-		 * delivered directly to L2.
+		 * which can be injected, this may cause a vmexit or it may
+		 * be injected into L2.  Either way, this interrupt will be
+		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
+		 * virtual interrupt delivery to inject L1 interrupts into L2.
 		 */
-		if (is_guest_mode(vcpu) && max_irr_updated) {
-			if (nested_exit_on_intr(vcpu))
-				kvm_vcpu_exiting_guest_mode(vcpu);
-			else
-				kvm_make_request(KVM_REQ_EVENT, vcpu);
-		}
+		if (is_guest_mode(vcpu) && max_irr_updated)
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	} else {
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 	}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index aa9f50fccc5d..0f68c6da7382 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -51,9 +51,6 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(uint32_t, xen_vcpu_id);
 EXPORT_PER_CPU_SYMBOL(xen_vcpu_id);
 
-enum xen_domain_type xen_domain_type = XEN_NATIVE;
-EXPORT_SYMBOL_GPL(xen_domain_type);
-
 unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
 EXPORT_SYMBOL(machine_to_phys_mapping);
 unsigned long  machine_to_phys_nr;
@@ -68,9 +65,11 @@ __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 
 /*
- * NB: needs to live in .data because it's used by xen_prepare_pvh which runs
- * before clearing the bss.
+ * NB: These need to live in .data or alike because they're used by
+ * xen_prepare_pvh() which runs before clearing the bss.
  */
+enum xen_domain_type __ro_after_init xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
 uint32_t xen_start_flags __section(".data") = 0;
 EXPORT_SYMBOL(xen_start_flags);
 
diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 4f7d6142d41f..538e6748e85a 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -51,8 +51,12 @@ void platform_power_off(void)
 
 void platform_restart(void)
 {
-	/* Flush and reset the mmu, simulate a processor reset, and
-	 * jump to the reset vector. */
+	/* Try software reset first. */
+	WRITE_ONCE(*(u32 *)XTFPGA_SWRST_VADDR, 0xdead);
+
+	/* If software reset did not work, flush and reset the mmu,
+	 * simulate a processor reset, and jump to the reset vector.
+	 */
 	cpu_reset();
 	/* control never gets here */
 }
@@ -66,7 +70,7 @@ void __init platform_calibrate_ccount(void)
 
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static void __init xtfpga_clk_setup(struct device_node *np)
 {
@@ -284,4 +288,4 @@ static int __init xtavnet_init(void)
  */
 arch_initcall(xtavnet_init);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4de03da9a624..b5f26082b959 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -129,6 +129,7 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(PCI_P2PDMA),
 	QUEUE_FLAG_NAME(ZONE_RESETALL),
 	QUEUE_FLAG_NAME(RQ_ALLOC_TIME),
+	QUEUE_FLAG_NAME(HCTX_ACTIVE),
 	QUEUE_FLAG_NAME(NOWAIT),
 };
 #undef QUEUE_FLAG_NAME
diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index 3c410d236c49..f3274eb6b341 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -33,6 +33,8 @@ config DRM_AMD_DC_HDCP
 
 config DRM_AMD_DC_SI
 	bool "AMD DC support for Southern Islands ASICs"
+	depends on DRM_AMDGPU_SI
+	depends on DRM_AMD_DC
 	default n
 	help
 	  Choose this option to enable new AMD DC support for SI asics
diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.c b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
index f31e8ef3c258..25e422d2e7f8 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -268,7 +268,11 @@ static void mxsfb_irq_disable(struct drm_device *drm)
 	struct mxsfb_drm_private *mxsfb = drm->dev_private;
 
 	mxsfb_enable_axi_clk(mxsfb);
-	mxsfb->crtc.funcs->disable_vblank(&mxsfb->crtc);
+
+	/* Disable and clear VBLANK IRQ */
+	writel(CTRL1_CUR_FRAME_DONE_IRQ_EN, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+	writel(CTRL1_CUR_FRAME_DONE_IRQ, mxsfb->base + LCDC_CTRL1 + REG_CLR);
+
 	mxsfb_disable_axi_clk(mxsfb);
 }
 
diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index 0145129d7c66..534dd7414d42 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -590,14 +590,14 @@ static const struct drm_display_mode k101_im2byl02_default_mode = {
 	.clock		= 69700,
 
 	.hdisplay	= 800,
-	.hsync_start	= 800 + 6,
-	.hsync_end	= 800 + 6 + 15,
-	.htotal		= 800 + 6 + 15 + 16,
+	.hsync_start	= 800 + 52,
+	.hsync_end	= 800 + 52 + 8,
+	.htotal		= 800 + 52 + 8 + 48,
 
 	.vdisplay	= 1280,
-	.vsync_start	= 1280 + 8,
-	.vsync_end	= 1280 + 8 + 48,
-	.vtotal		= 1280 + 8 + 48 + 52,
+	.vsync_start	= 1280 + 16,
+	.vsync_end	= 1280 + 16 + 6,
+	.vtotal		= 1280 + 16 + 6 + 15,
 
 	.width_mm	= 135,
 	.height_mm	= 217,
diff --git a/drivers/input/keyboard/snvs_pwrkey.c b/drivers/input/keyboard/snvs_pwrkey.c
index 2f5e3ab5ed63..65286762b02a 100644
--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -3,6 +3,7 @@
 // Driver for the IMX SNVS ON/OFF Power Key
 // Copyright (C) 2015 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -99,6 +100,11 @@ static irqreturn_t imx_snvs_pwrkey_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void imx_snvs_pwrkey_disable_clk(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 static void imx_snvs_pwrkey_act(void *pdata)
 {
 	struct pwrkey_drv_data *pd = pdata;
@@ -111,6 +117,7 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
 	struct pwrkey_drv_data *pdata;
 	struct input_dev *input;
 	struct device_node *np;
+	struct clk *clk;
 	int error;
 	u32 vid;
 
@@ -134,6 +141,28 @@ static int imx_snvs_pwrkey_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "KEY_POWER without setting in dts\n");
 	}
 
+	clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Failed to get snvs clock (%pe)\n", clk);
+		return PTR_ERR(clk);
+	}
+
+	error = clk_prepare_enable(clk);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to enable snvs clock (%pe)\n",
+			ERR_PTR(error));
+		return error;
+	}
+
+	error = devm_add_action_or_reset(&pdev->dev,
+					 imx_snvs_pwrkey_disable_clk, clk);
+	if (error) {
+		dev_err(&pdev->dev,
+			"Failed to register clock cleanup handler (%pe)\n",
+			ERR_PTR(error));
+		return error;
+	}
+
 	pdata->wakeup = of_property_read_bool(np, "wakeup-source");
 
 	pdata->irq = platform_get_irq(pdev, 0);
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index cb0afe897162..7313454e403a 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -480,6 +480,11 @@ int detach_capi_ctr(struct capi_ctr *ctr)
 
 	ctr_down(ctr, CAPI_CTR_DETACHED);
 
+	if (ctr->cnr < 1 || ctr->cnr - 1 >= CAPI_MAXCONTR) {
+		err = -EINVAL;
+		goto unlock_out;
+	}
+
 	if (capi_controller[ctr->cnr - 1] != ctr) {
 		err = -EINVAL;
 		goto unlock_out;
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 2a1ddd47a096..a52f275f8263 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -949,8 +949,8 @@ nj_release(struct tiger_hw *card)
 		nj_disable_hwirq(card);
 		mode_tiger(&card->bc[0], ISDN_P_NONE);
 		mode_tiger(&card->bc[1], ISDN_P_NONE);
-		card->isac.release(&card->isac);
 		spin_unlock_irqrestore(&card->lock, flags);
+		card->isac.release(&card->isac);
 		release_region(card->base, card->base_s);
 		card->base_s = 0;
 	}
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 48575900adb7..3570a4de0085 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -846,10 +846,12 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
 	struct rcar_can_priv *priv = netdev_priv(ndev);
 	u16 ctlr;
 
-	if (netif_running(ndev)) {
-		netif_stop_queue(ndev);
-		netif_device_detach(ndev);
-	}
+	if (!netif_running(ndev))
+		return 0;
+
+	netif_stop_queue(ndev);
+	netif_device_detach(ndev);
+
 	ctlr = readw(&priv->regs->ctlr);
 	ctlr |= RCAR_CAN_CTLR_CANM_HALT;
 	writew(ctlr, &priv->regs->ctlr);
@@ -868,6 +870,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 	u16 ctlr;
 	int err;
 
+	if (!netif_running(ndev))
+		return 0;
+
 	err = clk_enable(priv->clk);
 	if (err) {
 		netdev_err(ndev, "clk_enable() failed, error %d\n", err);
@@ -881,10 +886,9 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 	writew(ctlr, &priv->regs->ctlr);
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	if (netif_running(ndev)) {
-		netif_device_attach(ndev);
-		netif_start_queue(ndev);
-	}
+	netif_device_attach(ndev);
+	netif_start_queue(ndev);
+
 	return 0;
 }
 
diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 4713921bd511..c3fd7cd802a9 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -731,16 +731,15 @@ static void peak_pci_remove(struct pci_dev *pdev)
 		struct net_device *prev_dev = chan->prev_dev;
 
 		dev_info(&pdev->dev, "removing device %s\n", dev->name);
+		/* do that only for first channel */
+		if (!prev_dev && chan->pciec_card)
+			peak_pciec_remove(chan->pciec_card);
 		unregister_sja1000dev(dev);
 		free_sja1000dev(dev);
 		dev = prev_dev;
 
-		if (!dev) {
-			/* do that only for first channel */
-			if (chan->pciec_card)
-				peak_pciec_remove(chan->pciec_card);
+		if (!dev)
 			break;
-		}
 		priv = netdev_priv(dev);
 		chan = priv->priv;
 	}
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index d56592283818..301a0f54fc99 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -551,11 +551,10 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 	} else if (sm->channel_p_w_b & PUCAN_BUS_WARNING) {
 		new_state = CAN_STATE_ERROR_WARNING;
 	} else {
-		/* no error bit (so, no error skb, back to active state) */
-		dev->can.state = CAN_STATE_ERROR_ACTIVE;
+		/* back to (or still in) ERROR_ACTIVE state */
+		new_state = CAN_STATE_ERROR_ACTIVE;
 		pdev->bec.txerr = 0;
 		pdev->bec.rxerr = 0;
-		return 0;
 	}
 
 	/* state hasn't changed */
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 95e634cbc4b6..4d23a7aba796 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -229,7 +229,7 @@
 #define GSWIP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
 #define  GSWIP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
 #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
-#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
+#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(3)	/* Pause Frame Forwarding */
 
 #define GSWIP_TABLE_ACTIVE_VLAN		0x01
 #define GSWIP_TABLE_VLAN_MAPPING	0x02
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 73de09093c35..1f642fdbf214 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -981,9 +981,6 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Allow the user port gets connected to the cpu port and also
@@ -1006,9 +1003,6 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Clear up all port matrix which could be restored in the next
@@ -2593,7 +2587,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = DSA_MAX_PORTS;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
 
 	/* Use medatek,mcm property to distinguish hardware type that would
 	 * casues a little bit differences on power-on sequence.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 89e558135432..9c1690f64a02 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -157,7 +157,7 @@ static const struct {
 	{ ENETC_PM0_TFRM,   "MAC tx frames" },
 	{ ENETC_PM0_TFCS,   "MAC tx fcs errors" },
 	{ ENETC_PM0_TVLAN,  "MAC tx VLAN frames" },
-	{ ENETC_PM0_TERR,   "MAC tx frames" },
+	{ ENETC_PM0_TERR,   "MAC tx frame errors" },
 	{ ENETC_PM0_TUCA,   "MAC tx unicast frames" },
 	{ ENETC_PM0_TMCA,   "MAC tx multicast frames" },
 	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index eef1b2764d34..67b0bf310daa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -10,6 +10,27 @@ static LIST_HEAD(hnae3_ae_algo_list);
 static LIST_HEAD(hnae3_client_list);
 static LIST_HEAD(hnae3_ae_dev_list);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo)
+{
+	const struct pci_device_id *pci_id;
+	struct hnae3_ae_dev *ae_dev;
+
+	if (!ae_algo)
+		return;
+
+	list_for_each_entry(ae_dev, &hnae3_ae_dev_list, node) {
+		if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_INITED_B))
+			continue;
+
+		pci_id = pci_match_id(ae_algo->pdev_id_table, ae_dev->pdev);
+		if (!pci_id)
+			continue;
+		if (IS_ENABLED(CONFIG_PCI_IOV))
+			pci_disable_sriov(ae_dev->pdev);
+	}
+}
+EXPORT_SYMBOL(hnae3_unregister_ae_algo_prepare);
+
 /* we are keeping things simple and using single lock for all the
  * list. This is a non-critical code so other updations, if happen
  * in parallel, can wait.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 912c51e327d6..4a9576a449e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -754,6 +754,7 @@ struct hnae3_handle {
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
+void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo);
 void hnae3_unregister_ae_algo(struct hnae3_ae_algo *ae_algo);
 void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4777db2623cf..ae7cd73c823b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1283,7 +1283,6 @@ void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
 
 static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb,
-			      u8 max_non_tso_bd_num,
 			      unsigned int bd_num)
 {
 	/* 'bd_num == UINT_MAX' means the skb' fraglist has a
@@ -1300,8 +1299,7 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 * will not help.
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
-	    (!skb_is_gso(skb) && skb->len >
-	     HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))) {
+	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.hw_limitation++;
 		u64_stats_update_end(&ring->syncp);
@@ -1336,8 +1334,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 			goto out;
 		}
 
-		if (hns3_skb_linearize(ring, skb, max_non_tso_bd_num,
-				       bd_num))
+		if (hns3_skb_linearize(ring, skb, bd_num))
 			return -ENOMEM;
 
 		bd_num = hns3_tx_bd_count(skb->len);
@@ -2424,6 +2421,7 @@ static void hns3_buffer_detach(struct hns3_enet_ring *ring, int i)
 {
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc[i].addr = 0;
+	ring->desc_cb[i].refill = 0;
 }
 
 static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i,
@@ -2501,6 +2499,7 @@ static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
 		return ret;
 
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
+	ring->desc_cb[i].refill = 1;
 
 	return 0;
 }
@@ -2531,12 +2530,14 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc_cb[i] = *res_cb;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].rx.bd_base_info = 0;
 }
 
 static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 {
 	ring->desc_cb[i].reuse_flag = 0;
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
@@ -2634,10 +2635,14 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	int ntc = ring->next_to_clean;
 	int ntu = ring->next_to_use;
 
+	if (unlikely(ntc == ntu && !ring->desc_cb[ntc].refill))
+		return ring->desc_num;
+
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
-static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
+/* Return true if there is any allocation failure */
+static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				      int cleand_count)
 {
 	struct hns3_desc_cb *desc_cb;
@@ -2662,7 +2667,10 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
 					    ret);
-				break;
+
+				writel(i, ring->tqp->io_base +
+				       HNS3_RING_RX_RING_HEAD_REG);
+				return true;
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
@@ -2675,6 +2683,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	}
 
 	writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
+	return false;
 }
 
 static bool hns3_page_is_reusable(struct page *page)
@@ -2905,6 +2914,7 @@ static void hns3_rx_ring_move_fw(struct hns3_enet_ring *ring)
 {
 	ring->desc[ring->next_to_clean].rx.bd_base_info &=
 		cpu_to_le32(~BIT(HNS3_RXD_VLD_B));
+	ring->desc_cb[ring->next_to_clean].refill = 0;
 	ring->next_to_clean += 1;
 
 	if (unlikely(ring->next_to_clean == ring->desc_num))
@@ -3218,6 +3228,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 {
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int unused_count = hns3_desc_unused(ring);
+	bool failure = false;
 	int recv_pkts = 0;
 	int err;
 
@@ -3226,9 +3237,9 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	while (recv_pkts < budget) {
 		/* Reuse or realloc buffers */
 		if (unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
-			hns3_nic_alloc_rx_buffers(ring, unused_count);
-			unused_count = hns3_desc_unused(ring) -
-					ring->pending_buf;
+			failure = failure ||
+				hns3_nic_alloc_rx_buffers(ring, unused_count);
+			unused_count = 0;
 		}
 
 		/* Poll one pkt */
@@ -3247,11 +3258,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	}
 
 out:
-	/* Make all data has been write before submit */
-	if (unused_count > 0)
-		hns3_nic_alloc_rx_buffers(ring, unused_count);
-
-	return recv_pkts;
+	return failure ? budget : recv_pkts;
 }
 
 static bool hns3_get_new_flow_lvl(struct hns3_enet_ring_group *ring_group)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 398686b15a82..54d02ea4aaa7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -170,11 +170,9 @@ enum hns3_nic_state {
 
 #define HNS3_MAX_BD_SIZE			65535
 #define HNS3_MAX_TSO_BD_NUM			63U
-#define HNS3_MAX_TSO_SIZE \
-	(HNS3_MAX_BD_SIZE * HNS3_MAX_TSO_BD_NUM)
+#define HNS3_MAX_TSO_SIZE			1048576U
+#define HNS3_MAX_NON_TSO_SIZE			9728U
 
-#define HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num) \
-	(HNS3_MAX_BD_SIZE * (max_non_tso_bd_num))
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200
@@ -285,6 +283,7 @@ struct hns3_desc_cb {
 	u32 length;     /* length of the buffer */
 
 	u16 reuse_flag;
+	u16 refill;
 
 	/* desc type, used by the ring user to mark the type of the priv data */
 	u16 type;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 28a90ead4795..8e6085753b9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -134,6 +134,15 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 				*changed = true;
 			break;
 		case IEEE_8021QAZ_TSA_ETS:
+			/* The hardware will switch to sp mode if bandwidth is
+			 * 0, so limit ets bandwidth must be greater than 0.
+			 */
+			if (!ets->tc_tx_bw[i]) {
+				dev_err(&hdev->pdev->dev,
+					"tc%u ets bw cannot be 0\n", i);
+				return -EINVAL;
+			}
+
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
 				HCLGE_SCH_MODE_DWRR)
 				*changed = true;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e869f449f12..7b94764b4f5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11518,6 +11518,7 @@ static int hclge_init(void)
 
 static void hclge_exit(void)
 {
+	hnae3_unregister_ae_algo_prepare(&ae_algo);
 	hnae3_unregister_ae_algo(&ae_algo);
 	destroy_workqueue(hclge_wq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 69d081515c60..71aa6d16fc19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -671,6 +671,8 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 		hdev->tm_info.pg_info[i].tc_bit_map = hdev->hw_tc_map;
 		for (k = 0; k < hdev->tm_info.num_tc; k++)
 			hdev->tm_info.pg_info[i].tc_dwrr[k] = BW_PERCENT;
+		for (; k < HNAE3_MAX_TC; k++)
+			hdev->tm_info.pg_info[i].tc_dwrr[k] = 0;
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3641d7c31451..a47f23f27a11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2160,9 +2160,9 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		hdev->reset_attempts = 0;
 
 		hdev->last_reset_time = jiffies;
-		while ((hdev->reset_type =
-			hclgevf_get_reset_level(hdev, &hdev->reset_pending))
-		       != HNAE3_NONE_RESET)
+		hdev->reset_type =
+			hclgevf_get_reset_level(hdev, &hdev->reset_pending);
+		if (hdev->reset_type != HNAE3_NONE_RESET)
 			hclgevf_reset(hdev);
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
 				      &hdev->reset_state)) {
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 5b2143f4b1f8..3178efd98006 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -113,7 +113,8 @@ enum e1000_boards {
 	board_pch2lan,
 	board_pch_lpt,
 	board_pch_spt,
-	board_pch_cnp
+	board_pch_cnp,
+	board_pch_tgp
 };
 
 struct e1000_ps_page {
@@ -499,6 +500,7 @@ extern const struct e1000_info e1000_pch2_info;
 extern const struct e1000_info e1000_pch_lpt_info;
 extern const struct e1000_info e1000_pch_spt_info;
 extern const struct e1000_info e1000_pch_cnp_info;
+extern const struct e1000_info e1000_pch_tgp_info;
 extern const struct e1000_info e1000_es2_info;
 
 void e1000e_ptp_init(struct e1000_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 854c585de2e1..b38b914f9ac6 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4811,7 +4811,7 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 {
 	struct e1000_mac_info *mac = &hw->mac;
-	u32 ctrl_ext, txdctl, snoop;
+	u32 ctrl_ext, txdctl, snoop, fflt_dbg;
 	s32 ret_val;
 	u16 i;
 
@@ -4870,6 +4870,15 @@ static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 		snoop = (u32)~(PCIE_NO_SNOOP_ALL);
 	e1000e_set_pcie_no_snoop(hw, snoop);
 
+	/* Enable workaround for packet loss issue on TGP PCH
+	 * Do not gate DMA clock from the modPHY block
+	 */
+	if (mac->type >= e1000_pch_tgp) {
+		fflt_dbg = er32(FFLT_DBG);
+		fflt_dbg |= E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK;
+		ew32(FFLT_DBG, fflt_dbg);
+	}
+
 	ctrl_ext = er32(CTRL_EXT);
 	ctrl_ext |= E1000_CTRL_EXT_RO_DIS;
 	ew32(CTRL_EXT, ctrl_ext);
@@ -5990,3 +5999,23 @@ const struct e1000_info e1000_pch_cnp_info = {
 	.phy_ops		= &ich8_phy_ops,
 	.nvm_ops		= &spt_nvm_ops,
 };
+
+const struct e1000_info e1000_pch_tgp_info = {
+	.mac			= e1000_pch_tgp,
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
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index e757896287eb..8f2a8f4ce0ee 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -286,6 +286,9 @@
 /* Proprietary Latency Tolerance Reporting PCI Capability */
 #define E1000_PCI_LTR_CAP_LPT		0xA8
 
+/* Don't gate wake DMA clock */
+#define E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK	0x1000
+
 void e1000e_write_protect_nvm_ich8lan(struct e1000_hw *hw);
 void e1000e_set_kmrn_lock_loss_workaround_ich8lan(struct e1000_hw *hw,
 						  bool state);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 361b8d0bd78d..d0c4de023112 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -50,6 +50,7 @@ static const struct e1000_info *e1000_info_tbl[] = {
 	[board_pch_lpt]		= &e1000_pch_lpt_info,
 	[board_pch_spt]		= &e1000_pch_spt_info,
 	[board_pch_cnp]		= &e1000_pch_cnp_info,
+	[board_pch_tgp]		= &e1000_pch_tgp_info,
 };
 
 struct e1000_reg_info {
@@ -7837,20 +7838,20 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V12), board_pch_spt },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_tgp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2239a5f45e5a..64714757bd4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -24,6 +24,8 @@ static enum ice_status ice_set_mac_type(struct ice_hw *hw)
 	case ICE_DEV_ID_E810C_BACKPLANE:
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E810_XXV_BACKPLANE:
+	case ICE_DEV_ID_E810_XXV_QSFP:
 	case ICE_DEV_ID_E810_XXV_SFP:
 		hw->mac_type = ICE_MAC_E810;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 9d8194671f6a..ef4392e6e244 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -21,6 +21,10 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
+/* Intel(R) Ethernet Controller E810-XXV for backplane */
+#define ICE_DEV_ID_E810_XXV_BACKPLANE	0x1599
+/* Intel(R) Ethernet Controller E810-XXV for QSFP */
+#define ICE_DEV_ID_E810_XXV_QSFP	0x159A
 /* Intel(R) Ethernet Controller E810-XXV for SFP */
 #define ICE_DEV_ID_E810_XXV_SFP		0x159B
 /* Intel(R) Ethernet Connection E823-C for backplane */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 9095b4d274ad..a81be917f653 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1669,7 +1669,7 @@ static u16 ice_tunnel_idx_to_entry(struct ice_hw *hw, enum ice_tunnel_type type,
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
 		if (hw->tnl.tbl[i].valid &&
 		    hw->tnl.tbl[i].type == type &&
-		    idx--)
+		    idx-- == 0)
 			return i;
 
 	WARN_ON_ONCE(1);
@@ -1829,7 +1829,7 @@ int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
 	u16 index;
 
 	tnl_type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? TNL_VXLAN : TNL_GENEVE;
-	index = ice_tunnel_idx_to_entry(&pf->hw, idx, tnl_type);
+	index = ice_tunnel_idx_to_entry(&pf->hw, tnl_type, idx);
 
 	status = ice_create_tunnel(&pf->hw, index, tnl_type, ntohs(ti->port));
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5d0dc1f811e0..66d92a0cfef3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4773,6 +4773,8 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_SFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_QSFP), 0 },
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index fad503820e04..b3365b34cac7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -71,6 +71,7 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 
 static const struct of_device_id dwmac_generic_match[] = {
 	{ .compatible = "st,spear600-gmac"},
+	{ .compatible = "snps,dwmac-3.40a"},
 	{ .compatible = "snps,dwmac-3.50a"},
 	{ .compatible = "snps,dwmac-3.610"},
 	{ .compatible = "snps,dwmac-3.70a"},
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6133b2fe8a78..0ac61e7ab43c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -605,7 +605,7 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
-			if (priv->synopsys_id != DWMAC_CORE_5_10)
+			if (priv->synopsys_id < DWMAC_CORE_4_10)
 				ts_event_en = PTP_TCR_TSEVNTENA;
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 53be8fc1d125..48186cd32ce1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -508,6 +508,14 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		plat->pmt = 1;
 	}
 
+	if (of_device_is_compatible(np, "snps,dwmac-3.40a")) {
+		plat->has_gmac = 1;
+		plat->enh_desc = 1;
+		plat->tx_coe = 1;
+		plat->bugged_jumbo = 1;
+		plat->pmt = 1;
+	}
+
 	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2645ca35103c..453490be7055 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -544,6 +544,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
+		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 4efad42b9aa9..867ff2ee8ecf 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -117,6 +117,7 @@ config USB_LAN78XX
 	select PHYLIB
 	select MICROCHIP_PHY
 	select FIXED_PHY
+	select CRC32
 	help
 	  This option adds support for Microchip LAN78XX based USB 2
 	  & USB 3 10/100/1000 Ethernet adapters.
diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
index a047c421debe..93174f503464 100644
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -109,14 +109,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct zpci_dev *zdev = container_of(hotplug_slot, struct zpci_dev,
 					     hotplug_slot);
 
-	switch (zdev->state) {
-	case ZPCI_FN_STATE_STANDBY:
-		*value = 0;
-		break;
-	default:
-		*value = 1;
-		break;
-	}
+	*value = zpci_is_device_configured(zdev) ? 1 : 0;
 	return 0;
 }
 
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 3af4430543dc..a5f1f6ba7439 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1645,8 +1645,8 @@ int __maybe_unused stm32_pinctrl_resume(struct device *dev)
 	struct stm32_pinctrl_group *g = pctl->groups;
 	int i;
 
-	for (i = g->pin; i < g->pin + pctl->ngroups; i++)
-		stm32_pinctrl_restore_gpio_regs(pctl, i);
+	for (i = 0; i < pctl->ngroups; i++, g++)
+		stm32_pinctrl_restore_gpio_regs(pctl, g->pin);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 425d2064148f..69d706039cb2 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -247,7 +247,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return -ETIMEDOUT;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index da3920a19d53..d664c4650b2d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
-	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
+	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 7fa085969a63..1fd292a6ac88 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -414,7 +414,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 41772b88610a..3f7fa8de3642 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2907,8 +2907,6 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		err = transport->set_param(conn, ev->u.set_param.param,
-					   data, ev->u.set_param.len);
 		if ((conn->state == ISCSI_CONN_BOUND) ||
 			(conn->state == ISCSI_CONN_UP)) {
 			err = transport->set_param(conn, ev->u.set_param.param,
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 2299866dc82f..8c65e9476b41 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -276,8 +276,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
-	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483)
+	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+		xhci->quirks |= XHCI_EP_CTX_BROKEN_DCS;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ec8f2910faf9..4512c4223392 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -562,7 +562,10 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
 	struct xhci_segment *new_seg;
+	struct xhci_segment *halted_seg = NULL;
 	union xhci_trb *new_deq;
+	union xhci_trb *halted_trb;
+	int index = 0;
 	dma_addr_t addr;
 	u64 hw_dequeue;
 	bool cycle_found = false;
@@ -600,7 +603,28 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	hw_dequeue = xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
 	new_seg = ep_ring->deq_seg;
 	new_deq = ep_ring->dequeue;
-	state->new_cycle_state = hw_dequeue & 0x1;
+
+	/*
+	 * Quirk: xHC write-back of the DCS field in the hardware dequeue
+	 * pointer is wrong - use the cycle state of the TRB pointed to by
+	 * the dequeue pointer.
+	 */
+	if (xhci->quirks & XHCI_EP_CTX_BROKEN_DCS &&
+	    !(ep->ep_state & EP_HAS_STREAMS))
+		halted_seg = trb_in_td(xhci, cur_td->start_seg,
+				       cur_td->first_trb, cur_td->last_trb,
+				       hw_dequeue & ~0xf, false);
+	if (halted_seg) {
+		index = ((dma_addr_t)(hw_dequeue & ~0xf) - halted_seg->dma) /
+			 sizeof(*halted_trb);
+		halted_trb = &halted_seg->trbs[index];
+		state->new_cycle_state = halted_trb->generic.field[3] & 0x1;
+		xhci_dbg(xhci, "Endpoint DCS = %d TRB index = %d cycle = %d\n",
+			 (u8)(hw_dequeue & 0x1), index,
+			 state->new_cycle_state);
+	} else {
+		state->new_cycle_state = hw_dequeue & 0x1;
+	}
 	state->stream_id = stream_id;
 
 	/*
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1c97c8d81154..45584a278336 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1884,6 +1884,7 @@ struct xhci_hcd {
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c3bb5c4375ab..3b93a98fd544 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -894,9 +894,11 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 }
 
 /*
- * helper function to see if a given name and sequence number found
- * in an inode back reference are already in a directory and correctly
- * point to this inode
+ * See if a given name and sequence number found in an inode back reference are
+ * already in a directory and correctly point to this inode.
+ *
+ * Returns: < 0 on error, 0 if the directory entry does not exists and 1 if it
+ * exists.
  */
 static noinline int inode_in_dir(struct btrfs_root *root,
 				 struct btrfs_path *path,
@@ -905,29 +907,35 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key location;
-	int match = 0;
+	int ret = 0;
 
 	di = btrfs_lookup_dir_index_item(NULL, root, path, dirid,
 					 index, name, name_len, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		if (PTR_ERR(di) != -ENOENT)
+			ret = PTR_ERR(di);
+		goto out;
+	} else if (di) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
 		if (location.objectid != objectid)
 			goto out;
-	} else
+	} else {
 		goto out;
-	btrfs_release_path(path);
+	}
 
+	btrfs_release_path(path);
 	di = btrfs_lookup_dir_item(NULL, root, path, dirid, name, name_len, 0);
-	if (di && !IS_ERR(di)) {
-		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
-		if (location.objectid != objectid)
-			goto out;
-	} else
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
 		goto out;
-	match = 1;
+	} else if (di) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
+		if (location.objectid == objectid)
+			ret = 1;
+	}
 out:
 	btrfs_release_path(path);
-	return match;
+	return ret;
 }
 
 /*
@@ -1477,10 +1485,12 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 
-		/* if we already have a perfect match, we're done */
-		if (!inode_in_dir(root, path, btrfs_ino(BTRFS_I(dir)),
-					btrfs_ino(BTRFS_I(inode)), ref_index,
-					name, namelen)) {
+		ret = inode_in_dir(root, path, btrfs_ino(BTRFS_I(dir)),
+				   btrfs_ino(BTRFS_I(inode)), ref_index,
+				   name, namelen);
+		if (ret < 0) {
+			goto out;
+		} else if (ret == 0) {
 			/*
 			 * look for a conflicting back reference in the
 			 * metadata. if we find one we have to unlink that name
@@ -1538,6 +1548,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 			btrfs_update_inode(trans, root, inode);
 		}
+		/* Else, ret == 1, we already have a perfect match, we're done. */
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
 		kfree(name);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 48ea95b81df8..676f55195306 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2334,7 +2334,6 @@ static int unsafe_request_wait(struct inode *inode)
 
 int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct ceph_file_info *fi = file->private_data;
 	struct inode *inode = file->f_mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 flush_tid;
@@ -2369,14 +2368,9 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (err < 0)
 		ret = err;
 
-	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
-		spin_lock(&file->f_lock);
-		err = errseq_check_and_advance(&ci->i_meta_err,
-					       &fi->meta_err);
-		spin_unlock(&file->f_lock);
-		if (err < 0)
-			ret = err;
-	}
+	err = file_check_and_advance_wb_err(file);
+	if (err < 0)
+		ret = err;
 out:
 	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
 	return ret;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f1895f78ab45..8e6855e7ed83 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -233,7 +233,6 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
-	fi->meta_err = errseq_sample(&ci->i_meta_err);
 	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
 	return 0;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 63e781e4f7e4..76be50f6f041 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -529,8 +529,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ceph_fscache_inode_init(ci);
 
-	ci->i_meta_err = 0;
-
 	return &ci->vfs_inode;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0f57b7d09457..76e347a8cf08 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1481,7 +1481,6 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_request *req;
 	struct rb_node *p;
-	struct ceph_inode_info *ci;
 
 	dout("cleanup_session_requests mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
@@ -1490,16 +1489,10 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 				       struct ceph_mds_request, r_unsafe_item);
 		pr_warn_ratelimited(" dropping unsafe request %llu\n",
 				    req->r_tid);
-		if (req->r_target_inode) {
-			/* dropping unsafe change of inode's attributes */
-			ci = ceph_inode(req->r_target_inode);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
-		if (req->r_unsafe_dir) {
-			/* dropping unsafe directory operation */
-			ci = ceph_inode(req->r_unsafe_dir);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
+		if (req->r_target_inode)
+			mapping_set_error(req->r_target_inode->i_mapping, -EIO);
+		if (req->r_unsafe_dir)
+			mapping_set_error(req->r_unsafe_dir->i_mapping, -EIO);
 		__unregister_request(mdsc, req);
 	}
 	/* zero r_attempts, so kick_requests() will re-send requests */
@@ -1668,7 +1661,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		spin_unlock(&mdsc->cap_dirty_lock);
 
 		if (dirty_dropped) {
-			errseq_set(&ci->i_meta_err, -EIO);
+			mapping_set_error(inode->i_mapping, -EIO);
 
 			if (ci->i_wrbuffer_ref_head == 0 &&
 			    ci->i_wr_ref == 0 &&
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 33ba6f0aa55c..f33bfb255db8 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -997,16 +997,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_fs_client *new = fc->s_fs_info;
 	struct ceph_mount_options *fsopt = new->mount_options;
 	struct ceph_options *opt = new->client->options;
-	struct ceph_fs_client *other = ceph_sb_to_client(sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 
 	dout("ceph_compare_super %p\n", sb);
 
-	if (compare_mount_options(fsopt, opt, other)) {
+	if (compare_mount_options(fsopt, opt, fsc)) {
 		dout("monitor(s)/mount options don't match\n");
 		return 0;
 	}
 	if ((opt->flags & CEPH_OPT_FSID) &&
-	    ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
+	    ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
 		dout("fsid doesn't match\n");
 		return 0;
 	}
@@ -1014,6 +1014,17 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 		dout("flags differ\n");
 		return 0;
 	}
+
+	if (fsc->blocklisted && !ceph_test_mount_opt(fsc, CLEANRECOVER)) {
+		dout("client is blocklisted (and CLEANRECOVER is not set)\n");
+		return 0;
+	}
+
+	if (fsc->mount_state == CEPH_MOUNT_SHUTDOWN) {
+		dout("client has been forcibly unmounted\n");
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9362eeb5812d..4db305fd2a02 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -430,8 +430,6 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 	u32 i_fscache_gen;
 #endif
-	errseq_t i_meta_err;
-
 	struct inode vfs_inode; /* at end */
 };
 
@@ -773,7 +771,6 @@ struct ceph_file_info {
 	spinlock_t rw_contexts_lock;
 	struct list_head rw_contexts;
 
-	errseq_t meta_err;
 	u32 filp_gen;
 	atomic_t num_locks;
 };
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26753d0cb431..0736487165da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5559,7 +5559,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags |
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags ||
 	    sqe->splice_fd_in)
 		return -EINVAL;
 
diff --git a/fs/kernel_read_file.c b/fs/kernel_read_file.c
index 90d255fbdd9b..c84d87f558cb 100644
--- a/fs/kernel_read_file.c
+++ b/fs/kernel_read_file.c
@@ -178,7 +178,7 @@ int kernel_read_file_from_fd(int fd, loff_t offset, void **buf,
 	struct fd f = fdget(fd);
 	int ret = -EBADF;
 
-	if (!f.file)
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
 
 	ret = kernel_read_file(f.file, offset, buf, buf_size, file_size, id);
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index ddf2b375632b..21c4ffda5f94 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -792,7 +792,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 		svc_xprt_put(xprt);
 	}
 out_err:
-	nfsd_destroy(net);
+	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
+		nn->nfsd_serv->sv_nrthreads--;
+	 else
+		nfsd_destroy(net);
 	return err;
 }
 
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 78710788c237..a9a6276ff29b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7047,7 +7047,7 @@ void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh)
 {
-	int ret, i, has_data, num_pages = 0;
+	int ret, has_data, num_pages = 0;
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
@@ -7056,26 +7056,17 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_alloc_context *data_ac = NULL;
-	struct page **pages = NULL;
-	loff_t end = osb->s_clustersize;
+	struct page *page = NULL;
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
 	has_data = i_size_read(inode) ? 1 : 0;
 
 	if (has_data) {
-		pages = kcalloc(ocfs2_pages_per_cluster(osb->sb),
-				sizeof(struct page *), GFP_NOFS);
-		if (pages == NULL) {
-			ret = -ENOMEM;
-			mlog_errno(ret);
-			return ret;
-		}
-
 		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
 		if (ret) {
 			mlog_errno(ret);
-			goto free_pages;
+			goto out;
 		}
 	}
 
@@ -7095,7 +7086,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 	if (has_data) {
-		unsigned int page_end;
+		unsigned int page_end = min_t(unsigned, PAGE_SIZE,
+							osb->s_clustersize);
 		u64 phys;
 
 		ret = dquot_alloc_space_nodirty(inode,
@@ -7119,15 +7111,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 */
 		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-		/*
-		 * Non sparse file systems zero on extend, so no need
-		 * to do that now.
-		 */
-		if (!ocfs2_sparse_alloc(osb) &&
-		    PAGE_SIZE < osb->s_clustersize)
-			end = PAGE_SIZE;
-
-		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
+		ret = ocfs2_grab_eof_pages(inode, 0, page_end, &page,
+					   &num_pages);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
@@ -7138,20 +7123,15 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 * This should populate the 1st page for us and mark
 		 * it up to date.
 		 */
-		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
+		ret = ocfs2_read_inline_data(inode, page, di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
 			goto out_unlock;
 		}
 
-		page_end = PAGE_SIZE;
-		if (PAGE_SIZE > osb->s_clustersize)
-			page_end = osb->s_clustersize;
-
-		for (i = 0; i < num_pages; i++)
-			ocfs2_map_and_dirty_page(inode, handle, 0, page_end,
-						 pages[i], i > 0, &phys);
+		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, page, 0,
+					 &phys);
 	}
 
 	spin_lock(&oi->ip_lock);
@@ -7182,8 +7162,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	}
 
 out_unlock:
-	if (pages)
-		ocfs2_unlock_and_free_pages(pages, num_pages);
+	if (page)
+		ocfs2_unlock_and_free_pages(&page, num_pages);
 
 out_commit:
 	if (ret < 0 && did_quota)
@@ -7207,8 +7187,6 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-free_pages:
-	kfree(pages);
 	return ret;
 }
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2febc76e9de7..435f82892432 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2171,11 +2171,17 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
+		/*
+		 * ci_stack and ci_cluster in ocfs2_cluster_info may not be null
+		 * terminated, so make sure no overflow happens here by using
+		 * memcpy. Destination strings will always be null terminated
+		 * because osb is allocated using kzalloc.
+		 */
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		strlcpy(osb->osb_cluster_stack,
+		memcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN + 1);
+		       OCFS2_STACK_LABEL_LEN);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2184,9 +2190,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
-		strlcpy(osb->osb_cluster_name,
+		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
-			OCFS2_CLUSTER_NAME_LEN + 1);
+			OCFS2_CLUSTER_NAME_LEN);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 17397c7532f1..aef0da5d6f63 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1794,9 +1794,15 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
-	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, mode_wp,
-				  &ctx->mmap_changing);
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+					  uffdio_wp.range.len, mode_wp,
+					  &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
 	if (ret)
 		return ret;
 
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index de51c1bef27d..40e93bfa559d 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -104,7 +104,7 @@ static inline int elf_core_copy_task_fpregs(struct task_struct *t, struct pt_reg
 #endif
 }
 
-#if defined(CONFIG_UM) || defined(CONFIG_IA64)
+#if (defined(CONFIG_UML) && defined(CONFIG_X86_32)) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 73827b7d17e0..cf530e9fb5f5 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -225,6 +225,7 @@ struct hda_codec {
 #endif
 
 	/* misc flags */
+	unsigned int configured:1; /* codec was configured */
 	unsigned int in_freeing:1; /* being released */
 	unsigned int registered:1; /* codec was registered */
 	unsigned int display_power_control:1; /* needs display power */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8dba8f0983b5..638f424859ed 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -653,7 +653,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
 			break;
 		case AUDIT_SADDR_FAM:
-			if (ctx->sockaddr)
+			if (ctx && ctx->sockaddr)
 				result = audit_comparator(ctx->sockaddr->ss_family,
 							  f->op, f->val);
 			break;
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 445754529917..10d07ace46c1 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1300,6 +1300,12 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	if (unlikely(dma_debug_disabled()))
 		return;
 
+	for_each_sg(sg, s, nents, i) {
+		check_for_stack(dev, sg_page(s), s->offset);
+		if (!PageHighMem(sg_page(s)))
+			check_for_illegal_area(dev, sg_virt(s), s->length);
+	}
+
 	for_each_sg(sg, s, mapped_ents, i) {
 		entry = dma_entry_alloc();
 		if (!entry)
@@ -1315,12 +1321,6 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
-		check_for_stack(dev, sg_page(s), s->offset);
-
-		if (!PageHighMem(sg_page(s))) {
-			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
-		}
-
 		check_sg_segment(dev, s);
 
 		add_dma_entry(entry);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6db20a66e8e6..e4551d1736fa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6677,6 +6677,7 @@ void idle_task_exit(void)
 		finish_arch_post_lock_switch();
 	}
 
+	scs_task_reset(current);
 	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
 }
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 30010614b923..4a5d35dc490b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6985,7 +6985,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	struct ftrace_ops *op;
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
@@ -7060,7 +7060,7 @@ static void ftrace_ops_assist_func(unsigned long ip, unsigned long parent_ip,
 {
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6784b572ce59..15a811d34cd8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -573,18 +573,6 @@ struct tracer {
  *    then this function calls...
  *   The function callback, which can use the FTRACE bits to
  *    check for recursion.
- *
- * Now if the arch does not support a feature, and it calls
- * the global list function which calls the ftrace callback
- * all three of these steps will do a recursion protection.
- * There's no reason to do one if the previous caller already
- * did. The recursion that we are protecting against will
- * go through the same steps again.
- *
- * To prevent the multiple recursion checks, if a recursion
- * bit is set that is higher than the MAX bit of the current
- * check, then we know that the check was made by the previous
- * caller, and we can skip the current check.
  */
 enum {
 	/* Function recursion bits */
@@ -592,12 +580,14 @@ enum {
 	TRACE_FTRACE_NMI_BIT,
 	TRACE_FTRACE_IRQ_BIT,
 	TRACE_FTRACE_SIRQ_BIT,
+	TRACE_FTRACE_TRANSITION_BIT,
 
-	/* INTERNAL_BITs must be greater than FTRACE_BITs */
+	/* Internal use recursion bits */
 	TRACE_INTERNAL_BIT,
 	TRACE_INTERNAL_NMI_BIT,
 	TRACE_INTERNAL_IRQ_BIT,
 	TRACE_INTERNAL_SIRQ_BIT,
+	TRACE_INTERNAL_TRANSITION_BIT,
 
 	TRACE_BRANCH_BIT,
 /*
@@ -637,12 +627,6 @@ enum {
 	 * function is called to clear it.
 	 */
 	TRACE_GRAPH_NOTRACE_BIT,
-
-	/*
-	 * When transitioning between context, the preempt_count() may
-	 * not be correct. Allow for a single recursion to cover this case.
-	 */
-	TRACE_TRANSITION_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
@@ -662,12 +646,18 @@ enum {
 #define TRACE_CONTEXT_BITS	4
 
 #define TRACE_FTRACE_START	TRACE_FTRACE_BIT
-#define TRACE_FTRACE_MAX	((1 << (TRACE_FTRACE_START + TRACE_CONTEXT_BITS)) - 1)
 
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
-#define TRACE_LIST_MAX		((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
-#define TRACE_CONTEXT_MASK	TRACE_LIST_MAX
+#define TRACE_CONTEXT_MASK	((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
+
+enum {
+	TRACE_CTX_NMI,
+	TRACE_CTX_IRQ,
+	TRACE_CTX_SOFTIRQ,
+	TRACE_CTX_NORMAL,
+	TRACE_CTX_TRANSITION,
+};
 
 static __always_inline int trace_get_context_bit(void)
 {
@@ -675,59 +665,48 @@ static __always_inline int trace_get_context_bit(void)
 
 	if (in_interrupt()) {
 		if (in_nmi())
-			bit = 0;
+			bit = TRACE_CTX_NMI;
 
 		else if (in_irq())
-			bit = 1;
+			bit = TRACE_CTX_IRQ;
 		else
-			bit = 2;
+			bit = TRACE_CTX_SOFTIRQ;
 	} else
-		bit = 3;
+		bit = TRACE_CTX_NORMAL;
 
 	return bit;
 }
 
-static __always_inline int trace_test_and_set_recursion(int start, int max)
+static __always_inline int trace_test_and_set_recursion(int start)
 {
 	unsigned int val = current->trace_recursion;
 	int bit;
 
-	/* A previous recursion check was made */
-	if ((val & TRACE_CONTEXT_MASK) > max)
-		return 0;
-
 	bit = trace_get_context_bit() + start;
 	if (unlikely(val & (1 << bit))) {
 		/*
 		 * It could be that preempt_count has not been updated during
 		 * a switch between contexts. Allow for a single recursion.
 		 */
-		bit = TRACE_TRANSITION_BIT;
+		bit = start + TRACE_CTX_TRANSITION;
 		if (trace_recursion_test(bit))
 			return -1;
 		trace_recursion_set(bit);
 		barrier();
-		return bit + 1;
+		return bit;
 	}
 
-	/* Normal check passed, clear the transition to allow it again */
-	trace_recursion_clear(TRACE_TRANSITION_BIT);
-
 	val |= 1 << bit;
 	current->trace_recursion = val;
 	barrier();
 
-	return bit + 1;
+	return bit;
 }
 
 static __always_inline void trace_clear_recursion(int bit)
 {
 	unsigned int val = current->trace_recursion;
 
-	if (!bit)
-		return;
-
-	bit--;
 	bit = 1 << bit;
 	val &= ~bit;
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 2c2126e1871d..93e20ed642e5 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -144,7 +144,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 	pc = preempt_count();
 	preempt_disable_notrace();
 
-	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	bit = trace_test_and_set_recursion(TRACE_FTRACE_START);
 	if (bit < 0)
 		goto out;
 
diff --git a/mm/slub.c b/mm/slub.c
index f5fc44208bdc..1384dc906833 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1543,7 +1543,8 @@ static __always_inline bool slab_free_hook(struct kmem_cache *s, void *x)
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail)
+					   void **head, void **tail,
+					   int *cnt)
 {
 
 	void *object;
@@ -1578,6 +1579,12 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 			*head = object;
 			if (!*tail)
 				*tail = object;
+		} else {
+			/*
+			 * Adjust the reconstructed freelist depth
+			 * accordingly if object's reuse is delayed.
+			 */
+			--(*cnt);
 		}
 	} while (object != old_tail);
 
@@ -3093,7 +3100,9 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, &head, 1);
+	/* memcg_slab_free_hook() is already called for bulk free. */
+	if (!tail)
+		memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -3137,7 +3146,7 @@ static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (slab_free_freelist_hook(s, &head, &tail))
+	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
 		do_slab_free(s, page, head, tail, cnt, addr);
 }
 
@@ -3825,8 +3834,8 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
 error:
+	__kmem_cache_release(s);
 	return -EINVAL;
 }
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 72d424a5a142..eb684f31fd69 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -481,6 +481,12 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	__skb->gso_segs = skb_shinfo(skb)->gso_segs;
 }
 
+static struct proto bpf_dummy_proto = {
+	.name   = "bpf_dummy",
+	.owner  = THIS_MODULE,
+	.obj_size = sizeof(struct sock),
+};
+
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
@@ -525,20 +531,19 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		break;
 	}
 
-	sk = kzalloc(sizeof(struct sock), GFP_USER);
+	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
 		kfree(data);
 		kfree(ctx);
 		return -ENOMEM;
 	}
-	sock_net_set(sk, net);
 	sock_init_data(NULL, sk);
 
 	skb = build_skb(data, 0);
 	if (!skb) {
 		kfree(data);
 		kfree(ctx);
-		kfree(sk);
+		sk_free(sk);
 		return -ENOMEM;
 	}
 	skb->sk = sk;
@@ -611,8 +616,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (dev && dev != net->loopback_dev)
 		dev_put(dev);
 	kfree_skb(skb);
-	bpf_sk_storage_free(sk);
-	kfree(sk);
+	sk_free(sk);
 	kfree(ctx);
 	return ret;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5e5726048a1a..2b88b17cc8b2 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -931,9 +931,7 @@ static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
 
 static inline unsigned long br_multicast_gmi(const struct net_bridge *br)
 {
-	/* use the RFC default of 2 for QRV */
-	return 2 * br->multicast_query_interval +
-	       br->multicast_query_response_interval;
+	return br->multicast_membership_interval;
 }
 #else
 static inline int br_multicast_rcv(struct net_bridge *br,
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 5fc28f190677..8ee580538d87 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -121,7 +121,7 @@ enum {
 struct tpcon {
 	int idx;
 	int len;
-	u8 state;
+	u32 state;
 	u8 bs;
 	u8 sn;
 	u8 ll_dl;
@@ -846,6 +846,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
+	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
@@ -858,37 +859,45 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		return -EADDRNOTAVAIL;
 
 	/* we do not support multiple buffers - for now */
-	if (so->tx.state != ISOTP_IDLE || wq_has_sleeper(&so->wait)) {
-		if (msg->msg_flags & MSG_DONTWAIT)
-			return -EAGAIN;
+	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
+	    wq_has_sleeper(&so->wait)) {
+		if (msg->msg_flags & MSG_DONTWAIT) {
+			err = -EAGAIN;
+			goto err_out;
+		}
 
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			goto err_out;
 	}
 
-	if (!size || size > MAX_MSG_LENGTH)
-		return -EINVAL;
+	if (!size || size > MAX_MSG_LENGTH) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		return err;
+		goto err_out;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
-	if (!dev)
-		return -ENXIO;
+	if (!dev) {
+		err = -ENXIO;
+		goto err_out;
+	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		return err;
+		goto err_out;
 	}
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
 
-	so->tx.state = ISOTP_SENDING;
 	so->tx.len = size;
 	so->tx.idx = 0;
 
@@ -947,15 +956,25 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
 			       __func__, err);
-		return err;
+		goto err_out;
 	}
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+
+		if (sk->sk_err)
+			return -sk->sk_err;
 	}
 
 	return size;
+
+err_out:
+	so->tx.state = old_state;
+	if (so->tx.state == ISOTP_IDLE)
+		wake_up_interruptible(&so->wait);
+
+	return err;
 }
 
 static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index 12369b604ce9..cea712fb2a9e 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -326,6 +326,7 @@ int j1939_session_activate(struct j1939_session *session);
 void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec);
 void j1939_session_timers_cancel(struct j1939_session *session);
 
+#define J1939_MIN_TP_PACKET_SIZE 9
 #define J1939_MAX_TP_PACKET_SIZE (7 * 0xff)
 #define J1939_MAX_ETP_PACKET_SIZE (7 * 0x00ffffff)
 
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 6884d18f919c..266c189f1e80 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -249,11 +249,14 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 	struct j1939_priv *priv, *priv_new;
 	int ret;
 
-	priv = j1939_priv_get_by_ndev(ndev);
+	spin_lock(&j1939_netdev_lock);
+	priv = j1939_priv_get_by_ndev_locked(ndev);
 	if (priv) {
 		kref_get(&priv->rx_kref);
+		spin_unlock(&j1939_netdev_lock);
 		return priv;
 	}
+	spin_unlock(&j1939_netdev_lock);
 
 	priv = j1939_priv_create(ndev);
 	if (!priv)
@@ -269,10 +272,10 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 		/* Someone was faster than us, use their priv and roll
 		 * back our's.
 		 */
+		kref_get(&priv_new->rx_kref);
 		spin_unlock(&j1939_netdev_lock);
 		dev_put(ndev);
 		kfree(priv);
-		kref_get(&priv_new->rx_kref);
 		return priv_new;
 	}
 	j1939_priv_set(ndev, priv);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bdc95bd7a851..e59fbbffa31c 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1230,12 +1230,11 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
 		session->err = -ETIME;
 		j1939_session_deactivate(session);
 	} else {
-		netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
-			     __func__, session);
-
 		j1939_session_list_lock(session->priv);
 		if (session->state >= J1939_SESSION_ACTIVE &&
 		    session->state < J1939_SESSION_ACTIVE_MAX) {
+			netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
+				     __func__, session);
 			j1939_session_get(session);
 			hrtimer_start(&session->rxtimer,
 				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),
@@ -1597,6 +1596,8 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 			abort = J1939_XTP_ABORT_FAULT;
 		else if (len > priv->tp_max_packet_size)
 			abort = J1939_XTP_ABORT_RESOURCE;
+		else if (len < J1939_MIN_TP_PACKET_SIZE)
+			abort = J1939_XTP_ABORT_FAULT;
 	}
 
 	if (abort != J1939_XTP_NO_ABORT) {
@@ -1771,6 +1772,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
 static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 				 struct sk_buff *skb)
 {
+	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *skcb;
 	struct sk_buff *se_skb = NULL;
@@ -1785,9 +1787,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 
 	skcb = j1939_skb_to_cb(skb);
 	dat = skb->data;
-	if (skb->len <= 1)
+	if (skb->len != 8) {
 		/* makes no sense */
+		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
 		goto out_session_cancel;
+	}
 
 	switch (session->last_cmd) {
 	case 0xff:
@@ -1885,7 +1889,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
  out_session_cancel:
 	kfree_skb(se_skb);
 	j1939_session_timers_cancel(session);
-	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
+	j1939_session_cancel(session, abort);
 	j1939_session_put(session);
 }
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 71395e745bc5..017cd666387f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1022,6 +1022,20 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
 DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
 EXPORT_SYMBOL(tcp_md5_needed);
 
+static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
+{
+	if (!old)
+		return true;
+
+	/* l3index always overrides non-l3index */
+	if (old->l3index && new->l3index == 0)
+		return false;
+	if (old->l3index == 0 && new->l3index)
+		return true;
+
+	return old->prefixlen < new->prefixlen;
+}
+
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
@@ -1059,8 +1073,7 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 			match = false;
 		}
 
-		if (match && (!best_match ||
-			      key->prefixlen > best_match->prefixlen))
+		if (match && better_md5_match(best_match, key))
 			best_match = key;
 	}
 	return best_match;
@@ -1090,7 +1103,7 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->l3index && key->l3index != l3index)
+		if (key->l3index != l3index)
 			continue;
 		if (!memcmp(&key->addr, addr, size) &&
 		    key->prefixlen == prefixlen)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 72a673a43a75..c2f8e69d7d7a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -487,13 +487,14 @@ static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
 
 int ip6_forward(struct sk_buff *skb)
 {
-	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
 	struct dst_entry *dst = skb_dst(skb);
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(dst->dev);
+	struct inet6_dev *idev;
 	u32 mtu;
 
+	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
 	if (net->ipv6.devconf_all->forwarding == 0)
 		goto error;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 733c83d38b30..4ad8b2032f1f 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -25,12 +25,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	bool r;
-	pr_debug("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, id, max);
-	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (id >= min && id <= max) ^ invert;
 }
 
 static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -65,30 +60,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	pr_debug("TYPE %04X ", rh->type);
-	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-	pr_debug("IPv6 RT segsleft %02X ",
-		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-				rh->segments_left,
-				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	pr_debug("type %02X %02X %02X ",
-		 rtinfo->rt_type, rh->type,
-		 (!(rtinfo->flags & IP6T_RT_TYP) ||
-		  ((rtinfo->rt_type == rh->type) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	pr_debug("len %02X %04X %02X ",
-		 rtinfo->hdrlen, hdrlen,
-		 !(rtinfo->flags & IP6T_RT_LEN) ||
-		  ((rtinfo->hdrlen == hdrlen) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
-		 rtinfo->flags & IP6T_RT_RES,
-		 ((const struct rt0_hdr *)rh)->reserved,
-		 !((rtinfo->flags & IP6T_RT_RES) &&
-		   (((const struct rt0_hdr *)rh)->reserved)));
-
 	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
@@ -107,22 +78,22 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 						       reserved),
 					sizeof(_reserved),
 					&_reserved);
+		if (!rp) {
+			par->hotdrop = true;
+			return false;
+		}
 
 		ret = (*rp == 0);
 	}
 
-	pr_debug("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		pr_debug("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -138,26 +109,20 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 					return false;
 				}
 
-				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					pr_debug("i=%d temp=%d;\n", i, temp);
+				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		pr_debug("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -173,7 +138,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 52370211e46b..6bafd3876aff 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -94,7 +94,7 @@ config NF_CONNTRACK_MARK
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
 	depends on NETWORK_SECMARK
-	default m if NETFILTER_ADVANCED=n
+	default y if NETFILTER_ADVANCED=n
 	help
 	  This option enables security markings to be applied to
 	  connections.  Typically they are copied to connections from
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c25097092a06..29ec3ef63edc 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4090,6 +4090,11 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
+#ifdef CONFIG_IP_VS_DEBUG
+	/* Global sysctls must be ro in non-init netns */
+	if (!net_eq(net, &init_net))
+		tbl[idx++].mode = 0444;
+#endif
 
 	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
 	if (ipvs->sysctl_hdr == NULL) {
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 7b2f359bfce4..2f7cf5ecebf4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -137,7 +137,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 {
 	int ret;
 
-	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	info->timer = kzalloc(sizeof(*info->timer), GFP_KERNEL);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a48297b79f34..b0ed2b47ac43 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -277,6 +277,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
 							 ndev->cur_conn_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			if (conn_info == ndev->rf_conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 952e46876329..4aad28480035 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -19,6 +19,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF)		\
 		+= -fplugin-arg-structleak_plugin-byref
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	\
 		+= -fplugin-arg-structleak_plugin-byref-all
+ifdef CONFIG_GCC_PLUGIN_STRUCTLEAK
+    DISABLE_STRUCTLEAK_PLUGIN += -fplugin-arg-structleak_plugin-disable
+endif
+export DISABLE_STRUCTLEAK_PLUGIN
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)		\
 		+= -DSTRUCTLEAK_PLUGIN
 
diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index b98449fd92f3..522d1897659c 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -421,8 +421,9 @@ int snd_hdac_bus_reset_link(struct hdac_bus *bus, bool full_reset)
 	if (!full_reset)
 		goto skip_reset;
 
-	/* clear STATESTS */
-	snd_hdac_chip_writew(bus, STATESTS, STATESTS_INT_MASK);
+	/* clear STATESTS if not in reset */
+	if (snd_hdac_chip_readb(bus, GCTL) & AZX_GCTL_RESET)
+		snd_hdac_chip_writew(bus, STATESTS, STATESTS_INT_MASK);
 
 	/* reset controller */
 	snd_hdac_bus_enter_link_reset(bus);
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 17a25e453f60..4efbcc41fdfb 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -301,29 +301,31 @@ int snd_hda_codec_configure(struct hda_codec *codec)
 {
 	int err;
 
+	if (codec->configured)
+		return 0;
+
 	if (is_generic_config(codec))
 		codec->probe_id = HDA_CODEC_ID_GENERIC;
 	else
 		codec->probe_id = 0;
 
-	err = snd_hdac_device_register(&codec->core);
-	if (err < 0)
-		return err;
+	if (!device_is_registered(&codec->core.dev)) {
+		err = snd_hdac_device_register(&codec->core);
+		if (err < 0)
+			return err;
+	}
 
 	if (!codec->preset)
 		codec_bind_module(codec);
 	if (!codec->preset) {
 		err = codec_bind_generic(codec);
 		if (err < 0) {
-			codec_err(codec, "Unable to bind the codec\n");
-			goto error;
+			codec_dbg(codec, "Unable to bind the codec\n");
+			return err;
 		}
 	}
 
+	codec->configured = 1;
 	return 0;
-
- error:
-	snd_hdac_device_unregister(&codec->core);
-	return err;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_configure);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 4cec1bd77e6f..6dece719be66 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -791,6 +791,7 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	snd_array_free(&codec->nids);
 	remove_conn_list(codec);
 	snd_hdac_regmap_exit(&codec->core);
+	codec->configured = 0;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_cleanup_for_unbind);
 
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index b972d59eb1ec..3de7dc34def2 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -25,6 +25,7 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include "hda_controller.h"
+#include "hda_local.h"
 
 #define CREATE_TRACE_POINTS
 #include "hda_controller_trace.h"
@@ -1259,17 +1260,24 @@ EXPORT_SYMBOL_GPL(azx_probe_codecs);
 int azx_codec_configure(struct azx *chip)
 {
 	struct hda_codec *codec, *next;
+	int success = 0;
 
-	/* use _safe version here since snd_hda_codec_configure() deregisters
-	 * the device upon error and deletes itself from the bus list.
-	 */
-	list_for_each_codec_safe(codec, next, &chip->bus) {
-		snd_hda_codec_configure(codec);
+	list_for_each_codec(codec, &chip->bus) {
+		if (!snd_hda_codec_configure(codec))
+			success++;
 	}
 
-	if (!azx_bus(chip)->num_codecs)
-		return -ENODEV;
-	return 0;
+	if (success) {
+		/* unregister failed codecs if any codec has been probed */
+		list_for_each_codec_safe(codec, next, &chip->bus) {
+			if (!codec->configured) {
+				codec_err(codec, "Unable to configure, disabling\n");
+				snd_hdac_device_unregister(&codec->core);
+			}
+		}
+	}
+
+	return success ? 0 : -ENODEV;
 }
 EXPORT_SYMBOL_GPL(azx_codec_configure);
 
diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index 68f9668788ea..324cba13c7ba 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -41,7 +41,7 @@
 /* 24 unused */
 #define AZX_DCAPS_COUNT_LPIB_DELAY  (1 << 25)	/* Take LPIB as delay */
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
-/* 27 unused */
+#define AZX_DCAPS_RETRY_PROBE	(1 << 27)	/* retry probe if no codec is configured */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
 #define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 #define AZX_DCAPS_SEPARATE_STREAM_TAG	(1 << 30) /* capture and playback use separate stream tag */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 4c8b281c3992..8bc27e7c0590 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -341,7 +341,8 @@ enum {
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
 	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_AMD_WORKAROUND |\
-	 AZX_DCAPS_SNOOP_TYPE(ATI) | AZX_DCAPS_PM_RUNTIME)
+	 AZX_DCAPS_SNOOP_TYPE(ATI) | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_RETRY_PROBE)
 
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
@@ -1758,7 +1759,7 @@ static void azx_check_snoop_available(struct azx *chip)
 
 static void azx_probe_work(struct work_struct *work)
 {
-	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work);
+	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
 	azx_probe_continue(&hda->chip);
 }
 
@@ -1867,7 +1868,7 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	}
 
 	/* continue probing in work context as may trigger request module */
-	INIT_WORK(&hda->probe_work, azx_probe_work);
+	INIT_DELAYED_WORK(&hda->probe_work, azx_probe_work);
 
 	*rchip = chip;
 
@@ -2202,7 +2203,7 @@ static int azx_probe(struct pci_dev *pci,
 #endif
 
 	if (schedule_probe)
-		schedule_work(&hda->probe_work);
+		schedule_delayed_work(&hda->probe_work, 0);
 
 	dev++;
 	if (chip->disabled)
@@ -2290,6 +2291,11 @@ static int azx_probe_continue(struct azx *chip)
 	int dev = chip->dev_index;
 	int err;
 
+	if (chip->disabled || hda->init_failed)
+		return -EIO;
+	if (hda->probe_retry)
+		goto probe_retry;
+
 	to_hda_bus(bus)->bus_probing = 1;
 	hda->probe_continued = 1;
 
@@ -2351,10 +2357,20 @@ static int azx_probe_continue(struct azx *chip)
 #endif
 	}
 #endif
+
+ probe_retry:
 	if (bus->codec_mask && !(probe_only[dev] & 1)) {
 		err = azx_codec_configure(chip);
-		if (err < 0)
+		if (err) {
+			if ((chip->driver_caps & AZX_DCAPS_RETRY_PROBE) &&
+			    ++hda->probe_retry < 60) {
+				schedule_delayed_work(&hda->probe_work,
+						      msecs_to_jiffies(1000));
+				return 0; /* keep things up */
+			}
+			dev_err(chip->card->dev, "Cannot probe codecs, giving up\n");
 			goto out_free;
+		}
 	}
 
 	err = snd_card_register(chip->card);
@@ -2384,6 +2400,7 @@ static int azx_probe_continue(struct azx *chip)
 		display_power(chip, false);
 	complete_all(&hda->probe_wait);
 	to_hda_bus(bus)->bus_probing = 0;
+	hda->probe_retry = 0;
 	return 0;
 }
 
@@ -2409,7 +2426,7 @@ static void azx_remove(struct pci_dev *pci)
 		 * device during cancel_work_sync() call.
 		 */
 		device_unlock(&pci->dev);
-		cancel_work_sync(&hda->probe_work);
+		cancel_delayed_work_sync(&hda->probe_work);
 		device_lock(&pci->dev);
 
 		snd_card_free(card);
diff --git a/sound/pci/hda/hda_intel.h b/sound/pci/hda/hda_intel.h
index 3fb119f09040..0f39418f9328 100644
--- a/sound/pci/hda/hda_intel.h
+++ b/sound/pci/hda/hda_intel.h
@@ -14,7 +14,7 @@ struct hda_intel {
 
 	/* sync probing */
 	struct completion probe_wait;
-	struct work_struct probe_work;
+	struct delayed_work probe_work;
 
 	/* card list (for power_save trigger) */
 	struct list_head list;
@@ -30,6 +30,8 @@ struct hda_intel {
 	unsigned int freed:1; /* resources already released */
 
 	bool need_i915_power:1; /* the hda controller needs i915 power */
+
+	int probe_retry;	/* being probe-retry */
 };
 
 #endif
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c36239cea474..f511ae66bc8a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2547,6 +2547,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 9d325555e219..618692e2e0e4 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -742,9 +742,16 @@ static int wm8960_configure_clocking(struct snd_soc_component *component)
 	int i, j, k;
 	int ret;
 
-	if (!(iface1 & (1<<6))) {
-		dev_dbg(component->dev,
-			"Codec is slave mode, no need to configure clock\n");
+	/*
+	 * For Slave mode clocking should still be configured,
+	 * so this if statement should be removed, but some platform
+	 * may not work if the sysclk is not configured, to avoid such
+	 * compatible issue, just add '!wm8960->sysclk' condition in
+	 * this if statement.
+	 */
+	if (!(iface1 & (1 << 6)) && !wm8960->sysclk) {
+		dev_warn(component->dev,
+			 "slave mode, but proceeding with no clock configuration\n");
 		return 0;
 	}
 
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f4b380d6aecf..08960167d34f 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2559,6 +2559,7 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
 				const char *pin, int status)
 {
 	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
+	int ret = 0;
 
 	dapm_assert_locked(dapm);
 
@@ -2571,13 +2572,14 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
 		dapm_mark_dirty(w, "pin configuration");
 		dapm_widget_invalidate_input_paths(w);
 		dapm_widget_invalidate_output_paths(w);
+		ret = 1;
 	}
 
 	w->connected = status;
 	if (status == 0)
 		w->force = 0;
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -3582,14 +3584,15 @@ int snd_soc_dapm_put_pin_switch(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
 	const char *pin = (const char *)kcontrol->private_value;
+	int ret;
 
 	if (ucontrol->value.integer.value[0])
-		snd_soc_dapm_enable_pin(&card->dapm, pin);
+		ret = snd_soc_dapm_enable_pin(&card->dapm, pin);
 	else
-		snd_soc_dapm_disable_pin(&card->dapm, pin);
+		ret = snd_soc_dapm_disable_pin(&card->dapm, pin);
 
 	snd_soc_dapm_sync(&card->dapm);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_put_pin_switch);
 
@@ -4035,7 +4038,7 @@ static int snd_soc_dapm_dai_link_put(struct snd_kcontrol *kcontrol,
 
 	rtd->params_select = ucontrol->value.enumerated.item[0];
 
-	return 0;
+	return 1;
 }
 
 static void
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 7c649cd38049..949c6d129f2a 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3698,6 +3698,38 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * Sennheiser GSP670
+	 * Change order of interfaces loaded
+	 */
+	USB_DEVICE(0x1395, 0x0300),
+	.bInterfaceClass = USB_CLASS_PER_INTERFACE,
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			// Communication
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			// Recording
+			{
+				.ifnum = 4,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			// Main
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
diff --git a/tools/lib/perf/tests/test-evlist.c b/tools/lib/perf/tests/test-evlist.c
index bd19cabddaf6..60b5d1801103 100644
--- a/tools/lib/perf/tests/test-evlist.c
+++ b/tools/lib/perf/tests/test-evlist.c
@@ -38,7 +38,7 @@ static int test_stat_cpu(void)
 		.type	= PERF_TYPE_SOFTWARE,
 		.config	= PERF_COUNT_SW_TASK_CLOCK,
 	};
-	int err, cpu, tmp;
+	int err, idx;
 
 	cpus = perf_cpu_map__new(NULL);
 	__T("failed to create cpus", cpus);
@@ -64,10 +64,10 @@ static int test_stat_cpu(void)
 	perf_evlist__for_each_evsel(evlist, evsel) {
 		cpus = perf_evsel__cpus(evsel);
 
-		perf_cpu_map__for_each_cpu(cpu, tmp, cpus) {
+		for (idx = 0; idx < perf_cpu_map__nr(cpus); idx++) {
 			struct perf_counts_values counts = { .val = 0 };
 
-			perf_evsel__read(evsel, cpu, 0, &counts);
+			perf_evsel__read(evsel, idx, 0, &counts);
 			__T("failed to read value for evsel", counts.val != 0);
 		}
 	}
diff --git a/tools/lib/perf/tests/test-evsel.c b/tools/lib/perf/tests/test-evsel.c
index 0ad82d7a2a51..2de98768d844 100644
--- a/tools/lib/perf/tests/test-evsel.c
+++ b/tools/lib/perf/tests/test-evsel.c
@@ -21,7 +21,7 @@ static int test_stat_cpu(void)
 		.type	= PERF_TYPE_SOFTWARE,
 		.config	= PERF_COUNT_SW_CPU_CLOCK,
 	};
-	int err, cpu, tmp;
+	int err, idx;
 
 	cpus = perf_cpu_map__new(NULL);
 	__T("failed to create cpus", cpus);
@@ -32,10 +32,10 @@ static int test_stat_cpu(void)
 	err = perf_evsel__open(evsel, cpus, NULL);
 	__T("failed to open evsel", err == 0);
 
-	perf_cpu_map__for_each_cpu(cpu, tmp, cpus) {
+	for (idx = 0; idx < perf_cpu_map__nr(cpus); idx++) {
 		struct perf_counts_values counts = { .val = 0 };
 
-		perf_evsel__read(evsel, cpu, 0, &counts);
+		perf_evsel__read(evsel, idx, 0, &counts);
 		__T("failed to read value for evsel", counts.val != 0);
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 8b641c306f26..5b52985cb60e 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -857,7 +857,7 @@ void test_core_reloc(void)
 			goto cleanup;
 		}
 
-		if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
+		if (!ASSERT_EQ(test_case->fails, false, "obj_load_should_fail"))
 			goto cleanup;
 
 		equal = memcmp(data->out, test_case->output,
diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 250fbb2d1625..881e680c2e9c 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -9,6 +9,7 @@ TEST_PROGS = bridge_igmp.sh \
 	gre_inner_v4_multipath.sh \
 	gre_inner_v6_multipath.sh \
 	gre_multipath.sh \
+	ip6_forward_instats_vrf.sh \
 	ip6gre_inner_v4_multipath.sh \
 	ip6gre_inner_v6_multipath.sh \
 	ipip_flat_gre_key.sh \
diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index b802c14d2950..e5e2fbeca22e 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -39,3 +39,5 @@ NETIF_CREATE=yes
 # Timeout (in seconds) before ping exits regardless of how many packets have
 # been sent or received
 PING_TIMEOUT=5
+# IPv6 traceroute utility name.
+TROUTE6=traceroute6
diff --git a/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
new file mode 100755
index 000000000000..9f5b3e2e5e95
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
@@ -0,0 +1,172 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test ipv6 stats on the incoming if when forwarding with VRF
+
+ALL_TESTS="
+	ipv6_ping
+	ipv6_in_too_big_err
+	ipv6_in_hdr_err
+	ipv6_in_addr_err
+	ipv6_in_discard
+"
+
+NUM_NETIFS=4
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:1:1::2/64
+	ip -6 route add vrf v$h1 2001:1:2::/64 via 2001:1:1::1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 2001:1:2::/64 via 2001:1:1::1
+	simple_if_fini $h1 2001:1:1::2/64
+}
+
+router_create()
+{
+	vrf_create router
+	__simple_if_init $rtr1 router 2001:1:1::1/64
+	__simple_if_init $rtr2 router 2001:1:2::1/64
+	mtu_set $rtr2 1280
+}
+
+router_destroy()
+{
+	mtu_restore $rtr2
+	__simple_if_fini $rtr2 2001:1:2::1/64
+	__simple_if_fini $rtr1 2001:1:1::1/64
+	vrf_destroy router
+}
+
+h2_create()
+{
+	simple_if_init $h2 2001:1:2::2/64
+	ip -6 route add vrf v$h2 2001:1:1::/64 via 2001:1:2::1
+	mtu_set $h2 1280
+}
+
+h2_destroy()
+{
+	mtu_restore $h2
+	ip -6 route del vrf v$h2 2001:1:1::/64 via 2001:1:2::1
+	simple_if_fini $h2 2001:1:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rtr1=${NETIFS[p2]}
+
+	rtr2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+	h1_create
+	router_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	router_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+ipv6_in_too_big_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InTooBigErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Send too big packets
+	ip vrf exec $vrf_name \
+		$PING6 -s 1300 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InTooBigErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InTooBigErrors"
+}
+
+ipv6_in_hdr_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InHdrErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Send packets with hop limit 1, easiest with traceroute6 as some ping6
+	# doesn't allow hop limit to be specified
+	ip vrf exec $vrf_name \
+		$TROUTE6 2001:1:2::2 &> /dev/null
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InHdrErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InHdrErrors"
+}
+
+ipv6_in_addr_err()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InAddrErrors)
+	local vrf_name=$(master_name_get $h1)
+
+	# Disable forwarding temporary while sending the packet
+	sysctl -qw net.ipv6.conf.all.forwarding=0
+	ip vrf exec $vrf_name \
+		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+	sysctl -qw net.ipv6.conf.all.forwarding=1
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InAddrErrors)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InAddrErrors"
+}
+
+ipv6_in_discard()
+{
+	RET=0
+
+	local t0=$(ipv6_stats_get $rtr1 Ip6InDiscards)
+	local vrf_name=$(master_name_get $h1)
+
+	# Add a policy to discard
+	ip xfrm policy add dst 2001:1:2::2/128 dir fwd action block
+	ip vrf exec $vrf_name \
+		$PING6 2001:1:2::2 -c 1 -w $PING_TIMEOUT &> /dev/null
+	ip xfrm policy del dst 2001:1:2::2/128 dir fwd
+
+	local t1=$(ipv6_stats_get $rtr1 Ip6InDiscards)
+	test "$((t1 - t0))" -ne 0
+	check_err $?
+	log_test "Ip6InDiscards"
+}
+ipv6_ping()
+{
+	RET=0
+
+	ping6_test $h1 2001:1:2::2
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 927f9ba49e08..be6fa808d219 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -674,6 +674,14 @@ qdisc_parent_stats_get()
 	    | jq '.[] | select(.parent == "'"$parent"'") | '"$selector"
 }
 
+ipv6_stats_get()
+{
+	local dev=$1; shift
+	local stat=$1; shift
+
+	cat /proc/net/dev_snmp6/$dev | grep "^$stat" | cut -f2
+}
+
 humanize()
 {
 	local speed=$1; shift
diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 431296c0f91c..aefe50e0e4a8 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -199,7 +199,6 @@ fi
 # test basic connectivity
 if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
-  bash
   exit 1
 fi
 
