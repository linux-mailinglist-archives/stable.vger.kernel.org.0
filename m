Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0016A6790DD
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjAXG33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjAXG3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:29:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043973D08D;
        Mon, 23 Jan 2023 22:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B04D8B810CB;
        Tue, 24 Jan 2023 06:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC374C433D2;
        Tue, 24 Jan 2023 06:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541732;
        bh=i1E6vhF9PT9ZQ0rkiPYNQFsHApA0U7XvLmzlkV4CTL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+6RT5sVxdBhupzmBD3khqfaHCv2GNn4UFycCOZgrsUNHMBS0wOaA/lDDhI5Q9JTO
         krcPBrKq9Psg3+KXpTCExBa7l0lT2uo9W+jyrl10//3lcEo16jDJWz1GUuHNPj/hAX
         jnokTkHgN2Zq6NyP5ixD8Z/U2TN/M5j2G9WJtb98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.165
Date:   Tue, 24 Jan 2023 07:28:44 +0100
Message-Id: <1674541723140156@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <16745417235230@kroah.com>
References: <16745417235230@kroah.com>
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
index 68fd49d8d436..5fbff8603f44 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 164
+SUBLEVEL = 165
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 973b14415271..16892f0d05ad 100644
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
index c5685179db5a..72f432d23ec5 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -143,3 +143,30 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
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
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 701f196d7c68..3c0a621b9792 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,9 +138,6 @@ static void __init fpu__init_system_generic(void)
 unsigned int fpu_kernel_xstate_size;
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
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 60b0e13bb9fc..5347fc465ce8 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -50,6 +50,9 @@
 #define IBS_HOST_TX_IDLE_TIMEOUT_MS	2000
 #define CMD_TRANS_TIMEOUT_MS		100
 #define MEMDUMP_TIMEOUT_MS		8000
+#define IBS_DISABLE_SSR_TIMEOUT_MS \
+	(MEMDUMP_TIMEOUT_MS + FW_DOWNLOAD_TIMEOUT_MS)
+#define FW_DOWNLOAD_TIMEOUT_MS		3000
 
 /* susclk rate */
 #define SUSCLK_RATE_32KHZ	32768
