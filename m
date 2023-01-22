Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2620C676D07
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjAVMzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 07:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjAVMzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 07:55:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085421E2BA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 04:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74FB4CE0EAF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60132C433EF;
        Sun, 22 Jan 2023 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674392101;
        bh=aPUDYSpkZ/hbs/mm84zUloeReO8/Qies2bYI9+Nn0qs=;
        h=Subject:To:Cc:From:Date:From;
        b=w0RU4uom1308a7KjE9tT487wbcmA3GEm0mN2UZN3gUJskI31WKUNavzswmODMOlwY
         ueuO/SqesNxP5EIGacJkIpBT5QZ+ZMGQXVwO7bqL3czZ/Kzx7aXqg08l3+TRBBBbGG
         XHOqAF3uw/cHgG4UvH8bO6eUmD/vH3jjKm7GJD8I=
Subject: FAILED: patch "[PATCH] btrfs: fix directory logging due to race with concurrent" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, admin@prnet.org, dsterba@suse.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 13:54:54 +0100
Message-ID: <1674392094224146@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8bb6898da627 ("btrfs: fix directory logging due to race with concurrent index key deletion")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8bb6898da6271d82d8e76d8088d66b971a7dcfa6 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 10 Jan 2023 14:56:35 +0000
Subject: [PATCH] btrfs: fix directory logging due to race with concurrent
 index key deletion

Sometimes we log a directory without holding its VFS lock, so while we
logging it, dir index entries may be added or removed. This typically
happens when logging a dentry from a parent directory that points to a
new directory, through log_new_dir_dentries(), or when while logging
some other inode we also need to log its parent directories (through
btrfs_log_all_parents()).

This means that while we are at log_dir_items(), we may not find a dir
index key we found before, because it was deleted in the meanwhile, so
a call to btrfs_search_slot() may return 1 (key not found). In that case
we return from log_dir_items() with a success value (the variable 'err'
has a value of 0). This can lead to a few problems, specially in the case
where the variable 'last_offset' has a value of (u64)-1 (and it's
initialized to that when it was declared):

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
   log_dir_items() because btrfs_search_slot() returned 1, we end up
   returning from log_dir_items() with success (0) and then
   log_directory_changes() sets inode->last_dir_index_offset to a lower
   value than it had before.
   This can result in unpredictable and unexpected behaviour when we
   need to log again the directory in the same transaction, and can result
   in ending up with a log tree leaf that has duplicated keys, as we do
   batch insertions of dir index keys into a log tree.

So fix this by making log_dir_items() move on to the next dir index key
if it does not find the one it was looking for.

Reported-by: David Arendt <admin@prnet.org>
Link: https://lore.kernel.org/linux-btrfs/ae169fc6-f504-28f0-a098-6fa6a4dfb612@leemhuis.info/
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3ef0266e9527..c09daab3f19e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3857,17 +3857,26 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	/*
-	 * Find the first key from this transaction again.  See the note for
-	 * log_new_dir_dentries, if we're logging a directory recursively we
-	 * won't be holding its i_mutex, which means we can modify the directory
-	 * while we're logging it.  If we remove an entry between our first
-	 * search and this search we'll not find the key again and can just
-	 * bail.
+	 * Find the first key from this transaction again or the one we were at
+	 * in the loop below in case we had to reschedule. We may be logging the
+	 * directory without holding its VFS lock, which happen when logging new
+	 * dentries (through log_new_dir_dentries()) or in some cases when we
+	 * need to log the parent directory of an inode. This means a dir index
+	 * key might be deleted from the inode's root, and therefore we may not
+	 * find it anymore. If we can't find it, just move to the next key. We
+	 * can not bail out and ignore, because if we do that we will simply
+	 * not log dir index keys that come after the one that was just deleted
+	 * and we can end up logging a dir index range that ends at (u64)-1
+	 * (@last_offset is initialized to that), resulting in removing dir
+	 * entries we should not remove at log replay time.
 	 */
 search:
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
+	if (ret > 0)
+		ret = btrfs_next_item(root, path);
 	if (ret < 0)
 		err = ret;
+	/* If ret is 1, there are no more keys in the inode's root. */
 	if (ret != 0)
 		goto done;
 

