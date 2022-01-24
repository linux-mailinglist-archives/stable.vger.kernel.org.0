Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E861499B5D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575225AbiAXVvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53258 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378844AbiAXVoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D439B811FC;
        Mon, 24 Jan 2022 21:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49527C340E4;
        Mon, 24 Jan 2022 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060641;
        bh=toS2nEL/HovX5hqVgGICDP1uLl/XeY10V55n1+2q4Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK3kCltUOeNehVC9TStqaJT6nH3aqZdCkJSog0K56fv8KhyrieVxnkzoTxzg8hErR
         oLnsj0xmlxTerWi0LzTG9kP04p4oHx3O3KKhHVS6ftaC/y8tnBy77XGc/aNvvnwsoo
         GuF/TtS9+LJE1XFGzUSqqKyW/eamoHzx4G1dvMyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH 5.16 0982/1039] vdpa/mlx5: Fix wrong configuration of virtio_version_1_0
Date:   Mon, 24 Jan 2022 19:46:11 +0100
Message-Id: <20220124184158.288162031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -876,8 +876,6 @@ static int create_virtqueue(struct mlx5_
 	MLX5_SET(virtio_q, vq_ctx, umem_3_id, mvq->umem3.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_3_size, mvq->umem3.size);
 	MLX5_SET(virtio_q, vq_ctx, pd, ndev->mvdev.res.pdn);
-	if (MLX5_CAP_DEV_VDPA_EMULATION(ndev->mvdev.mdev, eth_frame_offload_type))
-		MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0, 1);
 
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)


