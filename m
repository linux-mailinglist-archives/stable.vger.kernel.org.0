Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E5460FECC
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiJ0RIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiJ0RIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E08919D886
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B183BB824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAD0C433D6;
        Thu, 27 Oct 2022 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890508;
        bh=Xcksv0pGWzs3BGYaNbTBVvggUXa+mFrKV60f9GqQo2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZE5VG2qYku1xjVfSPi98/n27qsPznZfrnU0Y1qUXDbhgArhw6oPP2oyP7/iIriBw
         +5RTcIGqVl49m+KronJOTeWmRCwztoLHHgawttU7TRnPfUBQVaXlLNXsLFPwsFUjMJ
         OoU8EobKmjZy4A8Ghxd8doKqxbdagfUXsz0JkJMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 03/53] xfs: rework collapse range into an atomic operation
Date:   Thu, 27 Oct 2022 18:55:51 +0200
Message-Id: <20221027165049.951175600@linuxfoundation.org>
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

commit 211683b21de959a647de74faedfdd8a5d189327e upstream.

The collapse range operation uses a unique transaction and ilock
cycle for the hole punch and each extent shift iteration of the
overall operation. While the hole punch is safe as a separate
operation due to the iolock, cycling the ilock after each extent
shift is risky w.r.t. concurrent operations, similar to insert range.

To avoid this problem, make collapse range atomic with respect to
ilock. Hold the ilock across the entire operation, replace the
individual transactions with a single rolling transaction sequence
and finish dfops on each iteration to perform pending frees and roll
the transaction. Remove the unnecessary quota reservation as
collapse range can only ever merge extents (and thus remove extent
records and potentially free bmap blocks). The dfops call
automatically relogs the inode to keep it moving in the log. This
guarantees that nothing else can change the extent mapping of an
inode while a collapse range operation is in progress.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1237,7 +1237,6 @@ xfs_collapse_file_space(
 	int			error;
 	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
-	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	bool			done = false;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
@@ -1253,32 +1252,34 @@ xfs_collapse_file_space(
 	if (error)
 		return error;
 
-	while (!error && !done) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
-					&tp);
-		if (error)
-			break;
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
-				ip->i_gdquot, ip->i_pdquot, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_trans_cancel;
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
+	while (!done) {
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
 				&done);
 		if (error)
 			goto out_trans_cancel;
+		if (done)
+			break;
 
-		error = xfs_trans_commit(tp);
+		/* finish any deferred frees and roll the transaction */
+		error = xfs_defer_finish(&tp);
+		if (error)
+			goto out_trans_cancel;
 	}
 
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 


