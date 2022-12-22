Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69A1654790
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 21:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiLVU4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 15:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLVU4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 15:56:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533421C93E
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 12:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671742523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvRumMImlcFs3FZ95qQ7RqCaL1BsczRcfz4qHMe/Ro0=;
        b=AIVo5nuf4azU5OrZnODIJERGyv7FN3qXMAeDU9lkXnN9bMsygAPxdUklJzrx0pGMPz0Tt+
        qEZ8mN/M/+CxI/ONa2//X41WRYE1oo5K82UjJPK8QA7JF1yUkz56Pu1QLtgRKrLrGndlCp
        KEsDP7nySkO4Z+3idoVg+//g7t2SFkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-wBHk7L1HNYmRypQcJnJMyQ-1; Thu, 22 Dec 2022 15:55:18 -0500
X-MC-Unique: wBHk7L1HNYmRypQcJnJMyQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA8FE101A521;
        Thu, 22 Dec 2022 20:55:17 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.193.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68BF340C2004;
        Thu, 22 Dec 2022 20:55:15 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Miaohe Lin <linmiaohe@huawei.com>, stable@vger.kernel.org
Subject: [PATCH v1 1/2] mm/hugetlb: fix PTE marker handling in hugetlb_change_protection()
Date:   Thu, 22 Dec 2022 21:55:10 +0100
Message-Id: <20221222205511.675832-2-david@redhat.com>
In-Reply-To: <20221222205511.675832-1-david@redhat.com>
References: <20221222205511.675832-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two problematic cases when stumbling over a PTE marker in
hugetlb_change_protection():

(1) We protect an uffd-wp PTE marker a second time using uffd-wp: we will
    end up in the "!huge_pte_none(pte)" case and mess up the PTE marker.

(2) We unprotect a uffd-wp PTE marker: we will similarly end up in the
    "!huge_pte_none(pte)" case even though we cleared the PTE, because
    the "pte" variable is stale. We'll mess up the PTE marker.

For example, if we later stumble over such a "wrongly modified" PTE marker,
we'll treat it like a present PTE that maps some garbage page.

This can, for example, be triggered by mapping a memfd backed by huge
pages, registering uffd-wp, uffd-wp'ing an unmapped page and (a)
uffd-wp'ing it a second time; or (b) uffd-unprotecting it; or (c)
unregistering uffd-wp. Then, ff we trigger fallocate(FALLOC_FL_PUNCH_HOLE)
on that file range, we will run into a VM_BUG_ON:

[  195.039560] page:00000000ba1f2987 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x0
[  195.039565] flags: 0x7ffffc0001000(reserved|node=0|zone=0|lastcpupid=0x1fffff)
[  195.039568] raw: 0007ffffc0001000 ffffe742c0000008 ffffe742c0000008 0000000000000000
[  195.039569] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[  195.039569] page dumped because: VM_BUG_ON_PAGE(compound && !PageHead(page))
[  195.039573] ------------[ cut here ]------------
[  195.039574] kernel BUG at mm/rmap.c:1346!
[  195.039579] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  195.039581] CPU: 7 PID: 4777 Comm: qemu-system-x86 Not tainted 6.0.12-200.fc36.x86_64 #1
[  195.039583] Hardware name: LENOVO 20WNS1F81N/20WNS1F81N, BIOS N35ET50W (1.50 ) 09/15/2022
[  195.039584] RIP: 0010:page_remove_rmap+0x45b/0x550
[  195.039588] Code: [...]
[  195.039589] RSP: 0018:ffffbc03c3633ba8 EFLAGS: 00010292
[  195.039591] RAX: 0000000000000040 RBX: ffffe742c0000000 RCX: 0000000000000000
[  195.039592] RDX: 0000000000000002 RSI: ffffffff8e7aac1a RDI: 00000000ffffffff
[  195.039592] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffbc03c3633a08
[  195.039593] R10: 0000000000000003 R11: ffffffff8f146328 R12: ffff9b04c42754b0
[  195.039594] R13: ffffffff8fcc6328 R14: ffffbc03c3633c80 R15: ffff9b0484ab9100
[  195.039595] FS:  00007fc7aaf68640(0000) GS:ffff9b0bbf7c0000(0000) knlGS:0000000000000000
[  195.039596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  195.039597] CR2: 000055d402c49110 CR3: 0000000159392003 CR4: 0000000000772ee0
[  195.039598] PKRU: 55555554
[  195.039599] Call Trace:
[  195.039600]  <TASK>
[  195.039602]  __unmap_hugepage_range+0x33b/0x7d0
[  195.039605]  unmap_hugepage_range+0x55/0x70
[  195.039608]  hugetlb_vmdelete_list+0x77/0xa0
[  195.039611]  hugetlbfs_fallocate+0x410/0x550
[  195.039612]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[  195.039616]  vfs_fallocate+0x12e/0x360
[  195.039618]  __x64_sys_fallocate+0x40/0x70
[  195.039620]  do_syscall_64+0x58/0x80
[  195.039623]  ? syscall_exit_to_user_mode+0x17/0x40
[  195.039624]  ? do_syscall_64+0x67/0x80
[  195.039626]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  195.039628] RIP: 0033:0x7fc7b590651f
[  195.039653] Code: [...]
[  195.039654] RSP: 002b:00007fc7aaf66e70 EFLAGS: 00000293 ORIG_RAX: 000000000000011d
[  195.039655] RAX: ffffffffffffffda RBX: 0000558ef4b7f370 RCX: 00007fc7b590651f
[  195.039656] RDX: 0000000018000000 RSI: 0000000000000003 RDI: 000000000000000c
[  195.039657] RBP: 0000000008000000 R08: 0000000000000000 R09: 0000000000000073
[  195.039658] R10: 0000000008000000 R11: 0000000000000293 R12: 0000000018000000
[  195.039658] R13: 00007fb8bbe00000 R14: 000000000000000c R15: 0000000000001000
[  195.039661]  </TASK>

Fix it by not going into the "!huge_pte_none(pte)" case if we stumble
over an exclusive marker. spin_unlock() + continue would get the job
done.

However, instead, make it clearer that there are no fall-through
statements: we process each case (hwpoison, migration, marker, !none, none)
and then unlock the page table to continue with the next PTE. Let's
avoid "continue" statements and use a single spin_unlock() at the end.

Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 77f36e3681e3..3a94f519304f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6512,10 +6512,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		}
 		pte = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
-			spin_unlock(ptl);
-			continue;
-		}
-		if (unlikely(is_hugetlb_entry_migration(pte))) {
+			/* Nothing to do. */
+		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			struct page *page = pfn_swap_entry_to_page(entry);
 
@@ -6536,18 +6534,13 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 				set_huge_pte_at(mm, address, ptep, newpte);
 				pages++;
 			}
-			spin_unlock(ptl);
-			continue;
-		}
-		if (unlikely(pte_marker_uffd_wp(pte))) {
-			/*
-			 * This is changing a non-present pte into a none pte,
-			 * no need for huge_ptep_modify_prot_start/commit().
-			 */
+		} else if (unlikely(is_pte_marker(pte))) {
+			/* No other markers apply for now. */
+			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
 			if (uffd_wp_resolve)
+				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
-		}
-		if (!huge_pte_none(pte)) {
+		} else if (!huge_pte_none(pte)) {
 			pte_t old_pte;
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
-- 
2.38.1

