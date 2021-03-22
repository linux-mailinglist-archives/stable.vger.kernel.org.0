Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01343443D6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhCVMyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbhCVMw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2796D619E2;
        Mon, 22 Mar 2021 12:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417207;
        bh=/MmVq5Ogx833lFW8IvgYNzD3k9TDCJnlbClvnqfVyXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKxE5eNpZFOgwntZEWeAa9vK2ajhceYhAlOPgtQ87B7fZVtWM0XUQe7QEZyw3HD9P
         eXAnxUw1NTCp0PvwntI82iCC/UZiUP8fCZUPIeN2a2w763c/wPB3eOx2+MzHZK5bQH
         1EcLO+hkUt6uk5bBqoqkQmiUWy9dm3Hc2j9f0Aq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 02/25] ext4: dont allow overlapping system zones
Date:   Mon, 22 Mar 2021 13:28:52 +0100
Message-Id: <20210322121920.478208447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/block_validity.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -57,7 +57,7 @@ static int add_system_zone(struct ext4_s
 			   ext4_fsblk_t start_blk,
 			   unsigned int count)
 {
-	struct ext4_system_zone *new_entry = NULL, *entry;
+	struct ext4_system_zone *new_entry, *entry;
 	struct rb_node **n = &sbi->system_blks.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node = NULL;
 
@@ -68,30 +68,20 @@ static int add_system_zone(struct ext4_s
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


