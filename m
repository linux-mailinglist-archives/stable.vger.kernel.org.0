Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2B6A2921
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 11:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBYKq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 05:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBYKqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 05:46:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A9B34C33;
        Sat, 25 Feb 2023 02:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2EAE60ABD;
        Sat, 25 Feb 2023 10:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAC7C433D2;
        Sat, 25 Feb 2023 10:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677322004;
        bh=IVgMElnU95EJNteOCLAWejc+Bt34oM5VKK7hvubsATU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDgU2aUZWzJYiKsFiDMx06O4Qj+3XMsQUztLNxUbs0/b6JvqxEtCtuee5HcwBgzhP
         ieBblWk3PlExGDyQHVz1WWQJ2Fwh6qHI6VBwqUY8ahREd0bwKWp03yL0FMr220eDNB
         l1QNj7skzuQwJ5PryraaZSrgmRrd+bKZ6PC5xbm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.14
Date:   Sat, 25 Feb 2023 11:46:33 +0100
Message-Id: <1677321992150156@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1677321992228178@kroah.com>
References: <1677321992228178@kroah.com>
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

diff --git a/Documentation/admin-guide/perf/hisi-pcie-pmu.rst b/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
index 294ebbdb22af..bbe66480ff85 100644
--- a/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
+++ b/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
@@ -15,10 +15,10 @@ HiSilicon PCIe PMU driver
 The PCIe PMU driver registers a perf PMU with the name of its sicl-id and PCIe
 Core id.::
 
-  /sys/bus/event_source/hisi_pcie<sicl>_<core>
+  /sys/bus/event_source/hisi_pcie<sicl>_core<core>
 
 PMU driver provides description of available events and filter options in sysfs,
-see /sys/bus/event_source/devices/hisi_pcie<sicl>_<core>.
+see /sys/bus/event_source/devices/hisi_pcie<sicl>_core<core>.
 
 The "format" directory describes all formats of the config (events) and config1
 (filter options) fields of the perf_event_attr structure. The "events" directory
@@ -33,13 +33,13 @@ monitored by PMU.
 Example usage of perf::
 
   $# perf list
-  hisi_pcie0_0/rx_mwr_latency/ [kernel PMU event]
-  hisi_pcie0_0/rx_mwr_cnt/ [kernel PMU event]
+  hisi_pcie0_core0/rx_mwr_latency/ [kernel PMU event]
+  hisi_pcie0_core0/rx_mwr_cnt/ [kernel PMU event]
   ------------------------------------------
 
-  $# perf stat -e hisi_pcie0_0/rx_mwr_latency/
-  $# perf stat -e hisi_pcie0_0/rx_mwr_cnt/
-  $# perf stat -g -e hisi_pcie0_0/rx_mwr_latency/ -e hisi_pcie0_0/rx_mwr_cnt/
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_latency/
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_cnt/
+  $# perf stat -g -e hisi_pcie0_core0/rx_mwr_latency/ -e hisi_pcie0_core0/rx_mwr_cnt/
 
 The current driver does not support sampling. So "perf record" is unsupported.
 Also attach to a task is unsupported for PCIe PMU.
@@ -64,7 +64,7 @@ bit8 is set, port=0x100; if these two Root Ports are both monitored, port=0x101.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mwr_latency,port=0x1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_latency,port=0x1/ sleep 5
 
 -bdf
 
@@ -76,7 +76,7 @@ For example, "bdf=0x3900" means BDF of target Endpoint is 0000:39:00.0.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,bdf=0x3900/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,bdf=0x3900/ sleep 5
 
 2. Trigger filter
 Event statistics start when the first time TLP length is greater/smaller
@@ -90,7 +90,7 @@ means start when TLP length < condition.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,trig_len=0x4,trig_mode=1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,trig_len=0x4,trig_mode=1/ sleep 5
 
 3. Threshold filter
 Counter counts when TLP length within the specified range. You can set the
@@ -103,4 +103,4 @@ when TLP length < threshold.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,thr_len=0x4,thr_mode=1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,thr_len=0x4,thr_mode=1/ sleep 5
diff --git a/MAINTAINERS b/MAINTAINERS
index d4822ae39e39..350d7e3ba94f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3444,7 +3444,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git
diff --git a/Makefile b/Makefile
index e51356b982f9..3e82a3224362 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 13
+SUBLEVEL = 14
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc..27714dc2f04a 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@ usb1: usb@211000 {
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
@@ -659,3 +659,19 @@ L2_1: l2-cache-controller@c20000 {
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8c3862b4c259..a4c6efadc90c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\
@@ -410,9 +411,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 5a2384ed1727..26245aaf12b8 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -234,6 +234,14 @@ void radix__mark_rodata_ro(void)
 	end = (unsigned long)__end_rodata;
 
 	radix__change_memory_range(start, end, _PAGE_WRITE);
+
+	for (start = PAGE_OFFSET; start < (unsigned long)_stext; start += PAGE_SIZE) {
+		end = start + PAGE_SIZE;
+		if (overlaps_interrupt_vector_text(start, end))
+			radix__change_memory_range(start, end, _PAGE_WRITE);
+		else
+			break;
+	}
 }
 
 void radix__mark_initmem_nx(void)
@@ -268,6 +276,11 @@ static unsigned long next_boundary(unsigned long addr, unsigned long end)
 
 	// Relocatable kernel running at non-zero real address
 	if (stext_phys != 0) {
+		// The end of interrupts code at zero is a rodata boundary
+		unsigned long end_intr = __pa_symbol(__end_interrupts) - stext_phys;
+		if (addr < end_intr)
+			return end_intr;
+
 		// Start of relocated kernel text is a rodata boundary
 		if (addr < stext_phys)
 			return stext_phys;
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index f81d96710595..cbf9c1b0beda 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index 1cc15528ce29..85b85a275a43 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -183,6 +183,37 @@ void int3_emulate_ret(struct pt_regs *regs)
 	unsigned long ip = int3_emulate_pop(regs);
 	int3_emulate_jmp(regs, ip);
 }
+
+static __always_inline
+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+{
+	static const unsigned long jcc_mask[6] = {
+		[0] = X86_EFLAGS_OF,
+		[1] = X86_EFLAGS_CF,
+		[2] = X86_EFLAGS_ZF,
+		[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
+		[4] = X86_EFLAGS_SF,
+		[5] = X86_EFLAGS_PF,
+	};
+
+	bool invert = cc & 1;
+	bool match;
+
+	if (cc < 0xc) {
+		match = regs->flags & jcc_mask[cc >> 1];
+	} else {
+		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
+			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
+		if (cc >= 0xe)
+			match = match || (regs->flags & X86_EFLAGS_ZF);
+	}
+
+	if ((match && !invert) || (!match && invert))
+		ip += disp;
+
+	int3_emulate_jmp(regs, ip);
+}
+
 #endif /* !CONFIG_UML_X86 */
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5cadcea035e0..d1d92897ed6b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -339,6 +339,12 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 	}
 }
 
+static inline bool is_jcc32(struct insn *insn)
+{
+	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
+	return insn->opcode.bytes[0] == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80;
+}
+
 #if defined(CONFIG_RETPOLINE) && defined(CONFIG_OBJTOOL)
 
 /*
@@ -427,8 +433,7 @@ static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 	 *   [ NOP ]
 	 * 1:
 	 */
