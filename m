Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF5657ACE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiL1PPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiL1PPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8B613EAF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 070E26155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12864C433EF;
        Wed, 28 Dec 2022 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240502;
        bh=HQt/RaU67WmlK+obr6Pit5a+GbGA3NcCzXse/VFamyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qchqZqrcG7nzCU6aXnH8fi39ILb/PZfnTyRmNhO3mWWFI7U36K6Jz8QojTBOGwBSl
         aetknrFugDrrk48Flfh5NVmjR6xqPMZ9HO+tFYyU99DuYHg1b5tetPLkz0wyxfwHOq
         /3OfxlOIhyceeF7uWeXe0hiJH+gm6JlJFU91qDnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yue Hu <huyue2@coolpad.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0168/1073] erofs: support interlaced uncompressed data for compressed files
Date:   Wed, 28 Dec 2022 15:29:16 +0100
Message-Id: <20221228144332.578613679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yue Hu <huyue2@coolpad.com>

[ Upstream commit fdffc091e6f94602558bba712b51bc16f79fd6d5 ]

Currently, uncompressed data is all handled in the shifted way, which
means we have to shift the whole on-disk plain pcluster to get the
logical data.   However, since we are also using in-place I/O for
uncompressed data, data copy will be reduced a lot if pcluster is
recorded in the interlaced way as illustrated below:
 _______________________________________________________________
|               |    |               |_ tail part |_ head part _|
|<-   blk0    ->| .. |<-   blkn-2  ->|<-         blkn-1       ->|

The logical data then becomes:
 ________________________________________________________
|_ head part _|_  blk0  _| .. |_  blkn-2  _|_ tail part _|

In addition, non-4k plain pclusters are also survived by the
interlaced way, which can be used for non-4k lclusters as well.

However, it's almost impossible to de-duplicate uncompressed data
in the interlaced way, therefore shifted uncompressed data is still
useful.

Signed-off-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/8369112678604fdf4ef796626d59b1fdd0745a53.1663898962.git.huyue2@coolpad.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: c505feba4c0d ("erofs: validate the extent length for uncompressed pclusters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 47 ++++++++++++++++++++++++-----------------
 fs/erofs/erofs_fs.h     |  2 ++
 fs/erofs/internal.h     |  1 +
 fs/erofs/zmap.c         | 14 ++++++++----
 4 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 2d55569f96ac..51b7ac7166d9 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -317,52 +317,61 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq,
 	return ret;
 }
 
