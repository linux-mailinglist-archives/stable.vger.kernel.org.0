Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2AB313772
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhBHPZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhBHPVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8245464EC2;
        Mon,  8 Feb 2021 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797197;
        bh=1wh2SZt/l9pZZ/jxoLAU/qBcAQbzhJXCWuKKMHDw0i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/utp6P/T+sEr4MaXpxJsybL8Oj6CSalF+/SIQ0kNH2rk0sxfZ3qoOjLJyonSgtHc
         XhJQeo9ARmU0VAn7LIU79YcAP9TKzS0n5BRYLWKECDdY3v54Xu2F0w1ub6hb6/G7C4
         9OAuH0aot7sCrv2oFgVVgONgY30cjNIZj16OlGQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/120] vdpa/mlx5: Fix memory key MTT population
Date:   Mon,  8 Feb 2021 16:00:12 +0100
Message-Id: <20210208145819.406738156@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 710eb8e32d04714452759f2b66884bfa7e97d495 ]

map_direct_mr() assumed that the number of scatter/gather entries
returned by dma_map_sg_attrs() was equal to the number of segments in
the sgl list. This led to wrong population of the mkey object. Fix this
by properly referring to the returned value.

The hardware expects each MTT entry to contain the DMA address of a
contiguous block of memory of size (1 << mr->log_size) bytes.
dma_map_sg_attrs() can coalesce several sg entries into a single
scatter/gather entry of contiguous DMA range so we need to scan the list
and refer to the size of each s/g entry.

In addition, get rid of fill_sg() which effect is overwritten by
populate_mtts().

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210107071845.GA224876@mtl-vdi-166.wap.labs.mlnx
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
 drivers/vdpa/mlx5/core/mr.c        | 28 ++++++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 5c92a576edae8..08f742fd24099 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -15,6 +15,7 @@ struct mlx5_vdpa_direct_mr {
 	struct sg_table sg_head;
 	int log_size;
 	int nsg;
+	int nent;
 	struct list_head list;
 	u64 offset;
 };
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 4b6195666c589..d300f799efcd1 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -25,17 +25,6 @@ static int get_octo_len(u64 len, int page_shift)
 	return (npages + 1) / 2;
 }
 
-static void fill_sg(struct mlx5_vdpa_direct_mr *mr, void *in)
-{
-	struct scatterlist *sg;
-	__be64 *pas;
-	int i;
-
-	pas = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
-	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
-		(*pas) = cpu_to_be64(sg_dma_address(sg));
-}
-
 static void mlx5_set_access_mode(void *mkc, int mode)
 {
 	MLX5_SET(mkc, mkc, access_mode_1_0, mode & 0x3);
@@ -45,10 +34,18 @@ static void mlx5_set_access_mode(void *mkc, int mode)
 static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
 {
 	struct scatterlist *sg;
+	int nsg = mr->nsg;
+	u64 dma_addr;
+	u64 dma_len;
+	int j = 0;
 	int i;
 
-	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
-		mtt[i] = cpu_to_be64(sg_dma_address(sg));
+	for_each_sg(mr->sg_head.sgl, sg, mr->nent, i) {
+		for (dma_addr = sg_dma_address(sg), dma_len = sg_dma_len(sg);
+		     nsg && dma_len;
+		     nsg--, dma_addr += BIT(mr->log_size), dma_len -= BIT(mr->log_size))
+			mtt[j++] = cpu_to_be64(dma_addr);
+	}
 }
 
 static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
@@ -64,7 +61,6 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
 		return -ENOMEM;
 
 	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
-	fill_sg(mr, in);
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, lw, !!(mr->perm & VHOST_MAP_WO));
 	MLX5_SET(mkc, mkc, lr, !!(mr->perm & VHOST_MAP_RO));
@@ -276,8 +272,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 done:
 	mr->log_size = log_entity_size;
 	mr->nsg = nsg;
-	err = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
-	if (!err)
+	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
+	if (!mr->nent)
 		goto err_map;
 
 	err = create_direct_mr(mvdev, mr);
-- 
2.27.0