-	/* Jcc.d32 second opcode byte is in the range: 0x80-0x8f */
-	if (op == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80) {
+	if (is_jcc32(insn)) {
 		cc = insn->opcode.bytes[1] & 0xf;
 		cc ^= 1; /* invert condition */
 
@@ -1311,6 +1316,11 @@ void text_poke_sync(void)
 	on_each_cpu(do_sync_core, NULL, 1);
 }
 
+/*
+ * NOTE: crazy scheme to allow patching Jcc.d32 but not increase the size of
+ * this thing. When len == 6 everything is prefixed with 0x0f and we map
+ * opcode to Jcc.d8, using len to distinguish.
+ */
 struct text_poke_loc {
 	/* addr := _stext + rel_addr */
 	s32 rel_addr;
@@ -1432,6 +1442,10 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 		int3_emulate_jmp(regs, (long)ip + tp->disp);
 		break;
 
+	case 0x70 ... 0x7f: /* Jcc */
+		int3_emulate_jcc(regs, tp->opcode & 0xf, (long)ip, tp->disp);
+		break;
+
 	default:
 		BUG();
 	}
@@ -1505,16 +1519,26 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 	 * Second step: update all but the first byte of the patched range.
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
-		u8 old[POKE_MAX_OPCODE_SIZE] = { tp[i].old, };
+		u8 old[POKE_MAX_OPCODE_SIZE+1] = { tp[i].old, };
+		u8 _new[POKE_MAX_OPCODE_SIZE+1];
+		const u8 *new = tp[i].text;
 		int len = tp[i].len;
 
 		if (len - INT3_INSN_SIZE > 0) {
 			memcpy(old + INT3_INSN_SIZE,
 			       text_poke_addr(&tp[i]) + INT3_INSN_SIZE,
 			       len - INT3_INSN_SIZE);
+
+			if (len == 6) {
+				_new[0] = 0x0f;
+				memcpy(_new + 1, new, 5);
+				new = _new;
+			}
+
 			text_poke(text_poke_addr(&tp[i]) + INT3_INSN_SIZE,
-				  (const char *)tp[i].text + INT3_INSN_SIZE,
+				  new + INT3_INSN_SIZE,
 				  len - INT3_INSN_SIZE);
+
 			do_sync++;
 		}
 
@@ -1542,8 +1566,7 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 		 * The old instruction is recorded so that the event can be
 		 * processed forwards or backwards.
 		 */
-		perf_event_text_poke(text_poke_addr(&tp[i]), old, len,
-				     tp[i].text, len);
+		perf_event_text_poke(text_poke_addr(&tp[i]), old, len, new, len);
 	}
 
 	if (do_sync) {
@@ -1560,10 +1583,15 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 	 * replacing opcode.
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
-		if (tp[i].text[0] == INT3_INSN_OPCODE)
+		u8 byte = tp[i].text[0];
+
+		if (tp[i].len == 6)
+			byte = 0x0f;
+
+		if (byte == INT3_INSN_OPCODE)
 			continue;
 
-		text_poke(text_poke_addr(&tp[i]), tp[i].text, INT3_INSN_SIZE);
+		text_poke(text_poke_addr(&tp[i]), &byte, INT3_INSN_SIZE);
 		do_sync++;
 	}
 
@@ -1581,9 +1609,11 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 			       const void *opcode, size_t len, const void *emulate)
 {
 	struct insn insn;
-	int ret, i;
+	int ret, i = 0;
 
-	memcpy((void *)tp->text, opcode, len);
+	if (len == 6)
+		i = 1;
+	memcpy((void *)tp->text, opcode+i, len-i);
 	if (!emulate)
 		emulate = opcode;
 
@@ -1594,6 +1624,13 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	tp->len = len;
 	tp->opcode = insn.opcode.bytes[0];
 
+	if (is_jcc32(&insn)) {
+		/*
+		 * Map Jcc.d32 onto Jcc.d8 and use len to distinguish.
+		 */
+		tp->opcode = insn.opcode.bytes[1] - 0x10;
+	}
+
 	switch (tp->opcode) {
 	case RET_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
@@ -1610,7 +1647,6 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 		BUG_ON(len != insn.length);
 	};
 
-
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
 	case RET_INSN_OPCODE:
@@ -1619,6 +1655,7 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
+	case 0x70 ... 0x7f: /* Jcc */
 		tp->disp = insn.immediate.value;
 		break;
 
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 5be7f23099e1..ea155f0cf545 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -471,50 +471,26 @@ static void kprobe_emulate_call(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(kprobe_emulate_call);
 
-static nokprobe_inline
-void __kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs, bool cond)
+static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
 {
 	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (cond)
-		ip += p->ainsn.rel32;
+	ip += p->ainsn.rel32;
 	int3_emulate_jmp(regs, ip);
 }
-
-static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
-{
-	__kprobe_emulate_jmp(p, regs, true);
-}
 NOKPROBE_SYMBOL(kprobe_emulate_jmp);
 
-static const unsigned long jcc_mask[6] = {
-	[0] = X86_EFLAGS_OF,
-	[1] = X86_EFLAGS_CF,
-	[2] = X86_EFLAGS_ZF,
-	[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
-	[4] = X86_EFLAGS_SF,
-	[5] = X86_EFLAGS_PF,
-};
-
 static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 {
-	bool invert = p->ainsn.jcc.type & 1;
-	bool match;
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (p->ainsn.jcc.type < 0xc) {
-		match = regs->flags & jcc_mask[p->ainsn.jcc.type >> 1];
-	} else {
-		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
-			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
-		if (p->ainsn.jcc.type >= 0xe)
-			match = match || (regs->flags & X86_EFLAGS_ZF);
-	}
-	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
+	int3_emulate_jcc(regs, p->ainsn.jcc.type, ip, p->ainsn.rel32);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_jcc);
 
 static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 {
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 	bool match;
 
 	if (p->ainsn.loop.type != 3) {	/* LOOP* */
@@ -542,7 +518,9 @@ static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 	else if (p->ainsn.loop.type == 1)	/* LOOPE */
 		match = match && (regs->flags & X86_EFLAGS_ZF);
 
-	__kprobe_emulate_jmp(p, regs, match);
+	if (match)
+		ip += p->ainsn.rel32;
+	int3_emulate_jmp(regs, ip);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_loop);
 
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index aaaba85d6d7f..a9b54b795ebf 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -9,6 +9,7 @@ enum insn_type {
 	NOP = 1,  /* site cond-call */
 	JMP = 2,  /* tramp / site tail-call */
 	RET = 3,  /* tramp / site cond-tail-call */
+	JCC = 4,
 };
 
 /*
@@ -25,12 +26,39 @@ static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
+static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */
+{
+	u8 ret = 0;
+
+	if (insn[0] == 0x0f) {
+		u8 tmp = insn[1];
+		if ((tmp & 0xf0) == 0x80)
+			ret = tmp;
+	}
+
+	return ret;
+}
+
+extern void __static_call_return(void);
+
+asm (".global __static_call_return\n\t"
+     ".type __static_call_return, @function\n\t"
+     "__static_call_return:\n\t"
+     ANNOTATE_NOENDBR
+     ANNOTATE_RETPOLINE_SAFE
+     "ret; int3\n\t"
+     ".size __static_call_return, . - __static_call_return \n\t");
+
 static void __ref __static_call_transform(void *insn, enum insn_type type,
 					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
 	const void *code;
+	u8 op, buf[6];
+
+	if ((type == JMP || type == RET) && (op = __is_Jcc(insn)))
+		type = JCC;
 
 	switch (type) {
 	case CALL:
@@ -56,6 +84,20 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 		else
 			code = &retinsn;
 		break;
+
+	case JCC:
+		if (!func) {
+			func = __static_call_return;
+			if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+				func = __x86_return_thunk;
+		}
+
+		buf[0] = 0x0f;
+		__text_gen_insn(buf+1, op, insn+1, func, 5);
+		code = buf;
+		size = 6;
+
+		break;
 	}
 
 	if (memcmp(insn, code, size) == 0)
@@ -67,9 +109,9 @@ static void __ref __static_call_transform(void *insn, enum insn_type type,
 	text_poke_bp(insn, code, size, emulate);
 }
 
-static void __static_call_validate(void *insn, bool tail, bool tramp)
+static void __static_call_validate(u8 *insn, bool tail, bool tramp)
 {
-	u8 opcode = *(u8 *)insn;
+	u8 opcode = insn[0];
 
 	if (tramp && memcmp(insn+5, tramp_ud, 3)) {
 		pr_err("trampoline signature fail");
@@ -78,7 +120,8 @@ static void __static_call_validate(void *insn, bool tail, bool tramp)
 
 	if (tail) {
 		if (opcode == JMP32_INSN_OPCODE ||
-		    opcode == RET_INSN_OPCODE)
+		    opcode == RET_INSN_OPCODE ||
+		    __is_Jcc(insn))
 			return;
 	} else {
 		if (opcode == CALL_INSN_OPCODE ||
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..0434bb7b456b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3889,8 +3889,14 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	/*
+	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
+	 * can't read guest memory (dereference memslots) to decode the WRMSR.
+	 */
+	if (control->exit_code == SVM_EXIT_MSR && control->exit_info_1 &&
+	    nrips && control->next_rip)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
 	return EXIT_FASTPATH_NONE;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 10c63b1bf92f..df8995977ec2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4767,6 +4767,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ae248e87f5e..95ed874fbbcc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1348,8 +1348,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05ca303d7fd9..68827b8dc37a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8860,7 +8860,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
-			if (ctxt->have_exception) {
+
+			if (ctxt->have_exception &&
+			    !(emulation_type & EMULTYPE_SKIP)) {
 				/*
 				 * #UD should result in just EMULATION_FAILED, and trap-like
 				 * exception should not be encountered during decode.
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f3098c0e386a..a58a426e6b1c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1757,18 +1757,42 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 
 static int kvm_xen_eventfd_reset(struct kvm *kvm)
 {
-	struct evtchnfd *evtchnfd;
+	struct evtchnfd *evtchnfd, **all_evtchnfds;
 	int i;
+	int n = 0;
 
 	mutex_lock(&kvm->lock);
+
+	/*
+	 * Because synchronize_srcu() cannot be called inside the
+	 * critical section, first collect all the evtchnfd objects
+	 * in an array as they are removed from evtchn_ports.
+	 */
+	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i)
+		n++;
+
+	all_evtchnfds = kmalloc_array(n, sizeof(struct evtchnfd *), GFP_KERNEL);
+	if (!all_evtchnfds) {
+		mutex_unlock(&kvm->lock);
+		return -ENOMEM;
+	}
+
+	n = 0;
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
+		all_evtchnfds[n++] = evtchnfd;
 		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
-		synchronize_srcu(&kvm->srcu);
+	}
+	mutex_unlock(&kvm->lock);
+
+	synchronize_srcu(&kvm->srcu);
+
+	while (n--) {
+		evtchnfd = all_evtchnfds[n];
 		if (!evtchnfd->deliver.port.port)
 			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 		kfree(evtchnfd);
 	}
-	mutex_unlock(&kvm->lock);
+	kfree(all_evtchnfds);
 
 	return 0;
 }
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6beafd62d722..93e9ae928e4e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -316,6 +316,90 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0489, 0xe0d0), .driver_info = BTUSB_QCA_WCN6855 |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9108), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9109), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9208), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9209), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9308), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9408), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9508), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9509), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9608), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9609), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x10ab, 0x9f09), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3022), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0c7), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0c9), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0ca), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0cb), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0ce), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0de), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0df), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0e1), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0ea), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0ec), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3023), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3024), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3a22), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3a24), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3a26), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x3a27), .driver_info = BTUSB_QCA_WCN6855 |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* QCA WCN785x chipset */
 	{ USB_DEVICE(0x0cf3, 0xe700), .driver_info = BTUSB_QCA_WCN6855 |
diff --git a/drivers/clk/x86/Kconfig b/drivers/clk/x86/Kconfig
index 69642e15fcc1..ced99e082e3d 100644
--- a/drivers/clk/x86/Kconfig
+++ b/drivers/clk/x86/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CLK_LGM_CGU
 	depends on OF && HAS_IOMEM && (X86 || COMPILE_TEST)
+	select MFD_SYSCON
 	select OF_EARLY_FLATTREE
 	bool "Clock driver for Lightning Mountain(LGM) platform"
 	help
-	  Clock Generation Unit(CGU) driver for Intel Lightning Mountain(LGM)
-	  network processor SoC.
+	  Clock Generation Unit(CGU) driver for MaxLinear's x86 based
+	  Lightning Mountain(LGM) network processor SoC.
diff --git a/drivers/clk/x86/clk-cgu-pll.c b/drivers/clk/x86/clk-cgu-pll.c
index 3179557b5f78..409dbf55f4ca 100644
--- a/drivers/clk/x86/clk-cgu-pll.c
+++ b/drivers/clk/x86/clk-cgu-pll.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #include <linux/clk-provider.h>
@@ -40,13 +41,10 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
 	unsigned int div, mult, frac;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	mult = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 0, 12);
 	div = lgm_get_clk_val(pll->membase, PLL_REF_DIV(pll->reg), 18, 6);
 	frac = lgm_get_clk_val(pll->membase, pll->reg, 2, 24);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	if (pll->type == TYPE_LJPLL)
 		div *= 4;
