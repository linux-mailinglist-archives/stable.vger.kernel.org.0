Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FF43AEF81
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhFUQkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232427AbhFUQhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB3861424;
        Mon, 21 Jun 2021 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292923;
        bh=kyF51fD9yOs4mJjlPg9BL4zavpsliWiQaFtbe6aVDeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDx7EpAonAegIpWvdwY/v0drWPJ7j7pCD1AqKgeS0uRMtRCB7Phmpj6fHXeYgxuUn
         MlBXzgybRB09WtC9wxkdgEBRWkF44WVbmSZiNIQcXV7vIbYGqZSHMFDf7Z9dQVmkYb
         42lDv+ANi9kVlOGWgMHZO6j+ULT5w+srE30K+mQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 035/178] net/mlx5: Consider RoCE cap before init RDMA resources
Date:   Mon, 21 Jun 2021 18:14:09 +0200
Message-Id: <20210621154923.214360955@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit c189716b2a7c1d2d8658e269735273caa1c38b54 ]

Check if RoCE is supported by the device before enable it in
the vport context and create all the RDMA steering objects.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 8e0dddc6383f..2389239acadc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -156,6 +156,9 @@ void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
 {
 	int err;
 
+	if (!MLX5_CAP_GEN(dev, roce))
+		return;
+
 	err = mlx5_nic_vport_enable_roce(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to enable RoCE: %d\n", err);
-- 
2.30.2



