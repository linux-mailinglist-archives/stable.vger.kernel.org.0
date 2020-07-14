Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E5321FA3E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgGNSux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgGNSux (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B5522B3F;
        Tue, 14 Jul 2020 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752652;
        bh=NGFCHbSe5ZUZiSBlNjSOtCtvAsGFgJpCK38zbY82Ql4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnEz12FSCbx/Rl2TZyLYW/PEgPPGy1DQBvopfUgqfRJERYnBMMkbXTXjg1Sl+Msf6
         8uDVh8s8BoKz2K2xAvingO8DqXU3beu/RgjeZOKxHTH7+L0Vv7DWceVwUc/f3QXN9f
         +Bv21nWMyJMCag4WDGrvZ0lMFfiPn1Kborzu2oXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/109] IB/mlx5: Fix 50G per lane indication
Date:   Tue, 14 Jul 2020 20:44:03 +0200
Message-Id: <20200714184108.398057933@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 530c8632b547ff72f11ff83654b22462a73f1f7b ]

Some released FW versions mistakenly don't set the capability that 50G per
lane link-modes are supported for VFs (ptys_extended_ethernet capability
bit).

Use PTYS.ext_eth_proto_capability instead, as this indication is always
accurate. If PTYS.ext_eth_proto_capability is valid
(has a non-zero value) conclude that the HCA supports 50G per lane.

Otherwise, conclude that the HCA doesn't support 50G per lane.

Fixes: 08e8676f1607 ("IB/mlx5: Add support for 50Gbps per lane link modes")
Link: https://lore.kernel.org/r/20200707110612.882962-3-leon@kernel.org
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4f44a731a48e1..b781ad74e6de4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -517,7 +517,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 					   mdev_port_num);
 	if (err)
 		goto out;
-	ext = MLX5_CAP_PCAM_FEATURE(dev->mdev, ptys_extended_ethernet);
+	ext = !!MLX5_GET_ETH_PROTO(ptys_reg, out, true, eth_proto_capability);
 	eth_prot_oper = MLX5_GET_ETH_PROTO(ptys_reg, out, ext, eth_proto_oper);
 
 	props->active_width     = IB_WIDTH_4X;
-- 
2.25.1



