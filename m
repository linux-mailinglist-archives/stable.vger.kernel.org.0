Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DC86AF160
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCGSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjCGSmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37EE196A6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 561B06153B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C27C433EF;
        Tue,  7 Mar 2023 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213974;
        bh=ADptdmh2tNWasfKW0aQORL4yIY4ow1X2A90pLbQUuE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK/KkSP7pNJJe5fQ2ZZ3c5CbqJNOKTF7jpTbizpJ7UDIUz65q8+0LtCWYtLZiYnhf
         NCKeunEPXlOL742fvFevT2ZFrRd+oGenKTsL65FAaaxlu7BYV3R/X1EVUNrpMMS/sM
         ygRIjKCWo+pSIIh+on2ZBs+ZC+HZBZL76e2NK1qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 681/885] btrfs: hold block group refcount during async discard
Date:   Tue,  7 Mar 2023 18:00:15 +0100
Message-Id: <20230307170031.706754885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit 2b5463fcbdfb24e898916bcae2b1359042d26963 upstream.

Async discard does not acquire the block group reference count while it
holds a reference on the discard list. This is generally OK, as the
paths which destroy block groups tend to try to synchronize on
cancelling async discard work. However, relying on cancelling work
requires careful analysis to be sure it is safe from races with
unpinning scheduling more work.

While I am unable to find a race with unpinning in the current code for
either the unused bgs or relocation paths, I believe we have one in an
older version of auto relocation in a Meta internal build. This suggests
that this is in fact an error prone model, and could be fragile to
future changes to these bg deletion paths.

To make this ownership more clear, add a refcount for async discard. If
work is queued for a block group, its refcount should be incremented,
and when work is completed or canceled, it should be decremented.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/discard.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -77,6 +77,7 @@ static struct list_head *get_discard_lis
 static void __add_to_discard_list(struct btrfs_discard_ctl *discard_ctl,
 				  struct btrfs_block_group *block_group)
 {
+	lockdep_assert_held(&discard_ctl->lock);
 	if (!btrfs_run_discard_work(discard_ctl))
 		return;
 
@@ -88,6 +89,8 @@ static void __add_to_discard_list(struct
 						      BTRFS_DISCARD_DELAY);
 		block_group->discard_state = BTRFS_DISCARD_RESET_CURSOR;
 	}
+	if (list_empty(&block_group->discard_list))
+		btrfs_get_block_group(block_group);
 
 	list_move_tail(&block_group->discard_list,
 		       get_discard_list(discard_ctl, block_group));
@@ -107,8 +110,12 @@ static void add_to_discard_list(struct b
 static void add_to_discard_unused_list(struct btrfs_discard_ctl *discard_ctl,
 				       struct btrfs_block_group *block_group)
 {
+	bool queued;
+
 	spin_lock(&discard_ctl->lock);
 
+	queued = !list_empty(&block_group->discard_list);
+
 	if (!btrfs_run_discard_work(discard_ctl)) {
 		spin_unlock(&discard_ctl->lock);
 		return;
@@ -120,6 +127,8 @@ static void add_to_discard_unused_list(s
 	block_group->discard_eligible_time = (ktime_get_ns() +
 					      BTRFS_DISCARD_UNUSED_DELAY);
 	block_group->discard_state = BTRFS_DISCARD_RESET_CURSOR;
+	if (!queued)
+		btrfs_get_block_group(block_group);
 	list_add_tail(&block_group->discard_list,
 		      &discard_ctl->discard_list[BTRFS_DISCARD_INDEX_UNUSED]);
 
@@ -130,6 +139,7 @@ static bool remove_from_discard_list(str
 				     struct btrfs_block_group *block_group)
 {
 	bool running = false;
+	bool queued = false;
 
 	spin_lock(&discard_ctl->lock);
 
@@ -139,7 +149,16 @@ static bool remove_from_discard_list(str
 	}
 
 	block_group->discard_eligible_time = 0;
+	queued = !list_empty(&block_group->discard_list);
 	list_del_init(&block_group->discard_list);
+	/*
+	 * If the block group is currently running in the discard workfn, we
+	 * don't want to deref it, since it's still being used by the workfn.
+	 * The workfn will notice this case and deref the block group when it is
+	 * finished.
+	 */
+	if (queued && !running)
+		btrfs_put_block_group(block_group);
 
 	spin_unlock(&discard_ctl->lock);
 
@@ -212,10 +231,12 @@ again:
 	if (block_group && now >= block_group->discard_eligible_time) {
 		if (block_group->discard_index == BTRFS_DISCARD_INDEX_UNUSED &&
 		    block_group->used != 0) {
-			if (btrfs_is_block_group_data_only(block_group))
+			if (btrfs_is_block_group_data_only(block_group)) {
 				__add_to_discard_list(discard_ctl, block_group);
-			else
+			} else {
 				list_del_init(&block_group->discard_list);
+				btrfs_put_block_group(block_group);
+			}
 			goto again;
 		}
 		if (block_group->discard_state == BTRFS_DISCARD_RESET_CURSOR) {
@@ -502,6 +523,15 @@ static void btrfs_discard_workfn(struct
 	spin_lock(&discard_ctl->lock);
 	discard_ctl->prev_discard = trimmed;
 	discard_ctl->prev_discard_time = now;
+	/*
+	 * If the block group was removed from the discard list while it was
+	 * running in this workfn, then we didn't deref it, since this function
+	 * still owned that reference. But we set the discard_ctl->block_group
+	 * back to NULL, so we can use that condition to know that now we need
+	 * to deref the block_group.
+	 */
+	if (discard_ctl->block_group == NULL)
+		btrfs_put_block_group(block_group);
 	discard_ctl->block_group = NULL;
 	__btrfs_discard_schedule_work(discard_ctl, now, false);
 	spin_unlock(&discard_ctl->lock);
@@ -638,8 +668,12 @@ void btrfs_discard_punt_unused_bgs_list(
 	list_for_each_entry_safe(block_group, next, &fs_info->unused_bgs,
 				 bg_list) {
 		list_del_init(&block_group->bg_list);
-		btrfs_put_block_group(block_group);
 		btrfs_discard_queue_work(&fs_info->discard_ctl, block_group);
+		/*
+		 * This put is for the get done by btrfs_mark_bg_unused.
+		 * Queueing discard incremented it for discard's reference.
+		 */
+		btrfs_put_block_group(block_group);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 }
@@ -669,6 +703,7 @@ static void btrfs_discard_purge_list(str
 			if (block_group->used == 0)
 				btrfs_mark_bg_unused(block_group);
 			spin_lock(&discard_ctl->lock);
+			btrfs_put_block_group(block_group);
 		}
 	}
 	spin_unlock(&discard_ctl->lock);


