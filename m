Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35BE40E5B4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350888AbhIPROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350674AbhIPRLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98476140F;
        Thu, 16 Sep 2021 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810298;
        bh=ZtrKLeLVWbqB664sLNuRoEgEqzoe5fiWVqCH3F4UCO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWiEkHSLFpLt4x7looYOsEGxlKlfsDnGvp8pcjCOxN56jk7YSCYlThpKANotkyav1
         GvbkSimyfOxPVY6HjNFpw6QnOpCb0uz9D+iNSHSDhGOEWLPCKlMmg6wsnubfNs6llE
         Fc/fqqhQz00ce0hyhrJ8MWzVIJnJagMl4Wjzgz94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Youngjin Gil <youngjin.gil@samsung.com>,
        Hyeong Jun Kim <hj514.kim@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 088/432] f2fs: turn back remapped address in compressed page endio
Date:   Thu, 16 Sep 2021 17:57:17 +0200
Message-Id: <20210916155813.767494801@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 4931e0c93e124357308893a3e5e224cbeeabc721 ]

Turned back the remmaped sector address to the address in the partition,
when ending io, for compress cache to work properly.

Fixes: 6ce19aff0b8c ("f2fs: compress: add compress_inode to cache
compressed blocks")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Hyeong Jun Kim <hj514.kim@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ba120d55e9b1..6eda24768d4b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -116,6 +116,7 @@ struct bio_post_read_ctx {
 	struct f2fs_sb_info *sbi;
 	struct work_struct work;
 	unsigned int enabled_steps;
+	block_t fs_blkaddr;
 };
 
 static void f2fs_finish_read_bio(struct bio *bio)
@@ -228,7 +229,7 @@ static void f2fs_handle_step_decompress(struct bio_post_read_ctx *ctx)
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 	bool all_compressed = true;
-	block_t blkaddr = SECTOR_TO_BLOCK(ctx->bio->bi_iter.bi_sector);
+	block_t blkaddr = ctx->fs_blkaddr;
 
 	bio_for_each_segment_all(bv, ctx->bio, iter_all) {
 		struct page *page = bv->bv_page;
@@ -1003,6 +1004,7 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 		ctx->bio = bio;
 		ctx->sbi = sbi;
 		ctx->enabled_steps = post_read_steps;
+		ctx->fs_blkaddr = blkaddr;
 		bio->bi_private = ctx;
 	}
 
-- 
2.30.2



