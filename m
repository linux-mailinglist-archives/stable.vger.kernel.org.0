Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA39841477D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhIVLPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235567AbhIVLOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AA6610D1;
        Wed, 22 Sep 2021 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309188;
        bh=N/X5xJCJjTEiR51zVn+erisknTCaPaWlZC0quFaQASo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOpFTFaeCVmuMYSzZmPPs96eM6trN8rqvzVIPH9/5I4gLuIKbgu4l318+AMxeKAAZ
         zjAsTO/QHDkbRhQpWsHvAk9GRjINsHJC5/aBq3PtyRG66s9NnXcQ4DLyEdnknf8mxJ
         nn3JPy6Lnpre6kxMKYAU4asXJyBTie90g9r3dt1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.247
Date:   Wed, 22 Sep 2021 13:12:52 +0200
Message-Id: <1632309171163121@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163230917116451@kroah.com>
References: <163230917116451@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 4ec843123cc3..361bff6d3053 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2989,10 +2989,10 @@
 		65 = /dev/infiniband/issm1     Second InfiniBand IsSM device
 		  ...
 		127 = /dev/infiniband/issm63    63rd InfiniBand IsSM device
-		128 = /dev/infiniband/uverbs0   First InfiniBand verbs device
-		129 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
+		192 = /dev/infiniband/uverbs0   First InfiniBand verbs device
+		193 = /dev/infiniband/uverbs1   Second InfiniBand verbs device
 		  ...
-		159 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
+		223 = /dev/infiniband/uverbs31  31st InfiniBand verbs device
 
  232 char	Biometric Devices
 		0 = /dev/biometric/sensor0/fingerprint	first fingerprint sensor on first device
diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index dd559045593d..d2d1bae63a36 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -123,7 +123,7 @@ on various other factors also like;
 	so the device should have enough free bytes available its OOB/Spare
 	area to accommodate ECC for entire page. In general following expression
 	helps in determining if given device can accommodate ECC syndrome:
-	"2 + (PAGESIZE / 512) * ECC_BYTES" >= OOBSIZE"
+	"2 + (PAGESIZE / 512) * ECC_BYTES" <= OOBSIZE"
 	where
 		OOBSIZE		number of bytes in OOB/spare area
 		PAGESIZE	number of bytes in main-area of device page
diff --git a/Makefile b/Makefile
index 11f0d1f637c4..b05401adeaf5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 246
+SUBLEVEL = 247
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arc/mm/cache.c b/arch/arc/mm/cache.c
index d14499500106..bf02efbee5e1 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -1118,7 +1118,7 @@ void clear_user_page(void *to, unsigned long u_vaddr, struct page *page)
 	clear_page(to);
 	clear_bit(PG_dc_clean, &page->flags);
 }
-
+EXPORT_SYMBOL(clear_user_page);
 
 /**********************************************************************
  * Explicit Cache flush request from user space via syscall
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 746c8c575f98..a61b7e4d0666 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -87,6 +87,8 @@ $(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
 	$(addprefix $(obj)/,$(libfdt_hdrs))
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
+CFLAGS_REMOVE_atags_to_fdt.o += -Wframe-larger-than=${CONFIG_FRAME_WARN}
+CFLAGS_atags_to_fdt.o += -Wframe-larger-than=1280
 OBJS	+= $(libfdt_objs) atags_to_fdt.o
 endif
 
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 6089c8d56cd5..eef243998392 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1228,9 +1228,9 @@
 				<&mmcc DSI1_BYTE_CLK>,
 				<&mmcc DSI_PIXEL_CLK>,
 				<&mmcc DSI1_ESC_CLK>;
-			clock-names = "iface_clk", "bus_clk", "core_mmss_clk",
-					"src_clk", "byte_clk", "pixel_clk",
-					"core_clk";
+			clock-names = "iface", "bus", "core_mmss",
+					"src", "byte", "pixel",
+					"core";
 
 			assigned-clocks = <&mmcc DSI1_BYTE_SRC>,
 					<&mmcc DSI1_ESC_SRC>,
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 872046d48709..4d69d67792d1 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -185,8 +185,9 @@
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
 					"cdev1", "cdev2", "dap1", "dtb", "gma",
 					"gmb", "gmc", "gmd", "gme", "gpu7",
-					"gpv", "i2cp", "pta", "rm", "slxa",
-					"slxk", "spia", "spib", "uac";
+					"gpv", "i2cp", "irrx", "irtx", "pta",
+					"rm", "slxa", "slxk", "spia", "spib",
+					"uac";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -211,7 +212,7 @@
 			conf_ddc {
 				nvidia,pins = "ddc", "dta", "dtd", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
-					"sdc";
+					"sdc", "uad", "uca";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -221,10 +222,9 @@
 					"lvp0", "owc", "sdb";
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
-			conf_irrx {
-				nvidia,pins = "irrx", "irtx", "sdd", "spic",
-					"spie", "spih", "uaa", "uab", "uad",
-					"uca", "ucb";
+			conf_sdd {
+				nvidia,pins = "sdd", "spic", "spie", "spih",
+					"uaa", "uab", "ucb";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 50de918252b7..3939ad178405 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -17,10 +17,14 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o reboot.o return_address.o \
+		   process.o ptrace.o reboot.o \
 		   setup.o signal.o sigreturn_codes.o \
 		   stacktrace.o sys_arm.o time.o traps.o
 
+ifneq ($(CONFIG_ARM_UNWIND),y)
+obj-$(CONFIG_FRAME_POINTER)	+= return_address.o
+endif
+
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags_proc.o
 obj-$(CONFIG_DEPRECATED_PARAM_STRUCT) += atags_compat.o
diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index 36ed35073289..f945742dea44 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -10,8 +10,6 @@
  */
 #include <linux/export.h>
 #include <linux/ftrace.h>
-
-#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
 #include <linux/sched.h>
 
 #include <asm/stacktrace.h>
@@ -56,6 +54,4 @@ void *return_address(unsigned int level)
 		return NULL;
 }
 
-#endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) */
-
 EXPORT_SYMBOL_GPL(return_address);
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 875297a470da..331dcf94acf0 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -94,7 +94,7 @@
 			#address-cells = <0>;
 			interrupt-controller;
 			reg =	<0x11001000 0x1000>,
-				<0x11002000 0x1000>,
+				<0x11002000 0x2000>,
 				<0x11004000 0x2000>,
 				<0x11006000 0x2000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index 6a838b5d321e..1ab7deeb2497 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -27,7 +27,7 @@
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index e45ce4243aaa..76262dc40e79 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -258,8 +258,8 @@ static void __exit nfeth_cleanup(void)
 
 	for (i = 0; i < MAX_UNIT; i++) {
 		if (nfeth_dev[i]) {
-			unregister_netdev(nfeth_dev[0]);
-			free_netdev(nfeth_dev[0]);
+			unregister_netdev(nfeth_dev[i]);
+			free_netdev(nfeth_dev[i]);
 		}
 	}
 	free_irq(nfEtherIRQ, nfeth_interrupt);
diff --git a/arch/mips/mti-malta/malta-dtshim.c b/arch/mips/mti-malta/malta-dtshim.c
index 7859b6e49863..5b5d78a7882a 100644
--- a/arch/mips/mti-malta/malta-dtshim.c
+++ b/arch/mips/mti-malta/malta-dtshim.c
@@ -26,7 +26,7 @@
 #define  ROCIT_CONFIG_GEN1_MEMMAP_SHIFT	8
 #define  ROCIT_CONFIG_GEN1_MEMMAP_MASK	(0xf << 8)
 
-static unsigned char fdt_buf[16 << 10] __initdata;
+static unsigned char fdt_buf[16 << 10] __initdata __aligned(8);
 
 /* determined physical memory size, not overridden by command line args	 */
 extern unsigned long physical_memsize;
diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 0fdfa7142f4b..272eda8d6368 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -495,6 +495,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 	l.bnf	1f			// ext irq enabled, all ok.
 	l.nop
 
+#ifdef CONFIG_PRINTK
 	l.addi  r1,r1,-0x8
 	l.movhi r3,hi(42f)
 	l.ori	r3,r3,lo(42f)
@@ -508,6 +509,7 @@ EXCEPTION_ENTRY(_external_irq_handler)
 		.string "\n\rESR interrupt bug: in _external_irq_handler (ESR %x)\n\r"
 		.align 4
 	.previous
+#endif
 
 	l.ori	r4,r4,SPR_SR_IEE	// fix the bug
 //	l.sw	PT_SR(r1),r4
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index f2a4038e275b..99b1479792f0 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -242,6 +242,12 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs,
 #endif
 	
 	usp = (regs->gr[30] & ~(0x01UL));
+#ifdef CONFIG_64BIT
+	if (is_compat_task()) {
+		/* The gcc alloca implementation leaves garbage in the upper 32 bits of sp */
+		usp = (compat_uint_t)usp;
+	}
+#endif
 	/*FIXME: frame_size parameter is unused, remove it. */
 	frame = get_sigframe(&ksig->ka, usp, sizeof(*frame));
 
diff --git a/arch/powerpc/boot/crt0.S b/arch/powerpc/boot/crt0.S
index 9b9d17437373..0247b8e6cb1b 100644
--- a/arch/powerpc/boot/crt0.S
+++ b/arch/powerpc/boot/crt0.S
@@ -49,9 +49,6 @@ p_end:		.long	_end
 p_pstack:	.long	_platform_stack_top
 #endif
 
-	.globl	_zimage_start
-	/* Clang appears to require the .weak directive to be after the symbol
-	 * is defined. See https://bugs.llvm.org/show_bug.cgi?id=38921  */
 	.weak	_zimage_start
 _zimage_start:
 	.globl	_zimage_start_lib
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 4d8f6291b766..bbf033bda55d 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -695,7 +695,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			/*
 			 * If found, replace it with:
 			 *	addis r2, r12, (.TOC.-func)@ha
-			 *	addi r2, r12, (.TOC.-func)@l
+			 *	addi  r2,  r2, (.TOC.-func)@l
 			 */
 			((uint32_t *)location)[0] = 0x3c4c0000 + PPC_HA(value);
 			((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 43fabb3cae0f..160b86d9d819 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -168,7 +168,7 @@ static unsigned long single_gpci_request(u32 req, u32 starting_index,
 	 */
 	count = 0;
 	for (i = offset; i < offset + length; i++)
-		count |= arg->bytes[i] << (i - offset);
+		count |= (u64)(arg->bytes[i]) << ((length - 1 - (i - offset)) * 8);
 
 	*value = count;
 out:
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index dec2ece4af28..b6168c6abd3a 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -2018,7 +2018,7 @@ void show_code(struct pt_regs *regs)
 		start += opsize;
 		pr_cont("%s", buffer);
 		ptr = buffer;
-		ptr += sprintf(ptr, "\n\t  ");
+		ptr += sprintf(ptr, "\n          ");
 		hops++;
 	}
 	pr_cont("\n");
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 43f8430fb67d..608b363cd35b 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -43,7 +43,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index bb3710e7ad9c..1241e365af5d 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -626,8 +626,13 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 	case BPF_ALU64 | BPF_SUB | BPF_K: /* dst = dst - imm */
 		if (!imm)
 			break;
-		/* agfi %dst,-imm */
-		EMIT6_IMM(0xc2080000, dst_reg, -imm);
+		if (imm == -0x80000000) {
+			/* algfi %dst,0x80000000 */
+			EMIT6_IMM(0xc20a0000, dst_reg, 0x80000000);
+		} else {
+			/* agfi %dst,-imm */
+			EMIT6_IMM(0xc2080000, dst_reg, -imm);
+		}
 		break;
 	/*
 	 * BPF_MUL
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 3fe68f7f9d5e..5043425ced6b 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -90,6 +90,7 @@ struct perf_ibs {
 	unsigned long			offset_mask[1];
 	int				offset_max;
 	unsigned int			fetch_count_reset_broken : 1;
+	unsigned int			fetch_ignore_if_zero_rip : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -674,6 +675,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
+		/* Workaround for erratum #1197 */
+		if (perf_ibs->fetch_ignore_if_zero_rip && !(ibs_data.regs[1]))
+			goto out;
+
 		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
 	}
@@ -767,6 +772,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
 		perf_ibs_fetch.fetch_count_reset_broken = 1;
 
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
+		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 0661227d935c..990ca9614b23 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -69,7 +69,7 @@ static struct pt_cap_desc {
 	PT_CAP(topa_multiple_entries,	0, CPUID_ECX, BIT(1)),
 	PT_CAP(single_range_output,	0, CPUID_ECX, BIT(2)),
 	PT_CAP(payloads_lip,		0, CPUID_ECX, BIT(31)),
-	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x3),
+	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x7),
 	PT_CAP(mtc_periods,		1, CPUID_EAX, 0xffff0000),
 	PT_CAP(cycle_thresholds,	1, CPUID_EBX, 0xffff),
 	PT_CAP(psb_periods,		1, CPUID_EBX, 0xffff0000),
diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index 2d324cd1dea7..1c4be5dcd474 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -244,6 +244,12 @@ static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m = &rr->d->mbm_local[rmid];
 		break;
+	default:
+		/*
+		 * Code would never reach here because an invalid
+		 * event id would fail the __rmid_read.
+		 */
+		return RMID_VAL_ERROR;
 	}
 
 	if (rr->first) {
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 729e288718cc..aa08b7614ab0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -388,10 +388,11 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 	},
 	{	/* Handle problems with rebooting on the OptiPlex 990. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell OptiPlex 990 BIOS A0x",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A0"),
 		},
 	},
 	{	/* Handle problems with rebooting on Dell 300's */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d77caab7ad5e..0690155f42b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2355,6 +2355,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				/* Before back to guest, tsc_timestamp must be adjusted
+				 * as well, otherwise guest's percpu pvclock time could jump.
+				 */
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 624edfbff02d..8c02da40931a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1282,18 +1282,18 @@ int kern_addr_valid(unsigned long addr)
 		return 0;
 
 	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d))
+	if (!p4d_present(*p4d))
 		return 0;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+	if (!pud_present(*pud))
 		return 0;
 
 	if (pud_large(*pud))
 		return pfn_valid(pud_pfn(*pud));
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		return 0;
 
 	if (pmd_large(*pmd))
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 7d90a4645511..3e6a08068b25 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1214,6 +1214,11 @@ static void __init xen_dom0_set_legacy_features(void)
 	x86_platform.legacy.rtc = 1;
 }
 
+static void __init xen_domu_set_legacy_features(void)
+{
+	x86_platform.legacy.rtc = 0;
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage __visible void __init xen_start_kernel(void)
 {
@@ -1375,6 +1380,8 @@ asmlinkage __visible void __init xen_start_kernel(void)
 		add_preferred_console("hvc", 0, NULL);
 		if (pci_xen)
 			x86_init.pci.arch_init = pci_xen_init;
+		x86_platform.set_legacy_features =
+				xen_domu_set_legacy_features;
 	} else {
 		const struct dom0_vga_console_info *info =
 			(void *)((char *)xen_start_info +
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index e031b7e7272a..0d83f25ac8ac 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -613,8 +613,8 @@ int xen_alloc_p2m_entry(unsigned long pfn)
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index eb1f196c3f6e..2ad174fdc8ab 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -20,7 +20,7 @@ config XTENSA
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUTEX_CMPXCHG if !MMU
+	select HAVE_FUTEX_CMPXCHG if !MMU && FUTEX
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 0140a22551c8..63d6d043af16 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -182,9 +182,13 @@ static const struct tty_operations serial_ops = {
 
 int __init rs_init(void)
 {
-	tty_port_init(&serial_port);
+	int ret;
 
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
+	if (!serial_driver)
+		return -ENOMEM;
+
+	tty_port_init(&serial_port);
 
 	printk ("%s %s\n", serial_name, serial_version);
 
@@ -204,8 +208,15 @@ int __init rs_init(void)
 	tty_set_operations(serial_driver, &serial_ops);
 	tty_port_link_device(&serial_port, serial_driver, 0);
 
-	if (tty_register_driver(serial_driver))
-		panic("Couldn't register serial driver\n");
+	ret = tty_register_driver(serial_driver);
+	if (ret) {
+		pr_err("Couldn't register serial driver\n");
+		tty_driver_kref_put(serial_driver);
+		tty_port_destroy(&serial_port);
+
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 959bee9fa911..f8c6b898f637 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3825,7 +3825,7 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 	if (bfqq->new_ioprio >= IOPRIO_BE_NR) {
 		pr_crit("bfq_set_next_ioprio_data: new_ioprio %d\n",
 			bfqq->new_ioprio);
-		bfqq->new_ioprio = IOPRIO_BE_NR;
+		bfqq->new_ioprio = IOPRIO_BE_NR - 1;
 	}
 
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 77fce6f09f78..96cd65c22ec2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -277,9 +277,6 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
 
@@ -338,9 +335,6 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/certs/Makefile b/certs/Makefile
index 5d0999b9e21b..ca3c71e3a3d9 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -46,11 +46,19 @@ endif
 redirect_openssl	= 2>&1
 quiet_redirect_openssl	= 2>&1
 silent_redirect_openssl = 2>/dev/null
+openssl_available       = $(shell openssl help 2>/dev/null && echo yes)
 
 # We do it this way rather than having a boolean option for enabling an
 # external private key, because 'make randconfig' might enable such a
 # boolean option and we unfortunately can't make it depend on !RANDCONFIG.
 ifeq ($(CONFIG_MODULE_SIG_KEY),"certs/signing_key.pem")
+
+ifeq ($(openssl_available),yes)
+X509TEXT=$(shell openssl x509 -in "certs/signing_key.pem" -text 2>/dev/null)
+
+$(if $(findstring rsaEncryption,$(X509TEXT)),,$(shell rm -f "certs/signing_key.pem"))
+endif
+
 $(obj)/signing_key.pem: $(obj)/x509.genkey
 	@$(kecho) "###"
 	@$(kecho) "### Now generating an X.509 key pair to be used for signing modules."
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c28b0ca24907..8310beab6b2f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4564,6 +4564,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
@@ -6339,7 +6343,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index ce128d5a6ded..ed301dee200d 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1253,24 +1253,20 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "no SATA DMA irq\n");
-		err = -ENODEV;
-		goto error_out;
+		return -ENODEV;
 	}
 
 #ifdef CONFIG_SATA_DWC_OLD_DMA
 	if (!of_find_property(np, "dmas", NULL)) {
 		err = sata_dwc_dma_init_old(ofdev, hsdev);
 		if (err)
-			goto error_out;
+			return err;
 	}
 #endif
 
 	hsdev->phy = devm_phy_optional_get(hsdev->dev, "sata-phy");
-	if (IS_ERR(hsdev->phy)) {
-		err = PTR_ERR(hsdev->phy);
-		hsdev->phy = NULL;
-		goto error_out;
-	}
+	if (IS_ERR(hsdev->phy))
+		return PTR_ERR(hsdev->phy);
 
 	err = phy_init(hsdev->phy);
 	if (err)
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 1cda505d6a85..9664cce49109 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
+#include <linux/init.h>
 
 #include <linux/mc146818rtc.h>
 
@@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, unsigned int user)
 	const char *file = *(const char **)(tracedata + 2);
 	unsigned int user_hash_value, file_hash_value;
 
+	if (!x86_platform.legacy.rtc)
+		return;
+
 	user_hash_value = user % USERHASH;
 	file_hash_value = hash_string(lineno, file, FILEHASH);
 	set_magic_time(user_hash_value, file_hash_value, dev_hash_value);
@@ -267,6 +271,9 @@ static struct notifier_block pm_trace_nb = {
 
 static int early_resume_init(void)
 {
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	hash_value_early_read = read_magic_time();
 	register_pm_notifier(&pm_trace_nb);
 	return 0;
@@ -277,6 +284,9 @@ static int late_resume_init(void)
 	unsigned int val = hash_value_early_read;
 	unsigned int user, file, dev;
 
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	user = val % USERHASH;
 	val = val / USERHASH;
 	file = val % FILEHASH;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4e0cc40ad9ce..1c5ff22d92f1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1378,7 +1378,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			if (ret) {
 				dev_err(map->dev,
 					"Error in caching of register: %x ret: %d\n",
-					reg + i, ret);
+					reg + regmap_get_offset(map, i), ret);
 				return ret;
 			}
 		}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index e6986c7608f1..b1783f5b5cb5 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -236,6 +236,7 @@ EXPORT_SYMBOL(bcma_core_irq);
 
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
+	device_initialize(&core->dev);
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
@@ -299,11 +300,10 @@ static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
 
-	err = device_register(&core->dev);
+	err = device_add(&core->dev);
 	if (err) {
 		bcma_err(bus, "Could not register dev for core 0x%03X\n",
 			 core->id.id);
-		put_device(&core->dev);
 		return;
 	}
 	core->dev_registered = true;
@@ -394,7 +394,7 @@ void bcma_unregister_cores(struct bcma_bus *bus)
 	/* Now noone uses internally-handled cores, we can free them */
 	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
 		list_del(&core->list);
-		kfree(core);
+		put_device(&core->dev);
 	}
 }
 
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 01091c08e999..ef702fdb2f92 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -234,7 +234,7 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
+	tristate "Cryptoloop Support (DEPRECATED)"
 	select CRYPTO
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
@@ -246,7 +246,7 @@ config BLK_DEV_CRYPTOLOOP
 	  WARNING: This device is not safe for journaled file systems like
 	  ext3 or Reiserfs. Please use the Device Mapper crypto module
 	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
+	  cryptoloop device.  cryptoloop support will be removed in Linux 5.16.
 
 source "drivers/block/drbd/Kconfig"
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 74e03aa537ad..32363816cb04 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -203,6 +203,8 @@ init_cryptoloop(void)
 
 	if (rc)
 		printk(KERN_ERR "cryptoloop: loop_register_transfer failed\n");
+	else
+		pr_warn("the cryptoloop driver has been deprecated and will be removed in in Linux 5.16\n");
 	return rc;
 }
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 971a9a5006af..0813cc259f0f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -45,11 +45,6 @@ static struct hlist_head *all_lists[] = {
 	NULL,
 };
 
