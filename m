Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3641017A8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfKSFlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbfKSFlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE1321783;
        Tue, 19 Nov 2019 05:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142068;
        bh=4tVHdXxnr2nmS5HAhsqoyBMeGWaB5sri6kDgiem2kdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV+mSzrwXKaFq1Q1/OBQ6ebuF1h/HP+s3eUAgjMrnw4dvr9ySzTdkbZ3PghAXkRi6
         LG96M+WxiLJj1/xUMqrxTMNRiGj1SmDXL4ZST2av6668+/7JdY9V91qQ1ALuDMQ0XM
         xgPWPG7VkupxMnfVW+QODZcy6tK3sC1wnUiSHQcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 377/422] f2fs: update i_size after DIO completion
Date:   Tue, 19 Nov 2019 06:19:34 +0100
Message-Id: <20191119051423.467819205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b4a634da1372b..3a2fd66769660 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -889,7 +889,6 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	struct f2fs_summary sum;
 	struct node_info ni;
 	block_t old_blkaddr;
-	pgoff_t fofs;
 	blkcnt_t count = 1;
 	int err;
 
@@ -918,12 +917,10 @@ alloc:
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
 
@@ -1089,6 +1086,8 @@ next_block:
 					last_ofs_in_node = dn.ofs_in_node;
 				}
 			} else {
+				WARN_ON(flag != F2FS_GET_BLOCK_PRE_DIO &&
+					flag != F2FS_GET_BLOCK_DIO);
 				err = __allocate_data_block(&dn,
 							map->m_seg_type);
 				if (!err)
@@ -1268,7 +1267,7 @@ static int get_data_block_dio(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	return __get_data_block(inode, iblock, bh_result, create,
-						F2FS_GET_BLOCK_DEFAULT, NULL,
+						F2FS_GET_BLOCK_DIO, NULL,
 						f2fs_rw_hint_to_seg_type(
 							inode->i_write_hint));
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6d361c8c61306..2dc49a5419070 100644
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



