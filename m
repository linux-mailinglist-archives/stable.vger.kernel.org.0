Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57B54155F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359379AbiFGUf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377209AbiFGUc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7E01E3B12;
        Tue,  7 Jun 2022 11:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E35161552;
        Tue,  7 Jun 2022 18:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABBFC385A5;
        Tue,  7 Jun 2022 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626874;
        bh=LF1vIGrxFRi8ROAYUdvZubMa66w/+arlvkmdlFTpdtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhmG3s/8mAnZzankbmDllKO8kL7F+WupaMmVyWC1Lu1tmmk2HNBYHZTtaz6xGXyO/
         K1e/FcuFdVfZ49C8ukRvyJwYM9oNmWRtqTjK8dWq/Q64T0LGpADGP53sLKdeghoDZG
         fgrIQzBMrS9Ze8yXFNdTpOaf+K/iZsK1ONH7iml4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jane Chu <jane.chu@oracle.com>, Borislav Petkov <bp@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 535/772] x86/mce: relocate set{clear}_mce_nospec() functions
Date:   Tue,  7 Jun 2022 19:02:07 +0200
Message-Id: <20220607165004.733121634@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit b3fdf9398a16f01dc013967a4ab25e99c3f4fc12 ]

Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
file where they belong.

While at it, fixup a function name in a comment.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
[sfr: gate {set,clear}_mce_nospec() by CONFIG_X86_64]
Link: https://lore.kernel.org/r/165272527328.90175.8336008202048685278.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/set_memory.h | 52 -------------------------------
 arch/x86/mm/pat/set_memory.c      | 50 +++++++++++++++++++++++++++--
 include/linux/set_memory.h        |  8 ++---
 3 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ff0f2d90338a..648be0bd20df 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -88,56 +88,4 @@ void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc);
 
 extern int kernel_set_to_readonly;
 
-#ifdef CONFIG_X86_64
-/*
- * Prevent speculative access to the page by either unmapping
- * it (if we do not require access to any part of the page) or
- * marking it uncacheable (if we want to try to retrieve data
- * from non-poisoned lines in the page).
- */
-static inline int set_mce_nospec(unsigned long pfn, bool unmap)
-{
-	unsigned long decoy_addr;
-	int rc;
-
-	/* SGX pages are not in the 1:1 map */
-	if (arch_is_platform_page(pfn << PAGE_SHIFT))
-		return 0;
-	/*
-	 * We would like to just call:
-	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
-	 * but doing that would radically increase the odds of a
-	 * speculative access to the poison page because we'd have
-	 * the virtual address of the kernel 1:1 mapping sitting
-	 * around in registers.
-	 * Instead we get tricky.  We create a non-canonical address
-	 * that looks just like the one we want, but has bit 63 flipped.
-	 * This relies on set_memory_XX() properly sanitizing any __pa()
-	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
-	 */
-	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
-
-	if (unmap)
-		rc = set_memory_np(decoy_addr, 1);
-	else
-		rc = set_memory_uc(decoy_addr, 1);
-	if (rc)
-		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
-	return rc;
-}
-#define set_mce_nospec set_mce_nospec
-
-/* Restore full speculative operation to the pfn. */
-static inline int clear_mce_nospec(unsigned long pfn)
-{
-	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
-}
-#define clear_mce_nospec clear_mce_nospec
-#else
-/*
- * Few people would run a 32-bit kernel on a machine that supports
- * recoverable errors because they have too much memory to boot 32-bit.
- */
-#endif
-
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b4072115c8ef..b143972885eb 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -19,6 +19,7 @@
 #include <linux/vmstat.h>
 #include <linux/kernel.h>
 #include <linux/cc_platform.h>
+#include <linux/set_memory.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -29,7 +30,6 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/memtype.h>
-#include <asm/set_memory.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
 
@@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
 }
 
 /*
- * _set_memory_prot is an internal helper for callers that have been passed
+ * __set_memory_prot is an internal helper for callers that have been passed
  * a pgprot_t value from upper layers and a reservation has already been taken.
  * If you want to set the pgprot to a specific page protocol, use the
  * set_memory_xx() functions.
@@ -1925,6 +1925,52 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+/*
+ * Prevent speculative access to the page by either unmapping
+ * it (if we do not require access to any part of the page) or
+ * marking it uncacheable (if we want to try to retrieve data
+ * from non-poisoned lines in the page).
+ */
+#ifdef CONFIG_X86_64
+int set_mce_nospec(unsigned long pfn, bool unmap)
+{
+	unsigned long decoy_addr;
+	int rc;
+
+	/* SGX pages are not in the 1:1 map */
+	if (arch_is_platform_page(pfn << PAGE_SHIFT))
+		return 0;
+	/*
+	 * We would like to just call:
+	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
+	 * but doing that would radically increase the odds of a
+	 * speculative access to the poison page because we'd have
+	 * the virtual address of the kernel 1:1 mapping sitting
+	 * around in registers.
+	 * Instead we get tricky.  We create a non-canonical address
+	 * that looks just like the one we want, but has bit 63 flipped.
+	 * This relies on set_memory_XX() properly sanitizing any __pa()
+	 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
+	 */
+	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
+
+	if (unmap)
+		rc = set_memory_np(decoy_addr, 1);
+	else
+		rc = set_memory_uc(decoy_addr, 1);
+	if (rc)
+		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
+	return rc;
+}
+
+/* Restore full speculative operation to the pfn. */
+int clear_mce_nospec(unsigned long pfn)
+{
+	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
+}
+EXPORT_SYMBOL_GPL(clear_mce_nospec);
+#endif /* CONFIG_X86_64 */
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index f36be5166c19..683a6c3f7179 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -42,14 +42,14 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
-#ifndef set_mce_nospec
+#ifdef CONFIG_X86_64
+int set_mce_nospec(unsigned long pfn, bool unmap);
+int clear_mce_nospec(unsigned long pfn);
+#else
 static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 {
 	return 0;
 }
-#endif
-
-#ifndef clear_mce_nospec
 static inline int clear_mce_nospec(unsigned long pfn)
 {
 	return 0;
-- 
2.35.1



