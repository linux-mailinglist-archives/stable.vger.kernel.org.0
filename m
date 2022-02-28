Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443EE4C7703
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbiB1SLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiB1SJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C160055;
        Mon, 28 Feb 2022 09:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E196090B;
        Mon, 28 Feb 2022 17:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EAC340E7;
        Mon, 28 Feb 2022 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070552;
        bh=w+wBhdcNP3+fOBzCJ3poBi1CaOnAg9LGPZ5xkmvD6GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIO1vGn7m++zSLrrazX17x6ReCvpXXIadoq/VGMvvo+1gssMkxqYP1EWHaj09A+8W
         WWk52NHk4cL38bpbpv6A2BnQjq4fR1c83FdRqe2rZx4OpYxpaBJ+N+4bRFOs1ukM2K
         XiAZ0O43RqdWOjlvTrUNF9E/AKq4qvLpmYBZX+fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 143/164] btrfs: autodefrag: only scan one inode once
Date:   Mon, 28 Feb 2022 18:25:05 +0100
Message-Id: <20220228172412.874615154@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 26fbac2517fcad34fa3f950151fd4c0240fb2935 upstream.

Although we have btrfs_requeue_inode_defrag(), for autodefrag we are
still just exhausting all inode_defrag items in the tree.

This means, it doesn't make much difference to requeue an inode_defrag,
other than scan the inode from the beginning till its end.

Change the behaviour to always scan from offset 0 of an inode, and till
the end.

By this we get the following benefit:

- Straight-forward code

- No more re-queue related check

- Fewer members in inode_defrag

We still keep the same btrfs_get_fs_root() and btrfs_iget() check for
each loop, and added extra should_auto_defrag() check per-loop.

Note: the patch needs to be backported and is intentionally written
to minimize the diff size, code will be cleaned up later.

CC: stable@vger.kernel.org # 5.16
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   84 ++++++++++++++------------------------------------------
 1 file changed, 22 insertions(+), 62 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -49,12 +49,6 @@ struct inode_defrag {
 
 	/* root objectid */
 	u64 root;
-
-	/* last offset we were able to defrag */
-	u64 last_offset;
-
-	/* if we've wrapped around back to zero once already */
-	int cycled;
 };
 
 static int __compare_inode_defrag(struct inode_defrag *defrag1,
@@ -107,8 +101,6 @@ static int __btrfs_add_inode_defrag(stru
 			 */
 			if (defrag->transid < entry->transid)
 				entry->transid = defrag->transid;
-			if (defrag->last_offset > entry->last_offset)
-				entry->last_offset = defrag->last_offset;
 			return -EEXIST;
 		}
 	}
@@ -179,34 +171,6 @@ int btrfs_add_inode_defrag(struct btrfs_
 }
 
 /*
- * Requeue the defrag object. If there is a defrag object that points to
- * the same inode in the tree, we will merge them together (by
- * __btrfs_add_inode_defrag()) and free the one that we want to requeue.
- */
-static void btrfs_requeue_inode_defrag(struct btrfs_inode *inode,
-				       struct inode_defrag *defrag)
-{
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	int ret;
-
-	if (!__need_auto_defrag(fs_info))
-		goto out;
-
-	/*
-	 * Here we don't check the IN_DEFRAG flag, because we need merge
-	 * them together.
-	 */
-	spin_lock(&fs_info->defrag_inodes_lock);
-	ret = __btrfs_add_inode_defrag(inode, defrag);
-	spin_unlock(&fs_info->defrag_inodes_lock);
-	if (ret)
-		goto out;
-	return;
-out:
-	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-}
-
-/*
  * pick the defragable inode that we want, if it doesn't exist, we will get
  * the next one.
  */
@@ -278,8 +242,14 @@ static int __btrfs_run_defrag_inode(stru
 	struct btrfs_root *inode_root;
 	struct inode *inode;
 	struct btrfs_ioctl_defrag_range_args range;
-	int num_defrag;
-	int ret;
+	int ret = 0;
+	u64 cur = 0;
+
+again:
+	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+		goto cleanup;
+	if (!__need_auto_defrag(fs_info))
+		goto cleanup;
 
 	/* get the inode */
 	inode_root = btrfs_get_fs_root(fs_info, defrag->root, true);
@@ -295,39 +265,29 @@ static int __btrfs_run_defrag_inode(stru
 		goto cleanup;
 	}
 
+	if (cur >= i_size_read(inode)) {
+		iput(inode);
+		goto cleanup;
+	}
+
 	/* do a chunk of defrag */
 	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
 	memset(&range, 0, sizeof(range));
 	range.len = (u64)-1;
-	range.start = defrag->last_offset;
+	range.start = cur;
 
 	sb_start_write(fs_info->sb);
-	num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
+	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
 				       BTRFS_DEFRAG_BATCH);
 	sb_end_write(fs_info->sb);
-	/*
-	 * if we filled the whole defrag batch, there
-	 * must be more work to do.  Queue this defrag
-	 * again
-	 */
-	if (num_defrag == BTRFS_DEFRAG_BATCH) {
-		defrag->last_offset = range.start;
-		btrfs_requeue_inode_defrag(BTRFS_I(inode), defrag);
-	} else if (defrag->last_offset && !defrag->cycled) {
-		/*
-		 * we didn't fill our defrag batch, but
-		 * we didn't start at zero.  Make sure we loop
-		 * around to the start of the file.
-		 */
-		defrag->last_offset = 0;
-		defrag->cycled = 1;
-		btrfs_requeue_inode_defrag(BTRFS_I(inode), defrag);
-	} else {
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	}
-
 	iput(inode);
-	return 0;
+
+	if (ret < 0)
+		goto cleanup;
+
+	cur = max(cur + fs_info->sectorsize, range.start);
+	goto again;
+
 cleanup:
 	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 	return ret;


