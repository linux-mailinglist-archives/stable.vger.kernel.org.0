Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1870C1F9EF5
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgFOSA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 14:00:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:50585 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgFOSAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 14:00:25 -0400
IronPort-SDR: W5WiG3gZensmnGz6U/gzCqOqerLcIGTt1wqxGC7zw5AqrPoy8ZfMEn1IwPRppvNBZhZ4dmo6gs
 7gh8aPTwkQcw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 11:00:25 -0700
IronPort-SDR: sw4+WFG0hElSW8LcadUuFGMLAQgylglBdyNtHlF/8OCUHPgoGgL5Vbv5Ru3S5O08gqFK8Oc9rN
 DmwvB2KoOHoA==
X-IronPort-AV: E=Sophos;i="5.73,515,1583222400"; 
   d="scan'208";a="298600582"
Received: from agluck-desk2.sc.intel.com ([10.3.52.68])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 11:00:24 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     stable@vger.kernel.org
Cc:     "Luck, Tony" <tony.luck@intel.com>, Jue Wang <juew@google.com>
Subject: [PATCH stable 5.6, 5.7] x86/mm: Change so poison pages are either unmapped or marked uncacheable
Date:   Mon, 15 Jun 2020 11:00:24 -0700
Message-Id: <20200615180024.24452-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>

commit 17fae1294ad9d711b2c3dd0edef479d40c76a5e8 upstream

An interesting thing happened when a guest Linux instance took
a machine check. The VMM unmapped the bad page from guest physical
space and passed the machine check to the guest.

Linux took all the normal actions to offline the page from the process
that was using it. But then guest Linux crashed because it said there
was a second machine check inside the kernel with this stack trace:

do_memory_failure
    set_mce_nospec
         set_memory_uc
              _set_memory_uc
                   change_page_attr_set_clr
                        cpa_flush
                             clflush_cache_range_opt

This was odd, because a CLFLUSH instruction shouldn't raise a machine
check (it isn't consuming the data). Further investigation showed that
the VMM had passed in another machine check because is appeared that the
guest was accessing the bad page.

Fix is to check the scope of the poison by checking the MCi_MISC register.
If the entire page is affected, then unmap the page. If only part of the
page is affected, then mark the page as uncacheable.

This assumes that VMMs will do the logical thing and pass in the "whole
page scope" via the MCi_MISC register (since they unmapped the entire
page).

Reported-by: Jue Wang <juew@google.com>
Tested-by: Jue Wang <juew@google.com>
Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set, clear}_mce_nospec()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20200520163546.GA7977@agluck-desk2.amr.corp.intel.com
---
 arch/x86/include/asm/set_memory.h | 19 +++++++++++++------
 arch/x86/kernel/cpu/mce/core.c    | 11 +++++++++--
 include/linux/set_memory.h        |  2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ec2c0a094b5d..5948218f35c5 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,28 +86,35 @@ int set_direct_map_default_noflush(struct page *page);
 extern int kernel_set_to_readonly;
 
 #ifdef CONFIG_X86_64
-static inline int set_mce_nospec(unsigned long pfn)
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	unsigned long decoy_addr;
 	int rc;
 
 	/*
-	 * Mark the linear address as UC to make sure we don't log more
-	 * errors because of speculative access to the page.
 	 * We would like to just call:
-	 *      set_memory_uc((unsigned long)pfn_to_kaddr(pfn), 1);
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
 	 * but doing that would radically increase the odds of a
 	 * speculative access to the poison page because we'd have
 	 * the virtual address of the kernel 1:1 mapping sitting
 	 * around in registers.
 	 * Instead we get tricky.  We create a non-canonical address
 	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_uc() properly sanitizing any __pa()
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
 	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
 	 */
 	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
 
-	rc = set_memory_uc(decoy_addr, 1);
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
 	if (rc)
 		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
 	return rc;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 54165f3569e8..c1a480a27164 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -529,6 +529,13 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
+static bool whole_page(struct mce *m)
+{
+	if (!mca_cfg.ser || !(m->status & MCI_STATUS_MISCV))
+		return true;
+	return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;
+}
+
 bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
@@ -600,7 +607,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 
 	pfn = mce->addr >> PAGE_SHIFT;
 	if (!memory_failure(pfn, 0))
-		set_mce_nospec(pfn);
+		set_mce_nospec(pfn, whole_page(mce));
 
 	return NOTIFY_OK;
 }
@@ -1098,7 +1105,7 @@ static int do_memory_failure(struct mce *m)
 	if (ret)
 		pr_err("Memory error not recovered");
 	else
-		set_mce_nospec(m->addr >> PAGE_SHIFT);
+		set_mce_nospec(m->addr >> PAGE_SHIFT, whole_page(m));
 	return ret;
 }
 
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 86281ac7c305..860e0f843c12 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -26,7 +26,7 @@ static inline int set_direct_map_default_noflush(struct page *page)
 #endif
 
 #ifndef set_mce_nospec
-static inline int set_mce_nospec(unsigned long pfn)
+static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }
-- 
2.21.1

