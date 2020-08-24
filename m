Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB024F4CF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgHXIlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgHXIlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:41:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEF32074D;
        Mon, 24 Aug 2020 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258479;
        bh=eA4vERAy34S0VeWfur/IzoADNGAc7BgNJIWlo12kVsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9YadaAQOJ7h3eec6SMa4J1qKpBKla3VYeMLOPLBqqcVH2EQAc4Ako5Z4N/Y/GeRK
         Ra1Cy9DXCL9gf4I1PQnwerYQl25j8XXGVWfeQsAwprHFbb4XzpIFlGQ13kZcRjh6t2
         f5jcTSs2teNBXX9s6DnuB/Wb+YQ1P3Fwz1gETK/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 061/124] ext4: dont allow overlapping system zones
Date:   Mon, 24 Aug 2020 10:29:55 +0200
Message-Id: <20200824082412.422488689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit bf9a379d0980e7413d94cb18dac73db2bfc5f470 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 16e9b2fda03ae..b394a50ebbe30 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -68,7 +68,7 @@ static int add_system_zone(struct ext4_system_blocks *system_blks,
 			   ext4_fsblk_t start_blk,
 			   unsigned int count)
 {
-	struct ext4_system_zone *new_entry = NULL, *entry;
+	struct ext4_system_zone *new_entry, *entry;
 	struct rb_node **n = &system_blks->root.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node = NULL;
 
@@ -79,30 +79,20 @@ static int add_system_zone(struct ext4_system_blocks *system_blks,
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
-
-		rb_link_node(new_node, parent, n);
-		rb_insert_color(new_node, &system_blks->root);
-	}
+	new_entry = kmem_cache_alloc(ext4_system_zone_cachep,
+				     GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
+	new_entry->start_blk = start_blk;
+	new_entry->count = count;
+	new_node = &new_entry->node;
+
+	rb_link_node(new_node, parent, n);
+	rb_insert_color(new_node, &system_blks->root);
 
 	/* Can we merge to the left? */
 	node = rb_prev(new_node);
-- 
2.25.1



