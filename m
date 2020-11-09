Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4A2AB969
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgKINJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgKINI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CCB220731;
        Mon,  9 Nov 2020 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927338;
        bh=E0iqgE0MEFo7Z3XQ5BA2SL4wpUamjmGLFFTnAn47tBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jvs6wQEAxEaVybMjMjLYOMRVEGqlWS4YTc4X9CV0stlguEwMhrumoV4s/uPP4MKcr
         rSoAnH/SzcOVNsiXa+KzKGCOIXlQElKxwt/I78/0M/5jUSPZUFYp9gy60wWu+nx8My
         Gp8atRqVQblgkjoQ42FAK429BxJP+d5VBOrF14mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 25/71] btrfs: tree-checker: Check chunk item at tree block read time
Date:   Mon,  9 Nov 2020 13:55:19 +0100
Message-Id: <20201109125021.093613113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 075cb3c78fe7976c9f29ca1fa23f9728634ecefc upstream.

Since we have btrfs_check_chunk_valid() in tree-checker, let's do
chunk item verification in tree-checker too.

Since the tree-checker is run at endio time, if one chunk leaf fails
chunk verification, we can still retry the other copy, making btrfs more
robust to fuzzed image as we may still get a good chunk item.

Also since we have done chunk verification in tree block read time, skip
the btrfs_check_chunk_valid() call in read_one_chunk() if we're reading
chunk items from leaf.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    6 ++++++
 fs/btrfs/volumes.c      |   12 +++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -608,6 +608,7 @@ static int check_leaf_item(struct btrfs_
 			   struct btrfs_key *key, int slot)
 {
 	int ret = 0;
+	struct btrfs_chunk *chunk;
 
 	switch (key->type) {
 	case BTRFS_EXTENT_DATA_KEY:
@@ -624,6 +625,11 @@ static int check_leaf_item(struct btrfs_
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
 		ret = check_block_group_item(fs_info, leaf, key, slot);
 		break;
+	case BTRFS_CHUNK_ITEM_KEY:
+		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
+					      key->offset);
+		break;
 	}
 	return ret;
 }
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6401,9 +6401,15 @@ static int read_one_chunk(struct btrfs_f
 	length = btrfs_chunk_length(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
-	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
-	if (ret)
-		return ret;
+	/*
+	 * Only need to verify chunk item if we're reading from sys chunk array,
+	 * as chunk item in tree block is already verified by tree-checker.
+	 */
+	if (leaf->start == BTRFS_SUPER_INFO_OFFSET) {
+		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
+		if (ret)
+			return ret;
+	}
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);


