Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87C06790E3
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjAXGaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjAXG3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:29:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFE33E086;
        Mon, 23 Jan 2023 22:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 232F8B810C5;
        Tue, 24 Jan 2023 06:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE9EC433EF;
        Tue, 24 Jan 2023 06:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541740;
        bh=kMvYqhgL7ME4IKDTU0on8sp2Fzw3tVFFIK1d7PcR3/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkxbYcOU33GogwQkwLhEZnZblLQAfWHZNPZrr2BHfih5HNbWdwvyASMaSAr/Zmqf5
         iqjYFtLnwbld28cFSj9XkGcCbcAH7C8s6uDbxmsIItZAudWkeM0z1og8QvG371p2cL
         KnSA4uLBSLdqcEgj8ZRFjUO2PsSzy0O6M/dsyLWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.90
Date:   Tue, 24 Jan 2023 07:28:49 +0100
Message-Id: <16745417296124@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167454172977219@kroah.com>
References: <167454172977219@kroah.com>
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

diff --git a/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
new file mode 100644
index 000000000000..ff86c87309a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb2-phy.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic G12A USB2 PHY
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,g12a-usb2-phy
+      - amlogic,a1-usb2-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: xtal
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 0
+
+  phy-supply:
+    description:
+      Phandle to a regulator that provides power to the PHY. This
+      regulator will be managed during the PHY power on/off sequence.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - "#phy-cells"
+
+if:
+  properties:
+    compatible:
+      enum:
+        - amlogic,meson-a1-usb-ctrl
+
+then:
+  properties:
+    power-domains:
+      maxItems: 1
+  required:
+    - power-domains
+
+additionalProperties: false
+
+examples:
+  - |
+    phy@36000 {
+          compatible = "amlogic,g12a-usb2-phy";
+          reg = <0x36000 0x2000>;
+          clocks = <&xtal>;
+          clock-names = "xtal";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <0>;
+    };
diff --git a/Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml
new file mode 100644
index 000000000000..84738644e398
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb3-pcie-phy.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic G12A USB3 + PCIE Combo PHY
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,g12a-usb3-pcie-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: ref_clk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - "#phy-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    phy@46000 {
+          compatible = "amlogic,g12a-usb3-pcie-phy";
+          reg = <0x46000 0x2000>;
+          clocks = <&ref_clk>;
+          clock-names = "ref_clk";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <1>;
+    };
diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
deleted file mode 100644
index 399ebde45409..000000000000
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ /dev/null
@@ -1,78 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-# Copyright 2019 BayLibre, SAS
-%YAML 1.2
----
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb2-phy.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
-
-title: Amlogic G12A USB2 PHY
-
-maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
-
-properties:
-  compatible:
-    enum:
-      - amlogic,meson-g12a-usb2-phy
-      - amlogic,meson-a1-usb2-phy
-
-  reg:
-    maxItems: 1
-
-  clocks:
-    maxItems: 1
-
-  clock-names:
-    items:
-      - const: xtal
-
-  resets:
-    maxItems: 1
-
-  reset-names:
-    items:
-      - const: phy
-
-  "#phy-cells":
-    const: 0
-
-  phy-supply:
-    description:
-      Phandle to a regulator that provides power to the PHY. This
-      regulator will be managed during the PHY power on/off sequence.
-
-required:
-  - compatible
-  - reg
-  - clocks
-  - clock-names
-  - resets
-  - reset-names
-  - "#phy-cells"
-
-if:
-  properties:
-    compatible:
-      enum:
-        - amlogic,meson-a1-usb-ctrl
-
-then:
-  properties:
-    power-domains:
-      maxItems: 1
-  required:
-    - power-domains
-
-additionalProperties: false
-
-examples:
-  - |
-    phy@36000 {
-          compatible = "amlogic,meson-g12a-usb2-phy";
-          reg = <0x36000 0x2000>;
-          clocks = <&xtal>;
-          clock-names = "xtal";
-          resets = <&phy_reset>;
-          reset-names = "phy";
-          #phy-cells = <0>;
-    };
diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
deleted file mode 100644
index 453c083cf44c..000000000000
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
+++ /dev/null
@@ -1,59 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-# Copyright 2019 BayLibre, SAS
-%YAML 1.2
----
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
-
-title: Amlogic G12A USB3 + PCIE Combo PHY
-
-maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
-
-properties:
-  compatible:
-    enum:
-      - amlogic,meson-g12a-usb3-pcie-phy
-
-  reg:
-    maxItems: 1
-
-  clocks:
-    maxItems: 1
-
-  clock-names:
-    items:
-      - const: ref_clk
-
-  resets:
-    maxItems: 1
-
-  reset-names:
-    items:
-      - const: phy
-
-  "#phy-cells":
-    const: 1
-
-required:
-  - compatible
-  - reg
-  - clocks
-  - clock-names
-  - resets
-  - reset-names
-  - "#phy-cells"
-
-additionalProperties: false
-
-examples:
-  - |
-    phy@46000 {
-          compatible = "amlogic,meson-g12a-usb3-pcie-phy";
-          reg = <0x46000 0x2000>;
-          clocks = <&ref_clk>;
-          clock-names = "ref_clk";
-          resets = <&phy_reset>;
-          reset-names = "phy";
-          #phy-cells = <1>;
-    };
diff --git a/Makefile b/Makefile
index 9ebe9ddb8641..028d23841df8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 89
+SUBLEVEL = 90
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index ad55079abe47..c5d4551a1be7 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -25,6 +25,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
+	spin_lock(&efi_rt_lock);					\
 })
 
 #define arch_efi_call_virt(p, f, args...)				\
