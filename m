Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7F24E904
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 19:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgHVRaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 13:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbgHVR37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A8E20855;
        Sat, 22 Aug 2020 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117398;
        bh=PuwJFGOp0Z6+jKaH7y+KSaatXk1WPC6+5BsiK+o2fRg=;
        h=Date:From:To:Subject:From;
        b=dxaLaeAVZ1Cw0EqZBa+ir5L5gvu48mf8bt6rQvF0k+jgclWOsAsffIcxXr4ouvfNL
         Kzql7YmWgZ5eJAFkeMB95lNiGpSuGm0H5e2Svs8FqIgAgCYl0HQPllMjWq1Qy/hb9W
         GHPQqVJdkMrQqU7uXiM3147qWjt7xr3TleaAZghc=
Date:   Sat, 22 Aug 2020 10:29:58 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, songliubraving@fb.com,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org,
        syzkaller@googlegroups.com
Subject:  [merged]
 uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch removed from -mm
 tree
Message-ID: <20200822172958.EVLlkZ26D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: uprobes: __replace_page() avoid BUG in munlock_vma_page()
has been removed from the -mm tree.  Its filename was
     uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: uprobes: __replace_page() avoid BUG in munlock_vma_page()

syzbot crashed on the VM_BUG_ON_PAGE(PageTail) in munlock_vma_page(), when
called from uprobes __replace_page().  Which of many ways to fix it? 
Settled on not calling when PageCompound (since Head and Tail are equals
in this context, PageCompound the usual check in uprobes.c, and the prior
use of FOLL_SPLIT_PMD will have cleared PageMlocked already).

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008161338360.20413@eggly.anvils
Fixes: 5a52c9df62b4 ("uprobe: use FOLL_SPLIT_PMD instead of FOLL_SPLIT")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~uprobes-__replace_page-avoid-bug-in-munlock_vma_page
+++ a/kernel/events/uprobes.c
@@ -205,7 +205,7 @@ static int __replace_page(struct vm_area
 		try_to_free_swap(old_page);
 	page_vma_mapped_walk_done(&pvmw);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if ((vma->vm_flags & VM_LOCKED) && !PageCompound(old_page))
 		munlock_vma_page(old_page);
 	put_page(old_page);
 
_

Patches currently in -mm which might be from hughd@google.com are


