Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124F4603D44
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiJSJAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiJSI7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1455691856;
        Wed, 19 Oct 2022 01:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BBC6617EE;
        Wed, 19 Oct 2022 08:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE734C433C1;
        Wed, 19 Oct 2022 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168879;
        bh=k3pbYwELAWZwoUJWPTFl+CxzU1z5/tRjW0u2LqamOj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOlkN0f52wrc+OjKTa0tLckO2ivJa2CeI1r1tJv6BGdq9dBmpfML2w37GF5Ya92mA
         miuwm1KyyA71OIaksRrR6m3GNOnQlHYMQ1fotVoC+HG+TGuSViIX84ZXacn7YJRGCr
         2dI3DjB098W3z9NrtY3y2hJQnB7rYlwltKNq1yng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com,
        Axel Rasmussen <axelrasmussen@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Edward Liaw <edliaw@google.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 085/862] mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in
Date:   Wed, 19 Oct 2022 10:22:52 +0200
Message-Id: <20221019083253.679416520@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 515778e2d790652a38a24554fdb7f21420d91efc upstream.

When PTE_MARKER_UFFD_WP not configured, it's still possible to reach pte
marker code and trigger an warning. Add a few CONFIG_PTE_MARKER_UFFD_WP
ifdefs to make sure the code won't be reached when not compiled in.

Link: https://lkml.kernel.org/r/YzeR+R6b4bwBlBHh@x1n
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: <syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Edward Liaw <edliaw@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c  |    4 ++++
 mm/memory.c   |    2 ++
 mm/mprotect.c |    2 ++
 3 files changed, 8 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5059,6 +5059,7 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5070,6 +5071,7 @@ static void __unmap_hugepage_range(struc
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
+#endif
 				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
@@ -5098,11 +5100,13 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
+#endif
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1393,10 +1393,12 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte,
 			      struct zap_details *details, pte_t pteval)
 {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	if (zap_drop_file_uffd_wp(details))
 		return;
 
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
+#endif
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -260,6 +260,7 @@ static unsigned long change_pte_range(st
 		} else {
 			/* It must be an none page, or what else?.. */
 			WARN_ON_ONCE(!pte_none(oldpte));
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
 				/*
 				 * For file-backed mem, we need to be able to
@@ -271,6 +272,7 @@ static unsigned long change_pte_range(st
 					   make_pte_marker(PTE_MARKER_UFFD_WP));
 				pages++;
 			}
+#endif
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();


