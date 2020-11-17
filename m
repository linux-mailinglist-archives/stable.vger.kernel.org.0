Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1882B6041
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgKQNH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgKQNH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:07:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 231492469D;
        Tue, 17 Nov 2020 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618446;
        bh=b4DVEnv7NChjMLM9ddUPcoDbrPCQLRPzs4KHY1O5TC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tclfLLNVuRVmdieQG4w/YAndg7Z525Th/9fCMwiSA7mdVFKWqFDe/oQhDmSpwdpE
         WlSuKgBfXEtiQM8c5L24y7mGVB5l0LnJtAQfDXmyVAzbETaVCQiyRJBn93zIhXCoWQ
         HU1Dvc2AgK3EidmfDdFFjew/zWJmhV5WNU8PWOfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 28/64] xfs: fix a missing unlock on error in xfs_fs_map_blocks
Date:   Tue, 17 Nov 2020 14:04:51 +0100
Message-Id: <20201117122107.528113940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2bd3fa793aaa7e98b74e3653fdcc72fa753913b5 ]

We also need to drop the iolock when invalidate_inode_pages2 fails, not
only on all other error or successful cases.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index dc6221942b85f..ab66ea0a72bfb 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -162,7 +162,7 @@ xfs_fs_map_blocks(
 		goto out_unlock;
 	error = invalidate_inode_pages2(inode->i_mapping);
 	if (WARN_ON_ONCE(error))
-		return error;
+		goto out_unlock;
 
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-- 
2.27.0