@@ -36,10 +37,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
+	spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
+extern spinlock_t efi_rt_lock;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 75691a2641c1..2d3c4b02393e 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -4,6 +4,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 SYM_FUNC_START(__efi_rt_asm_wrapper)
 	stp	x29, x30, [sp, #-32]!
@@ -16,6 +17,12 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	 */
 	stp	x1, x18, [sp, #16]
 
+	ldr_l	x16, efi_rt_stack_top
+	mov	sp, x16
+#ifdef CONFIG_SHADOW_CALL_STACK
+	str	x18, [sp, #-16]!
+#endif
+
 	/*
 	 * We are lucky enough that no EFI runtime services take more than
 	 * 5 arguments, so all are passed in registers rather than via the
@@ -29,6 +36,7 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	mov	x4, x6
 	blr	x8
 
+	mov	sp, x29
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
 	ldp	x29, x30, [sp], #32
@@ -42,6 +50,10 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 	 * called with preemption disabled and a separate shadow stack is used
 	 * for interrupts.
 	 */
-	mov	x18, x2
+#ifdef CONFIG_SHADOW_CALL_STACK
+	ldr_l	x18, efi_rt_stack_top
+	ldr	x18, [x18, #-16]
+#endif
+
 	b	efi_handle_corrupted_x18	// tail call
 SYM_FUNC_END(__efi_rt_asm_wrapper)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index a908a37f0367..386bd81ca12b 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -144,3 +144,30 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
 	return s;
 }
+
+DEFINE_SPINLOCK(efi_rt_lock);
+
+asmlinkage u64 *efi_rt_stack_top __ro_after_init;
+
+/* EFI requires 8 KiB of stack space for runtime services */
+static_assert(THREAD_SIZE >= SZ_8K);
+
+static int __init arm64_efi_rt_init(void)
+{
+	void *p;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	p = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, GFP_KERNEL,
+			   NUMA_NO_NODE, &&l);
+l:	if (!p) {
+		pr_warn("Failed to allocate EFI runtime stack\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return -ENOMEM;
+	}
+
+	efi_rt_stack_top = p + THREAD_SIZE;
+	return 0;
+}
+core_initcall(arm64_efi_rt_init);
diff --git a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
index 454079a69ab4..f72bb158a7ab 100644
--- a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
@@ -328,7 +328,7 @@ pcie@e00000000 {
 			bus-range = <0x0 0xff>;
 			ranges = <0x81000000  0x0 0x60080000  0x0 0x60080000 0x0 0x10000>,      /* I/O */
 				 <0x82000000  0x0 0x60090000  0x0 0x60090000 0x0 0xff70000>,    /* mem */
-				 <0x82000000  0x0 0x70000000  0x0 0x70000000 0x0 0x1000000>,    /* mem */
+				 <0x82000000  0x0 0x70000000  0x0 0x70000000 0x0 0x10000000>,    /* mem */
 				 <0xc3000000 0x20 0x00000000 0x20 0x00000000 0x20 0x00000000>;  /* mem prefetchable */
 			num-lanes = <0x8>;
 			interrupts = <56>, <57>, <58>, <59>, <60>, <61>, <62>, <63>, <64>;
diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 77e3a47af5ad..840ee43e3e46 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -804,6 +804,8 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&model_hsx),
 	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&model_spr),
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 64e29927cc32..c949424a11c1 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,9 +138,6 @@ static void __init fpu__init_system_generic(void)
 unsigned int fpu_kernel_xstate_size __ro_after_init;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
-/* Get alignment of the TYPE. */
-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
-
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -148,8 +145,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
-					   TYPE_ALIGN(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) !=         \
+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:
diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index a1f9416bf67a..6ff2f56cb0f7 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -10,6 +10,6 @@
  */
 SYM_FUNC_START(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	RET
 SYM_FUNC_END(__iowrite32_copy)
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 950c46332a76..aaef5088a3ba 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -305,7 +305,7 @@ static inline int deadline_check_fifo(struct dd_per_prio *per_prio,
 /*
  * Check if rq has a sequential request preceding it.
  */
-static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+static bool deadline_is_seq_write(struct deadline_data *dd, struct request *rq)
 {
 	struct request *prev = deadline_earlier_request(rq);
 
@@ -364,7 +364,7 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
 		if (blk_req_can_dispatch_to_zone(rq) &&
 		    (blk_queue_nonrot(rq->q) ||
-		     !deadline_is_seq_writes(dd, rq)))
+		     !deadline_is_seq_write(dd, rq)))
 			goto out;
 	}
 	rq = NULL;
diff --git a/drivers/accessibility/speakup/spk_ttyio.c b/drivers/accessibility/speakup/spk_ttyio.c
index 08cf8a17754b..07373b3debd1 100644
--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -354,6 +354,9 @@ void spk_ttyio_release(struct spk_synth *in_synth)
 {
 	struct tty_struct *tty = in_synth->dev;
 
+	if (tty == NULL)
+		return;
+
 	tty_lock(tty);
 
 	if (tty->ops->close)
diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 89c22bc55057..09c0af8a46f0 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -219,6 +219,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
 	efi_status_t status;
 	struct prm_context_buffer context;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err_ratelimited("PRM: EFI runtime services no longer available\n");
+		return AE_NO_HANDLER;
+	}
+
 	/*
 	 * The returned acpi_status will always be AE_OK. Error values will be
 	 * saved in the first byte of the PRM message buffer to be used by ASL.
@@ -308,6 +313,11 @@ void __init init_prmt(void)
 
 	pr_info("PRM: found %u modules\n", mc);
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err("PRM: EFI runtime services unavailable\n");
+		return;
+	}
+
 	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
 						    ACPI_ADR_SPACE_PLATFORM_RT,
 						    &acpi_platformrt_space_handler,
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 5d0428fc854f..e45777b3f5da 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2156,10 +2156,17 @@ static void qca_serdev_shutdown(struct device *dev)
 	int timeout = msecs_to_jiffies(CMD_TRANS_TIMEOUT_MS);
 	struct serdev_device *serdev = to_serdev_device(dev);
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
+	struct hci_uart *hu = &qcadev->serdev_hu;
+	struct hci_dev *hdev = hu->hdev;
+	struct qca_data *qca = hu->priv;
 	const u8 ibs_wake_cmd[] = { 0xFD };
 	const u8 edl_reset_soc_cmd[] = { 0x01, 0x00, 0xFC, 0x01, 0x05 };
 
 	if (qcadev->btsoc_type == QCA_QCA6390) {
+		if (test_bit(QCA_BT_OFF, &qca->flags) ||
+		    !test_bit(HCI_RUNNING, &hdev->flags))
+			return;
+
 		serdev_device_write_flush(serdev);
 		ret = serdev_device_write_buf(serdev, ibs_wake_cmd,
 					      sizeof(ibs_wake_cmd));
diff --git a/drivers/comedi/drivers/adv_pci1760.c b/drivers/comedi/drivers/adv_pci1760.c
index 6de8ab97d346..d6934b6c436d 100644
--- a/drivers/comedi/drivers/adv_pci1760.c
+++ b/drivers/comedi/drivers/adv_pci1760.c
@@ -59,7 +59,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firmware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 48de8d2b32f2..41654b2f6c60 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -980,6 +980,11 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 
 	/* The bad descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 	/* Remove the completed descriptor from issued list */
 	list_del(&vd->node);
 
@@ -994,6 +999,7 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 	/* Try to restart the controller */
 	axi_chan_start_first_queued(chan);
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 11d3f2aede71..37b07c679c0e 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1248,8 +1248,7 @@ int __drv_enable_wq(struct idxd_wq *wq)
 	return 0;
 
 err_map_portal:
-	rc = idxd_wq_disable(wq, false);
-	if (rc < 0)
+	if (idxd_wq_disable(wq, false))
 		dev_dbg(dev, "wq %s disable failed\n", dev_name(wq_confdev(wq)));
 err:
 	return rc;
diff --git a/drivers/dma/lgm/lgm-dma.c b/drivers/dma/lgm/lgm-dma.c
index 9b9184f964be..1709d159af7e 100644
--- a/drivers/dma/lgm/lgm-dma.c
+++ b/drivers/dma/lgm/lgm-dma.c
@@ -914,7 +914,7 @@ static void ldma_dev_init(struct ldma_dev *d)
 	}
 }
 
-static int ldma_cfg_init(struct ldma_dev *d)
+static int ldma_parse_dt(struct ldma_dev *d)
 {
 	struct fwnode_handle *fwnode = dev_fwnode(d->dev);
 	struct ldma_port *p;
@@ -1661,10 +1661,6 @@ static int intel_ldma_probe(struct platform_device *pdev)
 		p->ldev = d;
 	}
 
-	ret = ldma_cfg_init(d);
-	if (ret)
-		return ret;
-
 	dma_dev->dev = &pdev->dev;
 
 	ch_mask = (unsigned long)d->channels_mask;
@@ -1675,6 +1671,10 @@ static int intel_ldma_probe(struct platform_device *pdev)
 			ldma_dma_init_v3X(j, d);
 	}
 
+	ret = ldma_parse_dt(d);
+	if (ret)
+		return ret;
+
 	dma_dev->device_alloc_chan_resources = ldma_alloc_chan_resources;
 	dma_dev->device_free_chan_resources = ldma_free_chan_resources;
 	dma_dev->device_terminate_all = ldma_terminate_all;
diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index d1dff3a29db5..f4f722eacee2 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -224,7 +224,7 @@ static int tegra_adma_init(struct tegra_adma *tdma)
 	int ret;
 
 	/* Clear any interrupts */
-	tdma_write(tdma, tdma->cdata->global_int_clear, 0x1);
+	tdma_write(tdma, tdma->cdata->ch_base_offset + tdma->cdata->global_int_clear, 0x1);
 
 	/* Assert soft reset */
 	tdma_write(tdma, ADMA_GLOBAL_SOFT_RESET, 0x1);
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index f3e54f6616f0..60075e0e4943 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -62,6 +62,7 @@ struct efi_runtime_work efi_rts_work;
 									\
 	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
 		pr_warn_once("EFI Runtime Services are disabled!\n");	\
+		efi_rts_work.status = EFI_DEVICE_ERROR;			\
 		goto exit;						\
 	}								\
 									\
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 4e2575dfeb90..871bedf533a8 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -361,9 +361,10 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 		memcpy(data, gsmi_dev.data_buf->start, *data_size);
 
 		/* All variables are have the following attributes */
-		*attr = EFI_VARIABLE_NON_VOLATILE |
-			EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			EFI_VARIABLE_RUNTIME_ACCESS;
+		if (attr)
+			*attr = EFI_VARIABLE_NON_VOLATILE |
+				EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				EFI_VARIABLE_RUNTIME_ACCESS;
 	}
 
 	spin_unlock_irqrestore(&gsmi_dev.lock, flags);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 0d998bc830c2..b5fe2c91f58c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 
