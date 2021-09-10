Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC3E4061AB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhIJAnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232683AbhIJATG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC04611BD;
        Fri, 10 Sep 2021 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233075;
        bh=Uf5Xq0+N9p2rV/3he0Qm2UGmsoheKC8oEoIj5sg78aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7vZvKR0GNB23ZGynhkDwuwA8mXEYuO/tGM5PG8vkBPbFVKAmUCS6v1A69ZTvrKEz
         69AE8LQikkh8Zm2BqQTKXSk+fvTEPk5daMB5dEJ+Qf5yqLnkSMVunJU6HCocElMusm
         Zzbpdq8KahDZOc9cpccJpkFYk7VpZlIIfXLczTLd6on6T9qdizzE/WbCTG7fa4K84A
         oek7OeGn9VJyBVSHN5LGrWbOwHCKGj7wWH61n34oaGE8o9j9Ec6UUdFRhKv3VIb1se
         rc1ePhIrne4GYY8d1egy5rznHucM+8jHwOZs9FDkD2NnDipDYwoJAOVA2dOMZFGri7
         63cBHrAH2sOhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 84/99] ext4: make the updating inode data procedure atomic
Date:   Thu,  9 Sep 2021 20:15:43 -0400
Message-Id: <20210910001558.173296-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit baaae979b112642a41b71c71c599d875c067d257 ]

Now that ext4_do_update_inode() return error before filling the whole
inode data if we fail to set inode blocks in ext4_inode_blocks_set().
This error should never happen in theory since sb->s_maxbytes should not
have allowed this, we have already init sb->s_maxbytes according to this
feature in ext4_fill_super(). So even through that could only happen due
to the filesystem corruption, we'd better to return after we finish
updating the inode because it may left an uninitialized buffer and we
could read this buffer later in "errors=continue" mode.

This patch make the updating inode data procedure atomic, call
EXT4_ERROR_INODE() after we dropping i_raw_lock after something bad
happened, make sure that the inode is integrated, and also drop a BUG_ON
and do some small cleanups.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210826130412.3921207-4-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c33c795c4a7..ca032ae25765 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4932,8 +4932,14 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
+
+	/*
+	 * This should never happen since sb->s_maxbytes should not have
+	 * allowed this, sb->s_maxbytes was set according to the huge_file
+	 * feature in ext4_fill_super().
+	 */
 	if (!ext4_has_feature_huge_file(sb))
-		return -EFBIG;
+		return -EFSCORRUPTED;
 
 	if (i_blocks <= 0xffffffffffffULL) {
 		/*
@@ -5036,16 +5042,14 @@ static int ext4_do_update_inode(handle_t *handle,
 
 	spin_lock(&ei->i_raw_lock);
 
-	/* For fields not tracked in the in-memory inode,
-	 * initialise them to zero for new inodes. */
+	/*
+	 * For fields not tracked in the in-memory inode, initialise them
+	 * to zero for new inodes.
+	 */
 	if (ext4_test_inode_state(inode, EXT4_STATE_NEW))
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
 	err = ext4_inode_blocks_set(handle, raw_inode, ei);
-	if (err) {
-		spin_unlock(&ei->i_raw_lock);
-		goto out_brelse;
-	}
 
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	i_uid = i_uid_read(inode);
@@ -5054,10 +5058,11 @@ static int ext4_do_update_inode(handle_t *handle,
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
-/*
- * Fix up interoperability with old kernels. Otherwise, old inodes get
- * re-used with the upper 16 bits of the uid/gid intact
- */
+		/*
+		 * Fix up interoperability with old kernels. Otherwise,
+		 * old inodes get re-used with the upper 16 bits of the
+		 * uid/gid intact.
+		 */
 		if (ei->i_dtime && list_empty(&ei->i_orphan)) {
 			raw_inode->i_uid_high = 0;
 			raw_inode->i_gid_high = 0;
@@ -5126,8 +5131,9 @@ static int ext4_do_update_inode(handle_t *handle,
 		}
 	}
 
-	BUG_ON(!ext4_has_feature_project(inode->i_sb) &&
-	       i_projid != EXT4_DEF_PROJID);
+	if (i_projid != EXT4_DEF_PROJID &&
+	    !ext4_has_feature_project(inode->i_sb))
+		err = err ?: -EFSCORRUPTED;
 
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
@@ -5135,6 +5141,11 @@ static int ext4_do_update_inode(handle_t *handle,
 
 	ext4_inode_csum_set(inode, raw_inode, ei);
 	spin_unlock(&ei->i_raw_lock);
+	if (err) {
+		EXT4_ERROR_INODE(inode, "corrupted inode contents");
+		goto out_brelse;
+	}
+
 	if (inode->i_sb->s_flags & SB_LAZYTIME)
 		ext4_update_other_inodes_time(inode->i_sb, inode->i_ino,
 					      bh->b_data);
@@ -5142,13 +5153,13 @@ static int ext4_do_update_inode(handle_t *handle,
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (err)
-		goto out_brelse;
+		goto out_error;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 	if (set_large_file) {
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");
 		err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
 		if (err)
-			goto out_brelse;
+			goto out_error;
 		lock_buffer(EXT4_SB(sb)->s_sbh);
 		ext4_set_feature_large_file(sb);
 		ext4_superblock_csum_set(sb);
@@ -5158,9 +5169,10 @@ static int ext4_do_update_inode(handle_t *handle,
 						 EXT4_SB(sb)->s_sbh);
 	}
 	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
+out_error:
+	ext4_std_error(inode->i_sb, err);
 out_brelse:
 	brelse(bh);
-	ext4_std_error(inode->i_sb, err);
 	return err;
 }
 
-- 
2.30.2

