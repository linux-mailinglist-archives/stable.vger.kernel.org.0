Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA7024729D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403793AbgHQSpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388057AbgHQPz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:55:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E975208B3;
        Mon, 17 Aug 2020 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679757;
        bh=titsjm08NZ+ajusp+cgdUkzZnIuBuYqfhaNfHZlXsec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnXF/3jpXdXlGW8NZK0uttUxdisJ2LT/zYT7o4syjGipzWpdgIZ80IxOPyy6LuUkl
         mJbjElU80qESudd+xUFN0blkReAE7XZlfG0BEts0Mq+oQ3bj1WnQWhHWpKW1V7PqUM
         LzueEUbSqhphKXadI6BjvvU7jO4Xt+AM8Vio+wrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 293/393] net/mlx5: DR, Change push vlan action sequence
Date:   Mon, 17 Aug 2020 17:15:43 +0200
Message-Id: <20200817143833.831534913@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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
index 3b3f5b9d4f950..2f3ee8519b226 100644
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