@@ -68,12 +71,14 @@
 #define QCA_MEMDUMP_BYTE		0xFB
 
 enum qca_flags {
-	QCA_IBS_ENABLED,
+	QCA_IBS_DISABLED,
 	QCA_DROP_VENDOR_EVENT,
 	QCA_SUSPENDING,
 	QCA_MEMDUMP_COLLECTION,
 	QCA_HW_ERROR_EVENT,
-	QCA_SSR_TRIGGERED
+	QCA_SSR_TRIGGERED,
+	QCA_BT_OFF,
+	QCA_ROM_FW
 };
 
 enum qca_capabilities {
@@ -870,7 +875,7 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	 * Out-Of-Band(GPIOs control) sleep is selected.
 	 * Don't wake the device up when suspending.
 	 */
-	if (!test_bit(QCA_IBS_ENABLED, &qca->flags) ||
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags) ||
 	    test_bit(QCA_SUSPENDING, &qca->flags)) {
 		skb_queue_tail(&qca->txq, skb);
 		spin_unlock_irqrestore(&qca->hci_ibs_lock, flags);
@@ -1015,7 +1020,7 @@ static void qca_controller_memdump(struct work_struct *work)
 			 * the controller to send the dump is 8 seconds. let us
 			 * start timer to handle this asynchronous activity.
 			 */
-			clear_bit(QCA_IBS_ENABLED, &qca->flags);
+			set_bit(QCA_IBS_DISABLED, &qca->flags);
 			set_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
 			dump = (void *) skb->data;
 			dump_size = __le32_to_cpu(dump->dump_size);
@@ -1621,6 +1626,7 @@ static int qca_power_on(struct hci_dev *hdev)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 	struct qca_serdev *qcadev;
+	struct qca_data *qca = hu->priv;
 	int ret = 0;
 
 	/* Non-serdev device usually is powered by external power
@@ -1640,6 +1646,7 @@ static int qca_power_on(struct hci_dev *hdev)
 		}
 	}
 
+	clear_bit(QCA_BT_OFF, &qca->flags);
 	return ret;
 }
 
@@ -1658,8 +1665,9 @@ static int qca_setup(struct hci_uart *hu)
 	if (ret)
 		return ret;
 
+	clear_bit(QCA_ROM_FW, &qca->flags);
 	/* Patch downloading has to be done without IBS mode */
-	clear_bit(QCA_IBS_ENABLED, &qca->flags);
+	set_bit(QCA_IBS_DISABLED, &qca->flags);
 
 	/* Enable controller to do both LE scan and BR/EDR inquiry
 	 * simultaneously.
@@ -1710,18 +1718,20 @@ static int qca_setup(struct hci_uart *hu)
 	ret = qca_uart_setup(hdev, qca_baudrate, soc_type, soc_ver,
 			firmware_name);
 	if (!ret) {
-		set_bit(QCA_IBS_ENABLED, &qca->flags);
+		clear_bit(QCA_IBS_DISABLED, &qca->flags);
 		qca_debugfs_init(hdev);
 		hu->hdev->hw_error = qca_hw_error;
 		hu->hdev->cmd_timeout = qca_cmd_timeout;
 	} else if (ret == -ENOENT) {
 		/* No patch/nvm-config found, run with original fw/config */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	} else if (ret == -EAGAIN) {
 		/*
 		 * Userspace firmware loader will return -EAGAIN in case no
 		 * patch/nvm-config is found, so run with original fw/config.
 		 */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	} else {
 		if (retries < MAX_INIT_RETRIES) {
@@ -1814,7 +1824,7 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	 * data in skb's.
 	 */
 	spin_lock_irqsave(&qca->hci_ibs_lock, flags);
-	clear_bit(QCA_IBS_ENABLED, &qca->flags);
+	set_bit(QCA_IBS_DISABLED, &qca->flags);
 	qca_flush(hu);
 	spin_unlock_irqrestore(&qca->hci_ibs_lock, flags);
 
@@ -1833,6 +1843,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	} else if (qcadev->bt_en) {
 		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 	}
+
+	set_bit(QCA_BT_OFF, &qca->flags);
 }
 
 static int qca_power_off(struct hci_dev *hdev)
@@ -2057,10 +2069,17 @@ static void qca_serdev_shutdown(struct device *dev)
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
@@ -2093,13 +2112,44 @@ static int __maybe_unused qca_suspend(struct device *dev)
 	bool tx_pending = false;
 	int ret = 0;
 	u8 cmd;
+	u32 wait_timeout = 0;
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
-	/* Device is downloading patch or doesn't support in-band sleep. */
-	if (!test_bit(QCA_IBS_ENABLED, &qca->flags))
+	/* if BT SoC is running with default firmware then it does not
+	 * support in-band sleep
+	 */
+	if (test_bit(QCA_ROM_FW, &qca->flags))
+		return 0;
+
+	/* During SSR after memory dump collection, controller will be
+	 * powered off and then powered on.If controller is powered off
+	 * during SSR then we should wait until SSR is completed.
+	 */
+	if (test_bit(QCA_BT_OFF, &qca->flags) &&
+	    !test_bit(QCA_SSR_TRIGGERED, &qca->flags))
 		return 0;
 
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags) ||
+	    test_bit(QCA_SSR_TRIGGERED, &qca->flags)) {
+		wait_timeout = test_bit(QCA_SSR_TRIGGERED, &qca->flags) ?
+					IBS_DISABLE_SSR_TIMEOUT_MS :
+					FW_DOWNLOAD_TIMEOUT_MS;
+
+		/* QCA_IBS_DISABLED flag is set to true, During FW download
+		 * and during memory dump collection. It is reset to false,
+		 * After FW download complete.
+		 */
+		wait_on_bit_timeout(&qca->flags, QCA_IBS_DISABLED,
+			    TASK_UNINTERRUPTIBLE, msecs_to_jiffies(wait_timeout));
+
+		if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
+			bt_dev_err(hu->hdev, "SSR or FW download time out");
+			ret = -ETIMEDOUT;
+			goto error;
+		}
+	}
+
 	cancel_work_sync(&qca->ws_awake_device);
 	cancel_work_sync(&qca->ws_awake_rx);
 
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 14c1ac26f866..b8b5d91b7c1a 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -551,6 +551,11 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 
 	/* The bad descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 	/* Remove the completed descriptor from issued list */
 	list_del(&vd->node);
 
