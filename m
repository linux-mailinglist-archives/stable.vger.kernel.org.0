Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015E63830BE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhEQOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239487AbhEQO2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEF861628;
        Mon, 17 May 2021 14:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260869;
        bh=pA65frvz9Je2dhxeBGvonLp1FZJzdusgRI1gUhk9gCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXFJpf4Po+Q3/NvlBg1cVF029jqWyEI3Zq/RBTp/nX3NX1CLjK5PobZgzsXbVggnW
         tr7FpvfmdmPj7CYM9EGWpVaDF/BXjwx2IbBNM5X2Hygdcyd5BN868f9PZkQWBJe2Cb
         odKt7hh48TOwy/QZf44kzTg1fsSm7buQ9SJP2DLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 024/329] net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
Date:   Mon, 17 May 2021 15:58:55 +0200
Message-Id: <20210517140302.872083544@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 61ed671fe741..1b3c93c3fd23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -553,7 +553,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 
 	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	prefetchw(wqe->data);
+	net_prefetchw(wqe->data);
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
-- 
2.30.2