+#include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/amdgpu_drm.h>
@@ -89,6 +90,8 @@ MODULE_FIRMWARE("amdgpu/yellow_carp_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 
+static const struct drm_driver amdgpu_kms_driver;
+
 const char *amdgpu_asic_name[] = {
 	"TAHITI",
 	"PITCAIRN",
@@ -3637,6 +3640,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	if (r)
 		return r;
 
+	/* Get rid of things like offb */
+	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
+	if (r)
+		return r;
+
 	/* doorbell bar mapping and doorbell index init*/
 	amdgpu_device_doorbell_init(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cabbf02eb054..4df888c7e2ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -23,7 +23,6 @@
  */
 
 #include <drm/amdgpu_drm.h>
-#include <drm/drm_aperture.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_vblank.h>
@@ -1936,10 +1935,10 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x73FF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 
 	/* Aldebaran */
-	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
+	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
 
 	/* CYAN_SKILLFISH */
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
@@ -2067,11 +2066,6 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	size = pci_resource_len(pdev, 0);
 	is_fw_fb = amdgpu_is_fw_framebuffer(base, size);
 
-	/* Get rid of things like offb */
-	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &amdgpu_kms_driver);
-	if (ret)
-		return ret;
-
 	adev = devm_drm_dev_alloc(&pdev->dev, &amdgpu_kms_driver, typeof(*adev), ddev);
 	if (IS_ERR(adev))
 		return PTR_ERR(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 6744427577b3..43e30b9a2e02 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -43,6 +43,17 @@
 #include "amdgpu_display.h"
 #include "amdgpu_ras.h"
 
+static void amdgpu_runtime_pm_quirk(struct amdgpu_device *adev)
+{
+	/*
+	 * Add below quirk on several sienna_cichlid cards to disable
+	 * runtime pm to fix EMI failures.
+	 */
+	if (((adev->pdev->device == 0x73A1) && (adev->pdev->revision == 0x00)) ||
+	    ((adev->pdev->device == 0x73BF) && (adev->pdev->revision == 0xCF)))
+		adev->runpm = false;
+}
+
 void amdgpu_unregister_gpu_instance(struct amdgpu_device *adev)
 {
 	struct amdgpu_gpu_instance *gpu_instance;
@@ -201,6 +212,9 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 		 */
 		if (adev->is_fw_fb)
 			adev->runpm = false;
+
+		amdgpu_runtime_pm_quirk(adev);
+
 		if (adev->runpm)
 			dev_info(adev->dev, "Using BACO for runtime pm\n");
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index b1d0cad00b2e..a0b1bf17cb74 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1510,8 +1510,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
-	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
+	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0ebabcc8827b..409739ee5ba0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5855,8 +5855,6 @@ static void fill_stream_properties_from_drm_display_mode(
 
 	timing_out->aspect_ratio = get_aspect_ratio(mode_in);
 
-	stream->output_color_space = get_output_color_space(timing_out);
-
 	stream->out_transfer_func->type = TF_TYPE_PREDEFINED;
 	stream->out_transfer_func->tf = TRANSFER_FUNCTION_SRGB;
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A) {
@@ -5867,6 +5865,8 @@ static void fill_stream_properties_from_drm_display_mode(
 			adjust_colour_depth_from_display_info(timing_out, info);
 		}
 	}
+
+	stream->output_color_space = get_output_color_space(timing_out);
 }
 
 static void fill_audio_info(struct audio_info *audio_info,
@@ -10789,8 +10789,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 		}
 
-		if (dm_old_con_state->abm_level !=
-		    dm_new_con_state->abm_level)
+		if (dm_old_con_state->abm_level != dm_new_con_state->abm_level ||
+		    dm_old_con_state->scaling != dm_new_con_state->scaling)
 			new_crtc_state->connectors_changed = true;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 9039fb134db5..f858ae68aa5f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -92,8 +92,8 @@ static const struct out_csc_color_matrix_type output_csc_matrix[] = {
 		{ 0xE00, 0xF349, 0xFEB7, 0x1000, 0x6CE, 0x16E3,
 				0x24F, 0x200, 0xFCCB, 0xF535, 0xE00, 0x1000} },
 	{ COLOR_SPACE_YCBCR2020_TYPE,
-		{ 0x1000, 0xF149, 0xFEB7, 0x0000, 0x0868, 0x15B2,
-				0x01E6, 0x0000, 0xFB88, 0xF478, 0x1000, 0x0000} },
+		{ 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
+				0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
 	{ COLOR_SPACE_YCBCR709_BLACK_TYPE,
 		{ 0x0000, 0x0000, 0x0000, 0x1000, 0x0000, 0x0000,
 				0x0000, 0x0200, 0x0000, 0x0000, 0x0000, 0x1000} },
diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 724e7b04f3b6..b97b4b3b85e0 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -1473,7 +1473,7 @@ static int skl_check_main_surface(struct intel_plane_state *plane_state)
 	u32 offset;
 	int ret;
 
-	if (w > max_width || w < min_width || h > max_height) {
+	if (w > max_width || w < min_width || h > max_height || h < 1) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "requested Y/RGB source size %dx%d outside limits (min: %dx1 max: %dx%d)\n",
 			    w, h, min_width, max_width, max_height);
diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 1ad7259fb1f0..0bba1c5baca0 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -401,7 +401,8 @@ static const struct intel_device_info ilk_m_info = {
 	.has_coherent_ggtt = true, \
 	.has_llc = 1, \
 	.has_rc6 = 1, \
-	.has_rc6p = 1, \
+	/* snb does support rc6p, but enabling it causes various issues */ \
+	.has_rc6p = 0, \
 	.has_rps = true, \
 	.dma_mask_size = 40, \
 	.ppgtt_type = INTEL_PPGTT_ALIASING, \
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index abccddeea1e3..152242e8f733 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -62,9 +62,6 @@ enum {
 	SRP_DEFAULT_CMD_SQ_SIZE = SRP_DEFAULT_QUEUE_SIZE - SRP_RSP_SQ_SIZE -
 				  SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_NO_REQ		= ~0U,
-	SRP_TAG_TSK_MGMT	= 1U << 31,
-
 	SRP_MAX_PAGES_PER_MR	= 512,
 
 	SRP_MAX_ADD_CDB_LEN	= 16,
@@ -79,6 +76,11 @@ enum {
 				  sizeof(struct srp_imm_buf),
 };
 
+enum {
+	SRP_TAG_NO_REQ		= ~0U,
+	SRP_TAG_TSK_MGMT	= BIT(31),
+};
+
 enum srp_target_state {
 	SRP_TARGET_SCANNING,
 	SRP_TARGET_LIVE,
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index cf5705776c4f..55e42ccaef43 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -247,6 +247,13 @@ static void fastrpc_free_map(struct kref *ref)
 		dma_buf_put(map->buf);
 	}
 
+	if (map->fl) {
+		spin_lock(&map->fl->lock);
+		list_del(&map->node);
+		spin_unlock(&map->fl->lock);
+		map->fl = NULL;
+	}
+
 	kfree(map);
 }
 
@@ -256,10 +263,12 @@ static void fastrpc_map_put(struct fastrpc_map *map)
 		kref_put(&map->refcount, fastrpc_free_map);
 }
 
-static void fastrpc_map_get(struct fastrpc_map *map)
+static int fastrpc_map_get(struct fastrpc_map *map)
 {
-	if (map)
-		kref_get(&map->refcount);
+	if (!map)
+		return -ENOENT;
+
+	return kref_get_unless_zero(&map->refcount) ? 0 : -ENOENT;
 }
 
 static int fastrpc_map_find(struct fastrpc_user *fl, int fd,
@@ -1114,12 +1123,7 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 	fl->init_mem = NULL;
 	fastrpc_buf_free(imem);
 err_alloc:
-	if (map) {
-		spin_lock(&fl->lock);
-		list_del(&map->node);
-		spin_unlock(&fl->lock);
-		fastrpc_map_put(map);
-	}
+	fastrpc_map_put(map);
 err:
 	kfree(args);
 
@@ -1196,10 +1200,8 @@ static int fastrpc_device_release(struct inode *inode, struct file *file)
 		fastrpc_context_put(ctx);
 	}
 
-	list_for_each_entry_safe(map, m, &fl->maps, node) {
-		list_del(&map->node);
+	list_for_each_entry_safe(map, m, &fl->maps, node)
 		fastrpc_map_put(map);
-	}
 
 	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
 		list_del(&buf->node);
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 15e8e2b322b1..609519571545 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -111,6 +111,8 @@
 
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
+#define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 5324b65d0d29..f2765d6b8c04 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -117,6 +117,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index c6111adf8c08..794702e34657 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -107,6 +107,7 @@
 #define ESDHC_TUNING_START_TAP_DEFAULT	0x1
 #define ESDHC_TUNING_START_TAP_MASK	0x7f
 #define ESDHC_TUNING_CMD_CRC_CHECK_DISABLE	(1 << 7)
+#define ESDHC_TUNING_STEP_DEFAULT	0x1
 #define ESDHC_TUNING_STEP_MASK		0x00070000
 #define ESDHC_TUNING_STEP_SHIFT		16
 
@@ -1346,7 +1347,7 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	struct cqhci_host *cq_host = host->mmc->cqe_private;
-	int tmp;
+	u32 tmp;
 
 	if (esdhc_is_usdhc(imx_data)) {
 		/*
@@ -1399,17 +1400,24 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 
 		if (imx_data->socdata->flags & ESDHC_FLAG_STD_TUNING) {
 			tmp = readl(host->ioaddr + ESDHC_TUNING_CTRL);
-			tmp |= ESDHC_STD_TUNING_EN |
-				ESDHC_TUNING_START_TAP_DEFAULT;
-			if (imx_data->boarddata.tuning_start_tap) {
-				tmp &= ~ESDHC_TUNING_START_TAP_MASK;
+			tmp |= ESDHC_STD_TUNING_EN;
+
+			/*
+			 * ROM code or bootloader may config the start tap
+			 * and step, unmask them first.
+			 */
+			tmp &= ~(ESDHC_TUNING_START_TAP_MASK | ESDHC_TUNING_STEP_MASK);
+			if (imx_data->boarddata.tuning_start_tap)
 				tmp |= imx_data->boarddata.tuning_start_tap;
-			}
+			else
+				tmp |= ESDHC_TUNING_START_TAP_DEFAULT;
 
 			if (imx_data->boarddata.tuning_step) {
-				tmp &= ~ESDHC_TUNING_STEP_MASK;
 				tmp |= imx_data->boarddata.tuning_step
 					<< ESDHC_TUNING_STEP_SHIFT;
+			} else {
+				tmp |= ESDHC_TUNING_STEP_DEFAULT
+					<< ESDHC_TUNING_STEP_SHIFT;
 			}
 
 			/* Disable the CMD CRC check for tuning, if not, need to
diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index ce6cb8be654e..032f2c03e8fb 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1483,9 +1483,11 @@ static int sunxi_mmc_remove(struct platform_device *pdev)
 	struct sunxi_mmc_host *host = mmc_priv(mmc);
 
 	mmc_remove_host(mmc);
-	pm_runtime_force_suspend(&pdev->dev);
-	disable_irq(host->irq);
-	sunxi_mmc_disable(host);
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev)) {
+		disable_irq(host->irq);
+		sunxi_mmc_disable(host);
+	}
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
 	mmc_free_host(mmc);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 3dceab45986d..1504856fafde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -617,6 +617,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
 	mutex_unlock(&dev->intf_state_mutex);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2af4c76bcf02..264bb3ec44a5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2251,28 +2251,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void rtl_wol_enable_rx(struct rtl8169_private *tp)
-{
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
-		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
-}
-
-static void rtl_prepare_power_down(struct rtl8169_private *tp)
-{
-	if (tp->dash_type != RTL_DASH_NONE)
-		return;
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_33)
-		rtl_ephy_write(tp, 0x19, 0xff64);
-
-	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
-		rtl_wol_enable_rx(tp);
-	}
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -2492,6 +2470,28 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 	rtl_wait_txrx_fifo_empty(tp);
 }
 
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
+		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
+			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+}
+
+static void rtl_prepare_power_down(struct rtl8169_private *tp)
+{
+	if (tp->dash_type != RTL_DASH_NONE)
+		return;
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		rtl_ephy_write(tp, 0x19, 0xff64);
+
+	if (device_may_wakeup(tp_to_dev(tp))) {
+		phy_speed_down(tp->phydev, false);
+		rtl_wol_enable_rx(tp);
+	}
+}
+
 static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
 {
 	u32 val = TX_DMA_BURST << TxDMAShift |
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f5f5a002fdcf..6d8a04217018 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1118,7 +1118,7 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
-	if (max_flowrings > 256) {
+	if (max_flowrings > 512) {
 		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
 		return -EIO;
 	}
diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 173427bbf916..8fd823b40f4b 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -317,9 +317,10 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 		goto out;
 	}
 
+	/* Protection domain is optional, it does not exist on older platforms */
 	ret = of_property_read_string_index(np, "qcom,protection-domain",
 					    1, &adev->service_path);
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINVAL) {
 		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
 		goto out;
 	}
diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index 59a9ce282a3b..04c4d6eeea19 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -47,10 +47,10 @@ mmc_fixed_1v8_io: fixedregulator@1 {
 		regulator-always-on;
 	};
 
-	palmbus: palmbus@1E000000 {
+	palmbus: palmbus@1e000000 {
 		compatible = "palmbus";
-		reg = <0x1E000000 0x100000>;
-		ranges = <0x0 0x1E000000 0x0FFFFF>;
+		reg = <0x1e000000 0x100000>;
+		ranges = <0x0 0x1e000000 0x0fffff>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -301,11 +301,11 @@ rstctrl: rstctrl {
 		#reset-cells = <1>;
 	};
 
-	sdhci: sdhci@1E130000 {
+	sdhci: sdhci@1e130000 {
 		status = "disabled";
 
 		compatible = "mediatek,mt7620-mmc";
-		reg = <0x1E130000 0x4000>;
+		reg = <0x1e130000 0x4000>;
 
 		bus-width = <4>;
 		max-frequency = <48000000>;
@@ -327,7 +327,7 @@ sdhci: sdhci@1E130000 {
 		interrupts = <GIC_SHARED 20 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
-	xhci: xhci@1E1C0000 {
+	xhci: xhci@1e1c0000 {
 		status = "okay";
 
 		compatible = "mediatek,mt8173-xhci";
diff --git a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
index 81db7fb76d6d..97893bb0a0fd 100644
--- a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
+++ b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
@@ -82,7 +82,7 @@ struct vchiq_service_params_kernel {
 
 struct vchiq_instance;
 
-extern enum vchiq_status vchiq_initialise(struct vchiq_instance **pinstance);
+extern int vchiq_initialise(struct vchiq_instance **pinstance);
 extern enum vchiq_status vchiq_shutdown(struct vchiq_instance *instance);
 extern enum vchiq_status vchiq_connect(struct vchiq_instance *instance);
 extern enum vchiq_status vchiq_open_service(struct vchiq_instance *instance,
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
index e8e39a154c74..69f342e9bb7a 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
@@ -152,10 +152,10 @@ extern struct vchiq_arm_state*
 vchiq_platform_get_arm_state(struct vchiq_state *state);
 
 
-extern enum vchiq_status
+extern int
 vchiq_use_internal(struct vchiq_state *state, struct vchiq_service *service,
 		   enum USE_TYPE_E use_type);
-extern enum vchiq_status
+extern int
 vchiq_release_internal(struct vchiq_state *state,
 		       struct vchiq_service *service);
 
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 500a0afe3073..42cc4ef02e86 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1262,7 +1262,7 @@ static void tb_usb3_reclaim_available_bandwidth(struct tb_tunnel *tunnel,
 		return;
 	} else if (!ret) {
 		/* Use maximum link rate if the link valid is not set */
-		ret = usb4_usb3_port_max_link_rate(tunnel->src_port);
+		ret = tb_usb3_max_link_rate(tunnel->dst_port, tunnel->src_port);
 		if (ret < 0) {
 			tb_tunnel_warn(tunnel, "failed to read maximum link rate\n");
 			return;
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7c8515f83f0a..b91fe25a64a1 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1472,6 +1472,10 @@ static bool pl011_tx_chars(struct uart_amba_port *uap, bool from_irq)
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count = uap->fifosize >> 1;
 
+	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
+	    !uap->rs485_tx_started)
+		pl011_rs485_tx_start(uap);
+
 	if (uap->port.x_char) {
 		if (!pl011_tx_char(uap, uap->port.x_char, from_irq))
 			return true;
@@ -1483,10 +1487,6 @@ static bool pl011_tx_chars(struct uart_amba_port *uap, bool from_irq)
 		return false;
 	}
 
-	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
-	    !uap->rs485_tx_started)
-		pl011_rs485_tx_start(uap);
-
 	/* If we are using DMA mode, try to send some characters. */
 	if (pl011_dma_tx_irq(uap))
 		return true;
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c0a86558ceaa..714e6ff4a8fb 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2615,13 +2615,7 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	else if (mr == ATMEL_US_PAR_ODD)
 		*parity = 'o';
 
-	/*
-	 * The serial core only rounds down when matching this to a
-	 * supported baud rate. Make sure we don't end up slightly
-	 * lower than one of those, as it would make us fall through
-	 * to a much lower baud rate than we really want.
-	 */
-	*baud = port->uartclk / (16 * (quot - 1));
+	*baud = port->uartclk / (16 * quot);
 }
 
 static int __init atmel_console_setup(struct console *co, char *options)
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 52cab2038da8..49bc5a4b2832 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -765,7 +765,7 @@ static void pch_dma_tx_complete(void *arg)
 	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;
diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index aedc38893e6c..ce1c81731a2a 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -866,9 +866,10 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
+static int setup_fifos(struct qcom_geni_serial_port *port)
 {
 	struct uart_port *uport;
+	u32 old_rx_fifo_depth = port->rx_fifo_depth;
 
 	uport = &port->uport;
 	port->tx_fifo_depth = geni_se_get_tx_fifo_depth(&port->se);
@@ -876,6 +877,16 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
 	port->rx_fifo_depth = geni_se_get_rx_fifo_depth(&port->se);
 	uport->fifosize =
 		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
+
+	if (port->rx_fifo && (old_rx_fifo_depth != port->rx_fifo_depth) && port->rx_fifo_depth) {
+		port->rx_fifo = devm_krealloc(uport->dev, port->rx_fifo,
+					      port->rx_fifo_depth * sizeof(u32),
+					      GFP_KERNEL);
+		if (!port->rx_fifo)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 
@@ -890,6 +901,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	u32 rxstale = DEFAULT_BITS_PER_CHAR * STALE_TIMEOUT;
 	u32 proto;
 	u32 pin_swap;
+	int ret;
 
 	proto = geni_se_read_proto(&port->se);
 	if (proto != GENI_SE_UART) {
@@ -899,7 +911,9 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 
 	qcom_geni_serial_stop_rx(uport);
 
-	get_tx_fifo_size(port);
+	ret = setup_fifos(port);
+	if (ret)
+		return ret;
 
 	writel(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
 
diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 1802f6818e63..924c2793c732 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2610,6 +2610,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	u8 req_on_hw_ring = 0;
 	unsigned long flags;
 	int ret = 0;
+	int val;
 
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
@@ -2645,6 +2646,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring && link_trb) {
+		/* Stop DMA */
+		writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
+
+		/* wait for DFLUSH cleared */
+		readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
+					  !(val & EP_CMD_DFLUSH), 1, 1000);
+
 		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE)));
 		link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
@@ -2656,6 +2664,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
 
+	req = cdns3_next_request(&priv_ep->pending_req_list);
+	if (req)
+		cdns3_rearm_transfer(priv_ep, 1);
+
 not_found:
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
 	return ret;
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 98bdae4ac314..d23ccace5ca2 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -43,6 +43,9 @@
 #define USB_PRODUCT_USB5534B			0x5534
 #define USB_VENDOR_CYPRESS			0x04b4
 #define USB_PRODUCT_CY7C65632			0x6570
+#define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
+#define USB_PRODUCT_TUSB8041_USB3		0x8140
+#define USB_PRODUCT_TUSB8041_USB2		0x8142
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5791,6 +5794,16 @@ static const struct usb_device_id hub_id_table[] = {
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_CHECK_PORT_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB2,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB3,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_DEV_CLASS,
       .bDeviceClass = USB_CLASS_HUB},
     { .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 50b2fc7fcc0e..8751276ef578 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -37,6 +37,71 @@ bool usb_acpi_power_manageable(struct usb_device *hdev, int index)
 }
 EXPORT_SYMBOL_GPL(usb_acpi_power_manageable);
 
+#define UUID_USB_CONTROLLER_DSM "ce2ee385-00e6-48cb-9f05-2edb927c4899"
+#define USB_DSM_DISABLE_U1_U2_FOR_PORT	5
+
+/**
+ * usb_acpi_port_lpm_incapable - check if lpm should be disabled for a port.
+ * @hdev: USB device belonging to the usb hub
+ * @index: zero based port index
+ *
+ * Some USB3 ports may not support USB3 link power management U1/U2 states
+ * due to different retimer setup. ACPI provides _DSM method which returns 0x01
+ * if U1 and U2 states should be disabled. Evaluate _DSM with:
+ * Arg0: UUID = ce2ee385-00e6-48cb-9f05-2edb927c4899
+ * Arg1: Revision ID = 0
+ * Arg2: Function Index = 5
+ * Arg3: (empty)
+ *
+ * Return 1 if USB3 port is LPM incapable, negative on error, otherwise 0
+ */
+
+int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index)
+{
+	union acpi_object *obj;
+	acpi_handle port_handle;
+	int port1 = index + 1;
+	guid_t guid;
+	int ret;
+
+	ret = guid_parse(UUID_USB_CONTROLLER_DSM, &guid);
+	if (ret)
+		return ret;
+
+	port_handle = usb_get_hub_port_acpi_handle(hdev, port1);
+	if (!port_handle) {
+		dev_dbg(&hdev->dev, "port-%d no acpi handle\n", port1);
+		return -ENODEV;
+	}
+
+	if (!acpi_check_dsm(port_handle, &guid, 0,
+			    BIT(USB_DSM_DISABLE_U1_U2_FOR_PORT))) {
+		dev_dbg(&hdev->dev, "port-%d no _DSM function %d\n",
+			port1, USB_DSM_DISABLE_U1_U2_FOR_PORT);
+		return -ENODEV;
+	}
+
+	obj = acpi_evaluate_dsm(port_handle, &guid, 0,
+				USB_DSM_DISABLE_U1_U2_FOR_PORT, NULL);
+
+	if (!obj)
+		return -ENODEV;
+
+	if (obj->type != ACPI_TYPE_INTEGER) {
+		dev_dbg(&hdev->dev, "evaluate port-%d _DSM failed\n", port1);
+		ACPI_FREE(obj);
+		return -EINVAL;
+	}
+
+	if (obj->integer.value == 0x01)
+		ret = 1;
+
+	ACPI_FREE(obj);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usb_acpi_port_lpm_incapable);
+
 /**
  * usb_acpi_set_power_state - control usb port's power via acpi power
  * resource
diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index dc8f078f918c..e0c183234283 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -83,7 +83,9 @@ static inline struct f_ncm *func_to_ncm(struct usb_function *f)
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static inline unsigned ncm_bitrate(struct usb_gadget *g)
 {
-	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+	if (!g)
+		return 0;
+	else if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
 		return 4250000000U;
 	else if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
 		return 3750000000U;
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 9e8b678f0548..ed28aaa82e25 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -229,6 +229,7 @@ static void put_ep (struct ep_data *data)
  */
 
 static const char *CHIP;
+static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
 
 /*----------------------------------------------------------------------*/
 
@@ -2013,13 +2014,20 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 {
 	struct inode	*inode;
 	struct dev_data	*dev;
+	int		rc;
 
-	if (the_device)
-		return -ESRCH;
+	mutex_lock(&sb_mutex);
+
+	if (the_device) {
+		rc = -ESRCH;
+		goto Done;
+	}
 
 	CHIP = usb_get_gadget_udc_name();
-	if (!CHIP)
-		return -ENODEV;
+	if (!CHIP) {
+		rc = -ENODEV;
+		goto Done;
+	}
 
 	/* superblock */
 	sb->s_blocksize = PAGE_SIZE;
@@ -2056,13 +2064,17 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 	 * from binding to a controller.
 	 */
 	the_device = dev;
-	return 0;
+	rc = 0;
+	goto Done;
 
-Enomem:
+ Enomem:
 	kfree(CHIP);
 	CHIP = NULL;
+	rc = -ENOMEM;
 
-	return -ENOMEM;
+ Done:
+	mutex_unlock(&sb_mutex);
+	return rc;
 }
 
 /* "mount -t gadgetfs path /dev/gadget" ends up here */
@@ -2084,6 +2096,7 @@ static int gadgetfs_init_fs_context(struct fs_context *fc)
 static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
+	mutex_lock(&sb_mutex);
 	kill_litter_super (sb);
 	if (the_device) {
 		put_dev (the_device);
@@ -2091,6 +2104,7 @@ gadgetfs_kill_sb (struct super_block *sb)
 	}
 	kfree(CHIP);
 	CHIP = NULL;
+	mutex_unlock(&sb_mutex);
 }
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
index 94e22867da1d..e9b5846b2322 100644
--- a/drivers/usb/gadget/legacy/webcam.c
+++ b/drivers/usb/gadget/legacy/webcam.c
@@ -293,6 +293,7 @@ static const struct uvc_descriptor_header * const uvc_fs_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -305,6 +306,7 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -317,6 +319,7 @@ static const struct uvc_descriptor_header * const uvc_ss_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 385be30baad3..e38dfbd0d9dd 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -29,7 +29,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 105f2b8dc1ba..7308b388c92b 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -78,9 +78,12 @@ static const char hcd_name[] = "xhci_hcd";
 static struct hc_driver __read_mostly xhci_pci_hc_driver;
 
 static int xhci_pci_setup(struct usb_hcd *hcd);
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags);
 
 static const struct xhci_driver_overrides xhci_pci_overrides __initconst = {
 	.reset = xhci_pci_setup,
+	.update_hub_device = xhci_pci_update_hub_device,
 };
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -353,8 +356,38 @@ static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev)
 				NULL);
 	ACPI_FREE(obj);
 }
+
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev)
+{
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct xhci_hub *rhub = &xhci->usb3_rhub;
+	int ret;
+	int i;
+
+	/* This is not the usb3 roothub we are looking for */
+	if (hcd != rhub->hcd)
+		return;
+
+	if (hdev->maxchild > rhub->num_ports) {
+		dev_err(&hdev->dev, "USB3 roothub port number mismatch\n");
+		return;
+	}
+
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_acpi_port_lpm_incapable(hdev, i);
+
+		dev_dbg(&hdev->dev, "port-%d disable U1/U2 _DSM: %d\n", i + 1, ret);
+
+		if (ret >= 0) {
+			rhub->ports[i]->lpm_incapable = ret;
+			continue;
+		}
+	}
+}
+
 #else
 static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev) { }
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev) { }
 #endif /* CONFIG_ACPI */
 
 /* called during probe() after chip reset completes */
@@ -387,6 +420,16 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	return xhci_pci_reinit(xhci, pdev);
 }
 
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags)
+{
+	/* Check if acpi claims some USB3 roothub ports are lpm incapable */
+	if (!hdev->parent)
+		xhci_find_lpm_incapable_ports(hcd, hdev);
+
+	return xhci_update_hub_device(hcd, hdev, tt, mem_flags);
+}
+
 /*
  * We need to register our own PCI probe function (instead of the USB core's
  * function) in order to create a second roothub under xHCI.
@@ -456,6 +499,8 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 90bf5d57b1a9..220d836428d2 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1178,7 +1178,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep;
 	struct xhci_ring *ring;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	if ((ep->ep_state & EP_HAS_STREAMS) ||
 			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
 		int stream_id;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3636fa49285c..a982b5346764 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3962,6 +3962,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -3990,7 +3991,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	}
 	virt_dev->udev = NULL;
 	xhci_disable_slot(xhci, udev->slot_id);
+
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_free_virt_device(xhci, udev->slot_id);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
 }
 
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
@@ -5046,6 +5051,7 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -5059,6 +5065,13 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			!xhci->devs[udev->slot_id])
 		return USB3_LPM_DISABLED;
 
+	/* If connected to root port then check port can handle lpm */
+	if (udev->parent && !udev->parent->parent) {
+		port = xhci->usb3_rhub.ports[udev->portnum - 1];
+		if (port->lpm_incapable)
+			return USB3_LPM_DISABLED;
+	}
+
 	hub_encoded_timeout = xhci_calculate_lpm_timeout(hcd, udev, state);
 	mel = calculate_max_exit_latency(udev, state, hub_encoded_timeout);
 	if (mel < 0) {
@@ -5118,7 +5131,7 @@ static int xhci_disable_usb3_lpm_timeout(struct usb_hcd *hcd,
 /* Once a hub descriptor is fetched for a device, we need to update the xHC's
  * internal data structures for the device.
  */
-static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 			struct usb_tt *tt, gfp_t mem_flags)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -5218,6 +5231,7 @@ static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 	xhci_free_command(xhci, config_cmd);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xhci_update_hub_device);
 
 static int xhci_get_frame(struct usb_hcd *hcd)
 {
@@ -5495,6 +5509,8 @@ void xhci_init_driver(struct hc_driver *drv,
 			drv->check_bandwidth = over->check_bandwidth;
 		if (over->reset_bandwidth)
 			drv->reset_bandwidth = over->reset_bandwidth;
+		if (over->update_hub_device)
+			drv->update_hub_device = over->update_hub_device;
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_init_driver);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 4193427a7f0d..b8ad9676312b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1737,6 +1737,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {
@@ -1948,6 +1949,8 @@ struct xhci_driver_overrides {
 			     struct usb_host_endpoint *ep);
 	int (*check_bandwidth)(struct usb_hcd *, struct usb_device *);
 	void (*reset_bandwidth)(struct usb_hcd *, struct usb_device *);
+	int (*update_hub_device)(struct usb_hcd *hcd, struct usb_device *hdev,
+			    struct usb_tt *tt, gfp_t mem_flags);
 };
 
 #define	XHCI_CFC_DELAY		10
@@ -2104,6 +2107,8 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 		       struct usb_host_endpoint *ep);
 int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+			   struct usb_tt *tt, gfp_t mem_flags);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
 int xhci_ext_cap_init(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 988a8c02e7e2..b421f1326087 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -814,7 +814,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 9bb20779f156..fbdebf7e5502 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -60,6 +60,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0908, 0x0070) }, /* Siemens SCALANCE LPE-9000 USB Serial Console */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dee79c7d82d5..6b69d05e2fb0 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -255,10 +255,16 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM05G			0x030a
 #define QUECTEL_PRODUCT_EM060K			0x030b
