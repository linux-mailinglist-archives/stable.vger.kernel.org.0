Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E43C4F18
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244854AbhGLHXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344226AbhGLHUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338EA61153;
        Mon, 12 Jul 2021 07:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074256;
        bh=8gW7JFX5rK52QRputCNKEUye20hYvArEIkpGCgB/JgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5EMPHF3czmmtAU4SY0Lc1sfpGQilbuwf2ETiw0O/ZFHTBX7Vjj771HIgaQSM1kRh
         RVEdGJKoFAI9YUCbxZvG4TmqEy1mkuFTFyJKt4r2+xyRhjpTvV+qb4uTzBDBfQ7nB/
         2U+glWhzxM7XI0OKMHKUb8PEWi0ZuF3A/rMy5gyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 517/700] RDMA/core: Always release restrack object
Date:   Mon, 12 Jul 2021 08:10:00 +0200
Message-Id: <20210712061031.488968752@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 3d8287544223a3d2f37981c1f9ffd94d0b5e9ffc ]

Change location of rdma_restrack_del() to fix the bug where
task_struct was acquired but not released, causing to resource leak.

  ucma_create_id() {
    ucma_alloc_ctx();
    rdma_create_user_id() {
      rdma_restrack_new();
      rdma_restrack_set_name() {
        rdma_restrack_attach_task.part.0(); <--- task_struct was gotten
      }
    }
    ucma_destroy_private_ctx() {
      ucma_put_ctx();
      rdma_destroy_id() {
        _destroy_id()                       <--- id_priv was freed
      }
    }
  }

Fixes: 889d916b6f8a ("RDMA/core: Don't access cm_id after its destruction")
Link: https://lore.kernel.org/r/073ec27acb943ca8b6961663c47c5abe78a5c8cc.1624948948.git.leonro@nvidia.com
Reported-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 68bbcecb0a6a..bb46f794f324 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1856,6 +1856,7 @@ static void _destroy_id(struct rdma_id_private *id_priv,
 {
 	cma_cancel_operation(id_priv, state);
 
+	rdma_restrack_del(&id_priv->res);
 	if (id_priv->cma_dev) {
 		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
@@ -1865,7 +1866,6 @@ static void _destroy_id(struct rdma_id_private *id_priv,
 				iw_destroy_cm_id(id_priv->cm_id.iw);
 		}
 		cma_leave_mc_groups(id_priv);
-		rdma_restrack_del(&id_priv->res);
 		cma_release_dev(id_priv);
 	}
 
-- 
2.30.2



