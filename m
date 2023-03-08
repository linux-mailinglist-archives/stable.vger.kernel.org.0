Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B435B6B160E
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 00:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCHXBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 18:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjCHXBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 18:01:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEBBD49E2;
        Wed,  8 Mar 2023 15:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A28FB81E1E;
        Wed,  8 Mar 2023 23:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482BDC433D2;
        Wed,  8 Mar 2023 23:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678316433;
        bh=UNBiEptSI6HARhfxoCic4dbFRHGuMqDaeZaCeEINN/I=;
        h=Date:To:From:Subject:From;
        b=N8rdGiWuhyU0avoul5cTsrFonp/KAjka3KZyiYys/qZyIebkGPjIs1Ybdn/aBkqik
         3hYTaGzoRqelyILxUcanubFL4evWD95BNfgkzpSg/fu+S7BPsAsm0N8TSaQmU75UB1
         7XMa9kIjkoFFS9ZteuEFVkewb5/jVvX0334uVLgA=
Date:   Wed, 08 Mar 2023 15:00:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, pengfei.xu@intel.com, heng.su@intel.com,
        david@redhat.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch added to mm-hotfixes-unstable branch
Message-Id: <20230308230033.482BDC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/ksm: fix race with VMA iteration and mm_struct teardown
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/ksm: fix race with VMA iteration and mm_struct teardown
Date: Wed, 8 Mar 2023 17:03:10 -0500

exit_mmap() will tear down the VMAs and maple tree with the mmap_lock held
in write mode.  Ensure that the maple tree is still valid by checking
ksm_test_exit() after taking the mmap_lock in read mode, but before the
for_each_vma() iterator dereferences a destroyed maple tree.

Since the maple tree is destroyed, the flags telling lockdep to check an
external lock has been cleared.  Skip the for_each_vma() iterator to avoid
dereferencing a maple tree without the external lock flag, which would
create a lockdep warning.

Link: https://lkml.kernel.org/r/20230308220310.3119196-1-Liam.Howlett@oracle.com
Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
  Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
Reported-by: syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <heng.su@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown
+++ a/mm/ksm.c
@@ -988,9 +988,15 @@ static int unmerge_and_remove_all_rmap_i
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+
+		/*
+		 * Exit right away if mm is exiting to avoid lockdep issue in
+		 * the maple tree
+		 */
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -999,6 +1005,7 @@ static int unmerge_and_remove_all_rmap_i
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-mas_skip_node-end-slot-detection.patch
test_maple_tree-add-more-testing-for-mas_empty_area.patch
mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

