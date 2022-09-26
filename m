Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9AF5EA2E5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiIZLQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbiIZLPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:15:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0DB65274;
        Mon, 26 Sep 2022 03:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E01F060AF0;
        Mon, 26 Sep 2022 10:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D450BC433D6;
        Mon, 26 Sep 2022 10:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188257;
        bh=XrY/kvQJTArJAl3vqCiYNo4EjSadl360AmWIo/uNlew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inXAuG9cYTiRGRLfzzCDG2H1Wknq70QYSiatdh2B5INVquWVseTONhCnD5lra3spP
         e0OU4ngxjMbkTHApmKK3r3YMIXywaGlkZuF181OvDI8XBIqlnCRO7fweLthkPjy04P
         1d3RIYUusz7jRnjfRGEiIgXmND3Ma+tJmhoj0a64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Hofmann <fhofmann@cloudflare.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.10 061/141] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Mon, 26 Sep 2022 12:11:27 +0200
Message-Id: <20220926100756.662473396@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.

[backport for 5.10.y]

The O_TMPFILE creation implementation creates a specific order of
operations for inode allocation/freeing and unlinked list
modification. Currently both are serialised by the AGI, so the order
doesn't strictly matter as long as the are both in the same
transaction.

However, if we want to move the unlinked list insertions largely out
from under the AGI lock, then we have to be concerned about the
order in which we do unlinked list modification operations.
O_TMPFILE creation tells us this order is inode allocation/free,
then unlinked list modification.

Change xfs_ifree() to use this same ordering on unlinked list
removal. This way we always guarantee that when we enter the
iunlinked list removal code from this path, we already have the AGI
locked and we don't have to worry about lock nesting AGI reads
inside unlink list locks because it's already locked and attached to
the transaction.

We can do this safely as the inode freeing and unlinked list removal
are done in the same transaction and hence are atomic operations
with respect to log recovery.

Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2694,13 +2693,16 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, ip);
 	if (error)
 		return error;
 


