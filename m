Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B293C9434
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 01:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhGNXMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 19:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 19:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C7061360;
        Wed, 14 Jul 2021 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626304146;
        bh=6WehOXPfHGhmExw7DxXEZuuREMY9ztJvo0vuzRfxqDE=;
        h=Date:From:To:Subject:From;
        b=OI861fkxgrY4iqCsly+lsmXzdVWXMVhG3bGzkwLiBrU4uNXQdD9pkC1Ta1/yW6XbC
         IStV8S/W3k3DCqk+QFNFNph67dEJxivMY//qlpu/EoI687TzFRlHN8C352sE/iqtyB
         2IYmWwrF1IcrQD82CfJ8qv2PGdShRAgMrnQBv3U8=
Date:   Wed, 14 Jul 2021 16:09:06 -0700
From:   akpm@linux-foundation.org
To:     joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr.patch added to -mm
 tree
Message-ID: <20210714230906.zpqurUo_F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix refs calculation from unaligned @vaddr
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: fix refs calculation from unaligned @vaddr

commit 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording") refactored
the count of subpages but missed an edge case when @vaddr is not aligned
to PAGE_SIZE e.g.  when close to vma->vm_end.  It would then errousnly set
@refs to 0 and record_subpages_vmas() wouldn't set the @pages array
element to its value, consequently causing the reported null-deref by
syzbot.

Fix it by aligning down @vaddr by PAGE_SIZE in @refs calculation.

Link: https://lkml.kernel.org/r/20210713152440.28650-1-joao.m.martins@oracle.com
Fixes: 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
Reported-by: syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr
+++ a/mm/hugetlb.c
@@ -5440,8 +5440,9 @@ long follow_hugetlb_page(struct mm_struc
 			continue;
 		}
 
-		refs = min3(pages_per_huge_page(h) - pfn_offset,
-			    (vma->vm_end - vaddr) >> PAGE_SHIFT, remainder);
+		/* vaddr may not be aligned to PAGE_SIZE */
+		refs = min3(pages_per_huge_page(h) - pfn_offset, remainder,
+		    (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);
 
 		if (pages || vmas)
 			record_subpages_vmas(mem_map_offset(page, pfn_offset),
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr.patch

