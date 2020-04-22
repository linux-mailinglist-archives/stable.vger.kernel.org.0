Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B0A1B3F2F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgDVKf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgDVKXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E522A2071E;
        Wed, 22 Apr 2020 10:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551012;
        bh=micotk57/YyCbC9O+mxgFISmiIDBkthE9XBBlTkxP7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkhhVBNyMgjIVI6iepKoaDwSPCK6omcjzTXd8hbuHDNQBgq+u2Hh8ZD0ng4GzGsLl
         +OFi3A3UO3Eh1PmSYa+GKI30qUO7DigJoTUEwC32en2H2e0qe4e3UQcw7raTnWr5yP
         eP1/mikO/bOeDe4SMGxf0LL7vXir1F524hpcP2HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 063/166] xfs: fix use-after-free when aborting corrupt attr inactivation
Date:   Wed, 22 Apr 2020 11:56:30 +0200
Message-Id: <20200422095055.594423338@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 496b9bcd62b0b3a160be61e3265a086f97adcbd3 ]

Log the corrupt buffer before we release the buffer.

Fixes: a5155b870d687 ("xfs: always log corruption errors")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_inactive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bbfa6ba84dcd7..fe8f60b59ec4d 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -145,8 +145,8 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		xfs_buf_corruption_error(bp);
+		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
 
-- 
2.20.1



