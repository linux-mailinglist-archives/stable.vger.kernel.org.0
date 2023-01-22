Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A13676FA1
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjAVPXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjAVPXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40831EFA6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B286160C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2800C433D2;
        Sun, 22 Jan 2023 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401010;
        bh=1zJDZxcoLl6XwCPW4HOkZygAQSAOo50pws10uztRl60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFv51RsrBAMxmR++OPfcwk0Xkc+fFbJInpJ43PsoGCsvyGZv+rjhBU4I1HiURuXrO
         pJ5ZLspGW094Jp/n4eP+R4VlzC0iMPVFPkQrH/DX8I2U6TNFouZn1qRRETAquUCbX3
         ckZh8lmYa2bK/nqi5uQgouIYaaQPbnTs1IM4Rz0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 076/193] mm/hugetlb: fix PTE marker handling in hugetlb_change_protection()
Date:   Sun, 22 Jan 2023 16:03:25 +0100
Message-Id: <20230122150249.816900015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

commit 0e678153f5be7e6c8d28835f5a678618da4b7a9c upstream.

Patch series "mm/hugetlb: uffd-wp fixes for hugetlb_change_protection()".

Playing with virtio-mem and background snapshots (using uffd-wp) on
hugetlb in QEMU, I managed to trigger a VM_BUG_ON().  Looking into the
details, hugetlb_change_protection() seems to not handle uffd-wp correctly
in all cases.

Patch #1 fixes my test case.  I don't have reproducers for patch #2, as it
requires running into migration entries.

I did not yet check in detail yet if !hugetlb code requires similar care.


This patch (of 2):

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

Fix it by not going into the "!huge_pte_none(pte)" case if we stumble over
an exclusive marker.  spin_unlock() + continue would get the job done.

However, instead, make it clearer that there are no fall-through
statements: we process each case (hwpoison, migration, marker, !none,
none) and then unlock the page table to continue with the next PTE.  Let's
avoid "continue" statements and use a single spin_unlock() at the end.

Link: https://lkml.kernel.org/r/20221222205511.675832-1-david@redhat.com
Link: https://lkml.kernel.org/r/20221222205511.675832-2-david@redhat.com
Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6623,10 +6623,8 @@ unsigned long hugetlb_change_protection(
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
 
@@ -6647,18 +6645,13 @@ unsigned long hugetlb_change_protection(
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
 


