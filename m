Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83EC69CD65
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjBTNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjBTNs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CFF1E1EE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8638FB80D4F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB9BC433D2;
        Mon, 20 Feb 2023 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900922;
        bh=F2X80Hz0xZW+KwrRWoxZlfyh9T0k0BETbu0x3822WW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1clFSP5n/lxIEcHDGKwrtBppPlDM7I2UEWvqLo5ueTnOkXoKdfgyKkFyPRlv8F8R
         BETwU05B1p+uZxR6BygKjMJDlW91VK/lAACPScxmlUyMmLr0BBG3jN/ATsL9Ifd/IF
         GCgbWg/6s0dFksblZnpoc2xyGdyVeGLlSFJH8m+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 119/156] xfs: periodically relog deferred intent items
Date:   Mon, 20 Feb 2023 14:36:03 +0100
Message-Id: <20230220133607.542596794@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4e919af7827a6adfc28e82cd6c4ffcfcc3dd6118 upstream.

[ Modify xfs_{bmap|extfree|refcount|rmap}_item.c to fix merge conflicts ]

There's a subtle design flaw in the deferred log item code that can lead
to pinning the log tail.  Taking up the defer ops chain examples from
the previous commit, we can get trapped in sequences like this:

Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
chain will look like the following if the transaction rolls succeed:

t1: D0(t0), D1(t0), D2(t0), D3(t0)
t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

In transaction 9, we finish d9 and try to roll to t10 while holding onto
an intent item for D3 that we logged in t0.

The previous commit changed the order in which we place new defer ops in
the defer ops processing chain to reduce the maximum chain length.  Now
make xfs_defer_finish_noroll capable of relogging the entire chain
periodically so that we can always move the log tail forward.  Most
chains will never get relogged, except for operations that generate very
long chains (large extents containing many blocks with different sharing
levels) or are on filesystems with small logs and a lot of ongoing
metadata updates.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

The decision to relog an intent item is made based on whether the intent
was logged in a previous checkpoint, since there's no point in relogging
an intent into the same checkpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   42 ++++++++++++++++++
 fs/xfs/xfs_bmap_item.c     |   83 +++++++++++++++++++++++------------
 fs/xfs/xfs_extfree_item.c  |  104 ++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_refcount_item.c |   95 ++++++++++++++++++++++++++---------------
 fs/xfs/xfs_rmap_item.c     |   93 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_stats.c         |    4 +
 fs/xfs/xfs_stats.h         |    1 
 fs/xfs/xfs_trace.h         |    1 
 fs/xfs/xfs_trans.h         |   10 ++++
 9 files changed, 300 insertions(+), 133 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Deferred Operations in XFS
@@ -362,6 +363,42 @@ xfs_defer_cancel_list(
 }
 
 /*
+ * Prevent a log intent item from pinning the tail of the log by logging a
+ * done item to release the intent item; and then log a new intent item.
+ * The caller should provide a fresh transaction and roll it after we're done.
+ */
+static int
+xfs_defer_relog(
+	struct xfs_trans		**tpp,
+	struct list_head		*dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is not a part of
+		 * the current log checkpoint, relog the intent item to keep
+		 * the log tail moving forward.  We're ok with this being racy
+		 * because an incorrect decision means we'll be a little slower
+		 * at pushing the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
+			continue;
+
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
+}
+
+/*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
  */
@@ -447,6 +484,11 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Possibly relog intent items to keep the log moving. */
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -125,34 +125,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_bui_item_ops = {
-	.iop_size	= xfs_bui_item_size,
-	.iop_format	= xfs_bui_item_format,
-	.iop_unpin	= xfs_bui_item_unpin,
-	.iop_release	= xfs_bui_item_release,
-};
-
-/*
- * Allocate and initialize an bui item with the given number of extents.
- */
-struct xfs_bui_log_item *
-xfs_bui_init(
-	struct xfs_mount		*mp)
-
-{
-	struct xfs_bui_log_item		*buip;
-
-	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
-
-	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
-	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
-	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
-	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
-
-	return buip;
-}
-
 static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_bud_log_item, bud_item);
