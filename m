Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9262A387F8E
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbhERS01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 14:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DE2611B0;
        Tue, 18 May 2021 18:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362307;
        bh=PiQkxAshWpAcQ7w4J/reSfS3YkopAKV2bfI5YD7zggo=;
        h=Date:From:To:Subject:From;
        b=h19/p4RNEAS9uFnky1NaKDhvZFl6dFzZbOig2UZOM6/2FX3tlCJs2XAt+WfQFR+Kj
         ODdeeDw2XKy1cmo0aTZnZg87EISfse+L7pL9MyWaG5ciGzHLS3xeomaFo2CSYU1byQ
         GW+hpnVf/flWPSRjG16Iq4DAp3wQuD+5ezWVu8hs=
Date:   Tue, 18 May 2021 11:25:07 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, joel@joelfernandes.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-fix-cow-where-page-writtable-in-child.patch removed from -mm
 tree
Message-ID: <20210518182507.XDBiqpRIh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix cow where page writable in child
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-cow-where-page-writtable-in-child.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix cow where page writtable in child

When rework early cow of pinned hugetlb pages, we moved huge_ptep_get()
upper but overlooked a side effect that the huge_ptep_get() will fetch the
pte after wr-protection.  After moving it upwards, we need explicit
wr-protect of child pte or we will keep the write bit set in the child
process, which could cause data corrution where the child can write to the
original page directly.

This issue can also be exposed by "memfd_test hugetlbfs" kselftest.

Link: https://lkml.kernel.org/r/20210503234356.9097-3-peterx@redhat.com
Fixes: 4eae4efa2c299 ("hugetlb: do early cow when page pinned on src mm")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-cow-where-page-writtable-in-child
+++ a/mm/hugetlb.c
@@ -4056,6 +4056,7 @@ again:
 				 * See Documentation/vm/mmu_notifier.rst
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				entry = huge_pte_wrprotect(entry);
 			}
 
 			page_dup_rmap(ptepage, true);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup_benchmark-support-threading.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

