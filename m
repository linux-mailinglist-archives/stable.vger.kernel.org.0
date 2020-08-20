Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9324B58E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgHTKZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbgHTKZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C4C20658;
        Thu, 20 Aug 2020 10:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919125;
        bh=BOjAsGPtbJQYY1chuWkpdg5mJVtRTxQcinkcqu30H+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpJejPWg1yxrOH1xsXfHSPfvoyogk7X55PODEaXOe1jkG3323bssfe6OMqPBCB5LI
         hs0Q4HAvCJwlS8ISOr85faR/aTANdyN3EHFZBCpJY8sjwV7QK0D/2+Tdo/6uFVczKE
         6t5JPif+bCYY+TKGmBLoxM7+R1CArEldj/n3AZcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xu, Wen" <wen.xu@gatech.edu>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 003/212] xfs: dont call xfs_da_shrink_inode with NULL bp
Date:   Thu, 20 Aug 2020 11:19:36 +0200
Message-Id: <20200820091602.424819869@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

[ Upstream commit bb3d48dcf86a97dc25fe9fc2c11938e19cb4399a ]

xfs_attr3_leaf_create may have errored out before instantiating a buffer,
for example if the blkno is out of range.  In that case there is no work
to do to remove it, and in fact xfs_da_shrink_inode will lead to an oops
if we try.

This also seems to fix a flaw where the original error from
xfs_attr3_leaf_create gets overwritten in the cleanup case, and it
removes a pointless assignment to bp which isn't used after this.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199969
Reported-by: Xu, Wen <wen.xu@gatech.edu>
Tested-by: Xu, Wen <wen.xu@gatech.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c6c15e5717e42..70da4113c2baf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -785,9 +785,8 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	ASSERT(blkno == 0);
 	error = xfs_attr3_leaf_create(args, blkno, &bp);
 	if (error) {
-		error = xfs_da_shrink_inode(args, 0, bp);
-		bp = NULL;
-		if (error)
+		/* xfs_attr3_leaf_create may not have instantiated a block */
+		if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))
 			goto out;
 		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
 		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */
-- 
2.25.1