@@ -548,3 +520,58 @@ err_rele:
 	xfs_irele(ip);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_bud_log_item		*budp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	extp = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	atomic_set(&buip->bui_next_extent, count);
+	xfs_trans_add_item(tp, &buip->bui_item);
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+	return &buip->bui_item;
+}
+
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_release	= xfs_bui_item_release,
+	.iop_relog	= xfs_bui_item_relog,
+};
+
+/*
+ * Allocate and initialize an bui item with the given number of extents.
+ */
+struct xfs_bui_log_item *
+xfs_bui_init(
+	struct xfs_mount		*mp)
+
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
+	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
+	atomic_set(&buip->bui_next_extent, 0);
+	atomic_set(&buip->bui_refcount, 2);
+
+	return buip;
+}
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -139,44 +139,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_efi_item_ops = {
-	.iop_size	= xfs_efi_item_size,
-	.iop_format	= xfs_efi_item_format,
-	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_release	= xfs_efi_item_release,
-};
-
-
-/*
- * Allocate and initialize an efi item with the given number of extents.
- */
-struct xfs_efi_log_item *
-xfs_efi_init(
-	struct xfs_mount	*mp,
-	uint			nextents)
-
-{
-	struct xfs_efi_log_item	*efip;
-	uint			size;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, 0);
-	} else {
-		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
-	}
-
-	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
-	efip->efi_format.efi_nextents = nextents;
-	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
-	atomic_set(&efip->efi_next_extent, 0);
-	atomic_set(&efip->efi_refcount, 2);
-
-	return efip;
-}
-
 /*
  * Copy an EFI format buffer from the given buf, and into the destination
  * EFI format structure.
@@ -645,3 +607,69 @@ abort_error:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_efi_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_efd_log_item		*efdp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent		*extp;
+	unsigned int			count;
+
+	count = EFI_ITEM(intent)->efi_format.efi_nextents;
+	extp = EFI_ITEM(intent)->efi_format.efi_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
+	efdp->efd_next_extent = count;
+	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	efip = xfs_efi_init(tp->t_mountp, count);
+	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	atomic_set(&efip->efi_next_extent, count);
+	xfs_trans_add_item(tp, &efip->efi_item);
+	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+	return &efip->efi_item;
+}
+
+static const struct xfs_item_ops xfs_efi_item_ops = {
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_release	= xfs_efi_item_release,
+	.iop_relog	= xfs_efi_item_relog,
+};
+
+/*
+ * Allocate and initialize an efi item with the given number of extents.
+ */
+struct xfs_efi_log_item *
+xfs_efi_init(
+	struct xfs_mount	*mp,
+	uint			nextents)
+
+{
+	struct xfs_efi_log_item	*efip;
+	uint			size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
+			((nextents - 1) * sizeof(xfs_extent_t)));
+		efip = kmem_zalloc(size, 0);
+	} else {
+		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
+	}
+
+	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
+	efip->efi_format.efi_nextents = nextents;
+	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
+	atomic_set(&efip->efi_next_extent, 0);
+	atomic_set(&efip->efi_refcount, 2);
+
+	return efip;
+}
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -123,40 +123,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_cui_item_ops = {
-	.iop_size	= xfs_cui_item_size,
-	.iop_format	= xfs_cui_item_format,
-	.iop_unpin	= xfs_cui_item_unpin,
-	.iop_release	= xfs_cui_item_release,
-};
-
-/*
- * Allocate and initialize an cui item with the given number of extents.
- */
-struct xfs_cui_log_item *
-xfs_cui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
-		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-				0);
-	else
-		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
-
-	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
-	cuip->cui_format.cui_nextents = nextents;
-	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
-	atomic_set(&cuip->cui_next_extent, 0);
-	atomic_set(&cuip->cui_refcount, 2);
-
-	return cuip;
-}
-
 static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_cud_log_item, cud_item);
