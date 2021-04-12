Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F2B35BED9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbhDLJCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239163AbhDLI7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1120761243;
        Mon, 12 Apr 2021 08:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217854;
        bh=B3Z+kegQ/q0iCRikUQByQLt78kbiA/6W0nX6/k83WJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3ieWZ2RylELCJFgjLQ1RE9+IXNHlRBg99yPOW6cerXZukMwSYBI5YAD0Q5tVKDC6
         sOGNsiRZbbfvBgoWE6KfP9pLr7mg/h8gqKHdNzTEjxnwEne0Ca++Y+bkNklssNwk5i
         ATY2m6pIqmwnxoRRMBna/s+1RTt3pZGqHSJwiQN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/188] vdpa/mlx5: Fix wrong use of bit numbers
Date:   Mon, 12 Apr 2021 10:41:22 +0200
Message-Id: <20210412084019.220334209@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 4b454a82418dd76d8c0590bb3f7a99a63ea57dc5 ]

VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
conditionals.

Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
the rest of the code.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210408091047.4269-5-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 545160ee2a62..65cfbd377130 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -805,7 +805,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
 	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
 	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
-		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
+		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
@@ -1535,7 +1535,7 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
 	return virtio_legacy_is_little_endian() ||
-		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
+		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
 }
 
 static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
-- 
2.30.2



