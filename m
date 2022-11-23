Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638716354C8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbiKWJLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiKWJKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:10:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB72105AB9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:10:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7325DB81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A0FC433D6;
        Wed, 23 Nov 2022 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194639;
        bh=GhXVaMMPq+UaqeaYn61W7XBXEWGHPVFdhdeY8zM2vTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds6vyVWjCDyOvwJYRz7X7WFbOZ5h/3EBqXGl5g3KNHaEYovrLeQLuaTvBaa5JOBvU
         CzDgtzcmQz8EueDOLqLJskgaT+uxqo7cSio/W0pmOOKLx89miI9hbK7CvNWjEu1pyY
         7oiZOjB6mxUqZsNio2BNQ+1ps/MHHRlemVt4jpfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 002/156] xfs: rename xfs_bmap_is_real_extent to is_written_extent
Date:   Wed, 23 Nov 2022 09:49:19 +0100
Message-Id: <20221123084557.926302292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

commit 877f58f53684f14ca3202640f70592bf44890924 upstream.

[ Slightly modify fs/xfs/libxfs/xfs_rtbitmap.c & fs/xfs/xfs_reflink.c to
  resolve merge conflict ]

The name of this predicate is a little misleading -- it decides if the
extent mapping is allocated and written.  Change the name to be more
direct, as we're going to add a new predicate in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
 fs/xfs/xfs_reflink.c         |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(in
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
 	return irec->br_state != XFS_EXT_UNWRITTEN &&
 		irec->br_startblock != HOLESTARTBLOCK &&
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+	if (nmap == 0 || !xfs_bmap_is_written_extent(&map)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -181,7 +181,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -657,7 +657,7 @@ xfs_reflink_end_cow_extent(
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.
 	 */
-	if (!xfs_bmap_is_real_extent(&got)) {
+	if (!xfs_bmap_is_written_extent(&got)) {
 		*end_fsb = del.br_startoff;
 		goto out_cancel;
 	}
@@ -998,7 +998,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		new_isize)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_real_extent(irec);
+	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
 	unsigned int		resblks;
 	struct xfs_bmbt_irec	uirec;
@@ -1427,7 +1427,7 @@ xfs_reflink_dirty_extents(
 			goto out;
 		if (nmaps == 0)
 			break;
-		if (!xfs_bmap_is_real_extent(&map[0]))
+		if (!xfs_bmap_is_written_extent(&map[0]))
 			goto next;
 
 		map[1] = map[0];


