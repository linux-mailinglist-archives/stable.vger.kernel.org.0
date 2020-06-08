Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5981F1959
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgFHMyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:54:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:62072 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbgFHMyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 08:54:36 -0400
IronPort-SDR: xm+SC2q5rsGoTSwsJINpdVMHDXl4wIWa5jkITLGloQrhaQ/EHzmWSDPre9e2TqHYzDBSzctym/
 PesANgFJ7qKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 05:54:35 -0700
IronPort-SDR: KEqQaB2sMxoC1CNPxMnKuLgPvBAWbnAy77aEs/+afjjth1efB6uzAqm4c8Z6yQ8Lu1VYKdFS4v
 aMzv5FS6xobg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="349160340"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2020 05:54:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id ADB65180; Mon,  8 Jun 2020 15:54:30 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org
Subject: [PATCHv2 1/2] x86/mm: Fix boot with some memory above MAXMEM
Date:   Mon,  8 Jun 2020 15:54:23 +0300
Message-Id: <20200608125424.70198-2-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200608125424.70198-1-kirill.shutemov@linux.intel.com>
References: <20200608125424.70198-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A 5-level paging capable machine can have memory above 46-bit in the
physical address space. This memory is only addressable in the 5-level
paging mode: we don't have enough virtual address space to create direct
mapping for such memory in the 4-level paging mode.

Currently, we fail boot completely: NULL pointer dereference in
subsection_map_init().

Skip creating a memblock for such memory instead and notify user that
some memory is not addressable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Cc: stable@vger.kernel.org # v4.14
---
 arch/x86/kernel/e820.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c5399e80c59c..c10bab121916 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -16,6 +16,7 @@
 #include <linux/firmware-map.h>
 #include <linux/sort.h>
 #include <linux/memory_hotplug.h>
+#include <linux/string_helpers.h>
 
 #include <asm/e820/api.h>
 #include <asm/setup.h>
@@ -1280,8 +1281,8 @@ void __init e820__memory_setup(void)
 
 void __init e820__memblock_setup(void)
 {
+	u64 size, end, not_addressable = 0;
 	int i;
-	u64 end;
 
 	/*
 	 * The bootstrap memblock region count maximum is 128 entries
@@ -1307,7 +1308,26 @@ void __init e820__memblock_setup(void)
 		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
 			continue;
 
-		memblock_add(entry->addr, entry->size);
+		if (entry->addr >= MAXMEM) {
+			not_addressable += entry->size;
+			continue;
+		}
+
+		end = min_t(u64, end, MAXMEM - 1);
+		size = end - entry->addr;
+		not_addressable += entry->size - size;
+		memblock_add(entry->addr, size);
+	}
+
+	if (not_addressable) {
+		char tmp[10];
+
+		string_get_size(not_addressable, 1, STRING_UNITS_2, tmp, sizeof(tmp));
+		pr_err("%s of physical memory is not addressable in the %s paging mode\n",
+		       tmp, pgtable_l5_enabled() ? "5-level" : "4-level");
+
+		if (!pgtable_l5_enabled())
+			pr_err("Consider enabling 5-level paging\n");
 	}
 
 	/* Throw away partial pages: */
-- 
2.26.2

