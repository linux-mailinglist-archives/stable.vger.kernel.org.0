Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB26383310
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbhEQOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241512AbhEQOv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97FCC61984;
        Mon, 17 May 2021 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261419;
        bh=EYWBTJda0F6zMNnuHeE7/4rKHkgRRO3h1/YDuq1xrtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5RMS7UE6/R0VEDCT9LTkMBsuSBmdweQjnu31llYbsMeJkOQhzd2Tj38yvyJXTHvd
         jnLj86L51P/W7zucsfoeTqymVVfbQn1iOA0vTX9/OFGSAXNHTwmRkhdJCZuJFfB07E
         pETTGA/rFQb+TUrB9mGNabvn1uhjHAkCWu24TbK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/289] net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
Date:   Mon, 17 May 2021 15:59:03 +0200
Message-Id: <20210517140305.793992588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 991b2654605b455a94dac73e14b23480e7e20991 ]

Commit e20f0dbf204f ("net/mlx5e: RX, Add a prefetch command for small
L1_CACHE_BYTES") switched to using net_prefetchw at all places in mlx5e.
In the same time frame, commit 5af75c747e2a ("net/mlx5e: Enhanced TX
MPWQE for SKBs") added one more usage of prefetchw. When these two
changes were merged, this new occurrence of prefetchw wasn't replaced
with net_prefetchw.

This commit fixes this last occurrence of prefetchw in
mlx5e_tx_mpwqe_session_start, making the same change that was done in
mlx5e_xdp_mpwqe_session_start.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 38a23d209b33..373668068071 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -486,7 +486,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 
 	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	prefetchw(wqe->data);
+	net_prefetchw(wqe->data);
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
-- 
2.30.2