+#define QUECTEL_PRODUCT_EM05G_CS		0x030c
+#define QUECTEL_PRODUCT_EM05CN_SG		0x0310
 #define QUECTEL_PRODUCT_EM05G_SG		0x0311
+#define QUECTEL_PRODUCT_EM05CN			0x0312
+#define QUECTEL_PRODUCT_EM05G_GR		0x0313
+#define QUECTEL_PRODUCT_EM05G_RS		0x0314
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_RM520N			0x0801
+#define QUECTEL_PRODUCT_EC200U			0x0901
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
 #define QUECTEL_PRODUCT_RM500K			0x7001
@@ -1159,8 +1165,18 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05CN, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05CN_SG, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_GR, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_CS, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_RS, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_SG, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0x00, 0x40) },
@@ -1180,6 +1196,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 3f720faa6f97..d73282c0ec50 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -116,6 +116,19 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
 		flags |= US_FL_NO_ATA_1X;
 
+	/*
+	 * RTL9210-based enclosure from HIKSEMI, MD202 reportedly have issues
+	 * with UAS.  This isn't distinguishable with just idVendor and
+	 * idProduct, use manufacturer and product too.
+	 *
+	 * Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bda &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x9210 &&
+			(udev->manufacturer && !strcmp(udev->manufacturer, "HIKSEMI")) &&
+			(udev->product && !strcmp(udev->product, "MD202")))
+		flags |= US_FL_IGNORE_UAS;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 251778d14e2d..c7b763d6d102 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,13 +83,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
-/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
-UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
-		"Hiksemi",
-		"External HDD",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
-
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 998c1e3e318e..ff3038047d38 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -418,6 +418,18 @@ static const char * const pin_assignments[] = {
 	[DP_PIN_ASSIGN_F] = "F",
 };
 
+/*
+ * Helper function to extract a peripheral's currently supported
+ * Pin Assignments from its DisplayPort alternate mode state.
+ */
+static u8 get_current_pin_assignments(struct dp_altmode *dp)
+{
+	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
+		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
+	else
+		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
+}
+
 static ssize_t
 pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t size)
