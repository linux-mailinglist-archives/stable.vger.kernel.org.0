Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B363137D2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBHPcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233792AbhBHPWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3937164F13;
        Mon,  8 Feb 2021 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797245;
        bh=ALOmynC92w/tAhOU/v5HC6dA2Wo1l4i9lToY8jFORhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyWp8+7kxp4mWEgfhDhd0FnKtE1hAEEP1tip6zBPUSn01b5mTBpYwpUNYeX+lZTBJ
         Fy7KnauDsbr2184p1qo0Y4TuKCM5/x7+8lUHFDAqgIF3gfg24DqaajWmM4LxYNletI
         M1CcTT033Wv8qZ12u2ftQeRFfj9Om46ifXynL67o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/120] net/mlx5e: Release skb in case of failure in tc update skb
Date:   Mon,  8 Feb 2021 16:00:30 +0100
Message-Id: <20210208145820.134710885@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit a34ffec8af8ff1c730697a99e09ec7b74a3423b6 ]

In case of failure in tc update skb the packet is dropped
without freeing the skb.

Fixed by freeing the skb in case failure in tc update skb.

Fixes: d6d27782864f ("net/mlx5: E-Switch, Restore chain id on miss")
Fixes: c75690972228 ("net/mlx5e: Add tc chains offload support for nic flows")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6628a0197b4e0..6d2ba8b84187c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1262,8 +1262,10 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb))
+		if (!mlx5e_tc_update_skb(cqe, skb)) {
+			dev_kfree_skb_any(skb);
 			goto free_wqe;
+		}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1316,8 +1318,10 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+		dev_kfree_skb_any(skb);
 		goto free_wqe;
+	}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1371,8 +1375,10 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
+	}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
@@ -1528,8 +1534,10 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb))
+		if (!mlx5e_tc_update_skb(cqe, skb)) {
+			dev_kfree_skb_any(skb);
 			goto mpwrq_cqe_out;
+		}
 
 	napi_gro_receive(rq->cq.napi, skb);
 
-- 
2.27.0



