Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C2A1DB645
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgETOXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:23:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33230 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-00036N-K1; Wed, 20 May 2020 15:22:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DRJ-Cc; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Mark Salter" <msalter@redhat.com>,
        "Leif Lindholm" <leif.lindholm@linaro.org>
Date:   Wed, 20 May 2020 15:14:11 +0100
Message-ID: <lsq.1589984008.586913999@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 43/99] efi: Use early_mem*() instead of early_io*()
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Kiper <daniel.kiper@oracle.com>

commit abc93f8eb6e46a480485f19256bdbda36ec78a84 upstream.

Use early_mem*() instead of early_io*() because all mapped EFI regions
are memory (usually RAM but they could also be ROM, EPROM, EEPROM, flash,
etc.) not I/O regions. Additionally, I/O family calls do not work correctly
under Xen in our case. early_ioremap() skips the PFN to MFN conversion
when building the PTE. Using it for memory will attempt to map the wrong
machine frame. However, all artificial EFI structures created under Xen
live in dom0 memory and should be mapped/unmapped using early_mem*() family
calls which map domain memory.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c | 28 ++++++++++++++--------------
 drivers/firmware/efi/efi.c  |  4 ++--
 2 files changed, 16 insertions(+), 16 deletions(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -435,7 +435,7 @@ void __init efi_unmap_memmap(void)
 {
 	clear_bit(EFI_MEMMAP, &efi.flags);
 	if (memmap.map) {
-		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
 	}
 }
@@ -475,12 +475,12 @@ static int __init efi_systab_init(void *
 			if (!data)
 				return -ENOMEM;
 		}
-		systab64 = early_ioremap((unsigned long)phys,
+		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
 			if (data)
-				early_iounmap(data, sizeof(*data));
+				early_memunmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
@@ -512,9 +512,9 @@ static int __init efi_systab_init(void *
 					   systab64->tables;
 		tmp |= data ? data->tables : systab64->tables;
 
-		early_iounmap(systab64, sizeof(*systab64));
+		early_memunmap(systab64, sizeof(*systab64));
 		if (data)
-			early_iounmap(data, sizeof(*data));
+			early_memunmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -524,7 +524,7 @@ static int __init efi_systab_init(void *
 	} else {
 		efi_system_table_32_t *systab32;
 
-		systab32 = early_ioremap((unsigned long)phys,
+		systab32 = early_memremap((unsigned long)phys,
 					 sizeof(*systab32));
 		if (systab32 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -545,7 +545,7 @@ static int __init efi_systab_init(void *
 		efi_systab.nr_tables = systab32->nr_tables;
 		efi_systab.tables = systab32->tables;
 
-		early_iounmap(systab32, sizeof(*systab32));
+		early_memunmap(systab32, sizeof(*systab32));
 	}
 
 	efi.systab = &efi_systab;
@@ -571,7 +571,7 @@ static int __init efi_runtime_init32(voi
 {
 	efi_runtime_services_32_t *runtime;
 
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_32_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -586,7 +586,7 @@ static int __init efi_runtime_init32(voi
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_32_t));
 
 	return 0;
 }
@@ -595,7 +595,7 @@ static int __init efi_runtime_init64(voi
 {
 	efi_runtime_services_64_t *runtime;
 
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 			sizeof(efi_runtime_services_64_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -610,7 +610,7 @@ static int __init efi_runtime_init64(voi
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
 			(unsigned long)runtime->set_virtual_address_map;
-	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_64_t));
 
 	return 0;
 }
@@ -641,7 +641,7 @@ static int __init efi_runtime_init(void)
 static int __init efi_memmap_init(void)
 {
 	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
 		pr_err("Could not map the memory map!\n");
@@ -745,14 +745,14 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	early_memunmap(tmp, 2);
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -295,7 +295,7 @@ int __init efi_config_init(efi_config_ta
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
+				early_memunmap(config_tables,
 					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
@@ -311,7 +311,7 @@ int __init efi_config_init(efi_config_ta
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 