@@ -444,10 +456,7 @@ pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		goto out_unlock;
 	}
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	if (!(DP_CONF_GET_PIN_ASSIGN(conf) & assignments)) {
 		ret = -EINVAL;
@@ -484,10 +493,7 @@ static ssize_t pin_assignment_show(struct device *dev,
 
 	cur = get_count_order(DP_CONF_GET_PIN_ASSIGN(dp->data.conf));
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	for (i = 0; assignments; assignments >>= 1, i++) {
 		if (assignments & 1) {
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 984a13a9efc2..ee461d314927 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4527,14 +4527,13 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case DR_SWAP_CHANGE_DR:
-		if (port->data_role == TYPEC_HOST) {
-			tcpm_unregister_altmodes(port);
+		tcpm_unregister_altmodes(port);
+		if (port->data_role == TYPEC_HOST)
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_DEVICE);
-		} else {
+		else
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_HOST);
-		}
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index e7d2d5b7e125..3467c75f310a 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1251,6 +1251,9 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (config->config_size > PAGE_SIZE)
 		return false;
 
+	if (config->vq_num > 0xffff)
+		return false;
+
 	if (!device_is_allowed(config->device_id))
 		return false;
 
diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index d43b081d592f..db84a662e8de 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -1538,22 +1538,28 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 	unsigned long flags;
-	struct dsi_irq_stats stats;
+	struct dsi_irq_stats *stats;
+
+	stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats) {
+		seq_printf(s, "out of memory\n");
+		return;
+	}
 
 	spin_lock_irqsave(&dsi->irq_stats_lock, flags);
 
-	stats = dsi->irq_stats;
+	*stats = dsi->irq_stats;
 	memset(&dsi->irq_stats, 0, sizeof(dsi->irq_stats));
 	dsi->irq_stats.last_reset = jiffies;
 
 	spin_unlock_irqrestore(&dsi->irq_stats_lock, flags);
 
 	seq_printf(s, "period %u ms\n",
-			jiffies_to_msecs(jiffies - stats.last_reset));
+			jiffies_to_msecs(jiffies - stats->last_reset));
 
