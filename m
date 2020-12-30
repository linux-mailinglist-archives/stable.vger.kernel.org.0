Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3892E7914
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgL3NGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbgL3NFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6830A2246B;
        Wed, 30 Dec 2020 13:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333490;
        bh=ReUes9q7BqELJX4xI33jWXD2pF9HTd2JgrZ9Ofcr1oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZfpLXQ38fxR9rUZTN2YCFYJdZP74Av0/Gv9wrioQWgXB1bd/Zpvogzd6x9KYE+PQ
         G+DXnqccE4g/l111WmCkNdZbqxZHt4K1DRuE0XZ7X72p6Hyo8/Rxz8tJFkhdW1RYyv
         /NXejqr/5wPpyHxNsbeduIrhmLDPz+wyMebtGvzgQJ0KTdRtJkj9C8C6H/SGFa7BLI
         FRpbQX1diHB5/z8JNDfUB3vjMV1Y21UzvjkTHYGvhy7QLm+LUWOMqZvGycqI3XOB/y
         sNurdBJSv4nOac3zEhM0NJLNyPCBPNfkiff+pNsmtZj2O9jJYQ6JfbuPm7nglV9jKK
         h7PDlWfd8j9uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 2/5] quota: Don't overflow quota file offsets
Date:   Wed, 30 Dec 2020 08:04:44 -0500
Message-Id: <20201230130447.3637694-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130447.3637694-1-sashal@kernel.org>
References: <20201230130447.3637694-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 10f04d40a9fa29785206c619f80d8beedb778837 ]

The on-disk quota format supports quota files with upto 2^32 blocks. Be
careful when computing quota file offsets in the quota files from block
numbers as they can overflow 32-bit types. Since quota files larger than
4GB would require ~26 millions of quota users, this is mostly a
theoretical concern now but better be careful, fuzzers would find the
problem sooner or later anyway...

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota_tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 0738972e8d3f0..ecd9887b0d1fe 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -61,7 +61,7 @@ static ssize_t read_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 
 	memset(buf, 0, info->dqi_usable_bs);
 	return sb->s_op->quota_read(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 }
 
 static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
@@ -70,7 +70,7 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 	ssize_t ret;
 
 	ret = sb->s_op->quota_write(sb, info->dqi_type, buf,
-	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
+	       info->dqi_usable_bs, (loff_t)blk << info->dqi_blocksize_bits);
 	if (ret != info->dqi_usable_bs) {
 		quota_error(sb, "dquota write failed");
 		if (ret >= 0)
@@ -283,7 +283,7 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
 			    blk);
 		goto out_buf;
 	}
-	dquot->dq_off = (blk << info->dqi_blocksize_bits) +
+	dquot->dq_off = ((loff_t)blk << info->dqi_blocksize_bits) +
 			sizeof(struct qt_disk_dqdbheader) +
 			i * info->dqi_entry_size;
 	kfree(buf);
@@ -558,7 +558,7 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
 		ret = -EIO;
 		goto out_buf;
 	} else {
-		ret = (blk << info->dqi_blocksize_bits) + sizeof(struct
+		ret = ((loff_t)blk << info->dqi_blocksize_bits) + sizeof(struct
 		  qt_disk_dqdbheader) + i * info->dqi_entry_size;
 	}
 out_buf:
-- 
2.27.0

