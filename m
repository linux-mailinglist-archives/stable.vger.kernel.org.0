Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4460FECA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiJ0RIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiJ0RI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35C619D886
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C25623E7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730E5C433C1;
        Thu, 27 Oct 2022 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890505;
        bh=BVBJbNG5oiPDxcFzS3lIxZdJMA5MIygX+IvUREFT62k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9Epl8UnhOs/nvHGEqd+jUfOjvYEWN98AXCwHeDpGqy5elRxoKIWQvu4U3R52r+ZO
         Twq1tB3lzkXbL3wubx2UHVZIlw843CdtfYmaFomqp1kqLf7pYdthQxUHjICV9kzZNQ
         ubkFjXpNG1GLJcKeoVzz1rj6a/j51i9eASjMq2So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 02/53] xfs: rework insert range into an atomic operation
Date:   Thu, 27 Oct 2022 18:55:50 +0200
Message-Id: <20221027165049.906398257@linuxfoundation.org>
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

commit dd87f87d87fa4359a54e7b44549742f579e3e805 upstream.

The insert range operation uses a unique transaction and ilock cycle
for the extent split and each extent shift iteration of the overall
operation. While this works, it is risks racing with other
operations in subtle ways such as COW writeback modifying an extent
tree in the middle of a shift operation.

To avoid this problem, make insert range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and relog the inode to keep it moving in the log. This guarantees
that nothing else can change the extent mapping of an inode while
an insert range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1321,47 +1321,41 @@ xfs_insert_file_space(
 	if (error)
 		return error;
 
-	/*
-	 * The extent shifting code works on extent granularity. So, if stop_fsb
-	 * is not the starting block of extent, we need to split the extent at
-	 * stop_fsb.
-	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * The extent shifting code works on extent granularity. So, if stop_fsb
+	 * is not the starting block of extent, we need to split the extent at
+	 * stop_fsb.
+	 */
 	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_trans_commit(tp);
-	if (error)
-		return error;
-
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
-					&tp);
+	do {
+		error = xfs_trans_roll_inode(&tp, ip);
 		if (error)
-			break;
+			goto out_trans_cancel;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb);
 		if (error)
 			goto out_trans_cancel;
+	} while (!done);
 
-		error = xfs_trans_commit(tp);
-	}
-
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 


