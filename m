Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF242B6526
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbgKQNvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731936AbgKQNal (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D4E21534;
        Tue, 17 Nov 2020 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619841;
        bh=a1qBWLIqeC3ibtRR2AJPsnjzgaNuc7Dxkdj1GDGQCSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN7qP+SWkD/MoHIeZK+N9yAlus7DDLEOv2rEnfLKDlnyyka+2yPSP4RQ990x5bCZS
         yppptiVgBDyVHDozfzzkXRf3zrzvoMPWIHsjRsIkmJ8GOpNjE8YCsH76E+M9JTViVx
         E+T9k+i0iIguHWYqrAguypb24acNV9WPDlLDgoeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 021/255] xfs: set xefi_discard when creating a deferred agfl free log intent item
Date:   Tue, 17 Nov 2020 14:02:41 +0100
Message-Id: <20201117122139.976162894@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
index 852b536551b53..15640015be9d2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2467,6 +2467,7 @@ xfs_defer_agfl_block(
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
+	new->xefi_skip_discard = false;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e1bd484e55485..6747e97a79490 100644
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



