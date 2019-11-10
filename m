Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A713EF6294
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKJCoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfKJCoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C7C222CD;
        Sun, 10 Nov 2019 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353845;
        bh=bM9cRdbOq7bN8J7dnv5tjh1Vva7808rZD3E11I9ZnJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17aQd07OtDYdVJoySJfKD/nPUVXadvvE7ObqL119f+QpXN/9JMgPjydJpeNEI6Xks
         NGuye8zx8lOBkWoje30pE4oCcmXIcWZ8PCZJHOBnKlSax2wstJkLujm4HPKwdEduTh
         46MCzb8JfOj1uaul5DDj+XTDGz50OdpD4FvFsTOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations passed via a linux specific config table
Date:   Sat,  9 Nov 2019 21:39:15 -0500
Message-Id: <20191110024013.29782-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]

In order to allow the OS to reserve memory persistently across a
kexec, introduce a Linux-specific UEFI configuration table that
points to the head of a linked list in memory, allowing each kernel
to add list items describing memory regions that the next kernel
should treat as reserved.

This is useful, e.g., for GICv3 based ARM systems that cannot disable
DMA access to the LPI tables, forcing them to reuse the same memory
region again after a kexec reboot.

Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 27 ++++++++++++++++++++++++++-
 include/linux/efi.h        |  8 ++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d54fca902e64f..f265309859781 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -52,7 +52,8 @@ struct efi __read_mostly efi = {
 	.properties_table	= EFI_INVALID_TABLE_ADDR,
 	.mem_attr_table		= EFI_INVALID_TABLE_ADDR,
 	.rng_seed		= EFI_INVALID_TABLE_ADDR,
-	.tpm_log		= EFI_INVALID_TABLE_ADDR
+	.tpm_log		= EFI_INVALID_TABLE_ADDR,
+	.mem_reserve		= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -487,6 +488,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
 	{LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
 	{LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
+	{LINUX_EFI_MEMRESERVE_TABLE_GUID, "MEMRESERVE", &efi.mem_reserve},
 	{NULL_GUID, NULL, NULL},
 };
 
@@ -594,6 +596,29 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		early_memunmap(tbl, sizeof(*tbl));
 	}
 
+	if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
+		unsigned long prsv = efi.mem_reserve;
+
+		while (prsv) {
+			struct linux_efi_memreserve *rsv;
+
+			/* reserve the entry itself */
+			memblock_reserve(prsv, sizeof(*rsv));
+
+			rsv = early_memremap(prsv, sizeof(*rsv));
+			if (rsv == NULL) {
+				pr_err("Could not map UEFI memreserve entry!\n");
+				return -ENOMEM;
+			}
+
+			if (rsv->size)
+				memblock_reserve(rsv->base, rsv->size);
+
+			prsv = rsv->next;
+			early_memunmap(rsv, sizeof(*rsv));
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc3391796c0b8..f43fc61fbe2c9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -672,6 +672,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
 #define LINUX_EFI_RANDOM_SEED_TABLE_GUID	EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
 #define LINUX_EFI_TPM_EVENT_LOG_GUID		EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
+#define LINUX_EFI_MEMRESERVE_TABLE_GUID		EFI_GUID(0x888eb0c6, 0x8ede, 0x4ff5,  0xa8, 0xf0, 0x9a, 0xee, 0x5c, 0xb9, 0x77, 0xc2)
 
 typedef struct {
 	efi_guid_t guid;
@@ -957,6 +958,7 @@ extern struct efi {
 	unsigned long mem_attr_table;	/* memory attributes table */
 	unsigned long rng_seed;		/* UEFI firmware random seed */
 	unsigned long tpm_log;		/* TPM2 Event Log table */
+	unsigned long mem_reserve;	/* Linux EFI memreserve table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -1667,4 +1669,10 @@ extern int efi_tpm_eventlog_init(void);
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
+struct linux_efi_memreserve {
+	phys_addr_t	next;
+	phys_addr_t	base;
+	phys_addr_t	size;
+};
+
 #endif /* _LINUX_EFI_H */
-- 
2.20.1