@@ -57,12 +55,9 @@ static unsigned long lgm_pll_recalc_rate(struct clk_hw *hw, unsigned long prate)
 static int lgm_pll_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	ret = lgm_get_clk_val(pll->membase, pll->reg, 0, 1);
-	spin_unlock_irqrestore(&pll->lock, flags);
 
 	return ret;
 }
@@ -70,15 +65,13 @@ static int lgm_pll_is_enabled(struct clk_hw *hw)
 static int lgm_pll_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 	u32 val;
 	int ret;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 1);
-	ret = readl_poll_timeout_atomic(pll->membase + pll->reg,
-					val, (val & 0x1), 1, 100);
-	spin_unlock_irqrestore(&pll->lock, flags);
+	ret = regmap_read_poll_timeout_atomic(pll->membase, pll->reg,
+					      val, (val & 0x1), 1, 100);
+
 
 	return ret;
 }
@@ -86,11 +79,8 @@ static int lgm_pll_enable(struct clk_hw *hw)
 static void lgm_pll_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_pll *pll = to_lgm_clk_pll(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pll->lock, flags);
 	lgm_set_clk_val(pll->membase, pll->reg, 0, 1, 0);
-	spin_unlock_irqrestore(&pll->lock, flags);
 }
 
 static const struct clk_ops lgm_pll_ops = {
@@ -121,7 +111,6 @@ lgm_clk_register_pll(struct lgm_clk_provider *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	pll->membase = ctx->membase;
-	pll->lock = ctx->lock;
 	pll->reg = list->reg;
 	pll->flags = list->flags;
 	pll->type = list->type;
diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 33de600e0c38..89b53f280aee 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -24,14 +25,10 @@
 static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 					     const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return clk_hw_register_fixed_rate(NULL, list->name,
 					  list->parent_data[0].name,
@@ -41,33 +38,27 @@ static struct clk_hw *lgm_clk_register_fixed(struct lgm_clk_provider *ctx,
 static u8 lgm_clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		val = mux->reg;
 	else
 		val = lgm_get_clk_val(mux->membase, mux->reg, mux->shift,
 				      mux->width);
-	spin_unlock_irqrestore(&mux->lock, flags);
 	return clk_mux_val_to_index(hw, NULL, mux->flags, val);
 }
 
 static int lgm_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct lgm_clk_mux *mux = to_lgm_clk_mux(hw);
-	unsigned long flags;
 	u32 val;
 
 	val = clk_mux_index_to_val(NULL, mux->flags, index);
-	spin_lock_irqsave(&mux->lock, flags);
 	if (mux->flags & MUX_CLK_SW)
 		mux->reg = val;
 	else
 		lgm_set_clk_val(mux->membase, mux->reg, mux->shift,
 				mux->width, val);
-	spin_unlock_irqrestore(&mux->lock, flags);
 
 	return 0;
 }
@@ -90,7 +81,7 @@ static struct clk_hw *
 lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 		     const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->mux_flags;
+	unsigned long cflags = list->mux_flags;
 	struct device *dev = ctx->dev;
 	u8 shift = list->mux_shift;
 	u8 width = list->mux_width;
@@ -111,7 +102,6 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	init.num_parents = list->num_parents;
 
 	mux->membase = ctx->membase;
-	mux->lock = ctx->lock;
 	mux->reg = reg;
 	mux->shift = shift;
 	mux->width = width;
@@ -123,11 +113,8 @@ lgm_clk_register_mux(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&mux->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(mux->membase, reg, shift, width, list->mux_val);
-		spin_unlock_irqrestore(&mux->lock, flags);
-	}
 
 	return hw;
 }
@@ -136,13 +123,10 @@ static unsigned long
 lgm_clk_divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	unsigned int val;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	val = lgm_get_clk_val(divider->membase, divider->reg,
 			      divider->shift, divider->width);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return divider_recalc_rate(hw, parent_rate, val, divider->table,
 				   divider->flags, divider->width);
@@ -163,7 +147,6 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 			 unsigned long prate)
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
-	unsigned long flags;
 	int value;
 
 	value = divider_get_val(rate, prate, divider->table,
@@ -171,10 +154,8 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (value < 0)
 		return value;
 
-	spin_lock_irqsave(&divider->lock, flags);
 	lgm_set_clk_val(divider->membase, divider->reg,
 			divider->shift, divider->width, value);
-	spin_unlock_irqrestore(&divider->lock, flags);
 
 	return 0;
 }
