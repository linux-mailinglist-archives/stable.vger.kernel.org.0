Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C3124934E
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 05:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHSDNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 23:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgHSDNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 23:13:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1016F2065F;
        Wed, 19 Aug 2020 03:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597806811;
        bh=Q3zDJbnLjzFqrYrv7pRu4yqsIhmiNwq1L1sTe+nUOGg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kzBkWodpmZrVgIaeKLYXVR4qSD5MmGHFU9tra7tUXb0kZ9IMUSJx4oOeyvsGrZAs1
         qYs+aFj64tU3uky4lMpbQ0BqZcIIIOQPOa3kqtSkJ3D9MsMNxMLHruHP/Q91im6ywt
         BJ90v1iZlsyjT54rsFFwyC136wDCuksdb5T9XOUk=
Date:   Tue, 18 Aug 2020 20:13:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adrien+dev@schischi.me, drosen@google.com, groeck@chromium.org,
        hch@lst.de, mm-commits@vger.kernel.org,
        nicolas.prochazka@gmail.com, phillip@squashfs.org.uk,
        pliard@google.com, shimada@walbrix.com, stable@vger.kernel.org
Subject:  +
 squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch added to -mm tree
Message-ID: <20200819031330.JnC84oXzt%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: avoid bio_alloc() failure with 1Mbyte blocks
has been added to the -mm tree.  Its filename is
     squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: avoid bio_alloc() failure with 1Mbyte blocks

This is a regression introduced by the patch "migrate from ll_rw_block
usage to BIO".

Bio_alloc() is limited to 256 pages (1 Mbyte).  This can cause a failure
when reading 1 Mbyte block filesystems.  The problem is a datablock can be
fully (or almost uncompressed), requiring 256 pages, but, because blocks
are not aligned to page boundaries, it may require 257 pages to read.

Bio_kmalloc() can handle 1024 pages, and so use this for the edge
condition.

Link: http://lkml.kernel.org/r/20200815035637.15319-1-phillip@squashfs.org.uk
Fixes: 93e72b3c612a ("squashfs: migrate from ll_rw_block usage to BIO")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Nicolas Prochazka <nicolas.prochazka@gmail.com>
Reported-by: Tomoatsu Shimada <shimada@walbrix.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: Philippe Liard <pliard@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks
+++ a/fs/squashfs/block.c
@@ -87,7 +87,11 @@ static int squashfs_bio_read(struct supe
 	int error, i;
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_NOIO, page_count);
+	if (page_count <= BIO_MAX_PAGES)
+		bio = bio_alloc(GFP_NOIO, page_count);
+	else
+		bio = bio_kmalloc(GFP_NOIO, page_count);
+
 	if (!bio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-bio_alloc-failure-with-1mbyte-blocks.patch

