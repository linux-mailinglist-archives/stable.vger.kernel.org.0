Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C04B5A490A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiH2LTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiH2LTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E9574CDA;
        Mon, 29 Aug 2022 04:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B763611E0;
        Mon, 29 Aug 2022 11:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FECC433D6;
        Mon, 29 Aug 2022 11:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771441;
        bh=1+9F/qj0BexxnF6d6mCbsl9aSt5WFLc5KjlQIw0Y7NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFqMcYG2Luay1gaet2IPs6+Xjpew/OrK47mfBs6lR3kwqCC6BHqmkCvzbfKH8mCK0
         lFQxw8PUz08SA6/Lv4UI8HU1L/XE0kapfUYx9/1ULADBDmTMepvjqeMP6kmg0lrgA+
         SP80xuXk1Jjsqffe1f+g3vP+UCW1s05Bk45Dh2nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 031/158] net/mlx5: Eswitch, Fix forwarding decision to uplink
Date:   Mon, 29 Aug 2022 12:58:01 +0200
Message-Id: <20220829105810.081100200@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 942fca7e762be39204e5926e91a288a343a97c72 ]

Make sure to modify the rule for uplink forwarding only for the case
where destination vport number is MLX5_VPORT_UPLINK.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eb79810199d3e..d04739cb793e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -427,7 +427,8 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 		dest[dest_idx].vport.vhca_id =
 			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
-		if (mlx5_lag_mpesw_is_activated(esw->dev))
+		if (dest[dest_idx].vport.num == MLX5_VPORT_UPLINK &&
+		    mlx5_lag_mpesw_is_activated(esw->dev))
 			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
-- 
2.35.1