@@ -182,12 +163,10 @@ lgm_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 static int lgm_clk_divider_enable_disable(struct clk_hw *hw, int enable)
 {
 	struct lgm_clk_divider *div = to_lgm_clk_divider(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&div->lock, flags);
-	lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
-			div->width_gate, enable);
-	spin_unlock_irqrestore(&div->lock, flags);
+	if (div->flags != DIV_CLK_NO_MASK)
+		lgm_set_clk_val(div->membase, div->reg, div->shift_gate,
+				div->width_gate, enable);
 	return 0;
 }
 
@@ -213,7 +192,7 @@ static struct clk_hw *
 lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 			 const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->div_flags;
+	unsigned long cflags = list->div_flags;
 	struct device *dev = ctx->dev;
 	struct lgm_clk_divider *div;
 	struct clk_init_data init = {};
@@ -236,7 +215,6 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	init.num_parents = 1;
 
 	div->membase = ctx->membase;
-	div->lock = ctx->lock;
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
@@ -251,11 +229,8 @@ lgm_clk_register_divider(struct lgm_clk_provider *ctx,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&div->lock, flags);
+	if (cflags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(div->membase, reg, shift, width, list->div_val);
-		spin_unlock_irqrestore(&div->lock, flags);
-	}
 
 	return hw;
 }
@@ -264,7 +239,6 @@ static struct clk_hw *
 lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list)
 {
-	unsigned long flags;
 	struct clk_hw *hw;
 
 	hw = clk_hw_register_fixed_factor(ctx->dev, list->name,
@@ -273,12 +247,9 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 	if (IS_ERR(hw))
 		return ERR_CAST(hw);
 
-	if (list->div_flags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&ctx->lock, flags);
+	if (list->div_flags & CLOCK_FLAG_VAL_INIT)
 		lgm_set_clk_val(ctx->membase, list->div_off, list->div_shift,
 				list->div_width, list->div_val);
-		spin_unlock_irqrestore(&ctx->lock, flags);
-	}
 
 	return hw;
 }
@@ -286,13 +257,10 @@ lgm_clk_register_fixed_factor(struct lgm_clk_provider *ctx,
 static int lgm_clk_gate_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_EN(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return 0;
 }
@@ -300,25 +268,19 @@ static int lgm_clk_gate_enable(struct clk_hw *hw)
 static void lgm_clk_gate_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
-	unsigned long flags;
 	unsigned int reg;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_DIS(gate->reg);
 	lgm_set_clk_val(gate->membase, reg, gate->shift, 1, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 }
 
 static int lgm_clk_gate_is_enabled(struct clk_hw *hw)
 {
 	struct lgm_clk_gate *gate = to_lgm_clk_gate(hw);
 	unsigned int reg, ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gate->lock, flags);
 	reg = GATE_HW_REG_STAT(gate->reg);
 	ret = lgm_get_clk_val(gate->membase, reg, gate->shift, 1);
-	spin_unlock_irqrestore(&gate->lock, flags);
 
 	return ret;
 }
@@ -333,7 +295,7 @@ static struct clk_hw *
 lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		      const struct lgm_clk_branch *list)
 {
-	unsigned long flags, cflags = list->gate_flags;
+	unsigned long cflags = list->gate_flags;
 	const char *pname = list->parent_data[0].name;
 	struct device *dev = ctx->dev;
 	u8 shift = list->gate_shift;
@@ -354,7 +316,6 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 	init.num_parents = pname ? 1 : 0;
 
 	gate->membase = ctx->membase;
-	gate->lock = ctx->lock;
 	gate->reg = reg;
 	gate->shift = shift;
 	gate->flags = cflags;
@@ -366,9 +327,7 @@ lgm_clk_register_gate(struct lgm_clk_provider *ctx,
 		return ERR_PTR(ret);
 
 	if (cflags & CLOCK_FLAG_VAL_INIT) {
-		spin_lock_irqsave(&gate->lock, flags);
 		lgm_set_clk_val(gate->membase, reg, shift, 1, list->gate_val);
-		spin_unlock_irqrestore(&gate->lock, flags);
 	}
 
 	return hw;
@@ -396,8 +355,22 @@ int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			hw = lgm_clk_register_fixed_factor(ctx, list);
 			break;
 		case CLK_TYPE_GATE:
-			hw = lgm_clk_register_gate(ctx, list);
+			if (list->gate_flags & GATE_CLK_HW) {
+				hw = lgm_clk_register_gate(ctx, list);
+			} else {
+				/*
+				 * GATE_CLKs can be controlled either from
+				 * CGU clk driver i.e. this driver or directly
+				 * from power management driver/daemon. It is
+				 * dependent on the power policy/profile requirements
+				 * of the end product. To override control of gate
+				 * clks from this driver, provide NULL for this index
+				 * of gate clk provider.
+				 */
+				hw = NULL;
+			}
 			break;
+
 		default:
 			dev_err(ctx->dev, "invalid clk type\n");
 			return -EINVAL;
@@ -443,24 +416,18 @@ lgm_clk_ddiv_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 static int lgm_clk_ddiv_enable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 	return 0;
 }
 
 static void lgm_clk_ddiv_disable(struct clk_hw *hw)
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift_gate,
 			ddiv->width_gate, 0);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 }
 
 static int
@@ -497,32 +464,25 @@ lgm_clk_ddiv_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)prate, rate);
 
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 		div = div * 2;
 	}
 
-	if (div <= 0) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (div <= 0)
 		return -EINVAL;
-	}
 
-	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2)) {
-		spin_unlock_irqrestore(&ddiv->lock, flags);
+	if (lgm_clk_get_ddiv_val(div, &ddiv1, &ddiv2))
 		return -EINVAL;
-	}
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg, ddiv->shift0, ddiv->width0,
 			ddiv1 - 1);
 
 	lgm_set_clk_val(ddiv->membase, ddiv->reg,  ddiv->shift1, ddiv->width1,
 			ddiv2 - 1);
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return 0;
 }
@@ -533,18 +493,15 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct lgm_clk_ddiv *ddiv = to_lgm_clk_ddiv(hw);
 	u32 div, ddiv1, ddiv2;
-	unsigned long flags;
 	u64 rate64;
 
 	div = DIV_ROUND_CLOSEST_ULL((u64)*prate, rate);
 
 	/* if predivide bit is enabled, modify div by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		div = div * 2;
 		div = DIV_ROUND_CLOSEST_ULL((u64)div, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	if (div <= 0)
 		return *prate;
@@ -558,12 +515,10 @@ lgm_clk_ddiv_round_rate(struct clk_hw *hw, unsigned long rate,
 	do_div(rate64, ddiv2);
 
 	/* if predivide bit is enabled, modify rounded rate by factor of 2.5 */
-	spin_lock_irqsave(&ddiv->lock, flags);
 	if (lgm_get_clk_val(ddiv->membase, ddiv->reg, ddiv->shift2, 1)) {
 		rate64 = rate64 * 2;
 		rate64 = DIV_ROUND_CLOSEST_ULL(rate64, 5);
 	}
-	spin_unlock_irqrestore(&ddiv->lock, flags);
 
 	return rate64;
 }