-static struct hlist_head *orphan_list[] = {
-	&clk_orphan_list,
-	NULL,
-};
-
 /***    private data structures    ***/
 
 struct clk_core {
@@ -2004,6 +1999,11 @@ static int inited = 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
 
+static struct hlist_head *orphan_list[] = {
+	&clk_orphan_list,
+	NULL,
+};
+
 static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {
diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index 890ebf623261..38612cd9092e 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -254,6 +254,7 @@ static const char *powersave_parents[] = {
 static const struct clk_muxing_soc_desc kirkwood_mux_desc[] __initconst = {
 	{ "powersave", powersave_parents, ARRAY_SIZE(powersave_parents),
 		11, 1, 0 },
+	{ }
 };
 
 static struct clk *clk_muxing_get_src(
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 3cd62f7c33e3..48eeee53a586 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -570,7 +570,8 @@ static int sh_cmt_start(struct sh_cmt_channel *ch, unsigned long flag)
 	ch->flags |= flag;
 
 	/* setup timeout if no clockevent */
-	if ((flag == FLAG_CLOCKSOURCE) && (!(ch->flags & FLAG_CLOCKEVENT)))
+	if (ch->cmt->num_channels == 1 &&
+	    flag == FLAG_CLOCKSOURCE && (!(ch->flags & FLAG_CLOCKEVENT)))
 		__sh_cmt_set_next(ch, ch->max_match_value);
  out:
 	raw_spin_unlock_irqrestore(&ch->lock, flags);
@@ -606,20 +607,25 @@ static struct sh_cmt_channel *cs_to_sh_cmt(struct clocksource *cs)
 static u64 sh_cmt_clocksource_read(struct clocksource *cs)
 {
 	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
-	unsigned long flags;
 	u32 has_wrapped;
-	u64 value;
-	u32 raw;
 
-	raw_spin_lock_irqsave(&ch->lock, flags);
-	value = ch->total_cycles;
-	raw = sh_cmt_get_counter(ch, &has_wrapped);
+	if (ch->cmt->num_channels == 1) {
+		unsigned long flags;
+		u64 value;
+		u32 raw;
 
-	if (unlikely(has_wrapped))
-		raw += ch->match_value + 1;
-	raw_spin_unlock_irqrestore(&ch->lock, flags);
+		raw_spin_lock_irqsave(&ch->lock, flags);
+		value = ch->total_cycles;
+		raw = sh_cmt_get_counter(ch, &has_wrapped);
+
+		if (unlikely(has_wrapped))
+			raw += ch->match_value + 1;
+		raw_spin_unlock_irqrestore(&ch->lock, flags);
+
+		return value + raw;
+	}
 
-	return value + raw;
+	return sh_cmt_get_counter(ch, &has_wrapped);
 }
 
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
@@ -682,7 +688,7 @@ static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
 	cs->disable = sh_cmt_clocksource_disable;
 	cs->suspend = sh_cmt_clocksource_suspend;
 	cs->resume = sh_cmt_clocksource_resume;
-	cs->mask = CLOCKSOURCE_MASK(sizeof(u64) * 8);
+	cs->mask = CLOCKSOURCE_MASK(ch->cmt->info->width);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
 	dev_info(&ch->cmt->pdev->dev, "ch%u: used as clock source\n",
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 56c3d86e5b9d..7ec5bc4548aa 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -44,6 +44,7 @@
 #define MAX_PSTATE_SHIFT	32
 #define LPSTATE_SHIFT		48
 #define GPSTATE_SHIFT		56
+#define MAX_NR_CHIPS		32
 
 #define MAX_RAMP_DOWN_TIME				5120
 /*
@@ -1011,12 +1012,20 @@ static int init_chip_info(void)
 	unsigned int *chip;
 	unsigned int cpu, i;
 	unsigned int prev_chip_id = UINT_MAX;
+	cpumask_t *chip_cpu_mask;
 	int ret = 0;
 
 	chip = kcalloc(num_possible_cpus(), sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	/* Allocate a chip cpu mask large enough to fit mask for all chips */
+	chip_cpu_mask = kcalloc(MAX_NR_CHIPS, sizeof(cpumask_t), GFP_KERNEL);
+	if (!chip_cpu_mask) {
+		ret = -ENOMEM;
+		goto free_and_return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned int id = cpu_to_chip_id(cpu);
 
@@ -1024,22 +1033,25 @@ static int init_chip_info(void)
 			prev_chip_id = id;
 			chip[nr_chips++] = id;
 		}
+		cpumask_set_cpu(cpu, &chip_cpu_mask[nr_chips-1]);
 	}
 
 	chips = kcalloc(nr_chips, sizeof(struct chip), GFP_KERNEL);
 	if (!chips) {
 		ret = -ENOMEM;
-		goto free_and_return;
+		goto out_free_chip_cpu_mask;
 	}
 
 	for (i = 0; i < nr_chips; i++) {
 		chips[i].id = chip[i];
-		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
+		cpumask_copy(&chips[i].mask, &chip_cpu_mask[i]);
 		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
 		for_each_cpu(cpu, &chips[i].mask)
 			per_cpu(chip_info, cpu) =  &chips[i];
 	}
 
+out_free_chip_cpu_mask:
+	kfree(chip_cpu_mask);
 free_and_return:
 	kfree(chip);
 	return ret;
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index eb569cf06309..e986be405411 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -167,15 +167,19 @@ static struct dcp *global_sdcp;
 
 static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 {
+	int dma_err;
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
 	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
 					      DMA_TO_DEVICE);
 
+	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
+	if (dma_err)
+		return dma_err;
+
 	reinit_completion(&sdcp->completion[chan]);
 
 	/* Clear status register. */
@@ -213,18 +217,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct ablkcipher_request *req, int init)
 {
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 	int ret;
 
-	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
-					     2 * AES_KEYSIZE_128,
-					     DMA_TO_DEVICE);
-	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
-					     DCP_BUF_SZ, DMA_FROM_DEVICE);
+	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
+				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
+
+	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
+				  DCP_BUF_SZ, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, src_phys);
+	if (ret)
+		goto err_src;
+
+	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
+				  DCP_BUF_SZ, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, dst_phys);
+	if (ret)
+		goto err_dst;
 
 	if (actx->fill % AES_BLOCK_SIZE) {
 		dev_err(sdcp->dev, "Invalid block size!\n");
@@ -262,10 +277,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	ret = mxs_dcp_start_dma(actx);
 
 aes_done_run:
+	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
+err_dst:
+	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
+err_src:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
 
 	return ret;
 }
@@ -280,21 +297,20 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *src = req->src;
-	const int nents = sg_nents(req->src);
+	int dst_nents = sg_nents(dst);
 
 	const int out_off = DCP_BUF_SZ;
 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
 
-	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
 	uint32_t dst_off = 0;
+	uint8_t *src_buf = NULL;
 	uint32_t last_out_len = 0;
 
 	uint8_t *key = sdcp->coh->aes_key;
 
 	int ret = 0;
-	int split = 0;
-	unsigned int i, len, clen, rem = 0, tlen = 0;
+	unsigned int i, len, clen, tlen = 0;
 	int init = 0;
 	bool limit_hit = false;
 
@@ -312,7 +328,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, nents, i) {
+	for_each_sg(req->src, src, sg_nents(src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
@@ -337,34 +353,17 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * submit the buffer.
 			 */
 			if (actx->fill == out_off || sg_is_last(src) ||
-				limit_hit) {
+			    limit_hit) {
 				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init = 0;
 
-				out_tmp = out_buf;
+				sg_pcopy_from_buffer(dst, dst_nents, out_buf,
+						     actx->fill, dst_off);
+				dst_off += actx->fill;
 				last_out_len = actx->fill;
-				while (dst && actx->fill) {
-					if (!split) {
-						dst_buf = sg_virt(dst);
-						dst_off = 0;
-					}
-					rem = min(sg_dma_len(dst) - dst_off,
-						  actx->fill);
-
-					memcpy(dst_buf + dst_off, out_tmp, rem);
-					out_tmp += rem;
-					dst_off += rem;
-					actx->fill -= rem;
-
-					if (dst_off == sg_dma_len(dst)) {
-						dst = sg_next(dst);
-						split = 0;
-					} else {
-						split = 1;
-					}
-				}
+				actx->fill = 0;
 			}
 		} while (len);
 
@@ -565,6 +564,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
+	ret = dma_mapping_error(sdcp->dev, buf_phys);
+	if (ret)
+		return ret;
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -597,6 +600,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	if (rctx->fini) {
 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
+		ret = dma_mapping_error(sdcp->dev, digest_phys);
+		if (ret)
+			goto done_run;
+
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e34e9561e77d..adf958956982 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1746,7 +1746,7 @@ static void omap_sham_done_task(unsigned long data)
 		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
 			goto finish;
 	} else if (test_bit(FLAGS_DMA_READY, &dd->flags)) {
-		if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
+		if (test_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
 			omap_sham_update_dma_stop(dd);
 			if (dd->err) {
 				err = dd->err;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index d2d0ae445fd8..7c7d49a8a403 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -123,10 +123,10 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 38e4bc04f407..90e8a7564756 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -123,10 +123,10 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index d78f8d5c89c3..289dd7e48d4a 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -239,8 +239,8 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
@@ -263,12 +263,12 @@ static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
 
-static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 26556c713049..7a7d43c47534 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -105,6 +105,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int ret;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -171,9 +172,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 
 	hw_data->enable_error_correction(accel_dev);
-	hw_data->enable_vf2pf_comms(accel_dev);
+	ret = hw_data->enable_vf2pf_comms(accel_dev);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_dev_init);
 
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 2c0be14309cf..7877ba677220 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -59,6 +59,8 @@
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
+#define ADF_MAX_NUM_VFS	32
+
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -111,7 +113,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-		u32 vf_mask;
+		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
 		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
@@ -132,8 +134,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			 * unless the VF is malicious and is attempting to
 			 * flood the host OS with VF2PF interrupts.
 			 */
-			for_each_set_bit(i, (const unsigned long *)&vf_mask,
-					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
 				vf_info = accel_dev->pf.vf_info + i;
 
 				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index b3875fdf6cd7..c64481160b71 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -231,7 +231,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
@@ -361,6 +360,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index cd5f37dffe8a..1830194567e8 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -49,14 +49,14 @@
 #include "adf_pf2vf_msg.h"
 
 /**
- * adf_vf2pf_init() - send init msg to PF
+ * adf_vf2pf_notify_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends an init messge from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -69,17 +69,17 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_init);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
 
 /**
- * adf_vf2pf_shutdown() - send shutdown msg to PF
+ * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends a shutdown messge from the VF to a PF
  *
  * Return: void
  */
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -89,4 +89,4 @@ void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send Shutdown event to PF\n");
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index df9a1f35b832..ef90902c8200 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -203,6 +203,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	bool handled = false;
 	u32 v_int;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
@@ -215,7 +216,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 
 		/* Schedule tasklet to handle interrupt BH */
 		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
 	/* Check bundle interrupt */
@@ -227,10 +228,10 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 		WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 					   0);
 		tasklet_hi_schedule(&bank->resp_handler);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
-	return IRQ_NONE;
+	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index a3b4dd8099a7..3a8361c83f0b 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -123,10 +123,10 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8028fbd5cda4..830d03115efb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,11 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
+#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
+#else
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
+#endif
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 struct talitos_ctx {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index f2739995c335..199eccee0b0b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -338,7 +338,7 @@ static void amdgpu_i2c_put_byte(struct amdgpu_i2c_chan *i2c_bus,
 void
 amdgpu_i2c_router_select_ddc_port(const struct amdgpu_connector *amdgpu_connector)
 {
-	u8 val;
+	u8 val = 0;
 
 	if (!amdgpu_connector->router.ddc_valid)
 		return;
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 98742d7af6dc..bacb33eec0fa 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -34,8 +34,10 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 	}
 
 	phy_pdev = of_find_device_by_node(phy_node);
-	if (phy_pdev)
+	if (phy_pdev) {
 		msm_dsi->phy = platform_get_drvdata(phy_pdev);
+		msm_dsi->phy_dev = &phy_pdev->dev;
+	}
 
 	of_node_put(phy_node);
 
@@ -44,8 +46,6 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 		return -EPROBE_DEFER;
 	}
 
-	msm_dsi->phy_dev = get_device(&phy_pdev->dev);
-
 	return 0;
 }
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 0e63cedcc3b5..96bf221ba572 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -425,8 +425,6 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 
 		if (dev->battery_status == HID_BATTERY_UNKNOWN)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else if (dev->battery_capacity == 100)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		break;
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 56dc69e7349f..9ad031ea3300 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -382,7 +382,7 @@ static int highlander_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	dev->irq = platform_get_irq(pdev, 0);
-	if (iic_force_poll)
+	if (dev->irq < 0 || iic_force_poll)
 		dev->irq = 0;
 
 	if (dev->irq) {
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 85cbe4b55578..d4fe7ccccb22 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -456,16 +456,14 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		ret = -ENXIO;
+		ret = irq;
 		goto unmap;
 	}
 	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
 				pdev->name, adapter_data);
 
-	if (ret) {
-		ret = -EIO;
+	if (ret)
 		goto unmap;
-	}
 
 	memcpy(new_adapter->name, pdev->name, strlen(pdev->name));
 	new_adapter->owner = THIS_MODULE;
diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 09d288ce0ddb..cbcf76ea9c19 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -740,7 +740,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c->pdmabase);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	init_completion(&i2c->msg_complete);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index de10ca40aebc..911f8628128e 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1181,7 +1181,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	 */
 	if (!(i2c->quirks & QUIRK_POLL)) {
 		i2c->irq = ret = platform_get_irq(pdev, 0);
-		if (ret <= 0) {
+		if (ret < 0) {
 			dev_err(&pdev->dev, "cannot find IRQ\n");
 			clk_unprepare(i2c->clk);
 			return ret;
diff --git a/drivers/iio/dac/ad5624r_spi.c b/drivers/iio/dac/ad5624r_spi.c
index 5489ec43b95d..e5cefdb674f8 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -231,7 +231,7 @@ static int ad5624r_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
+	st->reg = devm_regulator_get_optional(&spi->dev, "vref");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
 		if (ret)
@@ -242,6 +242,22 @@ static int ad5624r_probe(struct spi_device *spi)
 			goto error_disable_reg;
 
 		voltage_uv = ret;
+	} else {
+		if (PTR_ERR(st->reg) != -ENODEV)
+			return PTR_ERR(st->reg);
+		/* Backwards compatibility. This naming is not correct */
+		st->reg = devm_regulator_get_optional(&spi->dev, "vcc");
+		if (!IS_ERR(st->reg)) {
+			ret = regulator_enable(st->reg);
+			if (ret)
+				return ret;
+
+			ret = regulator_get_voltage(st->reg);
+			if (ret < 0)
+				goto error_disable_reg;
+
+			voltage_uv = ret;
+		}
 	}
 
 	spi_set_drvdata(spi, indio_dev);
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 16b0c10348e8..66204e08ce5a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1176,29 +1176,34 @@ static int __init iw_cm_init(void)
 
 	ret = iwpm_init(RDMA_NL_IWCM);
 	if (ret)
-		pr_err("iw_cm: couldn't init iwpm\n");
-	else
-		rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
+		return ret;
+
 	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", 0);
 	if (!iwcm_wq)
-		return -ENOMEM;
+		goto err_alloc;
 
 	iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
 						 iwcm_ctl_table);
 	if (!iwcm_ctl_table_hdr) {
 		pr_err("iw_cm: couldn't register sysctl paths\n");
-		destroy_workqueue(iwcm_wq);
-		return -ENOMEM;
+		goto err_sysctl;
 	}
 
+	rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
 	return 0;
+
+err_sysctl:
+	destroy_workqueue(iwcm_wq);
+err_alloc:
+	iwpm_exit(RDMA_NL_IWCM);
+	return -ENOMEM;
 }
 
 static void __exit iw_cm_cleanup(void)
 {
+	rdma_nl_unregister(RDMA_NL_IWCM);
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
-	rdma_nl_unregister(RDMA_NL_IWCM);
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5e38ceb36000..b8a9695af141 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2188,7 +2188,12 @@ static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
 	struct crypt_config *cc = pool_data;
 	struct page *page;
 
-	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
+	/*
+	 * Note, percpu_counter_read_positive() may over (and under) estimate
+	 * the current usage by at most (batch - 1) * num_online_cpus() pages,
+	 * but avoids potential spinlock contention of an exact result.
+	 */
+	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) >= dm_crypt_pages_per_client) &&
 	    likely(gfp_mask & __GFP_NORETRY))
 		return NULL;
 
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 5d9381509b07..59ab01dc62b1 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2110,32 +2110,55 @@ static void dib8000_load_ana_fe_coefs(struct dib8000_state *state, const s16 *an
 			dib8000_write_word(state, 117 + mode, ana_fe[mode]);
 }
 
