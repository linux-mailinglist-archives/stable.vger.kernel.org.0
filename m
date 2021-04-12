Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3291735C062
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhDLJNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240235AbhDLJKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275256138B;
        Mon, 12 Apr 2021 09:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218293;
        bh=XUXlz7XLflIylKMKSTVByxQ2kVi6HZ6HjlSFrfkaIHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wnv0HDSveDopFC1RZmaPqGffFggyz0QwtpTuELX++TIEA/+ZJHOMetRW4uUwic9Wb
         Ve/dadt35tTS7x+GAV/dovlyMhQydQfJIrzW08LsF+Zl8aswqQbsGjdcKMPAvRyFsJ
         p2f6Ksof1f/UnI/wxc9eLNwJUJKz+cLm7oL15ixU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 144/210] net/mlx5: Delete auxiliary bus driver eth-rep first
Date:   Mon, 12 Apr 2021 10:40:49 +0200
Message-Id: <20210412084020.793562538@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 1f90aedfb496ccccf862c7b7c0889af20c2fc61a ]

Delete auxiliary bus drivers flow deletes the eth driver
first and then the eth-reps driver but eth-reps devices resources
are depend on eth device.

Fixed by changing the delete order of auxiliary bus drivers to delete
the eth-rep driver first and after it the eth driver.

Fixes: 601c10c89cbb ("net/mlx5: Delete custom device management logic")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index b051417ede67..9153c9bda96f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -191,12 +191,12 @@ static bool is_ib_supported(struct mlx5_core_dev *dev)
 }
 
 enum {
-	MLX5_INTERFACE_PROTOCOL_ETH_REP,
 	MLX5_INTERFACE_PROTOCOL_ETH,
+	MLX5_INTERFACE_PROTOCOL_ETH_REP,
 
+	MLX5_INTERFACE_PROTOCOL_IB,
 	MLX5_INTERFACE_PROTOCOL_IB_REP,
 	MLX5_INTERFACE_PROTOCOL_MPIB,
-	MLX5_INTERFACE_PROTOCOL_IB,
 
 	MLX5_INTERFACE_PROTOCOL_VNET,
 };
-- 
2.30.2



