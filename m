Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303E8745C0
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbfGYFpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405257AbfGYFpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CBAC21880;
        Thu, 25 Jul 2019 05:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033547;
        bh=pSryTvXNuUCi9g6Q9rMqN8+KiH/rNRnTJxRRJ5VIlv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDxz6UYYkEvcPR8jWr2UugYPoTLg/paczmzQ+8ltKaQTIldyYwqrF+BrxP5gtQceB
         uHJ19Da39g1wIzyIbprZBNWy7f3lJOhcrv/tdDC1i+TtWb1fBm6QqW89tl6Wjtwhnu
         JwdSKs/PTuGDS3RMBUMwvABjB6q/kXjhzwv5WFXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/271] xfs: rename m_inotbt_nores to m_finobt_nores
Date:   Wed, 24 Jul 2019 21:21:54 +0200
Message-Id: <20190724191716.193047394@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e1f6ca11381588e3ef138c10de60eeb34cb8466a upstream.

Rename this flag variable to imply more strongly that it's related to
the free inode btree (finobt) operation.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c      | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 4 ++--
 fs/xfs/xfs_inode.c               | 2 +-
 fs/xfs/xfs_mount.h               | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e701ebc36c06..e2ba2a3b63b2 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -281,7 +281,7 @@ xfs_ag_resv_init(
 			 */
 			ask = used = 0;
 
-			mp->m_inotbt_nores = true;
+			mp->m_finobt_nores = true;
 
 			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
 					&used);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 86c50208a143..adb2f6df5a11 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -124,7 +124,7 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_alloc_block(cur, start, new, stat);
 	return __xfs_inobt_alloc_block(cur, start, new, stat,
 			XFS_AG_RESV_METADATA);
@@ -157,7 +157,7 @@ xfs_finobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	if (cur->bc_mp->m_inotbt_nores)
+	if (cur->bc_mp->m_finobt_nores)
 		return xfs_inobt_free_block(cur, bp);
 	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05db9540e459..ae07baa7bdbf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1754,7 +1754,7 @@ xfs_inactive_ifree(
 	 * now remains allocated and sits on the unlinked list until the fs is
 	 * repaired.
 	 */
-	if (unlikely(mp->m_inotbt_nores)) {
+	if (unlikely(mp->m_finobt_nores)) {
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
 				XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE,
 				&tp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513c3128..7e0bf952e087 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,7 +127,7 @@ typedef struct xfs_mount {
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint64_t		m_flags;	/* global mount flags */
-	bool			m_inotbt_nores; /* no per-AG finobt resv. */
+	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
 	int			m_ialloc_min_blks;/* min blocks in sparse inode
-- 
2.20.1



