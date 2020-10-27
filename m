Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98A29BFAF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816436AbgJ0RGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509806AbgJ0PGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B96C2242E;
        Tue, 27 Oct 2020 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811197;
        bh=NSZcLyLc+lG2Lh4QM+0BGVdUbjTSQ1T5XemTD61W+PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnG2MTWmHnh6QX8MYnsHN0D57ukcB/CfDT8SRVqBLhLr4zeDQr/tqDAIoR7s8JIqe
         NgYpH/v/UKygAHBAkdyLOBJtbhHu3xVJh9/ut61bA74ymKn2xAONgAo4RaJdr9TWXa
         q9TsdUgCjgfkwFxSy/s7qAjvW0uWDQfEemQ1M5YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 380/633] RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR cant work
Date:   Tue, 27 Oct 2020 14:52:03 +0100
Message-Id: <20201027135540.533647109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 6f99ed03d88e7..1f4aa2647a6f3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -867,7 +867,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
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



