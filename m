Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FB62D36FE
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 00:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgLHXjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 18:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbgLHXjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 18:39:15 -0500
Date:   Tue, 08 Dec 2020 15:38:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607470708;
        bh=wTtOPQY6s8v55z0XQGMjoVRNudIHavg2ch7Fx81AHmY=;
        h=From:To:Subject:From;
        b=q5ED1PZtfDmGiwqqLAyvXYV4CPOGuU2wmpfolRWpMuQrGSU2V0kLc81BtlDee20Y2
         dg5ic2uKscgNOttBl1KtZKLL+vpxhrfLvbfso1Lj2LaIlBjotxkNMp0wOm9i2WFFSY
         1roddvbAbIxR8oW+whF5OUZYtC0ABTsqmuW4B+K8=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, mike.kravetz@oracle.com,
        borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com
Subject:  +
 mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages.patch added to -mm
 tree
Message-ID: <20201208233827.2yXQC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: clear compound_nr before freeing gigantic pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm/hugetlb: clear compound_nr before freeing gigantic pages

Commit 1378a5ee451a ("mm: store compound_nr as well as compound_order")
added compound_nr counter to first tail struct page, overlaying with
page->mapping.  The overlay itself is fine, but while freeing gigantic
hugepages via free_contig_range(), a "bad page" check will trigger for
non-NULL page->mapping on the first tail page:

[  276.681603] BUG: Bad page state in process bash  pfn:380001
[  276.681614] page:00000000c35f0856 refcount:0 mapcount:0 mapping:00000000126b68aa index:0x0 pfn:0x380001
[  276.681620] aops:0x0
[  276.681622] flags: 0x3ffff00000000000()
[  276.681626] raw: 3ffff00000000000 0000000000000100 0000000000000122 0000000100000000
[  276.681628] raw: 0000000000000000 0000000000000000 ffffffff00000000 0000000000000000
[  276.681630] page dumped because: non-NULL mapping
[  276.681632] Modules linked in:
[  276.681637] CPU: 6 PID: 616 Comm: bash Not tainted 5.10.0-rc7-next-20201208 #1
[  276.681639] Hardware name: IBM 3906 M03 703 (LPAR)
[  276.681641] Call Trace:
[  276.681648]  [<0000000458c252b6>] show_stack+0x6e/0xe8
[  276.681652]  [<000000045971cf60>] dump_stack+0x90/0xc8
[  276.681656]  [<0000000458e8b186>] bad_page+0xd6/0x130
[  276.681658]  [<0000000458e8cdea>] free_pcppages_bulk+0x26a/0x800
[  276.681661]  [<0000000458e8e67e>] free_unref_page+0x6e/0x90
[  276.681663]  [<0000000458e8ea6c>] free_contig_range+0x94/0xe8
[  276.681666]  [<0000000458ea5e54>] update_and_free_page+0x1c4/0x2c8
[  276.681669]  [<0000000458ea784e>] free_pool_huge_page+0x11e/0x138
[  276.681671]  [<0000000458ea8530>] set_max_huge_pages+0x228/0x300
[  276.681673]  [<0000000458ea86c0>] nr_hugepages_store_common+0xb8/0x130
[  276.681678]  [<0000000458fd5b6a>] kernfs_fop_write+0xd2/0x218
[  276.681681]  [<0000000458ef9da0>] vfs_write+0xb0/0x2b8
[  276.681684]  [<0000000458efa15c>] ksys_write+0xac/0xe0
[  276.681687]  [<000000045972c5ca>] system_call+0xe6/0x288
[  276.681730] Disabling lock debugging due to kernel taint

This is because only the compound_order is cleared in
destroy_compound_gigantic_page(), and compound_nr is set to 1U << order ==
1 for order 0 in set_compound_order(page, 0).

Fix this by explicitly clearing compound_nr for first tail page after
calling set_compound_order(page, 0).

Link: https://lkml.kernel.org/r/20201208182813.66391-2-gerald.schaefer@linux.ibm.com
Fixes: 1378a5ee451a ("mm: store compound_nr as well as compound_order")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc; Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages
+++ a/mm/hugetlb.c
@@ -1216,6 +1216,7 @@ static void destroy_compound_gigantic_pa
 	}
 
 	set_compound_order(page, 0);
+	page[1].compound_nr = 0;
 	__ClearPageHead(page);
 }
 
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-hugetlb-clear-compound_nr-before-freeing-gigantic-pages.patch

