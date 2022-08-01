Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FCD586926
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiHAL6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiHAL5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8552C48CAF;
        Mon,  1 Aug 2022 04:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C93B8116E;
        Mon,  1 Aug 2022 11:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407FFC433C1;
        Mon,  1 Aug 2022 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354710;
        bh=j+lLUqvz74ahqj07oBiRiEe4LBl0Q7op740iScROl2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATWQfGO22NMbLY72pHISDqOFAtFi18kk2sHv2F2wdQCojnHWumV5pHvmhRffHVGUD
         OcuvVGAUuHKQ5ZA/YLgKfBCiR7/78qahPqMeqqUDRgFv+L7ulSlPLtwrKERUknzMFs
         tbVeHCKqTy0NEbrVo6+wQWzG96znOydOeRKwm91I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 58/65] xfs: hold buffer across unpin and potential shutdown processing
Date:   Mon,  1 Aug 2022 13:47:15 +0200
Message-Id: <20220801114136.094866787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 84d8949e770745b16a7e8a68dcb1d0f3687bdee9 upstream.

The special processing used to simulate a buffer I/O failure on fs
shutdown has a difficult to reproduce race that can result in a use
after free of the associated buffer. Consider a buffer that has been
committed to the on-disk log and thus is AIL resident. The buffer
lands on the writeback delwri queue, but is subsequently locked,
committed and pinned by another transaction before submitted for
I/O. At this point, the buffer is stuck on the delwri queue as it
cannot be submitted for I/O until it is unpinned. A log checkpoint
I/O failure occurs sometime later, which aborts the bli. The unpin
handler is called with the aborted log item, drops the bli reference
count, the pin count, and falls into the I/O failure simulation
path.

The potential problem here is that once the pin count falls to zero
in ->iop_unpin(), xfsaild is free to retry delwri submission of the
buffer at any time, before the unpin handler even completes. If
delwri queue submission wins the race to the buffer lock, it
observes the shutdown state and simulates the I/O failure itself.
This releases both the bli and delwri queue holds and frees the
buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
run through the same failure sequence. This problem is rare and
requires many iterations of fstest generic/019 (which simulates disk
I/O failures) to reproduce.

To avoid this problem, grab a hold on the buffer before the log item
is unpinned if the associated item has been aborted and will require
a simulated I/O failure. The hold is already required for the
simulated I/O failure, so the ordering simply guarantees the unpin
handler access to the buffer before it is unpinned and thus
processed by the AIL. This particular ordering is required so long
as the AIL does not acquire a reference on the bli, which is the
long term solution to this problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -393,17 +393,8 @@ xfs_buf_item_pin(
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log
- * item which was previously pinned with a call to xfs_buf_item_pin().
- *
- * Also drop the reference to the buf item for the current transaction.
- * If the XFS_BLI_STALE flag is set and we are the last reference,
- * then free up the buf log item and unlock the buffer.
- *
- * If the remove flag is set we are called from uncommit in the
- * forced-shutdown path.  If that is true and the reference count on
- * the log item is going to drop to zero we need to free the item's
- * descriptor in the transaction.
+ * This is called to unpin the buffer associated with the buf log item which
+ * was previously pinned with a call to xfs_buf_item_pin().
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -420,12 +411,26 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
+	/*
+	 * Drop the bli ref associated with the pin and grab the hold required
+	 * for the I/O simulation failure in the abort case. We have to do this
+	 * before the pin count drops because the AIL doesn't acquire a bli
+	 * reference. Therefore if the refcount drops to zero, the bli could
+	 * still be AIL resident and the buffer submitted for I/O (and freed on
+	 * completion) at any point before we return. This can be removed once
+	 * the AIL properly holds a reference on the bli.
+	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-
+	if (freed && !stale && remove)
+		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	if (freed && stale) {
+	 /* nothing to do but drop the pin count if the bli is active */
+	if (!freed)
+		return;
+
+	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
@@ -468,13 +473,13 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (freed && remove) {
+	} else if (remove) {
 		/*
 		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure.
+		 * an async I/O failure. We acquired the hold for this case
+		 * before the buffer was unpinned.
 		 */
 		xfs_buf_lock(bp);
-		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
 	}


