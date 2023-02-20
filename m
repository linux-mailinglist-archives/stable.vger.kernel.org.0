Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7E169CD7A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBTNt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjBTNtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1771A6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D048C60B74
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE39DC433D2;
        Mon, 20 Feb 2023 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900970;
        bh=/7tSQCEA221aoHBe6sQP+vviUDpDj6VtXr4Ku3KffTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE0Npl+HM/3QwAufzzqm83QuU7x84HUaTAIKnr29K/v4ISMAbTE9SFe7unYOAYH8S
         y2VqEul09U6UNrodJYG6tBUXj/inHGAgRvfoqBP34OdINXlpjZqajfNqWCOhPcH1W+
         vsYSna4P++pWXQhdNGf230oPA+TOlFnHQgaAImj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 108/156] xfs: turn dfp_intent into a xfs_log_item
Date:   Mon, 20 Feb 2023 14:35:52 +0100
Message-Id: <20230220133607.025471779@linuxfoundation.org>
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

commit 13a8333339072b8654c1d2c75550ee9f41ee15de upstream.

All defer op instance place their own extension of the log item into
the dfp_intent field.  Replace that with a xfs_log_item to improve type
safety and make the code easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.h  |   11 ++++++-----
 fs/xfs/xfs_bmap_item.c     |   12 ++++++------
 fs/xfs/xfs_extfree_item.c  |   12 ++++++------
 fs/xfs/xfs_refcount_item.c |   12 ++++++------
 fs/xfs/xfs_rmap_item.c     |   12 ++++++------
 5 files changed, 30 insertions(+), 29 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -28,7 +28,7 @@ enum xfs_defer_ops_type {
 struct xfs_defer_pending {
 	struct list_head		dfp_list;	/* pending items */
 	struct list_head		dfp_work;	/* work items */
-	void				*dfp_intent;	/* log intent item */
+	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	void				*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
 	enum xfs_defer_ops_type		dfp_type;
@@ -43,14 +43,15 @@ void xfs_defer_move(struct xfs_trans *dt
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-	void (*abort_intent)(void *);
-	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
+	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
+			struct list_head *items, unsigned int count, bool sort);
+	void (*abort_intent)(struct xfs_log_item *intent);
+	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
+			unsigned int count);
 	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -330,7 +330,7 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -348,17 +348,17 @@ xfs_bmap_update_create_intent(
 		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
-	return buip;
+	return &buip->bui_item;
 }
 
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_bud(tp, intent);
+	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -394,9 +394,9 @@ xfs_bmap_update_finish_item(
 /* Abort all pending BUIs. */
 STATIC void
 xfs_bmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_bui_release(intent);
+	xfs_bui_release(BUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -437,7 +437,7 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -455,17 +455,17 @@ xfs_extent_free_create_intent(
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
-	return efip;
+	return &efip->efi_item;
 }
 
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_efd(tp, intent, count);
+	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 }
 
 /* Process a free extent. */
@@ -491,9 +491,9 @@ xfs_extent_free_finish_item(
 /* Abort all pending EFIs. */
 STATIC void
 xfs_extent_free_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_efi_release(intent);
+	xfs_efi_release(EFI_ITEM(intent));
 }
 
 /* Cancel a free extent. */
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -329,7 +329,7 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -347,17 +347,17 @@ xfs_refcount_update_create_intent(
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
-	return cuip;
+	return &cuip->cui_item;
 }
 
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_cud(tp, intent);
+	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
 }
 
 /* Process a deferred refcount update. */
@@ -407,9 +407,9 @@ xfs_refcount_update_finish_cleanup(
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_cui_release(intent);
+	xfs_cui_release(CUI_ITEM(intent));
 }
 
 /* Cancel a deferred refcount update. */
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -381,7 +381,7 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -399,17 +399,17 @@ xfs_rmap_update_create_intent(
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
-	return ruip;
+	return &ruip->rui_item;
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_rud(tp, intent);
+	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -451,9 +451,9 @@ xfs_rmap_update_finish_cleanup(
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item	*intent)
 {
-	xfs_rui_release(intent);
+	xfs_rui_release(RUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */


