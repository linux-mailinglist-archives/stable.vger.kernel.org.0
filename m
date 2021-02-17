Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C729931DF68
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBQTHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhBQTHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 14:07:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09CE264DE0;
        Wed, 17 Feb 2021 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613588801;
        bh=wmMbEgQUr3JrFli1SCzjAY5ndgEnQKnrID4cKCb1ZCg=;
        h=Date:From:To:Subject:From;
        b=Xq4Qr1oUzpvwjKziqaKk1b9EZQbv87pf+Z5oXBpSimwom29LnbgrrJ7D0PxYs788E
         BUgJV2foMkYxirldnr9A7dEC4BA8NQnW3qrHTToJ8Q2suyTbbup1WfnApJnhx7QZCv
         wwGUhQFiqHtIiUN3Q/jvRwHxRfyHl5blE0bnN7GE=
Date:   Wed, 17 Feb 2021 11:06:40 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        stable@vger.kernel.org, osalvador@suse.de,
        kirill.shutemov@linux.intel.com, joao.m.martins@oracle.com,
        dbueso@suse.de, aarcange@redhat.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch added to
 -mm tree
Message-ID: <20210217190640.BiIUU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: fix update_and_free_page contig page struct assumpti=
on
has been added to the -mm tree.  Its filename is
     hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-update_and_free_p=
age-contig-page-struct-assumption.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-update_and_free_p=
age-contig-page-struct-assumption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix update_and_free_page contig page struct assumption

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine update_and_free_page can encounter a gigantic page, yet it assumes
page structs are contiguous when setting page flags in subpages.

If update_and_free_page encounters non-contiguous page structs, we can see
=E2=80=9CBUG: Bad page state in process =E2=80=A6=E2=80=9D errors.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where
the gigantic page will be allocated.  Zi Yan outlined steps to reproduce
here [1].

[1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@n=
vidia.com/

Link: https://lkml.kernel.org/r/20210217184926.33567-1-mike.kravetz@oracle.=
com
Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at =
runtime")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-update_and_free_page-contig-page-struct-assu=
mption
+++ a/mm/hugetlb.c
@@ -1321,14 +1321,16 @@ static inline void destroy_compound_giga
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct page *subpage =3D page;
=20
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
=20
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
-	for (i =3D 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &=3D ~(1 << PG_locked | 1 << PG_error |
+	for (i =3D 0; i < pages_per_huge_page(h);
+	     i++, subpage =3D mem_map_next(subpage, page, i)) {
+		subpage->flags &=3D ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

