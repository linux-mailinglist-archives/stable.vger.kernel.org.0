Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0777329B9B2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802732AbgJ0PvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802366AbgJ0Pqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D12F22202;
        Tue, 27 Oct 2020 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813611;
        bh=yXqeFP9waseVng23oKDHhwTymLtY0AP+P7lpYFpfHfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLOhYJDUafF6AC8Fu72DtxwsX1D5p8AdRRD6SKkZ7NUoaiZOVFyG+zeD+6uw9FXSO
         OEh2D8MoVE6nHpFljWFbX2VIPDKGDepTI9GwjUscdyCHlo3HCyDB5LxQkfuDWhOZh8
         vvNj44EgpPBNzdBiGT2mm2wMjNSUpSC/O32YkgS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 579/757] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Date:   Tue, 27 Oct 2020 14:53:49 +0100
Message-Id: <20201027135517.678689514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 1897f0b618b0af0eb9dca709ab6bdf9ef1969ef7 ]

set_map() is used by mlx5 vdpa to create a memory region based on the
address map passed by the iotlb argument. If we get successive calls, we
will destroy the current memory region and build another one based on
the new address mapping. We also need to setup the hardware resources
since they depend on the memory region.

If these calls happen before DRIVER_OK, It means that driver VQs may
also not been setup and we may not create them yet. In this case we want
to avoid setting up the other resources and defer this till we get
DRIVER OK.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 5ca309473c03d..1fa6fcac82992 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1658,6 +1658,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net *ndev, struct vhost_iotlb *
 	if (err)
 		goto err_mr;
 
+	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
+		return 0;
+
 	restore_channels_info(ndev);
 	err = setup_driver(ndev);
 	if (err)
-- 
2.25.1



