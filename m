Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D650A409590
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347269AbhIMOmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347260AbhIMOk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43136630EC;
        Mon, 13 Sep 2021 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541368;
        bh=E/4e5cDsBv25x9Gdn3jZTWAWC4/mGWRHdHrBZx9arLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuuizEBnitWCktb3IizL+vT+4r0Me1QQ3qom2xp+Dq2l0zlCpyyMG3/wuxPCR6Ggw
         JEk6ATfymVLbfDDVJkkHsvJH6fMVo6JkBN6MKIyNJdG/ma0/Wvj/xy3y6tokGT3shO
         fomtYIz3P99mR/RNMj87ddHeSdkmrBnZ6v+xZ2Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        Yicong Yang <yangyicong@hisilicon.com>
Subject: [PATCH 5.14 269/334] net/mlx5: Remove all auxiliary devices at the unregister event
Date:   Mon, 13 Sep 2021 15:15:23 +0200
Message-Id: <20210913131122.512055592@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 8e7e2e8ed0e251138926838b7933f8eb6dd56b12 ]

The call to mlx5_unregister_device() means that mlx5_core driver is
removed. In such scenario, we need to disregard all other flags like
attach/detach and forcibly remove all auxiliary devices.

Fixes: a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow")
Tested-and-Reported-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index def2156e50ee..20bb37266254 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -397,7 +397,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
 	mutex_lock(&mlx5_intf_mutex);
-	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
 }
-- 
2.30.2



