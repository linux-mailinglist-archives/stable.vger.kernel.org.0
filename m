Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202053C4B56
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbhGLG4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239035AbhGLGt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B3C061289;
        Mon, 12 Jul 2021 06:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072345;
        bh=t+jresWZQupaAwt3R2oqvu3vRilrsFqM2IFw6eJD0sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyZJIlCYpDQKdTv1nnHumFgoefWW+T0SIIIo5we169C0Ma0qS3yOSB43jfoQ+7D0F
         Noemrbn+RSTwtPdGP1pQs+d5iZwAnPl/GNjxQa1JWpefBqSVak6TSnX/NR0ZaDE/9+
         vfcwoyABZprBptn/ZPwHM/SjzYHgrqgpTU4OtrKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/593] RDMA/core: Always release restrack object
Date:   Mon, 12 Jul 2021 08:09:51 +0200
Message-Id: <20210712060935.932124547@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index be4e447134b3..0c879e40bd18 100644
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