-static int z_erofs_shifted_transform(struct z_erofs_decompress_req *rq,
-				     struct page **pagepool)
+static int z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
+				   struct page **pagepool)
 {
-	const unsigned int nrpages_out =
+	const unsigned int inpages = PAGE_ALIGN(rq->inputsize) >> PAGE_SHIFT;
+	const unsigned int outpages =
 		PAGE_ALIGN(rq->pageofs_out + rq->outputsize) >> PAGE_SHIFT;
 	const unsigned int righthalf = min_t(unsigned int, rq->outputsize,
 					     PAGE_SIZE - rq->pageofs_out);
 	const unsigned int lefthalf = rq->outputsize - righthalf;
+	const unsigned int interlaced_offset =
+		rq->alg == Z_EROFS_COMPRESSION_SHIFTED ? 0 : rq->pageofs_out;
 	unsigned char *src, *dst;
 
-	if (nrpages_out > 2) {
+	if (outpages > 2 && rq->alg == Z_EROFS_COMPRESSION_SHIFTED) {
 		DBG_BUGON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	if (rq->out[0] == *rq->in) {
-		DBG_BUGON(nrpages_out != 1);
+		DBG_BUGON(rq->pageofs_out);
 		return 0;
 	}
 
-	src = kmap_atomic(*rq->in) + rq->pageofs_in;
+	src = kmap_local_page(rq->in[inpages - 1]) + rq->pageofs_in;
 	if (rq->out[0]) {
-		dst = kmap_atomic(rq->out[0]);
-		memcpy(dst + rq->pageofs_out, src, righthalf);
-		kunmap_atomic(dst);
+		dst = kmap_local_page(rq->out[0]);
+		memcpy(dst + rq->pageofs_out, src + interlaced_offset,
+		       righthalf);
+		kunmap_local(dst);
 	}
 
-	if (nrpages_out == 2) {
-		DBG_BUGON(!rq->out[1]);
-		if (rq->out[1] == *rq->in) {
+	if (outpages > inpages) {
+		DBG_BUGON(!rq->out[outpages - 1]);
+		if (rq->out[outpages - 1] != rq->in[inpages - 1]) {
+			dst = kmap_local_page(rq->out[outpages - 1]);
+			memcpy(dst, interlaced_offset ? src :
+					(src + righthalf), lefthalf);
+			kunmap_local(dst);
+		} else if (!interlaced_offset) {
 			memmove(src, src + righthalf, lefthalf);
-		} else {
-			dst = kmap_atomic(rq->out[1]);
-			memcpy(dst, src + righthalf, lefthalf);
-			kunmap_atomic(dst);
 		}
 	}
-	kunmap_atomic(src);
+	kunmap_local(src);
 	return 0;
 }
 
 static struct z_erofs_decompressor decompressors[] = {
 	[Z_EROFS_COMPRESSION_SHIFTED] = {
-		.decompress = z_erofs_shifted_transform,
+		.decompress = z_erofs_transform_plain,
 		.name = "shifted"
 	},
+	[Z_EROFS_COMPRESSION_INTERLACED] = {
+		.decompress = z_erofs_transform_plain,
+		.name = "interlaced"
+	},
 	[Z_EROFS_COMPRESSION_LZ4] = {
 		.decompress = z_erofs_lz4_decompress,
 		.name = "lz4"
diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 2b48373f690b..5c1de6d7ad71 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -295,11 +295,13 @@ struct z_erofs_lzma_cfgs {
  * bit 1 : HEAD1 big pcluster (0 - off; 1 - on)
  * bit 2 : HEAD2 big pcluster (0 - off; 1 - on)
  * bit 3 : tailpacking inline pcluster (0 - off; 1 - on)
+ * bit 4 : interlaced plain pcluster (0 - off; 1 - on)
  */
 #define Z_EROFS_ADVISE_COMPACTED_2B		0x0001
 #define Z_EROFS_ADVISE_BIG_PCLUSTER_1		0x0002
 #define Z_EROFS_ADVISE_BIG_PCLUSTER_2		0x0004
 #define Z_EROFS_ADVISE_INLINE_PCLUSTER		0x0008
+#define Z_EROFS_ADVISE_INTERLACED_PCLUSTER	0x0010
 
 struct z_erofs_map_header {
 	__le16	h_reserved1;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index a01cc82795a2..12d075dfb964 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -407,6 +407,7 @@ struct erofs_map_blocks {
 
 enum {
 	Z_EROFS_COMPRESSION_SHIFTED = Z_EROFS_COMPRESSION_MAX,
+	Z_EROFS_COMPRESSION_INTERLACED,
 	Z_EROFS_COMPRESSION_RUNTIME_MAX
 };
 
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index bcc39077e9ac..a2a44c11bb64 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -676,12 +676,18 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 			goto unmap_out;
 	}
 
-	if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_PLAIN)
-		map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-	else if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_HEAD2)
+	if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_PLAIN) {
+		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
+			map->m_algorithmformat =
+				Z_EROFS_COMPRESSION_INTERLACED;
+		else
+			map->m_algorithmformat =
+				Z_EROFS_COMPRESSION_SHIFTED;
+	} else if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_HEAD2) {
 		map->m_algorithmformat = vi->z_algorithmtype[1];
-	else
+	} else {
 		map->m_algorithmformat = vi->z_algorithmtype[0];
+	}
 
 	if ((flags & EROFS_GET_BLOCKS_FIEMAP) ||
 	    ((flags & EROFS_GET_BLOCKS_READMORE) &&
-- 
2.35.1



