Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1262E62C0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406181AbgL1Ntk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406182AbgL1Ntk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050C120738;
        Mon, 28 Dec 2020 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163364;
        bh=Kb1WTf/if7ztm6KCptekc7ovnNtabWGDWlP8K4EUyjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Id/wK9BD6d8op4gvXTvLGVmY7mMpIm+PXtzO8ClKNj7mOQc0WgE+G1btYQS9pDBqV
         39c5URk4P66i/MITAmye6t6a0Qdu1zH1hJJeNND5LGn9VCd1hXv0dMcWxmngKMLldi
         jpR5B7nD52TFxSXyz4bFGw5zSc1RlfBTUmtOu4zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Huang Jianan <huangjianan@oppo.com>,
        Guo Weichao <guoweichao@oppo.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/453] erofs: avoid using generic_block_bmap
Date:   Mon, 28 Dec 2020 13:48:16 +0100
Message-Id: <20201228124949.735361752@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Jianan <huangjianan@oppo.com>

[ Upstream commit d8b3df8b1048405e73558b88cba2adf29490d468 ]

Surprisingly, `block' in sector_t indicates the number of
i_blkbits-sized blocks rather than sectors for bmap.

In addition, considering buffer_head limits mapped size to 32-bits,
should avoid using generic_block_bmap.

Link: https://lore.kernel.org/r/20201209115740.18802-1-huangjianan@oppo.com
Fixes: 9da681e017a3 ("staging: erofs: support bmap")
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Huang Jianan <huangjianan@oppo.com>
Signed-off-by: Guo Weichao <guoweichao@oppo.com>
[ Gao Xiang: slightly update the commit message description. ]
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index fc3a8d8064f84..b22a08ac53a23 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -323,27 +323,12 @@ static int erofs_raw_access_readpages(struct file *filp,
 	return 0;
 }
 
-static int erofs_get_block(struct inode *inode, sector_t iblock,
-			   struct buffer_head *bh, int create)
-{
-	struct erofs_map_blocks map = {
-		.m_la = iblock << 9,
-	};
-	int err;
-
-	err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
-	if (err)
-		return err;
-
-	if (map.m_flags & EROFS_MAP_MAPPED)
-		bh->b_blocknr = erofs_blknr(map.m_pa);
-
-	return err;
-}
-
 static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
+	struct erofs_map_blocks map = {
+		.m_la = blknr_to_addr(block),
+	};
 
 	if (EROFS_I(inode)->datalayout == EROFS_INODE_FLAT_INLINE) {
 		erofs_blk_t blks = i_size_read(inode) >> LOG_BLOCK_SIZE;
@@ -352,7 +337,10 @@ static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
 			return 0;
 	}
 
-	return generic_block_bmap(mapping, block, erofs_get_block);
+	if (!erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW))
+		return erofs_blknr(map.m_pa);
+
+	return 0;
 }
 
 /* for uncompressed (aligned) files and raw access for other files */
-- 
2.27.0



