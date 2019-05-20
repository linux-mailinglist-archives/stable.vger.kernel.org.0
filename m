Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB3234C0
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbfETMa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390097AbfETMa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D185821734;
        Mon, 20 May 2019 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355426;
        bh=yputAOmvq4pakf8w26I0FF70V3hB7OHK244yXiugR5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/gS7LodqsAB/D69SWzdd5EWEwidoMD3nqLTSp7+lRe3F4QaxLV/+k4FiNWWZY7s8
         0Bd3dTIWpH5H+9ciGGROGIXLNH1PfYHazFWnZ95uMA8gtn6pmCF/OzlTXK0To/GfOt
         06c5ZWCidti5KpnSIdZWEudVUnIDB6TLdlw0to68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PGNet Dev <pgnet.dev@gmail.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.0 115/123] xen/pvh: correctly setup the PV EFI interface for dom0
Date:   Mon, 20 May 2019 14:14:55 +0200
Message-Id: <20190520115252.785602230@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 72813bfbf0276a97c82af038efb5f02dcdd9e310 upstream.

This involves initializing the boot params EFI related fields and the
efi global variable.

Without this fix a PVH dom0 doesn't detect when booted from EFI, and
thus doesn't support accessing any of the EFI related data.

Reported-by: PGNet Dev <pgnet.dev@gmail.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/pvh/enlighten.c |    8 ++++----
 arch/x86/xen/efi.c                |   12 ++++++------
 arch/x86/xen/enlighten_pv.c       |    2 +-
 arch/x86/xen/enlighten_pvh.c      |    6 +++++-
 arch/x86/xen/xen-ops.h            |    4 ++--
 5 files changed, 18 insertions(+), 14 deletions(-)

--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -44,8 +44,6 @@ void __init __weak mem_map_via_hcall(str
 
 static void __init init_pvh_bootparams(bool xen_guest)
 {
-	memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
-
 	if ((pvh_start_info.version > 0) && (pvh_start_info.memmap_entries)) {
 		struct hvm_memmap_table_entry *ep;
 		int i;
@@ -103,7 +101,7 @@ static void __init init_pvh_bootparams(b
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
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -158,7 +158,7 @@ static enum efi_secureboot_mode xen_efi_
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
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1403,7 +1403,7 @@ asmlinkage __visible void __init xen_sta
 	/* We need this for printk timestamps */
 	xen_setup_runstate_info(0);
 
-	xen_efi_init();
+	xen_efi_init(&boot_params);
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
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
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -122,9 +122,9 @@ static inline void __init xen_init_vga(c
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


