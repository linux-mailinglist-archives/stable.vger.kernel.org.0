Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D266517E1
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiLTBWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiLTBV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:21:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8FB11C35;
        Mon, 19 Dec 2022 17:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4731EB81104;
        Tue, 20 Dec 2022 01:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0827FC433EF;
        Tue, 20 Dec 2022 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499283;
        bh=O7ZPnSdU+9nfWxyIj09iRYt36PSNkVWc7abHvEsM3jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l79GltoUtUIrOTCIUIiPm9lpQJKSDmQTDHXdBJRiXi7HTd+gT3KLrQF1lQSAMgcd5
         NVhM7qTxrq3NxwCXa2WfG+MXl/6YX9Y7wlNMWEZri6FvEIy17hb4puWau7y1/ubAIP
         jI2U984GHVtpb3Gid7l3FT4+qwSvtA2BsYRUyDuh+DlfEYA/FZgvvcYTYO8DmaxYbW
         4859GlP0P5kI519Q/xwjXLl1XNgGVymI2HoYGQrSC7vwHQD0ZLHcleY91X3bq+nnQ8
         yZv1QPGE6NEU57Uw6I7CEqGJgYig8nXoH96ooFlC20p7DQPSkKOvV73Uet9lsaxjBJ
         uVroiPwaI5zVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/16] iomap: write iomap validity checks
Date:   Mon, 19 Dec 2022 20:20:50 -0500
Message-Id: <20221220012053.1222101-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012053.1222101-1-sashal@kernel.org>
References: <20221220012053.1222101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d7b64041164ca177170191d2ad775da074ab2926 ]

A recent multithreaded write data corruption has been uncovered in
the iomap write code. The core of the problem is partial folio
writes can be flushed to disk while a new racing write can map it
and fill the rest of the page:

writeback			new write

allocate blocks
  blocks are unwritten
submit IO
.....
				map blocks
				iomap indicates UNWRITTEN range
				loop {
				  lock folio
				  copyin data
.....
IO completes
  runs unwritten extent conv
    blocks are marked written
				  <iomap now stale>
				  get next folio
				}

Now add memory pressure such that memory reclaim evicts the
partially written folio that has already been written to disk.

When the new write finally gets to the last partial page of the new
write, it does not find it in cache, so it instantiates a new page,
sees the iomap is unwritten, and zeros the part of the page that
it does not have data from. This overwrites the data on disk that
was originally written.

The full description of the corruption mechanism can be found here:

https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/

To solve this problem, we need to check whether the iomap is still
valid after we lock each folio during the write. We have to do it
after we lock the page so that we don't end up with state changes
occurring while we wait for the folio to be locked.

Hence we need a mechanism to be able to check that the cached iomap
is still valid (similar to what we already do in buffered
writeback), and we need a way for ->begin_write to back out and
tell the high level iomap iterator that we need to remap the
remaining write range.

The iomap needs to grow some storage for the validity cookie that
the filesystem provides to travel with the iomap. XFS, in
particular, also needs to know some more information about what the
iomap maps (attribute extents rather than file data extents) to for
the validity cookie to cover all the types of iomaps we might need
to validate.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 29 +++++++++++++++++++++++++++-
 fs/iomap/iter.c        | 19 ++++++++++++++++++-
 include/linux/iomap.h  | 43 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13..8354b0fdaa94 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -584,7 +584,7 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
 	return iomap_read_inline_data(iter, folio);
 }
 
-static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
+static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		size_t len, struct folio **foliop)
 {
 	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
@@ -618,6 +618,27 @@ static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
 		goto out_no_page;
 	}
+
+	/*
+	 * Now we have a locked folio, before we do anything with it we need to
+	 * check that the iomap we have cached is not stale. The inode extent
+	 * mapping can change due to concurrent IO in flight (e.g.
+	 * IOMAP_UNWRITTEN state can change and memory reclaim could have
+	 * reclaimed a previously partially written page at this index after IO
+	 * completion before this write reaches this file offset) and hence we
+	 * could do the wrong thing here (zero a page range incorrectly or fail
+	 * to zero) and corrupt data.
+	 */
+	if (page_ops && page_ops->iomap_valid) {
+		bool iomap_valid = page_ops->iomap_valid(iter->inode,
+							&iter->iomap);
+		if (!iomap_valid) {
+			iter->iomap.flags |= IOMAP_F_STALE;
+			status = 0;
+			goto out_unlock;
+		}
+	}
+
 	if (pos + len > folio_pos(folio) + folio_size(folio))
 		len = folio_pos(folio) + folio_size(folio) - pos;
 
