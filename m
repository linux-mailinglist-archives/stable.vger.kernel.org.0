Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30906B42B4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjCJOGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjCJOGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D1314233
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D518617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E09FC433D2;
        Fri, 10 Mar 2023 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457130;
        bh=V/cX8kh6Yf+9u6fvnRURvuOx4GM5pfroYORCzuxND04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYz1AIQ9Dnb2oLEZiT3v5eGl5uXyinKSj9CvrtXIIvgBBxZiUHX3w1QTas8MTYQn+
         SufijpooH3OC1LaZ/iqgL7OcGCrblhZRgm59ClDZ4HPZBXke11h5pMU1NF5jTEtUpF
         /yjATgIHRq4IqkY2DP11HcwVG2x1AwpamBWwEQFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/200] f2fs: dont rely on F2FS_MAP_* in f2fs_iomap_begin
Date:   Fri, 10 Mar 2023 14:36:52 +0100
Message-Id: <20230310133717.220240433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 8d3c1fa3fa5eacfd14f5b018eddb6c1a91c57783 ]

When testing with a mixed zoned / convention device combination, there
are regular but not 100% reproducible failures in xfstests generic/113
where the __is_valid_data_blkaddr assert hits due to finding a hole.

This seems to be because f2fs_map_blocks can set this flag on a hole
when it was found in the extent cache.

Rework f2fs_iomap_begin to just check the special block numbers directly.
This has the added benefits of the WARN_ON showing which invalid block
address we found, and being properly error out on delalloc blocks that
are confusingly called unwritten but not actually suitable for direct
I/O.

Fixes: 1517c1a7a445 ("f2fs: implement iomap operations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5f4519af98214..f92899bfcbd5e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4138,20 +4138,24 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
 
-	if (map.m_flags & (F2FS_MAP_MAPPED | F2FS_MAP_UNWRITTEN)) {
-		iomap->length = blks_to_bytes(inode, map.m_len);
-		if (map.m_flags & F2FS_MAP_MAPPED) {
-			iomap->type = IOMAP_MAPPED;
-			iomap->flags |= IOMAP_F_MERGED;
-		} else {
-			iomap->type = IOMAP_UNWRITTEN;
-		}
-		if (WARN_ON_ONCE(!__is_valid_data_blkaddr(map.m_pblk)))
-			return -EINVAL;
+	/*
+	 * We should never see delalloc or compressed extents here based on
+	 * prior flushing and checks.
+	 */
+	if (WARN_ON_ONCE(map.m_pblk == NEW_ADDR))
+		return -EINVAL;
+	if (WARN_ON_ONCE(map.m_pblk == COMPRESS_ADDR))
+		return -EINVAL;
 
+	if (map.m_pblk != NULL_ADDR) {
+		iomap->length = blks_to_bytes(inode, map.m_len);
+		iomap->type = IOMAP_MAPPED;
+		iomap->flags |= IOMAP_F_MERGED;
 		iomap->bdev = map.m_bdev;
 		iomap->addr = blks_to_bytes(inode, map.m_pblk);
 	} else {
+		if (flags & IOMAP_WRITE)
+			return -ENOTBLK;
 		iomap->length = blks_to_bytes(inode, next_pgofs) -
 				iomap->offset;
 		iomap->type = IOMAP_HOLE;
-- 
2.39.2



