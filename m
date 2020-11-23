Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904532C0990
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbgKWNJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732835AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EE62173E;
        Mon, 23 Nov 2020 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135691;
        bh=sBYJe6HdskY7nxOUQhP1BTaosjHP5UMVz5myARVvEh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVHC5QyS5zIn0DZmAFRi63z0zfiJ4edPKa11pRZaJIJf3m4AUoGDv1X8JN0PsyVCb
         sAxAtikf0/MnXI7NYuVkIR3qxPK5B14ZF+CUo1bhyzzflkjpqfOcL9LX36Zz8PR6KH
         dVn6cNJOumTJQSBEJas7tDRfXOwQd7YPKt3X/Etc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 161/252] xfs: strengthen rmap record flags checking
Date:   Mon, 23 Nov 2020 13:21:51 +0100
Message-Id: <20201123121843.360301938@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 498fe261f0d6d5189f8e11d283705dd97b474b54 ]

We always know the correct state of the rmap record flags (attr, bmbt,
unwritten) so check them by direct comparison.

Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 412e2ec55e388..fed56d213a3f9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -218,13 +218,13 @@ xchk_bmap_xref_rmap(
 	 * which doesn't track unwritten state.
 	 */
 	if (owner != XFS_RMAP_OWN_COW &&
-	    irec->br_state == XFS_EXT_UNWRITTEN &&
-	    !(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
+	    !!(irec->br_state == XFS_EXT_UNWRITTEN) !=
+	    !!(rmap.rm_flags & XFS_RMAP_UNWRITTEN))
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
-	if (info->whichfork == XFS_ATTR_FORK &&
-	    !(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
+	if (!!(info->whichfork == XFS_ATTR_FORK) !=
+	    !!(rmap.rm_flags & XFS_RMAP_ATTR_FORK))
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (rmap.rm_flags & XFS_RMAP_BMBT_BLOCK)
-- 
2.27.0



