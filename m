Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673154A6659
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 21:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiBAUuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 15:50:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiBAUuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 15:50:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015FE61723;
        Tue,  1 Feb 2022 20:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C34DC340EB;
        Tue,  1 Feb 2022 20:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643748602;
        bh=QnZATx0lkZS4eAV3fifDYwvtSlnhsWLURXHzYtsWpuc=;
        h=Date:To:From:Subject:From;
        b=KfcXgPqzHO9g+s0BpDSMKICyrYDmJ1JwIIPzJ0K/do9ZZsFESryR/cyl9d8HvvD0O
         G8aow4dfzc+gexkVNP6w0BpPQCSEwpV/FDyibOyHZFsMs8kL6Hc03b1ce1E9FfV0yV
         1ONwvCC4cBU/tDOMVzr6ohv9008DZzpXhpp0X8GU=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:50:00 -0800
Date:   Tue, 01 Feb 2022 12:50:00 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jglisse@redhat.com, jack@suse.cz, alex.williamson@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch removed from -mm tree
Message-Id: <20220201205001.1C34DC340EB@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix invalid page pointer returned with FOLL_PIN gups
has been removed from the -mm tree.  Its filename was
     mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup.c: fix invalid page pointer returned with FOLL_PIN gups

Alex reported invalid page pointer returned with pin_user_pages_remote()
from vfio after upstream commit 4b6c33b32296 ("vfio/type1: Prepare for
batched pinning with struct vfio_batch").  This problem breaks NVIDIA vfio
mdev.

It turns out that it's not the fault of the vfio commit; however after
vfio switches to a full page buffer to store the page pointers it starts
to expose the problem easier.

The problem is for VM_PFNMAP vmas we should normally fail with an -EFAULT
then vfio will carry on to handle the MMIO regions.  However when the bug
triggered, follow_page_mask() returned -EEXIST for such a page, which will
jump over the current page, leaving that entry in **pages untouched. 
However the caller is not aware of it, hence the caller will reference the
page as usual even if the pointer data can be anything.

We had that -EEXIST logic since commit 1027e4436b6a ("mm: make GUP handle
pfn mapping unless FOLL_GET is requested") which seems very reasonable. 
It could be that when we reworked GUP with FOLL_PIN we could have
overlooked that special path in commit 3faa52c03f44 ("mm/gup: track
FOLL_PIN pages"), even if that commit rightfully touched up
follow_devmap_pud() on checking FOLL_PIN when it needs to return an
-EEXIST.

Since at it, add another WARN_ON_ONCE() at the -EEXIST handling to make
sure we mustn't have **pages set when reaching there, because otherwise it
means the caller will try to read a garbage right after __get_user_pages()
returns.

Attaching the Fixes to the FOLL_PIN rework commit, as it happened later
than 1027e4436b6a.

Link: https://lkml.kernel.org/r/20220125033700.69705-1-peterx@redhat.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Debugged-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-fix-invalid-page-pointer-returned-with-foll_pin-gups
+++ a/mm/gup.c
@@ -440,7 +440,7 @@ static int follow_pfn_pte(struct vm_area
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
@@ -1181,7 +1181,13 @@ retry:
 			/*
 			 * Proper page table entry exists, but no corresponding
 			 * struct page.
+			 *
+			 * Warn if we jumped over even with a valid **pages.
+			 * It shouldn't trigger in practise, but when there's
+			 * buggy returns on -EEXIST we'll warn before returning
+			 * an invalid page pointer in the array.
 			 */
+			WARN_ON_ONCE(pages);
 			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
_

Patches currently in -mm which might be from peterx@redhat.com are


