Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B69348FF3
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhCYLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhCYL3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D91B961A3C;
        Thu, 25 Mar 2021 11:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671643;
        bh=ESrgeAGkNjGuJum2C8Uh4K19XiYTrGfcFCRY97NUhBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnTD3VMbqpXeYJic7NAjjioohOaWvK/sxML2EDkQkDZrVQXpDlkTVZ+mqj4Q1yf8q
         vXIWGwFwxwY94g9X+OoKJXq73GMGwNDoL/GcXeQVPCQdAO0/A5HS8mJ399YGFHFKDA
         rZU3kGpJqKmc0M8fGUTdnJ0LAaj6vUGPMTBXSyMtXSlgvTYjrZtJpdvdyQ4BCNQtxI
         Gv0JbEr1gGp7Qu9h18dbHPHGZ+S1hgMZUcJ49lry+O2o2ZZe8K+1EEI5zP8kltx1lJ
         9/WJ1pgW1O6w3NjemXa6jONDV3Edam8ufU0F4Z+pPkdQZ6G4nGBlXUcdjEEPBaJu1R
         kF/id5M+gxMVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/24] ext4: do not iput inode under running transaction in ext4_rename()
Date:   Thu, 25 Mar 2021 07:26:50 -0400
Message-Id: <20210325112651.1927828-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

[ Upstream commit 5dccdc5a1916d4266edd251f20bbbb113a5c495f ]

In ext4_rename(), when RENAME_WHITEOUT failed to add new entry into
directory, it ends up dropping new created whiteout inode under the
running transaction. After commit <9b88f9fb0d2> ("ext4: Do not iput inode
under running transaction"), we follow the assumptions that evict() does
not get called from a transaction context but in ext4_rename() it breaks
this suggestion. Although it's not a real problem, better to obey it, so
this patch add inode to orphan list and stop transaction before final
iput().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210303131703.330415-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7f22487d502b..c6963597975a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3706,14 +3706,14 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	retval = -ENOENT;
 	if (!old.bh || le32_to_cpu(old.de->inode) != old.inode->i_ino)
-		goto end_rename;
+		goto release_bh;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
-		goto end_rename;
+		goto release_bh;
 	}
 	if (new.bh) {
 		if (!new.inode) {
@@ -3730,15 +3730,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
 		if (IS_ERR(handle)) {
 			retval = PTR_ERR(handle);
-			handle = NULL;
-			goto end_rename;
+			goto release_bh;
 		}
 	} else {
 		whiteout = ext4_whiteout_for_rename(&old, credits, &handle);
 		if (IS_ERR(whiteout)) {
 			retval = PTR_ERR(whiteout);
-			whiteout = NULL;
-			goto end_rename;
+			goto release_bh;
 		}
 	}
 
@@ -3846,16 +3844,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			ext4_setent(handle, &old,
 				old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
+			ext4_orphan_add(handle, whiteout);
 		}
 		unlock_new_inode(whiteout);
+		ext4_journal_stop(handle);
 		iput(whiteout);
-
+	} else {
+		ext4_journal_stop(handle);
 	}
+release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
-	if (handle)
-		ext4_journal_stop(handle);
 	return retval;
 }
 
-- 
2.30.1

