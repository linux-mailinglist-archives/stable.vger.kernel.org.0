Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6B73CE400
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbhGSPlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347643AbhGSPfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D91C61585;
        Mon, 19 Jul 2021 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711161;
        bh=3VbulVuZux7N5vm4eGkeSfR/Q6TdIl8kVzV8A7gfNGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJau3smF/Oi8bwTHIuwPApBDvQ4A2rZa3WQJ7W+cw/2Uxh34c7PpGT44P1Rd6xDI8
         Lk+D3+ZMoaB1f2NNPwVfpvoK9ovU1Megk5VE+CdjHhjym1nyd349PY5VwZAcOWBfUd
         Xg3rTgH/ARKEDCJGHOxOn13unHGlA0b2W7ypgm3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 251/351] vdpa/mlx5: Fix possible failure in umem size calculation
Date:   Mon, 19 Jul 2021 16:53:17 +0200
Message-Id: <20210719144953.261442638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index e8865e6adf37..01eb6c100d2d 100644
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



