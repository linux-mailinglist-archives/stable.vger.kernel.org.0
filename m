Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1E224B591
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgHTKZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731717AbgHTKZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:25:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 467AA2075E;
        Thu, 20 Aug 2020 10:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919127;
        bh=WuWUFoM8glOjWZTJLhMfKnsgfVWQ7Vo3QZ4kDFUqIRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIGqP6QAB0ADSO5hzPWm1fE3Q3Lo3pCeW5lIAIuYXGgQZ8N3+eHu/OYBlWC1bF1Gw
         pAFQ3MNWNAHVXFd4L3zVHrI8otgEjcc+dyBAaoZtXLra3Q4pHwOMW0dR7gHKpsgDCs
         tUisIFQ+MBBiSO4yJjL5k8tUa5AuuOTdqGHj0GUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xu, Wen" <wen.xu@gatech.edu>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 001/149] xfs: dont call xfs_da_shrink_inode with NULL bp
Date:   Thu, 20 Aug 2020 11:21:18 +0200
Message-Id: <20200820092125.757209674@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index 01a5ecfedfcf1..445a3f2f871fb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -779,9 +779,8 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
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



