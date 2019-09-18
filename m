Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3792B5C67
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfIRG0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbfIRG0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1E7218AF;
        Wed, 18 Sep 2019 06:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787966;
        bh=pr6Kep4VyWjboAQB5tBFUKdvb1ggzp2wNkWBcOBWZyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkJEXWCiFX8UUxqb2sQUtejixzG+umb/5ohAnZl5NEXBIAVe/BqBiT5ABkqF3GXIr
         oUGe7Dd2sIBJC/PFu57WQ5njf/u+6Ve2+jNV6DzgoEV2NLgUztLXUJjV1h2Ab3QjhI
         vlg99LK2Hklpu5TOMRRvYYVUnvH8aTOTHIikMOys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Borislav Petkov <bp@suse.de>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Chao Fan <fanc.fnst@cn.fujitsu.com>,
        Dave Young <dyoung@redhat.com>
Subject: [PATCH 5.2 51/85] x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernels
Date:   Wed, 18 Sep 2019 08:19:09 +0200
Message-Id: <20190918061235.736976524@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junichi Nomura <j-nomura@ce.jp.nec.com>

commit 0a23ebc66a46786769dd68bfdaa3102345819b9c upstream.

Commit

  3a63f70bf4c3a ("x86/boot: Early parse RSDP and save it in boot_params")

broke kexec boot on EFI systems. efi_get_rsdp_addr() in the early
parsing code tries to search RSDP from the EFI tables but that will
crash because the table address is virtual when the kernel was booted by
kexec (set_virtual_address_map() has run in the first kernel and cannot
be run again in the second kernel).

In the case of kexec, the physical address of EFI tables is provided via
efi_setup_data in boot_params, which is set up by kexec(1).

Factor out the table parsing code and use different pointers depending
on whether the kernel is booted by kexec or not.

 [ bp: Massage. ]

Fixes: 3a63f70bf4c3a ("x86/boot: Early parse RSDP and save it in boot_params")
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Cc: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: Dave Young <dyoung@redhat.com>
Link: https://lkml.kernel.org/r/20190408231011.GA5402@jeru.linux.bs1.fc.nec.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/acpi.c |  143 +++++++++++++++++++++++++++++-----------
 1 file changed, 107 insertions(+), 36 deletions(-)

--- a/arch/x86/boot/compressed/acpi.c
+++ b/arch/x86/boot/compressed/acpi.c
@@ -44,17 +44,109 @@ static acpi_physical_address get_acpi_rs
 	return addr;
 }
 
