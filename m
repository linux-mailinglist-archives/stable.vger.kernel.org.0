Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C4451E12
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354751AbhKPAfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344534AbhKOTY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACDB563490;
        Mon, 15 Nov 2021 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002767;
        bh=v+Q0hMj+CzyYjXFSdfpzCJ5UeoWx5JFwDBjYlUuOn4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yM1IDkJLIPOnSEZ3ZZS6hRC84mZdo0t45LZhaz8FwqEaqQ1OGgtPXD3LozMliOhUl
         uz7G1S2qw+sEOWSwcbb1x9c9bC16pmlOV+5NHKMkAdgI3Qtq0T4/2sVQLMF+Byz2A1
         GWjM+/z7u6JdjNxIRPqcYri4gtLmTNJ9F7KLJdd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 689/917] vdpa/mlx5: Fix clearing of VIRTIO_NET_F_MAC feature bit
Date:   Mon, 15 Nov 2021 18:03:04 +0100
Message-Id: <20211115165452.256711711@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit ef76eb83a17e803a66b64ac95b36ae48b3d17c22 ]

Cited patch in the fixes tag clears the features bit during reset.
mlx5 vdpa device feature bits are static decided by device capabilities.
These feature bits (including VIRTIO_NET_F_MAC) are initialized during
device addition time.

Clearing features bit in reset callback cleared the VIRTIO_NET_F_MAC. Due
to this, MAC address provided by the device is not honored.

Fix it by not clearing the static feature bits during reset.

Fixes: 0686082dbf7a ("vdpa: Add reset callback in vdpa_config_ops")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20211026175519.87795-7-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index bd56de7484dcb..ae85d2dd6eb76 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2192,7 +2192,6 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	clear_vqs_ready(ndev);
 	mlx5_vdpa_destroy_mr(&ndev->mvdev);
 	ndev->mvdev.status = 0;
-	ndev->mvdev.mlx_features = 0;
 	memset(ndev->event_cbs, 0, sizeof(ndev->event_cbs));
 	ndev->mvdev.actual_features = 0;
 	++mvdev->generation;
-- 
2.33.0



