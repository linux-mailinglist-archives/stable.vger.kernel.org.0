Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21907F65D5
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKJDJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbfKJCo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B78921655;
        Sun, 10 Nov 2019 02:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353866;
        bh=Sg8qrQudyXGXbUZiWMaBT0NuDvDe+WK1N9/ihXre3Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kwALOfWONzGrUrbGac1CiV62VxHO1ob3YKkADF2sqtxlUP5y45ya3M3rsSXEg1SF
         ljia4BaUBV6VRiDOQb3dmM1SZCLxpeuHFx3vWewmrSHF25SEL7kaSSeCRFOExTn0tw
         EfAlC+wvz4kntbyrWZab8kK2sDK7tFgHiT16Z1LE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 146/191] f2fs: update i_size after DIO completion
Date:   Sat,  9 Nov 2019 21:39:28 -0500
Message-Id: <20191110024013.29782-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0a4daae5ffea39f5015334e4d18a6a80b447cae4 ]

This is related to
ee70daaba82d ("xfs: update i_size after unwritten conversion in dio completion")

If we update i_size during dio_write, dio_read can read out stale data, which
breaks xfstests/465.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 15 +++++++--------
 fs/f2fs/f2fs.h |  1 +
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9511466bc7857..c0d0744a52a55 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -887,7 +887,6 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	struct f2fs_summary sum;
 	struct node_info ni;
 	block_t old_blkaddr;
-	pgoff_t fofs;
 	blkcnt_t count = 1;
 	int err;
 
@@ -916,12 +915,10 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 					old_blkaddr, old_blkaddr);
 	f2fs_set_data_blkaddr(dn);
 
-	/* update i_size */
-	fofs = f2fs_start_bidx_of_node(ofs_of_node(dn->node_page), dn->inode) +
-							dn->ofs_in_node;
-	if (i_size_read(dn->inode) < ((loff_t)(fofs + 1) << PAGE_SHIFT))
-		f2fs_i_size_write(dn->inode,
-				((loff_t)(fofs + 1) << PAGE_SHIFT));
+	/*
+	 * i_size will be updated by direct_IO. Otherwise, we'll get stale
+	 * data from unwritten block via dio_read.
+	 */
 	return 0;
 }
 
@@ -1087,6 +1084,8 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 					last_ofs_in_node = dn.ofs_in_node;
 				}
 			} else {
+				WARN_ON(flag != F2FS_GET_BLOCK_PRE_DIO &&
+					flag != F2FS_GET_BLOCK_DIO);
 				err = __allocate_data_block(&dn,
 							map->m_seg_type);
 				if (!err)
@@ -1266,7 +1265,7 @@ static int get_data_block_dio(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	return __get_data_block(inode, iblock, bh_result, create,
-						F2FS_GET_BLOCK_DEFAULT, NULL,
+						F2FS_GET_BLOCK_DIO, NULL,
 						f2fs_rw_hint_to_seg_type(
 							inode->i_write_hint));
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fb216488d67a9..6beda9147d3a0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -600,6 +600,7 @@ enum {
 	F2FS_GET_BLOCK_DEFAULT,
 	F2FS_GET_BLOCK_FIEMAP,
 	F2FS_GET_BLOCK_BMAP,
+	F2FS_GET_BLOCK_DIO,
 	F2FS_GET_BLOCK_PRE_DIO,
 	F2FS_GET_BLOCK_PRE_AIO,
 	F2FS_GET_BLOCK_PRECACHE,
-- 
2.20.1

