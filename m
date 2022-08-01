Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C01586924
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiHAL5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiHAL4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798F948C8C;
        Mon,  1 Aug 2022 04:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02738B81163;
        Mon,  1 Aug 2022 11:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659C0C433D6;
        Mon,  1 Aug 2022 11:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354707;
        bh=1P8mkzwbB14g4oMscYA+zqx1Erlt0gIDYOVB6LuB2Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx3Jr3W+Tz9I8WfFBNsvOC0CFM5v1TFMpA8GpEV/rfB3L9ppEqWNu1/AMC29MHoU7
         8iaeCq83kf14jGyPi6FMnOpfN0u/1q9HEXA3nFcEe7nDrJAViTd9fh12e+t1YHWoVV
         50d0cZIxnrmtAM/95qoFe+5TxuQn8j8glwALXE0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 57/65] xfs: force the log offline when log intent item recovery fails
Date:   Mon,  1 Aug 2022 13:47:14 +0200
Message-Id: <20220801114136.056238154@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4e6b8270c820c8c57a73f869799a0af2b56eff3e upstream.

If any part of log intent item recovery fails, we should shut down the
log immediately to stop the log from writing a clean unmount record to
disk, because the metadata is not consistent.  The inability to cancel a
dirty transaction catches most of these cases, but there are a few
things that have slipped through the cracks, such as ENOSPC from a
transaction allocation, or runtime errors that result in cancellation of
a non-dirty transaction.

This solves some weird behaviors reported by customers where a system
goes down, the first mount fails, the second succeeds, but then the fs
goes down later because of inconsistent metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c         |    3 +++
 fs/xfs/xfs_log_recover.c |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -765,6 +765,9 @@ xfs_log_mount_finish(
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
+	/* Make sure the log is dead if we're returning failure. */
+	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
+
 	return error;
 }
 
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2457,8 +2457,10 @@ xlog_finish_defer_ops(
 
 		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
 				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
-		if (error)
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 			return error;
+		}
 
 		/*
 		 * Transfer to this new transaction all the dfops we captured
@@ -3454,6 +3456,7 @@ xlog_recover_finish(
 			 * this) before we get around to xfs_log_mount_cancel.
 			 */
 			xlog_recover_cancel_intents(log);
+			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}


