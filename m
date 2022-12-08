Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54464796E
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 00:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLHXCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 18:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLHXCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 18:02:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DA17DA68;
        Thu,  8 Dec 2022 15:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C02AB82665;
        Thu,  8 Dec 2022 23:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E6C433D2;
        Thu,  8 Dec 2022 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670540520;
        bh=GsG/A7gc5EQ38JgYrW8NSLmew1yQwE9wTGXBHbsZUu4=;
        h=Date:To:From:Subject:From;
        b=bqaq1Y90kOsi+IDgWjiIHv9dP65E9FH1aCwi3T4PPlKdyA6RPKTBiFUvPX3Lg36qt
         5JtoYmEI0ldgSLbtL7IRGlAXBEzZLLXKTK2YC3Os6Qw7tO7pGvGs7p0dXzYN/FIxhp
         1/YEAzsAFKdbAvtNgDHcObcQ9qb2Rwr9uPVFE1S0=
Date:   Thu, 08 Dec 2022 15:01:57 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com, ives@codesandbox.io,
        david@redhat.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch removed from -mm tree
Message-Id: <20221208230159.E85E6C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: fix read-only page got writable when recover pte
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/migrate: fix read-only page got writable when recover pte
Date: Sun, 13 Nov 2022 19:04:46 -0500

Ives van Hoorne from codesandbox.io reported an issue regarding possible
data loss of uffd-wp when applied to memfds on heavily loaded systems. 
The symptom is some read page got data mismatch from the snapshot child
VMs.

Here I can also reproduce with a Rust reproducer that was provided by Ives
that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
80 instances I can trigger the issues in ten minutes.

It turns out that we got some pages write-through even if uffd-wp is
applied to the pte.

The problem is, when removing migration entries, we didn't really worry
about write bit as long as we know it's not a write migration entry.  That
may not be true, for some memory types (e.g.  writable shmem) mk_pte can
return a pte with write bit set, then to recover the migration entry to
its original state we need to explicit wr-protect the pte or it'll has the
write bit set if it's a read migration entry.  For uffd it can cause
write-through.

The relevant code on uffd was introduced in the anon support, which is
commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
2020-04-07).  However anon shouldn't suffer from this problem because anon
should already have the write bit cleared always, so that may not be a
proper Fixes target, while I'm adding the Fixes to be uffd shmem support.

[peterx@redhat.com: enhance comment]
  Link: https://lkml.kernel.org/r/Y4jIHureiOd8XjDX@x1n
Link: https://lkml.kernel.org/r/20221114000447.1681003-2-peterx@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Ives van Hoorne <ives@codesandbox.io>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-fix-read-only-page-got-writable-when-recover-pte
+++ a/mm/migrate.c
@@ -213,8 +213,21 @@ static bool remove_migration_pte(struct
 			pte = pte_mkdirty(pte);
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
-		else if (pte_swp_uffd_wp(*pvmw.pte))
+		else
+			/*
+			 * NOTE: mk_pte() can have write bit set per memory
+			 * type (e.g. shmem), or pte_mkdirty() per archs
+			 * (e.g., sparc64).  If this is a read migration
+			 * entry, we need to make sure when we recover the
+			 * pte from migration entry to present entry the
+			 * write bit is cleared.
+			 */
+			pte = pte_wrprotect(pte);
+
+		if (pte_swp_uffd_wp(*pvmw.pte)) {
+			WARN_ON_ONCE(pte_write(pte));
 			pte = pte_mkuffd_wp(pte);
+		}
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
_

Patches currently in -mm which might be from peterx@redhat.com are


