Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF242E3D98
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501887AbgL1ORe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501881AbgL1ORe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E59207B2;
        Mon, 28 Dec 2020 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165038;
        bh=+ckL7sCwj843aPBGGz7Zq03vrwFIHW76lI/94Rcm2x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJS8d1/bjjUDbxPpTFXx2kCuV6I8fQjG7U4FJBl1oLMomD3E2s8ARs19L39XndTVn
         54A1IjG2ZFXQ3kpD5ion1raoVuEspX6+l39ULrDggAVue5aU1BEdxI/7vZbU1+OX8n
         88aAbmQBcKzBVSRbmhe1AsYpUoRLBLd5sXTfKKpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Huang Jianan <huangjianan@oppo.com>,
        Guo Weichao <guoweichao@oppo.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/717] erofs: avoid using generic_block_bmap
Date:   Mon, 28 Dec 2020 13:46:27 +0100
Message-Id: <20201228125039.642500610@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 347be146884c3..ea4f693bee224 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -312,27 +312,12 @@ static void erofs_raw_access_readahead(struct readahead_control *rac)
 		submit_bio(bio);
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
@@ -341,7 +326,10 @@ static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
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



