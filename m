Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC629B237
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761363AbgJ0OjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761356AbgJ0OjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B33122202;
        Tue, 27 Oct 2020 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809544;
        bh=kZ4b+RhcBaSFZcTfvOjhmSoh8yL7IF33IxzpOUkc0ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzZL9Ig7fl5l5hOmOLY4I7aQcswlCl7iN7/nUMtBXTfuFtGNUnY9cw/J7tTqmADhL
         v6sdJNrkFjlSyNcj5KUvdvn7tAAMy0FMjMCPGeyjL+u5p6piIpN3HT7sVOQf6j71uq
         PyWLv22kjFahKkeftzx+omg+LbN76HumWa4pQr4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 233/408] RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR cant work
Date:   Tue, 27 Oct 2020 14:52:51 +0100
Message-Id: <20201027135505.868624127@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 0ec52f0194638e2d284ad55eba5a7aff753de1b9 ]

set_reg_wr() always fails if !umr_modify_entity_size_disabled because
mlx5_ib_can_use_umr() always fails. Without set_reg_wr() IB_WR_REG_MR
doesn't work and that means the device should not advertise
IB_DEVICE_MEM_MGT_EXTENSIONS.

Fixes: 841b07f99a47 ("IB/mlx5: Block MR WR if UMR is not possible")
Link: https://lore.kernel.org/r/20200914112653.345244-5-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b781ad74e6de4..40c1a05c2445d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -888,7 +888,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		/* We support 'Gappy' memory registration too */
 		props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
 	}
-	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	/* IB_WR_REG_MR always requires changing the entity size with UMR */
+	if (!MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	if (MLX5_CAP_GEN(mdev, sho)) {
 		props->device_cap_flags |= IB_DEVICE_INTEGRITY_HANDOVER;
 		/* At this stage no support for signature handover */
-- 
2.25.1



