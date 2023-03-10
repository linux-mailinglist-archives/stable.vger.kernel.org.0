Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1E16B41F6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCJN6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjCJN6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BB516AEA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68A1F60D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66482C4339B;
        Fri, 10 Mar 2023 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456689;
        bh=ZtF8I0e8C9GGOUn6OuDhC9e7IQyAjJDJAm3yzabemKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RP+reTA/9OOWa7qfq88IMtW8sO0/Hbs9lZ6TgrBv2dMnVXMIYD0i3yw9tsmXLStk
         XEZaeifh4HkL8vKkw+aq3VLYkBLjfEK3L3aWCikkVC07aQYMiiKZoRwX70zA2/YHeQ
         w7gz/dZoOMA8U2ZyBg9K1kGTMs4NGQbdSaYeiWv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 090/211] net/mlx5e: Verify flow_source cap before using it
Date:   Fri, 10 Mar 2023 14:37:50 +0100
Message-Id: <20230310133721.519726388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 1bf8b0dae8dde6f02520a5ea34fdaa3b39342e69 ]

When adding send to vport rule verify flow_source matching is
supported by checking the flow_source cap.

Fixes: d04442540372 ("net/mlx5: E-Switch, set flow source for send to uplink rule")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c981fa77f4398..f3b74cb67b71c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1070,7 +1070,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (MLX5_CAP_ESW_FLOWTABLE(on_esw->dev, flow_source) &&
+	    rep->vport == MLX5_VPORT_UPLINK)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 
 	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(on_esw),
-- 
2.39.2



