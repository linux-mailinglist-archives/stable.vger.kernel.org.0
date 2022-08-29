Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1E5A481D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiH2LGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiH2LF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:05:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D205659D9;
        Mon, 29 Aug 2022 04:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2646FB80EF5;
        Mon, 29 Aug 2022 11:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705BFC433C1;
        Mon, 29 Aug 2022 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770987;
        bh=JA+Ax4iE7NHMuD+uWSGTnW4YkWjMeLjcQjis3Tv/84I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TelaZzt8dSalESMgB36jON6qlZj9zmbLltfzhMaPAQ4lGDOWztd9jlHk1d7d5vD4
         DZ0lByjThPbB8cdkAWlGx4IiwCD625yVfg8BVK2Rmzd1AstjJKxExvFXhjTPolTIvW
         H2e+BbJ8c/MUnqeempISxIf4IGYzfCk8xjfL48t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/136] net/mlx5e: Properly disable vlan strip on non-UL reps
Date:   Mon, 29 Aug 2022 12:58:31 +0200
Message-Id: <20220829105806.418526712@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit f37044fd759b6bc40b6398a978e0b1acdf717372 ]

When querying mlx5 non-uplink representors capabilities with ethtool
rx-vlan-offload is marked as "off [fixed]". However, it is actually always
enabled because mlx5e_params->vlan_strip_disable is 0 by default when
initializing struct mlx5e_params instance. Fix the issue by explicitly
setting the vlan_strip_disable to 'true' for non-uplink representors.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 161b60e1139b3..3d614bf5cff9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -618,6 +618,8 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		params->vlan_strip_disable = true;
 
 	/* Set an initial non-zero value, so that mlx5e_select_queue won't
 	 * divide by zero if called before first activating channels.
-- 
2.35.1



