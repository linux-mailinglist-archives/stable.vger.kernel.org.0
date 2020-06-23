Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ABB20658B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbgFWUFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388341AbgFWUFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:05:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52B8C206C3;
        Tue, 23 Jun 2020 20:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942718;
        bh=JMvlUhCjrGlUQV8cZmG5Jqmr1/kiIi4DV2YpJduhak4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0UsKnSBvq4zPn39NDUOAQYDXiFsFfFa8cAuLLB6hP4p2ARUUTRgyGAFGUcHBneSx
         vltCN+WWz73Hg+HrkHUYev2Zv3kGxyphAmrbgVPh7svUQASTRSwVpIgOE+S0/f5Ueh
         yE3iYmehPRK6B6H64LDU8Du0aT0WA6/uUq9F8FNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 101/477] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Tue, 23 Jun 2020 21:51:38 +0200
Message-Id: <20200623195412.362739481@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 8cc0072469723459dc6bd7beff81b2b3149f4cf4 ]

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29d..8845faa8161a9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2639,8 +2639,10 @@ xfs_ifree_cluster(
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
 				mp->m_bsize * igeo->blocks_per_cluster,
 				XBF_UNMAPPED, &bp);
-		if (error)
+		if (error) {
+			xfs_perag_put(pag);
 			return error;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we
-- 
2.25.1



