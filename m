Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBCE45C58A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhKXN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349256AbhKXNyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA82363266;
        Wed, 24 Nov 2021 13:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759137;
        bh=nC4L3lBQ9wC1a/nRaETaUCLfO5YUykkNuNW8F0lMny4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iafYAvhLDQU6CN8lDDFfsMQsmBUYS4/PWN1zIB8HQA48ZVdPkGmY6Jw0WFV6xJ/Vm
         FYSxtxOFoRphdnMy8TudPPAB9HAeN/z6uJmd0bqIDrtjst5ERdf2lCaFDXAHIQfV8j
         6LSrKjCI/JIrPhffNLl8IJWtXtGmxUYet6huJOuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/279] net/mlx5e: Wait for concurrent flow deletion during neigh/fib events
Date:   Wed, 24 Nov 2021 12:57:11 +0100
Message-Id: <20211124115723.754272186@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 362980eada85b5ea691e5e0d9257a991aa7ade47 ]

Function mlx5e_take_tmp_flow() skips flows with zero reference count. This
can cause syndrome 0x179e84 when the called from neigh or route update code
and the skipped flow is not removed from the hardware by the time
underlying encap/decap resource is deleted. Add new completion
'del_hw_done' that is completed when flow is unoffloaded. This is safe to
do because flow with reference count zero needs to be detached from
encap/decap entry before its memory is deallocated, which requires taking
the encap_tbl_lock mutex that is held by the event handlers code.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index d1599b7b944bf..c340bf90354a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -102,6 +102,7 @@ struct mlx5e_tc_flow {
 	refcount_t refcnt;
 	struct rcu_head rcu_head;
 	struct completion init_done;
+	struct completion del_hw_done;
 	int tunnel_id; /* the mapped tunnel id of this flow */
 	struct mlx5_flow_attr *attr;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 1c44c6c345f5d..ec0163d75dd25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -221,8 +221,14 @@ static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
 				struct list_head *flow_list,
 				int index)
 {
-	if (IS_ERR(mlx5e_flow_get(flow)))
+	if (IS_ERR(mlx5e_flow_get(flow))) {
+		/* Flow is being deleted concurrently. Wait for it to be
+		 * unoffloaded from hardware, otherwise deleting encap will
+		 * fail.
+		 */
+		wait_for_completion(&flow->del_hw_done);
 		return;
+	}
 	wait_for_completion(&flow->init_done);
 
 	flow->tmp_entry_index = index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 129ff7e0d65cc..d2e7b099b83ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1544,6 +1544,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		else
 			mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
 	}
+	complete_all(&flow->del_hw_done);
 
 	if (mlx5_flow_has_geneve_opt(flow))
 		mlx5_geneve_tlv_option_del(priv->mdev->geneve);
@@ -4222,6 +4223,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	INIT_LIST_HEAD(&flow->l3_to_l2_reformat);
 	refcount_set(&flow->refcnt, 1);
 	init_completion(&flow->init_done);
+	init_completion(&flow->del_hw_done);
 
 	*__flow = flow;
 	*__parse_attr = parse_attr;
-- 
2.33.0



