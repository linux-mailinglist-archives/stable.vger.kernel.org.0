Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4923D29B9AC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802701AbgJ0Puz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802360AbgJ0Pqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 238A321D42;
        Tue, 27 Oct 2020 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813594;
        bh=xrA56hjdrbI8BUc+er5VFpNcBhxlUCv4ku6YAz/YQxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOie0iS/42jEfRmHbgKU52GHAKNQ471nk9JD7bb2Z29LrqwewG9SLtTVPa4uJJx0X
         UPCdzGOc9O3BcXeYaE3WWdJkjo38O4vyAQevF/ynYIzWNx877KTEsWwjv2fCAiT41Y
         1V6KtByNevinWfPfGHYHnNgC4tQJxI2IG93Wlh8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 577/757] vdpa/mlx5: Make use of a specific 16 bit endianness API
Date:   Tue, 27 Oct 2020 14:53:47 +0100
Message-Id: <20201027135517.580594765@linuxfoundation.org>
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

[ Upstream commit 36bdcf318bc21af24de10b68e32cdea6b9a8d17f ]

Introduce a dedicated function to be used for setting 16 bit fields per
virio endianness requirements and use it to set the mtu field.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20200917121425.GA98139@mtl-vdi-166.wap.labs.mlnx
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 74264e5906951..56228467d7ec6 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1522,6 +1522,11 @@ static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
 }
 
+static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
+{
+	return __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev), val);
+}
+
 static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
@@ -1535,8 +1540,7 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 		return err;
 
 	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
-	ndev->config.mtu = __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mvdev),
-					     ndev->mtu);
+	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
 	return err;
 }
 
-- 
2.25.1



