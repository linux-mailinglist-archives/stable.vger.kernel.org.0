Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0BB60FEF4
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiJ0RKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbiJ0RKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C90A2A42B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED4FB623F7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9DFC433C1;
        Thu, 27 Oct 2022 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890600;
        bh=lui9w7XPvNP66GC9eaMQ6qd391ezcnG4QmhNnTrL0Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+PqbDlx/IK2N5woTDjk4323lZ7ALl91zhV57DAOFWOZ1JtOJm5LfpacOL7RLD73C
         lwtUD9kSD28t2j9zbO+1oKdLjCjCmWN6/zAiKBR+zGKm7q/HDX6iqC0GAYz5ZIYfN2
         /lNqmyyB4DCMp6HMALwjjD3JA+Sax5IbA9M+4v7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 22/53] xfs: trylock underlying buffer on dquot flush
Date:   Thu, 27 Oct 2022 18:56:10 +0200
Message-Id: <20221027165050.666599099@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 8d3d7e2b35ea7d91d6e085c93b5efecfb0fba307 upstream.

A dquot flush currently blocks on the buffer lock for the underlying
dquot buffer. In turn, this causes xfsaild to block rather than
continue processing other items in the meantime. Update
xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
are handled, and return -EAGAIN if the lock fails. Fix up any
callers that don't currently handle the error properly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c      |    6 +++---
 fs/xfs/xfs_dquot_item.c |    3 ++-
 fs/xfs/xfs_qm.c         |   14 +++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-				   &xfs_dquot_buf_ops);
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
 	if (error)
 		goto out_unlock;
 
@@ -1176,7 +1176,7 @@ xfs_qm_dqflush(
 
 out_unlock:
 	xfs_dqfunlock(dqp);
-	return -EIO;
+	return error;
 }
 
 /*
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	}
+	} else if (error == -EAGAIN)
+		rval = XFS_ITEM_LOCKED;
 
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -121,12 +121,11 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	int			error = -EAGAIN;
 
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
-		xfs_dqunlock(dqp);
-		return -EAGAIN;
-	}
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
+		goto out_unlock;
 
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
@@ -139,7 +138,6 @@ xfs_qm_dqpurge(
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
-		int		error;
 
 		/*
 		 * We don't care about getting disk errors here. We need
@@ -149,6 +147,8 @@ xfs_qm_dqpurge(
 		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
+		} else if (error == -EAGAIN) {
+			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
@@ -174,6 +174,10 @@ xfs_qm_dqpurge(
 
 	xfs_qm_dqdestroy(dqp);
 	return 0;
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
 }
 
 /*