-static const u16 lut_prbs_2k[14] = {
-	0, 0x423, 0x009, 0x5C7, 0x7A6, 0x3D8, 0x527, 0x7FF, 0x79B, 0x3D6, 0x3A2, 0x53B, 0x2F4, 0x213
+static const u16 lut_prbs_2k[13] = {
+	0x423, 0x009, 0x5C7,
+	0x7A6, 0x3D8, 0x527,
+	0x7FF, 0x79B, 0x3D6,
+	0x3A2, 0x53B, 0x2F4,
+	0x213
 };
-static const u16 lut_prbs_4k[14] = {
-	0, 0x208, 0x0C3, 0x7B9, 0x423, 0x5C7, 0x3D8, 0x7FF, 0x3D6, 0x53B, 0x213, 0x029, 0x0D0, 0x48E
+
+static const u16 lut_prbs_4k[13] = {
+	0x208, 0x0C3, 0x7B9,
+	0x423, 0x5C7, 0x3D8,
+	0x7FF, 0x3D6, 0x53B,
+	0x213, 0x029, 0x0D0,
+	0x48E
 };
-static const u16 lut_prbs_8k[14] = {
-	0, 0x740, 0x069, 0x7DD, 0x208, 0x7B9, 0x5C7, 0x7FF, 0x53B, 0x029, 0x48E, 0x4C4, 0x367, 0x684
+
+static const u16 lut_prbs_8k[13] = {
+	0x740, 0x069, 0x7DD,
+	0x208, 0x7B9, 0x5C7,
+	0x7FF, 0x53B, 0x029,
+	0x48E, 0x4C4, 0x367,
+	0x684
 };
 
 static u16 dib8000_get_init_prbs(struct dib8000_state *state, u16 subchannel)
 {
 	int sub_channel_prbs_group = 0;
+	int prbs_group;
 
-	sub_channel_prbs_group = (subchannel / 3) + 1;
-	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
+	sub_channel_prbs_group = subchannel / 3;
+	if (sub_channel_prbs_group >= ARRAY_SIZE(lut_prbs_2k))
+		return 0;
 
 	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
 	case TRANSMISSION_MODE_2K:
-			return lut_prbs_2k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_2k[sub_channel_prbs_group];
+		break;
 	case TRANSMISSION_MODE_4K:
-			return lut_prbs_4k[sub_channel_prbs_group];
+		prbs_group =  lut_prbs_4k[sub_channel_prbs_group];
+		break;
 	default:
 	case TRANSMISSION_MODE_8K:
-			return lut_prbs_8k[sub_channel_prbs_group];
+		prbs_group = lut_prbs_8k[sub_channel_prbs_group];
 	}
+
+	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n",
+		sub_channel_prbs_group, subchannel, prbs_group);
+
+	return prbs_group;
 }
 
 static void dib8000_set_13seg_channel(struct dib8000_state *state)
@@ -2412,10 +2435,8 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	/* TSB or ISDBT ? apply it now */
 	if (c->isdbt_sb_mode) {
 		dib8000_set_sb_channel(state);
-		if (c->isdbt_sb_subchannel < 14)
-			init_prbs = dib8000_get_init_prbs(state, c->isdbt_sb_subchannel);
-		else
-			init_prbs = 0;
+		init_prbs = dib8000_get_init_prbs(state,
+						  c->isdbt_sb_subchannel);
 	} else {
 		dib8000_set_13seg_channel(state);
 		init_prbs = 0xfff;
@@ -3007,6 +3028,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	unsigned long *timeout = &state->timeout;
 	unsigned long now = jiffies;
+	u16 init_prbs;
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1, agc2;
 #endif
@@ -3305,8 +3327,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		break;
 
 	case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
-		if (state->subchannel <= 41) {
-			dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
+		init_prbs = dib8000_get_init_prbs(state, state->subchannel);
+
+		if (init_prbs) {
+			dib8000_set_subchannel_prbs(state, init_prbs);
 			*tune_state = CT_DEMOD_STEP_9;
 		} else {
 			*tune_state = CT_DEMOD_STOP;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 3822d9ebcb46..5abbde7e5d5b 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -52,7 +52,7 @@ static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);
diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index 1babd3341910..016a6d1ad279 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -133,7 +133,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 {
-	int i;
+	int i, ret;
 	u8 b;
 
 	mac[0] = 0x00;
@@ -142,7 +142,9 @@ static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 
 	/* this is a complete guess, but works for my box */
 	for (i = 136; i < 139; i++) {
-		dibusb_read_eeprom_byte(d,i, &b);
+		ret = dibusb_read_eeprom_byte(d, i, &b);
+		if (ret)
+			return ret;
 
 		mac[5 - (i - 136)] = b;
 	}
diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index 40de33de90a7..5c3b0a7ca27e 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -294,16 +294,22 @@ static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
 	u8 i, *buf;
+	int ret;
 	struct vp702x_device_state *st = d->priv;
 
 	mutex_lock(&st->buf_mutex);
 	buf = st->buf;
-	for (i = 6; i < 12; i++)
-		vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1, &buf[i - 6], 1);
+	for (i = 6; i < 12; i++) {
+		ret = vp702x_usb_in_op(d, READ_EEPROM_REQ, i, 1,
+				       &buf[i - 6], 1);
+		if (ret < 0)
+			goto err;
+	}
 
 	memcpy(mac, buf, 6);
+err:
 	mutex_unlock(&st->buf_mutex);
-	return 0;
+	return ret;
 }
 
 static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index b8c94b4ad232..0be2fb751705 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -839,7 +839,6 @@ static int em28xx_ir_init(struct em28xx *dev)
 	kfree(ir);
 ref_put:
 	em28xx_shutdown_buttons(dev);
-	kref_put(&dev->ref, em28xx_free_device);
 	return err;
 }
 
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 05b1126f263e..d861d7225f49 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -698,49 +698,23 @@ struct go7007 *go7007_alloc(const struct go7007_board_info *board,
 						struct device *dev)
 {
 	struct go7007 *go;
-	int i;
 
 	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
 	go->board_info = board;
-	go->board_id = 0;
 	go->tuner_type = -1;
-	go->channel_number = 0;
-	go->name[0] = 0;
 	mutex_init(&go->hw_lock);
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
 	go->status = STATUS_INIT;
-	memset(&go->i2c_adapter, 0, sizeof(go->i2c_adapter));
-	go->i2c_adapter_online = 0;
-	go->interrupt_available = 0;
 	init_waitqueue_head(&go->interrupt_waitq);
-	go->input = 0;
 	go7007_update_board(go);
-	go->encoder_h_halve = 0;
-	go->encoder_v_halve = 0;
-	go->encoder_subsample = 0;
 	go->format = V4L2_PIX_FMT_MJPEG;
 	go->bitrate = 1500000;
 	go->fps_scale = 1;
-	go->pali = 0;
 	go->aspect_ratio = GO7007_RATIO_1_1;
-	go->gop_size = 0;
-	go->ipb = 0;
-	go->closed_gop = 0;
-	go->repeat_seqhead = 0;
-	go->seq_header_enable = 0;
-	go->gop_header_enable = 0;
-	go->dvd_mode = 0;
-	go->interlace_coding = 0;
-	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;
-	for (i = 0; i < 1624; ++i)
-		go->modet_map[i] = 0;
-	go->audio_deliver = NULL;
-	go->audio_enabled = 0;
 
 	return go;
 }
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 6992e84f8a8b..2058742c556e 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1355,7 +1355,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	if (!dev->isoc_ep) {
 		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1368,10 +1368,12 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	err = stk_register_video_device(dev);
 	if (err)
-		goto error;
+		goto error_put;
 
 	return 0;
 
+error_put:
+	usb_put_intf(interface);
 error:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 08a3a8ad79d7..fae811b9cde9 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -876,8 +876,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u8 i;
 
 	if (chain->selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -885,22 +885,27 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 		return 0;
 	}
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
 			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
-			     &i, 1);
-	if (ret < 0)
-		return ret;
+			     buf, 1);
+	if (!ret)
+		*input = *buf - 1;
 
-	*input = i - 1;
-	return 0;
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u32 i;
 
 	ret = uvc_acquire_privileges(handle);
 	if (ret < 0)
@@ -916,10 +921,17 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 	if (input >= chain->selector->bNrInPins)
 		return -EINVAL;
 
