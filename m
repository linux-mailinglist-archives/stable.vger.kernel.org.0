Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C32111EDF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfLCXFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbfLCWuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E31C20862;
        Tue,  3 Dec 2019 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413420;
        bh=wazQLDWqdeo8o+zxRUBrSU54ctP1124qFxYkr2JL2fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlBtTSXZvsjQpCWtx69hc6TgXdSx1pPFA4sR1xZiuYbCukYaXqE3H54xVN/QzBBoo
         bEfH7I3IGHu1kQXZvHjLMKHtcFkCnpbPi/4jcbr62Q8EXpVMXPuQ9BFpkxM2vExeTL
         SH3+wGmZNk1mh/EwDklNvRrQxG1I08AkaIh673Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/321] Btrfs: allow clear_extent_dirty() to receive a cached extent state record
Date:   Tue,  3 Dec 2019 23:33:06 +0100
Message-Id: <20191203223433.399879288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0e6ec385b55f6001da8c6b1532494241e52c550d ]

We can have a lot freed extents during the life span of transaction, so
the red black tree that keeps track of the ranges of each freed extent
(fs_info->freed_extents[]) can get quite big. When finishing a
transaction commit we find each range, process it (discard the extents,
unpin them) and then remove it from the red black tree.

We can use an extent state record as a cache when searching for a range,
so that when we clean the range we can use the cached extent state we
passed to the search function instead of iterating the red black tree
again. Doing things as fast as possible when finishing a transaction (in
state TRANS_STATE_UNBLOCKED) is convenient as it reduces the time we
block another task that wants to commit the next transaction.

So change clear_extent_dirty() to allow an optional extent state record to
be passed as an argument, which will be passed down to __clear_extent_bit.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c     | 7 +++++--
 fs/btrfs/extent-tree.c | 7 +++++--
 fs/btrfs/extent_io.h   | 4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b2dc613ebed2c..96296dc7d2ea4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4350,6 +4350,8 @@ static int btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
 	unpin = pinned_extents;
 again:
 	while (1) {
+		struct extent_state *cached_state = NULL;
+
 		/*
 		 * The btrfs_finish_extent_commit() may get the same range as
 		 * ours between find_first_extent_bit and clear_extent_dirty.
@@ -4358,13 +4360,14 @@ again:
 		 */
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY, NULL);
+					    EXTENT_DIRTY, &cached_state);
 		if (ret) {
 			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			break;
 		}
 
-		clear_extent_dirty(unpin, start, end);
+		clear_extent_dirty(unpin, start, end, &cached_state);
+		free_extent_state(cached_state);
 		btrfs_error_unpin_extent_range(fs_info, start, end);
 		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 		cond_resched();
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 024dd336b20ae..4bda5c09cdfe7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6618,9 +6618,11 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 		unpin = &fs_info->freed_extents[0];
 
 	while (!trans->aborted) {
+		struct extent_state *cached_state = NULL;
+
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY, NULL);
+					    EXTENT_DIRTY, &cached_state);
 		if (ret) {
 			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			break;
@@ -6630,9 +6632,10 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 			ret = btrfs_discard_extent(fs_info, start,
 						   end + 1 - start, NULL);
 
-		clear_extent_dirty(unpin, start, end);
+		clear_extent_dirty(unpin, start, end, &cached_state);
 		unpin_extent_range(fs_info, start, end, true);
 		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
+		free_extent_state(cached_state);
 		cond_resched();
 	}
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ed27becd963c5..a3598b24441e1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -348,11 +348,11 @@ static inline int set_extent_dirty(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
-		u64 end)
+				     u64 end, struct extent_state **cached)
 {
 	return clear_extent_bit(tree, start, end,
 				EXTENT_DIRTY | EXTENT_DELALLOC |
-				EXTENT_DO_ACCOUNTING, 0, 0, NULL);
+				EXTENT_DO_ACCOUNTING, 0, 0, cached);
 }
 
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-- 
2.20.1



