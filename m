Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3DC23199
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 12:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbfETKrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 06:47:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60979 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbfETKrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 06:47:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C568220AB;
        Mon, 20 May 2019 06:47:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 May 2019 06:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mUzDWy
        bxffuwSU1a/uIrL4QaNpeQs05ETXdwyz8c5yc=; b=54w8Xak8CBo1ofpm1oUMdI
        dS0Fo+LV6IDn95hddSmhGHv6HN5Gjzl9XXjx9HFtDUAh+EjvgUAaEffK29LyzZk/
        AJYpeqC1zmhYLwfILPOPu6SZ3JVAmjVmf28VyAf0vZ4UrZk/2eEA8ai2xjjY10Xp
        SKQL1E11qT0LSwKg9ANcZRgTZuJoXXUo/IGgCUQbcAemGsRIcChJclOVIpV13R2c
        ogLCeF1zrOOrYGCiKc6q6PG9VP+wkDmKU8nXvcMK8CCn8tpHUGjGfNXKJDWuWZAl
        9qHE6gUQ3u0CjFgerM6TME/jfLUf5JJJcvfiKwaNXljwn7XTRdUoJOC6g4/hjYvA
        ==
X-ME-Sender: <xms:p4XiXEr0O6i1XiUnXEmvgs22QFrCFWfp6S946C1UqpHx-YewUCRJkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:p4XiXGVP3OtBK2eIMhyr9R-rqK7Wo-iv1vieX8TMrNhhM4v4ZmsFLg>
    <xmx:p4XiXD7lhr-6Go4TEukCJso5Woe1wcEVQK78-LTGNTXhktCPSL0-Xg>
    <xmx:p4XiXM2Wt6WLqDitq05kz2PuyN3CEmkq1GIbzI0E9RQZsPIbzLrzYg>
    <xmx:qIXiXETMbXtlCS8jh9oY5fUDRIzh0nsTOK930BSGrcniJnXCSKf_7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC6A08005C;
        Mon, 20 May 2019 06:47:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/pvh: correctly setup the PV EFI interface for dom0" failed to apply to 4.19-stable tree
To:     roger.pau@citrix.com, boris.ostrovsky@oracle.com,
        pgnet.dev@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 12:47:01 +0200
Message-ID: <1558349221210204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 72813bfbf0276a97c82af038efb5f02dcdd9e310 Mon Sep 17 00:00:00 2001
From: Roger Pau Monne <roger.pau@citrix.com>
Date: Tue, 23 Apr 2019 15:04:16 +0200
Subject: [PATCH] xen/pvh: correctly setup the PV EFI interface for dom0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This involves initializing the boot params EFI related fields and the
efi global variable.

Without this fix a PVH dom0 doesn't detect when booted from EFI, and
thus doesn't support accessing any of the EFI related data.

Reported-by: PGNet Dev <pgnet.dev@gmail.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: stable@vger.kernel.org # 4.19+

diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 62f5c7045944..1861a2ba0f2b 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -44,8 +44,6 @@ void __init __weak mem_map_via_hcall(struct boot_params *ptr __maybe_unused)
 
 static void __init init_pvh_bootparams(bool xen_guest)
 {
-	memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
-
 	if ((pvh_start_info.version > 0) && (pvh_start_info.memmap_entries)) {
 		struct hvm_memmap_table_entry *ep;
 		int i;
@@ -103,7 +101,7 @@ static void __init init_pvh_bootparams(bool xen_guest)
  * If we are trying to boot a Xen PVH guest, it is expected that the kernel
  * will have been configured to provide the required override for this routine.
  */
-void __init __weak xen_pvh_init(void)
+void __init __weak xen_pvh_init(struct boot_params *boot_params)
 {
 	xen_raw_printk("Error: Missing xen PVH initialization\n");
 	BUG();
@@ -112,7 +110,7 @@ void __init __weak xen_pvh_init(void)
 static void hypervisor_specific_init(bool xen_guest)
 {
 	if (xen_guest)
-		xen_pvh_init();
+		xen_pvh_init(&pvh_bootparams);
 }
 
 /*
@@ -131,6 +129,8 @@ void __init xen_prepare_pvh(void)
 		BUG();
 	}
 
+	memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
+
 	hypervisor_specific_init(xen_guest);
 
 	init_pvh_bootparams(xen_guest);
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 1fbb629a9d78..0d3365cb64de 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -158,7 +158,7 @@ static enum efi_secureboot_mode xen_efi_get_secureboot(void)
 	return efi_secureboot_mode_unknown;
 }
 
-void __init xen_efi_init(void)
+void __init xen_efi_init(struct boot_params *boot_params)
 {
 	efi_system_table_t *efi_systab_xen;
 
@@ -167,12 +167,12 @@ void __init xen_efi_init(void)
 	if (efi_systab_xen == NULL)
 		return;
 
-	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
-			sizeof(boot_params.efi_info.efi_loader_signature));
-	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
-	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
+	strncpy((char *)&boot_params->efi_info.efi_loader_signature, "Xen",
+			sizeof(boot_params->efi_info.efi_loader_signature));
+	boot_params->efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
+	boot_params->efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
 
-	boot_params.secure_boot = xen_efi_get_secureboot();
+	boot_params->secure_boot = xen_efi_get_secureboot();
 
 	set_bit(EFI_BOOT, &efi.flags);
 	set_bit(EFI_PARAVIRT, &efi.flags);
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index c54a493e139a..4722ba2966ac 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1403,7 +1403,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/* We need this for printk timestamps */
 	xen_setup_runstate_info(0);
 
-	xen_efi_init();
+	xen_efi_init(&boot_params);
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index bbffa409e0e8..80a79db72fcf 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -13,6 +13,8 @@
 
 #include <xen/interface/memory.h>
 
+#include "xen-ops.h"
+
 /*
  * PVH variables.
  *
@@ -21,7 +23,7 @@
  */
 bool xen_pvh __attribute__((section(".data"))) = 0;
 
-void __init xen_pvh_init(void)
+void __init xen_pvh_init(struct boot_params *boot_params)
 {
 	u32 msr;
 	u64 pfn;
@@ -33,6 +35,8 @@ void __init xen_pvh_init(void)
 	msr = cpuid_ebx(xen_cpuid_base() + 2);
 	pfn = __pa(hypercall_page);
 	wrmsr_safe(msr, (u32)pfn, (u32)(pfn >> 32));
+
+	xen_efi_init(boot_params);
 }
 
 void __init mem_map_via_hcall(struct boot_params *boot_params_p)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 0e60bd918695..2f111f47ba98 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -122,9 +122,9 @@ static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
 void __init xen_init_apic(void);
 
 #ifdef CONFIG_XEN_EFI
-extern void xen_efi_init(void);
+extern void xen_efi_init(struct boot_params *boot_params);
 #else
-static inline void __init xen_efi_init(void)
+static inline void __init xen_efi_init(struct boot_params *boot_params)
 {
 }
 #endif

