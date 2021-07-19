Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF01E3CE166
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349200AbhGSPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347655AbhGSPUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA2F6140E;
        Mon, 19 Jul 2021 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710342;
        bh=msz6kQGMxwihYwKqvmiGMzNq4gvtPtrGbyd0fbVlsw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFOqRfj+FAkX0u+LjmEa20qCYyWC1pYD/F52KY1pKwEM0yFMGWN6kdJymW9eOia8T
         b+mia38ipAELn36cR7NfB2yc8dJz0h2vz+rylos+7cMYbmFBVSnXXpJURkjFt6oLOl
         0UXaZsidy8NaOkuGWh739LrVgFP7xCK4SAuUSnSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/243] vdpa/mlx5: Fix possible failure in umem size calculation
Date:   Mon, 19 Jul 2021 16:53:24 +0200
Message-Id: <20210719144946.555350354@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index ef76cfedcd79..5773b68f9a93 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -596,8 +596,8 @@ static void cq_destroy(struct mlx5_vdpa_net *ndev, u16 idx)
 	mlx5_db_free(ndev->mvdev.mdev, &vcq->db);
 }
 
-static int umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int num,
-		     struct mlx5_vdpa_umem **umemp)
+static void set_umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int num,
+			  struct mlx5_vdpa_umem **umemp)
 {
 	struct mlx5_core_dev *mdev = ndev->mvdev.mdev;
 	int p_a;
@@ -620,7 +620,7 @@ static int umem_size(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		*umemp = &mvq->umem3;
 		break;
 	}
-	return p_a * mvq->num_ent + p_b;
+	(*umemp)->size = p_a * mvq->num_ent + p_b;
 }
 
 static void umem_frag_buf_free(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_umem *umem)
@@ -636,15 +636,10 @@ static int create_umem(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
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



