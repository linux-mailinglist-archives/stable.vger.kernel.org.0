Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD81181BE3
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 15:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgCKO64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 10:58:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38596 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgCKO64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 10:58:56 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jC2os-0002Ez-Pt; Wed, 11 Mar 2020 15:58:50 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 598211C2209;
        Wed, 11 Mar 2020 15:58:50 +0100 (CET)
Date:   Wed, 11 Mar 2020 14:58:50 -0000
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioremap: Map EFI runtime services data as
 encrypted for SEV
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: =?utf-8?q?=3C2d9e16eb5b53dc82665c95c6764b7407719df7a0=2E15826?=
 =?utf-8?q?45327=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C2d9e16eb5b53dc82665c95c6764b7407719df7a0=2E158264?=
 =?utf-8?q?5327=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <158393873003.28353.16382331068625290742.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     985e537a4082b4635754a57f4f95430790afee6a
Gitweb:        https://git.kernel.org/tip/985e537a4082b4635754a57f4f95430790afee6a
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Tue, 10 Mar 2020 18:35:57 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 11 Mar 2020 15:54:54 +01:00

x86/ioremap: Map EFI runtime services data as encrypted for SEV

The dmidecode program fails to properly decode the SMBIOS data supplied
by OVMF/UEFI when running in an SEV guest. The SMBIOS area, under SEV, is
encrypted and resides in reserved memory that is marked as EFI runtime
services data.

As a result, when memremap() is attempted for the SMBIOS data, it
can't be mapped as regular RAM (through try_ram_remap()) and, since
the address isn't part of the iomem resources list, it isn't mapped
encrypted through the fallback ioremap().

Add a new __ioremap_check_other() to deal with memory types like
EFI_RUNTIME_SERVICES_DATA which are not covered by the resource ranges.

This allows any runtime services data which has been created encrypted,
to be mapped encrypted too.

 [ bp: Move functionality to a separate function. ]

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org> # 5.3
Link: https://lkml.kernel.org/r/2d9e16eb5b53dc82665c95c6764b7407719df7a0.1582645327.git.thomas.lendacky@amd.com
---
 arch/x86/mm/ioremap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 44e4beb..935a91e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -106,6 +106,19 @@ static unsigned int __ioremap_check_encrypted(struct resource *res)
 	return 0;
 }
 
+/*
+ * The EFI runtime services data area is not covered by walk_mem_res(), but must
+ * be mapped encrypted when SEV is active.
+ */
+static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *desc)
+{
+	if (!sev_active())
+		return;
+
+	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
+		desc->flags |= IORES_MAP_ENCRYPTED;
+}
+
 static int __ioremap_collect_map_flags(struct resource *res, void *arg)
 {
 	struct ioremap_desc *desc = arg;
@@ -124,6 +137,9 @@ static int __ioremap_collect_map_flags(struct resource *res, void *arg)
  * To avoid multiple resource walks, this function walks resources marked as
  * IORESOURCE_MEM and IORESOURCE_BUSY and looking for system RAM and/or a
  * resource described not as IORES_DESC_NONE (e.g. IORES_DESC_ACPI_TABLES).
+ *
+ * After that, deal with misc other ranges in __ioremap_check_other() which do
+ * not fall into the above category.
  */
 static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 				struct ioremap_desc *desc)
@@ -135,6 +151,8 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 	memset(desc, 0, sizeof(struct ioremap_desc));
 
 	walk_mem_res(start, end, desc, __ioremap_collect_map_flags);
+
+	__ioremap_check_other(addr, desc);
 }
 
 /*
