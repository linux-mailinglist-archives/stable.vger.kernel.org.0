Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780FC6B41EE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCJN6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjCJN5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED99610F445
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E4EC616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76485C433EF;
        Fri, 10 Mar 2023 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456666;
        bh=Qdy+cCmeCbd2YllaHaQ62XSkQ8DMFxfyAL4zXmffnGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMqj/EV7AMvzE3+uJ1Jh5tNbDzbgZaMa4M5+absLgcQN3BPJIiullbsEj3Y9dEC9s
         SVTENU1hND7hXjyCT9wWIx5nn8dvsIJV1x7UtnUppSuh8VWW25hy3Nz0hnqkGeyBfv
         6ThvPe+TiLyS+sYu+xDezg9n5Kyt7YN+1j86LTi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 051/211] ext4: use ext4_fc_tl_mem in fast-commit replay path
Date:   Fri, 10 Mar 2023 14:37:11 +0100
Message-Id: <20230310133720.288156065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 11768cfd98136dd8399480c60b7a5d3d3c7b109b ]

To avoid 'sparse' warnings about missing endianness conversions, don't
store native endianness values into struct ext4_fc_tl.  Instead, use a
separate struct type, ext4_fc_tl_mem.

Fixes: dcc5827484d6 ("ext4: factor out ext4_fc_get_tl()")
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221217050212.150665-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 44 +++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 4594b62f147bb..b06de728b3b6c 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1332,8 +1332,14 @@ struct dentry_info_args {
 	char *dname;
 };
 
+/* Same as struct ext4_fc_tl, but uses native endianness fields */
+struct ext4_fc_tl_mem {
+	u16 fc_tag;
+	u16 fc_len;
+};
+
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1345,16 +1351,18 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
 	darg->dname_len = tl->fc_len - sizeof(struct ext4_fc_dentry_info);
 }
 
-static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
+static inline void ext4_fc_get_tl(struct ext4_fc_tl_mem *tl, u8 *val)
 {
-	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
-	tl->fc_len = le16_to_cpu(tl->fc_len);
-	tl->fc_tag = le16_to_cpu(tl->fc_tag);
+	struct ext4_fc_tl tl_disk;
+
+	memcpy(&tl_disk, val, EXT4_FC_TAG_BASE_LEN);
+	tl->fc_len = le16_to_cpu(tl_disk.fc_len);
+	tl->fc_tag = le16_to_cpu(tl_disk.fc_tag);
 }
 
 /* Unlink replay function */
-static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
-				 u8 *val)
+static int ext4_fc_replay_unlink(struct super_block *sb,
+				 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode, *old_parent;
 	struct qstr entry;
@@ -1451,8 +1459,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 }
 
 /* Link replay function */
-static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
-			       u8 *val)
+static int ext4_fc_replay_link(struct super_block *sb,
+			       struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct dentry_info_args darg;
@@ -1506,8 +1514,8 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
 /*
  * Inode replay function
  */
-static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
-				u8 *val)
+static int ext4_fc_replay_inode(struct super_block *sb,
+				struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_inode fc_inode;
 	struct ext4_inode *raw_inode;
@@ -1609,8 +1617,8 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
  * inode for which we are trying to create a dentry here, should already have
  * been replayed before we start here.
  */
-static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
-				 u8 *val)
+static int ext4_fc_replay_create(struct super_block *sb,
+				 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	int ret = 0;
 	struct inode *inode = NULL;
@@ -1708,7 +1716,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 
 /* Replay add range tag */
 static int ext4_fc_replay_add_range(struct super_block *sb,
-				    struct ext4_fc_tl *tl, u8 *val)
+				    struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_add_range fc_add_ex;
 	struct ext4_extent newex, *ex;
@@ -1828,8 +1836,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 /* Replay DEL_RANGE tag */
 static int
-ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
-			 u8 *val)
+ext4_fc_replay_del_range(struct super_block *sb,
+			 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct ext4_fc_del_range lrange;
@@ -2025,7 +2033,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	struct ext4_fc_replay_state *state;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_add_range ext;
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	struct ext4_fc_tail tail;
 	__u8 *start, *end, *cur, *val;
 	struct ext4_fc_head head;
@@ -2144,7 +2152,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	__u8 *start, *end, *cur, *val;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_replay_state *state = &sbi->s_fc_replay_state;
-- 
2.39.2



