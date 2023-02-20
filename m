Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB4B69CD58
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjBTNsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjBTNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAAA122
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEDE60E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE7FC433D2;
        Mon, 20 Feb 2023 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900906;
        bh=dz8nGF4JjypCPR3W+Twl5d3l5ZbHT1L0QPHRx1aUuXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbnFWbllnfRi9bAfaxUowv3wSOR1m4xSBsvL1TGNz/5WfDVMEXpOenaSli6svcE4E
         l0gICK28U+CCJ4IZZy1xpUxRrdyeZ4kak0bNcrPkAkX2g3CGJ5ULbXCjjSi2/GPO9z
         eqxlBWnC9B6e+3QvrqexJL4mHI79CbvTvYY7Hhjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 113/156] xfs: xfs_defer_capture should absorb remaining block reservations
Date:   Mon, 20 Feb 2023 14:35:57 +0100
Message-Id: <20230220133607.260556805@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4f9a60c48078c0efa3459678fa8d6e050e8ada5d upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the remaining block reservations so
that when we continue the dfops chain, we can reserve the same number of
blocks to use.  We capture the reservations for both data and realtime
volumes.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/libxfs/xfs_defer.h |    4 ++++
 fs/xfs/xfs_log_recover.c  |   21 +++------------------
 3 files changed, 11 insertions(+), 18 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -589,6 +589,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the remaining block reservations along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
+
 	return dfc;
 }
 
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -73,6 +73,10 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+
+	/* Block reservations for the data and rt devices. */
+	unsigned int		dfc_blkres;
+	unsigned int		dfc_rtxres;
 };
 
 /*
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4766,27 +4766,12 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint64_t		resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		/*
-		 * We're finishing the defer_ops that accumulated as a result
-		 * of recovering unfinished intent items during log recovery.
-		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
-		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0)
-			return -ENOSPC;
-
-		resblks = min_t(uint64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				dfc->dfc_blkres, dfc->dfc_rtxres,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 


