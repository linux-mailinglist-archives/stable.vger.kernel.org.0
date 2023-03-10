Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5876B6B4388
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCJOPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjCJOPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3D016337
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 227B46187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8C7C433D2;
        Fri, 10 Mar 2023 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457633;
        bh=XDbIqOjVStOKA90C5EH2Js/HyVXZVdddZGhRbicevvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV7vFZoawU6+VUzDqC4AyqbeVsmjdrJEuNl1Jr+4HZUMT5TynTGq1DipoubynUyiD
         Y+1jI084/spKRLrFEguGARaEcivV0WjLIjL24pGeZ56qJsAK4RwX0/VpPbVjpRZQ28
         +/Xpzi12nsIhuuy1xY1k2C7MN/O4nWPU6eBNUMVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 198/200] arm64: mte: Fix/clarify the PG_mte_tagged semantics
Date:   Fri, 10 Mar 2023 14:40:05 +0100
Message-Id: <20230310133723.161327844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit e059853d14ca4ed0f6a190d7109487918a22a976 upstream.

Currently the PG_mte_tagged page flag mostly means the page contains
valid tags and it should be set after the tags have been cleared or
restored. However, in mte_sync_tags() it is set before setting the tags
to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
write in another thread can cause the new page to have stale tags.
Similarly, tag reading via ptrace() can read stale tags if the
PG_mte_tagged flag is set before actually clearing/restoring the tags.

Fix the PG_mte_tagged semantics so that it is only set after the tags
have been cleared or restored. This is safe for swap restoring into a
MAP_SHARED or CoW page since the core code takes the page lock. Add two
functions to test and set the PG_mte_tagged flag with acquire and
release semantics. The downside is that concurrent mprotect(PROT_MTE) on
a MAP_SHARED page may cause tag loss. This is already the case for KVM
guests if a VMM changes the page protection while the guest triggers a
user_mem_abort().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[pcc@google.com: fix build with CONFIG_ARM64_MTE disabled]
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221104011041.290951-3-pcc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mte.h     |   30 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/arm64/kernel/cpufeature.c   |    4 +++-
 arch/arm64/kernel/elfcore.c      |    2 +-
 arch/arm64/kernel/hibernate.c    |    2 +-
 arch/arm64/kernel/mte.c          |   17 +++++++++++------
 arch/arm64/kvm/guest.c           |    4 ++--
 arch/arm64/kvm/mmu.c             |    4 ++--
 arch/arm64/mm/copypage.c         |    5 +++--
 arch/arm64/mm/fault.c            |    2 +-
 arch/arm64/mm/mteswap.c          |    2 +-
 11 files changed, 56 insertions(+), 18 deletions(-)

--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -37,6 +37,29 @@ void mte_free_tag_storage(char *storage)
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+	/*
+	 * Ensure that the tags written prior to this function are visible
+	 * before the page flags update.
+	 */
+	smp_wmb();
+	set_bit(PG_mte_tagged, &page->flags);
+}
+
+static inline bool page_mte_tagged(struct page *page)
+{
+	bool ret = test_bit(PG_mte_tagged, &page->flags);
+
+	/*
+	 * If the page is tagged, ensure ordering with a likely subsequent
+	 * read of the tags.
+	 */
+	if (ret)
+		smp_rmb();
+	return ret;
+}
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -56,6 +79,13 @@ size_t mte_probe_user_range(const char _
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+}
+static inline bool page_mte_tagged(struct page *page)
+{
+	return false;
+}
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1050,7 +1050,7 @@ static inline void arch_swap_invalidate_
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_bit(PG_mte_tagged, &folio->flags);
+		set_page_mte_tagged(&folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2074,8 +2074,10 @@ static void cpu_enable_mte(struct arm64_
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (!page_mte_tagged(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+		set_page_mte_tagged(ZERO_PAGE(0));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -46,7 +46,7 @@ static int mte_dump_tag_range(struct cor
 		 * Pages mapped in user space as !pte_access_permitted() (e.g.
 		 * PROT_EXEC only) may not have the PG_mte_tagged flag set.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			put_page(page);
 			dump_skip(cprm, MTE_PAGE_TAG_STORAGE);
 			continue;
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -271,7 +271,7 @@ static int swsusp_mte_save_tags(void)
 			if (!page)
 				continue;
 
-			if (!test_bit(PG_mte_tagged, &page->flags))
+			if (!page_mte_tagged(page))
 				continue;
 
 			ret = save_tags(page, pfn);
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,8 +41,10 @@ static void mte_sync_page_tags(struct pa
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
+		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
+			set_page_mte_tagged(page);
 			return;
+		}
 	}
 
 	if (!pte_is_tagged)
@@ -52,8 +54,10 @@ static void mte_sync_page_tags(struct pa
 	 * Test PG_mte_tagged again in case it was racing with another
 	 * set_pte_at().
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page)) {
 		mte_clear_page_tags(page_address(page));
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -69,9 +73,11 @@ void mte_sync_tags(pte_t old_pte, pte_t
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags))
+		if (!page_mte_tagged(page)) {
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
+			set_page_mte_tagged(page);
+		}
 	}
 
 	/* ensure the tags are visible before the PTE is set */
@@ -96,8 +102,7 @@ int memcmp_pages(struct page *page1, str
 	 * pages is tagged, set_pte_at() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
-	if (test_bit(PG_mte_tagged, &page1->flags) ||
-	    test_bit(PG_mte_tagged, &page2->flags))
+	if (page_mte_tagged(page1) || page_mte_tagged(page2))
 		return addr1 != addr2;
 
 	return ret;
@@ -454,7 +459,7 @@ static int __access_remote_tags(struct m
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1059,7 +1059,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct k
 		maddr = page_address(page);
 
 		if (!write) {
-			if (test_bit(PG_mte_tagged, &page->flags))
+			if (page_mte_tagged(page))
 				num_tags = mte_copy_tags_to_user(tags, maddr,
 							MTE_GRANULES_PER_PAGE);
 			else
@@ -1076,7 +1076,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct k
 			 * completed fully
 			 */
 			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_bit(PG_mte_tagged, &page->flags);
+				set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1110,9 +1110,9 @@ static int sanitise_mte_tags(struct kvm
 		return -EFAULT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			mte_clear_page_tags(page_address(page));
-			set_bit(PG_mte_tagged, &page->flags);
+			set_page_mte_tagged(page);
 		}
 	}
 
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,9 +21,10 @@ void copy_highpage(struct page *to, stru
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
-		set_bit(PG_mte_tagged, &to->flags);
+	if (system_supports_mte() && page_mte_tagged(from)) {
+		page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
+		set_page_mte_tagged(to);
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -944,5 +944,5 @@ struct page *alloc_zeroed_user_highpage_
 void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
-	set_bit(PG_mte_tagged, &page->flags);
+	set_page_mte_tagged(page);
 }
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -24,7 +24,7 @@ int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!test_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page))
 		return 0;
 
 	tag_storage = mte_allocate_tag_storage();


