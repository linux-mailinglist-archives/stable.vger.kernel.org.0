Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21E82B65AB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732275AbgKQN5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbgKQNTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F3824695;
        Tue, 17 Nov 2020 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619179;
        bh=dLG5ITSkyLAmWjLFAa0VwfX6Za66mIz9qPoWi5+lFgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSwC5IPqUS+OOvlUAHX21Ii7ft9wLZwQGb9gkQnfgGFEiMcURlQAIzvotjQqRVu9S
         bd6pd4m728vckNHVY83NAGg822sBmun4QoPPGmqCZqhH/rVytGm2BRF/alBc5TBQEJ
         Eq/JCRGYHJecCytYMdb0H/bBY7Y+1PPBasYlUYrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/101] xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents
Date:   Tue, 17 Nov 2020 14:05:22 +0100
Message-Id: <20201117122115.778357576@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index f84a58e523bc8..b05d65fd360b3 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -120,6 +120,8 @@ xchk_bmap_get_rmap(
 
 	if (info->whichfork == XFS_ATTR_FORK)
 		rflags |= XFS_RMAP_ATTR_FORK;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		rflags |= XFS_RMAP_UNWRITTEN;
 
 	/*
 	 * CoW staging extents are owned (on disk) by the refcountbt, so
-- 
2.27.0



