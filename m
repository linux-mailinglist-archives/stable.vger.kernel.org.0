Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614F624C950
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgHUAmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgHUAmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C8C207BB;
        Fri, 21 Aug 2020 00:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970542;
        bh=5noErkd/QBjuIceru/4CMPCuhV51RMG42iGKhOfIZLc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E3h/stmY1J7HLBZlCdKnSMods3Umi5J/69iWoOzxN2zmvoFuNHQG9AGmRkLh+O+yF
         xP5nPLldwkdNvBgV0U/LXUtCxSr8H5wldrn2j5Z2kTl3Wgj6pez85Nrd/J1yuiNjnd
         jH7Q6IIyIrZdCNJ2Vz94W3LlABW6fPTXLqU+YB6Q=
Date:   Thu, 20 Aug 2020 17:42:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adrien+dev@schischi.me, akpm@linux-foundation.org,
        drosen@google.com, groeck@chromium.org, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nicolas.prochazka@gmail.com, phillip@squashfs.org.uk,
        pliard@google.com, shimada@walbrix.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/11] squashfs: avoid bio_alloc() failure with
 1Mbyte blocks
Message-ID: <20200821004221.zUskNqmfM%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
