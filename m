Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E635BED2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbhDLJCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239133AbhDLI7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A030A61364;
        Mon, 12 Apr 2021 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217852;
        bh=bhvO43K6f4r1uoYFPUurnhM7Aa72C3l7WMvga48OFkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCZ56HEaUQEpQNuRVl4FfEeieZUV1CfyDHDjibJtNijDCxAvCuznLBr0Z+qD+RxSC
         93H/AsYrDim/crciQEwh4KVtwKITvHa+IfbYbY/NKBcLhuhfzctSfZO5Q5VbmKCP5y
         pmr6pud8+Q8TdFmuFyD+8egJ4uSJ2p/XrkBikf8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/188] vdpa/mlx5: should exclude header length and fcs from mtu
Date:   Mon, 12 Apr 2021 10:41:21 +0200
Message-Id: <20210412084019.180438378@linuxfoundation.org>
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

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit d084d996aaf53c0cc583dc75a4fc2a67fe485846 ]

When feature VIRTIO_NET_F_MTU is negotiated on mlx5_vdpa,
22 extra bytes worth of MTU length is shown in guest.
This is because the mlx5_query_port_max_mtu API returns
the "hardware" MTU value, which does not just contain the
 Ethernet payload, but includes extra lengths starting
from the Ethernet header up to the FCS altogether.

Fix the MTU so packets won't get dropped silently.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210408091047.4269-2-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 08f742fd2409..b6cc53ba980c 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -4,9 +4,13 @@
 #ifndef __MLX5_VDPA_H__
 #define __MLX5_VDPA_H__
 
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/vdpa.h>
 #include <linux/mlx5/driver.h>
 
+#define MLX5V_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
+
 struct mlx5_vdpa_direct_mr {
 	u64 start;
 	u64 end;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 36e5933f11bc..545160ee2a62 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1887,6 +1887,19 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.free = mlx5_vdpa_free,
 };
 
+static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
+{
+	u16 hw_mtu;
+	int err;
+
+	err = mlx5_query_nic_vport_mtu(mdev, &hw_mtu);
+	if (err)
+		return err;
+
+	*mtu = hw_mtu - MLX5V_ETH_HARD_MTU;
+	return 0;
+}
+
 static int alloc_resources(struct mlx5_vdpa_net *ndev)
 {
 	struct mlx5_vdpa_net_resources *res = &ndev->res;
@@ -1969,7 +1982,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 	init_mvqs(ndev);
 	mutex_init(&ndev->reslock);
 	config = &ndev->config;
-	err = mlx5_query_nic_vport_mtu(mdev, &ndev->mtu);
+	err = query_mtu(mdev, &ndev->mtu);
 	if (err)
 		goto err_mtu;
 
-- 
2.30.2



