Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6FF628E9B
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 01:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiKOAq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 19:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiKOAq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 19:46:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75D11D648;
        Mon, 14 Nov 2022 16:46:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DDBDCE1333;
        Tue, 15 Nov 2022 00:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBEBC433C1;
        Tue, 15 Nov 2022 00:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668473182;
        bh=VpQrjkUAdI5NRkFYCpqIluaDEwvqvAKtxcMfqAXdVyI=;
        h=Date:To:From:Subject:From;
        b=UGWSTrrT3eRts63pOoosmsXoS3LNMyDgm7D285xy9Ai/FahP+yIVYF5JFfwQuWg8/
         LRXVIDlYEf9SjyGTuvtajsMyXUXInGwezt6+w7Lu16Bd2+cRbQeyB6XzuB49su1djK
         M5yiRBh8Hagsv9nQtlGCDJdGd0O0YHTmRD4DggRY=
Date:   Mon, 14 Nov 2022 16:46:21 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com, ives@codesandbox.io,
        axelrasmussen@google.com, apopple@nvidia.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115004622.2CBEBC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix read-only page got writable when recover pte
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch

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

Link: https://lkml.kernel.org/r/20221114000447.1681003-2-peterx@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Ives van Hoorne <ives@codesandbox.io>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-read-only-page-got-writable-when-recover-pte
+++ a/mm/migrate.c
@@ -213,8 +213,14 @@ static bool remove_migration_pte(struct
 			pte = pte_mkdirty(pte);
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
-		else if (pte_swp_uffd_wp(*pvmw.pte))
+		else
+			/* NOTE: mk_pte can have write bit set */
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

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

