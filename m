Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911B15FFF89
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJPNW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJPNWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED6832DA1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFD20B80CB9
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0660EC433C1;
        Sun, 16 Oct 2022 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665926551;
        bh=jepFBBZSz2EvkrrvNzis5ln41vsCA9A4MF+kDaWUQ5o=;
        h=Subject:To:Cc:From:Date:From;
        b=WqF+OWSZmqPLLGveG139r6axZMHcFdBzHhq7hpJKdwCt9xr7dLpsVqmAuhiRFkSdN
         9QzCqRFA3OtVKjbTXPGSUbczJq9HOn6VPmA2DyV3hVbEEypYW9l3ToTGN7ldVwR4Iq
         tdTa292Ng0YKT55GjI7K2ZiOTcfFCZC8CDNNAcbA=
Subject: FAILED: patch "[PATCH] ext4: fix potential out of bound read in" failed to apply to 5.4-stable tree
To:     yebin10@huawei.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:23:09 +0200
Message-ID: <16659265894175@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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
efc61345274d ("ext4: shrink race window in ext4_should_retry_alloc()")

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

