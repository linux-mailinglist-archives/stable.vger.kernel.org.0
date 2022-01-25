Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71D49AC6D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349498AbiAYGbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346490AbiAYG2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 01:28:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA3C038AC1;
        Mon, 24 Jan 2022 20:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B3EECE16B3;
        Tue, 25 Jan 2022 04:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD44C340E0;
        Tue, 25 Jan 2022 04:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643086204;
        bh=MstIM0rfaGotgpIRhr3v2d3CRHPSm8jc0mTlrOLcJxo=;
        h=Date:From:To:Subject:From;
        b=Lrsh0Q8tGqa0pv7IbmSLB4fvrXfcSh2y3ASf2l1GTuzXuIGsewaT+D4C+eIQBXDIz
         CiPwR3Ts9+fIKRDmtZGkmJYzb3GezUt9V57jvUdeoEI6VwQK9Oj3RYMS+6+sMxaicr
         bf6oMYR7+/JmS21zZseT36XuDP3+sqk8y8aJmg/8=
Date:   Mon, 24 Jan 2022 20:50:03 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        alex.williamson@redhat.com, jack@suse.cz, jglisse@redhat.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org
Subject:  +
 mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch added to -mm
 tree
Message-ID: <20220125045003.H9m6c36XQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix invalid page pointer returned with FOLL_PIN gups
has been added to the -mm tree.  Its filename is
     mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-invalid-page-pointer-r=
eturned-with-foll_pin-gups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-invalid-page-pointer-r=
eturned-with-foll_pin-gups.patch

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
=46rom: Peter Xu <peterx@redhat.com>
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
jump over the current page, leaving that entry in **pages untouched.=20
However the caller is not aware of it, hence the caller will reference the
page as usual even if the pointer data can be anything.

We had that -EEXIST logic since commit 1027e4436b6a ("mm: make GUP handle
pfn mapping unless FOLL_GET is requested") which seems very reasonable.=20
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
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Debugged-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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
=20
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
 			ret =3D PTR_ERR(page);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

