Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C252B6240
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbgKQN06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbgKQN0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95072078E;
        Tue, 17 Nov 2020 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619613;
        bh=67wR2JK1ZJg0dpLtpxuU8+0flNKHFozp+c2KDpdX834=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy/c/AQkCjqB8Rd+8ukxaaWKxVODCuF9KVexRsq/FcUyXf6VQEB0vPdjSa0t2RUqy
         YV38xLTfyycyhQxy9Z8VYKJvLjDg+jo927ufi3ObumrC3fijM7E85c8sINthLzxCEr
         1M3RPopC6pN8eBTKgA88xzVT1GRluptToku8nNsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/151] xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents
Date:   Tue, 17 Nov 2020 14:05:27 +0100
Message-Id: <20201117122126.131623250@linuxfoundation.org>
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

[ Upstream commit 5dda3897fd90783358c4c6115ef86047d8c8f503 ]

When the bmbt scrubber is looking up rmap extents, we need to set the
extent flags from the bmbt record fully.  This will matter once we fix
the rmap btree comparison functions to check those flags correctly.

Fixes: d852657ccfc0 ("xfs: cross-reference reverse-mapping btree")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 392fb4df5c127..ec580c0d70fa3 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -113,6 +113,8 @@ xchk_bmap_get_rmap(
 
 	if (info->whichfork == XFS_ATTR_FORK)
 		rflags |= XFS_RMAP_ATTR_FORK;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		rflags |= XFS_RMAP_UNWRITTEN;
 
 	/*
 	 * CoW staging extents are owned (on disk) by the refcountbt, so
-- 
2.27.0