@@ -565,6 +570,7 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 	/* Try to restart the controller */
 	axi_chan_start_first_queued(chan);
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index c5fa2ef74abc..d84010c2e4bf 100644
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
index c1cd5ca875ca..407cac71c77d 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -360,9 +360,10 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index b6ce64b87f48..6937f8134008 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1531,8 +1531,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
 uint32_t amdgpu_bo_get_preferred_pin_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
-	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
+	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 167a1ee518a8..fbe15f4b75fd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4567,8 +4567,6 @@ static void fill_stream_properties_from_drm_display_mode(
 	timing_out->pix_clk_100hz = mode_in->crtc_clock * 10;
 	timing_out->aspect_ratio = get_aspect_ratio(mode_in);
 
-	stream->output_color_space = get_output_color_space(timing_out);
-
 	stream->out_transfer_func->type = TF_TYPE_PREDEFINED;
 	stream->out_transfer_func->tf = TRANSFER_FUNCTION_SRGB;
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A) {
@@ -4579,6 +4577,8 @@ static void fill_stream_properties_from_drm_display_mode(
 			adjust_colour_depth_from_display_info(timing_out, info);
 		}
 	}
+
+	stream->output_color_space = get_output_color_space(timing_out);
 }
 
 static void fill_audio_info(struct audio_info *audio_info,
@@ -8783,8 +8783,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 		}
 
-		if (dm_old_con_state->abm_level !=
-		    dm_new_con_state->abm_level)
+		if (dm_old_con_state->abm_level != dm_new_con_state->abm_level ||
+		    dm_old_con_state->scaling != dm_new_con_state->scaling)
 			new_crtc_state->connectors_changed = true;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 2a9080400bdd..86f3ea4edb31 100644
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
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index ac36b67fb46b..00b5912a88b8 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -289,6 +289,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
 static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 {
 	struct intel_uncore *uncore = gt->uncore;
+	int loops = 2;
 	int err;
 
 	/*
@@ -296,18 +297,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	 * for fifo space for the write or forcewake the chip for
 	 * the read
 	 */
-	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
+	do {
+		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
 
-	/* Wait for the device to ack the reset requests */
-	err = __intel_wait_for_register_fw(uncore,
-					   GEN6_GDRST, hw_domain_mask, 0,
-					   500, 0,
-					   NULL);
+		/*
+		 * Wait for the device to ack the reset requests.
+		 *
+		 * On some platforms, e.g. Jasperlake, we see that the
+		 * engine register state is not cleared until shortly after
+		 * GDRST reports completion, causing a failure as we try
+		 * to immediately resume while the internal state is still
+		 * in flux. If we immediately repeat the reset, the second
+		 * reset appears to serialise with the first, and since
+		 * it is a no-op, the registers should retain their reset
+		 * value. However, there is still a concern that upon
+		 * leaving the second reset, the internal engine state
+		 * is still in flux and not ready for resuming.
+		 */
+		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
+						   hw_domain_mask, 0,
+						   2000, 0,
+						   NULL);
+	} while (err == 0 && --loops);
 	if (err)
 		drm_dbg(&gt->i915->drm,
 			"Wait for 0x%08x engines reset failed\n",
 			hw_domain_mask);
 
