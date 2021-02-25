Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5963256BD
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhBYTcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234879AbhBYTaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D392664F34;
        Thu, 25 Feb 2021 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280645;
        bh=moz1E1ye/uyWdvK7moV1jIZ9dVb5lZ9+JoUbnL+PstM=;
        h=Date:From:To:Subject:From;
        b=Tjz2nk/mCC8ArS0vbd0j/NnWNvCHOpImWODt8h9wQY443AdV9hKG3+PAWsGfM3LEo
         kofNu40gUETDzb6d0tgcpp9mTSxpK6cEn3TMLHdkdkekkjUWCVBhz4Qg6TVh3GZdsR
         zzqESnXBRVRHb/4MPTRaeynXm2YZgT8wF1aFoyZg=
Date:   Thu, 25 Feb 2021 11:17:24 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, dbueso@suse.de, joao.m.martins@oracle.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
 removed from -mm tree
Message-ID: <20210225191724.8ziH2aj_k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: fix update_and_free_page contig page struct assumpti=
on
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Mike Kravetz <mike.kravetz@oracle.com>
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


