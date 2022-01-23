Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C410496EB5
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiAWANy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiAWANG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:13:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE1BC06175F;
        Sat, 22 Jan 2022 16:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D45B80927;
        Sun, 23 Jan 2022 00:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ED4C004E1;
        Sun, 23 Jan 2022 00:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896724;
        bh=FZdORr6n1v/yWRKN8gy/VklB3+rU/+xBNX36oDx/RLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEZB0iXg7942aPGfHf/UtfJupOZwHKJERHV6OwGOgXmFJMR9nf1+HPHhfpTHZMIue
         4Z19V+KIzMsRS95ksG4jI0vp7kJZMzzOq2zD/rcpdSQElI++Zi51BfBfpbwuuWpCXa
         pck7TeTTWEUTjt3BJim7eVMSfjhnF0TBwp/AKRhyHgnbS8NxznxUnfEQHG7sp5GDe1
         IayYe0gbpB8nXtfeC4GYQrtuaGUPYqmmZ2HSfWWk/76VOULjGsVZ4H1IEIfHVWiqEh
         FuEmX+7UnMe4IEb7rVtfI/8w8349doUBuWdJAxkjyRGi48EiFHRJdKCKHLYRLLhDxY
         Am9aZMKElD4Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Sasha Levin <sashal@kernel.org>, parav@nvidia.com,
        xieyongji@bytedance.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 13/19] net/mlx5_vdpa: Offer VIRTIO_NET_F_MTU when setting MTU
Date:   Sat, 22 Jan 2022 19:11:06 -0500
Message-Id: <20220123001113.2460140-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 60af39c1f4cc92cc2785ef745c0c97558134d539 ]

Make sure to offer VIRTIO_NET_F_MTU since we configure the MTU based on
what was queried from the device.

This allows the virtio driver to allocate large enough buffers based on
the reported MTU.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20211124170949.51725-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 63813fbb5f62a..d8e69340a25ae 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1895,6 +1895,7 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_CTRL_MAC_ADDR);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MQ);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_STATUS);
+	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MTU);
 
 	print_features(mvdev, ndev->mvdev.mlx_features, false);
 	return ndev->mvdev.mlx_features;
-- 
2.34.1

