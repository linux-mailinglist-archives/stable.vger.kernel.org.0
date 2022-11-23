Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911F6357F1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiKWJsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbiKWJsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41A111A707
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B59F61B91
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ABAC43152;
        Wed, 23 Nov 2022 09:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196746;
        bh=D2UP2YYd+mhqq8EaxCuLQUVxSjK0la7pczMmuOnfYX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipk7h+kux+GhC4FO0URi2HxFvM2isOifcTy6ApB/3eFhbBciFQWw6hv3DMp5F0dsc
         5kU7oj+eB5iXFUHj59YWfmjOMUIxdr/NpntWq7N+FJS2chy+LrXmxBm3o/eFTGJOGK
         X7kfsQQRryHvl2rCPhJ0tPN3fIWVEvCMN2voRcfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Jia Zhu <zhujia.zj@bytedance.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 113/314] erofs: clean up .read_folio() and .readahead() in fscache mode
Date:   Wed, 23 Nov 2022 09:49:18 +0100
Message-Id: <20221123084630.634328886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 1ae9470c3e14624b0f4d8741c22b5a94062c0e33 ]

The implementation of these two functions in fscache mode is almost the
same. Extract the same part as a generic helper to remove the code
duplication.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://lore.kernel.org/r/20220922062414.20437-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: e6d9f9ba111b ("erofs: get correct count for unmapped range in fscache mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 213 ++++++++++++++++++---------------------------
 1 file changed, 83 insertions(+), 130 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index b5fd9d71e67f..508b1a4df15e 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -234,113 +234,111 @@ static int erofs_fscache_meta_read_folio(struct file *data, struct folio *folio)
 	return ret;
 }
 
-static int erofs_fscache_read_folio_inline(struct folio *folio,
-					 struct erofs_map_blocks *map)
-{
-	struct super_block *sb = folio_mapping(folio)->host->i_sb;
-	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-	erofs_blk_t blknr;
-	size_t offset, len;
-	void *src, *dst;
-
-	/* For tail packing layout, the offset may be non-zero. */
-	offset = erofs_blkoff(map->m_pa);
-	blknr = erofs_blknr(map->m_pa);
-	len = map->m_llen;
-
-	src = erofs_read_metabuf(&buf, sb, blknr, EROFS_KMAP);
-	if (IS_ERR(src))
-		return PTR_ERR(src);
-
-	dst = kmap_local_folio(folio, 0);
-	memcpy(dst, src + offset, len);
-	memset(dst + len, 0, PAGE_SIZE - len);
-	kunmap_local(dst);
-
-	erofs_put_metabuf(&buf);
-	return 0;
-}
-
-static int erofs_fscache_read_folio(struct file *file, struct folio *folio)
+/*
+ * Read into page cache in the range described by (@pos, @len).
+ *
+ * On return, the caller is responsible for page unlocking if the output @unlock
+ * is true, or the callee will take this responsibility through netfs_io_request
+ * interface.
+ *
+ * The return value is the number of bytes successfully handled, or negative
+ * error code on failure. The only exception is that, the length of the range
+ * instead of the error code is returned on failure after netfs_io_request is
+ * allocated, so that .readahead() could advance rac accordingly.
+ */
+static int erofs_fscache_data_read(struct address_space *mapping,
+				   loff_t pos, size_t len, bool *unlock)
 {
-	struct inode *inode = folio_mapping(folio)->host;
+	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
+	struct netfs_io_request *rreq;
 	struct erofs_map_blocks map;
 	struct erofs_map_dev mdev;
-	struct netfs_io_request *rreq;
-	erofs_off_t pos;
-	loff_t pstart;
+	struct iov_iter iter;
+	size_t count;
 	int ret;
 
-	DBG_BUGON(folio_size(folio) != EROFS_BLKSIZ);
+	*unlock = true;
 
-	pos = folio_pos(folio);
 	map.m_la = pos;
-
 	ret = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
-	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
-		folio_zero_range(folio, 0, folio_size(folio));
-		goto out_uptodate;
+	if (map.m_flags & EROFS_MAP_META) {
+		struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+		erofs_blk_t blknr;
+		size_t offset, size;
+		void *src;
+
+		/* For tail packing layout, the offset may be non-zero. */
+		offset = erofs_blkoff(map.m_pa);
+		blknr = erofs_blknr(map.m_pa);
+		size = map.m_llen;
+
+		src = erofs_read_metabuf(&buf, sb, blknr, EROFS_KMAP);
+		if (IS_ERR(src))
+			return PTR_ERR(src);
+
+		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, PAGE_SIZE);
+		if (copy_to_iter(src + offset, size, &iter) != size)
+			return -EFAULT;
+		iov_iter_zero(PAGE_SIZE - size, &iter);
+		erofs_put_metabuf(&buf);
+		return PAGE_SIZE;
 	}
 
