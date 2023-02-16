Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE9699F83
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 22:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBPV5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 16:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPV5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 16:57:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA80F4DE0E;
        Thu, 16 Feb 2023 13:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4891C60C71;
        Thu, 16 Feb 2023 21:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99512C433A0;
        Thu, 16 Feb 2023 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676584616;
        bh=qDmxSxoBKk1Qa30a7Y9foBsbHqpaX8s9ZMRxS3UQFSU=;
        h=Date:To:From:Subject:From;
        b=TlYC/CcLu22jSKXvcN5Me9ZjJkLML/qiRbmEWgJViP+KT2sst7hFuBxYOaTazidWA
         LU1nan5TJbFCgCcQwekuzFMBJJmXN+1QWT7+wPB87mueiSsWU07IPU8+yQ0w8rVKBV
         VBguiAOBO1p/VgmF39zWikSTfnYVq/ROgZvwFto4=
Date:   Thu, 16 Feb 2023 13:56:55 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, nbowler@draconx.ca, david@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch added to mm-hotfixes-unstable branch
Message-Id: <20230216215656.99512C433A0@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix wrongly apply write bit after mkdirty on sparc64
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/migrate: fix wrongly apply write bit after mkdirty on sparc64
Date: Thu, 16 Feb 2023 10:30:59 -0500

Nick Bowler reported another sparc64 breakage after the young/dirty
persistent work for page migration (per "Link:" below).  That's after a
similar report [2].

It turns out page migration was overlooked, and it wasn't failing before
because page migration was not enabled in the initial report test
environment.

David proposed another way [2] to fix this from sparc64 side, but that
patch didn't land somehow.  Neither did I check whether there's any other
arch that has similar issues.

Let's fix it for now as simple as moving the write bit handling to be
after dirty, like what we did before.

Note: this is based on mm-unstable, because the breakage was since 6.1 and
we're at a very late stage of 6.2 (-rc8), so I assume for this specific
case we should target this at 6.3.

[1] https://lore.kernel.org/all/20221021160603.GA23307@u164.east.ru/
[2] https://lore.kernel.org/all/20221212130213.136267-1-david@redhat.com/

Link: https://lkml.kernel.org/r/20230216153059.256739-1-peterx@redhat.com
Fixes: 2e3468778dbe ("mm: remember young/dirty bit for page migrations")
Link: https://lore.kernel.org/all/CADyTPExpEqaJiMGoV+Z6xVgL50ZoMJg49B10LcZ=8eg19u34BA@mail.gmail.com/
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Nick Bowler <nbowler@draconx.ca>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Nick Bowler <nbowler@draconx.ca>
Cc: <regressions@lists.linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64
+++ a/mm/huge_memory.c
@@ -3272,8 +3272,6 @@ void remove_migration_pmd(struct page_vm
 	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = maybe_pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 	if (!is_migration_entry_young(entry))
@@ -3281,6 +3279,10 @@ void remove_migration_pmd(struct page_vm
 	/* NOTE: this may contain setting soft-dirty on some archs */
 	if (PageDirty(new) && is_migration_entry_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
+	if (is_writable_migration_entry(entry))
+		pmde = maybe_pmd_mkwrite(pmde, vma);
+	else
+		pmde = pmd_wrprotect(pmde);
 
 	if (PageAnon(new)) {
 		rmap_t rmap_flags = RMAP_COMPOUND;
--- a/mm/migrate.c~mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64
+++ a/mm/migrate.c
@@ -224,6 +224,8 @@ static bool remove_migration_pte(struct
 			pte = maybe_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
+		else
+			pte = pte_wrprotect(pte);
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-uffd-fix-comment-in-handling-pte-markers.patch

