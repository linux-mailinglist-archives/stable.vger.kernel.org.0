Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2BD2B658A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgKQN4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731204AbgKQNWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92782246A5;
        Tue, 17 Nov 2020 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619370;
        bh=AOJ0PAjxzViNiDp9NnJFqaIJfJbgKExCReIodRxyUsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfIDjx9VIGrzlS1TmuUE527dO/7/0XW6JIXLmK6qcqAoEnG7+/XmzfRQvWodyEqzq
         8S82CuUV272b6o6gMa6a3MbgghA0mabUZGKZcRxKkf528NBWHHwuiy5Y2/IsOmqaS+
         +2TUJu+YPtoODOqrNWfwgECw9UeIoC6/TIhM4T3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/151] xfs: set xefi_discard when creating a deferred agfl free log intent item
Date:   Tue, 17 Nov 2020 14:04:06 +0100
Message-Id: <20201117122122.194319393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 2c334e12f957cd8c6bb66b4aa3f79848b7c33cab ]

Make sure that we actually initialize xefi_discard when we're scheduling
a deferred free of an AGFL block.  This was (eventually) found by the
UBSAN while I was banging on realtime rmap problems, but it exists in
the upstream codebase.  While we're at it, rearrange the structure to
reduce the struct size from 64 to 56 bytes.

Fixes: fcb762f5de2e ("xfs: add bmapi nodiscard flag")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 1 +
 fs/xfs/libxfs/xfs_bmap.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0a36f532cf86c..436f686a98918 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2209,6 +2209,7 @@ xfs_defer_agfl_block(
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
+	new->xefi_skip_discard = false;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e2798c6f3a5f3..093716a074fb7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -52,9 +52,9 @@ struct xfs_extent_free_item
 {
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
+	bool			xefi_skip_discard;
 	struct list_head	xefi_list;
 	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
-	bool			xefi_skip_discard;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
-- 
2.27.0



