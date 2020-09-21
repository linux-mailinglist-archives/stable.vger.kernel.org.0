Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D65272D0F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgIUQhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbgIUQhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4872399C;
        Mon, 21 Sep 2020 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706225;
        bh=uH3BYY2sIpwijIk/tAp7w0ibMs3cmNULbIeHF7b3H2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjfwxvSvSitROVO1wlL5rSZmg8yQECye04kBIfJxocZXF6gLjJFzroX2fjeod4j+4
         EhSZP3DCp8RgN2shbwuYCmcnt9TxkT4eflATNK7Dm/PGyDxd41G7fZKBvZowYekwec
         udGU8IDd/O1+Lbuv42N9V93/10s01bRAOwB16EVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/94] xfs: initialize the shortform attr header padding entry
Date:   Mon, 21 Sep 2020 18:27:03 +0200
Message-Id: <20200921162036.297186791@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
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
index 73a541755d5b7..299d17b088e21 100644
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



