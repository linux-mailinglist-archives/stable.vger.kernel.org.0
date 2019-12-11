Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA02111B54C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbfLKPT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732284AbfLKPTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 498F42073D;
        Wed, 11 Dec 2019 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077593;
        bh=uwl3yzZIRDGIzZbhCnRwMrZw4/ssOAVybnQ82DWjROE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsxbjM4boUB31AbILjxM6KeeNnJswSZ1i0M7C3aO9azocKCKpZtlGREo+eh/1tRvU
         X1mrczO41o6rvuDTRInXorIz5J4vNhIrIxbktVeLjs3px7/B/iQhXeQgPNwYaE2iWR
         X28GKcsm2UkrIG+oMbXSVfUCQW6octTjdGnOqgek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/243] xfs: extent shifting doesnt fully invalidate page cache
Date:   Wed, 11 Dec 2019 16:03:52 +0100
Message-Id: <20191211150343.827226097@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 7f9f71be84bcab368e58020a42f6d0dd97adf0ce ]

The extent shifting code uses a flush and invalidate mechainsm prior
to shifting extents around. This is similar to what
xfs_free_file_space() does, but it doesn't take into account things
like page cache vs block size differences, and it will fail if there
is a page that it currently busy.

xfs_flush_unmap_range() handles all of these cases, so just convert
xfs_prepare_shift() to us that mechanism rather than having it's own
special sauce.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 41ad9eaab6ce9..c045723678be9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1244,13 +1244,7 @@ xfs_prepare_shift(
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
 	 */
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset, -1);
-	if (error)
-		return error;
-	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-					offset >> PAGE_SHIFT, -1);
-	if (error)
-		return error;
+	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
 
 	/*
 	 * Clean out anything hanging around in the cow fork now that
-- 
2.20.1