-	seq_printf(s, "irqs %d\n", stats.irq_count);
+	seq_printf(s, "irqs %d\n", stats->irq_count);
 #define PIS(x) \
-	seq_printf(s, "%-20s %10d\n", #x, stats.dsi_irqs[ffs(DSI_IRQ_##x)-1])
+	seq_printf(s, "%-20s %10d\n", #x, stats->dsi_irqs[ffs(DSI_IRQ_##x)-1])
 
 	seq_printf(s, "-- DSI%d interrupts --\n", dsi->module_id + 1);
 	PIS(VC0);
@@ -1577,10 +1583,10 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d %10d %10d %10d\n", #x, \
-			stats.vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
+			stats->vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
 
 	seq_printf(s, "-- VC interrupts --\n");
 	PIS(CS);
@@ -1596,7 +1602,7 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1620,6 +1626,8 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 	PIS(ULPSACTIVENOT_ALL0);
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
+
+	kfree(stats);
 }
 
 static void dsi1_dump_irqs(struct seq_file *s)
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 30654d3a0b41..a274261f36d6 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -196,7 +196,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	int err;
 
 	if (index >= vp_modern_get_num_queues(mdev))
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EINVAL);
 
 	/* Check if queue is either not available or already active. */
 	num = vp_modern_get_queue_size(mdev, index);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2c80fc902f59..ce2da06c9d7b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -380,7 +380,14 @@ static int csum_one_extent_buffer(struct extent_buffer *eb)
 	btrfs_print_tree(eb, 0);
 	btrfs_err(fs_info, "block=%llu write time tree block corruption detected",
 		  eb->start);
-	WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+	/*
+	 * Be noisy if this is an extent buffer from a log tree. We don't abort
+	 * a transaction in case there's a bad log tree extent buffer, we just
+	 * fallback to a transaction commit. Still we want to know when there is
+	 * a bad log tree extent buffer, as that may signal a bug somewhere.
+	 */
+	WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG) ||
+		btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e72973f7c2cd..750c1ff9947d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1717,6 +1717,11 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		BUG();
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
+	if (ret < 0)
+		btrfs_err(trans->fs_info,
+"failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
+			  node->bytenr, node->num_bytes, node->type,
+			  node->action, node->ref_mod, ret);
 	return ret;
 }
 
@@ -1955,8 +1960,6 @@ static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
 		if (ret) {
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			btrfs_put_delayed_ref(ref);
-			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
-				    ret);
 			return ret;
 		}
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 485abe7faeab..fc40159197f7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3286,6 +3286,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	int err = -ENOMEM;
 	int ret = 0;
 	bool stopped = false;
+	bool did_leaf_rescans = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3306,6 +3307,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 
 		err = qgroup_rescan_leaf(trans, path);
+		did_leaf_rescans = true;
 
 		if (err > 0)
 			btrfs_commit_transaction(trans);
@@ -3326,16 +3328,23 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	/*
-	 * only update status, since the previous part has already updated the
-	 * qgroup info.
+	 * Only update status, since the previous part has already updated the
+	 * qgroup info, and only if we did any actual work. This also prevents
+	 * race with a concurrent quota disable, which has already set
+	 * fs_info->quota_root to NULL and cleared BTRFS_FS_QUOTA_ENABLED at
+	 * btrfs_quota_disable().
 	 */
-	trans = btrfs_start_transaction(fs_info->quota_root, 1);
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+	if (did_leaf_rescans) {
+		trans = btrfs_start_transaction(fs_info->quota_root, 1);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			trans = NULL;
+			btrfs_err(fs_info,
+				  "fail to start transaction for status update: %d",
+				  err);
+		}
+	} else {
 		trans = NULL;
-		btrfs_err(fs_info,
-			  "fail to start transaction for status update: %d",
-			  err);
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 727289658730..7c0c6fc0c536 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3141,7 +3141,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		ret = 0;
 	if (ret) {
 		blk_finish_plug(&plug);
-		btrfs_abort_transaction(trans, ret);
 		btrfs_set_log_full_commit(trans);
 		mutex_unlock(&root->log_mutex);
 		goto out;
@@ -3273,7 +3272,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out_wake_log_root;
 	} else if (ret) {
 		btrfs_set_log_full_commit(trans);
-		btrfs_abort_transaction(trans, ret);
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
 	}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c0ea2813978b..f51fea2e808d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3999,12 +3999,15 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+				 .rq_nvec = 1, };
+
+	if (rdata->got_bytes) {
+		rqst.rq_pages = rdata->pages;
+		rqst.rq_offset = rdata->page_offset;
+		rqst.rq_npages = rdata->nr_pages;
+		rqst.rq_pagesz = rdata->pagesz;
+		rqst.rq_tailsz = rdata->tailsz;
+	}
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",
diff --git a/fs/eventfd.c b/fs/eventfd.c
index c0ffee99ad23..249ca6c0b784 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,21 +43,7 @@ struct eventfd_ctx {
 	int id;
 };
 
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- * @n: [in] Value of the counter to be added to the eventfd internal counter.
- *          The value cannot be negative.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.  This will be less
- * than @n if the counter has overflowed.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask)
 {
 	unsigned long flags;
 
@@ -78,12 +64,31 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
+
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ *
+ * Returns the amount by which the counter was incremented.  This will be less
+ * than @n if the counter has overflowed.
+ */
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+{
+	return eventfd_signal_mask(ctx, n, 0);
+}
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cf326c53db0f..1ec197825544 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -484,7 +484,8 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
 	struct eventpoll *ep_src;
 	unsigned long flags;
@@ -515,16 +516,17 @@ static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
 	}
 	spin_lock_irqsave_nested(&ep->poll_wait.lock, flags, nests);
 	ep->nests = nests + 1;
