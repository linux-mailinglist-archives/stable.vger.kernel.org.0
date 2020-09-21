Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C62273084
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgIURFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgIUQdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:33:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACBEA2396F;
        Mon, 21 Sep 2020 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706024;
        bh=eo6Nm9fAQf9qVIoL3ZBKPiiHmkLUcpw0XTOMtnjPZu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhrfZymjdiwLC0aYFKJIaTCznf1NKb9R9vIUGEOYYee9nF3FS2u8GVWn8/o4OKE9q
         LskA8wHF7qYJDaq8zJk1+fGTZCbyWcw6DBsZ3MYrKYs4uEk/8G1/OsbqojgwwAXV9g
         CpwYhhYhPvKChNlVDZ1SUhjQ9QPMo6BdkBmM9Wp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/70] xfs: initialize the shortform attr header padding entry
Date:   Mon, 21 Sep 2020 18:27:10 +0200
Message-Id: <20200921162035.595966123@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 125eac243806e021f33a1fdea3687eccbb9f7636 ]

Don't leak kernel memory contents into the shortform attr fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 70da4113c2baf..7b9dd76403bfd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -520,8 +520,8 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 		ASSERT(ifp->if_flags & XFS_IFINLINE);
 	}
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = (xfs_attr_sf_hdr_t *)ifp->if_u1.if_data;
-	hdr->count = 0;
+	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
 }
-- 
2.25.1



