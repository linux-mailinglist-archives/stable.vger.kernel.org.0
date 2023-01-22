Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452F2676FA7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjAVPXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjAVPXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AF418B30
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D22CB80B22
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799BEC433D2;
        Sun, 22 Jan 2023 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401025;
        bh=ev9aMqDOT61nFu590PRR+YVfHb16yiagIRUV4H4gkLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJGNJ2XYGchtqJ8UTWrPmq1+tEi1EiWUaf5l7zoUYXtGhOcLJbx9TGaA5xcC9IO8y
         bUGSa/jNjjjru8SHpot+MVH0uijenL6e0H5SYgCLwR1bG4pzBbtBO+2o1ZJYnA2HVO
         7mz4IHAUNitu6RXdmmuIuZzIm5OYdT8zGY3LDx84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Arendt <admin@prnet.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 082/193] btrfs: fix missing error handling when logging directory items
Date:   Sun, 22 Jan 2023 16:03:31 +0100
Message-Id: <20230122150250.120717717@linuxfoundation.org>
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

commit 6d3d970b2735b967650d319be27268fedc5598d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3857,7 +3857,10 @@ static noinline int log_dir_items(struct
 					      path->slots[0]);
 			if (tmp.type == BTRFS_DIR_INDEX_KEY)
 				last_old_dentry_offset = tmp.offset;
+		} else if (ret < 0) {
+			err = ret;
 		}
+
 		goto done;
 	}
 
@@ -3877,7 +3880,11 @@ static noinline int log_dir_items(struct
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
@@ -3890,6 +3897,8 @@ static noinline int log_dir_items(struct
 	 */
 search:
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
+	if (ret < 0)
+		err = ret;
 	if (ret != 0)
 		goto done;
 


