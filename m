Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AB73CE567
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348850AbhGSPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347473AbhGSPpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225D661166;
        Mon, 19 Jul 2021 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711993;
        bh=scFsY1NGDBz0F+RDxTz8nFdjYLG0Qt4hPIotrS/R4x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqRxXpP7X/pz3GuI5NXVLv+6LKAxFm6FknT6Zt2ex2q+X5NEW2wgjPwp5ehgDNBIG
         c6fwaRBxAM3/wYqtffL98fJ1RmTo2aBs5gOz7PAfuA/207RMqIAen/Gp7WjJp8D3F7
         tJzJAFfbEVuzjTK09IfDKzl0I3oD7Ad8+CBeDyFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 209/292] vdpa/mlx5: Fix possible failure in umem size calculation
Date:   Mon, 19 Jul 2021 16:54:31 +0200
Message-Id: <20210719144949.872070943@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 71ab6a7cfbae27f86a3901daab10bfe13b3a1e3a ]

umem size is a 32 bit unsigned value so assigning it to an int could
cause false failures. Set the calculated value inside the function and
modify function name to reflect the fact it updates the size.

This bug was found during code review but never had real impact to this
date.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210530090349.8360-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index fc7834a34695..d5ea956a3a3a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -611,8 +611,8 @@ static void cq_destroy(struct mlx5_vdpa_net *ndev, u16 idx)
 	mlx5_db_free(ndev->mvdev.mdev, &vcq->db);
 }
 
-static int umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int num,
-		     struct mlx5_vdpa_umem **umemp)
+static void set_umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int num,
+			  struct mlx5_vdpa_umem **umemp)
 {
 	struct mlx5_core_dev *mdev = ndev->mvdev.mdev;
 	int p_a;
@@ -635,7 +635,7 @@ static int umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		*umemp = &mvq->umem3;
 		break;
 	}
-	return p_a * mvq->num_ent + p_b;
+	(*umemp)->size = p_a * mvq->num_ent + p_b;
 }
 
 static void umem_frag_buf_free(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_umem *umem)
@@ -651,15 +651,10 @@ static int create_umem(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
 	void *in;
 	int err;
 	__be64 *pas;
-	int size;
 	struct mlx5_vdpa_umem *umem;
 
-	size = umem_size(ndev, mvq, num, &umem);
-	if (size < 0)
-		return size;
-
-	umem->size = size;
-	err = umem_frag_buf_alloc(ndev, umem, size);
+	set_umem_size(ndev, mvq, num, &umem);
+	err = umem_frag_buf_alloc(ndev, umem, umem->size);
 	if (err)
 		return err;
 
-- 
2.30.2



