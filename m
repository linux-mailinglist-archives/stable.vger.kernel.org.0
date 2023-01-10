Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78210664AD5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbjAJSga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbjAJSfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EEB58804
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C745D61846
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D7C433D2;
        Tue, 10 Jan 2023 18:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375480;
        bh=7SpcSdzupjlMER5OEfkLC9wDYdoAG8sN2rTwJtpmpZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohzzaCEQFEQ1DR9wCZKm0N1NgKI8Ve0TCqMzWLH7J6gl88Bnvs0PXrgFRMoGe8LVc
         AzL31/jhbfH7B3pa9ycCEk47NcOJL5Mu5FWnj6a6+3nOrOK8UirG16xHenade3eYZn
         kIqb8bGocYm1ZteVWofeDL1shqcGuOiMk+zWwFWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 171/290] ext4: fix potential out of bound read in ext4_fc_replay_scan()
Date:   Tue, 10 Jan 2023 19:04:23 +0100
Message-Id: <20230110180037.813163503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>

From: Ye Bin <yebin10@huawei.com>

commit 1b45cc5c7b920fd8bf72e5a888ec7abeadf41e09 upstream.

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1907,6 +1907,34 @@ void ext4_fc_replay_cleanup(struct super
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
@@ -1963,10 +1991,15 @@ static int ext4_fc_replay_scan(journal_t
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
@@ -2077,7 +2110,7 @@ static int ext4_fc_replay(journal_t *jou
 	start = (u8 *)bh->b_data;
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
-	for (cur = start; cur < end;
+	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
@@ -2087,6 +2120,7 @@ static int ext4_fc_replay(journal_t *jou
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
+
 		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
 		switch (tl.fc_tag) {


