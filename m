Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C433066C477
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjAPPzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjAPPzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876CB22A00
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFD0B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AABC433F0;
        Mon, 16 Jan 2023 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884497;
        bh=yBWUZxEUKOQLK1gTS3IxwiG6EM/K5H18kRuE5kQ/9qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vti8ZJEHHWyGFR2mavYfOYYJKrHzAITBvZxbIyIY6pO5t07is+J3uXcju25dpSho0
         82zYj5UcBNNnebEwwfVSEwcw9o9sjB60ksYYzioyyoWhSMhWONfY185hg0/Txy/O+D
         trm9O9o3QGFdB5bmcyNF8irtQaMxQUCA9cRQsLgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 6.1 028/183] drm: Optimize drm buddy top-down allocation method
Date:   Mon, 16 Jan 2023 16:49:11 +0100
Message-Id: <20230116154804.560156805@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 5640e81607152d7f2d2558227c0f6cb78b8f39cf upstream.

We are observing performance drop in many usecases which include
games, 3D benchmark applications,etc.. To solve this problem, We
are strictly not allowing top down flag enabled allocations to
steal the memory space from cpu visible region.

The idea is, we are sorting each order list entries in
ascending order and compare the last entry of each order
list in the freelist and return the max block.

This patch improves the 3D benchmark scores and solves
fragmentation issues.

All drm buddy selftests are verfied.
drm_buddy: pass:6 fail:0 skip:0 total:6

Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230112120027.3072-1-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
CC: Cc: stable@vger.kernel.org # 5.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_buddy.c |   83 +++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 28 deletions(-)

--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -38,6 +38,25 @@ static void drm_block_free(struct drm_bu
 	kmem_cache_free(slab_blocks, block);
 }
 
+static void list_insert_sorted(struct drm_buddy *mm,
+			       struct drm_buddy_block *block)
+{
+	struct drm_buddy_block *node;
+	struct list_head *head;
+
+	head = &mm->free_list[drm_buddy_block_order(block)];
+	if (list_empty(head)) {
+		list_add(&block->link, head);
+		return;
+	}
+
+	list_for_each_entry(node, head, link)
+		if (drm_buddy_block_offset(block) < drm_buddy_block_offset(node))
+			break;
+
+	__list_add(&block->link, node->link.prev, &node->link);
+}
+
 static void mark_allocated(struct drm_buddy_block *block)
 {
 	block->header &= ~DRM_BUDDY_HEADER_STATE;
@@ -52,8 +71,7 @@ static void mark_free(struct drm_buddy *
 	block->header &= ~DRM_BUDDY_HEADER_STATE;
 	block->header |= DRM_BUDDY_FREE;
 
-	list_add(&block->link,
-		 &mm->free_list[drm_buddy_block_order(block)]);
+	list_insert_sorted(mm, block);
 }
 
 static void mark_split(struct drm_buddy_block *block)
@@ -387,20 +405,26 @@ err_undo:
 }
 
 static struct drm_buddy_block *
-get_maxblock(struct list_head *head)
+get_maxblock(struct drm_buddy *mm, unsigned int order)
 {
 	struct drm_buddy_block *max_block = NULL, *node;
+	unsigned int i;
 
-	max_block = list_first_entry_or_null(head,
-					     struct drm_buddy_block,
-					     link);
-	if (!max_block)
-		return NULL;
-
-	list_for_each_entry(node, head, link) {
-		if (drm_buddy_block_offset(node) >
-		    drm_buddy_block_offset(max_block))
-			max_block = node;
+	for (i = order; i <= mm->max_order; ++i) {
+		if (!list_empty(&mm->free_list[i])) {
+			node = list_last_entry(&mm->free_list[i],
+					       struct drm_buddy_block,
+					       link);
+			if (!max_block) {
+				max_block = node;
+				continue;
+			}
+
+			if (drm_buddy_block_offset(node) >
+			    drm_buddy_block_offset(max_block)) {
+				max_block = node;
+			}
+		}
 	}
 
 	return max_block;
@@ -412,20 +436,23 @@ alloc_from_freelist(struct drm_buddy *mm
 		    unsigned long flags)
 {
 	struct drm_buddy_block *block = NULL;
-	unsigned int i;
+	unsigned int tmp;
 	int err;
 
-	for (i = order; i <= mm->max_order; ++i) {
-		if (flags & DRM_BUDDY_TOPDOWN_ALLOCATION) {
-			block = get_maxblock(&mm->free_list[i]);
-			if (block)
-				break;
-		} else {
-			block = list_first_entry_or_null(&mm->free_list[i],
-							 struct drm_buddy_block,
-							 link);
-			if (block)
-				break;
+	if (flags & DRM_BUDDY_TOPDOWN_ALLOCATION) {
+		block = get_maxblock(mm, order);
+		if (block)
+			/* Store the obtained block order */
+			tmp = drm_buddy_block_order(block);
+	} else {
+		for (tmp = order; tmp <= mm->max_order; ++tmp) {
+			if (!list_empty(&mm->free_list[tmp])) {
+				block = list_last_entry(&mm->free_list[tmp],
+							struct drm_buddy_block,
+							link);
+				if (block)
+					break;
+			}
 		}
 	}
 
@@ -434,18 +461,18 @@ alloc_from_freelist(struct drm_buddy *mm
 
 	BUG_ON(!drm_buddy_block_is_free(block));
 
-	while (i != order) {
+	while (tmp != order) {
 		err = split_block(mm, block);
 		if (unlikely(err))
 			goto err_undo;
 
 		block = block->right;
-		i--;
+		tmp--;
 	}
 	return block;
 
 err_undo:
-	if (i != order)
+	if (tmp != order)
 		__drm_buddy_free(mm, block);
 	return ERR_PTR(err);
 }