@@ -773,6 +794,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			break;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		page = folio_file_page(folio, pos >> PAGE_SHIFT);
 		if (mapping_writably_mapped(mapping))
@@ -856,6 +879,8 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		status = iomap_write_end(iter, pos, bytes, bytes, folio);
 		if (WARN_ON_ONCE(status == 0))
@@ -911,6 +936,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index a1c7592d2ade..79a0614eaab7 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -7,12 +7,28 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Advance to the next range we need to map.
+ *
+ * If the iomap is marked IOMAP_F_STALE, it means the existing map was not fully
+ * processed - it was aborted because the extent the iomap spanned may have been
+ * changed during the operation. In this case, the iteration behaviour is to
+ * remap the unprocessed range of the iter, and that means we may need to remap
+ * even when we've made no progress (i.e. iter->processed = 0). Hence the
+ * "finished iterating" case needs to distinguish between
+ * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
+ * need to remap the entire remaining range.
+ */
 static inline int iomap_iter_advance(struct iomap_iter *iter)
 {
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
-		if (iter->processed <= 0)
+		if (iter->processed < 0)
 			return iter->processed;
+		if (!iter->processed && !stale)
+			return 0;
 		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
 			return -EIO;
 		iter->pos += iter->processed;
@@ -33,6 +49,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
 	WARN_ON_ONCE(iter->iomap.length == 0);
 	WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
+	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_STALE);
 
 	trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
 	if (iter->srcmap.type != IOMAP_HOLE)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..f166d80b68bf 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -49,26 +49,35 @@ struct vm_fault;
  *
  * IOMAP_F_BUFFER_HEAD indicates that the file system requires the use of
  * buffer heads for this mapping.
+ *
+ * IOMAP_F_XATTR indicates that the iomap is for an extended attribute extent
+ * rather than a file data extent.
  */
-#define IOMAP_F_NEW		0x01
-#define IOMAP_F_DIRTY		0x02
-#define IOMAP_F_SHARED		0x04
-#define IOMAP_F_MERGED		0x08
-#define IOMAP_F_BUFFER_HEAD	0x10
-#define IOMAP_F_ZONE_APPEND	0x20
+#define IOMAP_F_NEW		(1U << 0)
+#define IOMAP_F_DIRTY		(1U << 1)
+#define IOMAP_F_SHARED		(1U << 2)
+#define IOMAP_F_MERGED		(1U << 3)
+#define IOMAP_F_BUFFER_HEAD	(1U << 4)
+#define IOMAP_F_ZONE_APPEND	(1U << 5)
+#define IOMAP_F_XATTR		(1U << 6)
 
 /*
  * Flags set by the core iomap code during operations:
  *
  * IOMAP_F_SIZE_CHANGED indicates to the iomap_end method that the file size
  * has changed as the result of this write operation.
+ *
+ * IOMAP_F_STALE indicates that the iomap is not valid any longer and the file
+ * range it covers needs to be remapped by the high level before the operation
+ * can proceed.
  */
-#define IOMAP_F_SIZE_CHANGED	0x100
+#define IOMAP_F_SIZE_CHANGED	(1U << 8)
+#define IOMAP_F_STALE		(1U << 9)
 
 /*
  * Flags from 0x1000 up are for file system specific usage:
  */
-#define IOMAP_F_PRIVATE		0x1000
+#define IOMAP_F_PRIVATE		(1U << 12)
 
 
 /*
@@ -89,6 +98,7 @@ struct iomap {
 	void			*inline_data;
 	void			*private; /* filesystem private */
 	const struct iomap_page_ops *page_ops;
+	u64			validity_cookie; /* used with .iomap_valid() */
 };
 
 static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
@@ -128,6 +138,23 @@ struct iomap_page_ops {
 	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
 	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
 			struct page *page);
+
+	/*
+	 * Check that the cached iomap still maps correctly to the filesystem's
+	 * internal extent map. FS internal extent maps can change while iomap
+	 * is iterating a cached iomap, so this hook allows iomap to detect that
+	 * the iomap needs to be refreshed during a long running write
+	 * operation.
+	 *
+	 * The filesystem can store internal state (e.g. a sequence number) in
+	 * iomap->validity_cookie when the iomap is first mapped to be able to
+	 * detect changes between mapping time and whenever .iomap_valid() is
+	 * called.
+	 *
+	 * This is called with the folio over the specified file position held
+	 * locked by the iomap code.
+	 */
+	bool (*iomap_valid)(struct inode *inode, const struct iomap *iomap);
 };
 
 /*
-- 
2.35.1