@@ -600,7 +555,6 @@ int lgm_clk_register_ddiv(struct lgm_clk_provider *ctx,
 		init.num_parents = 1;
 
 		ddiv->membase = ctx->membase;
-		ddiv->lock = ctx->lock;
 		ddiv->reg = list->reg;
 		ddiv->shift0 = list->shift0;
 		ddiv->width0 = list->width0;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 4e22bfb22312..bcaf8aec94e5 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -1,28 +1,28 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright(c) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
+ * Copyright (C) 2020 Intel Corporation.
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 
 #ifndef __CLK_CGU_H
 #define __CLK_CGU_H
 
-#include <linux/io.h>
+#include <linux/regmap.h>
 
 struct lgm_clk_mux {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_divider {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	u8 width;
@@ -30,12 +30,11 @@ struct lgm_clk_divider {
 	u8 width_gate;
 	unsigned long flags;
 	const struct clk_div_table *table;
-	spinlock_t lock;
 };
 
 struct lgm_clk_ddiv {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift0;
 	u8 width0;
@@ -48,16 +47,14 @@ struct lgm_clk_ddiv {
 	unsigned int mult;
 	unsigned int div;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 struct lgm_clk_gate {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	u8 shift;
 	unsigned long flags;
-	spinlock_t lock;
 };
 
 enum lgm_clk_type {
@@ -77,11 +74,10 @@ enum lgm_clk_type {
  * @clk_data: array of hw clocks and clk number.
  */
 struct lgm_clk_provider {
-	void __iomem *membase;
+	struct regmap *membase;
 	struct device_node *np;
 	struct device *dev;
 	struct clk_hw_onecell_data clk_data;
-	spinlock_t lock;
 };
 
 enum pll_type {
@@ -92,11 +88,10 @@ enum pll_type {
 
 struct lgm_clk_pll {
 	struct clk_hw hw;
-	void __iomem *membase;
+	struct regmap *membase;
 	unsigned int reg;
 	unsigned long flags;
 	enum pll_type type;
-	spinlock_t lock;
 };
 
 /**
@@ -202,6 +197,8 @@ struct lgm_clk_branch {
 /* clock flags definition */
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
+#define GATE_CLK_HW		BIT(18)
+#define DIV_CLK_NO_MASK		BIT(19)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
@@ -300,29 +297,32 @@ struct lgm_clk_branch {
 		.div = _d,					\
 	}
 
-static inline void lgm_set_clk_val(void __iomem *membase, u32 reg,
+static inline void lgm_set_clk_val(struct regmap *membase, u32 reg,
 				   u8 shift, u8 width, u32 set_val)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
-	u32 regval;
 
-	regval = readl(membase + reg);
-	regval = (regval & ~mask) | ((set_val << shift) & mask);
-	writel(regval, membase + reg);
+	regmap_update_bits(membase, reg, mask, set_val << shift);
 }
 
-static inline u32 lgm_get_clk_val(void __iomem *membase, u32 reg,
+static inline u32 lgm_get_clk_val(struct regmap *membase, u32 reg,
 				  u8 shift, u8 width)
 {
 	u32 mask = (GENMASK(width - 1, 0) << shift);
 	u32 val;
 
-	val = readl(membase + reg);
+	if (regmap_read(membase, reg, &val)) {
+		WARN_ONCE(1, "Failed to read clk reg: 0x%x\n", reg);
+		return 0;
+	}
+
 	val = (val & mask) >> shift;
 
 	return val;
 }
 
+
+
 int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			      const struct lgm_clk_branch *list,
 			      unsigned int nr_clk);
diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 020f4e83a5cc..f69455dd1c98 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Copyright (C) 2020-2022 MaxLinear, Inc.
  * Copyright (C) 2020 Intel Corporation.
- * Zhu YiXin <yixin.zhu@intel.com>
- * Rahul Tanwar <rahul.tanwar@intel.com>
+ * Zhu Yixin <yzhu@maxlinear.com>
+ * Rahul Tanwar <rtanwar@maxlinear.com>
  */
 #include <linux/clk-provider.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <dt-bindings/clock/intel,lgm-clk.h>
@@ -253,8 +255,8 @@ static const struct lgm_clk_branch lgm_branch_clks[] = {
 	LGM_FIXED(LGM_CLK_SLIC, "slic", NULL, 0, CGU_IF_CLK1,
 		  8, 2, CLOCK_FLAG_VAL_INIT, 8192000, 2),
 	LGM_FIXED(LGM_CLK_DOCSIS, "v_docsis", NULL, 0, 0, 0, 0, 0, 16000000, 0),
-	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", 0, CGU_PCMCR,
-		25, 3, 0, 0, 0, 0, dcl_div),
+	LGM_DIV(LGM_CLK_DCL, "dcl", "v_ifclk", CLK_SET_RATE_PARENT, CGU_PCMCR,
+		25, 3, 0, 0, DIV_CLK_NO_MASK, 0, dcl_div),
 	LGM_MUX(LGM_CLK_PCM, "pcm", pcm_p, 0, CGU_C55_PCMCR,
 		0, 1, CLK_MUX_ROUND_CLOSEST, 0),
 	LGM_FIXED_FACTOR(LGM_CLK_DDR_PHY, "ddr_phy", "ddr",
@@ -433,13 +435,15 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 
 	ctx->clk_data.num = CLK_NR_CLKS;
 
-	ctx->membase = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctx->membase))
+	ctx->membase = syscon_node_to_regmap(np);
+	if (IS_ERR(ctx->membase)) {
+		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
+	}
+
 
 	ctx->np = np;
 	ctx->dev = dev;
-	spin_lock_init(&ctx->lock);
 
 	ret = lgm_clk_register_plls(ctx, lgm_pll_clks,
 				    ARRAY_SIZE(lgm_pll_clks));
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b36abfa91581..9d82de4c0a8b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5827,7 +5827,8 @@ static void drm_parse_hdmi_forum_scds(struct drm_connector *connector,
 			else if (hf_scds[11] & DRM_EDID_DSC_10BPC)
 				hdmi_dsc->bpc_supported = 10;
 			else
-				hdmi_dsc->bpc_supported = 0;
+				/* Supports min 8 BPC if DSC 1.2 is supported*/
+				hdmi_dsc->bpc_supported = 8;
 
 			dsc_max_frl_rate = (hf_scds[12] & DRM_EDID_DSC_MAX_FRL_RATE_MASK) >> 4;
 			drm_get_max_frl_rate(dsc_max_frl_rate, &hdmi_dsc->max_lanes,
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index 55479cb8b1ac..67bdce5326c6 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -80,10 +80,10 @@ static int etnaviv_iommu_map(struct etnaviv_iommu_context *context, u32 iova,
 		return -EINVAL;
 
 	for_each_sgtable_dma_sg(sgt, sg, i) {
-		u32 pa = sg_dma_address(sg) - sg->offset;
+		phys_addr_t pa = sg_dma_address(sg) - sg->offset;
 		size_t bytes = sg_dma_len(sg) + sg->offset;
 
-		VERB("map[%d]: %08x %08x(%zx)", i, iova, pa, bytes);
+		VERB("map[%d]: %08x %pap(%zx)", i, iova, &pa, bytes);
 
 		ret = etnaviv_context_map(context, da, pa, bytes, prot);
 		if (ret)
diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 34f2d9da201e..fe4f279aaeb3 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -1130,7 +1130,6 @@ static const struct intel_gt_definition xelpmp_extra_gt[] = {
 	{}
 };
 
-__maybe_unused
 static const struct intel_device_info mtl_info = {
 	XE_HP_FEATURES,
 	XE_LPDP_FEATURES,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index f688124d6d66..ef341c4254fc 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -545,6 +545,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 					    u8 cmd_no, int channel)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -552,6 +553,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	if (channel < 0) {
 		kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -568,7 +570,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -584,6 +586,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 {
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
@@ -591,14 +594,14 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd_async(priv, cmd,
-					kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd_async(priv, cmd, cmd_len);
 	if (err)
 		kfree(cmd);
 
@@ -742,6 +745,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	u32 value = 0;
 	u32 mask = 0;
 	u16 cap_cmd_res;
@@ -753,13 +757,14 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_CAPABILITIES_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
 
 	kvaser_usb_hydra_set_cmd_dest_he(cmd, card_data->hydra.sysdbg_he);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1578,6 +1583,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_usb_net_hydra_priv *hydra = priv->sub_priv;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if (!hydra)
@@ -1588,6 +1594,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1597,7 +1604,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 
 	reinit_completion(&priv->get_busparams_comp);
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		return err;
 
@@ -1624,6 +1631,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -1631,6 +1639,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_nominal, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_nominal));
 
@@ -1639,7 +1648,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1652,6 +1661,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -1659,6 +1669,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_data, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_data));
 
@@ -1676,7 +1687,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1804,6 +1815,7 @@ static int kvaser_usb_hydra_get_software_info(struct kvaser_usb *dev)
 static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
@@ -1813,6 +1825,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_SOFTWARE_DETAILS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->sw_detail_req.use_ext_cmd = 1;
 	kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -1820,7 +1833,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1938,6 +1951,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if ((priv->can.ctrlmode &
@@ -1953,6 +1967,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_DRIVERMODE_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1962,7 +1977,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	else
 		cmd->set_ctrlmode.mode = KVASER_USB_HYDRA_CTRLMODE_NORMAL;
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	kfree(cmd);
 
 	return err;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index afd3edfa2428..b9266cf72a17 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -28,6 +28,7 @@ struct nfp_hwinfo;
 struct nfp_mip;
 struct nfp_net;
 struct nfp_nsp_identify;
+struct nfp_eth_media_buf;
 struct nfp_port;
 struct nfp_rtsym;
 struct nfp_rtsym_table;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 991059d6cb32..af376b900067 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,6 +293,182 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
+static const struct nfp_eth_media_link_mode {
+	u16 ethtool_link_mode;
+	u16 speed;
+} nfp_eth_media_table[NFP_MEDIA_LINK_MODES_NUMBER] = {
+	[NFP_MEDIA_1000BASE_CX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_1000BASE_KX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_10GBASE_KX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_25GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_KR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_40GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_LR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_50GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_LR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_FR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_100GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_KP4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR10] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+};
+
+static const unsigned int nfp_eth_speed_map[NFP_SUP_SPEED_NUMBER] = {
+	[NFP_SPEED_1G]		= SPEED_1000,
+	[NFP_SPEED_10G]		= SPEED_10000,
+	[NFP_SPEED_25G]		= SPEED_25000,
+	[NFP_SPEED_40G]		= SPEED_40000,
+	[NFP_SPEED_50G]		= SPEED_50000,
+	[NFP_SPEED_100G]	= SPEED_100000,
+};
+
+static void nfp_add_media_link_mode(struct nfp_port *port,
+				    struct nfp_eth_table_port *eth_port,
+				    struct ethtool_link_ksettings *cmd)
+{
+	u64 supported_modes[2], advertised_modes[2];
+	struct nfp_eth_media_buf ethm = {
+		.eth_index = eth_port->eth_index,
+	};
+	struct nfp_cpp *cpp = port->app->cpp;
+
+	if (nfp_eth_read_media(cpp, &ethm)) {
+		bitmap_fill(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
+		return;
+	}
+
+	bitmap_zero(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
+
+	for (u32 i = 0; i < 2; i++) {
+		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
+		advertised_modes[i] = le64_to_cpu(ethm.advertised_modes[i]);
+	}
+
+	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
+		if (i < 64) {
+			if (supported_modes[0] & BIT_ULL(i)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
+					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
+
+			if (advertised_modes[0] & BIT_ULL(i))
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
+					  cmd->link_modes.advertising);
+		} else {
+			if (supported_modes[1] & BIT_ULL(i - 64)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
+					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
+
+			if (advertised_modes[1] & BIT_ULL(i - 64))
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
+					  cmd->link_modes.advertising);
+		}
+	}
+}
+
 /**
  * nfp_net_get_link_ksettings - Get Link Speed settings
  * @netdev:	network interface device structure
@@ -311,6 +487,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	u16 sts;
 
 	/* Init to unknowns */
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
@@ -321,6 +499,7 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+		nfp_add_media_link_mode(port, eth_port, cmd);
 		if (eth_port->supp_aneg) {
 			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
 			if (eth_port->aneg == NFP_ANEG_AUTO) {
@@ -395,6 +574,22 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 
 	if (cmd->base.speed != SPEED_UNKNOWN) {
 		u32 speed = cmd->base.speed / eth_port->lanes;
+		bool is_supported = false;
+
+		for (u32 i = 0; i < NFP_SUP_SPEED_NUMBER; i++) {
+			if (cmd->base.speed == nfp_eth_speed_map[i] &&
+			    test_bit(i, port->speed_bitmap)) {
+				is_supported = true;
+				break;
+			}
+		}
+
+		if (!is_supported) {
+			netdev_err(netdev, "Speed %u is not supported.\n",
+				   cmd->base.speed);
+			err = -EINVAL;
+			goto err_bad_set;
+		}
 
 		if (req_aneg) {
 			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index 6793cdf9ff11..c31812287ded 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -38,6 +38,16 @@ enum nfp_port_flags {
 	NFP_PORT_CHANGED = 0,
 };
 
+enum {
+	NFP_SPEED_1G,
+	NFP_SPEED_10G,
+	NFP_SPEED_25G,
+	NFP_SPEED_40G,
+	NFP_SPEED_50G,
+	NFP_SPEED_100G,
+	NFP_SUP_SPEED_NUMBER
+};
+
 /**
  * struct nfp_port - structure representing NFP port
  * @netdev:	backpointer to associated netdev
@@ -52,6 +62,7 @@ enum nfp_port_flags {
  * @eth_forced:	for %NFP_PORT_PHYS_PORT port is forced UP or DOWN, don't change
  * @eth_port:	for %NFP_PORT_PHYS_PORT translated ETH Table port entry
  * @eth_stats:	for %NFP_PORT_PHYS_PORT MAC stats if available
+ * @speed_bitmap:	for %NFP_PORT_PHYS_PORT supported speed bitmap
  * @pf_id:	for %NFP_PORT_PF_PORT, %NFP_PORT_VF_PORT ID of the PCI PF (0-3)
  * @vf_id:	for %NFP_PORT_VF_PORT ID of the PCI VF within @pf_id
  * @pf_split:	for %NFP_PORT_PF_PORT %true if PCI PF has more than one vNIC
@@ -78,6 +89,7 @@ struct nfp_port {
 			bool eth_forced;
 			struct nfp_eth_table_port *eth_port;
 			u8 __iomem *eth_stats;
+			DECLARE_BITMAP(speed_bitmap, NFP_SUP_SPEED_NUMBER);
 		};
 		/* NFP_PORT_PF_PORT, NFP_PORT_VF_PORT */
 		struct {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 730fea214b8a..7136bc48530b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -100,6 +100,7 @@ enum nfp_nsp_cmd {
 	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
+	SPCODE_READ_MEDIA	= 23, /* Get either the supported or advertised media for a port */
 };
 
 struct nfp_nsp_dma_buf {
@@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 	kfree(buf);
 
 	return ret;
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
+{
+	struct nfp_nsp_command_buf_arg media = {
+		{
+			.code		= SPCODE_READ_MEDIA,
+			.option		= size,
+		},
+		.in_buf		= buf,
+		.in_size	= size,
+		.out_buf	= buf,
+		.out_size	= size,
+	};
+
+	return nfp_nsp_command_buf(state, &media);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 992d72ac98d3..8f5cab0032d0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -65,6 +65,11 @@ static inline bool nfp_nsp_has_read_module_eeprom(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 28;
 }
 
+static inline bool nfp_nsp_has_read_media(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 33;
+}
+
 enum nfp_eth_interface {
 	NFP_INTERFACE_NONE	= 0,
 	NFP_INTERFACE_SFP	= 1,
@@ -97,6 +102,47 @@ enum nfp_eth_fec {
 	NFP_FEC_DISABLED_BIT,
 };
 
+/* link modes about RJ45 haven't been used, so there's no mapping to them */
+enum nfp_ethtool_link_mode_list {
+	NFP_MEDIA_W0_RJ45_10M,
+	NFP_MEDIA_W0_RJ45_10M_HD,
+	NFP_MEDIA_W0_RJ45_100M,
+	NFP_MEDIA_W0_RJ45_100M_HD,
+	NFP_MEDIA_W0_RJ45_1G,
+	NFP_MEDIA_W0_RJ45_2P5G,
+	NFP_MEDIA_W0_RJ45_5G,
+	NFP_MEDIA_W0_RJ45_10G,
+	NFP_MEDIA_1000BASE_CX,
+	NFP_MEDIA_1000BASE_KX,
+	NFP_MEDIA_10GBASE_KX4,
+	NFP_MEDIA_10GBASE_KR,
+	NFP_MEDIA_10GBASE_CX4,
+	NFP_MEDIA_10GBASE_CR,
+	NFP_MEDIA_10GBASE_SR,
+	NFP_MEDIA_10GBASE_ER,
+	NFP_MEDIA_25GBASE_KR,
+	NFP_MEDIA_25GBASE_KR_S,
+	NFP_MEDIA_25GBASE_CR,
+	NFP_MEDIA_25GBASE_CR_S,
+	NFP_MEDIA_25GBASE_SR,
+	NFP_MEDIA_40GBASE_CR4,
+	NFP_MEDIA_40GBASE_KR4,
+	NFP_MEDIA_40GBASE_SR4,
+	NFP_MEDIA_40GBASE_LR4,
+	NFP_MEDIA_50GBASE_KR,
+	NFP_MEDIA_50GBASE_SR,
+	NFP_MEDIA_50GBASE_CR,
+	NFP_MEDIA_50GBASE_LR,
+	NFP_MEDIA_50GBASE_ER,
+	NFP_MEDIA_50GBASE_FR,
+	NFP_MEDIA_100GBASE_KR4,
+	NFP_MEDIA_100GBASE_SR4,
+	NFP_MEDIA_100GBASE_CR4,
+	NFP_MEDIA_100GBASE_KP4,
+	NFP_MEDIA_100GBASE_CR10,
+	NFP_MEDIA_LINK_MODES_NUMBER
+};
+
 #define NFP_FEC_AUTO		BIT(NFP_FEC_AUTO_BIT)
 #define NFP_FEC_BASER		BIT(NFP_FEC_BASER_BIT)
 #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
@@ -256,6 +302,16 @@ enum nfp_nsp_sensor_id {
 int nfp_hwmon_read_sensor(struct nfp_cpp *cpp, enum nfp_nsp_sensor_id id,
 			  long *val);
 
+struct nfp_eth_media_buf {
+	u8 eth_index;
+	u8 reserved[7];
+	__le64 supported_modes[2];
+	__le64 advertised_modes[2];
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
+
 #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
 
 enum nfp_nsp_versions {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index bb64efec4c46..570ac1bb2122 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -647,3 +647,29 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
 				      lanes, NSP_ETH_CTRL_SET_LANES);
 }
+
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
+{
+	struct nfp_nsp *nsp;
+	int ret;
+
+	nsp = nfp_nsp_open(cpp);
+	if (IS_ERR(nsp)) {
+		nfp_err(cpp, "Failed to access the NSP: %pe\n", nsp);
+		return PTR_ERR(nsp);
+	}
+
+	if (!nfp_nsp_has_read_media(nsp)) {
+		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
+		ret = -EOPNOTSUPP;
+		goto exit_close_nsp;
+	}
+
+	ret = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
+	if (ret)
+		nfp_err(cpp, "Reading media link modes failed: %pe\n", ERR_PTR(ret));
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return ret;
+}
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 7cc5fa325152..381c6b390dd7 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1964,7 +1964,7 @@ static void ath11k_qmi_free_target_mem_chunk(struct ath11k_base *ab)
 			continue;
 
 		dma_free_coherent(ab->dev,
-				  ab->qmi.target_mem[i].size,
+				  ab->qmi.target_mem[i].prev_size,
 				  ab->qmi.target_mem[i].vaddr,
 				  ab->qmi.target_mem[i].paddr);
 		ab->qmi.target_mem[i].vaddr = NULL;
@@ -1985,12 +1985,12 @@ static int ath11k_qmi_alloc_target_mem_chunk(struct ath11k_base *ab)
 		 * in such case, no need to allocate memory for FW again.
 		 */
 		if (chunk->vaddr) {
-			if (chunk->prev_type == chunk->type ||
+			if (chunk->prev_type == chunk->type &&
 			    chunk->prev_size == chunk->size)
 				continue;
 
 			/* cannot reuse the existing chunk */
-			dma_free_coherent(ab->dev, chunk->size,
+			dma_free_coherent(ab->dev, chunk->prev_size,
 					  chunk->vaddr, chunk->paddr);
 			chunk->vaddr = NULL;
 		}
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index b8dc3b5c9ad9..9f506efa5370 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -480,6 +480,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e9c1b62c9c3c..e445084e358f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4389,12 +4389,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
-#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
 	/*
-	 * Barry Day reports this causes issues with 8192eu and 8723bu
-	 * devices reconnecting. The reason for this is unclear, but
-	 * until it is better understood, leave the code in place but
-	 * disabled, so it is not lost.
+	 * The firmware turns on the rate control when it knows it's
+	 * connected to a network.
 	 */
 	struct h2c_cmd h2c;
 
@@ -4407,7 +4404,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
diff --git a/drivers/platform/x86/amd/pmf/Kconfig b/drivers/platform/x86/amd/pmf/Kconfig
index c375498c4071..6d89528c3177 100644
--- a/drivers/platform/x86/amd/pmf/Kconfig
+++ b/drivers/platform/x86/amd/pmf/Kconfig
@@ -6,6 +6,7 @@
 config AMD_PMF
 	tristate "AMD Platform Management Framework"
 	depends on ACPI && PCI
+	depends on POWER_SUPPLY
 	select ACPI_PLATFORM_PROFILE
 	help
 	  This driver provides support for the AMD Platform Management Framework.
diff --git a/drivers/platform/x86/nvidia-wmi-ec-backlight.c b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
index baccdf658538..1b572c90c76e 100644
--- a/drivers/platform/x86/nvidia-wmi-ec-backlight.c
+++ b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
@@ -12,6 +12,10 @@
 #include <linux/wmi.h>
 #include <acpi/video.h>
 
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force loading (disable acpi_backlight=xxx checks");
+
 /**
  * wmi_brightness_notify() - helper function for calling WMI-wrapped ACPI method
  * @w:    Pointer to the struct wmi_device identified by %WMI_BRIGHTNESS_GUID
@@ -91,7 +95,7 @@ static int nvidia_wmi_ec_backlight_probe(struct wmi_device *wdev, const void *ct
 	int ret;
 
 	/* drivers/acpi/video_detect.c also checks that SOURCE == EC */
-	if (acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
+	if (!force && acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
 		return -ENODEV;
 
 	/*
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 02fa3c00dccc..a8142e2b9643 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1708,13 +1708,15 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 		return rc;
 	}
 
+	/* Remote phy */
 	if (rc)
 		return rc;
 
-	/* Remote phy */
 	if (dev_is_sata(device)) {
-		rc = sas_ata_wait_after_reset(device,
-					HISI_SAS_WAIT_PHYUP_TIMEOUT);
+		struct ata_link *link = &device->sata_dev.ap->link;
+
+		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
 	}
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d35c9296f738..2fd55ef9ffca 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -287,6 +287,31 @@ static int sas_ata_clear_pending(struct domain_device *dev, struct ex_phy *phy)
 		return 1;
 }
 
+int smp_ata_check_ready_type(struct ata_link *link)
+{
+	struct domain_device *dev = link->ap->private_data;
+	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct domain_device *ex_dev = dev->parent;
+	enum sas_device_type type = SAS_PHY_UNUSED;
+	u8 sas_addr[SAS_ADDR_SIZE];
+	int res;
+
+	res = sas_get_phy_attached_dev(ex_dev, phy->number, sas_addr, &type);
+	sas_put_local_phy(phy);
+	if (res)
+		return res;
+
+	switch (type) {
+	case SAS_SATA_PENDING:
+		return 0;
+	case SAS_END_DEVICE:
+		return 1;
+	default:
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL_GPL(smp_ata_check_ready_type);
+
 static int smp_ata_check_ready(struct ata_link *link)
 {
 	int res;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5ce251830104..63a23251fb1d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1693,8 +1693,8 @@ static int sas_get_phy_change_count(struct domain_device *dev,
 	return res;
 }
 
-static int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
-				    u8 *sas_addr, enum sas_device_type *type)
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type)
 {
 	int res;
 	struct smp_disc_resp *disc_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 8d0ad3abc7b5..a94bd0790b05 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -84,6 +84,8 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 			    struct smp_rps_resp *rps_resp);
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 void sas_hae_reset(struct work_struct *work);
 
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index d6aff909fc36..9eab6c20dbc5 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1192,11 +1192,6 @@ static int mtk_spi_probe(struct platform_device *pdev)
 	else
 		dma_set_max_seg_size(dev, SZ_256K);
 
-	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
-			       IRQF_TRIGGER_NONE, dev_name(dev), master);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to register irq\n");
-
 	mdata->parent_clk = devm_clk_get(dev, "parent-clk");
 	if (IS_ERR(mdata->parent_clk))
 		return dev_err_probe(dev, PTR_ERR(mdata->parent_clk),
@@ -1258,6 +1253,11 @@ static int mtk_spi_probe(struct platform_device *pdev)
 		dev_notice(dev, "SPI dma_set_mask(%d) failed, ret:%d\n",
 			   addr_bits, ret);
 
+	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
+			       IRQF_TRIGGER_NONE, dev_name(dev), master);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register irq\n");
+
 	pm_runtime_enable(dev);
 
 	ret = devm_spi_register_master(dev, master);
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d233c24ea342..e2b8b3437c58 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -491,6 +491,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -505,7 +510,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3dc5824141cd..7ad6f51b3d91 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -929,7 +929,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index c1e79f72cd89..9f0af4f116d9 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -11,6 +11,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 6e4372735068..14a1ebb74e11 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -177,6 +177,7 @@ struct psi_group {
 	struct timer_list poll_timer;
 	wait_queue_head_t poll_wait;
 	atomic_t poll_wakeup;
+	atomic_t poll_scheduled;
 
 	/* Protects data used by the monitor */
 	struct mutex trigger_lock;
diff --git a/include/linux/random.h b/include/linux/random.h
index bd954ecbef90..51133627ba73 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 #if IS_ENABLED(CONFIG_VMGENID)
 void add_vmfork_randomness(const void *unique_vm_id, size_t len);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index a1df4f9d57a3..ec646217e7f6 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -35,6 +35,7 @@ void sas_ata_end_eh(struct ata_port *ap);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int sas_ata_wait_after_reset(struct domain_device *dev, unsigned long deadline);
+int smp_ata_check_ready_type(struct ata_link *link);
 #else
 
 
@@ -98,6 +99,11 @@ static inline int sas_ata_wait_after_reset(struct domain_device *dev,
 {
 	return -ETIMEDOUT;
 }
+
+static inline int smp_ata_check_ready_type(struct ata_link *link)
+{
+	return 0;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 17ab3e15ac25..211f63e87c63 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -34,6 +34,7 @@
 #include <linux/log2.h>
 #include <linux/bpf_verifier.h>
 #include <linux/nodemask.h>
+#include <linux/nospec.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -1908,9 +1909,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 48fedeee15c5..e83c321461cf 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -189,6 +189,7 @@ static void group_init(struct psi_group *group)
 	INIT_DELAYED_WORK(&group->avgs_work, psi_avgs_work);
 	mutex_init(&group->avgs_lock);
 	/* Init trigger-related members */
+	atomic_set(&group->poll_scheduled, 0);
 	mutex_init(&group->trigger_lock);
 	INIT_LIST_HEAD(&group->triggers);
 	group->poll_min_period = U32_MAX;
@@ -565,18 +566,17 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 	return now + group->poll_min_period;
 }
 
-/* Schedule polling if it's not already scheduled. */
-static void psi_schedule_poll_work(struct psi_group *group, unsigned long delay)
+/* Schedule polling if it's not already scheduled or forced. */
+static void psi_schedule_poll_work(struct psi_group *group, unsigned long delay,
+				   bool force)
 {
 	struct task_struct *task;
 
 	/*
-	 * Do not reschedule if already scheduled.
-	 * Possible race with a timer scheduled after this check but before
-	 * mod_timer below can be tolerated because group->polling_next_update
-	 * will keep updates on schedule.
+	 * atomic_xchg should be called even when !force to provide a
+	 * full memory barrier (see the comment inside psi_poll_work).
 	 */
-	if (timer_pending(&group->poll_timer))
+	if (atomic_xchg(&group->poll_scheduled, 1) && !force)
 		return;
 
 	rcu_read_lock();
@@ -588,12 +588,15 @@ static void psi_schedule_poll_work(struct psi_group *group, unsigned long delay)
 	 */
 	if (likely(task))
 		mod_timer(&group->poll_timer, jiffies + delay);
+	else
+		atomic_set(&group->poll_scheduled, 0);
 
 	rcu_read_unlock();
 }
 
 static void psi_poll_work(struct psi_group *group)
 {
+	bool force_reschedule = false;
 	u32 changed_states;
 	u64 now;
 
@@ -601,6 +604,43 @@ static void psi_poll_work(struct psi_group *group)
 
 	now = sched_clock();
 
+	if (now > group->polling_until) {
+		/*
+		 * We are either about to start or might stop polling if no
+		 * state change was recorded. Resetting poll_scheduled leaves
+		 * a small window for psi_group_change to sneak in and schedule
+		 * an immediate poll_work before we get to rescheduling. One
+		 * potential extra wakeup at the end of the polling window
+		 * should be negligible and polling_next_update still keeps
+		 * updates correctly on schedule.
+		 */
+		atomic_set(&group->poll_scheduled, 0);
+		/*
+		 * A task change can race with the poll worker that is supposed to
+		 * report on it. To avoid missing events, ensure ordering between
+		 * poll_scheduled and the task state accesses, such that if the poll
+		 * worker misses the state update, the task change is guaranteed to
+		 * reschedule the poll worker:
+		 *
+		 * poll worker:
+		 *   atomic_set(poll_scheduled, 0)
+		 *   smp_mb()
+		 *   LOAD states
+		 *
+		 * task change:
+		 *   STORE states
+		 *   if atomic_xchg(poll_scheduled, 1) == 0:
+		 *     schedule poll worker
+		 *
+		 * The atomic_xchg() implies a full barrier.
+		 */
+		smp_mb();
+	} else {
+		/* Polling window is not over, keep rescheduling */
+		force_reschedule = true;
+	}
+
+
 	collect_percpu_times(group, PSI_POLL, &changed_states);
 
 	if (changed_states & group->poll_states) {
@@ -626,7 +666,8 @@ static void psi_poll_work(struct psi_group *group)
 		group->polling_next_update = update_triggers(group, now);
 
 	psi_schedule_poll_work(group,
-		nsecs_to_jiffies(group->polling_next_update - now) + 1);
+		nsecs_to_jiffies(group->polling_next_update - now) + 1,
+		force_reschedule);
 
 out:
 	mutex_unlock(&group->trigger_lock);
@@ -787,7 +828,7 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	write_seqcount_end(&groupc->seq);
 
 	if (state_mask & group->poll_states)
-		psi_schedule_poll_work(group, 1);
+		psi_schedule_poll_work(group, 1, false);
 
 	if (wake_clock && !delayed_work_pending(&group->avgs_work))
 		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
@@ -941,7 +982,7 @@ void psi_account_irqtime(struct task_struct *task, u32 delta)
 		write_seqcount_end(&groupc->seq);
 
 		if (group->poll_states & (1 << PSI_IRQ_FULL))
-			psi_schedule_poll_work(group, 1);
+			psi_schedule_poll_work(group, 1, false);
 	} while ((group = group->parent));
 }
 #endif
@@ -1328,6 +1369,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
 		 * can no longer be found through group->poll_task.
 		 */
 		kthread_stop(task_to_destroy);
+		atomic_set(&group->poll_scheduled, 0);
 	}
 	kfree(t);
 }
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 1505a52f23a0..d29fe29c6849 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -3,6 +3,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -12,6 +13,12 @@ unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		instrument_copy_from_user_before(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 		instrument_copy_from_user_after(to, from, n, res);
diff --git a/scripts/head-object-list.txt b/scripts/head-object-list.txt
index b16326a92c45..b074134cfac2 100644
--- a/scripts/head-object-list.txt
+++ b/scripts/head-object-list.txt
@@ -15,7 +15,6 @@ arch/alpha/kernel/head.o
 arch/arc/kernel/head.o
 arch/arm/kernel/head-nommu.o
 arch/arm/kernel/head.o
-arch/arm64/kernel/head.o
 arch/csky/kernel/head.o
 arch/hexagon/kernel/head.o
 arch/ia64/kernel/head.o
@@ -39,7 +38,6 @@ arch/powerpc/kernel/entry_64.o
 arch/powerpc/kernel/fpu.o
 arch/powerpc/kernel/vector.o
 arch/powerpc/kernel/prom_init.o
-arch/riscv/kernel/head.o
 arch/s390/kernel/head64.o
 arch/sh/kernel/head_32.o
 arch/sparc/kernel/head_32.o
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 53baa95cb644..0f295961e773 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -281,6 +281,9 @@ endmenu
 
 config CC_HAS_RANDSTRUCT
 	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
+	# Randstruct was first added in Clang 15, but it isn't safe to use until
+	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
 
 choice
 	prompt "Randomize layout of sensitive kernel structures"
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 2a5727188c8d..0668ec542ccc 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -428,6 +428,7 @@ static void *juggle_shinfo_state(void *arg)
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
+	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
 	pthread_t thread;
 	bool verbose;
@@ -942,6 +943,10 @@ int main(int argc, char *argv[])
 	}
 
  done:
+	evt_reset.type = KVM_XEN_ATTR_TYPE_EVTCHN;
+	evt_reset.u.evtchn.flags = KVM_XEN_EVTCHN_RESET;
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
+
 	alarm(0);
 	clock_gettime(CLOCK_REALTIME, &max_ts);
 