-/* Search EFI system tables for RSDP. */
-static acpi_physical_address efi_get_rsdp_addr(void)
+/*
+ * Search EFI system tables for RSDP.  If both ACPI_20_TABLE_GUID and
+ * ACPI_TABLE_GUID are found, take the former, which has more features.
+ */
+static acpi_physical_address
+__efi_get_rsdp_addr(unsigned long config_tables, unsigned int nr_tables,
+		    bool efi_64)
 {
 	acpi_physical_address rsdp_addr = 0;
 
 #ifdef CONFIG_EFI
-	unsigned long systab, systab_tables, config_tables;
+	int i;
+
+	/* Get EFI tables from systab. */
+	for (i = 0; i < nr_tables; i++) {
+		acpi_physical_address table;
+		efi_guid_t guid;
+
+		if (efi_64) {
+			efi_config_table_64_t *tbl = (efi_config_table_64_t *)config_tables + i;
+
+			guid  = tbl->guid;
+			table = tbl->table;
+
+			if (!IS_ENABLED(CONFIG_X86_64) && table >> 32) {
+				debug_putstr("Error getting RSDP address: EFI config table located above 4GB.\n");
+				return 0;
+			}
+		} else {
+			efi_config_table_32_t *tbl = (efi_config_table_32_t *)config_tables + i;
+
+			guid  = tbl->guid;
+			table = tbl->table;
+		}
+
+		if (!(efi_guidcmp(guid, ACPI_TABLE_GUID)))
+			rsdp_addr = table;
+		else if (!(efi_guidcmp(guid, ACPI_20_TABLE_GUID)))
+			return table;
+	}
+#endif
+	return rsdp_addr;
+}
+
+/* EFI/kexec support is 64-bit only. */
+#ifdef CONFIG_X86_64
+static struct efi_setup_data *get_kexec_setup_data_addr(void)
+{
+	struct setup_data *data;
+	u64 pa_data;
+
+	pa_data = boot_params->hdr.setup_data;
+	while (pa_data) {
+		data = (struct setup_data *)pa_data;
+		if (data->type == SETUP_EFI)
+			return (struct efi_setup_data *)(pa_data + sizeof(struct setup_data));
+
+		pa_data = data->next;
+	}
+	return NULL;
+}
+
+static acpi_physical_address kexec_get_rsdp_addr(void)
+{
+	efi_system_table_64_t *systab;
+	struct efi_setup_data *esd;
+	struct efi_info *ei;
+	char *sig;
+
+	esd = (struct efi_setup_data *)get_kexec_setup_data_addr();
+	if (!esd)
+		return 0;
+
+	if (!esd->tables) {
+		debug_putstr("Wrong kexec SETUP_EFI data.\n");
+		return 0;
+	}
+
+	ei = &boot_params->efi_info;
+	sig = (char *)&ei->efi_loader_signature;
+	if (strncmp(sig, EFI64_LOADER_SIGNATURE, 4)) {
+		debug_putstr("Wrong kexec EFI loader signature.\n");
+		return 0;
+	}
+
+	/* Get systab from boot params. */
+	systab = (efi_system_table_64_t *) (ei->efi_systab | ((__u64)ei->efi_systab_hi << 32));
+	if (!systab)
+		error("EFI system table not found in kexec boot_params.");
+
+	return __efi_get_rsdp_addr((unsigned long)esd->tables, systab->nr_tables, true);
+}
+#else
+static acpi_physical_address kexec_get_rsdp_addr(void) { return 0; }
+#endif /* CONFIG_X86_64 */
+
+static acpi_physical_address efi_get_rsdp_addr(void)
+{
+#ifdef CONFIG_EFI
+	unsigned long systab, config_tables;
 	unsigned int nr_tables;
 	struct efi_info *ei;
 	bool efi_64;
-	int size, i;
 	char *sig;
 
 	ei = &boot_params->efi_info;
@@ -88,49 +180,20 @@ static acpi_physical_address efi_get_rsd
 
 		config_tables	= stbl->tables;
 		nr_tables	= stbl->nr_tables;
-		size		= sizeof(efi_config_table_64_t);
 	} else {
 		efi_system_table_32_t *stbl = (efi_system_table_32_t *)systab;
 
 		config_tables	= stbl->tables;
 		nr_tables	= stbl->nr_tables;
-		size		= sizeof(efi_config_table_32_t);
 	}
 
 	if (!config_tables)
 		error("EFI config tables not found.");
 
-	/* Get EFI tables from systab. */
-	for (i = 0; i < nr_tables; i++) {
-		acpi_physical_address table;
-		efi_guid_t guid;
-
-		config_tables += size;
-
-		if (efi_64) {
-			efi_config_table_64_t *tbl = (efi_config_table_64_t *)config_tables;
-
-			guid  = tbl->guid;
-			table = tbl->table;
-
-			if (!IS_ENABLED(CONFIG_X86_64) && table >> 32) {
-				debug_putstr("Error getting RSDP address: EFI config table located above 4GB.\n");
-				return 0;
-			}
-		} else {
-			efi_config_table_32_t *tbl = (efi_config_table_32_t *)config_tables;
-
-			guid  = tbl->guid;
-			table = tbl->table;
-		}
-
-		if (!(efi_guidcmp(guid, ACPI_TABLE_GUID)))
-			rsdp_addr = table;
-		else if (!(efi_guidcmp(guid, ACPI_20_TABLE_GUID)))
-			return table;
-	}
+	return __efi_get_rsdp_addr(config_tables, nr_tables, efi_64);
+#else
+	return 0;
 #endif
-	return rsdp_addr;
 }
 
 static u8 compute_checksum(u8 *buffer, u32 length)
@@ -220,6 +283,14 @@ acpi_physical_address get_rsdp_addr(void
 	if (!pa)
 		pa = boot_params->acpi_rsdp_addr;
 
+	/*
+	 * Try to get EFI data from setup_data. This can happen when we're a
+	 * kexec'ed kernel and kexec(1) has passed all the required EFI info to
+	 * us.
+	 */
+	if (!pa)
+		pa = kexec_get_rsdp_addr();
+
 	if (!pa)
 		pa = efi_get_rsdp_addr();
 


