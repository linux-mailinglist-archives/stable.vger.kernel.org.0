Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50C81EC765
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 04:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgFCCd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 22:33:29 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:47874 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgFCCd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 22:33:29 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 0532XCP5019239; Wed, 3 Jun 2020 11:33:12 +0900
X-Iguazu-Qid: 34trpDa8MGMsEcHsEk
X-Iguazu-QSIG: v=2; s=0; t=1591151592; q=34trpDa8MGMsEcHsEk; m=BUcO9NqBVIivuGgnDo85nb1HSpvdBm6Due8FvQFhI+g=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 0532XBXI007642;
        Wed, 3 Jun 2020 11:33:11 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0532XBes022124;
        Wed, 3 Jun 2020 11:33:11 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0532XAhc008571;
        Wed, 3 Jun 2020 11:33:11 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.14] xfs: set format back to extents if xfs_bmap_extents_to_btree
Date:   Wed,  3 Jun 2020 11:32:57 +0900
X-TSB-HOP: ON
Message-Id: <20200603023257.2984930-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 2c4306f719b083d17df2963bc761777576b8ad1b upstream.

If xfs_bmap_extents_to_btree fails in a mode where we call
xfs_iroot_realloc(-1) to de-allocate the root, set the
format back to extents.

Otherwise we can assume we can dereference ifp->if_broot
based on the XFS_DINODE_FMT_BTREE format, and crash.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199423
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 84245d2101828..2b07dadc59167 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -761,12 +761,16 @@ xfs_bmap_extents_to_btree(
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
 		xfs_iroot_realloc(ip, -1, whichfork);
+		ASSERT(ifp->if_broot == NULL);
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return error;
 	}
 
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		xfs_iroot_realloc(ip, -1, whichfork);
+		ASSERT(ifp->if_broot == NULL);
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return -ENOSPC;
 	}
-- 
2.27.0.rc0

