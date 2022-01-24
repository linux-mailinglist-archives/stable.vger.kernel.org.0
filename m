Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23D3499594
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442089AbiAXUxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43884 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391988AbiAXUuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB05860C2A;
        Mon, 24 Jan 2022 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB58C340E5;
        Mon, 24 Jan 2022 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057410;
        bh=rTzjsPOM+kVOAAhf7w4z3TQ9XVsck917kVkeBLIXDsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRof/DEkF/7ryjJKdcOfyk8T6sz09DFgp5FAiAwJI44xEoIQF3bChx5itjwTrA+kb
         SMFd1cp05+Cz0gA2HbJVdq+SMfo9Bv3yYrmhDnv/kWnk3dmBDUIeCkg1UgJ5fznG19
         AxwSlsmli4HbEODkUMzJhQrqBmE40qLJO25b/PQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH 5.15 804/846] vdpa/mlx5: Fix wrong configuration of virtio_version_1_0
Date:   Mon, 24 Jan 2022 19:45:21 +0100
Message-Id: <20220124184128.673051881@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit 97143b70aa847f2b0a1f959dde126b76ff7b5376 upstream.

Remove overriding of virtio_version_1_0 which forced the virtqueue
object to version 1.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20211230142024.142979-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -873,8 +873,6 @@ static int create_virtqueue(struct mlx5_
 	MLX5_SET(virtio_q, vq_ctx, umem_3_id, mvq->umem3.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_3_size, mvq->umem3.size);
 	MLX5_SET(virtio_q, vq_ctx, pd, ndev->mvdev.res.pdn);
-	if (MLX5_CAP_DEV_VDPA_EMULATION(ndev->mvdev.mdev, eth_frame_offload_type))
-		MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0, 1);
 
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)


