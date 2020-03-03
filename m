Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E029177FAB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgCCRwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCCRwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:52:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9DB206D5;
        Tue,  3 Mar 2020 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257930;
        bh=wwYAtY6bjKNZ28ZOO+yoynbjZWU+rFBQW1m8byw9ZuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YHuZyhsrVbzcxVVkMjWVSWJTp0lklt5woKqTmYWKHZ5i4JhebZmOsTC3kZUwyaM5
         R0NWX5b8K/9GCpIqjy2qhVUDSblX3q6u7WCSOAQBT2/891dyafw5oaIDLMGvoDfVnF
         pqY9e8i4zayc0wXcj3jklqBiMDNT9Z7XBTsZgwvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jerome Glisse <jglisse@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 172/176] mm/gup: allow FOLL_FORCE for get_user_pages_fast()
Date:   Tue,  3 Mar 2020 18:43:56 +0100
Message-Id: <20200303174323.801359431@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit f4000fdf435b8301a11cf85237c561047f8c4c72 upstream.

Commit 817be129e6f2 ("mm: validate get_user_pages_fast flags") allowed
only FOLL_WRITE and FOLL_LONGTERM to be passed to get_user_pages_fast().
This, combined with the fact that get_user_pages_fast() falls back to
"slow gup", which *does* accept FOLL_FORCE, leads to an odd situation:
if you need FOLL_FORCE, you cannot call get_user_pages_fast().

There does not appear to be any reason for filtering out FOLL_FORCE.
There is nothing in the _fast() implementation that requires that we
avoid writing to the pages.  So it appears to have been an oversight.

Fix by allowing FOLL_FORCE to be set for get_user_pages_fast().

Link: http://lkml.kernel.org/r/20200107224558.2362728-9-jhubbard@nvidia.com
Fixes: 817be129e6f2 ("mm: validate get_user_pages_fast flags")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Björn Töpel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2415,7 +2415,8 @@ int get_user_pages_fast(unsigned long st
 	unsigned long addr, len, end;
 	int nr = 0, ret = 0;
 
-	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
+	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
+				       FOLL_FORCE)))
 		return -EINVAL;
 
 	start = untagged_addr(start) & PAGE_MASK;