@@ -576,3 +542,64 @@ abort_error:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_cui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_cud_log_item		*cudp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*extp;
+	unsigned int			count;
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	extp = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	atomic_set(&cuip->cui_next_extent, count);
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+	return &cuip->cui_item;
+}
+
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_release	= xfs_cui_item_release,
+	.iop_relog	= xfs_cui_item_relog,
+};
+
+/*
+ * Allocate and initialize an cui item with the given number of extents.
+ */
+struct xfs_cui_log_item *
+xfs_cui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
+				0);
+	else
+		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
+
+	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
+	cuip->cui_format.cui_nextents = nextents;
+	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
+	atomic_set(&cuip->cui_next_extent, 0);
+	atomic_set(&cuip->cui_refcount, 2);
+
+	return cuip;
+}
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -122,39 +122,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_rui_item_ops = {
-	.iop_size	= xfs_rui_item_size,
-	.iop_format	= xfs_rui_item_format,
-	.iop_unpin	= xfs_rui_item_unpin,
-	.iop_release	= xfs_rui_item_release,
-};
-
-/*
- * Allocate and initialize an rui item with the given number of extents.
- */
-struct xfs_rui_log_item *
-xfs_rui_init(
-	struct xfs_mount		*mp,
-	uint				nextents)
-
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ASSERT(nextents > 0);
-	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
-	else
-		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
-
-	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
-	ruip->rui_format.rui_nextents = nextents;
-	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
-	atomic_set(&ruip->rui_next_extent, 0);
-	atomic_set(&ruip->rui_refcount, 2);
-
-	return ruip;
-}
-
 /*
  * Copy an RUI format buffer from the given buf, and into the destination
  * RUI format structure.  The RUI/RUD items were designed not to need any
@@ -600,3 +567,63 @@ abort_error:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rui_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_rud_log_item		*rudp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*extp;
+	unsigned int			count;
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	extp = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
+	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
+
+	ruip = xfs_rui_init(tp->t_mountp, count);
+	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	atomic_set(&ruip->rui_next_extent, count);
+	xfs_trans_add_item(tp, &ruip->rui_item);
+	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
+	return &ruip->rui_item;
+}
+
+static const struct xfs_item_ops xfs_rui_item_ops = {
+	.iop_size	= xfs_rui_item_size,
+	.iop_format	= xfs_rui_item_format,
+	.iop_unpin	= xfs_rui_item_unpin,
+	.iop_release	= xfs_rui_item_release,
+	.iop_relog	= xfs_rui_item_relog,
+};
+
+/*
+ * Allocate and initialize an rui item with the given number of extents.
+ */
+struct xfs_rui_log_item *
+xfs_rui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
+		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
+	else
+		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
+
+	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
+	ruip->rui_format.rui_nextents = nextents;
+	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
+	atomic_set(&ruip->rui_next_extent, 0);
+	atomic_set(&ruip->rui_refcount, 2);
+
+	return ruip;
+}
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -23,6 +23,7 @@ int xfs_stats_format(struct xfsstats __p
 	uint64_t	xs_xstrat_bytes = 0;
 	uint64_t	xs_write_bytes = 0;
 	uint64_t	xs_read_bytes = 0;
+	uint64_t	defer_relog = 0;
 
 	static const struct xstats_entry {
 		char	*desc;
@@ -70,10 +71,13 @@ int xfs_stats_format(struct xfsstats __p
 		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
 		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
+		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
 	}
 
 	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
+			defer_relog);
 	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -137,6 +137,7 @@ struct __xfsstats {
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
 	uint64_t		xs_read_bytes;
+	uint64_t		defer_relog;
 };
 
 #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2418,6 +2418,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_cre
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,6 +77,8 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
+	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_trans *tp);
 };
 
 /*
@@ -244,4 +246,12 @@ void		xfs_trans_buf_copy_type(struct xfs
 
 extern kmem_zone_t	*xfs_trans_zone;
 
+static inline struct xfs_log_item *
+xfs_trans_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	return lip->li_ops->iop_relog(lip, tp);
+}
+
 #endif	/* __XFS_TRANS_H__ */


