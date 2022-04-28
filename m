Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C07D5138ED
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349437AbiD1Pp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349380AbiD1Ppr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4BEB6E60;
        Thu, 28 Apr 2022 08:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C855D61FAE;
        Thu, 28 Apr 2022 15:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9D5C385A0;
        Thu, 28 Apr 2022 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160551;
        bh=LWyqadbMX4amHy8ej3ONoYy1N7Vi21lmkuoAe29epNc=;
        h=From:To:Cc:Subject:Date:From;
        b=HjkJLc1wNNAyH1cLytrkHl+dQ+0CBbIjEdE4CoeM/h102Ex1eYwk8wRrXQSeKWc5Q
         Er2YfUzL6pv2U2BFeAzVhnv8mwjuwPadG/2CJH8LCBnG9MTHbTJEUbfW+O2a/eCWqf
         kvTTExklafsb3xldxza7H3jcP1ubIyb84nW/Ksgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        David Hildenbrand <david@redhat.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 01/14] mm: fix invalid page pointer returned with FOLL_PIN gups
Date:   Thu, 28 Apr 2022 17:42:09 +0200
Message-Id: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3214; i=gregkh@linuxfoundation.org; h=from:subject; bh=gsjByhgD7RsvTzmoVWRKhBN4eOYCQhhmeLufTdnA7Mc=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW29FJmY1djf5GD/S4WnOtZ+wOlPjvRULg8mm1/8mxfmd OP+nI5aFQZCJQVZMkeXLNp6j+ysOKXoZ2p6GmcPKBDKEgYtTACYyZybDPPOTB5bJZ/+L3KwpG7hKKe JjR7RFM8OC7RVxd3YczHl5+do5YQ2eL78eCQmpAgA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 7196040e19ad634293acd3eff7083149d7669031 upstream.

Patch series "mm/gup: some cleanups", v5.

This patch (of 5):

Alex reported invalid page pointer returned with pin_user_pages_remote()
from vfio after upstream commit 4b6c33b32296 ("vfio/type1: Prepare for
batched pinning with struct vfio_batch").

It turns out that it's not the fault of the vfio commit; however after
vfio switches to a full page buffer to store the page pointers it starts
to expose the problem easier.

The problem is for VM_PFNMAP vmas we should normally fail with an
-EFAULT then vfio will carry on to handle the MMIO regions.  However
when the bug triggered, follow_page_mask() returned -EEXIST for such a
page, which will jump over the current page, leaving that entry in
**pages untouched.  However the caller is not aware of it, hence the
caller will reference the page as usual even if the pointer data can be
anything.

We had that -EEXIST logic since commit 1027e4436b6a ("mm: make GUP
handle pfn mapping unless FOLL_GET is requested") which seems very
reasonable.  It could be that when we reworked GUP with FOLL_PIN we
could have overlooked that special path in commit 3faa52c03f44 ("mm/gup:
track FOLL_PIN pages"), even if that commit rightfully touched up
follow_devmap_pud() on checking FOLL_PIN when it needs to return an
-EEXIST.

Attaching the Fixes to the FOLL_PIN rework commit, as it happened later
than 1027e4436b6a.

[jhubbard@nvidia.com: added some tags, removed a reference to an out of tree module.]

Link: https://lkml.kernel.org/r/20220207062213.235127-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220204020010.68930-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220204020010.68930-2-jhubbard@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Debugged-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7bc1ba9ce440..41da0bd61bec 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -465,7 +465,7 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
-- 
2.36.0

