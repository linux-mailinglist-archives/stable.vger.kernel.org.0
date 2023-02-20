Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E0F69CD77
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjBTNtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjBTNtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C11DB9B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD8CDB80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417CAC433D2;
        Mon, 20 Feb 2023 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900967;
        bh=RaZxpoy1KaqAhMlEBDC8UsgbHzscJue7dF5Pn5quo6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01xGfMXBdVMPiGc7C5LvKw0+lrV1LdFL0fofLy79BY+2e2D1J/xgQbpV6EjMEY2MP
         Z7hwT0TP5Q7kZo1lPRkYPWBz2zIwllHj12IjAzYAbcwJr3BnEC/LmkJ4OLCEFctWYV
         NzK2Rqw/VFe1v8Is6tJsuPmFMfAYkG0gMmuWNUok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 107/156] xfs: merge the ->diff_items defer op into ->create_intent
Date:   Mon, 20 Feb 2023 14:35:51 +0100
Message-Id: <20230220133606.980959374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit d367a868e46b025a8ced8e00ef2b3a3c2f3bf732 upstream.

This avoids a per-item indirect call, and also simplifies the interface
a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    5 +----
 fs/xfs/libxfs/xfs_defer.h  |    3 +--
 fs/xfs/xfs_bmap_item.c     |    9 ++++++---
 fs/xfs/xfs_extfree_item.c  |    7 ++++---
 fs/xfs/xfs_refcount_item.c |    6 ++++--
 fs/xfs/xfs_rmap_item.c     |    6 ++++--
 6 files changed, 20 insertions(+), 16 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,11 +186,8 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	if (sort)
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-
 	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count);
+			dfp->dfp_count, sort);
 }
 
 /*
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -49,9 +49,8 @@ struct xfs_defer_op_type {
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	int (*diff_items)(void *, struct list_head *, struct list_head *);
 	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count);
+			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -334,14 +334,18 @@ STATIC void *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
-	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
 	struct xfs_bmap_intent		*bmap;
 
 	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
 
 	xfs_trans_add_item(tp, &buip->bui_item);
+	if (sort)
+		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
 	return buip;
@@ -408,7 +412,6 @@ xfs_bmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_bmap_update_diff_items,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
 	.create_done	= xfs_bmap_update_create_done,
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -441,7 +441,8 @@ STATIC void *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
@@ -450,6 +451,8 @@ xfs_extent_free_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &efip->efi_item);
+	if (sort)
+		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
 	return efip;
@@ -506,7 +509,6 @@ xfs_extent_free_cancel_item(
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
@@ -571,7 +573,6 @@ xfs_agfl_free_finish_item(
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -333,7 +333,8 @@ STATIC void *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
@@ -342,6 +343,8 @@ xfs_refcount_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &cuip->cui_item);
+	if (sort)
+		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
 	return cuip;
@@ -422,7 +425,6 @@ xfs_refcount_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_refcount_update_diff_items,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
 	.create_done	= xfs_refcount_update_create_done,
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -385,7 +385,8 @@ STATIC void *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
-	unsigned int			count)
+	unsigned int			count,
+	bool				sort)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
@@ -394,6 +395,8 @@ xfs_rmap_update_create_intent(
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &ruip->rui_item);
+	if (sort)
+		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
 	return ruip;
@@ -466,7 +469,6 @@ xfs_rmap_update_cancel_item(
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_rmap_update_diff_items,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
 	.create_done	= xfs_rmap_update_create_done,


