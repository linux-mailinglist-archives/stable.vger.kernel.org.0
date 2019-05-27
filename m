Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18A32B4D5
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfE0MSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:18:50 -0400
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:25814 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfE0MSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:18:50 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2019 08:18:49 EDT
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL01.citrite.net
Received-SPF: None (esa5.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=23.29.105.83;
  receiver=esa5.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa5.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa5.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa5.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL01.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa5.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL01.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: Gh2BTVmagKlnF8VKfwPAidsBsJ+V4TbsKvEggIXqipM0pBgr0u2Hy1UGK/AOhjyyW7F0eWEwFS
 l1NuwauKMCtOsPNepbG2tpqHjN0RKpDD+Rt+g/dI1XwCbflEBwBNljW8MPqj8onsUsv2sQIOJL
 6La4M4L8lllQGzYlTg6pfLn/axfSic+lbQNmP1nlqWye/H63rTAsuuZ9hDhbIPCacPevGpgSYa
 XMnM2B3ZdjvSAf2Z4aWOjJKH8WC38iL7vDrxqv4JNR70rMlGRSSVD+f5MBIt2g4PdNAIIv2iK6
 gOY=
X-SBRS: 2.7
X-MesageID: 925016
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,519,1549947600"; 
   d="scan'208";a="925016"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <xen-devel@lists.xenproject.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>,
        PGNet Dev <pgnet.dev@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <stable@vger.kernel.org>
Subject: [BACKPORT] xen/pvh: correctly setup the PV EFI interface for dom0
Date:   Mon, 27 May 2019 14:11:38 +0200
Message-ID: <20190527121138.41800-1-roger.pau@citrix.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 72813bfbf0276a97c82af038efb5f02dcdd9e310 upstream

This involves initializing the boot params EFI related fields and the
efi global variable.

Without this fix a PVH dom0 doesn't detect when booted from EFI, and
thus doesn't support accessing any of the EFI related data.

Reported-by: PGNet Dev <pgnet.dev@gmail.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: stable@vger.kernel.org # 4.19+
---
 arch/x86/xen/efi.c           | 12 ++++++------
 arch/x86/xen/enlighten_pv.c  |  2 +-
 arch/x86/xen/enlighten_pvh.c |  4 ++++
 arch/x86/xen/xen-ops.h       |  4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 1804b27f9632..30edb9bc58e2 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -170,7 +170,7 @@ static enum efi_secureboot_mode xen_efi_get_secureboot(void)
 	return efi_secureboot_mode_unknown;
 }
 
-void __init xen_efi_init(void)
+void __init xen_efi_init(struct boot_params *boot_params)
 {
 	efi_system_table_t *efi_systab_xen;
 
@@ -179,12 +179,12 @@ void __init xen_efi_init(void)
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
index 782f98b332f0..0f8da4aebe7b 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1399,7 +1399,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/* We need this for printk timestamps */
 	xen_setup_runstate_info(0);
 
-	xen_efi_init();
+	xen_efi_init(&boot_params);
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index dab07827d25e..f04d22bcf08d 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -14,6 +14,8 @@
 #include <xen/interface/memory.h>
 #include <xen/interface/hvm/start_info.h>
 
+#include "xen-ops.h"
+
 /*
  * PVH variables.
  *
@@ -79,6 +81,8 @@ static void __init init_pvh_bootparams(void)
 	pvh_bootparams.hdr.type_of_loader = (9 << 4) | 0; /* Xen loader */
 
 	x86_init.acpi.get_root_pointer = pvh_get_root_pointer;
+
+	xen_efi_init(&pvh_bootparams);
 }
 
 /*
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
-- 
2.20.1 (Apple Git-117)

