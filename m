Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E60A676FAA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjAVPX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjAVPXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318D1D904
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59C4BB80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D96C433D2;
        Sun, 22 Jan 2023 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401031;
        bh=A/L8c3NAjrDYgZ00mzdIJSZ3xdVwPtzi2OIgThe9Q0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuOkA/OQMNQt4saR/dytXhrATsNESvunqI88GyXsrUQA4Qft21ZaInF9C0e0RiO0d
         9m1Ljjc1fXFCRZzX1VgMvjD4lznbavk2VMBE13MSfcMris9tRu8OQtwtFA8nmsy5uY
         xKTzFFfpimh9z3vUur2EKgnMhHGetcHmnvC7sliI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Arendt <admin@prnet.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 083/193] btrfs: fix directory logging due to race with concurrent index key deletion
Date:   Sun, 22 Jan 2023 16:03:32 +0100
Message-Id: <20230122150250.172778501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 8bb6898da6271d82d8e76d8088d66b971a7dcfa6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3888,17 +3888,26 @@ static noinline int log_dir_items(struct
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
 


