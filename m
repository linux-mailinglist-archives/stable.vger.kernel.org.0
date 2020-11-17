Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AB92B634F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgKQNhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732769AbgKQNgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE2AA20780;
        Tue, 17 Nov 2020 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620209;
        bh=mQX95/B3tG3dh3kShX3/qtKjgZqmD8wMl6ZXIekotiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKqYI5NG1GLkbLYMCnwNhaaqCnM0qW3M7+8eLYtW68tTTlN5g+JGSnHeyDbP+Wl5G
         izGiS9Bwl5JAYB6fyygfzaR2MPMT/UIJaRTHJnSn7jrpaAfGTdMWUfzrzgkhL1cTLc
         3jovP1q+N2/niUCn2C446iKDnrvnzK8Y0wgj5C2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 142/255] net/mlx5e: Fix incorrect access of RCU-protected xdp_prog
Date:   Tue, 17 Nov 2020 14:04:42 +0100
Message-Id: <20201117122145.858705277@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 1a50cf9a67ff2241c2949d30bc11c8dd4280eef8 ]

rq->xdp_prog is RCU-protected and should be accessed only with
rcu_access_pointer for the NULL check in mlx5e_poll_rx_cq.

rq->xdp_prog may change on the fly only from one non-NULL value to
another non-NULL value, so the checks in mlx5e_xdp_handle and
mlx5e_poll_rx_cq will have the same result during one NAPI cycle,
meaning that no additional synchronization is needed.

Fixes: fe45386a2082 ("net/mlx5e: Use RCU to protect rq->xdp_prog")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 64c8ac5eabf6a..a0a4398408b85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1566,7 +1566,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
 
 out:
-	if (rq->xdp_prog)
+	if (rcu_access_pointer(rq->xdp_prog))
 		mlx5e_xdp_rx_poll_complete(rq);
 
 	mlx5_cqwq_update_db_record(cqwq);
-- 
2.27.0



