Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E126D6AF8FB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 23:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCGWhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 17:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjCGWhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 17:37:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF666B1EF5;
        Tue,  7 Mar 2023 14:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3786E61590;
        Tue,  7 Mar 2023 22:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D0CC433D2;
        Tue,  7 Mar 2023 22:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678228514;
        bh=UjEm0pHs0MKl6rflWMubDXFYIxcTq0Ha9Qm+UuycSvc=;
        h=Date:To:From:Subject:From;
        b=v3ziKdAFF75wXAh2Z4ELcD0a6hAEk6Oe/WykXdJeND1NH69EHIYQyh+aVHIDkPGS6
         9LI/4BSsYNXCFXxsQgEk6EaCjTPt3Y4V93DOhizkKwLI4zNSENe+cZ0p/REryIoxdy
         EjN4KdaqAX+DGGjVhxdcI90zhSgl+YSBfTGDHPDk=
Date:   Tue, 07 Mar 2023 14:35:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        stable@vger.kernel.org, pengfei.xu@intel.com, heng.su@intel.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-race-with-ksm_exit-in-vma-iteration.patch added to mm-hotfixes-unstable branch
Message-Id: <20230307223514.90D0CC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/ksm: fix race with ksm_exit() in VMA iteration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-race-with-ksm_exit-in-vma-iteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-race-with-ksm_exit-in-vma-iteration.patch

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
Subject: mm/ksm: fix race with ksm_exit() in VMA iteration
Date: Tue, 7 Mar 2023 15:59:51 -0500

ksm_exit() may remove the mm from the ksm_scan between the unlocking of
the ksm_mmlist and the start of the VMA iteration.  This results in the
mmap_read_lock() not being taken and a report from lockdep that the mm
isn't locked in the maple tree code.

Fix the race by checking if this mm has been removed before iterating the
VMAs.  __ksm_exit() uses the mmap lock to synchronize the freeing of an
mm, so it is safe to keep iterating over the VMAs when it is going to be
freed.

This change will slow down the mm exit during the race condition, but will
speed up the non-race scenarios iteration over the VMA list, which should
be much more common.

Link: https://lkml.kernel.org/r/20230307205951.2465275-1-Liam.Howlett@oracle.com
Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
  Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
Reported-by: <syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com>
  Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <heng.su@intel.com>
Cc: Pengfei Xu <pengfei.xu@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-race-with-ksm_exit-in-vma-iteration
+++ a/mm/ksm.c
@@ -988,9 +988,10 @@ static int unmerge_and_remove_all_rmap_i
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -999,6 +1000,7 @@ static int unmerge_and_remove_all_rmap_i
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-mas_skip_node-end-slot-detection.patch
test_maple_tree-add-more-testing-for-mas_empty_area.patch
mm-ksm-fix-race-with-ksm_exit-in-vma-iteration.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

