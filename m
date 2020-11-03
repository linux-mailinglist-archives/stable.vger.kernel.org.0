Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FBC2A52BF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbgKCUwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbgKCUwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC6C22226;
        Tue,  3 Nov 2020 20:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436770;
        bh=JBaCx8sNsgI2+hW/u7K6XjkgDbpF9jMGNnZWhz2w7uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rW6wQ4UE9MaIaXy/DWDBNLIa3jSXRORPhc6aW5URCVQ4Tgdu0FHcbf2bl2HgZfU2h
         UCIB4/nJOWmNwzyIgw0bjQqLhFkDUF4E67wXU2u3pVMO+R1TvlSSFuFzG42Eyg+S5p
         OPH0cZuDJPd9FX1MYqaIM0/+SZ9t9y6yu87M7n8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.9 388/391] vdpa/mlx5: Fix error return in map_direct_mr()
Date:   Tue,  3 Nov 2020 21:37:19 +0100
Message-Id: <20201103203413.345130932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

commit 7ba08e81cb4aec9724ab7674a5de49e7a341062c upstream.

Fix to return the variable "err" from the error handling case instead
of "ret".

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: https://lore.kernel.org/r/20201026070637.164321-1-jingxiangfeng@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vdpa/mlx5/core/mr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -239,7 +239,6 @@ static int map_direct_mr(struct mlx5_vdp
 	u64 paend;
 	struct scatterlist *sg;
 	struct device *dma = mvdev->mdev->device;
-	int ret;
 
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
 	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
@@ -277,8 +276,8 @@ static int map_direct_mr(struct mlx5_vdp
 done:
 	mr->log_size = log_entity_size;
 	mr->nsg = nsg;
-	ret = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
-	if (!ret)
+	err = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
+	if (!err)
 		goto err_map;
 
 	err = create_direct_mr(mvdev, mr);