+	/*
+	 * As we have observed that the engine state is still volatile
+	 * after GDRST is acked, impose a small delay to let everything settle.
+	 */
+	udelay(50);
+
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index fb5e30de78c2..63dc0fcfcc8e 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -403,7 +403,8 @@ static const struct intel_device_info ilk_m_info = {
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
index 6818cac0a3b7..85bac20d9007 100644
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
index 2c3142b4b5dd..67a51f69cf9a 100644
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
@@ -1112,12 +1121,7 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
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
 
@@ -1194,10 +1198,8 @@ static int fastrpc_device_release(struct inode *inode, struct file *file)
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
index afb2e78df4d6..eabbdf17b0c6 100644
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
index 9e827bfe19ff..70f388f83485 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -103,6 +103,7 @@
 #define ESDHC_TUNING_START_TAP_DEFAULT	0x1
 #define ESDHC_TUNING_START_TAP_MASK	0x7f
 #define ESDHC_TUNING_CMD_CRC_CHECK_DISABLE	(1 << 7)
+#define ESDHC_TUNING_STEP_DEFAULT	0x1
 #define ESDHC_TUNING_STEP_MASK		0x00070000
 #define ESDHC_TUNING_STEP_SHIFT		16
 
@@ -1300,7 +1301,7 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	struct cqhci_host *cq_host = host->mmc->cqe_private;
-	int tmp;
+	u32 tmp;
 
 	if (esdhc_is_usdhc(imx_data)) {
 		/*
@@ -1353,17 +1354,24 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 
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
index fc62773602ec..9215069c6156 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1459,9 +1459,11 @@ static int sunxi_mmc_remove(struct platform_device *pdev)
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
index b21054514736..f42e118f3290 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -621,6 +621,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
 	mutex_unlock(&dev->intf_state_mutex);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 6a5621f17bf5..721d587425c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1109,7 +1109,7 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
-	if (max_flowrings > 256) {
+	if (max_flowrings > 512) {
 		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
 		return -EIO;
 	}
diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 7063e0d42c5e..660ee3aea447 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -319,9 +319,10 @@ static int apr_add_device(struct device *dev, struct device_node *np,
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
diff --git a/drivers/staging/comedi/drivers/adv_pci1760.c b/drivers/staging/comedi/drivers/adv_pci1760.c
index 6de8ab97d346..d6934b6c436d 100644
--- a/drivers/staging/comedi/drivers/adv_pci1760.c
+++ b/drivers/staging/comedi/drivers/adv_pci1760.c
@@ -59,7 +59,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firmware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */
diff --git a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
index fefc664eefcf..f5e1ae5f5ee2 100644
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
index 0784c5002417..77d8fb180173 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
@@ -89,10 +89,10 @@ extern struct vchiq_arm_state*
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
index 829b6ccdd5d4..011ab5fed85b 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -956,7 +956,7 @@ static void tb_usb3_reclaim_available_bandwidth(struct tb_tunnel *tunnel,
 		return;
 	} else if (!ret) {
 		/* Use maximum link rate if the link valid is not set */
-		ret = usb4_usb3_port_max_link_rate(tunnel->src_port);
+		ret = tb_usb3_max_link_rate(tunnel->dst_port, tunnel->src_port);
 		if (ret < 0) {
 			tb_tunnel_warn(tunnel, "failed to read maximum link rate\n");
 			return;
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index b7872ad3e762..02fd0e79c8f7 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2633,13 +2633,7 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
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
index fa2061f1cf3d..cb68a1028090 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -769,7 +769,7 @@ static void pch_dma_tx_complete(void *arg)
 	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;
diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 0d85b55ea823..f50ffc8076d8 100644
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
 
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f2a3c0b5b535..5925b8eb9ee3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -42,6 +42,9 @@
 #define USB_PRODUCT_USB5534B			0x5534
 #define USB_VENDOR_CYPRESS			0x04b4
 #define USB_PRODUCT_CY7C65632			0x6570
+#define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
+#define USB_PRODUCT_TUSB8041_USB3		0x8140
+#define USB_PRODUCT_TUSB8041_USB2		0x8142
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5715,6 +5718,16 @@ static const struct usb_device_id hub_id_table[] = {
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
index 855127249f24..f56147489835 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -85,7 +85,9 @@ static inline struct f_ncm *func_to_ncm(struct usb_function *f)
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
index cd097474b6c3..cbe801640916 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -229,6 +229,7 @@ static void put_ep (struct ep_data *data)
  */
 
 static const char *CHIP;
+static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
 
 /*----------------------------------------------------------------------*/
 
@@ -2012,13 +2013,20 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
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
@@ -2055,13 +2063,17 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
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
@@ -2083,6 +2095,7 @@ static int gadgetfs_init_fs_context(struct fs_context *fc)
 static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
+	mutex_lock(&sb_mutex);
 	kill_litter_super (sb);
 	if (the_device) {
 		put_dev (the_device);
@@ -2090,6 +2103,7 @@ gadgetfs_kill_sb (struct super_block *sb)
 	}
 	kfree(CHIP);
 	CHIP = NULL;
+	mutex_unlock(&sb_mutex);
 }
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
index 2c9eab2b863d..ff970a943347 100644
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
index 1e8b59ab2272..c78f71a5faac 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -29,7 +29,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9168b492c02b..aff65cefead2 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -77,9 +77,12 @@ static const char hcd_name[] = "xhci_hcd";
 static struct hc_driver __read_mostly xhci_pci_hc_driver;
 
 static int xhci_pci_setup(struct usb_hcd *hcd);
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags);
 
 static const struct xhci_driver_overrides xhci_pci_overrides __initconst = {
 	.reset = xhci_pci_setup,
+	.update_hub_device = xhci_pci_update_hub_device,
 };
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -348,8 +351,38 @@ static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev)
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
@@ -382,6 +415,16 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
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
@@ -451,6 +494,8 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ead42fc3e16d..b69b8c7e7966 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1044,7 +1044,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
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
index c968dd865314..2967372a9988 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3919,6 +3919,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -3947,7 +3948,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
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
@@ -5004,6 +5009,7 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -5017,6 +5023,13 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
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
@@ -5076,7 +5089,7 @@ static int xhci_disable_usb3_lpm_timeout(struct usb_hcd *hcd,
 /* Once a hub descriptor is fetched for a device, we need to update the xHC's
  * internal data structures for the device.
  */
-static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 			struct usb_tt *tt, gfp_t mem_flags)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -5176,6 +5189,7 @@ static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 	xhci_free_command(xhci, config_cmd);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xhci_update_hub_device);
 
 static int xhci_get_frame(struct usb_hcd *hcd)
 {
@@ -5446,6 +5460,8 @@ void xhci_init_driver(struct hc_driver *drv,
 			drv->check_bandwidth = over->check_bandwidth;
 		if (over->reset_bandwidth)
 			drv->reset_bandwidth = over->reset_bandwidth;
+		if (over->update_hub_device)
+			drv->update_hub_device = over->update_hub_device;
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_init_driver);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ac09b171b783..c7749f6e3474 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1728,6 +1728,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {
@@ -1933,6 +1934,8 @@ struct xhci_driver_overrides {
 	int (*start)(struct usb_hcd *hcd);
 	int (*check_bandwidth)(struct usb_hcd *, struct usb_device *);
 	void (*reset_bandwidth)(struct usb_hcd *, struct usb_device *);
+	int (*update_hub_device)(struct usb_hcd *hcd, struct usb_device *hdev,
+			    struct usb_tt *tt, gfp_t mem_flags);
 };
 
 #define	XHCI_CFC_DELAY		10
@@ -2089,6 +2092,8 @@ void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
 int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+			   struct usb_tt *tt, gfp_t mem_flags);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
 int xhci_ext_cap_init(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 72a06af25081..51a5d626134c 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -817,7 +817,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 8a4a0d4dbc13..9ee0fa775612 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -64,6 +64,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0908, 0x0070) }, /* Siemens SCALANCE LPE-9000 USB Serial Console */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5636b8f52216..2fc65cbbfea9 100644
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
index 5e293ccf0e90..eed719cf5552 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -409,6 +409,18 @@ static const char * const pin_assignments[] = {
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
@@ -435,10 +447,7 @@ pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		goto out_unlock;
 	}
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	if (!(DP_CONF_GET_PIN_ASSIGN(conf) & assignments)) {
 		ret = -EINVAL;
@@ -475,10 +484,7 @@ static ssize_t pin_assignment_show(struct device *dev,
 
 	cur = get_count_order(DP_CONF_GET_PIN_ASSIGN(dp->data.conf));
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	for (i = 0; assignments; assignments >>= 1, i++) {
 		if (assignments & 1) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 284294620e9f..7d9b8050b09c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1684,6 +1684,11 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
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
 
@@ -1935,8 +1940,6 @@ static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
 		if (ret) {
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			btrfs_put_delayed_ref(ref);
-			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
-				    ret);
 			return ret;
 		}
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 74cbbb5d8897..9fe6a01ea8b8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3296,6 +3296,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	int err = -ENOMEM;
 	int ret = 0;
 	bool stopped = false;
+	bool did_leaf_rescans = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3316,6 +3317,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 
 		err = qgroup_rescan_leaf(trans, path);
+		did_leaf_rescans = true;
 
 		if (err > 0)
 			btrfs_commit_transaction(trans);
@@ -3336,16 +3338,23 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
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
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0c4a2474e75b..9a80047bc9b7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3925,12 +3925,15 @@ smb2_readv_callback(struct mid_q_entry *mid)
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
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index bd16c78b5bf2..ad0b83a41226 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -414,7 +414,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	struct extent_node *en;
 	bool ret = false;
 
-	f2fs_bug_on(sbi, !et);
+	if (!et)
+		return false;
 
 	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
 
diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index ae5ed3a07494..deecfb50dd7e 100644
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
index 77efd69213a3..65cd599cb2ab 100644
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
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 475d23a4f8da..66a089a62c39 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -394,6 +394,10 @@ static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 			data_size = zonefs_check_zone_condition(inode, zone,
 								false, false);
 		}
+	} else if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO &&
+		   data_size > isize) {
+		/* Do not expose garbage data */
+		data_size = isize;
 	}
 
 	/*
@@ -772,6 +776,24 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 
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
 
 out_release:
diff --git a/include/linux/usb.h b/include/linux/usb.h
index a093667991bb..568be613bdb3 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -754,11 +754,14 @@ extern struct device *usb_intf_get_dma_device(struct usb_interface *intf);
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
index ecd24c719de4..041be3ce1071 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -95,7 +95,7 @@ struct btrfs_space_info;
 	EM( FLUSH_DELALLOC,		"FLUSH_DELALLOC")		\
 	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
 	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
-	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
+	EM( FLUSH_DELAYED_REFS,		"FLUSH_DELAYED_REFS")		\
 	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
 	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
 	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index d74c076e9e2b..717d388ecbd6 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -400,7 +400,7 @@ static struct trace_event_functions trace_event_type_funcs_##call = {	\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#define ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
+#define ALIGN_STRUCTFIELD(type) ((int)(__alignof__(struct {type b;})))
 
 #undef __field_ext
 #define __field_ext(_type, _item, _filter_type) {			\
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
index 0c4d16afb9ef..642e1a0560c6 100644
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
@@ -2478,12 +2482,26 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
+		struct io_uring_cqe *cqe;
+		unsigned cflags;
+
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-
-		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
+		cflags = io_put_rw_kbuf(req);
 		(*nr_events)++;
 
+		cqe = io_get_cqe(ctx);
+		if (cqe) {
+			WRITE_ONCE(cqe->user_data, req->user_data);
+			WRITE_ONCE(cqe->res, req->result);
+			WRITE_ONCE(cqe->flags, cflags);
+		} else {
+			spin_lock(&ctx->completion_lock);
+			io_cqring_event_overflow(ctx, req->user_data,
+							req->result, cflags);
+			spin_unlock(&ctx->completion_lock);
+		}
+
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
@@ -2682,17 +2700,32 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
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
@@ -2734,12 +2767,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
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
@@ -2749,7 +2780,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	if (__io_complete_rw_common(req, res))
 		return;
 	req->result = io_fixup_rw_res(req, res);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 
@@ -2901,14 +2932,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2990,6 +3013,23 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
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
@@ -2997,10 +3037,20 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 
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
@@ -3282,6 +3332,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct file *file = req->file;
 	ssize_t ret = 0;
+	loff_t *ppos;
 
 	/*
 	 * Don't support polled IO through this interface, and we can't
@@ -3293,6 +3344,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	ppos = io_kiocb_ppos(kiocb);
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3306,10 +3359,10 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 
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
@@ -3510,6 +3563,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3542,7 +3596,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3646,6 +3702,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3676,7 +3733,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -4613,6 +4672,13 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4630,8 +4696,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
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
@@ -4676,12 +4744,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -4706,17 +4776,27 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4752,13 +4832,24 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -4902,12 +4993,14 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -4945,10 +5038,20 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -4956,8 +5059,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -5004,15 +5109,29 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -5050,9 +5169,6 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5065,6 +5181,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
+		/* safe to retry */
+		req->flags |= REQ_F_PARTIAL_IO;
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
@@ -5632,7 +5750,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
+	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -5648,7 +5766,12 @@ static int io_arm_poll_handler(struct io_kiocb *req)
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
@@ -7440,7 +7563,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 
@@ -7452,7 +7575,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -7515,7 +7638,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
@@ -9435,6 +9558,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
+	/* drop cached put refs after potentially doing completions */
+	if (current->io_uring)
+		io_uring_drop_tctx_refs(current);
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
@@ -10741,8 +10868,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -10874,6 +10999,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	long ret = -EBADF;
 	struct fd f;
 
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
diff --git a/kernel/sys.c b/kernel/sys.c
index 24a3a28ae228..9f59cc8ab8f8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1548,6 +1548,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0eb3adf4ff68..b77186ec70e9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1459,14 +1459,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1538,6 +1530,10 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
+	/* we make no change to anon, but protect concurrent anon page lookup */
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
 				haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1547,6 +1543,8 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 
 drop_hpage:
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 47c2dd4a9b9f..12bf740e2fb3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2052,7 +2052,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
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
index 4b4ab1961068..92e5812daf89 100644
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
index d04e5a1a7e0e..3a15ef8dd322 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2013,7 +2013,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = register_netdevice(ndev);
 		if (ret) {
-			ieee80211_if_free(ndev);
 			free_netdev(ndev);
 			return ret;
 		}
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index eb7dd457ef5a..cfd86389d37f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3561,6 +3561,15 @@ static void alc256_init(struct hda_codec *codec)
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
+		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
+		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
+		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		msleep(30);
+	}
+
 	if (!hp_pin)
 		hp_pin = 0x21;
 
