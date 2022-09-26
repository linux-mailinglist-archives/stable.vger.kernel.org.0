Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F735EA14C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiIZKrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiIZKqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:46:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB7556BBB;
        Mon, 26 Sep 2022 03:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC30FB8055F;
        Mon, 26 Sep 2022 10:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F456C433C1;
        Mon, 26 Sep 2022 10:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187952;
        bh=h+/4jC8dkAJL9pGO+IjbkJB8AIPYC7de9IyAM3x4D2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwbdJYyZtP7s7N2BkUtu5Ix6rmanJU5aGKrE1YJ+4AiaFhEVDStq+RmwZBSJpDJ/D
         loTxAS7/p/4YhIZ1FbqH97X0fKVnsjtYoympfhrakr8MdKMJZEY+cVmK4AAihVBo7e
         u14siaa9Q0fv0F0DjPIy/GPRZzC0/UgbKGEVO3SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 114/120] xfs: stabilize insert range start boundary to avoid COW writeback race
Date:   Mon, 26 Sep 2022 12:12:27 +0200
Message-Id: <20220926100755.090442267@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

From: Brian Foster <bfoster@redhat.com>

commit d0c2204135a0cdbc607c94c481cf1ccb2f659aa7 upstream.

generic/522 (fsx) occasionally fails with a file corruption due to
an insert range operation. The primary characteristic of the
corruption is a misplaced insert range operation that differs from
the requested target offset. The reason for this behavior is a race
between the extent shift sequence of an insert range and a COW
writeback completion that causes a front merge with the first extent
in the shift.

The shift preparation function flushes and unmaps from the target
offset of the operation to the end of the file to ensure no
modifications can be made and page cache is invalidated before file
data is shifted. An insert range operation then splits the extent at
the target offset, if necessary, and begins to shift the start
offset of each extent starting from the end of the file to the start
offset. The shift sequence operates at extent level and so depends
on the preparation sequence to guarantee no changes can be made to
the target range during the shift. If the block immediately prior to
the target offset was dirty and shared, however, it can undergo
writeback and move from the COW fork to the data fork at any point
during the shift. If the block is contiguous with the block at the
start offset of the insert range, it can front merge and alter the
start offset of the extent. Once the shift sequence reaches the
target offset, it shifts based on the latest start offset and
silently changes the target offset of the operation and corrupts the
file.

To address this problem, update the shift preparation code to
stabilize the start boundary along with the full range of the
insert. Also update the existing corruption check to fail if any
extent is shifted with a start offset behind the target offset of
the insert range. This prevents insert from racing with COW
writeback completion and fails loudly in the event of an unexpected
extent shift.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 fs/xfs/xfs_bmap_util.c   |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5876,7 +5876,7 @@ xfs_bmap_insert_extents(
 	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
 				del_cursor);
 
-	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+	if (stop_fsb > got.br_startoff) {
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1167,6 +1167,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
 	/*
@@ -1180,6 +1181,17 @@ xfs_prepare_shift(
 	}
 
 	/*
+	 * Shift operations must stabilize the start block offset boundary along
+	 * with the full range of the operation. If we don't, a COW writeback
+	 * completion could race with an insert, front merge with the start
+	 * extent (after split) during the shift and corrupt the file. Start
+	 * with the block just prior to the start to stabilize the boundary.
+	 */
+	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	if (offset)
+		offset -= (1 << mp->m_sb.sb_blocklog);
+
+	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
 	 */


