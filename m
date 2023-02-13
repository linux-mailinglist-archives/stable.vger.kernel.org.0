Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0487C694925
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjBMO4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBMO4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392461C7F1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5CD9B8125D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C58C4339B;
        Mon, 13 Feb 2023 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300150;
        bh=1FdSGSad1HsC61HVFTHlqeSL5QRO8cNjPmySxpKPmOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ej4l4FY2zrG6hR5r6vL3eLZnNQqxJoBNrB/S804G+dUgndQeLwnWNx1GqHLLIZxqJ
         IrXnxKetTAeIR3TABg1ywEXkjW0XrvcGKN5uSx/XJ4gVZkvCju/2qOc7sHx5eoF55U
         XxRXYQR9NH5k7hJh+TgN+3E+F9VIPVrqv2hpFfTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Arendt <admin@prnet.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Hunter Wardlaw <wardlawhunter@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 083/114] btrfs: simplify update of last_dir_index_offset when logging a directory
Date:   Mon, 13 Feb 2023 15:48:38 +0100
Message-Id: <20230213144746.450414739@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 6afaed53cc9adde69d8a76ff5b4d740d5efbc54c upstream.

When logging a directory, we always set the inode's last_dir_index_offset
to the offset of the last dir index item we found. This is using an extra
field in the log context structure, and it makes more sense to update it
only after we insert dir index items, and we could directly update the
inode's last_dir_index_offset field instead.

So make this simpler by updating the inode's last_dir_index_offset only
when we actually insert dir index keys in the log tree, and getting rid
of the last_dir_item_offset field in the log context structure.

Reported-by: David Arendt <admin@prnet.org>
Link: https://lore.kernel.org/linux-btrfs/ae169fc6-f504-28f0-a098-6fa6a4dfb612@leemhuis.info/
Reported-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/Y8voyTXdnPDz8xwY@mail.gmail.com/
Reported-by: Hunter Wardlaw <wardlawhunter@gmail.com>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1207231
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216851
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   23 +++++++++++++++++------
 fs/btrfs/tree-log.h |    2 --
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3607,17 +3607,19 @@ static noinline int insert_dir_log_key(s
 }
 
 static int flush_dir_items_batch(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *log,
+				 struct btrfs_inode *inode,
 				 struct extent_buffer *src,
 				 struct btrfs_path *dst_path,
 				 int start_slot,
 				 int count)
 {
+	struct btrfs_root *log = inode->root->log_root;
 	char *ins_data = NULL;
 	struct btrfs_item_batch batch;
 	struct extent_buffer *dst;
 	unsigned long src_offset;
 	unsigned long dst_offset;
+	u64 last_index;
 	struct btrfs_key key;
 	u32 item_size;
 	int ret;
@@ -3675,6 +3677,19 @@ static int flush_dir_items_batch(struct
 	src_offset = btrfs_item_ptr_offset(src, start_slot + count - 1);
 	copy_extent_buffer(dst, src, dst_offset, src_offset, batch.total_data_size);
 	btrfs_release_path(dst_path);
+
+	last_index = batch.keys[count - 1].offset;
+	ASSERT(last_index > inode->last_dir_index_offset);
+
+	/*
+	 * If for some unexpected reason the last item's index is not greater
+	 * than the last index we logged, warn and return an error to fallback
+	 * to a transaction commit.
+	 */
+	if (WARN_ON(last_index <= inode->last_dir_index_offset))
+		ret = -EUCLEAN;
+	else
+		inode->last_dir_index_offset = last_index;
 out:
 	kfree(ins_data);
 
@@ -3724,7 +3739,6 @@ static int process_dir_items_leaf(struct
 		}
 
 		di = btrfs_item_ptr(src, i, struct btrfs_dir_item);
-		ctx->last_dir_item_offset = key.offset;
 
 		/*
 		 * Skip ranges of items that consist only of dir item keys created
@@ -3787,7 +3801,7 @@ static int process_dir_items_leaf(struct
 	if (batch_size > 0) {
 		int ret;
 
-		ret = flush_dir_items_batch(trans, log, src, dst_path,
+		ret = flush_dir_items_batch(trans, inode, src, dst_path,
 					    batch_start, batch_size);
 		if (ret < 0)
 			return ret;
@@ -4075,7 +4089,6 @@ static noinline int log_directory_change
 
 	min_key = BTRFS_DIR_START_INDEX;
 	max_key = 0;
-	ctx->last_dir_item_offset = inode->last_dir_index_offset;
 
 	while (1) {
 		ret = log_dir_items(trans, inode, path, dst_path,
@@ -4087,8 +4100,6 @@ static noinline int log_directory_change
 		min_key = max_key + 1;
 	}
 
-	inode->last_dir_index_offset = ctx->last_dir_item_offset;
-
 	return 0;
 }
 
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -23,8 +23,6 @@ struct btrfs_log_ctx {
 	bool logging_new_delayed_dentries;
 	/* Indicate if the inode being logged was logged before. */
 	bool logged_before;
-	/* Tracks the last logged dir item/index key offset. */
-	u64 last_dir_item_offset;
 	struct inode *inode;
 	struct list_head list;
 	/* Only used for fast fsyncs. */