@@ -3572,14 +3581,6 @@ static void alc256_init(struct hda_codec *codec)
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x03, 1<<1, 1<<1);
-		alc_update_coef_idx(codec, 0x08, 3<<2, 3<<2);
-		alc_update_coef_idx(codec, 0x08, 7<<4, 0);
-		alc_update_coef_idx(codec, 0x3b, 1<<15, 0);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		msleep(30);
-	}
 
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
@@ -3661,6 +3662,13 @@ static void alc225_init(struct hda_codec *codec)
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp1_pin_sense, hp2_pin_sense;
 
+	if (spec->ultra_low_power) {
+		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
+		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
+		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
+		msleep(30);
+	}
+
 	if (!hp_pin)
 		hp_pin = 0x21;
 	msleep(30);
@@ -3672,12 +3680,6 @@ static void alc225_init(struct hda_codec *codec)
 		msleep(2);
 
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-	if (spec->ultra_low_power) {
-		alc_update_coef_idx(codec, 0x08, 0x0f << 2, 3<<2);
-		alc_update_coef_idx(codec, 0x0e, 7<<6, 7<<6);
-		alc_update_coef_idx(codec, 0x33, 1<<11, 0);
-		msleep(30);
-	}
 
 	if (hp1_pin_sense || spec->ultra_low_power)
 		snd_hda_codec_write(codec, hp_pin, 0,
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
