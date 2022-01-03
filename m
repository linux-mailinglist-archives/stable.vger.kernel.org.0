Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E98F48331E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiACOdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32768 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiACObk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6366110F;
        Mon,  3 Jan 2022 14:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CAAC36AEB;
        Mon,  3 Jan 2022 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220298;
        bh=27e5PbD9EWqYAWYv9hAqSWtD7yB2Z/OoYQ5POT/Z1Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6DebqqwSCEcHR1fUZ4toft/susGvCvS8geMMc6edfX8Xhc6SLIwxZ4W/YMO0G9lp
         1brWtAw6d9kcuOWgr01B4uRF25qGt5Hs4xuqARaTPzrABqkccTmR+HMm8cBWkL2OuA
         VG7jCN1zr1racJCXq7ng3x+jYp9+Wg7uRoEIyvTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/73] net/mlx5e: Delete forward rule for ct or sample action
Date:   Mon,  3 Jan 2022 15:23:46 +0100
Message-Id: <20220103142057.728180193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 2820110d945923ab2f4901753e4ccbb2a506fa8e ]

When there is ct or sample action, the ct or sample rule will be deleted
and return. But if there is an extra mirror action, the forward rule can't
be deleted because of the return.

Fix it by removing the return.

Fixes: 69e2916ebce4 ("net/mlx5: CT: Add support for mirroring")
Fixes: f94d6389f6a8 ("net/mlx5e: TC, Add support to offload sample action")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e7736421d1bc2..fa461bc57baee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1179,21 +1179,16 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
 		goto offload_rule_0;
 
-	if (flow_flag_test(flow, CT)) {
-		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
-		return;
-	}
-
-	if (flow_flag_test(flow, SAMPLE)) {
-		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
-		return;
-	}
-
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
+	if (flow_flag_test(flow, CT))
+		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
+	else if (flow_flag_test(flow, SAMPLE))
+		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
+	else
 offload_rule_0:
-	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
+		mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 }
 
 struct mlx5_flow_handle *
-- 
2.34.1



