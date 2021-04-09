Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A465359B1D
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhDIKHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234209AbhDIKFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048F261352;
        Fri,  9 Apr 2021 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962493;
        bh=zbUYVA0Aak82mjeAyjKw0nf0XfPsh2sO9uhwAHHAEu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDlw6EFGwQFvzGJrHqMyX5U7JbfJEX/WmzD6XQbBCUO6PIaHkJ3O/aywCNKEqpDAA
         8hwTMlLogwlJEFKoJRjdVeggaDKwYToS+f5hF3+x+QeTDtqsaTCSVuqWlmeKq2o1cJ
         2DKIQf6ZE8Y8y77RTK1ofcq1pv6RpitprkGdpxr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 06/45] net/mlx5e: Enforce minimum value check for ICOSQ size
Date:   Fri,  9 Apr 2021 11:53:32 +0200
Message-Id: <20210409095305.596128291@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 5115daa675ccf70497fe56e8916cf738d8212c10 ]

The ICOSQ size should not go below MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE.
Enforce this where it's missing.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index aaa5a56b44c7..b6324d11a008 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2317,8 +2317,9 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
 {
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return order_base_2(MLX5E_UMR_WQEBBS) +
-			mlx5e_get_rq_log_wq_sz(rqp->rqc);
+		return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE,
+			     order_base_2(MLX5E_UMR_WQEBBS) +
+			     mlx5e_get_rq_log_wq_sz(rqp->rqc));
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 	}
-- 
2.30.2



