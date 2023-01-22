Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CC7676D00
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 13:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjAVMya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 07:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjAVMy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 07:54:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46BC1E2B0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 04:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4165F60BF0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56927C433EF;
        Sun, 22 Jan 2023 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674392067;
        bh=6lJNdZ44AtZzAqKMNLlChbmckeE+97pC6Q67TwUHbp8=;
        h=Subject:To:Cc:From:Date:From;
        b=omSnBJreMn0IZRfQ1dLYXpnMJ0BHqMTvVJedHLeEoZ4eH9cErjwWMZbwd7rz/tjbV
         AZOxEnmxpF802PWdxp8rEpJS6t9Puk3k6d7Jo9VUuuUE8aGTRUdeNnJUHMuVsexrCY
         j5TorsHJjBQaDMhLHPTFZG0zpbV/rqqStQZrosqk=
Subject: FAILED: patch "[PATCH] btrfs: fix missing error handling when logging directory" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, admin@prnet.org, dsterba@suse.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 13:54:22 +0100
Message-ID: <1674392062163189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6d3d970b2735 ("btrfs: fix missing error handling when logging directory items")
732d591a5d6c ("btrfs: stop copying old dir items when logging a directory")
a450a4af7433 ("btrfs: don't log unnecessary boundary keys when logging directory")
339d03542484 ("btrfs: only copy dir index keys when logging a directory")
1b2e5e5c7fea ("btrfs: fix missing last dir item offset update when logging directory")
9798ba24cb76 ("btrfs: remove root argument from drop_one_dir_item()")
dc2872247ec0 ("btrfs: keep track of the last logged keys when logging a directory")
086dcbfa50d3 ("btrfs: insert items in batches when logging a directory when possible")
eb10d85ee77f ("btrfs: factor out the copying loop of dir items from log_dir_items()")
90d04510a774 ("btrfs: remove root argument from btrfs_log_inode() and its callees")
289cffcb0399 ("btrfs: remove no longer needed checks for NULL log context")
cfd312695b71 ("btrfs: check for error when looking up inode during dir entry replay")
8dcbc26194eb ("btrfs: unify lookup return value when dir entry is missing")
52db77791fe2 ("btrfs: deal with errors when adding inode reference during log replay")
e15ac6413745 ("btrfs: deal with errors when replaying dir entry during log replay")
77a5b9e3d14c ("btrfs: deal with errors when checking if a dir entry exists during log replay")
a7d1c5dc8632 ("btrfs: introduce btrfs_lookup_match_dir")
b590b839720c ("btrfs: avoid unnecessary logging of xattrs during fast fsyncs")
54a40fc3a1da ("btrfs: fix removed dentries still existing after log is synced")
64d6b281ba4d ("btrfs: remove unnecessary check_parent_dirs_for_sync()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d3d970b2735b967650d319be27268fedc5598d1 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 10 Jan 2023 14:56:34 +0000
Subject: [PATCH] btrfs: fix missing error handling when logging directory
 items

When logging a directory, at log_dir_items(), if we get an error when
attempting to search the subvolume tree for a dir index item, we end up
returning 0 (success) from log_dir_items() because 'err' is left with a
value of 0.

This can lead to a few problems, specially in the case the variable
'last_offset' has a value of (u64)-1 (and it's initialized to that when
it was declared):

1) By returning from log_dir_items() with success (0) and a value of
   (u64)-1 for '*last_offset_ret', we end up not logging any other dir
   index keys that follow the missing, just deleted, index key. The
   (u64)-1 value makes log_directory_changes() not call log_dir_items()
   again;

2) Before returning with success (0), log_dir_items(), will log a dir
   index range item covering a range from the last old dentry index
   (stored in the variable 'last_old_dentry_offset') to the value of
   'last_offset'. If 'last_offset' has a value of (u64)-1, then it means
   if the log is persisted and replayed after a power failure, it will
   cause deletion of all the directory entries that have an index number
   between last_old_dentry_offset + 1 and (u64)-1;

3) We can end up returning from log_dir_items() with
   ctx->last_dir_item_offset having a lower value than
   inode->last_dir_index_offset, because the former is set to the current
   key we are processing at process_dir_items_leaf(), and at the end of
   log_directory_changes() we set inode->last_dir_index_offset to the
   current value of ctx->last_dir_item_offset. So if for example a
   deletion of a lower dir index key happened, we set
   ctx->last_dir_item_offset to that index value, then if we return from
   log_dir_items() because btrfs_search_slot() returned an error, we end up
   returning without any error from log_dir_items() and then
   log_directory_changes() sets inode->last_dir_index_offset to a lower
   value than it had before.
   This can result in unpredictable and unexpected behaviour when we
   need to log again the directory in the same transaction, and can result
   in ending up with a log tree leaf that has duplicated keys, as we do
   batch insertions of dir index keys into a log tree.

Fix this by setting 'err' to the value of 'ret' in case
btrfs_search_slot() or btrfs_previous_item() returned an error. That will
result in falling back to a full transaction commit.

Reported-by: David Arendt <admin@prnet.org>
Link: https://lore.kernel.org/linux-btrfs/ae169fc6-f504-28f0-a098-6fa6a4dfb612@leemhuis.info/
Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fb52aa060093..3ef0266e9527 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3826,7 +3826,10 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 					      path->slots[0]);
 			if (tmp.type == BTRFS_DIR_INDEX_KEY)
 				last_old_dentry_offset = tmp.offset;
+		} else if (ret < 0) {
+			err = ret;
 		}
+
 		goto done;
 	}
 
@@ -3846,7 +3849,11 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 		 */
 		if (tmp.type == BTRFS_DIR_INDEX_KEY)
 			last_old_dentry_offset = tmp.offset;
+	} else if (ret < 0) {
+		err = ret;
+		goto done;
 	}
+
 	btrfs_release_path(path);
 
 	/*
@@ -3859,6 +3866,8 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	 */
 search:
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
+	if (ret < 0)
+		err = ret;
 	if (ret != 0)
 		goto done;
 

