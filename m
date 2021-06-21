Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B133AEFCB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhFUQmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhFUQj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3736C61440;
        Mon, 21 Jun 2021 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293024;
        bh=NnmdTo0pZwz9oc4CTfDc3hFC/2al5IuxrtxBXtEDhoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9hnrDdhd0z74AJpefv2BJcvk98BYembVCaphFfureOMbrnftk947z/wQhuO0VY6J
         I/TcLklydiPxuIflh9QDu3LJT/HlF41W5X00rZUFFdt1SRRTcowxedzYfv+z+ki8jp
         ZgvOM+v3sMJODor5rsOXQayisi1Wjfl0E771/Xtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 071/178] net/mlx5: Fix error path for set HCA defaults
Date:   Mon, 21 Jun 2021 18:14:45 +0200
Message-Id: <20210621154924.969626449@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 94a4b8414d3e91104873007b659252f855ee344a ]

In the case of the failure to execute mlx5_core_set_hca_defaults(),
we used wrong goto label to execute error unwind flow.

Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index efb93d63e54c..58b8f75d7a01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1157,7 +1157,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	err = mlx5_core_set_hca_defaults(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to set hca defaults\n");
-		goto err_sriov;
+		goto err_set_hca;
 	}
 
 	mlx5_vhca_event_start(dev);
@@ -1190,6 +1190,7 @@ err_ec:
 	mlx5_sf_hw_table_destroy(dev);
 err_vhca:
 	mlx5_vhca_event_stop(dev);
+err_set_hca:
 	mlx5_cleanup_fs(dev);
 err_fs:
 	mlx5_accel_tls_cleanup(dev);
-- 
2.30.2



