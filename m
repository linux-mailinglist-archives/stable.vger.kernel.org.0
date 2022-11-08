Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA2F62208D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiKHX7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiKHX6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74902600;
        Tue,  8 Nov 2022 15:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 245AB617E4;
        Tue,  8 Nov 2022 23:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA27C433D6;
        Tue,  8 Nov 2022 23:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951906;
        bh=v/j4BcKetI9QOLu0i7vwgJd+47sLUqeWcAPYlKJuAVQ=;
        h=Date:To:From:Subject:From;
        b=xfbPQt3QJQ+A6wHcloF5KCLr4Y3cAGBnu1yd8O400L4OP06myDqAwmMlVCxtaEfqx
         0BKfGeK6dTUps6YJN2KZbspY36hHOhBnNRDDInyYkUW4G9pkDQyEWPKullT7agDIDc
         SRKHbys37KM40cZqdSfGAObhC9vWfFtpNpVgJRMI=
Date:   Tue, 08 Nov 2022 15:58:26 -0800
To:     mm-commits@vger.kernel.org, ville.syrjala@linux.intel.com,
        tglx@linutronix.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, osalvador@suse.de,
        mingo@redhat.com, mike.kravetz@oracle.com, liushixin2@huawei.com,
        linmiaohe@huawei.com, david@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arch-x86-mm-hugetlbpagec-pud_huge-returns-0-when-using-2-level-paging.patch removed from -mm tree
Message-Id: <20221108235826.7BA27C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: arch/x86/mm/hugetlbpage.c: pud_huge() returns 0 when using 2-level paging
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-hugetlbpagec-pud_huge-returns-0-when-using-2-level-paging.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: arch/x86/mm/hugetlbpage.c: pud_huge() returns 0 when using 2-level paging
Date: Mon, 7 Nov 2022 11:10:10 +0900

The following bug is reported to be triggered when starting X on x86-32
system with i915:

  [  225.777375] kernel BUG at mm/memory.c:2664!
  [  225.777391] invalid opcode: 0000 [#1] PREEMPT SMP
  [  225.777405] CPU: 0 PID: 2402 Comm: Xorg Not tainted 6.1.0-rc3-bdg+ #86
  [  225.777415] Hardware name:  /8I865G775-G, BIOS F1 08/29/2006
  [  225.777421] EIP: __apply_to_page_range+0x24d/0x31c
  [  225.777437] Code: ff ff 8b 55 e8 8b 45 cc e8 0a 11 ec ff 89 d8 83 c4 28 5b 5e 5f 5d c3 81 7d e0 a0 ef 96 c1 74 ad 8b 45 d0 e8 2d 83 49 00 eb a3 <0f> 0b 25 00 f0 ff ff 81 eb 00 00 00 40 01 c3 8b 45 ec 8b 00 e8 76
  [  225.777446] EAX: 00000001 EBX: c53a3b58 ECX: b5c00000 EDX: c258aa00
  [  225.777454] ESI: b5c00000 EDI: b5900000 EBP: c4b0fdb4 ESP: c4b0fd80
  [  225.777462] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010202
  [  225.777470] CR0: 80050033 CR2: b5900000 CR3: 053a3000 CR4: 000006d0
  [  225.777479] Call Trace:
  [  225.777486]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.777684]  apply_to_page_range+0x21/0x27
  [  225.777694]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.777870]  remap_io_mapping+0x49/0x75 [i915]
  [  225.778046]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.778220]  ? mutex_unlock+0xb/0xd
  [  225.778231]  ? i915_vma_pin_fence+0x6d/0xf7 [i915]
  [  225.778420]  vm_fault_gtt+0x2a9/0x8f1 [i915]
  [  225.778644]  ? lock_is_held_type+0x56/0xe7
  [  225.778655]  ? lock_is_held_type+0x7a/0xe7
  [  225.778663]  ? 0xc1000000
  [  225.778670]  __do_fault+0x21/0x6a
  [  225.778679]  handle_mm_fault+0x708/0xb21
  [  225.778686]  ? mt_find+0x21e/0x5ae
  [  225.778696]  exc_page_fault+0x185/0x705
  [  225.778704]  ? doublefault_shim+0x127/0x127
  [  225.778715]  handle_exception+0x130/0x130
  [  225.778723] EIP: 0xb700468a

Recently pud_huge() got aware of non-present entry by commit 3a194f3f8ad0
("mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present
pud entry") to handle some special states of gigantic page.  However, it's
overlooked that pud_none() always returns false when running with 2-level
paging, and as a result pud_huge() can return true pointlessly.

Introduce "#if CONFIG_PGTABLE_LEVELS > 2" to pud_huge() to deal with this.

Link: https://lkml.kernel.org/r/20221107021010.2449306-1-naoya.horiguchi@linux.dev
Fixes: 3a194f3f8ad0 ("mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/mm/hugetlbpage.c~arch-x86-mm-hugetlbpagec-pud_huge-returns-0-when-using-2-level-paging
+++ a/arch/x86/mm/hugetlbpage.c
@@ -37,8 +37,12 @@ int pmd_huge(pmd_t pmd)
  */
 int pud_huge(pud_t pud)
 {
+#if CONFIG_PGTABLE_LEVELS > 2
 	return !pud_none(pud) &&
 		(pud_val(pud) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
+#else
+	return 0;
+#endif
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

