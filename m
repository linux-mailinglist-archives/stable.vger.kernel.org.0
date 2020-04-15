Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E209C1AA3F8
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370683AbgDONPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897036AbgDOLfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9AC420768;
        Wed, 15 Apr 2020 11:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950516;
        bh=1lEjVxhZiFoWNUrfREis8BxN3QnlAH5bJf6GvtAppkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krIP8K+RPft1qae/I4kuN6sfs+4KypAle6osEn9Wmiqxs+73l3AMGGlZ0sv5ExaQA
         6ByR/yZDe8c+Dq+K2Zw/HRxXcxevByldoarnRrG6XqasIUWjBvtGSj8u3IXk+rzzkq
         faMAMBQlgpcra3ZW3zryVZAL+5dceswwkZCbZsGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 026/129] xfs: fix use-after-free when aborting corrupt attr inactivation
Date:   Wed, 15 Apr 2020 07:33:01 -0400
Message-Id: <20200415113445.11881-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

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

