Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88FB65D6CA
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbjADPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbjADPDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:03:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42DCEE30
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F8961738
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3B6C4339E;
        Wed,  4 Jan 2023 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844585;
        bh=uAE/OqFTiViwC7dwpD0gO1jwZhrOyUHBPCU9lF+kqFo=;
        h=Subject:To:Cc:From:Date:From;
        b=G5GAp3SPRuveSLUICjWliN9F6D9lIU91bQUnp11qU+xAFnsH8VWVdSQkdu02Opy2j
         yvNjP1FDT8t38g98VMPqeOx949duEsSIePVmcQE+uEwSB4lsVZYAsh3r9/sZddliZz
         MsqQk/Qv2chRYvedojJVCTaXlMoBK9t/qjbSZcoQ=
Subject: FAILED: patch "[PATCH] ext4: add missing validation of fast-commit record lengths" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:02:54 +0100
Message-ID: <16728445744528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

64b4a25c3de8 ("ext4: add missing validation of fast-commit record lengths")
1b45cc5c7b92 ("ext4: fix potential out of bound read in ext4_fc_replay_scan()")
dcc5827484d6 ("ext4: factor out ext4_fc_get_tl()")
fdc2a3c75dd8 ("ext4: introduce EXT4_FC_TAG_BASE_LEN helper")
ccbf8eeb39f2 ("ext4: fix miss release buffer head in ext4_fc_write_inode")
4978c659e7b5 ("ext4: use ext4_debug() instead of jbd_debug()")
d9bf099cb980 ("ext4: add commit_tid info in jbd debug log")
0915e464cb27 ("ext4: simplify updating of fast commit stats")
7bbbe241ec7c ("ext4: drop ineligible txn start stop APIs")
02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
25c6d98fc4c2 ("ext4: Move orphan inode handling into a separate file")
188c299e2a26 ("ext4: Support for checksumming from journal triggers")
bd2c38cf1726 ("ext4: Make sure quota files are not grabbed accidentally")
facec450a824 ("ext4: reduce arguments of ext4_fc_add_dentry_tlv")
b9a037b7f3c4 ("ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle")
a7ba36bc94f2 ("ext4: fix fast commit alignment issues")
fcdf3c34b7ab ("ext4: fix debug format string warning")
3088e5a5153c ("ext4: fix various seppling typos")
72ffb49a7b62 ("ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()")
c915fb80eaa6 ("ext4: fix bh ref count on error paths")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64b4a25c3de81a69724e888ec2db3533b43816e2 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:38 -0800
Subject: [PATCH] ext4: add missing validation of fast-commit record lengths

Validate the inode and filename lengths in fast-commit journal records
so that a malicious fast-commit journal cannot cause a crash by having
invalid values for these.  Also validate EXT4_FC_TAG_DEL_RANGE.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-5-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 1e8be0554239..d5ad4b2b235d 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1991,32 +1991,31 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
 }
 
-static inline bool ext4_fc_tag_len_isvalid(struct ext4_fc_tl *tl,
-					   u8 *val, u8 *end)
+static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
+				      int tag, int len)
 {
-	if (val + tl->fc_len > end)
-		return false;
-
-	/* Here only check ADD_RANGE/TAIL/HEAD which will read data when do
-	 * journal rescan before do CRC check. Other tags length check will
-	 * rely on CRC check.
-	 */
-	switch (tl->fc_tag) {
+	switch (tag) {
 	case EXT4_FC_TAG_ADD_RANGE:
-		return (sizeof(struct ext4_fc_add_range) == tl->fc_len);
-	case EXT4_FC_TAG_TAIL:
-		return (sizeof(struct ext4_fc_tail) <= tl->fc_len);
-	case EXT4_FC_TAG_HEAD:
-		return (sizeof(struct ext4_fc_head) == tl->fc_len);
+		return len == sizeof(struct ext4_fc_add_range);
 	case EXT4_FC_TAG_DEL_RANGE:
+		return len == sizeof(struct ext4_fc_del_range);
+	case EXT4_FC_TAG_CREAT:
 	case EXT4_FC_TAG_LINK:
 	case EXT4_FC_TAG_UNLINK:
-	case EXT4_FC_TAG_CREAT:
+		len -= sizeof(struct ext4_fc_dentry_info);
+		return len >= 1 && len <= EXT4_NAME_LEN;
 	case EXT4_FC_TAG_INODE:
+		len -= sizeof(struct ext4_fc_inode);
+		return len >= EXT4_GOOD_OLD_INODE_SIZE &&
+			len <= sbi->s_inode_size;
 	case EXT4_FC_TAG_PAD:
-	default:
-		return true;
+		return true; /* padding can have any length */
+	case EXT4_FC_TAG_TAIL:
+		return len >= sizeof(struct ext4_fc_tail);
+	case EXT4_FC_TAG_HEAD:
+		return len == sizeof(struct ext4_fc_head);
 	}
+	return false;
 }
 
 /*
@@ -2079,7 +2078,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
-		if (!ext4_fc_tag_len_isvalid(&tl, val, end)) {
+		if (tl.fc_len > end - val ||
+		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
 			ret = state->fc_replay_num_tags ?
 				JBD2_FC_REPLAY_STOP : -ECANCELED;
 			goto out_err;
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 256f2ad27204..2fadb2c4780c 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -58,7 +58,7 @@ struct ext4_fc_dentry_info {
 	__u8 fc_dname[];
 };
 
-/* Value structure for EXT4_FC_TAG_INODE and EXT4_FC_TAG_INODE_PARTIAL. */
+/* Value structure for EXT4_FC_TAG_INODE. */
 struct ext4_fc_inode {
 	__le32 fc_ino;
 	__u8 fc_raw_inode[];

