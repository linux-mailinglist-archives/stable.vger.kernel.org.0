Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488EC681031
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbjA3OBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjA3OBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEC02BF2C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB8D8CE16A2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D0C433EF;
        Mon, 30 Jan 2023 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087226;
        bh=8PHhzrMtbOcaa+QufQqSDBjMdhyM7oMt5PF9jg5IdOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyQW2iC7B/u1bXAWrZNYlxjAjkNocT1Oa20aJP/DxJyyobOZVGOC9R3R2h6GWN7JE
         EeXT5gXEpTRK1CuJErZbLPeHCZveCh9XXGGd+1JPUd6js2nbYLKx2O6KgbpaLoT0L3
         e71q3HVmKrIo0jeCvqWxyv2w5yOEKQJoHnuw74Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/313] net/mlx5e: Set decap action based on attr for sample
Date:   Mon, 30 Jan 2023 14:49:04 +0100
Message-Id: <20230130134341.734127699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit ffa99b534732f90077f346c62094cab3d1ccddce ]

Currently decap action is set based on tunnel_id. That means it is
set unconditionally. But for decap, ct and sample actions, decap is
done before ct. No need to decap again in sample.

And the actions are set correctly when parsing. So set decap action
based on attr instead of tunnel_id.

Fixes: 2741f2230905 ("net/mlx5e: TC, Support sample offload action for tunneled traffic")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 1cbd2eb9d04f..f2c2c752bd1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -477,7 +477,6 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	struct mlx5e_sample_flow *sample_flow;
 	struct mlx5e_sample_attr *sample_attr;
 	struct mlx5_flow_attr *pre_attr;
-	u32 tunnel_id = attr->tunnel_id;
 	struct mlx5_eswitch *esw;
 	u32 default_tbl_id;
 	u32 obj_id;
@@ -522,7 +521,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	restore_obj.sample.group_id = sample_attr->group_num;
 	restore_obj.sample.rate = sample_attr->rate;
 	restore_obj.sample.trunc_size = sample_attr->trunc_size;
-	restore_obj.sample.tunnel_id = tunnel_id;
+	restore_obj.sample.tunnel_id = attr->tunnel_id;
 	err = mapping_add(esw->offloads.reg_c0_obj_pool, &restore_obj, &obj_id);
 	if (err)
 		goto err_obj_id;
@@ -548,7 +547,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	/* For decap action, do decap in the original flow table instead of the
 	 * default flow table.
 	 */
-	if (tunnel_id)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP)
 		pre_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	pre_attr->modify_hdr = sample_flow->restore->modify_hdr;
 	pre_attr->flags = MLX5_ATTR_FLAG_SAMPLE;
-- 
2.39.0



