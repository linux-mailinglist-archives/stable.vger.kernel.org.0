Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5EE247562
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392234AbgHQTWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbgHQPfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA73D20789;
        Mon, 17 Aug 2020 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678539;
        bh=QQAU1ikOIrDs5aF2Kgt4xXf0KPkLOjsnmxxrhoi6nYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9etYjBIEw8ucXM/MCxiBZOYXYeiZ1GRmknFkY1NQQbPng5qyWppWlSjfNrB+xuym
         VXfw1qV0jWYSbTVtkRuUfSpUx0CpAne2AEYKM2MU7cMl8PyY360cCY9Zv91OkdLtLB
         5azV12+KVXw25iLbsAdj2N3757lOOCftpqrbb+6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 352/464] net/mlx5: DR, Change push vlan action sequence
Date:   Mon, 17 Aug 2020 17:15:05 +0200
Message-Id: <20200817143850.630208221@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

[ Upstream commit b206490940216542c68563699b279eed3c55107c ]

The DR TX state machine supports the following order:
modify header, push vlan and encapsulation.
Instead fs_dr would pass:
push vlan, modify header and encapsulation.

The above caused the rule creation to fail on invalid action
sequence provided error.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 42 +++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 8887b2440c7d5..9b08eb557a311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -279,29 +279,9 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 
 	/* The order of the actions are must to be keep, only the following
 	 * order is supported by SW steering:
-	 * TX: push vlan -> modify header -> encap
+	 * TX: modify header -> push vlan -> encap
 	 * RX: decap -> pop vlan -> modify header
 	 */
-	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
-		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[0]);
-		if (!tmp_action) {
-			err = -ENOMEM;
-			goto free_actions;
-		}
-		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
-		actions[num_actions++] = tmp_action;
-	}
-
-	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
-		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[1]);
-		if (!tmp_action) {
-			err = -ENOMEM;
-			goto free_actions;
-		}
-		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
-		actions[num_actions++] = tmp_action;
-	}
-
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
 		enum mlx5dr_action_reformat_type decap_type =
 			DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2;
@@ -354,6 +334,26 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 		actions[num_actions++] =
 			fte->action.modify_hdr->action.dr_action;
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
+		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[0]);
+		if (!tmp_action) {
+			err = -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+		actions[num_actions++] = tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
+		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[1]);
+		if (!tmp_action) {
+			err = -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+		actions[num_actions++] = tmp_action;
+	}
+
 	if (delay_encap_set)
 		actions[num_actions++] =
 			fte->action.pkt_reformat->action.dr_action;
-- 
2.25.1



