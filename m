Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F90C5FFF86
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJPNWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJPNWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8084932DA1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C50C60B7A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1A7C433D6;
        Sun, 16 Oct 2022 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665926540;
        bh=KnWn+ewqGL9IZV8t52hWiyP45CeX8AyNX2Hd18kJaEg=;
        h=Subject:To:Cc:From:Date:From;
        b=2jROz6es7TAm/2dCTttgQalyCewb3KyQYITi5dpU9ECPCbV+GLVqgReXdd972g4rH
         lT9pIBBhgOpaQ9o0AEU5eKi1Ln1UW72IaKy5ZfxydxtpJt4TuOrx45QKcWFIkyKjh1
         /zFrlQpcFidMe+oLNKobN6NwKoVWIzsk34AVN/N8=
Subject: FAILED: patch "[PATCH] ext4: fix potential out of bound read in" failed to apply to 6.0-stable tree
To:     yebin10@huawei.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:23:06 +0200
Message-ID: <1665926586240239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1b45cc5c7b92 ("ext4: fix potential out of bound read in ext4_fc_replay_scan()")
dcc5827484d6 ("ext4: factor out ext4_fc_get_tl()")
fdc2a3c75dd8 ("ext4: introduce EXT4_FC_TAG_BASE_LEN helper")
ccbf8eeb39f2 ("ext4: fix miss release buffer head in ext4_fc_write_inode")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1b45cc5c7b920fd8bf72e5a888ec7abeadf41e09 Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Sat, 24 Sep 2022 15:52:33 +0800
Subject: [PATCH] ext4: fix potential out of bound read in
 ext4_fc_replay_scan()

For scan loop must ensure that at least EXT4_FC_TAG_BASE_LEN space. If remain
space less than EXT4_FC_TAG_BASE_LEN which will lead to out of bound read
when mounting corrupt file system image.
ADD_RANGE/HEAD/TAIL is needed to add extra check when do journal scan, as this
three tags will read data during scan, tag length couldn't less than data length
which will read.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220924075233.2315259-4-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 54622005a0c8..ef05bfa87798 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1976,6 +1976,34 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
 }
 
+static inline bool ext4_fc_tag_len_isvalid(struct ext4_fc_tl *tl,
+					   u8 *val, u8 *end)
+{
+	if (val + tl->fc_len > end)
+		return false;
+
+	/* Here only check ADD_RANGE/TAIL/HEAD which will read data when do
+	 * journal rescan before do CRC check. Other tags length check will
+	 * rely on CRC check.
+	 */
+	switch (tl->fc_tag) {
+	case EXT4_FC_TAG_ADD_RANGE:
+		return (sizeof(struct ext4_fc_add_range) == tl->fc_len);
+	case EXT4_FC_TAG_TAIL:
+		return (sizeof(struct ext4_fc_tail) <= tl->fc_len);
+	case EXT4_FC_TAG_HEAD:
+		return (sizeof(struct ext4_fc_head) == tl->fc_len);
+	case EXT4_FC_TAG_DEL_RANGE:
+	case EXT4_FC_TAG_LINK:
+	case EXT4_FC_TAG_UNLINK:
+	case EXT4_FC_TAG_CREAT:
+	case EXT4_FC_TAG_INODE:
+	case EXT4_FC_TAG_PAD:
+	default:
+		return true;
+	}
+}
+
 /*
  * Recovery Scan phase handler
  *
@@ -2032,10 +2060,15 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end;
+	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
+		if (!ext4_fc_tag_len_isvalid(&tl, val, end)) {
+			ret = state->fc_replay_num_tags ?
+				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			goto out_err;
+		}
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
 			   tag2str(tl.fc_tag), bh->b_blocknr);
 		switch (tl.fc_tag) {
@@ -2146,7 +2179,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 	start = (u8 *)bh->b_data;
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
-	for (cur = start; cur < end;
+	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
@@ -2156,6 +2189,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
+
 		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
 		switch (tl.fc_tag) {

