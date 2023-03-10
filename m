Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684FF6B4A93
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbjCJPYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjCJPYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:24:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B8117217
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D07461A70
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AC2C433D2;
        Fri, 10 Mar 2023 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461205;
        bh=NqIIifxAf9MPdBssd8YyP36IWKJs4bDpfwrPhtuRaNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgUHAOo0oTsBXt2S2XXayuYF+cZzQxmz9h3CL7ohCcC10zapKjHlMHBTJvKZ7aRLA
         BWOFz+DFrL+7khy9IMsWn+4oQqqH2W13fT3zg8Pty6s1GG1/DIhYItV0oQy4Ye0Lf5
         DBpEu/4ktkU6TYM/SwFXJ/F0CGYXm8x1j/GytRx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/136] ext4: use ext4_fc_tl_mem in fast-commit replay path
Date:   Fri, 10 Mar 2023 14:42:32 +0100
Message-Id: <20230310133707.908557585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index a8d0a8081a1da..2660c34c770e3 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1282,8 +1282,14 @@ struct dentry_info_args {
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
 
@@ -1295,16 +1301,18 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
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
@@ -1401,8 +1409,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 }
 
 /* Link replay function */
-static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
-			       u8 *val)
+static int ext4_fc_replay_link(struct super_block *sb,
+			       struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct dentry_info_args darg;
@@ -1456,8 +1464,8 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
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
@@ -1557,8 +1565,8 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
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
@@ -1657,7 +1665,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 
 /* Replay add range tag */
 static int ext4_fc_replay_add_range(struct super_block *sb,
-				    struct ext4_fc_tl *tl, u8 *val)
+				    struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_add_range fc_add_ex;
 	struct ext4_extent newex, *ex;
@@ -1778,8 +1786,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 /* Replay DEL_RANGE tag */
 static int
-ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
-			 u8 *val)
+ext4_fc_replay_del_range(struct super_block *sb,
+			 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct ext4_fc_del_range lrange;
@@ -1972,7 +1980,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	struct ext4_fc_replay_state *state;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_add_range ext;
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	struct ext4_fc_tail tail;
 	__u8 *start, *end, *cur, *val;
 	struct ext4_fc_head head;
@@ -2091,7 +2099,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
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



