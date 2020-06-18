Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B041FE83C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgFRCrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgFRBKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCEF214DB;
        Thu, 18 Jun 2020 01:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442623;
        bh=jplWrG6bk/PzGY0EE3Y+lK5ZNOODKNsKti9Z3BApBr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRAYCS3NkeeuzetBi+y7fUdvnJwMWnM7ZMyP5jly6rP5jYGLu/gEQTFIuls+Ts4dN
         g8JgtKZCwcBPuWWOTSFVe7zoOdYyFn8tvP+eFIzN+77gvqTW8aXQGEwNn9UspgDqxf
         Nja2SMLAKuA59j4gHcV2l8D2L+XJKDI0gIDocAOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 102/388] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Wed, 17 Jun 2020 21:03:19 -0400
Message-Id: <20200618010805.600873-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d1772786af29..8845faa8161a 100644
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

