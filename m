Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0661E716
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 23:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKFWwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 17:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiKFWwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 17:52:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BADB101D2;
        Sun,  6 Nov 2022 14:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E866B80D44;
        Sun,  6 Nov 2022 22:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2410C43470;
        Sun,  6 Nov 2022 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775154;
        bh=CwmSnIVpI76sT1bVYr4KtSadFui5lOLyxo/0xcTMzvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBo4YwohcKJ5Gb6zL8JUxCqqN1OeCSUWe56m8LQPgE9nA1BwcMF2ajlxVC84lLaYN
         66KgWzMujwx08uOiOpJrgxkKW4+DnQEPDGlM4zDf6RF4kmijM4UP8ztW4d4jkxmtmy
         KFv2f0+Wtx37B3QxKBmqMvG+Rf+dJUSeI0jfh663vnyZ0TOU9gA8rXUFCcbKW0xht8
         2y06T0kVTNNbC7K8zwxIV6u+f2txcyoPdu7SGXSfBQDAc4pMnF2wA+6BT/RnQknqgk
         KcpNY7q01RqrLIgPxUblIWsv9advemqEIj2raLjOvMp2+XDeLFOMzKU/TLqFkZe9XM
         amHczqSnk0XwQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/7] ext4: add missing validation of fast-commit record lengths
Date:   Sun,  6 Nov 2022 14:48:38 -0800
Message-Id: <20221106224841.279231-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106224841.279231-1-ebiggers@kernel.org>
References: <20221106224841.279231-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Validate the inode and filename lengths in fast-commit journal records
so that a malicious fast-commit journal cannot cause a crash by having
invalid values for these.  Also validate EXT4_FC_TAG_DEL_RANGE.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 38 +++++++++++++++++++-------------------
 fs/ext4/fast_commit.h |  2 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 1e8be05542396..d5ad4b2b235d6 100644
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
index 256f2ad27204a..2fadb2c4780c8 100644
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
-- 
2.38.1

