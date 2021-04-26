Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267FC36AEB9
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhDZHqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234096AbhDZHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D07613DB;
        Mon, 26 Apr 2021 07:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422884;
        bh=yYQ35UFsN6lIVZLWVcqNdSHHVQg1aI81kONed6NZS6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lKHueayP+al12ZJJ0ricmwsQUlO/icO38PedONDNzPB0gImroaKfnHneyhfk3m68
         /vjEFs61vcMyiHw5uE/lTYehpyCDvBFutg1Tbq0CRsPzCd0VXsS1t46h8Nh4tvZ4Qs
         1P4dL5dECoXfogpQkhKJpyEW3xmfg3vTEm/sdZwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 09/41] vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails
Date:   Mon, 26 Apr 2021 09:29:56 +0200
Message-Id: <20210426072820.002618140@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit be286f84e33da1a7f83142b64dbd86f600e73363 ]

Set err = -ENOMEM if dma_map_sg_attrs() fails so the function reutrns
error.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210411083646.910546-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index d300f799efcd..aa656f57bf5b 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -273,8 +273,10 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	mr->log_size = log_entity_size;
 	mr->nsg = nsg;
 	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
-	if (!mr->nent)
+	if (!mr->nent) {
+		err = -ENOMEM;
 		goto err_map;
+	}
 
 	err = create_direct_mr(mvdev, mr);
 	if (err)
-- 
2.30.2