-	if (map.m_flags & EROFS_MAP_META) {
-		ret = erofs_fscache_read_folio_inline(folio, &map);
-		goto out_uptodate;
+	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
+	DBG_BUGON(!count || count % PAGE_SIZE);
+
+	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, count);
+		iov_iter_zero(count, &iter);
+		return count;
 	}
 
 	mdev = (struct erofs_map_dev) {
 		.m_deviceid = map.m_deviceid,
 		.m_pa = map.m_pa,
 	};
-
 	ret = erofs_map_dev(sb, &mdev);
 	if (ret)
-		goto out_unlock;
-
-
-	rreq = erofs_fscache_alloc_request(folio_mapping(folio),
-				folio_pos(folio), folio_size(folio));
-	if (IS_ERR(rreq)) {
-		ret = PTR_ERR(rreq);
-		goto out_unlock;
-	}
+		return ret;
 
-	pstart = mdev.m_pa + (pos - map.m_la);
-	return erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
-				rreq, pstart);
+	rreq = erofs_fscache_alloc_request(mapping, pos, count);
+	if (IS_ERR(rreq))
+		return PTR_ERR(rreq);
 
-out_uptodate:
-	if (!ret)
-		folio_mark_uptodate(folio);
-out_unlock:
-	folio_unlock(folio);
-	return ret;
+	*unlock = false;
+	erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
+			rreq, mdev.m_pa + (pos - map.m_la));
+	return count;
 }
 
-static void erofs_fscache_advance_folios(struct readahead_control *rac,
-					 size_t len, bool unlock)
+static int erofs_fscache_read_folio(struct file *file, struct folio *folio)
 {
-	while (len) {
-		struct folio *folio = readahead_folio(rac);
-		len -= folio_size(folio);
-		if (unlock) {
+	bool unlock;
+	int ret;
+
+	DBG_BUGON(folio_size(folio) != EROFS_BLKSIZ);
+
+	ret = erofs_fscache_data_read(folio_mapping(folio), folio_pos(folio),
+				      folio_size(folio), &unlock);
+	if (unlock) {
+		if (ret > 0)
 			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
+		folio_unlock(folio);
 	}
+	return ret < 0 ? ret : 0;
 }
 
 static void erofs_fscache_readahead(struct readahead_control *rac)
 {
-	struct inode *inode = rac->mapping->host;
-	struct super_block *sb = inode->i_sb;
-	size_t len, count, done = 0;
-	erofs_off_t pos;
-	loff_t start, offset;
-	int ret;
+	struct folio *folio;
+	size_t len, done = 0;
+	loff_t start, pos;
+	bool unlock;
+	int ret, size;
 
 	if (!readahead_count(rac))
 		return;
@@ -349,67 +347,22 @@ static void erofs_fscache_readahead(struct readahead_control *rac)
 	len = readahead_length(rac);
 
 	do {
-		struct erofs_map_blocks map;
-		struct erofs_map_dev mdev;
-		struct netfs_io_request *rreq;
-
 		pos = start + done;
-		map.m_la = pos;
-
-		ret = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
-		if (ret)
+		ret = erofs_fscache_data_read(rac->mapping, pos,
+					      len - done, &unlock);
+		if (ret <= 0)
 			return;
 
-		offset = start + done;
-		count = min_t(size_t, map.m_llen - (pos - map.m_la),
-			      len - done);
-
-		if (!(map.m_flags & EROFS_MAP_MAPPED)) {
-			struct iov_iter iter;
-
-			iov_iter_xarray(&iter, READ, &rac->mapping->i_pages,
-					offset, count);
-			iov_iter_zero(count, &iter);
-
-			erofs_fscache_advance_folios(rac, count, true);
-			ret = count;
-			continue;
-		}
-
-		if (map.m_flags & EROFS_MAP_META) {
-			struct folio *folio = readahead_folio(rac);
-
-			ret = erofs_fscache_read_folio_inline(folio, &map);
-			if (!ret) {
+		size = ret;
+		while (size) {
+			folio = readahead_folio(rac);
+			size -= folio_size(folio);
+			if (unlock) {
 				folio_mark_uptodate(folio);
-				ret = folio_size(folio);
+				folio_unlock(folio);
 			}
-
-			folio_unlock(folio);
-			continue;
 		}
-
-		mdev = (struct erofs_map_dev) {
-			.m_deviceid = map.m_deviceid,
-			.m_pa = map.m_pa,
-		};
-		ret = erofs_map_dev(sb, &mdev);
-		if (ret)
-			return;
-
-		rreq = erofs_fscache_alloc_request(rac->mapping, offset, count);
-		if (IS_ERR(rreq))
-			return;
-		/*
-		 * Drop the ref of folios here. Unlock them in
-		 * rreq_unlock_folios() when rreq complete.
-		 */
-		erofs_fscache_advance_folios(rac, count, false);
-		ret = erofs_fscache_read_folios_async(mdev.m_fscache->cookie,
-					rreq, mdev.m_pa + (pos - map.m_la));
-		if (!ret)
-			ret = count;
-	} while (ret > 0 && ((done += ret) < len));
+	} while ((done += ret) < len);
 }
 
 static const struct address_space_operations erofs_fscache_meta_aops = {
-- 
2.35.1



