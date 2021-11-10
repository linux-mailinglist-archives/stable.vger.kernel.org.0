Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5049144C039
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 12:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhKJLlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 06:41:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhKJLlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 06:41:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636544344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mSRSfofEtoedE2yqkJZbQw0bqF5J9tr3mlk5/Zhn3oU=;
        b=fnPJfpZcki3JLw9Dh24xy0xX5l9ZqFardgnmdV+dbH30M9Fvis5nrWGgxW2NbJPf9WzpWz
        TRlY6zpg0E1MJUeNMivNu0ZubTWW51enh5WUqxxwmGGWYSLPH4admKxd6Pq2DIFZGsDJcp
        EmgObTYkTeUNefzzCl4UQgfdQ4xW/nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-YygdlXlsPsOEpiQxl1Uv7w-1; Wed, 10 Nov 2021 06:39:01 -0500
X-MC-Unique: YygdlXlsPsOEpiQxl1Uv7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6554719067E0;
        Wed, 10 Nov 2021 11:39:00 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.195.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96D3419D9F;
        Wed, 10 Nov 2021 11:38:43 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
Subject: [5.15 REGRESSION] iomap: Fix inline extent handling in iomap_readpage
Date:   Wed, 10 Nov 2021 12:38:42 +0100
Message-Id: <20211110113842.517426-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When reporting IOMAP_INLINE extents, filesystems set iomap->length to
the length of iomap->inline_data.  For reading that into the page cache,
function iomap_read_inline_data copies the inline data, zeroes out the
rest of the page, and marks the entire page up-to-date.

Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
value for inline data"), when hitting an IOMAP_INLINE extent,
iomap_readpage_actor would report having read the entire page.  Since
then, it only reports having read the inline data (iomap->length).

This will force iomap_readpage into another iteration, and the
filesystem will report an unaligned hole after the IOMAP_INLINE extent.
But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
deal with unaligned extents, it will get things wrong on filesystems
with a block size smaller than the page size, and we'll eventually run
into the following warning in iomap_iter_advance:

  WARN_ON_ONCE(iter->processed > iomap_length(iter));

Fix that by changing iomap_readpage_iter back to report that we've read
the entire page, which avoids having to deal with unaligned extents.  To
prevent iomap from complaining about running past the end of the extent,
fix up the extent size as well.

Fixes: 740499c78408 ("iomap: fix the iomap_readpage_actor return value for inline data")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1753c26c8e76..de3fcd2522a2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -244,10 +244,10 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 		pos >= i_size_read(iter->inode);
 }
 
-static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
+static loff_t iomap_readpage_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx, loff_t offset)
 {
-	const struct iomap *iomap = &iter->iomap;
+	struct iomap *iomap = &iter->iomap;
 	loff_t pos = iter->pos + offset;
 	loff_t length = iomap_length(iter) - offset;
 	struct page *page = ctx->cur_page;
@@ -256,8 +256,15 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	unsigned poff, plen;
 	sector_t sector;
 
-	if (iomap->type == IOMAP_INLINE)
-		return min(iomap_read_inline_data(iter, page), length);
+	if (iomap->type == IOMAP_INLINE) {
+		/*
+		 * The filesystem sets iomap->length to the size of the inline
+		 * data.  We're at the end of the file, so we know that the
+		 * rest of the page needs to be zeroed out.
+		 */
+		iomap->length = iomap_read_inline_data(iter, page);
+		return iomap->length;
+	}
 
 	/* zero post-eof blocks as the page may be mapped */
 	iop = iomap_page_create(iter->inode, page);
@@ -352,7 +359,7 @@ iomap_readpage(struct page *page, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_readpage);
 
-static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
+static loff_t iomap_readahead_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
 	loff_t length = iomap_length(iter);
-- 
2.31.1

