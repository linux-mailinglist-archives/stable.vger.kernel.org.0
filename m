Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86069B629
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 00:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBQXHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 18:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQXHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 18:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD82119A;
        Fri, 17 Feb 2023 15:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E5EAB82EA6;
        Fri, 17 Feb 2023 23:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDB2C433D2;
        Fri, 17 Feb 2023 23:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676675266;
        bh=fExcyML4LkR07+JWBsVgHvUX9J5y7OPoncWOiwO5AAo=;
        h=Date:To:From:Subject:From;
        b=gJ0pmv6sP5iY4gt3Ceho7c2EtAmAaleTMVei922mbgEP6m1oh2OabR7jqPyaIrt+k
         YIFUNLy5vlpI4Ad8da1Wwi24QBhvZlZ7H0I9vlcMpTjTTAT+wlsZlfKiPBSV8sz8gf
         zsFhhRgY8Z8HuqqPJSckghgm9ybth0I1CINatbYU=
Date:   Fri, 17 Feb 2023 15:07:45 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, nbowler@draconx.ca, david@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch removed from -mm tree
Message-Id: <20230217230746.1EDB2C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: fix wrongly apply write bit after mkdirty on sparc64
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-uffd-fix-comment-in-handling-pte-markers.patch

