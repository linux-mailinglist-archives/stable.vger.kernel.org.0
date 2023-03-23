Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5B26C5C2A
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCWBei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCWBeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:34:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7A4FF3C;
        Wed, 22 Mar 2023 18:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E32E6236F;
        Thu, 23 Mar 2023 01:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF9C433EF;
        Thu, 23 Mar 2023 01:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535136;
        bh=Qt278rxyGI6bes0Hay6WXrp68PJzx1IS7v0L4PKIUb8=;
        h=Date:To:From:Subject:From;
        b=lJaxScoxnKJNp3X3qbq3wnbW6wchIuGFHphLvxKlGAiXRkzfbjqrupyCaS6lIZ48X
         LgWTX6Be3BjJSIG7pPWa17zvLP7nRYNL7EIOtMl+yZ26IHT1j7hD0ck6agahcPxWYQ
         hvTfcFzvOAN5nc6QbI5tGOF+KPZHgwK1jTzIG85o=
Date:   Wed, 22 Mar 2023 18:32:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, pengfei.xu@intel.com, heng.su@intel.com,
        david@redhat.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch removed from -mm tree
Message-Id: <20230323013216.7EFF9C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: fix race with VMA iteration and mm_struct teardown
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-race-with-vma-iteration-and-mm_struct-teardown.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