-	wake_up_locked_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_locked_poll(&ep->poll_wait, EPOLLIN | pollflags);
 	ep->nests = 0;
 	spin_unlock_irqrestore(&ep->poll_wait.lock, flags);
 }
 
 #else
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
-	wake_up_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_poll(&ep->poll_wait, EPOLLIN | pollflags);
 }
 
 #endif
@@ -735,7 +737,7 @@ static void ep_free(struct eventpoll *ep)
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1201,7 +1203,7 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING_WAKE);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1546,7 +1548,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
@@ -1622,7 +1624,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 761fd42c93f2..6a9ab5c11939 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -415,7 +415,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	struct extent_node *en;
 	bool ret = false;
 
-	f2fs_bug_on(sbi, !et);
+	if (!et)
+		return false;
 
 	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
 
diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index d2103852475f..45eec08ec904 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -783,6 +783,12 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 	return &fl->generic_hdr;
 }
 
+static bool
+filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
+{
+	return flseg->num_fh > 1;
+}
+
 /*
  * filelayout_pg_test(). Called by nfs_can_coalesce_requests()
  *
@@ -803,6 +809,8 @@ filelayout_pg_test(struct nfs_pageio_descriptor *pgio, struct nfs_page *prev,
 	size = pnfs_generic_pg_test(pgio, prev, req);
 	if (!size)
 		return 0;
+	else if (!filelayout_lseg_is_striped(FILELAYOUT_LSEG(pgio->pg_lseg)))
+		return size;
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 2301b57ca17f..def9121a466e 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -480,9 +480,18 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 	ret = nilfs_btnode_submit_block(btnc, ptr, 0, REQ_OP_READ, 0, &bh,
 					&submit_ptr);
 	if (ret) {
-		if (ret != -EEXIST)
-			return ret;
-		goto out_check;
+		if (likely(ret == -EEXIST))
+			goto out_check;
+		if (ret == -ENOENT) {
+			/*
+			 * Block address translation failed due to invalid
+			 * value of 'ptr'.  In this case, return internal code
+			 * -EINVAL (broken bmap) to notify bmap layer of fatal
+			 * metadata corruption.
+			 */
+			ret = -EINVAL;
+		}
+		return ret;
 	}
 
 	if (ra) {
diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 42af83bcaf13..321d55b3ca17 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1967,7 +1967,7 @@ int attr_punch_hole(struct ntfs_inode *ni, u64 vbo, u64 bytes, u32 *frame_size)
 		return -ENOENT;
 
 	if (!attr_b->non_res) {
-		u32 data_size = le32_to_cpu(attr->res.data_size);
+		u32 data_size = le32_to_cpu(attr_b->res.data_size);
 		u32 from, to;
 
 		if (vbo > data_size)
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 85a98590b6ef..d3e182c1a128 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -402,6 +402,10 @@ static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 			data_size = zonefs_check_zone_condition(inode, zone,
 								false, false);
 		}
+	} else if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO &&
+		   data_size > isize) {
+		/* Do not expose garbage data */
+		data_size = isize;
 	}
 
 	/*
@@ -765,6 +769,24 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 
 	ret = submit_bio_wait(bio);
 
+	/*
+	 * If the file zone was written underneath the file system, the zone
+	 * write pointer may not be where we expect it to be, but the zone
+	 * append write can still succeed. So check manually that we wrote where
+	 * we intended to, that is, at zi->i_wpoffset.
+	 */
+	if (!ret) {
+		sector_t wpsector =
+			zi->i_zsector + (zi->i_wpoffset >> SECTOR_SHIFT);
+
+		if (bio->bi_iter.bi_sector != wpsector) {
+			zonefs_warn(inode->i_sb,
+				"Corrupted write pointer %llu for zone at %llu\n",
+				wpsector, zi->i_zsector);
+			ret = -EIO;
+		}
+	}
+
 	zonefs_file_write_dio_end_io(iocb, size, ret, 0);
 	trace_zonefs_file_dio_append(inode, size, ret);
 
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3cd202d3eefb..36a486505b08 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -40,6 +40,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -66,6 +67,12 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	return -ENOSYS;
 }
 
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
+				      unsigned mask)
+{
+	return -ENOSYS;
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index da1329b85329..89f58d070470 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -749,11 +749,14 @@ extern struct device *usb_intf_get_dma_device(struct usb_interface *intf);
 extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable);
 extern bool usb_acpi_power_manageable(struct usb_device *hdev, int index);
+extern int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index);
 #else
 static inline int usb_acpi_set_power_state(struct usb_device *hdev, int index,
 	bool enable) { return 0; }
 static inline bool usb_acpi_power_manageable(struct usb_device *hdev, int index)
 	{ return true; }
+static inline int usb_acpi_port_lpm_incapable(struct usb_device *hdev, int index)
+	{ return 0; }
 #endif
 
 /* USB autosuspend and autoresume */
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8f58fd95efc7..9271b5dfae4c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -96,7 +96,7 @@ struct btrfs_space_info;
 	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
 	EM( FLUSH_DELALLOC_FULL,	"FLUSH_DELALLOC_FULL")		\
 	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
-	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
+	EM( FLUSH_DELAYED_REFS,		"FLUSH_DELAYED_REFS")		\
 	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
 	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
 	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index a77b690709cc..7f0b91dfb532 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -479,7 +479,7 @@ static struct trace_event_functions trace_event_type_funcs_##call = {	\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+#define ALIGN_STRUCTFIELD(type) ((int)(__alignof__(struct {type b;})))
 
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..e687658843b1 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -41,6 +41,12 @@
 #define EPOLLMSG	(__force __poll_t)0x00000400
 #define EPOLLRDHUP	(__force __poll_t)0x00002000
 
+/*
+ * Internal flag - wakeup generated by io_uring, used to detect recursion back
+ * into the io_uring poll handler.
+ */
+#define EPOLL_URING_WAKE	((__force __poll_t)(1U << 27))
+
 /* Set exclusive wakeup mode for the target file descriptor */
 #define EPOLLEXCLUSIVE	((__force __poll_t)(1U << 28))
 
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 87bc38b47103..81485c1a9879 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -513,7 +513,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 
 static bool io_flush_signals(void)
 {
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();
 		return true;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a01188ff45a..cae78f37d709 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -578,6 +578,7 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
+	size_t				done_io;
 	struct io_buffer		*kbuf;
 };
 
@@ -739,6 +740,7 @@ enum {
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -794,6 +796,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -1629,13 +1633,15 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 * wake as many waiters as we need to.
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
+		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+		eventfd_signal_mask(ctx->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
+		__wake_up(&ctx->poll_wait, TASK_INTERRUPTIBLE, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1645,12 +1651,14 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (waitqueue_active(&ctx->cq_wait))
-			wake_up_all(&ctx->cq_wait);
+			__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				  poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 	}
 	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+		eventfd_signal_mask(ctx->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
+		__wake_up(&ctx->poll_wait, TASK_INTERRUPTIBLE, 0,
+				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -2695,17 +2703,32 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
-static bool __io_complete_rw_common(struct io_kiocb *req, long res)
+/*
+ * Trigger the notifications after having done some IO, and finish the write
+ * accounting, if any.
+ */
+static void io_req_io_end(struct io_kiocb *req)
 {
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
+	struct io_rw *rw = &req->rw;
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
 		fsnotify_modify(req->file);
 	} else {
 		fsnotify_access(req->file);
 	}
+}
+
+static bool __io_complete_rw_common(struct io_kiocb *req, long res)
+{
 	if (res != req->result) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
+			/*
+			 * Reissue will start accounting again, finish the
+			 * current cycle.
+			 */
+			io_req_io_end(req);
 			req->flags |= REQ_F_REISSUE;
 			return true;
 		}
@@ -2747,12 +2770,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	}
 }
 
-static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     unsigned int issue_flags)
+static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	if (__io_complete_rw_common(req, res))
-		return;
-	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
+	io_req_io_end(req);
+	io_req_task_complete(req, locked);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
@@ -2762,7 +2783,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	if (__io_complete_rw_common(req, res))
 		return;
 	req->result = io_fixup_rw_res(req, res);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 
@@ -2914,14 +2935,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
-			kiocb->ki_pos = 0;
-		}
-	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
@@ -3003,6 +3016,23 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
+static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+
+	if (kiocb->ki_pos != -1)
+		return &kiocb->ki_pos;
+
+	if (!(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		kiocb->ki_pos = req->file->f_pos;
+		return &kiocb->ki_pos;
+	}
+
+	kiocb->ki_pos = 0;
+	return NULL;
+}
+
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       unsigned int issue_flags)
 {
@@ -3010,10 +3040,20 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
-		__io_complete_rw(req, ret, 0, issue_flags);
-	else
+	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw)) {
+		if (!__io_complete_rw_common(req, ret)) {
+			/*
+			 * Safe to call io_end from here as we're inline
+			 * from the submission path.
+			 */
+			io_req_io_end(req);
+			__io_req_complete(req, issue_flags,
+					  io_fixup_rw_res(req, ret),
+					  io_put_rw_kbuf(req));
+		}
+	} else {
 		io_rw_done(kiocb, ret);
+	}
 
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -3295,6 +3335,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct file *file = req->file;
 	ssize_t ret = 0;
