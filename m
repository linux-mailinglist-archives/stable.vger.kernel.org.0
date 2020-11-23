Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB232C072E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732074AbgKWMiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732071AbgKWMiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A9620888;
        Mon, 23 Nov 2020 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135094;
        bh=WEx00jfl0w7WAFmhjq18LKjOtYIfeZ6kyBaWuxStlBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXpmgs9tRP3Kk4kooICBcehhKbjmnHGBJs9tNmmDEnBfnw7f1C/+/welf03TNOFyc
         WB+FCLO3f9dnBfNI0k+xNs74vomsu/JpXi4b8I+KcQnD4nff6bAmZRIiTvim2AvHMQ
         uDiwBtpLkXuBkG7s01RGfO2RUW4/9e4+n6LBrfIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/158] xfs: return corresponding errcode if xfs_initialize_perag() fail
Date:   Mon, 23 Nov 2020 13:22:11 +0100
Message-Id: <20201123121824.904549934@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 595189c25c28a55523354336bf24453242c81c15 ]

In xfs_initialize_perag(), if kmem_zalloc(), xfs_buf_hash_init(), or
radix_tree_preload() failed, the returned value 'error' is not set
accordingly.

Reported-as-fixing: 8b26c5825e02 ("xfs: handle ENOMEM correctly during initialisation of perag structures")
Fixes: 9b2471797942 ("xfs: cache unlinked pointers in an rhashtable")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_mount.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88a..5a0ce0c2c4bbd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -195,21 +195,26 @@ xfs_initialize_perag(
 		}
 
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
-		if (!pag)
+		if (!pag) {
+			error = -ENOMEM;
 			goto out_unwind_new_pags;
+		}
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		if (xfs_buf_hash_init(pag))
+
+		error = xfs_buf_hash_init(pag);
+		if (error)
 			goto out_free_pag;
 		init_waitqueue_head(&pag->pagb_wait);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 
-		if (radix_tree_preload(GFP_NOFS))
+		error = radix_tree_preload(GFP_NOFS);
+		if (error)
 			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
-- 
2.27.0



