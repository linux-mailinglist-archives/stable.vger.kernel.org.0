Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B3C373A16
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhEEMHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhEEMHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFC4161166;
        Wed,  5 May 2021 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216369;
        bh=pOl4JXZJE8NMHzH5c/4nuMjUotQ+2d4GEpFy+tssYdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBTufD4kbABHJQWei8DVp5eYWrcHNBXGph0ZHcZMTqwjSicrRktkipIDkUqY/aCZT
         m0rCTbjb1kBGHlMFc7tuKBZaIdNdPbNP1bSZLnDDKTn13E9Lj06GeyJmlEh3zQM++U
         qvPTwaqUEqBaX9hhrMolTkNABsbdkaR4bScVKH18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH 4.19 02/15] ACPI: tables: x86: Reserve memory occupied by ACPI tables
Date:   Wed,  5 May 2021 14:05:07 +0200
Message-Id: <20210505120503.862413359@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
References: <20210505120503.781531508@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a upstream.

The following problem has been reported by George Kennedy:

 Since commit 7fef431be9c9 ("mm/page_alloc: place pages to tail
 in __free_pages_core()") the following use after free occurs
 intermittently when ACPI tables are accessed.

 BUG: KASAN: use-after-free in ibft_init+0x134/0xc49
 Read of size 4 at addr ffff8880be453004 by task swapper/0/1
 CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.12.0-rc1-7a7fd0d #1
 Call Trace:
  dump_stack+0xf6/0x158
  print_address_description.constprop.9+0x41/0x60
  kasan_report.cold.14+0x7b/0xd4
  __asan_report_load_n_noabort+0xf/0x20
  ibft_init+0x134/0xc49
  do_one_initcall+0xc4/0x3e0
  kernel_init_freeable+0x5af/0x66b
  kernel_init+0x16/0x1d0
  ret_from_fork+0x22/0x30

 ACPI tables mapped via kmap() do not have their mapped pages
 reserved and the pages can be "stolen" by the buddy allocator.

Apparently, on the affected system, the ACPI table in question is
not located in "reserved" memory, like ACPI NVS or ACPI Data, that
will not be used by the buddy allocator, so the memory occupied by
that table has to be explicitly reserved to prevent the buddy
allocator from using it.

In order to address this problem, rearrange the initialization of the
ACPI tables on x86 to locate the initial tables earlier and reserve
the memory occupied by them.

The other architectures using ACPI should not be affected by this
change.

Link: https://lore.kernel.org/linux-acpi/1614802160-29362-1-git-send-email-george.kennedy@oracle.com/
Reported-by: George Kennedy <george.kennedy@oracle.com>
Tested-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |   25 ++++++++++++-------------
 arch/x86/kernel/setup.c     |    8 +++-----
 drivers/acpi/tables.c       |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/acpi.h        |    9 ++++++++-
 4 files changed, 62 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1565,10 +1565,18 @@ void __init acpi_boot_table_init(void)
 	/*
 	 * Initialize the ACPI boot-time table parser.
 	 */
-	if (acpi_table_init()) {
+	if (acpi_locate_initial_tables())
 		disable_acpi();
-		return;
-	}
+	else
+		acpi_reserve_initial_tables();
+}
+
+int __init early_acpi_boot_init(void)
+{
+	if (acpi_disabled)
+		return 1;
+
+	acpi_table_init_complete();
 
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
@@ -1581,18 +1589,9 @@ void __init acpi_boot_table_init(void)
 		} else {
 			printk(KERN_WARNING PREFIX "Disabling ACPI support\n");
 			disable_acpi();
-			return;
+			return 1;
 		}
 	}
-}
-
-int __init early_acpi_boot_init(void)
-{
-	/*
-	 * If acpi_disabled, bail out
-	 */
-	if (acpi_disabled)
-		return 1;
 
 	/*
 	 * Process the Multiple APIC Description Table (MADT), if present
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1097,6 +1097,9 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
+	/* Look for ACPI tables and reserve memory occupied by them. */
+	acpi_boot_table_init();
+
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	e820__memblock_setup();
 
@@ -1183,11 +1186,6 @@ void __init setup_arch(char **cmdline_p)
 
 	early_platform_quirks();
 
-	/*
-	 * Parse the ACPI tables for possible boot-time SMP configuration.
-	 */
-	acpi_boot_table_init();
-
 	early_acpi_boot_init();
 
 	initmem_init();
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -732,7 +732,7 @@ acpi_os_table_override(struct acpi_table
 }
 
 /*
- * acpi_table_init()
+ * acpi_locate_initial_tables()
  *
  * find RSDP, find and checksum SDT/XSDT.
  * checksum all tables, print SDT/XSDT
@@ -740,7 +740,7 @@ acpi_os_table_override(struct acpi_table
  * result: sdt_entry[] is initialized
  */
 
-int __init acpi_table_init(void)
+int __init acpi_locate_initial_tables(void)
 {
 	acpi_status status;
 
@@ -755,9 +755,45 @@ int __init acpi_table_init(void)
 	status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
 	if (ACPI_FAILURE(status))
 		return -EINVAL;
-	acpi_table_initrd_scan();
 
+	return 0;
+}
+
+void __init acpi_reserve_initial_tables(void)
+{
+	int i;
+
+	for (i = 0; i < ACPI_MAX_TABLES; i++) {
+		struct acpi_table_desc *table_desc = &initial_tables[i];
+		u64 start = table_desc->address;
+		u64 size = table_desc->length;
+
+		if (!start || !size)
+			break;
+
+		pr_info("Reserving %4s table memory at [mem 0x%llx-0x%llx]\n",
+			table_desc->signature.ascii, start, start + size - 1);
+
+		memblock_reserve(start, size);
+	}
+}
+
+void __init acpi_table_init_complete(void)
+{
+	acpi_table_initrd_scan();
 	check_multiple_madt();
+}
+
+int __init acpi_table_init(void)
+{
+	int ret;
+
+	ret = acpi_locate_initial_tables();
+	if (ret)
+		return ret;
+
+	acpi_table_init_complete();
+
 	return 0;
 }
 
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -230,10 +230,14 @@ void __iomem *__acpi_map_table(unsigned
 void __acpi_unmap_table(void __iomem *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
+void acpi_boot_table_prepare (void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
 
+int acpi_locate_initial_tables (void);
+void acpi_reserve_initial_tables (void);
+void acpi_table_init_complete (void);
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
@@ -734,9 +738,12 @@ static inline int acpi_boot_init(void)
 	return 0;
 }
 
+static inline void acpi_boot_table_prepare(void)
+{
+}
+
 static inline void acpi_boot_table_init(void)
 {
-	return;
 }
 
 static inline int acpi_mps_check(void)