+	loff_t *ppos;
 
 	/*
 	 * Don't support polled IO through this interface, and we can't
@@ -3306,6 +3347,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	ppos = io_kiocb_ppos(kiocb);
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3319,10 +3362,10 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, io_kiocb_ppos(kiocb));
+					      iovec.iov_len, ppos);
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, io_kiocb_ppos(kiocb));
+					       iovec.iov_len, ppos);
 		}
 
 		if (nr < 0) {
@@ -3523,6 +3566,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3555,7 +3599,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3659,6 +3705,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3689,7 +3736,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -4769,6 +4818,13 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 #if defined(CONFIG_NET)
+static bool io_net_retry(struct socket *sock, int flags)
+{
+	if (!(flags & MSG_WAITALL))
+		return false;
+	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
+}
+
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
@@ -4786,8 +4842,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
-	if (!async_msg->free_iov)
-		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+	if (!kmsg->free_iov) {
+		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
+		async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
+	}
 
 	return -EAGAIN;
 }
@@ -4832,12 +4890,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -4862,17 +4922,27 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg);
+		}
+		req_set_fail(req);
+	}
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret)
-		req_set_fail(req);
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4908,13 +4978,24 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (ret < min_ret)
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
+	}
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5058,12 +5139,14 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -5101,10 +5184,20 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg);
+		}
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
@@ -5112,8 +5205,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -5160,15 +5255,29 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
+		req_set_fail(req);
+	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -5206,9 +5315,6 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5220,6 +5326,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
+		/* safe to retry */
+		req->flags |= REQ_F_PARTIAL_IO;
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
@@ -5636,8 +5744,17 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (io_poll_get_ownership(req))
+	if (io_poll_get_ownership(req)) {
+		/*
+		 * If we trigger a multishot poll off our own wakeup path,
+		 * disable multishot as there is a circular dependency between
+		 * CQ posting and triggering the event.
+		 */
+		if (mask & EPOLL_URING_WAKE)
+			poll->events |= EPOLLONESHOT;
+
 		__io_poll_execute(req, mask);
+	}
 	return 1;
 }
 
@@ -5778,7 +5895,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
+	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -5794,7 +5911,12 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	if (req->flags & REQ_F_POLLED) {
+		apoll = req->apoll;
+		kfree(apoll->double_poll);
+	} else {
+		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	}
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
@@ -9607,6 +9729,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
+	/* drop cached put refs after potentially doing completions */
+	if (current->io_uring)
+		io_uring_drop_tctx_refs(current);
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index bd09290e3648..fcdd28224f53 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -216,9 +216,6 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
 	if (offload->dev_state)
 		offload->offdev->ops->destroy(prog);
 
-	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
-
 	list_del_init(&offload->offloads);
 	kfree(offload);
 	prog->aux->offload = NULL;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index aea9852f1c22..ad41b8230780 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1695,7 +1695,7 @@ static void bpf_audit_prog(const struct bpf_prog *prog, unsigned int op)
 		return;
 	if (audit_enabled == AUDIT_OFF)
 		return;
-	if (op == BPF_AUDIT_LOAD)
+	if (!in_irq() && !irqs_disabled())
 		ctx = audit_context();
 	ab = audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
 	if (unlikely(!ab))
@@ -1790,6 +1790,7 @@ static void bpf_prog_put_deferred(struct work_struct *work)
 	prog = aux->prog;
 	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
 	bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
+	bpf_prog_free_id(prog, true);
 	__bpf_prog_put_noref(prog, true);
 }
 
@@ -1798,9 +1799,6 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
-		/* bpf_prog_free_id() must be called first */
-		bpf_prog_free_id(prog, do_idr_lock);
-
 		if (in_irq() || irqs_disabled()) {
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
 			schedule_work(&aux->work);
diff --git a/kernel/sys.c b/kernel/sys.c
index 3e4e8930fafc..2d2bc6396515 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1575,6 +1575,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e7bd42f23667..8599f16d4aa4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -82,6 +82,8 @@ struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -4164,6 +4166,25 @@ static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+
+	/*
+	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
+	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
+	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 */
+	if (addr & ~PUD_MASK) {
+		/*
+		 * hugetlb_vm_op_split is called right before we attempt to
+		 * split the VMA. We will need to unshare PMDs in the old and
+		 * new VMAs, so let's unshare before we split.
+		 */
+		unsigned long floor = addr & PUD_MASK;
+		unsigned long ceil = floor + PUD_SIZE;
+
+		if (floor >= vma->vm_start && ceil <= vma->vm_end)
+			hugetlb_unshare_pmds(vma, floor, ceil);
+	}
+
 	return 0;
 }
 
@@ -6349,26 +6370,21 @@ void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason)
 	}
 }
 
-/*
- * This function will unconditionally remove all the shared pmd pgtable entries
- * within the specific vma for a hugetlbfs memory range.
- */
-void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+				   unsigned long start,
+				   unsigned long end)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long address, start, end;
+	unsigned long address;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	start = ALIGN(vma->vm_start, PUD_SIZE);
-	end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
-
 	if (start >= end)
 		return;
 
@@ -6400,6 +6416,16 @@ void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
 	mmu_notifier_invalidate_range_end(&range);
 }
 
+/*
+ * This function will unconditionally remove all the shared pmd pgtable entries
+ * within the specific vma for a hugetlbfs memory range.
+ */
+void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+{
+	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+}
+
 #ifdef CONFIG_CMA
 static bool cma_reserve_called __initdata;
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fd25d12e85b3..3afcb1466ec5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1458,14 +1458,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
-	/*
-	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
-	 * that got written to. Without this, we'd have to also lock the
-	 * anon_vma if one exists.
-	 */
-	if (vma->anon_vma)
-		return;
-
 	hpage = find_lock_page(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (!hpage)
@@ -1537,6 +1529,10 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
 				haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1546,6 +1542,8 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 drop_hpage:
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6991d77dcb2e..939c63d6e74b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2074,7 +2074,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
 		return -ENOMEM;
-	WARN_ON_ONCE(!n_stats);
+	if (WARN_ON_ONCE(!n_stats))
+		return -EOPNOTSUPP;
 
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index b5d707a5a31b..8e135af0d4f7 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,7 +136,7 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
-	err = -EINVAL;
+	err = -ENOTCONN;
 	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
 		goto out_err;
 
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 1deb3d874a4b..a4d3fa14f76b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -491,7 +491,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
 		.action = IEEE80211_AMPDU_TX_START,
@@ -521,6 +521,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
+	sdata = sta->sdata;
 	params.ssn = sta->tid_seq[tid] >> 4;
 	ret = drv_ampdu_action(local, sdata, &params);
 	tid_tx->ssn = params.ssn;
@@ -534,6 +535,9 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		 */
 		set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state);
 	} else if (ret) {
+		if (!sdata)
+			return;
+
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
 		       sta->sta.addr, tid);
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 48322e45e7dd..120bd9cdf7df 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -331,6 +331,9 @@ int drv_ampdu_action(struct ieee80211_local *local,
 
 	might_sleep();
 
+	if (!sdata)
+		return -EIO;
+
 	sdata = get_bss_sdata(sdata);
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a3347f245782..041859b5b71d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2059,7 +2059,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
-			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c7321f5842b3..74fe0fe85834 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9076,6 +9076,9 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
diff --git a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
new file mode 100644
index 000000000000..3add34df5767
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "jeq_infer_not_null_fail.skel.h"
+
+void test_jeq_infer_not_null(void)
+{
+	RUN_TESTS(jeq_infer_not_null_fail);
+}
diff --git a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
new file mode 100644
index 000000000000..f46965053acb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, u64);
+	__type(value, u64);
+} m_hash SEC(".maps");
+
+SEC("?raw_tp")
+__failure __msg("R8 invalid mem access 'map_value_or_null")
+int jeq_infer_not_null_ptr_to_btfid(void *ctx)
+{
+	struct bpf_map *map = (struct bpf_map *)&m_hash;
+	struct bpf_map *inner_map = map->inner_map_meta;
+	u64 key = 0, ret = 0, *val;
+
+	val = bpf_map_lookup_elem(map, &key);
+	/* Do not mark ptr as non-null if one of them is
+	 * PTR_TO_BTF_ID (R9), reject because of invalid
+	 * access to map value (R8).
+	 *
+	 * Here, we need to inline those insns to access
+	 * R8 directly, since compiler may use other reg
+	 * once it figures out val==inner_map.
+	 */
+	asm volatile("r8 = %[val];\n"
+		     "r9 = %[inner_map];\n"
+		     "if r8 != r9 goto +1;\n"
+		     "%[ret] = *(u64 *)(r8 +0);\n"
+		     : [ret] "+r"(ret)
+		     : [inner_map] "r"(inner_map), [val] "r"(val)
+		     : "r8", "r9");
+
+	return ret;
+}
diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index fa87b58bd5fa..98ff808d6f0c 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -308,6 +308,7 @@ static int parallel_test(u64 features,
 
 		gvdev.vdev.features = features;
 		INIT_LIST_HEAD(&gvdev.vdev.vqs);
+		spin_lock_init(&gvdev.vdev.vqs_list_lock);
 		gvdev.to_host_fd = to_host[1];
 		gvdev.notifies = 0;
 
@@ -455,6 +456,7 @@ int main(int argc, char *argv[])
 	getrange = getrange_iov;
 	vdev.features = 0;
 	INIT_LIST_HEAD(&vdev.vqs);
+	spin_lock_init(&vdev.vqs_list_lock);
 
 	while (argv[1]) {
 		if (strcmp(argv[1], "--indirect") == 0)
