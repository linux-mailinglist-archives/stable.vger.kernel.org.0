Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA06C18D3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjCTP1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjCTP12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3153773F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B43FB80EC1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30FEC433EF;
        Mon, 20 Mar 2023 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325641;
        bh=I5jKldDth/iDO4Vt3M+thx8228uhQrke/1U5IOLJRaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huAKB5XbtVKDphBbDKgLya9mx1ig9vrlH9AcaGFIY+hYnwGbnF81ZBXT+dyUWPWeY
         gZqapVSJ8csATAsLFreqI3R1WvxD45ckm5QP+8Yfu782bL9twi9G33PRcYqYJwLqBB
         EUZ62Blq4Rv72OoQjadJgn+IeGwYRABxFSnNah0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 075/211] net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
Date:   Mon, 20 Mar 2023 15:53:30 +0100
Message-Id: <20230320145516.402043048@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 1313d78ac0c1cfcff7bdece8da54b080e71487c4 ]

In few cases, rules with mirror use case are split to two FTEs, one which
do the mirror action and forward to second FTE which do the rest of the rule
actions and the second redirect action.
In case of mirror rules which do split and forward to ovs internal port or
VF stack devices, source port rewrite should be used in the second FTE but
it is wrongly also set in the first FTE which break the offload.

Fix this issue by removing the wrong check if source port rewrite is needed to
be used on the first FTE of the split and instead return EOPNOTSUPP which will
block offload of rules which mirror to ovs internal port or VF stack devices
which isn't supported.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Fixes: a508728a4c8b ("net/mlx5e: VF tunnel RX traffic offloading")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f3b74cb67b71c..3992bf6337ca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -726,11 +726,11 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	for (i = 0; i < esw_attr->split_count; i++) {
-		if (esw_is_indir_table(esw, attr))
-			err = esw_setup_indir_table(dest, &flow_act, esw, attr, spec, false, &i);
-		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
-			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
-							       &i);
+		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
+			/* Source port rewrite (forward to ovs internal port or statck device) isn't
+			 * supported in the rule of split action.
+			 */
+			err = -EOPNOTSUPP;
 		else
 			esw_setup_vport_dest(dest, &flow_act, esw, esw_attr, i, i, false);
 
-- 
2.39.2



