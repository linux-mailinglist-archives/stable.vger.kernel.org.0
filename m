Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC168496EC3
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiAWAOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:14:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46210 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiAWAN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:13:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AD9E2CE0920;
        Sun, 23 Jan 2022 00:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0A8C004E1;
        Sun, 23 Jan 2022 00:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896789;
        bh=ZAJLC2q3cS+5sfPOv6QANM6EFxVWb/Mgf7brJEM1cng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXLjTgW25Ktb371kRf65dBgVcD+7osTb7rRggfcM6K8jJqjShEJSXOtlhjCsPE5to
         IEyV0spxdhgDouiEZjHm7q9ECe/d7QWClWhYUKcl/rrHQ5E0vdL9HTAut8OOKYXuu9
         IurFCcZv5Tel6g5rMUpMHMAsxQK8k6mt8fG8Dom5QFaBGwEtfIv8BCVtajluZ3gjs2
         EFRSs5dHFORmH9PpG9cIHIzXJo8vWNnCIQeLO39ftWTd7qkXacjo5EIKUkFB+FpSqo
         bgSwFOdamp8GEKCbzzMXuUc3AKbvNLDM0OXZ6Z8Ta6X2o8g3aTlxgDpu4ZSDwwnvUE
         bcb9PyEhEBvdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: [PATCH AUTOSEL 5.10 2/9] x86/PCI: Ignore E820 reservations for bridge windows on newer systems
Date:   Sat, 22 Jan 2022 19:12:51 -0500
Message-Id: <20220123001258.2460594-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001258.2460594-1-sashal@kernel.org>
References: <20220123001258.2460594-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7f7b4236f2040d19df1ddaf30047128b41e78de7 ]

Some BIOS-es contain a bug where they add addresses which map to system
RAM in the PCI host bridge window returned by the ACPI _CRS method, see
commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
space").

To work around this bug Linux excludes E820 reserved addresses when
allocating addresses from the PCI host bridge window since 2010.

Recently (2019) some systems have shown-up with E820 reservations which
cover the entire _CRS returned PCI bridge memory window, causing all
attempts to assign memory to PCI BARs which have not been setup by the
BIOS to fail. For example here are the relevant dmesg bits from a
Lenovo IdeaPad 3 15IIL 81WE:

 [mem 0x000000004bc50000-0x00000000cfffffff] reserved
 pci_bus 0000:00: root bus resource [mem 0x65400000-0xbfffffff window]

The ACPI specifications appear to allow this new behavior:

The relationship between E820 and ACPI _CRS is not really very clear.
ACPI v6.3, sec 15, table 15-374, says AddressRangeReserved means:

  This range of addresses is in use or reserved by the system and is
  not to be included in the allocatable memory pool of the operating
  system's memory manager.

and it may be used when:

  The address range is in use by a memory-mapped system device.

Furthermore, sec 15.2 says:

  Address ranges defined for baseboard memory-mapped I/O devices, such
  as APICs, are returned as reserved.

A PCI host bridge qualifies as a baseboard memory-mapped I/O device,
and its apertures are in use and certainly should not be included in
the general allocatable pool, so the fact that some BIOS-es reports
the PCI aperture as "reserved" in E820 doesn't seem like a BIOS bug.

So it seems that the excluding of E820 reserved addresses is a mistake.

Ideally Linux would fully stop excluding E820 reserved addresses,
but then the old systems this was added for will regress.
Instead keep the old behavior for old systems, while ignoring
the E820 reservations for any systems from now on.

Old systems are defined here as BIOS year < 2018, this was chosen to make
sure that E820 reservations will not be used on the currently affected
systems, while at the same time also taking into account that the systems
for which the E820 checking was originally added may have received BIOS
updates for quite a while (esp. CVE related ones), giving them a more
recent BIOS year then 2010.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206459
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1868899
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1871793
BugLink: https://bugs.launchpad.net/bugs/1878279
BugLink: https://bugs.launchpad.net/bugs/1931715
BugLink: https://bugs.launchpad.net/bugs/1932069
BugLink: https://bugs.launchpad.net/bugs/1921649
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/resource.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 9b9fb7882c206..9ae64f9af9568 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/dmi.h>
 #include <linux/ioport.h>
 #include <asm/e820/api.h>
 
@@ -23,11 +24,31 @@ static void resource_clip(struct resource *res, resource_size_t start,
 		res->start = end + 1;
 }
 
+/*
+ * Some BIOS-es contain a bug where they add addresses which map to
+ * system RAM in the PCI host bridge window returned by the ACPI _CRS
+ * method, see commit 4dc2287c1805 ("x86: avoid E820 regions when
+ * allocating address space"). To avoid this Linux by default excludes
+ * E820 reservations when allocating addresses since 2010.
+ * In 2019 some systems have shown-up with E820 reservations which cover
+ * the entire _CRS returned PCI host bridge window, causing all attempts
+ * to assign memory to PCI BARs to fail if Linux uses E820 reservations.
+ *
+ * Ideally Linux would fully stop using E820 reservations, but then
+ * the old systems this was added for will regress.
+ * Instead keep the old behavior for old systems, while ignoring the
+ * E820 reservations for any systems from now on.
+ */
 static void remove_e820_regions(struct resource *avail)
 {
-	int i;
+	int i, year = dmi_get_bios_year();
 	struct e820_entry *entry;
 
+	if (year >= 2018)
+		return;
+
+	pr_info_once("PCI: Removing E820 reservations from host bridge windows\n");
+
 	for (i = 0; i < e820_table->nr_entries; i++) {
 		entry = &e820_table->entries[i];
 
-- 
2.34.1

