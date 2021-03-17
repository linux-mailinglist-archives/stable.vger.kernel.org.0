Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE733F5CE
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhCQQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:44:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:32910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232008AbhCQQoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:44:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 45990AD74;
        Wed, 17 Mar 2021 16:44:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ED75F1F2BA7; Wed, 17 Mar 2021 17:44:18 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH stable 4.14.y 2/3] ext4: don't allow overlapping system zones
Date:   Wed, 17 Mar 2021 17:44:13 +0100
Message-Id: <20210317164414.17364-3-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317164414.17364-1-jack@suse.cz>
References: <20210317164414.17364-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bf9a379d0980e7413d94cb18dac73db2bfc5f470 upstream.

Currently, add_system_zone() just silently merges two added system zones
that overlap. However the overlap should not happen and it generally
suggests that some unrelated metadata overlap which indicates the fs is
corrupted. We should have caught such problems earlier (e.g. in
ext4_check_descriptors()) but add this check as another line of defense.
In later patch we also use this for stricter checking of journal inode
extent tree.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/block_validity.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 3cbee832e796..dc2e3504bb06 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -58,7 +58,7 @@ static int add_system_zone(struct ext4_sb_info *sbi,
 			   ext4_fsblk_t start_blk,
 			   unsigned int count)
 {
-	struct ext4_system_zone *new_entry = NULL, *entry;
+	struct ext4_system_zone *new_entry, *entry;
 	struct rb_node **n = &sbi->system_blks.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node = NULL;
 
@@ -69,30 +69,20 @@ static int add_system_zone(struct ext4_sb_info *sbi,
 			n = &(*n)->rb_left;
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
-		else {
-			if (start_blk + count > (entry->start_blk +
-						 entry->count))
-				entry->count = (start_blk + count -
-						entry->start_blk);
-			new_node = *n;
-			new_entry = rb_entry(new_node, struct ext4_system_zone,
-					     node);
-			break;
-		}
+		else	/* Unexpected overlap of system zones. */
+			return -EFSCORRUPTED;
 	}
 
-	if (!new_entry) {
-		new_entry = kmem_cache_alloc(ext4_system_zone_cachep,
-					     GFP_KERNEL);
-		if (!new_entry)
-			return -ENOMEM;
-		new_entry->start_blk = start_blk;
-		new_entry->count = count;
-		new_node = &new_entry->node;
+	new_entry = kmem_cache_alloc(ext4_system_zone_cachep,
+				     GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
+	new_entry->start_blk = start_blk;
+	new_entry->count = count;
+	new_node = &new_entry->node;
 
-		rb_link_node(new_node, parent, n);
-		rb_insert_color(new_node, &sbi->system_blks);
-	}
+	rb_link_node(new_node, parent, n);
+	rb_insert_color(new_node, &sbi->system_blks);
 
 	/* Can we merge to the left? */
 	node = rb_prev(new_node);
-- 
2.26.2

