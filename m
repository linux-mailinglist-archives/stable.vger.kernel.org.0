Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB5E6ECEBE
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjDXNfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjDXNen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356D07EF6
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FDF0623B2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F49C4339E;
        Mon, 24 Apr 2023 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343264;
        bh=KcIYtxZiyltAwaQEXsnim1aZAxkvZbi72cBZ43HvthM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2au54br3AeKnCxvPTklw7SPNWAi/W1assCAwM+U9xJVU0aaa8Du0k8UEHyYeW64X
         wrOoPlWprL5qsvsSxc5t051KjqB0b34iuzNgonqMItUfv3V1wRT5H4byoYPkTpgJDl
         4cTn5VK+lEDNMVB8Spcec/WYNAvTn7HpMohYPqg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christian Theune <ct@flyingcircus.io>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 29/68] xfs: drop submit side trans alloc for append ioends
Date:   Mon, 24 Apr 2023 15:18:00 +0200
Message-Id: <20230424131128.759812392@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 7cd3099f4925d7c15887d1940ebd65acd66100f5 upstream.

Per-inode ioend completion batching has a log reservation deadlock
vector between preallocated append transactions and transactions
that are acquired at completion time for other purposes (i.e.,
unwritten extent conversion or COW fork remaps). For example, if the
ioend completion workqueue task executes on a batch of ioends that
are sorted such that an append ioend sits at the tail, it's possible
for the outstanding append transaction reservation to block
allocation of transactions required to process preceding ioends in
the list.

Append ioend completion is historically the common path for on-disk
inode size updates. While file extending writes may have completed
sometime earlier, the on-disk inode size is only updated after
successful writeback completion. These transactions are preallocated
serially from writeback context to mitigate concurrency and
associated log reservation pressure across completions processed by
multi-threaded workqueue tasks.

However, now that delalloc blocks unconditionally map to unwritten
extents at physical block allocation time, size updates via append
ioends are relatively rare. This means that inode size updates most
commonly occur as part of the preexisting completion time
transaction to convert unwritten extents. As a result, there is no
longer a strong need to preallocate size update transactions.

Remove the preallocation of inode size update transactions to avoid
the ioend completion processing log reservation deadlock. Instead,
continue to send all potential size extending ioends to workqueue
context for completion and allocate the transaction from that
context. This ensures that no outstanding log reservation is owned
by the ioend completion worker task when it begins to process
ioends.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Christian Theune <ct@flyingcircus.io>
Link: https://lore.kernel.org/linux-xfs/CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |   45 +++------------------------------------------
 1 file changed, 3 insertions(+), 42 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -39,33 +39,6 @@ static inline bool xfs_ioend_is_append(s
 		XFS_I(ioend->io_inode)->i_d.di_size;
 }
 
-STATIC int
-xfs_setfilesize_trans_alloc(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	ioend->io_private = tp;
-
-	/*
-	 * We may pass freeze protection with a transaction.  So tell lockdep
-	 * we released it.
-	 */
-	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
-	/*
-	 * We hand off the transaction to the completion thread now, so
-	 * clear the flag here.
-	 */
-	xfs_trans_clear_context(tp);
-	return 0;
-}
-
 /*
  * Update on-disk file size now that data has been written to disk.
  */
@@ -191,12 +164,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
+	if (!error && xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -246,7 +217,7 @@ xfs_end_io(
 
 static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
-	return ioend->io_private ||
+	return xfs_ioend_is_append(ioend) ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
 		(ioend->io_flags & IOMAP_F_SHARED);
 }
@@ -259,8 +230,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -510,14 +479,6 @@ xfs_prepare_ioend(
 				ioend->io_offset, ioend->io_size);
 	}
 
-	/* Reserve log space if we might write beyond the on-disk inode size. */
-	if (!status &&
-	    ((ioend->io_flags & IOMAP_F_SHARED) ||
-	     ioend->io_type != IOMAP_UNWRITTEN) &&
-	    xfs_ioend_is_append(ioend) &&
-	    !ioend->io_private)
-		status = xfs_setfilesize_trans_alloc(ioend);
-
 	memalloc_nofs_restore(nofs_flag);
 
 	if (xfs_ioend_needs_workqueue(ioend))


