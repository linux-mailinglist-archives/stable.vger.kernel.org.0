Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3F69CD7B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjBTNt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjBTNt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FE21E2BE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BDD460E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1E1C433EF;
        Mon, 20 Feb 2023 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900965;
        bh=aap7uhDJMSzUR4mGAwA2WUuicXuwEJLa4lPG/yARNT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5DQv381IQYtntwAeqYfpPzAALXo6FDVc0aENyD/DUbGgbhL0IhrdTzHLOBUI3vh7
         tFgl4D1h91gqhUaJqUuY7+db6tOEoINoHI0mzLJZCLVnw+TIjaYbEHynnw8edCU35c
         8pdo93cWYlExdjLEqNU8/Yrnly2j/7neLd/jxYbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 106/156] xfs: merge the ->log_item defer op into ->create_intent
Date:   Mon, 20 Feb 2023 14:35:50 +0100
Message-Id: <20230220133606.939098923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit c1f09188e8de0ae65433cb9c8ace4feb66359bcc upstream.

These are aways called together, and my merging them we reduce the amount
of indirect calls, improve type safety and in general clean up the code
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    6 +----
 fs/xfs/libxfs/xfs_defer.h  |    4 +--
 fs/xfs/xfs_bmap_item.c     |   47 +++++++++++++++++--------------------------
 fs/xfs/xfs_extfree_item.c  |   49 ++++++++++++++++++---------------------------
 fs/xfs/xfs_refcount_item.c |   48 ++++++++++++++++++--------------------------
 fs/xfs/xfs_rmap_item.c     |   48 ++++++++++++++++++--------------------------
 6 files changed, 83 insertions(+), 119 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -185,14 +185,12 @@ xfs_defer_create_intent(
 	bool				sort)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-	struct list_head		*li;
 
 	if (sort)
 		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
 
-	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
-	list_for_each(li, &dfp->dfp_work)
-		ops->log_item(tp, dfp->dfp_intent, li);
+	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+			dfp->dfp_count);
 }
 
 /*
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -50,8 +50,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
 	int (*diff_items)(void *, struct list_head *, struct list_head *);
-	void *(*create_intent)(struct xfs_trans *, uint);
-	void (*log_item)(struct xfs_trans *, void *, struct list_head *);
+	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
+			unsigned int count);
 	unsigned int		max_items;
 };
 
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -278,27 +278,6 @@ xfs_bmap_update_diff_items(
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
-/* Get an BUI. */
-STATIC void *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_bui_log_item		*buip;
-
-	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
-	ASSERT(tp != NULL);
-
-	buip = xfs_bui_init(tp->t_mountp);
-	ASSERT(buip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &buip->bui_item);
-	return buip;
-}
-
 /* Set the map extent flags for this mapping. */
 static void
 xfs_trans_set_bmap_flags(
@@ -326,16 +305,12 @@ xfs_trans_set_bmap_flags(
 STATIC void
 xfs_bmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_bui_log_item		*buip,
+	struct xfs_bmap_intent		*bmap)
 {
-	struct xfs_bui_log_item		*buip = intent;
-	struct xfs_bmap_intent		*bmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
 
@@ -355,6 +330,23 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_bmap_intent		*bmap;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+
+	xfs_trans_add_item(tp, &buip->bui_item);
+	list_for_each_entry(bmap, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bmap);
+	return buip;
+}
+
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
@@ -419,7 +411,6 @@ const struct xfs_defer_op_type xfs_bmap_
 	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
-	.log_item	= xfs_bmap_update_log_item,
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -412,41 +412,16 @@ xfs_extent_free_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
 }
 
-/* Get an EFI. */
-STATIC void *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_efi_log_item		*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, count);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
 /* Log a free extent to the intent item. */
 STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_efi_log_item		*efip,
+	struct xfs_extent_free_item	*free)
 {
-	struct xfs_efi_log_item		*efip = intent;
-	struct xfs_extent_free_item	*free;
 	uint				next_extent;
 	struct xfs_extent		*extp;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
 
@@ -462,6 +437,24 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
+STATIC void *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
+	struct xfs_extent_free_item	*free;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &efip->efi_item);
+	list_for_each_entry(free, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, free);
+	return efip;
+}
+
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
@@ -516,7 +509,6 @@ const struct xfs_defer_op_type xfs_exten
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_extent_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
@@ -582,7 +574,6 @@ const struct xfs_defer_op_type xfs_agfl_
 	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
 	.create_done	= xfs_extent_free_create_done,
 	.finish_item	= xfs_agfl_free_finish_item,
 	.cancel_item	= xfs_extent_free_cancel_item,
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -284,27 +284,6 @@ xfs_refcount_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
 }
 
-/* Get an CUI. */
-STATIC void *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	ASSERT(cuip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &cuip->cui_item);
-	return cuip;
-}
-
 /* Set the phys extent flags for this reverse mapping. */
 static void
 xfs_trans_set_refcount_flags(
@@ -328,16 +307,12 @@ xfs_trans_set_refcount_flags(
 STATIC void
 xfs_refcount_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_cui_log_item		*cuip,
+	struct xfs_refcount_intent	*refc)
 {
-	struct xfs_cui_log_item		*cuip = intent;
-	struct xfs_refcount_intent	*refc;
 	uint				next_extent;
 	struct xfs_phys_extent		*ext;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
 
@@ -354,6 +329,24 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
+	struct xfs_refcount_intent	*refc;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	list_for_each_entry(refc, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, refc);
+	return cuip;
+}
+
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
@@ -432,7 +425,6 @@ const struct xfs_defer_op_type xfs_refco
 	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
-	.log_item	= xfs_refcount_update_log_item,
 	.create_done	= xfs_refcount_update_create_done,
 	.finish_item	= xfs_refcount_update_finish_item,
 	.finish_cleanup = xfs_refcount_update_finish_cleanup,
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -352,41 +352,16 @@ xfs_rmap_update_diff_items(
 		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
 }
 
-/* Get an RUI. */
-STATIC void *
-xfs_rmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	ruip = xfs_rui_init(tp->t_mountp, count);
-	ASSERT(ruip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &ruip->rui_item);
-	return ruip;
-}
-
 /* Log rmap updates in the intent item. */
 STATIC void
 xfs_rmap_update_log_item(
 	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
+	struct xfs_rui_log_item		*ruip,
+	struct xfs_rmap_intent		*rmap)
 {
-	struct xfs_rui_log_item		*ruip = intent;
-	struct xfs_rmap_intent		*rmap;
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
 
@@ -406,6 +381,24 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
+	struct xfs_rmap_intent		*rmap;
+
+	ASSERT(count > 0);
+
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	list_for_each_entry(rmap, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, rmap);
+	return ruip;
+}
+
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
@@ -476,7 +469,6 @@ const struct xfs_defer_op_type xfs_rmap_
 	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
-	.log_item	= xfs_rmap_update_log_item,
 	.create_done	= xfs_rmap_update_create_done,
 	.finish_item	= xfs_rmap_update_finish_item,
 	.finish_cleanup = xfs_rmap_update_finish_cleanup,