-	i = input + 1;
-	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
-			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
-			      &i, 1);
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	*buf = input + 1;
+	ret = uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
+			     chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
+			     buf, 1);
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_queryctrl(struct file *file, void *fh,
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5c8c49d240d1..bed6b7db43f5 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -207,7 +207,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	if (!v4l2_valid_dv_timings(t, cap, fnc, fnc_handle))
 		return false;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
@@ -229,7 +229,7 @@ bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic)
 {
 	unsigned int i;
 
-	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
 		const struct v4l2_bt_timings *bt =
 			&v4l2_dv_timings_presets[i].bt;
 
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 11ab17f64c64..f0527e769867 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -493,7 +493,7 @@ static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
 		if (line == AB8540_INT_GPIO43F || line == AB8540_INT_GPIO44F)
 			line += 1;
 
-		handle_nested_irq(irq_create_mapping(ab8500->domain, line));
+		handle_nested_irq(irq_find_mapping(ab8500->domain, line));
 	}
 
 	return 0;
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 566caca4efd8..722ad2c368a5 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1035,7 +1035,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 
 	if (variant->id_val == STMPE801_ID ||
 	    variant->id_val == STMPE1600_ID) {
-		int base = irq_create_mapping(stmpe->domain, 0);
+		int base = irq_find_mapping(stmpe->domain, 0);
 
 		handle_nested_irq(base);
 		return IRQ_HANDLED;
@@ -1063,7 +1063,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 		while (status) {
 			int bit = __ffs(status);
 			int line = bank * 8 + bit;
-			int nestedirq = irq_create_mapping(stmpe->domain, line);
+			int nestedirq = irq_find_mapping(stmpe->domain, line);
 
 			handle_nested_irq(nestedirq);
 			status &= ~(1 << bit);
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index cc9e563f23aa..7062baf60685 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -187,7 +187,7 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
 
 	while (status) {
 		int bit = __ffs(status);
-		int virq = irq_create_mapping(tc3589x->domain, bit);
+		int virq = irq_find_mapping(tc3589x->domain, bit);
 
 		handle_nested_irq(virq);
 		status &= ~(1 << bit);
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 18710f3b5c53..2c58d9b99a39 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -159,7 +159,7 @@ static irqreturn_t wm8994_edge_irq(int irq, void *data)
 	struct wm8994 *wm8994 = data;
 
 	while (gpio_get_value_cansleep(wm8994->pdata.irq_gpio))
-		handle_nested_irq(irq_create_mapping(wm8994->edge_irq, 0));
+		handle_nested_irq(irq_find_mapping(wm8994->edge_irq, 0));
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/misc/aspeed-lpc-ctrl.c b/drivers/misc/aspeed-lpc-ctrl.c
index b5439643f54b..f3cc3167f1ef 100644
--- a/drivers/misc/aspeed-lpc-ctrl.c
+++ b/drivers/misc/aspeed-lpc-ctrl.c
@@ -44,7 +44,7 @@ static int aspeed_lpc_ctrl_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long vsize = vma->vm_end - vma->vm_start;
 	pgprot_t prot = vma->vm_page_prot;
 
-	if (vma->vm_pgoff + vsize > lpc_ctrl->mem_base + lpc_ctrl->mem_size)
+	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 7a7de85406e5..8394f4d03934 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -2338,7 +2338,8 @@ int vmci_qp_broker_map(struct vmci_handle handle,
 	is_local = entry->qp.flags & VMCI_QPFLAG_LOCAL;
 	result = VMCI_SUCCESS;
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    !QPBROKERSTATE_HAS_MEM(entry)) {
 		struct vmci_qp_page_store page_store;
 
 		page_store.pages = guest_mem;
@@ -2448,7 +2449,8 @@ int vmci_qp_broker_unmap(struct vmci_handle handle,
 
 	is_local = entry->qp.flags & VMCI_QPFLAG_LOCAL;
 
-	if (context_id != VMCI_HOST_CONTEXT_ID) {
+	if (context_id != VMCI_HOST_CONTEXT_ID &&
+	    QPBROKERSTATE_HAS_MEM(entry)) {
 		qp_acquire_queue_mutex(entry->produce_q);
 		result = qp_save_headers(entry);
 		if (result < VMCI_SUCCESS)
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bd994a8fce14..44d317d71b4c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -832,6 +832,7 @@ static int dw_mci_edmac_start_dma(struct dw_mci *host,
 	int ret = 0;
 
 	/* Set external dma config: burst size, burst width */
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.dst_addr = host->phy_regs + fifo_offset;
 	cfg.src_addr = cfg.dst_addr;
 	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index a0670e9cd012..5553a5643f40 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -631,6 +631,7 @@ static int moxart_probe(struct platform_device *pdev)
 			 host->dma_chan_tx, host->dma_chan_rx);
 		host->have_dma = true;
 
+		memset(&cfg, 0, sizeof(cfg));
 		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 41b57713b620..9de6a32f0c9f 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -551,9 +551,22 @@ static int sd_write_long_data(struct realtek_pci_sdmmc *host,
 	return 0;
 }
 
+static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
+}
+
+static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+}
+
 static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 {
 	struct mmc_data *data = mrq->data;
+	int err;
 
 	if (host->sg_count < 0) {
 		data->error = host->sg_count;
@@ -562,22 +575,19 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 		return data->error;
 	}
 
-	if (data->flags & MMC_DATA_READ)
-		return sd_read_long_data(host, mrq);
+	if (data->flags & MMC_DATA_READ) {
+		if (host->initial_mode)
+			sd_disable_initial_mode(host);
 
-	return sd_write_long_data(host, mrq);
-}
+		err = sd_read_long_data(host, mrq);
 
-static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
-}
+		if (host->initial_mode)
+			sd_enable_initial_mode(host);
 
-static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+		return err;
+	}
+
+	return sd_write_long_data(host, mrq);
 }
 
 static void sd_normal_rw(struct realtek_pci_sdmmc *host,
diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index e033ad477715..0a2bfd034df3 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -179,7 +179,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 			 * through low speeds without power cycling.
 			 */
 			sdhci_set_clock(host, host->max_clk);
-			phy_power_on(sdhci_arasan->phy);
+			if (phy_power_on(sdhci_arasan->phy)) {
+				pr_err("%s: Cannot power on phy.\n",
+				       mmc_hostname(host->mmc));
+				return;
+			}
+
 			sdhci_arasan->is_phy_on = true;
 
 			/*
@@ -205,7 +210,12 @@ static void sdhci_arasan_set_clock(struct sdhci_host *host, unsigned int clock)
 	sdhci_set_clock(host, clock);
 
 	if (ctrl_phy) {
-		phy_power_on(sdhci_arasan->phy);
+		if (phy_power_on(sdhci_arasan->phy)) {
+			pr_err("%s: Cannot power on phy.\n",
+			       mmc_hostname(host->mmc));
+			return;
+		}
+
 		sdhci_arasan->is_phy_on = true;
 	}
 }
@@ -305,7 +315,9 @@ static int sdhci_arasan_suspend(struct device *dev)
 		ret = phy_power_off(sdhci_arasan->phy);
 		if (ret) {
 			dev_err(dev, "Cannot power off phy.\n");
-			sdhci_resume_host(host);
+			if (sdhci_resume_host(host))
+				dev_err(dev, "Cannot resume host.\n");
+
 			return ret;
 		}
 		sdhci_arasan->is_phy_on = false;
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 98c013094fa2..ffc4ca1872e2 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -702,7 +702,7 @@ static int cafe_nand_probe(struct pci_dev *pdev,
 			  "CAFE NAND", mtd);
 	if (err) {
 		dev_warn(&pdev->dev, "Could not register IRQ %d\n", pdev->irq);
-		goto out_ior;
+		goto out_free_rs;
 	}
 
 	/* Disable master reset, enable NAND clock */
@@ -809,6 +809,8 @@ static int cafe_nand_probe(struct pci_dev *pdev,
 	/* Disable NAND IRQ in global IRQ mask register */
 	cafe_writel(cafe, ~1 & cafe_readl(cafe, GLOBAL_IRQ_MASK), GLOBAL_IRQ_MASK);
 	free_irq(pdev->irq, mtd);
+ out_free_rs:
+	free_rs(cafe->rs);
  out_ior:
 	pci_iounmap(pdev, cafe->mmio);
  out_free_mtd:
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 820aed3e2352..9fff49229435 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1843,9 +1843,8 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	/* cpu port is always last */
-	dev->num_ports = dev->cpu_port + 1;
 	dev->enabled_ports |= BIT(dev->cpu_port);
+	dev->num_ports = fls(dev->enabled_ports);
 
 	dev->ports = devm_kzalloc(dev->dev,
 				  sizeof(struct b53_port) * dev->num_ports,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index e4d1aaf838a4..c87b5b508993 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1243,7 +1243,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 
 	/* SR-IOV capability was enabled but there are no VFs*/
 	if (iov->total == 0) {
-		err = -EINVAL;
+		err = 0;
 		goto failed;
 	}
 
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index f1f07e9d53f8..07d6472dd149 100755
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -286,6 +286,12 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 
 	if (GEM_BFEXT(DMA_RXVALID, desc->addr)) {
 		desc_ptp = macb_ptp_desc(bp, desc);
+		/* Unlikely but check */
+		if (!desc_ptp) {
+			dev_warn_ratelimited(&bp->pdev->dev,
+					     "Timestamp not supported in BD\n");
+			return;
+		}
 		gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
@@ -318,8 +324,11 @@ int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
 	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
 		return -ENOMEM;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	/* Unlikely but check */
+	if (!desc_ptp)
+		return -EINVAL;
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	tx_timestamp = &queue->tx_timestamps[head];
 	tx_timestamp->skb = skb;
 	tx_timestamp->desc_ptp.ts_1 = desc_ptp->ts_1;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 8623be13bf86..eef8fa100889 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1157,6 +1157,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 52e747fd9c83..62d514b60e23 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -437,7 +437,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
 			rc = cnt;
 	}
 
-	if (rc > 0) {
+	/* For VFs, we should return with an error in case we didn't get the
+	 * exact number of msix vectors as we requested.
+	 * Not doing that will lead to a crash when starting queues for
+	 * this VF.
+	 */
+	if ((IS_PF(cdev) && rc > 0) || (IS_VF(cdev) && rc == cnt)) {
 		/* MSI-x configuration was achieved */
 		int_params->out.int_mode = QED_INT_MODE_MSIX;
 		int_params->out.num_vectors = rc;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 8bb734486bf3..99de923728ec 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1590,6 +1590,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2088,7 +2089,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
index c48a0e2d4d7e..6a009d51ec51 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
@@ -440,7 +440,6 @@ int qlcnic_pinit_from_rom(struct qlcnic_adapter *adapter)
 	QLCWR32(adapter, QLCNIC_CRB_PEG_NET_4 + 0x3c, 1);
 	msleep(20);
 
-	qlcnic_rom_unlock(adapter);
 	/* big hammer don't reset CAM block on reset */
 	QLCWR32(adapter, QLCNIC_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 1c87178fc485..1ca1f72474ab 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -413,7 +413,7 @@ qcaspi_receive(struct qcaspi *qca)
 				skb_put(qca->rx_skb, retcode);
 				qca->rx_skb->protocol = eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
-				qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+				skb_checksum_none_assert(qca->rx_skb);
 				netif_rx_ni(qca->rx_skb);
 				qca->rx_skb = netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index db6068cd7a1f..466e9d07697a 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -107,7 +107,7 @@ qca_tty_receive(struct serdev_device *serdev, const unsigned char *data,
 			skb_put(qca->rx_skb, retcode);
 			qca->rx_skb->protocol = eth_type_trans(
 						qca->rx_skb, qca->rx_skb->dev);
-			qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb_checksum_none_assert(qca->rx_skb);
 			netif_rx_ni(qca->rx_skb);
 			qca->rx_skb = netdev_alloc_skb_ip_align(netdev,
 								netdev->mtu +
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index aa11b70b9ca4..2199bd08f4d6 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -133,6 +133,8 @@
 #define PHY_ST		0x8A	/* PHY status register */
 #define MAC_SM		0xAC	/* MAC status machine */
 #define  MAC_SM_RST	0x0002	/* MAC status machine reset */
+#define MD_CSC		0xb6	/* MDC speed control register */
+#define  MD_CSC_DEFAULT	0x0030
 #define MAC_ID		0xBE	/* Identifier register */
 
 #define TX_DCNT		0x80	/* TX descriptor count */
@@ -368,8 +370,9 @@ static void r6040_reset_mac(struct r6040_private *lp)
 {
 	void __iomem *ioaddr = lp->base;
 	int limit = MAC_DEF_TIMEOUT;
-	u16 cmd;
+	u16 cmd, md_csc;
 
+	md_csc = ioread16(ioaddr + MD_CSC);
 	iowrite16(MAC_RST, ioaddr + MCR1);
 	while (limit--) {
 		cmd = ioread16(ioaddr + MCR1);
@@ -381,6 +384,10 @@ static void r6040_reset_mac(struct r6040_private *lp)
 	iowrite16(MAC_SM_RST, ioaddr + MAC_SM);
 	iowrite16(0, ioaddr + MAC_SM);
 	mdelay(5);
+
+	/* Restore MDIO clock frequency */
+	if (md_csc != MD_CSC_DEFAULT)
+		iowrite16(md_csc, ioaddr + MD_CSC);
 }
 
 static void r6040_init_mac_regs(struct net_device *dev)
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 36f1019809ea..0fa6403ab085 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2442,6 +2442,7 @@ static int sh_eth_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	else
 		txdesc->status |= cpu_to_le32(TD_TACT);
 
+	wmb(); /* cur_tx must be incremented after TACT bit was set */
 	mdp->cur_tx++;
 
 	if (!(sh_eth_read(ndev, EDTRR) & sh_eth_get_edtrr_trns(mdp)))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index f4ff43a1b5ba..d8c40b68bc96 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -300,10 +300,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 		val &= ~NSS_COMMON_GMAC_CTL_PHY_IFACE_SEL;
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_GMAC_CTL(gmac->id), val);
 
@@ -320,10 +317,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 			NSS_COMMON_CLK_SRC_CTRL_OFFSET(gmac->id);
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_SRC_CTRL, val);
 
@@ -340,8 +334,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 				NSS_COMMON_CLK_GATE_GMII_TX_EN(gmac->id);
 		break;
 	default:
-		/* We don't get here; the switch above will have errored out */
-		unreachable();
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
@@ -372,6 +365,11 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_unsupported_phy:
+	dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
+		phy_modes(gmac->phy_mode));
+	err = -EINVAL;
+
 err_remove_config_dt:
 	stmmac_remove_config_dt(pdev, plat_dat);
 
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index 2bdfb39215e9..87610d8b3462 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1059,6 +1059,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 939de185bc6b..178234e94cd1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -736,10 +736,8 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Kick off the transfer */
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
-	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
 		netif_stop_queue(ndev);
-	}
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/phy/dp83640_reg.h b/drivers/net/phy/dp83640_reg.h
index 21aa24c741b9..daae7fa58fb8 100644
--- a/drivers/net/phy/dp83640_reg.h
+++ b/drivers/net/phy/dp83640_reg.h
@@ -5,7 +5,7 @@
 #ifndef HAVE_DP83640_REGISTERS
 #define HAVE_DP83640_REGISTERS
 
-#define PAGE0                     0x0000
+/* #define PAGE0                  0x0000 */
 #define PHYCR2                    0x001c /* PHY Control Register 2 */
 
 #define PAGE4                     0x0004
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 0362acd5cdca..cdd1b193fd4f 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -655,6 +655,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit LN920 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1061, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ad64ec2e04b5..cda57104d5ba 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -613,6 +613,28 @@ struct amsdu_subframe_hdr {
 
 #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
 
+static inline u8 ath10k_bw_to_mac80211_bw(u8 bw)
+{
+	u8 ret = 0;
+
+	switch (bw) {
+	case 0:
+		ret = RATE_INFO_BW_20;
+		break;
+	case 1:
+		ret = RATE_INFO_BW_40;
+		break;
+	case 2:
+		ret = RATE_INFO_BW_80;
+		break;
+	case 3:
+		ret = RATE_INFO_BW_160;
+		break;
+	}
+
+	return ret;
+}
+
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
@@ -721,23 +743,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		if (sgi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-		switch (bw) {
-		/* 20MHZ */
-		case 0:
-			break;
-		/* 40MHZ */
-		case 1:
-			status->bw = RATE_INFO_BW_40;
-			break;
-		/* 80MHZ */
-		case 2:
-			status->bw = RATE_INFO_BW_80;
-			break;
-		case 3:
-			status->bw = RATE_INFO_BW_160;
-			break;
-		}
-
+		status->bw = ath10k_bw_to_mac80211_bw(bw);
 		status->encoding = RX_ENC_VHT;
 		break;
 	default:
@@ -2436,7 +2442,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
 	arsta->txrate.nss = txrate.nss;
-	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f80f1757b58f..66df6f8bc0de 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2513,8 +2513,10 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 		goto free_data_skb;
 
 	for (index = 0; index < num_pri_streams; index++) {
-		if (WARN_ON(!data_sync_bufs[index].skb))
+		if (WARN_ON(!data_sync_bufs[index].skb)) {
+			ret = -ENOMEM;
 			goto free_data_skb;
+		}
 
 		ep_id = ath6kl_ac2_endpoint_id(wmi->parent_dev,
 					       data_sync_bufs[index].
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 76385834a7de..694a58b1e995 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3346,7 +3346,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
-		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
+		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485) ||
+		    (length > cptr)) {
 			ath_dbg(common, EEPROM, "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
 			continue;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 933d4f49d6b0..9e3db55a8684 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1595,7 +1595,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
-		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
@@ -2702,14 +2701,17 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
 static void ath9k_hw_gpio_cfg_soc(struct ath_hw *ah, u32 gpio, bool out,
 				  const char *label)
 {
+	int err;
+
 	if (ah->caps.gpio_requested & BIT(gpio))
 		return;
 
-	/* may be requested by BSP, free anyway */
-	gpio_free(gpio);
-
-	if (gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label))
+	err = gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label);
+	if (err) {
+		ath_err(ath9k_hw_common(ah), "request GPIO%d failed:%d\n",
+			gpio, err);
 		return;
+	}
 
 	ah->caps.gpio_requested |= BIT(gpio);
 }
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 57e1c0dd63c4..11fd3a7484ac 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -654,13 +654,13 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->ctrl.queue_count = nr_io_queues + 1;
-	if (ctrl->ctrl.queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->ctrl.device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->ctrl.queue_count = nr_io_queues + 1;
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 5d41dda6da4e..75daa16f38b7 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -535,7 +535,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index a3a28e38430a..f84166f99517 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -185,7 +185,7 @@
 	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
 
-#define PIO_RETRY_CNT			500
+#define PIO_RETRY_CNT			750000 /* 1.5 s */
 #define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10
@@ -200,6 +200,7 @@ struct advk_pcie {
 	struct list_head resources;
 	struct irq_domain *irq_domain;
 	struct irq_chip irq_chip;
+	raw_spinlock_t irq_lock;
 	struct irq_domain *msi_domain;
 	struct irq_domain *msi_inner_domain;
 	struct irq_chip msi_bottom_irq_chip;
@@ -638,22 +639,28 @@ static void advk_pcie_irq_mask(struct irq_data *d)
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask |= PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static void advk_pcie_irq_unmask(struct irq_data *d)
 {
 	struct advk_pcie *pcie = d->domain->host_data;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long flags;
 	u32 mask;
 
+	raw_spin_lock_irqsave(&pcie->irq_lock, flags);
 	mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	mask &= ~PCIE_ISR1_INTX_ASSERT(hwirq);
 	advk_writel(pcie, mask, PCIE_ISR1_MASK_REG);
+	raw_spin_unlock_irqrestore(&pcie->irq_lock, flags);
 }
 
 static int advk_pcie_irq_map(struct irq_domain *h,
@@ -736,6 +743,8 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	struct device_node *pcie_intc_node;
 	struct irq_chip *irq_chip;
 
+	raw_spin_lock_init(&pcie->irq_lock);
+
 	pcie_intc_node =  of_get_next_child(node, NULL);
 	if (!pcie_intc_node) {
 		dev_err(dev, "No PCIe Intc node found\n");
diff --git a/drivers/pci/host/pcie-xilinx-nwl.c b/drivers/pci/host/pcie-xilinx-nwl.c
index 981a5195686f..6812a1b49fa8 100644
--- a/drivers/pci/host/pcie-xilinx-nwl.c
+++ b/drivers/pci/host/pcie-xilinx-nwl.c
@@ -10,6 +10,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -171,6 +172,7 @@ struct nwl_pcie {
 	u8 root_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -852,6 +854,16 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pcie->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(pcie->clk))
+		return PTR_ERR(pcie->clk);
+
+	err = clk_prepare_enable(pcie->clk);
+	if (err) {
+		dev_err(dev, "can't enable PCIe ref clock\n");
+		return err;
+	}
+
 	err = nwl_pcie_bridge_init(pcie);
 	if (err) {
 		dev_err(dev, "HW Initialization failed\n");
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 147369773280..2d7b06cfc606 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -754,6 +754,9 @@ static void msix_mask_all(void __iomem *base, int tsize)
 	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	int i;
 
+	if (pci_msi_ignore_mask)
+		return;
+
 	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
 		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c847b5554db6..4ff7f2575d28 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1384,11 +1384,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	 * so that things like MSI message writing will behave as expected
 	 * (e.g. if the device really is in D0 at enable time).
 	 */
-	if (dev->pm_cap) {
-		u16 pmcsr;
-		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
-		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	}
+	pci_update_current_state(dev, dev->current_state);
 
 	if (atomic_inc_return(&dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
@@ -1950,7 +1946,14 @@ static int __pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable
 	if (enable) {
 		int error;
 
-		if (pci_pme_capable(dev, state))
+		/*
+		 * Enable PME signaling if the device can signal PME from
+		 * D3cold regardless of whether or not it can signal PME from
+		 * the current target state, because that will allow it to
+		 * signal PME when the hierarchy above it goes into D3cold and
+		 * the device itself ends up in D3cold as a result of that.
+		 */
+		if (pci_pme_capable(dev, state) || pci_pme_capable(dev, PCI_D3cold))
 			pci_pme_active(dev, true);
 		else
 			ret = 1;
@@ -2054,17 +2057,21 @@ static pci_power_t pci_target_state(struct pci_dev *dev, bool wakeup)
 	if (dev->current_state == PCI_D3cold)
 		target_state = PCI_D3cold;
 
-	if (wakeup) {
+	if (wakeup && dev->pme_support) {
+		pci_power_t state = target_state;
+
 		/*
 		 * Find the deepest state from which the device can generate
 		 * wake-up events, make it the target state and enable device
 		 * to generate PME#.
 		 */
-		if (dev->pme_support) {
-			while (target_state
-			      && !(dev->pme_support & (1 << target_state)))
-				target_state--;
-		}
+		while (state && !(dev->pme_support & (1 << state)))
+			state--;
+
+		if (state)
+			return state;
+		else if (dev->pme_support & 1)
+			return PCI_D0;
 	}
 
 	return target_state;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index db1ec8209b56..eff361af792a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3034,12 +3034,13 @@ static void fixup_mpss_256(struct pci_dev *dev)
 {
 	dev->pcie_mpss = 1; /* 256 bytes */
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /* Intel 5000 and 5100 Memory controllers have an errata with read completion
  * coalescing (which is enabled by default on some BIOSes) and MPS of 256B.
@@ -4738,6 +4739,10 @@ static const struct pci_dev_acs_enabled {
 	{ 0x10df, 0x720, pci_quirk_mf_endpoint_acs }, /* Emulex Skyhawk-R */
 	/* Cavium ThunderX */
 	{ PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID, pci_quirk_cavium_acs },
+	/* Cavium multi-function devices */
+	{ PCI_VENDOR_ID_CAVIUM, 0xA026, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA059, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA060, pci_quirk_mf_endpoint_acs },
 	/* APM X-Gene */
 	{ PCI_VENDOR_ID_AMCC, 0xE004, pci_quirk_xgene_acs },
 	/* Ampere Computing */
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index 7445f895ecd1..18345d4643d7 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -24,8 +24,10 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
 	long err;
 	int cfg_ret;
 
+	err = -EPERM;
+	dev = NULL;
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		goto error;
 
 	err = -ENODEV;
 	dev = pci_get_bus_and_slot(bus, dfn);
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index f751b5c3bf7e..e33972c3a420 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1161,6 +1161,7 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 
 	if (PCS_HAS_PINCONF) {
 		dev_err(pcs->dev, "pinconf not supported\n");
+		res = -ENOTSUPP;
 		goto free_pingroups;
 	}
 
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 7c0f5d4e89f3..ab04d4c4941d 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -891,7 +891,7 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 		pin_bank->grange.pin_base = drvdata->pin_base
 						+ pin_bank->pin_base;
 		pin_bank->grange.base = pin_bank->grange.pin_base;
-		pin_bank->grange.npins = pin_bank->gpio_chip.ngpio;
+		pin_bank->grange.npins = pin_bank->nr_pins;
 		pin_bank->grange.gc = &pin_bank->gpio_chip;
 		pinctrl_add_gpio_range(drvdata->pctl_dev, &pin_bank->grange);
 	}
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index dbad14716da4..b8e90c1a5e26 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -217,6 +217,15 @@ static int cros_ec_host_command_proto_query(struct cros_ec_device *ec_dev,
 	msg->insize = sizeof(struct ec_response_get_protocol_info);
 
 	ret = send_command(ec_dev, msg);
+	/*
+	 * Send command once again when timeout occurred.
+	 * Fingerprint MCU (FPMCU) is restarted during system boot which
+	 * introduces small window in which FPMCU won't respond for any
+	 * messages sent by kernel. There is no need to wait before next
+	 * attempt because we waited at least EC_MSG_DEADLINE_MS.
+	 */
+	if (ret == -ETIMEDOUT)
+		ret = send_command(ec_dev, msg);
 
 	if (ret < 0) {
 		dev_dbg(ec_dev->dev,
diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index a8dcabc32721..1fe18c365c87 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -142,7 +142,7 @@ static int fuel_gauge_reg_readb(struct axp288_fg_info *info, int reg)
 	}
 
 	if (ret < 0) {
-		dev_err(&info->pdev->dev, "axp288 reg read err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error reading reg 0x%02x err: %d\n", reg, ret);
 		return ret;
 	}
 
@@ -156,7 +156,7 @@ static int fuel_gauge_reg_writeb(struct axp288_fg_info *info, int reg, u8 val)
 	ret = regmap_write(info->regmap, reg, (unsigned int)val);
 
 	if (ret < 0)
-		dev_err(&info->pdev->dev, "axp288 reg write err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error writing reg 0x%02x err: %d\n", reg, ret);
 
 	return ret;
 }
diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 911d42366ef1..fe5331b23a94 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -717,7 +717,7 @@ static inline void max17042_override_por_values(struct max17042_chip *chip)
 	struct max17042_config_data *config = chip->pdata->config_data;
 
 	max17042_override_por(map, MAX17042_TGAIN, config->tgain);
-	max17042_override_por(map, MAx17042_TOFF, config->toff);
+	max17042_override_por(map, MAX17042_TOFF, config->toff);
 	max17042_override_por(map, MAX17042_CGAIN, config->cgain);
 	max17042_override_por(map, MAX17042_COFF, config->coff);
 
@@ -833,8 +833,12 @@ static irqreturn_t max17042_thread_handler(int id, void *dev)
 {
 	struct max17042_chip *chip = dev;
 	u32 val;
+	int ret;
+
+	ret = regmap_read(chip->regmap, MAX17042_STATUS, &val);
+	if (ret)
+		return IRQ_HANDLED;
 
-	regmap_read(chip->regmap, MAX17042_STATUS, &val);
 	if ((val & STATUS_INTR_SOCMIN_BIT) ||
 		(val & STATUS_INTR_SOCMAX_BIT)) {
 		dev_info(&chip->client->dev, "SOC threshold INTR\n");
diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index a56b526db89a..33c56a1d3456 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -480,6 +480,6 @@ static struct platform_driver tps65910_rtc_driver = {
 };
 
 module_platform_driver(tps65910_rtc_driver);
-MODULE_ALIAS("platform:rtc-tps65910");
+MODULE_ALIAS("platform:tps65910-rtc");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index e2026d54dd37..435e804b6b8b 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -330,9 +330,26 @@ static ssize_t pimpampom_show(struct device *dev,
 }
 static DEVICE_ATTR(pimpampom, 0444, pimpampom_show, NULL);
 
+static ssize_t dev_busid_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct subchannel *sch = to_subchannel(dev);
+	struct pmcw *pmcw = &sch->schib.pmcw;
+
+	if ((pmcw->st == SUBCHANNEL_TYPE_IO ||
+	     pmcw->st == SUBCHANNEL_TYPE_MSG) && pmcw->dnv)
+		return sysfs_emit(buf, "0.%x.%04x\n", sch->schid.ssid,
+				  pmcw->dev);
+	else
+		return sysfs_emit(buf, "none\n");
+}
+static DEVICE_ATTR_RO(dev_busid);
+
 static struct attribute *io_subchannel_type_attrs[] = {
 	&dev_attr_chpids.attr,
 	&dev_attr_pimpampom.attr,
+	&dev_attr_dev_busid.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(io_subchannel_type);
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 48c1b590415d..92fbc0d6b185 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3605,7 +3605,7 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			if (buf[0] != '\n' || len > 1)
 				printk("%sscsi%d: %s", blogic_msglevelmap[msglevel], adapter->host_no, buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	} else {
 		if (begin) {
 			if (adapter != NULL && adapter->adapter_initd)
@@ -3613,7 +3613,7 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			else
 				printk("%s%s", blogic_msglevelmap[msglevel], buf);
 		} else
-			printk("%s", buf);
+			pr_cont("%s", buf);
 	}
 	begin = (buf[len - 1] == '\n');
 }
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 06958a192a5b..09f57ef35990 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1302,7 +1302,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -1313,14 +1313,14 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 	 */
 	if (!qedi->num_queues) {
 		QEDI_ERR(&qedi->dbg_ctx, "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/* Make sure we allocated the PBL that will contain the physical
 	 * addresses of our queues
 	 */
 	if (!qedi->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		goto mem_alloc_failure;
 	}
 
@@ -1335,13 +1335,13 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		  "qedi->global_queues=%p.\n", qedi->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedi_alloc_bdq(qedi);
-	if (rc)
+	status = qedi_alloc_bdq(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate DMA coherent buffers for NVM_ISCSI_CFG */
-	rc = qedi_alloc_nvm_iscsi_cfg(qedi);
-	if (rc)
+	status = qedi_alloc_nvm_iscsi_cfg(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate a CQ and an associated PBL for each MSI-X
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 6b33a1f24f56..c756298c0562 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -88,8 +88,9 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
 
-	if (!qidx)
-		qidx++;
+	/* Map admin queue and 1st IO queue to index 0 */
+	if (qidx)
+		qidx--;
 
 	vha = (struct scsi_qla_host *)lport->private;
 	ha = vha->hw;
diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 50214b620865..2b49d2c212da 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -117,7 +117,7 @@ struct smsm_entry {
 	DECLARE_BITMAP(irq_enabled, 32);
 	DECLARE_BITMAP(irq_rising, 32);
 	DECLARE_BITMAP(irq_falling, 32);
-	u32 last_value;
+	unsigned long last_value;
 
 	u32 *remote_state;
 	u32 *subscription;
@@ -212,8 +212,7 @@ static irqreturn_t smsm_intr(int irq, void *data)
 	u32 val;
 
 	val = readl(entry->remote_state);
-	changed = val ^ entry->last_value;
-	entry->last_value = val;
+	changed = val ^ xchg(&entry->last_value, val);
 
 	for_each_set_bit(i, entry->irq_enabled, 32) {
 		if (!(changed & BIT(i)))
@@ -274,6 +273,12 @@ static void smsm_unmask_irq(struct irq_data *irqd)
 	struct qcom_smsm *smsm = entry->smsm;
 	u32 val;
 
+	/* Make sure our last cached state is up-to-date */
+	if (readl(entry->remote_state) & BIT(irq))
+		set_bit(irq, &entry->last_value);
+	else
+		clear_bit(irq, &entry->last_value);
+
 	set_bit(irq, entry->irq_enabled);
 
 	if (entry->subscription) {
diff --git a/drivers/soc/rockchip/Kconfig b/drivers/soc/rockchip/Kconfig
index 20da55d9cbb1..d483b0e29b81 100644
--- a/drivers/soc/rockchip/Kconfig
+++ b/drivers/soc/rockchip/Kconfig
@@ -5,8 +5,8 @@ if ARCH_ROCKCHIP || COMPILE_TEST
 #
 
 config ROCKCHIP_GRF
-	bool
-	default y
+	bool "Rockchip General Register Files support" if COMPILE_TEST
+	default y if ARCH_ROCKCHIP
 	help
 	  The General Register Files are a central component providing
 	  special additional settings registers for a lot of soc-components.
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index ed114f00a6d1..59f18e344bfb 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -394,6 +394,7 @@ static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 		goto err_rx_dma_buf;
 	}
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = phy_addr + SPI_POPR;
 	cfg.dst_addr = phy_addr + SPI_PUSHR;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
diff --git a/drivers/spi/spi-pic32.c b/drivers/spi/spi-pic32.c
index 661a40c653e9..d8cdb13ce3e4 100644
--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -369,6 +369,7 @@ static int pic32_spi_dma_config(struct pic32_spi *pic32s, u32 dma_width)
 	struct dma_slave_config cfg;
 	int ret;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.device_fc = true;
 	cfg.src_addr = pic32s->dma_base + buf_offset;
 	cfg.dst_addr = pic32s->dma_base + buf_offset;
diff --git a/drivers/staging/board/board.c b/drivers/staging/board/board.c
index 86dc41101610..1e2b33912a8a 100644
--- a/drivers/staging/board/board.c
+++ b/drivers/staging/board/board.c
@@ -139,6 +139,7 @@ int __init board_staging_register_clock(const struct board_staging_clk *bsc)
 static int board_staging_add_dev_domain(struct platform_device *pdev,
 					const char *domain)
 {
+	struct device *dev = &pdev->dev;
 	struct of_phandle_args pd_args;
 	struct device_node *np;
 
@@ -151,7 +152,11 @@ static int board_staging_add_dev_domain(struct platform_device *pdev,
 	pd_args.np = np;
 	pd_args.args_count = 0;
 
-	return of_genpd_add_device(&pd_args, &pdev->dev);
+	/* Initialization similar to device_pm_init_common() */
+	spin_lock_init(&dev->power.lock);
+	dev->power.early_init = true;
+
+	return of_genpd_add_device(&pd_args, dev);
 }
 #else
 static inline int board_staging_add_dev_domain(struct platform_device *pdev,
diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 8cfdff198334..84a5b6ebfd07 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -904,9 +904,9 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 	memset(&priv->wstats, 0, sizeof(priv->wstats));
 
 	/* sleep mode */
+	atomic_set(&priv->sleepstatus.status, 0);
 	atomic_set(&priv->sleepstatus.doze_request, 0);
 	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
 
 	trx_device_init(priv);
 	hostif_init(priv);
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index a401b13f5f5e..c46ac0e5e852 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -3026,10 +3026,10 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	if (dev_info_id == 0x15) {
-		buf_len = 0x3A;
+		buf_len = 0x3C;
 		data_len = 0x3A;
 	} else {
-		buf_len = 0x6A;
+		buf_len = 0x6C;
 		data_len = 0x6A;
 	}
 
@@ -3081,11 +3081,7 @@ static int get_ms_information(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	rtsx_stor_set_xfer_buf(buf, buf_len, srb);
-
-	if (dev_info_id == 0x15)
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x3C);
-	else
-		scsi_set_resid(srb, scsi_bufflen(srb) - 0x6C);
+	scsi_set_resid(srb, scsi_bufflen(srb) - buf_len);
 
 	kfree(buf);
 	return STATUS_SUCCESS;
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 2e578d6433af..7d7fdfc578a9 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1051,7 +1051,7 @@ static const struct tty_operations hvsi_ops = {
 
 static int __init hvsi_init(void)
 {
-	int i;
+	int i, ret;
 
 	hvsi_driver = alloc_tty_driver(hvsi_count);
 	if (!hvsi_driver)
@@ -1082,12 +1082,25 @@ static int __init hvsi_init(void)
 	}
 	hvsi_wait = wait_for_state; /* irqs active now */
 
-	if (tty_register_driver(hvsi_driver))
-		panic("Couldn't register hvsi console driver\n");
+	ret = tty_register_driver(hvsi_driver);
+	if (ret) {
+		pr_err("Couldn't register hvsi console driver\n");
+		goto err_free_irq;
+	}
 
 	printk(KERN_DEBUG "HVSI: registered %i devices\n", hvsi_count);
 
 	return 0;
+err_free_irq:
+	hvsi_wait = poll_for_state;
+	for (i = 0; i < hvsi_count; i++) {
+		struct hvsi_struct *hp = &hvsi_ports[i];
+
+		free_irq(hp->virq, hp);
+	}
+	tty_driver_kref_put(hvsi_driver);
+
+	return ret;
 }
 device_initcall(hvsi_init);
 
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 071ee37399b7..72015cc7b33f 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -73,7 +73,7 @@ static void moan_device(const char *str, struct pci_dev *dev)
 
 static int
 setup_port(struct serial_private *priv, struct uart_8250_port *port,
-	   int bar, int offset, int regshift)
+	   u8 bar, unsigned int offset, int regshift)
 {
 	struct pci_dev *dev = priv->dev;
 
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 20f58e9da2fb..7ac6bb38948f 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -136,7 +136,8 @@ static const struct serial8250_config uart_config[] = {
 		.name		= "16C950/954",
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01,
+		.rxtrig_bytes	= {16, 32, 112, 120},
 		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
 		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 3d5fe53988e5..62d1e4607912 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2170,7 +2170,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	ret = platform_get_irq(pdev, 0);
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index c6fdd6369534..96e01bf4599c 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -827,7 +827,9 @@ static void neo_parse_isr(struct jsm_board *brd, u32 port)
 		/* Parse any modem signal changes */
 		jsm_dbg(INTR, &ch->ch_bd->pci_dev,
 			"MOD_STAT: sending to parse_modem_sigs\n");
+		spin_lock_irqsave(&ch->uart_port.lock, lock_flags);
 		neo_parse_modem(ch, readb(&ch->ch_neo_uart->msr));
+		spin_unlock_irqrestore(&ch->uart_port.lock, lock_flags);
 	}
 }
 
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index ec7d8383900f..7c790ff6b511 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -195,6 +195,7 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 
 static int jsm_tty_open(struct uart_port *port)
 {
+	unsigned long lock_flags;
 	struct jsm_board *brd;
 	struct jsm_channel *channel =
 		container_of(port, struct jsm_channel, uart_port);
@@ -248,6 +249,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_cached_lsr = 0;
 	channel->ch_stops_sent = 0;
 
+	spin_lock_irqsave(&port->lock, lock_flags);
 	termios = &port->state->port.tty->termios;
 	channel->ch_c_cflag	= termios->c_cflag;
 	channel->ch_c_iflag	= termios->c_iflag;
@@ -267,6 +269,7 @@ static int jsm_tty_open(struct uart_port *port)
 	jsm_carrier(channel);
 
 	channel->ch_open_count++;
+	spin_unlock_irqrestore(&port->lock, lock_flags);
 
 	jsm_dbg(OPEN, &channel->ch_bd->pci_dev, "finish\n");
 	return 0;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index ae3af8debf67..463f35273365 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2165,8 +2165,6 @@ static int tty_fasync(int fd, struct file *filp, int on)
  *	Locking:
  *		Called functions take tty_ldiscs_lock
  *		current->signal->tty check is safe without locks
- *
- *	FIXME: may race normal receive processing
  */
 
 static int tiocsti(struct tty_struct *tty, char __user *p)
@@ -2182,8 +2180,10 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld)
 		return -EIO;
+	tty_buffer_lock_exclusive(tty->port);
 	if (ld->ops->receive_buf)
 		ld->ops->receive_buf(tty, &ch, &mbz, 1);
+	tty_buffer_unlock_exclusive(tty->port);
 	tty_ldisc_deref(ld);
 	return 0;
 }
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 6696fdd97530..49806837b98b 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -484,7 +484,7 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 {
 	unsigned val;
 
-	if (c->MaxPower)
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
 		val = c->MaxPower;
 	else
 		val = CONFIG_USB_GADGET_VBUS_DRAW;
@@ -894,7 +894,11 @@ static int set_config(struct usb_composite_dev *cdev,
 	}
 
 	/* when we return, be sure our power usage is valid */
-	power = c->MaxPower ? c->MaxPower : CONFIG_USB_GADGET_VBUS_DRAW;
+	if (c->MaxPower || (c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+		power = c->MaxPower;
+	else
+		power = CONFIG_USB_GADGET_VBUS_DRAW;
+
 	if (gadget->speed < USB_SPEED_SUPER)
 		power = min(power, 500U);
 	else
diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 989682cc8686..38a35f57b22c 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -495,8 +495,9 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	if (skb && !in) {
-		dev_kfree_skb_any(skb);
+	if (!in) {
+		if (skb)
+			dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index 8bc78418d40e..cd92cda03d71 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1895,7 +1895,9 @@ static int at91udc_probe(struct platform_device *pdev)
 	clk_disable(udc->iclk);
 
 	/* request UDC and maybe VBUS irqs */
-	udc->udp_irq = platform_get_irq(pdev, 0);
+	udc->udp_irq = retval = platform_get_irq(pdev, 0);
+	if (retval < 0)
+		goto err_unprepare_iclk;
 	retval = devm_request_irq(dev, udc->udp_irq, at91_udc_irq, 0,
 				  driver_name, udc);
 	if (retval) {
diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 58ba04d858ba..23a27eb33c42 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -573,7 +573,8 @@ static int bdc_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(dev,
 				"No suitable DMA config available, abort\n");
-			return -ENOTSUPP;
+			ret = -ENOTSUPP;
+			goto phycleanup;
 		}
 		dev_dbg(dev, "Using 32-bit address\n");
 	}
diff --git a/drivers/usb/gadget/udc/mv_u3d_core.c b/drivers/usb/gadget/udc/mv_u3d_core.c
index 772049afe166..83c6c776a371 100644
--- a/drivers/usb/gadget/udc/mv_u3d_core.c
+++ b/drivers/usb/gadget/udc/mv_u3d_core.c
@@ -1925,14 +1925,6 @@ static int mv_u3d_probe(struct platform_device *dev)
 		goto err_get_irq;
 	}
 	u3d->irq = r->start;
-	if (request_irq(u3d->irq, mv_u3d_irq,
-		IRQF_SHARED, driver_name, u3d)) {
-		u3d->irq = 0;
-		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
-			u3d->irq);
-		retval = -ENODEV;
-		goto err_request_irq;
-	}
 
 	/* initialize gadget structure */
 	u3d->gadget.ops = &mv_u3d_ops;	/* usb_gadget_ops */
@@ -1945,6 +1937,15 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 	mv_u3d_eps_init(u3d);
 
+	if (request_irq(u3d->irq, mv_u3d_irq,
+		IRQF_SHARED, driver_name, u3d)) {
+		u3d->irq = 0;
+		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
+			u3d->irq);
+		retval = -ENODEV;
+		goto err_request_irq;
+	}
+
 	/* external vbus detection */
 	if (u3d->vbus) {
 		u3d->clock_gating = 1;
@@ -1968,8 +1969,8 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 err_unregister:
 	free_irq(u3d->irq, u3d);
-err_request_irq:
 err_get_irq:
+err_request_irq:
 	kfree(u3d->status_req);
 err_alloc_status_req:
 	kfree(u3d->eps);
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 1aec87ec68df..753c73624fb6 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -253,8 +253,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 * the clock does not exists.
 	 */
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(priv->clk))
-		clk_prepare_enable(priv->clk);
+	if (!IS_ERR(priv->clk)) {
+		err = clk_prepare_enable(priv->clk);
+		if (err)
+			goto err_put_hcd;
+	}
 
 	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
 	if (IS_ERR(priv->phy)) {
@@ -315,6 +318,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 err_phy_get:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+err_put_hcd:
 	usb_put_hcd(hcd);
 err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index bbe1ea00d887..3008d692000a 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -2536,11 +2536,6 @@ static unsigned qh_completions(struct fotg210_hcd *fotg210,
 	return count;
 }
 
-/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
-#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
-/* ... and packet size, for any kind of endpoint descriptor */
-#define max_packet(wMaxPacketSize) ((wMaxPacketSize) & 0x07ff)
-
 /* reverse of qh_urb_transaction:  free a list of TDs.
  * used for cleanup after errors, before HC sees an URB's TDs.
  */
@@ -2626,7 +2621,7 @@ static struct list_head *qh_urb_transaction(struct fotg210_hcd *fotg210,
 		token |= (1 /* "in" */ << 8);
 	/* else it's already initted to "out" pid (0 << 8) */
 
-	maxpacket = max_packet(usb_maxpacket(urb->dev, urb->pipe, !is_input));
+	maxpacket = usb_maxpacket(urb->dev, urb->pipe, !is_input);
 
 	/*
 	 * buffer gets wrapped in one or more qtds;
@@ -2740,9 +2735,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 		gfp_t flags)
 {
 	struct fotg210_qh *qh = fotg210_qh_alloc(fotg210, flags);
+	struct usb_host_endpoint *ep;
 	u32 info1 = 0, info2 = 0;
 	int is_input, type;
 	int maxp = 0;
+	int mult;
 	struct usb_tt *tt = urb->dev->tt;
 	struct fotg210_qh_hw *hw;
 
@@ -2757,14 +2754,15 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 
 	is_input = usb_pipein(urb->pipe);
 	type = usb_pipetype(urb->pipe);
-	maxp = usb_maxpacket(urb->dev, urb->pipe, !is_input);
+	ep = usb_pipe_endpoint(urb->dev, urb->pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
+	mult = usb_endpoint_maxp_mult(&ep->desc);
 
 	/* 1024 byte maxpacket is a hardware ceiling.  High bandwidth
 	 * acts like up to 3KB, but is built from smaller packets.
 	 */
-	if (max_packet(maxp) > 1024) {
-		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n",
-				max_packet(maxp));
+	if (maxp > 1024) {
+		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n", maxp);
 		goto done;
 	}
 
@@ -2778,8 +2776,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 	 */
 	if (type == PIPE_INTERRUPT) {
 		qh->usecs = NS_TO_US(usb_calc_bus_time(USB_SPEED_HIGH,
-				is_input, 0,
-				hb_mult(maxp) * max_packet(maxp)));
+				is_input, 0, mult * maxp));
 		qh->start = NO_FRAME;
 
 		if (urb->dev->speed == USB_SPEED_HIGH) {
@@ -2816,7 +2813,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			think_time = tt ? tt->think_time : 0;
 			qh->tt_usecs = NS_TO_US(think_time +
 					usb_calc_bus_time(urb->dev->speed,
-					is_input, 0, max_packet(maxp)));
+					is_input, 0, maxp));
 			qh->period = urb->interval;
 			if (qh->period > fotg210->periodic_size) {
 				qh->period = fotg210->periodic_size;
@@ -2879,11 +2876,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			 * to help them do so.  So now people expect to use
 			 * such nonconformant devices with Linux too; sigh.
 			 */
-			info1 |= max_packet(maxp) << 16;
+			info1 |= maxp << 16;
 			info2 |= (FOTG210_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
-			info1 |= max_packet(maxp) << 16;
-			info2 |= hb_mult(maxp) << 30;
+			info1 |= maxp << 16;
+			info2 |= mult << 30;
 		}
 		break;
 	default:
@@ -3953,6 +3950,7 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	int is_input;
 	long bandwidth;
 	unsigned multi;
+	struct usb_host_endpoint *ep;
 
 	/*
 	 * this might be a "high bandwidth" highspeed endpoint,
@@ -3960,14 +3958,14 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	 */
 	epnum = usb_pipeendpoint(pipe);
 	is_input = usb_pipein(pipe) ? USB_DIR_IN : 0;
-	maxp = usb_maxpacket(dev, pipe, !is_input);
+	ep = usb_pipe_endpoint(dev, pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
 	if (is_input)
 		buf1 = (1 << 11);
 	else
 		buf1 = 0;
 
-	maxp = max_packet(maxp);
-	multi = hb_mult(maxp);
+	multi = usb_endpoint_maxp_mult(&ep->desc);
 	buf1 |= maxp;
 	maxp *= multi;
 
@@ -4489,13 +4487,12 @@ static bool itd_complete(struct fotg210_hcd *fotg210, struct fotg210_itd *itd)
 
 			/* HC need not update length with this error */
 			if (!(t & FOTG210_ISOC_BABBLE)) {
-				desc->actual_length =
-					fotg210_itdlen(urb, desc, t);
+				desc->actual_length = FOTG210_ITD_LENGTH(t);
 				urb->actual_length += desc->actual_length;
 			}
 		} else if (likely((t & FOTG210_ISOC_ACTIVE) == 0)) {
 			desc->status = 0;
-			desc->actual_length = fotg210_itdlen(urb, desc, t);
+			desc->actual_length = FOTG210_ITD_LENGTH(t);
 			urb->actual_length += desc->actual_length;
 		} else {
 			/* URB was too late */
diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index 7fcd785c7bc8..0f1da9503bc6 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -683,11 +683,6 @@ static inline unsigned fotg210_read_frame_index(struct fotg210_hcd *fotg210)
 	return fotg210_readl(fotg210, &fotg210->regs->frame_index);
 }
 
-#define fotg210_itdlen(urb, desc, t) ({			\
-	usb_pipein((urb)->pipe) ?				\
-	(desc)->length - FOTG210_ITD_LENGTH(t) :			\
-	FOTG210_ITD_LENGTH(t);					\
-})
 /*-------------------------------------------------------------------------*/
 
 #endif /* __LINUX_FOTG210_H */
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 16d081a093bb..0cf4b6dc8972 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -202,6 +202,9 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (!cell)
 		return -EINVAL;
 
+	if (irq < 0)
+		return irq;
+
 	hcd = usb_create_hcd(&ohci_tmio_hc_driver, &dev->dev, dev_name(&dev->dev));
 	if (!hcd) {
 		ret = -ENOMEM;
diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 08eea4c402ee..9b6de7f083c0 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -152,6 +152,13 @@ static int xhci_rcar_download_firmware(struct usb_hcd *hcd)
 	const struct soc_device_attribute *attr;
 	const char *firmware_name;
 
+	/*
+	 * According to the datasheet, "Upon the completion of FW Download,
+	 * there is no need to write or reload FW".
+	 */
+	if (readl(regs + RCAR_USB3_DL_CTRL) & RCAR_USB3_DL_CTRL_FW_SUCCESS)
+		return 0;
+
 	attr = soc_device_match(rcar_quirks_match);
 	if (attr)
 		quirks = (uintptr_t)attr->data;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3cab64f2e861..e4a82da434c2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4400,19 +4400,19 @@ static u16 xhci_calculate_u1_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
-	else
-		timeout_ns = udev->u1_params.sel;
-
 	/* Prevent U1 if service interval is shorter than U1 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u1_params.mel) {
 			dev_dbg(&udev->dev, "Disable U1, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
+	else
+		timeout_ns = udev->u1_params.sel;
+
 	/* The U1 timeout is encoded in 1us intervals.
 	 * Don't return a timeout of zero, because that's USB3_LPM_DISABLED.
 	 */
@@ -4464,19 +4464,19 @@ static u16 xhci_calculate_u2_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
-	else
-		timeout_ns = udev->u2_params.sel;
-
 	/* Prevent U2 if service interval is shorter than U2 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u2_params.mel) {
 			dev_dbg(&udev->dev, "Disable U2, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
+	else
+		timeout_ns = udev->u2_params.sel;
+
 	/* The U2 timeout is encoded in 256us intervals */
 	timeout_ns = DIV_ROUND_UP_ULL(timeout_ns, 256 * 1000);
 	/* If the necessary timeout value is bigger than what we can set in the
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index b7d460adaa61..a582c3847dc2 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -930,23 +930,22 @@ static int dsps_probe(struct platform_device *pdev)
 	if (!glue->usbss_base)
 		return -ENXIO;
 
-	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
-		ret = dsps_setup_optional_vbus_irq(pdev, glue);
-		if (ret)
-			goto err_iounmap;
-	}
-
 	platform_set_drvdata(pdev, glue);
 	pm_runtime_enable(&pdev->dev);
 	ret = dsps_create_musb_pdev(glue, pdev);
 	if (ret)
 		goto err;
 
+	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
+		ret = dsps_setup_optional_vbus_irq(pdev, glue);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
 	pm_runtime_disable(&pdev->dev);
-err_iounmap:
 	iounmap(glue->usbss_base);
 	return ret;
 }
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index 9b4354a00ca7..968900c36451 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -886,6 +886,8 @@ int usb_otg_start(struct platform_device *pdev)
 
 	/* request irq */
 	p_otg->irq = platform_get_irq(pdev, 0);
+	if (p_otg->irq < 0)
+		return p_otg->irq;
 	status = request_irq(p_otg->irq, fsl_otg_isr,
 				IRQF_SHARED, driver_name, p_otg);
 	if (status) {
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index 1ec00eae339a..e4fc73bf6ee9 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -404,7 +404,9 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, tu);
 
-	tu->irq = platform_get_irq(pdev, 0);
+	tu->irq = ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
 	ret = request_threaded_irq(tu->irq, NULL, tahvo_usb_vbus_interrupt,
 				   IRQF_ONESHOT,
 				   "tahvo-vbus", tu);
diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 8e14fa221191..4884c4238b7b 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -355,6 +355,11 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->linkstat		= MUSB_UNKNOWN;
 
+	if (twl->irq1 < 0)
+		return twl->irq1;
+	if (twl->irq2 < 0)
+		return twl->irq2;
+
 	twl->comparator.set_vbus	= twl6030_set_vbus;
 	twl->comparator.start_srp	= twl6030_start_srp;
 
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index b36de65a0e12..1d3a94590712 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -229,8 +229,10 @@ static int read_mos_reg(struct usb_serial *serial, unsigned int serial_portnum,
 	int status;
 
 	buf = kmalloc(1, GFP_KERNEL);
-	if (!buf)
+	if (!buf) {
+		*data = 0;
 		return -ENOMEM;
+	}
 
 	status = usb_control_msg(usbdev, pipe, request, requesttype, value,
 				     index, buf, 1, MOS_WDR_TIMEOUT);
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 9833f307d70e..22e8cda7a137 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -469,8 +469,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			vhci_hcd->port_status[rhport] &= ~(1 << USB_PORT_FEAT_RESET);
 			vhci_hcd->re_timeout = 0;
 
+			/*
+			 * A few drivers do usb reset during probe when
+			 * the device could be in VDEV_ST_USED state
+			 */
 			if (vhci_hcd->vdev[rhport].ud.status ==
-			    VDEV_ST_NOTASSIGNED) {
+				VDEV_ST_NOTASSIGNED ||
+			    vhci_hcd->vdev[rhport].ud.status ==
+				VDEV_ST_USED) {
 				usbip_dbg_vhci_rh(
 					" enable rhport %d (status %u)\n",
 					rhport,
@@ -971,8 +977,32 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		struct urb *urb;
+
+		/* give back urb of unsent unlink request */
 		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		usb_hcd_unlink_urb_from_ep(hcd, urb);
+
 		list_del(&unlink->list);
+
+		spin_unlock(&vdev->priv_lock);
+		spin_unlock_irqrestore(&vhci->lock, flags);
+
+		usb_hcd_giveback_urb(hcd, urb, urb->status);
+
+		spin_lock_irqsave(&vhci->lock, flags);
+		spin_lock(&vdev->priv_lock);
+
 		kfree(unlink);
 	}
 
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index c84333eb5eb5..b7765271d0fb 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -29,7 +29,7 @@ menuconfig VFIO
 
 	  If you don't know what to do here, say N.
 
-menuconfig VFIO_NOIOMMU
+config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	depends on VFIO
 	help
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 2a0ce0c68302..67497a46d078 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -199,6 +199,33 @@ static int pwm_backlight_parse_dt(struct device *dev,
 static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 {
 	struct device_node *node = pb->dev->of_node;
+	bool active = true;
+
+	/*
+	 * If the enable GPIO is present, observable (either as input
+	 * or output) and off then the backlight is not currently active.
+	 * */
+	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
+		active = false;
+
+	if (!regulator_is_enabled(pb->power_supply))
+		active = false;
+
+	if (!pwm_is_enabled(pb->pwm))
+		active = false;
+
+	/*
+	 * Synchronize the enable_gpio with the observed state of the
+	 * hardware.
+	 */
+	if (pb->enable_gpio)
+		gpiod_direction_output(pb->enable_gpio, active);
+
+	/*
+	 * Do not change pb->enabled here! pb->enabled essentially
+	 * tells us if we own one of the regulator's use counts and
+	 * right now we do not.
+	 */
 
 	/* Not booted with device tree or no phandle link to the node */
 	if (!node || !node->phandle)
@@ -210,20 +237,7 @@ static int pwm_backlight_initial_power_state(const struct pwm_bl_data *pb)
 	 * assume that another driver will enable the backlight at the
 	 * appropriate time. Therefore, if it is disabled, keep it so.
 	 */
-
-	/* if the enable GPIO is disabled, do not enable the backlight */
-	if (pb->enable_gpio && gpiod_get_value_cansleep(pb->enable_gpio) == 0)
-		return FB_BLANK_POWERDOWN;
-
-	/* The regulator is disabled, do not enable the backlight */
-	if (!regulator_is_enabled(pb->power_supply))
-		return FB_BLANK_POWERDOWN;
-
-	/* The PWM is disabled, keep it like this */
-	if (!pwm_is_enabled(pb->pwm))
-		return FB_BLANK_POWERDOWN;
-
-	return FB_BLANK_UNBLANK;
+	return active ? FB_BLANK_UNBLANK: FB_BLANK_POWERDOWN;
 }
 
 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -300,18 +314,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		pb->enable_gpio = gpio_to_desc(data->enable_gpio);
 	}
 
-	/*
-	 * If the GPIO is not known to be already configured as output, that
-	 * is, if gpiod_get_direction returns either 1 or -EINVAL, change the
-	 * direction to output and set the GPIO as active.
-	 * Do not force the GPIO to active when it was already output as it
-	 * could cause backlight flickering or we would enable the backlight too
-	 * early. Leave the decision of the initial backlight state for later.
-	 */
-	if (pb->enable_gpio &&
-	    gpiod_get_direction(pb->enable_gpio) != 0)
-		gpiod_direction_output(pb->enable_gpio, 1);
-
 	pb->power_supply = devm_regulator_get(&pdev->dev, "power");
 	if (IS_ERR(pb->power_supply)) {
 		ret = PTR_ERR(pb->power_supply);
diff --git a/drivers/video/fbdev/asiliantfb.c b/drivers/video/fbdev/asiliantfb.c
index ea31054a28ca..c1d6e6336225 100644
--- a/drivers/video/fbdev/asiliantfb.c
+++ b/drivers/video/fbdev/asiliantfb.c
@@ -227,6 +227,9 @@ static int asiliantfb_check_var(struct fb_var_screeninfo *var,
 {
 	unsigned long Ftarget, ratio, remainder;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ratio = 1000000 / var->pixclock;
 	remainder = 1000000 % var->pixclock;
 	Ftarget = 1000000 * ratio + (1000000 * remainder) / var->pixclock;
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 4938ca1f4b63..9087d467cc46 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -34,6 +34,7 @@
 #include <linux/fb.h>
 #include <linux/fbcon.h>
 #include <linux/mem_encrypt.h>
+#include <linux/overflow.h>
 
 #include <asm/fb.h>
 
@@ -983,6 +984,7 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
 	    memcmp(&info->var, var, sizeof(struct fb_var_screeninfo))) {
 		u32 activate = var->activate;
+		u32 unused;
 
 		/* When using FOURCC mode, make sure the red, green, blue and
 		 * transp fields are set to 0.
@@ -1007,6 +1009,11 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 		if (var->xres < 8 || var->yres < 8)
 			return -EINVAL;
 
+		/* Too huge resolution causes multiplication overflow. */
+		if (check_mul_overflow(var->xres, var->yres, &unused) ||
+		    check_mul_overflow(var->xres_virtual, var->yres_virtual, &unused))
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)
diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index a7bd9f25911b..74bf26b527b9 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -372,6 +372,11 @@ static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight
 		/* probably haven't called CreateOverlay yet */
 		return -EINVAL;
 
+	if (ulWidth == 0 || ulWidth == 0xffffffff ||
+	    ulHeight == 0 || ulHeight == 0xffffffff ||
+	    (x < 2 && ulWidth + 2 == 0))
+		return -EINVAL;
+
 	/* Stop Ramdac Output */
 	DisableRamdacOutput(deviceInfo.pSTGReg);
 
@@ -394,6 +399,9 @@ static int kyrofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct kyrofb_info *par = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->bits_per_pixel != 16 && var->bits_per_pixel != 32) {
 		printk(KERN_WARNING "kyrofb: depth not supported: %u\n", var->bits_per_pixel);
 		return -EINVAL;
diff --git a/drivers/video/fbdev/riva/fbdev.c b/drivers/video/fbdev/riva/fbdev.c
index 1ea78bb911fb..c080d14f9d2a 100644
--- a/drivers/video/fbdev/riva/fbdev.c
+++ b/drivers/video/fbdev/riva/fbdev.c
@@ -1088,6 +1088,9 @@ static int rivafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	int mode_valid = 0;
 	
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 1 ... 8:
 		var->red.offset = var->green.offset = var->blue.offset = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 275a89b8e4b8..692d0d71e8c5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -540,7 +540,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(inode, start, end)) {
+	if (inode_need_compress(inode, start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9986817532b1..7932e20555d2 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -371,14 +371,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
 		if (!dst)
 			return NULL;
 		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
-			       NO_MAP_UNI_RSVD);
+				NO_MAP_UNI_RSVD);
 	} else {
-		len = strnlen(src, maxlen);
-		len++;
-		dst = kmalloc(len, GFP_KERNEL);
-		if (!dst)
-			return NULL;
-		strlcpy(dst, src, len);
+		dst = kstrndup(src, maxlen, GFP_KERNEL);
 	}
 
 	return dst;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index aa23c00367ec..0113dba28eb0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -602,7 +602,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 89a4ac83cbcd..034b5d0a0504 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -756,6 +756,12 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	ext4_write_lock_xattr(inode, &no_expand);
 	BUG_ON(!ext4_has_inline_data(inode));
 
+	/*
+	 * ei->i_inline_off may have changed since ext4_write_begin()
+	 * called ext4_try_to_write_inline_data()
+	 */
+	(void) ext4_find_inline_data_nolock(inode);
+
 	kaddr = kmap_atomic(page);
 	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
 	kunmap_atomic(kaddr);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2cd0d126ef8f..4307f8db6c8f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3337,14 +3337,17 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			} else {
 				memcpy(se->discard_map, se->cur_valid_map,
 							SIT_VBLOCK_MAP_SIZE);
-				sbi->discard_blks += old_valid_blocks -
-							se->valid_blocks;
+				sbi->discard_blks += old_valid_blocks;
+				sbi->discard_blks -= se->valid_blocks;
 			}
 		}
 
-		if (sbi->segs_per_sec > 1)
+		if (sbi->segs_per_sec > 1) {
 			get_sec_entry(sbi, start)->valid_blocks +=
-				se->valid_blocks - old_valid_blocks;
+							se->valid_blocks;
+			get_sec_entry(sbi, start)->valid_blocks -=
+							old_valid_blocks;
+		}
 	}
 	up_read(&curseg->journal_rwsem);
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index de733a6c30bb..f3c16a504c8d 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -295,6 +295,11 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
+	/* don't want to call dlm if we've unmounted the lock protocol */
+	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
+		gfs2_glock_free(gl);
+		return;
+	}
 	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a4994e25e19e..f1134752cea3 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -157,7 +157,6 @@ struct iso9660_options{
 	unsigned int overriderockperm:1;
 	unsigned int uid_set:1;
 	unsigned int gid_set:1;
-	unsigned int utf8:1;
 	unsigned char map;
 	unsigned char check;
 	unsigned int blocksize;
@@ -357,7 +356,6 @@ static int parse_options(char *options, struct iso9660_options *popt)
 	popt->gid = GLOBAL_ROOT_GID;
 	popt->uid = GLOBAL_ROOT_UID;
 	popt->iocharset = NULL;
-	popt->utf8 = 0;
 	popt->overriderockperm = 0;
 	popt->session=-1;
 	popt->sbsector=-1;
@@ -390,10 +388,13 @@ static int parse_options(char *options, struct iso9660_options *popt)
 		case Opt_cruft:
 			popt->cruft = 1;
 			break;
+#ifdef CONFIG_JOLIET
 		case Opt_utf8:
-			popt->utf8 = 1;
+			kfree(popt->iocharset);
+			popt->iocharset = kstrdup("utf8", GFP_KERNEL);
+			if (!popt->iocharset)
+				return 0;
 			break;
-#ifdef CONFIG_JOLIET
 		case Opt_iocharset:
 			kfree(popt->iocharset);
 			popt->iocharset = match_strdup(&args[0]);
@@ -496,7 +497,6 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 	if (sbi->s_nocompress)		seq_puts(m, ",nocompress");
 	if (sbi->s_overriderockperm)	seq_puts(m, ",overriderockperm");
 	if (sbi->s_showassoc)		seq_puts(m, ",showassoc");
-	if (sbi->s_utf8)		seq_puts(m, ",utf8");
 
 	if (sbi->s_check)		seq_printf(m, ",check=%c", sbi->s_check);
 	if (sbi->s_mapping)		seq_printf(m, ",map=%c", sbi->s_mapping);
@@ -519,9 +519,10 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",fmode=%o", sbi->s_fmode);
 
 #ifdef CONFIG_JOLIET
-	if (sbi->s_nls_iocharset &&
-	    strcmp(sbi->s_nls_iocharset->charset, CONFIG_NLS_DEFAULT) != 0)
+	if (sbi->s_nls_iocharset)
 		seq_printf(m, ",iocharset=%s", sbi->s_nls_iocharset->charset);
+	else
+		seq_puts(m, ",iocharset=utf8");
 #endif
 	return 0;
 }
@@ -865,14 +866,13 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	sbi->s_nls_iocharset = NULL;
 
 #ifdef CONFIG_JOLIET
-	if (joliet_level && opt.utf8 == 0) {
+	if (joliet_level) {
 		char *p = opt.iocharset ? opt.iocharset : CONFIG_NLS_DEFAULT;
-		sbi->s_nls_iocharset = load_nls(p);
-		if (! sbi->s_nls_iocharset) {
-			/* Fail only if explicit charset specified */
-			if (opt.iocharset)
+		if (strcmp(p, "utf8") != 0) {
+			sbi->s_nls_iocharset = opt.iocharset ?
+				load_nls(opt.iocharset) : load_nls_default();
+			if (!sbi->s_nls_iocharset)
 				goto out_freesbi;
-			sbi->s_nls_iocharset = load_nls_default();
 		}
 	}
 #endif
@@ -888,7 +888,6 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	sbi->s_gid = opt.gid;
 	sbi->s_uid_set = opt.uid_set;
 	sbi->s_gid_set = opt.gid_set;
-	sbi->s_utf8 = opt.utf8;
 	sbi->s_nocompress = opt.nocompress;
 	sbi->s_overriderockperm = opt.overriderockperm;
 	/*
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 8e42b4fbefdc..b4b9d4861c9d 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -44,7 +44,6 @@ struct isofs_sb_info {
 	unsigned char s_session;
 	unsigned int  s_high_sierra:1;
 	unsigned int  s_rock:2;
-	unsigned int  s_utf8:1;
 	unsigned int  s_cruft:1; /* Broken disks with high byte of length
 				  * containing junk */
 	unsigned int  s_nocompress:1;
diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index be8b6a9d0b92..c0f04a1e7f69 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -41,14 +41,12 @@ uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
 int
 get_joliet_filename(struct iso_directory_record * de, unsigned char *outname, struct inode * inode)
 {
-	unsigned char utf8;
 	struct nls_table *nls;
 	unsigned char len = 0;
 
-	utf8 = ISOFS_SB(inode->i_sb)->s_utf8;
 	nls = ISOFS_SB(inode->i_sb)->s_nls_iocharset;
 
-	if (utf8) {
+	if (!nls) {
 		len = utf16s_to_utf8s((const wchar_t *) de->name,
 				de->name_len[0] >> 1, UTF16_BIG_ENDIAN,
 				outname, PAGE_SIZE);
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 3949c4bec3a3..e5f4dcde309f 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -173,13 +173,22 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < iinfo->i_lenEAttr) {
+		while (offset + sizeof(*gaf) < iinfo->i_lenEAttr) {
+			uint32_t attrLength;
+
 			gaf = (struct genericFormat *)&ea[offset];
+			attrLength = le32_to_cpu(gaf->attrLength);
+
+			/* Detect undersized elements and buffer overflows */
+			if ((attrLength < sizeof(*gaf)) ||
+			    (attrLength > (iinfo->i_lenEAttr - offset)))
+				break;
+
 			if (le32_to_cpu(gaf->attrType) == type &&
 					gaf->attrSubtype == subtype)
 				return gaf;
 			else
-				offset += le32_to_cpu(gaf->attrLength);
+				offset += attrLength;
 		}
 	}
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 2b8147ecd97f..70b56011b823 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -113,16 +113,10 @@ struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_block *sb)
 		return NULL;
 	lvid = (struct logicalVolIntegrityDesc *)UDF_SB(sb)->s_lvid_bh->b_data;
 	partnum = le32_to_cpu(lvid->numOfPartitions);
-	if ((sb->s_blocksize - sizeof(struct logicalVolIntegrityDescImpUse) -
-	     offsetof(struct logicalVolIntegrityDesc, impUse)) /
-	     (2 * sizeof(uint32_t)) < partnum) {
-		udf_err(sb, "Logical volume integrity descriptor corrupted "
-			"(numOfPartitions = %u)!\n", partnum);
-		return NULL;
-	}
 	/* The offset is to skip freeSpaceTable and sizeTable arrays */
 	offset = partnum * 2 * sizeof(uint32_t);
-	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
+	return (struct logicalVolIntegrityDescImpUse *)
+					(((uint8_t *)(lvid + 1)) + offset);
 }
 
 /* UDF filesystem type */
@@ -1565,6 +1559,7 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
+	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1591,15 +1586,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 
 		lvid = (struct logicalVolIntegrityDesc *)final_bh->b_data;
 		if (lvid->nextIntegrityExt.extLength == 0)
-			return;
+			goto check;
 
 		loc = leea_to_cpu(lvid->nextIntegrityExt);
 	}
 
 	udf_warn(sb, "Too many LVID indirections (max %u), ignoring.\n",
 		UDF_MAX_LVID_NESTING);
+out_err:
 	brelse(sbi->s_lvid_bh);
 	sbi->s_lvid_bh = NULL;
+	return;
+check:
+	parts = le32_to_cpu(lvid->numOfPartitions);
+	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
+	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
+	    2 * parts * sizeof(u32) > sb->s_blocksize) {
+		udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
+			 "ignoring.\n", parts, impuselen);
+		goto out_err;
+	}
 }
 
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index e0b681a717ba..052e26fda2e6 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -35,9 +35,9 @@ extern void public_key_free(struct public_key *key);
 struct public_key_signature {
 	struct asymmetric_key_id *auth_ids[2];
 	u8 *s;			/* Signature */
-	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;		/* Number of bytes in digest */
+	u32 s_size;		/* Number of bytes in signature */
+	u32 digest_size;	/* Number of bytes in digest */
 	const char *pkey_algo;
 	const char *hash_algo;
 };
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d2b5cc8ce54f..26dddc03b35c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -503,6 +503,11 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->hugetlb_usage, 0);
+}
+
 static inline void hugetlb_count_add(long l, struct mm_struct *mm)
 {
 	atomic_long_add(l, &mm->hugetlb_usage);
@@ -583,6 +588,10 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 	return &mm->page_table_lock;
 }
 
+static inline void hugetlb_count_init(struct mm_struct *mm)
+{
+}
+
 static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
 {
 }
diff --git a/include/linux/list.h b/include/linux/list.h
index de04cc5ed536..d2c12ef7a4e3 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -484,6 +484,15 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos != (head); \
 	     pos = n, n = pos->prev)
 
+/**
+ * list_entry_is_head - test if the entry points to the head of the list
+ * @pos:	the type * to cursor
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_entry_is_head(pos, head, member)				\
+	(&pos->member == (head))
+
 /**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
@@ -492,7 +501,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_first_entry(head, typeof(*pos), member);	\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -503,7 +512,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_last_entry(head, typeof(*pos), member);		\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -528,7 +537,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
 	for (pos = list_next_entry(pos, member);			\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -542,7 +551,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
 	for (pos = list_prev_entry(pos, member);			\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -554,7 +563,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);					\
+	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -567,7 +576,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Iterate backwards over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from_reverse(pos, head, member)		\
-	for (; &pos->member != (head);					\
+	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -580,7 +589,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
 		n = list_next_entry(pos, member);			\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -596,7 +605,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
 	for (pos = list_next_entry(pos, member), 				\
 		n = list_next_entry(pos, member);				\
-	     &pos->member != (head);						\
+	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -611,7 +620,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
 	for (n = list_next_entry(pos, member);					\
-	     &pos->member != (head);						\
+	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -627,7 +636,7 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_last_entry(head, typeof(*pos), member),		\
 		n = list_prev_entry(pos, member);			\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_prev_entry(n, member))
 
 /**
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d36a02935391..8c48d9e0ca22 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -332,6 +332,6 @@ extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages,
 		int online_type);
-extern struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages);
+extern struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages);
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59f4d10568c6..66c0d5fad0cb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1633,8 +1633,9 @@ static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_assign_resource(struct pci_dev *dev, int i)
 { return -EBUSY; }
-static inline int __pci_register_driver(struct pci_driver *drv,
-					struct module *owner)
+static inline int __must_check __pci_register_driver(struct pci_driver *drv,
+						     struct module *owner,
+						     const char *mod_name)
 { return 0; }
 static inline int pci_register_driver(struct pci_driver *drv)
 { return 0; }
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index a7ed29baf44a..86e5ad8aeee4 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -82,7 +82,7 @@ enum max17042_register {
 	MAX17042_RelaxCFG	= 0x2A,
 	MAX17042_MiscCFG	= 0x2B,
 	MAX17042_TGAIN		= 0x2C,
-	MAx17042_TOFF		= 0x2D,
+	MAX17042_TOFF		= 0x2D,
 	MAX17042_CGAIN		= 0x2E,
 	MAX17042_COFF		= 0x2F,
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2f303454a323..33b6d3ba49a7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1758,7 +1758,7 @@ static inline void __skb_insert(struct sk_buff *newsk,
 	WRITE_ONCE(newsk->prev, prev);
 	WRITE_ONCE(next->prev, newsk);
 	WRITE_ONCE(prev->next, newsk);
-	list->qlen++;
+	WRITE_ONCE(list->qlen, list->qlen + 1);
 }
 
 static inline void __skb_queue_splice(const struct sk_buff_head *list,
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index 619fe6111dc9..a31ae32161f3 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -62,6 +62,7 @@
  * ST16C654:	 8  16  56  60		 8  16  32  56	PORT_16654
  * TI16C750:	 1  16  32  56		xx  xx  xx  xx	PORT_16750
  * TI16C752:	 8  16  56  60		 8  16  32  56
+ * OX16C950:	16  32 112 120		16  32  64 112	PORT_16C950
  * Tegra:	 1   4   8  14		16   8   4   1	PORT_TEGRA
  */
 #define UART_FCR_R_TRIG_00	0x00
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1aa094c5dedb..236e7900e3fc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8435,7 +8435,7 @@ static void perf_event_addr_filters_apply(struct perf_event *event)
 	if (!ifh->nr_file_filters)
 		return;
 
-	mm = get_task_mm(event->ctx->task);
+	mm = get_task_mm(task);
 	if (!mm)
 		goto restart;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 783eae426a86..5e44c062244f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -837,6 +837,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	hugetlb_count_init(mm);
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 22091c88b3bb..93ed69037ae9 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -55,7 +55,7 @@ static struct kmem_cache *create_pid_cachep(int nr_ids)
 	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
 	cachep = kmem_cache_create(pcache->name,
 			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
-			0, SLAB_HWCACHE_ALIGN, NULL);
+			0, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (cachep == NULL)
 		goto err_cachep;
 
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 75ebf2bbc2ee..9a8f957ad86e 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4395,8 +4395,8 @@ static struct bpf_test tests[] = {
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0),
 			BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
-			BPF_STX_MEM(BPF_W, R10, R1, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
 			BPF_EXIT_INSN(),
 		},
 		INTERNAL,
@@ -6306,7 +6306,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 		u64 duration;
 		u32 ret;
 
-		if (test->test[i].data_size == 0 &&
+		/*
+		 * NOTE: Several sub-tests may be present, in which case
+		 * a zero {data_size, result} tuple indicates the end of
+		 * the sub-test array. The first test is always run,
+		 * even if both data_size and result happen to be zero.
+		 */
+		if (i > 0 &&
+		    test->test[i].data_size == 0 &&
 		    test->test[i].result == 0)
 			break;
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 706f705c2e0a..0b842160168b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1520,7 +1520,7 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+			if (!(pfn & 63))
 				cond_resched();
 		}
 	}
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2d6626ab29d1..c2878d48b8b1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -842,8 +842,8 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone * zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
-		unsigned long nr_pages)
+struct zone *zone_for_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (online_type == MMOP_ONLINE_KERNEL)
 		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7183807d494f..9c467ac4b72d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -815,7 +815,7 @@ static inline void __free_one_page(struct page *page,
 	struct page *buddy;
 	unsigned int max_order;
 
-	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
+	max_order = min_t(unsigned int, MAX_ORDER - 1, pageblock_order);
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
@@ -828,7 +828,7 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 continue_merging:
-	while (order < max_order - 1) {
+	while (order < max_order) {
 		buddy_pfn = __find_buddy_pfn(pfn, order);
 		buddy = page + (buddy_pfn - pfn);
 
@@ -852,7 +852,7 @@ static inline void __free_one_page(struct page *page,
 		pfn = combined_pfn;
 		order++;
 	}
-	if (max_order < MAX_ORDER) {
+	if (order < MAX_ORDER - 1) {
 		/* If we are here, it means order is >= pageblock_order.
 		 * We want to prevent merge between freepages on isolate
 		 * pageblock and normal pageblock. Without this, pageblock
@@ -873,7 +873,7 @@ static inline void __free_one_page(struct page *page,
 						is_migrate_isolate(buddy_mt)))
 				goto done_merging;
 		}
-		max_order++;
+		max_order = order + 1;
 		goto continue_merging;
 	}
 
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index ea9f1773abc8..da843b68cdeb 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -139,7 +139,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
 
 static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 {
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv;
 	RING_IDX cons, prod, masked_cons, masked_prod;
 	unsigned long flags;
 	u32 size = p9_req->tc->size;
@@ -152,7 +152,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
 			break;
 	}
 	read_unlock(&xen_9pfs_lock);
-	if (!priv || priv->client != client)
+	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
 		return -EINVAL;
 
 	num = p9_req->tc->tag % priv->num_rings;
diff --git a/net/bluetooth/cmtp/cmtp.h b/net/bluetooth/cmtp/cmtp.h
index c32638dddbf9..f6b9dc4e408f 100644
--- a/net/bluetooth/cmtp/cmtp.h
+++ b/net/bluetooth/cmtp/cmtp.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
-#define BTNAMSIZ 18
+#define BTNAMSIZ 21
 
 /* CMTP ioctl defines */
 #define CMTPCONNADD	_IOW('C', 200, int)
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3b2dd98e9fd6..1906adfd553a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1258,6 +1258,12 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	/* Restrict maximum inquiry length to 60 seconds */
+	if (ir.length > 60) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
@@ -1582,6 +1588,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b3253f2e11af..5186f199d892 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3761,6 +3761,21 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 
 	switch (ev->status) {
 	case 0x00:
+		/* The synchronous connection complete event should only be
+		 * sent once per new connection. Receiving a successful
+		 * complete event when the connection status is already
+		 * BT_CONNECTED means that the device is misbehaving and sent
+		 * multiple complete event packets for the same new connection.
+		 *
+		 * Registering the device more than once can corrupt kernel
+		 * memory, hence upon detecting this invalid event, we report
+		 * an error and ignore the packet.
+		 */
+		if (conn->state == BT_CONNECTED) {
+			bt_dev_err(hdev, "Ignoring connect complete event for existing connection");
+			goto unlock;
+		}
+
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 2d23b29ce00d..f681e7ce8945 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -84,7 +84,6 @@ static void sco_sock_timeout(unsigned long arg)
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
 
-	sco_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -176,7 +175,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 	}
 
@@ -211,44 +209,32 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	return err;
 }
 
-static int sco_connect(struct sock *sk)
+static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 {
 	struct sco_conn *conn;
 	struct hci_conn *hcon;
-	struct hci_dev  *hdev;
 	int err, type;
 
 	BT_DBG("%pMR -> %pMR", &sco_pi(sk)->src, &sco_pi(sk)->dst);
 
-	hdev = hci_get_route(&sco_pi(sk)->dst, &sco_pi(sk)->src, BDADDR_BREDR);
-	if (!hdev)
-		return -EHOSTUNREACH;
-
-	hci_dev_lock(hdev);
-
 	if (lmp_esco_capable(hdev) && !disable_esco)
 		type = ESCO_LINK;
 	else
 		type = SCO_LINK;
 
 	if (sco_pi(sk)->setting == BT_VOICE_TRANSPARENT &&
-	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev))) {
-		err = -EOPNOTSUPP;
-		goto done;
-	}
+	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev)))
+		return -EOPNOTSUPP;
 
 	hcon = hci_connect_sco(hdev, type, &sco_pi(sk)->dst,
 			       sco_pi(sk)->setting);
-	if (IS_ERR(hcon)) {
-		err = PTR_ERR(hcon);
-		goto done;
-	}
+	if (IS_ERR(hcon))
+		return PTR_ERR(hcon);
 
 	conn = sco_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
-		err = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
 	/* Update source addr of the socket */
@@ -256,7 +242,7 @@ static int sco_connect(struct sock *sk)
 
 	err = sco_chan_add(conn, sk, NULL);
 	if (err)
-		goto done;
+		return err;
 
 	if (hcon->state == BT_CONNECTED) {
 		sco_sock_clear_timer(sk);
@@ -266,9 +252,6 @@ static int sco_connect(struct sock *sk)
 		sco_sock_set_timer(sk, sk->sk_sndtimeo);
 	}
 
-done:
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
 	return err;
 }
 
@@ -393,8 +376,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -446,7 +428,6 @@ static void sco_sock_close(struct sock *sk)
 	lock_sock(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_sock_init(struct sock *sk, struct sock *parent)
@@ -554,6 +535,7 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 {
 	struct sockaddr_sco *sa = (struct sockaddr_sco *) addr;
 	struct sock *sk = sock->sk;
+	struct hci_dev  *hdev;
 	int err;
 
 	BT_DBG("sk %p", sk);
@@ -568,12 +550,19 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	if (sk->sk_type != SOCK_SEQPACKET)
 		return -EINVAL;
 
+	hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
+	if (!hdev)
+		return -EHOSTUNREACH;
+	hci_dev_lock(hdev);
+
 	lock_sock(sk);
 
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 
-	err = sco_connect(sk);
+	err = sco_connect(hdev, sk);
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 	if (err)
 		goto done;
 
@@ -762,6 +751,11 @@ static void sco_conn_defer_accept(struct hci_conn *conn, u16 setting)
 			cp.max_latency = cpu_to_le16(0xffff);
 			cp.retrans_effort = 0xff;
 			break;
+		default:
+			/* use CVSD settings as fallback */
+			cp.max_latency = cpu_to_le16(0xffff);
+			cp.retrans_effort = 0xff;
+			break;
 		}
 
 		hci_send_cmd(hdev, HCI_OP_ACCEPT_SYNC_CONN_REQ,
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 922ac1d605b3..7f0d20b69289 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -54,20 +54,6 @@ struct chnl_net {
 	enum caif_states state;
 };
 
-static void robust_list_del(struct list_head *delete_node)
-{
-	struct list_head *list_node;
-	struct list_head *n;
-	ASSERT_RTNL();
-	list_for_each_safe(list_node, n, &chnl_net_list) {
-		if (list_node == delete_node) {
-			list_del(list_node);
-			return;
-		}
-	}
-	WARN_ON(1);
-}
-
 static int chnl_recv_cb(struct cflayer *layr, struct cfpkt *pkt)
 {
 	struct sk_buff *skb;
@@ -369,6 +355,7 @@ static int chnl_net_init(struct net_device *dev)
 	ASSERT_RTNL();
 	priv = netdev_priv(dev);
 	strncpy(priv->name, dev->name, sizeof(priv->name));
+	INIT_LIST_HEAD(&priv->list_field);
 	return 0;
 }
 
@@ -377,7 +364,7 @@ static void chnl_net_uninit(struct net_device *dev)
 	struct chnl_net *priv;
 	ASSERT_RTNL();
 	priv = netdev_priv(dev);
-	robust_list_del(&priv->list_field);
+	list_del_init(&priv->list_field);
 }
 
 static const struct net_device_ops netdev_ops = {
@@ -542,7 +529,7 @@ static void __exit chnl_exit_module(void)
 	rtnl_lock();
 	list_for_each_safe(list_node, _tmp, &chnl_net_list) {
 		dev = list_entry(list_node, struct chnl_net, list_field);
-		list_del(list_node);
+		list_del_init(list_node);
 		delete_device(dev);
 	}
 	rtnl_unlock();
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 071de3013364..b4dddb685fc2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -514,8 +514,10 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
 							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v4addrs, &iph->saddr,
-			       sizeof(key_addrs->v4addrs));
+			memcpy(&key_addrs->v4addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v4addrs.src));
+			memcpy(&key_addrs->v4addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v4addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
@@ -564,8 +566,10 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
 							      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v6addrs, &iph->saddr,
-			       sizeof(key_addrs->v6addrs));
+			memcpy(&key_addrs->v6addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v6addrs.src));
+			memcpy(&key_addrs->v6addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v6addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		}
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 1af25d53f63c..37f4313e82d2 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -181,9 +181,9 @@ static int net_eq_idr(int id, void *net, void *peer)
 	return 0;
 }
 
-/* Should be called with nsid_lock held. If a new id is assigned, the bool alloc
- * is set to true, thus the caller knows that the new id must be notified via
- * rtnl.
+/* Must be called from RCU-critical section or with nsid_lock held. If
+ * a new id is assigned, the bool alloc is set to true, thus the
+ * caller knows that the new id must be notified via rtnl.
  */
 static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 {
@@ -207,7 +207,7 @@ static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 	return NETNSA_NSID_NOT_ASSIGNED;
 }
 
-/* should be called with nsid_lock held */
+/* Must be called from RCU-critical section or with nsid_lock held */
 static int __peernet2id(struct net *net, struct net *peer)
 {
 	bool no = false;
@@ -240,9 +240,10 @@ int peernet2id(struct net *net, struct net *peer)
 {
 	int id;
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	id = __peernet2id(net, peer);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
+
 	return id;
 }
 EXPORT_SYMBOL(peernet2id);
@@ -761,6 +762,7 @@ struct rtnl_net_dump_cb {
 	int s_idx;
 };
 
+/* Runs in RCU-critical section. */
 static int rtnl_net_dumpid_one(int id, void *peer, void *data)
 {
 	struct rtnl_net_dump_cb *net_cb = (struct rtnl_net_dump_cb *)data;
@@ -791,9 +793,9 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 		.s_idx = cb->args[0],
 	};
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	idr_for_each(&net->netns_ids, rtnl_net_dumpid_one, &net_cb);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
 
 	cb->args[0] = net_cb.idx;
 	return skb->len;
diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 178bb9833311..f6092536de03 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -98,6 +98,8 @@ struct sock *dccp_create_openreq_child(const struct sock *sk,
 		newdp->dccps_role	    = DCCP_ROLE_SERVER;
 		newdp->dccps_hc_rx_ackvec   = NULL;
 		newdp->dccps_service_list   = NULL;
+		newdp->dccps_hc_rx_ccid     = NULL;
+		newdp->dccps_hc_tx_ccid     = NULL;
 		newdp->dccps_service	    = dreq->dreq_service;
 		newdp->dccps_timestamp_echo = dreq->dreq_timestamp_echo;
 		newdp->dccps_timestamp_time = dreq->dreq_timestamp_time;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index ba07f128d7ad..dc99b40da48d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -468,6 +468,23 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	local_bh_enable();
 }
 
+/*
+ * The device used for looking up which routing table to use for sending an ICMP
+ * error is preferably the source whenever it is set, which should ensure the
+ * icmp error can be sent to the source host, else lookup using the routing
+ * table of the destination device, else use the main routing table (index 0).
+ */
+static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
+{
+	struct net_device *route_lookup_dev = NULL;
+
+	if (skb->dev)
+		route_lookup_dev = skb->dev;
+	else if (skb_dst(skb))
+		route_lookup_dev = skb_dst(skb)->dev;
+	return route_lookup_dev;
+}
+
 static struct rtable *icmp_route_lookup(struct net *net,
 					struct flowi4 *fl4,
 					struct sk_buff *skb_in,
@@ -476,6 +493,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 					int type, int code,
 					struct icmp_bxm *param)
 {
+	struct net_device *route_lookup_dev;
 	struct rtable *rt, *rt2;
 	struct flowi4 fl4_dec;
 	int err;
@@ -490,7 +508,8 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
+	route_lookup_dev = icmp_get_route_lookup_dev(skb_in);
+	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
@@ -514,7 +533,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
+	if (inet_addr_type_dev_table(net, route_lookup_dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index a6b048ff30e6..eac0013809c9 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2695,6 +2695,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 		rv = 1;
 	} else if (im) {
 		if (src_addr) {
+			spin_lock_bh(&im->lock);
 			for (psf = im->sources; psf; psf = psf->sf_next) {
 				if (psf->sf_inaddr == src_addr)
 					break;
@@ -2705,6 +2706,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 					im->sfcount[MCAST_EXCLUDE];
 			else
 				rv = im->sfcount[MCAST_EXCLUDE] != 0;
+			spin_unlock_bh(&im->lock);
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 5ec185a9dcab..c9f82525bfa4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -419,8 +419,9 @@ static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 {
 	BUILD_BUG_ON(offsetof(typeof(*fl4), daddr) !=
 		     offsetof(typeof(*fl4), saddr) + sizeof(fl4->saddr));
-	memcpy(&iph->saddr, &fl4->saddr,
-	       sizeof(fl4->saddr) + sizeof(fl4->daddr));
+
+	iph->saddr = fl4->saddr;
+	iph->daddr = fl4->daddr;
 }
 
 /* Note: skb->sk can be different from sk, in case of tunnels */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 81901b052907..d67d424be919 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -619,18 +619,25 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 	}
 }
 
-static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
+static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 {
-	struct fib_nh_exception *fnhe, *oldest;
+	struct fib_nh_exception __rcu **fnhe_p, **oldest_p;
+	struct fib_nh_exception *fnhe, *oldest = NULL;
 
-	oldest = rcu_dereference(hash->chain);
-	for (fnhe = rcu_dereference(oldest->fnhe_next); fnhe;
-	     fnhe = rcu_dereference(fnhe->fnhe_next)) {
-		if (time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp))
+	for (fnhe_p = &hash->chain; ; fnhe_p = &fnhe->fnhe_next) {
+		fnhe = rcu_dereference_protected(*fnhe_p,
+						 lockdep_is_held(&fnhe_lock));
+		if (!fnhe)
+			break;
+		if (!oldest ||
+		    time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp)) {
 			oldest = fnhe;
+			oldest_p = fnhe_p;
+		}
 	}
 	fnhe_flush_routes(oldest);
-	return oldest;
+	*oldest_p = oldest->fnhe_next;
+	kfree_rcu(oldest, rcu);
 }
 
 static inline u32 fnhe_hashfun(__be32 daddr)
@@ -707,16 +714,21 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 		if (rt)
 			fill_route_from_fnhe(rt, fnhe);
 	} else {
-		if (depth > FNHE_RECLAIM_DEPTH)
-			fnhe = fnhe_oldest(hash);
-		else {
-			fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
-			if (!fnhe)
-				goto out_unlock;
-
-			fnhe->fnhe_next = hash->chain;
-			rcu_assign_pointer(hash->chain, fnhe);
+		/* Randomize max depth to avoid some side channels attacks. */
+		int max_depth = FNHE_RECLAIM_DEPTH +
+				prandom_u32_max(FNHE_RECLAIM_DEPTH);
+
+		while (depth > max_depth) {
+			fnhe_remove_oldest(hash);
+			depth--;
 		}
+
+		fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
+		if (!fnhe)
+			goto out_unlock;
+
+		fnhe->fnhe_next = hash->chain;
+
 		fnhe->fnhe_genid = genid;
 		fnhe->fnhe_daddr = daddr;
 		fnhe->fnhe_gw = gw;
@@ -724,6 +736,8 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 		fnhe->fnhe_mtu_locked = lock;
 		fnhe->fnhe_expires = max(1UL, expires);
 
+		rcu_assign_pointer(hash->chain, fnhe);
+
 		/* Exception created; mark the cached routes for the nexthop
 		 * stale, so anyone caching it rechecks if this exception
 		 * applies to them.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eb062fab6257..9382caeb721a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1225,7 +1225,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 	if (dup_sack && (sacked & TCPCB_RETRANS)) {
 		if (tp->undo_marker && tp->undo_retrans > 0 &&
 		    after(end_seq, tp->undo_marker))
-			tp->undo_retrans--;
+			tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
 		if (sacked & TCPCB_SACKED_ACKED)
 			state->reord = min(fack_count, state->reord);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 146a137ee7ef..744479c8b91f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2087,6 +2087,7 @@ static void *tcp_get_idx(struct seq_file *seq, loff_t pos)
 static void *tcp_seek_last_pos(struct seq_file *seq)
 {
 	struct tcp_iter_state *st = seq->private;
+	int bucket = st->bucket;
 	int offset = st->offset;
 	int orig_num = st->num;
 	void *rc = NULL;
@@ -2097,7 +2098,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 			break;
 		st->state = TCP_SEQ_STATE_LISTENING;
 		rc = listening_get_next(seq, NULL);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = listening_get_next(seq, rc);
 		if (rc)
 			break;
@@ -2108,7 +2109,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 		if (st->bucket > tcp_hashinfo.ehash_mask)
 			break;
 		rc = established_get_first(seq);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket == st->bucket)
 			rc = established_get_next(seq, rc);
 	}
 
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index f14de4b6d639..58e839e2ce1d 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -104,7 +104,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 {
 	__be16 uninitialized_var(dport), uninitialized_var(sport);
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
@@ -134,8 +134,6 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 			thoff + sizeof(*hp);
 
 	} else if (tproto == IPPROTO_ICMPV6) {
-		struct ipv6hdr ipv6_var;
-
 		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
 					 &sport, &dport, &ipv6_var))
 			return NULL;
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 36512fbea130..84d5650239d9 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -994,8 +994,10 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb,
 	}
 
 	if (tunnel->version == L2TP_HDR_VER_3 &&
-	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
+	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr)) {
+		l2tp_session_dec_refcount(session);
 		goto error;
+	}
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length, payload_hook);
 	l2tp_session_dec_refcount(session);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c7e8935224c0..e7b63ba8c184 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3080,7 +3080,9 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
 		return true;
 
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(*amsdu_hdr)))
+	if (!ieee80211_amsdu_realloc_pad(local, skb,
+					 sizeof(*amsdu_hdr) +
+					 local->hw.extra_tx_headroom))
 		return false;
 
 	data = skb_push(skb, sizeof(*amsdu_hdr));
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 3e3494c8d42f..e252f62bb8c2 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -156,8 +156,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		return -ENOMEM;
 	doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
 	if (doi_def->map.std == NULL) {
-		ret_val = -ENOMEM;
-		goto add_std_failure;
+		kfree(doi_def);
+		return -ENOMEM;
 	}
 	doi_def->type = CIPSO_V4_MAP_TRANS;
 
@@ -198,14 +198,14 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 	doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.local == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
 	}
 	doi_def->map.std->lvl.cipso = kcalloc(doi_def->map.std->lvl.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.cipso == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
@@ -273,7 +273,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.local = kcalloc(
 					      doi_def->map.std->cat.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.local == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
@@ -281,7 +281,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.cipso = kcalloc(
 					      doi_def->map.std->cat.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.cipso == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 140bec3568ec..955041c54702 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2476,13 +2476,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		/* errors reported via destination sk->sk_err, but propagate
 		 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */
 		err = nlmsg_multicast(sk, skb, exclude_portid, group, flags);
+		if (err == -ESRCH)
+			err = 0;
 	}
 
 	if (report) {
 		int err2;
 
 		err2 = nlmsg_unicast(sk, skb, portid);
-		if (!err || err == -ESRCH)
+		if (!err)
 			err = err2;
 	}
 
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 40fd1ee0095c..dea125d8aac7 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1590,7 +1590,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 27dfd85830d8..4f41a1bc59bf 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1861,7 +1861,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2e4d892768f9..94e74987fe65 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1775,7 +1775,7 @@ static int tipc_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 			    u32 dport, struct sk_buff_head *xmitq)
 {
-	unsigned long time_limit = jiffies + 2;
+	unsigned long time_limit = jiffies + usecs_to_jiffies(20000);
 	struct sk_buff *skb;
 	unsigned int lim;
 	atomic_t *dcnt;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 59009739d324..f30509ff302e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2742,7 +2742,7 @@ static unsigned int unix_dgram_poll(struct file *file, struct socket *sock,
 
 		other = unix_peer(sk);
 		if (other && unix_peer(other) != sk &&
-		    unix_recvq_full(other) &&
+		    unix_recvq_full_lockless(other) &&
 		    unix_dgram_peer_wake_me(sk, other))
 			writable = 0;
 
diff --git a/security/integrity/ima/ima_mok.c b/security/integrity/ima/ima_mok.c
index 3e7a1523663b..daad75ee74d9 100644
--- a/security/integrity/ima/ima_mok.c
+++ b/security/integrity/ima/ima_mok.c
@@ -26,7 +26,7 @@ struct key *ima_blacklist_keyring;
 /*
  * Allocate the IMA blacklist keyring
  */
-__init int ima_mok_init(void)
+static __init int ima_mok_init(void)
 {
 	struct key_restriction *restriction;
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index a9c20821a726..c8e82d6a12b5 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -85,23 +85,22 @@ int log_policy = SMACK_AUDIT_DENIED;
 int smk_access_entry(char *subject_label, char *object_label,
 			struct list_head *rule_list)
 {
-	int may = -ENOENT;
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_object->smk_known == object_label &&
 		    srp->smk_subject->smk_known == subject_label) {
-			may = srp->smk_access;
-			break;
+			int may = srp->smk_access;
+			/*
+			 * MAY_WRITE implies MAY_LOCK.
+			 */
+			if ((may & MAY_WRITE) == MAY_WRITE)
+				may |= MAY_LOCK;
+			return may;
 		}
 	}
 
-	/*
-	 * MAY_WRITE implies MAY_LOCK.
-	 */
-	if ((may & MAY_WRITE) == MAY_WRITE)
-		may |= MAY_LOCK;
-	return may;
+	return -ENOENT;
 }
 
 /**
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index c412f2a909c9..82a7387ba9d2 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1757,7 +1757,7 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_pcm_substream *substream,
 		channels = params_channels(params);
 		frame_size = snd_pcm_format_size(format, channels);
 		if (frame_size > 0)
-			params->fifo_size /= (unsigned)frame_size;
+			params->fifo_size /= frame_size;
 	}
 	return 0;
 }
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 4a76b099a508..e389ecf06e63 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -226,9 +226,6 @@ static const struct snd_soc_dapm_widget byt_rt5640_widgets[] = {
 static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 	{"Headphone", NULL, "Platform Clock"},
 	{"Headset Mic", NULL, "Platform Clock"},
-	{"Internal Mic", NULL, "Platform Clock"},
-	{"Speaker", NULL, "Platform Clock"},
-
 	{"Headset Mic", NULL, "MICBIAS1"},
 	{"IN2P", NULL, "Headset Mic"},
 	{"Headphone", NULL, "HPOL"},
@@ -236,19 +233,23 @@ static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC1", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic2_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC2", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN1P", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in3_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN3P", NULL, "Internal Mic"},
 };
@@ -290,6 +291,7 @@ static const struct snd_soc_dapm_route byt_rt5640_ssp0_aif2_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 	{"Speaker", NULL, "SPORP"},
@@ -297,6 +299,7 @@ static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_mono_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 };
diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 0e07e3dea7de..8d1a7114f6c2 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -188,7 +188,9 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_i2s_dev *i2s = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret = 0;
 
+	pm_runtime_get_sync(cpu_dai->dev);
 	mask = I2S_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
@@ -201,7 +203,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		i2s->is_master_mode = false;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -215,7 +218,8 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 		val = I2S_CKR_CKP_POS;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_CKR, mask, val);
@@ -231,14 +235,15 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_TXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_TXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_TXCR_TFS_PCM | I2S_TXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_TXCR_TFS_PCM;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_TXCR, mask, val);
@@ -254,19 +259,23 @@ static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_I2S:
 		val = I2S_RXCR_IBM_NORMAL;
 		break;
-	case SND_SOC_DAIFMT_DSP_A: /* PCM no delay mode */
-		val = I2S_RXCR_TFS_PCM;
-		break;
-	case SND_SOC_DAIFMT_DSP_B: /* PCM delay 1 mode */
+	case SND_SOC_DAIFMT_DSP_A: /* PCM delay 1 bit mode */
 		val = I2S_RXCR_TFS_PCM | I2S_RXCR_PBM_MODE(1);
 		break;
+	case SND_SOC_DAIFMT_DSP_B: /* PCM no delay mode */
+		val = I2S_RXCR_TFS_PCM;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_pm_put;
 	}
 
 	regmap_update_bits(i2s->regmap, I2S_RXCR, mask, val);
 
-	return 0;
+err_pm_put:
+	pm_runtime_put(cpu_dai->dev);
+
+	return ret;
 }
 
 static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 96c6238a4a1f..3f503ad37a2b 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -730,7 +730,7 @@ static void test_sockmap(int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
