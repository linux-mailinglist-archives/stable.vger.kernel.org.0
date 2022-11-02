Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D506158B0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiKBC4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiKBC4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820EF22512
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 292B0B82071
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF328C433D6;
        Wed,  2 Nov 2022 02:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357795;
        bh=987/RewX/79lrIDQuSxRtlCPNZrHT4NilLbUh1Z/8vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vow+rSQmRL/HKa7vyw0SeyRpFk7p7H+qyROWPreKacU4AtgzOvShcYsGSPSr9JATI
         mSoSVjn7Yuz3eGIbzBwuV9dDVtF0KKJM3nU+oL2ow7LVbDNbzuEfnMCGqgrsvWWL7r
         8KjQv7l2trHv8ecp26uDCOnfKhY0Ii8QbWk2GkiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 230/240] net/mlx5e: TC, Reject forwarding from internal port to internal port
Date:   Wed,  2 Nov 2022 03:33:25 +0100
Message-Id: <20221102022116.604752952@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

[ Upstream commit f382a2413dae8c855226a72600812a4b37432c48 ]

Reject TC rules that forward from internal port to internal port
as it is not supported.

This include rules that are explicitly have internal port as
the filter device as well as rules that apply on tunnel interfaces
as the route device for the tunnel interface can be an internal
port.

Fixes: 27484f7170ed ("net/mlx5e: Offload tc rules that redirect to ovs internal port")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-9-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6a0df046064f..a687f047e3ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4052,6 +4052,7 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
+	struct net_device *filter_dev;
 	int err;
 
 	err = flow_action_supported(flow_action, extack);
@@ -4060,6 +4061,7 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
+	filter_dev = parse_attr->filter_dev;
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
@@ -4069,13 +4071,21 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return err;
 
 	/* Forward to/from internal port can only have 1 dest */
-	if ((netif_is_ovs_master(parse_attr->filter_dev) || esw_attr->dest_int_port) &&
+	if ((netif_is_ovs_master(filter_dev) || esw_attr->dest_int_port) &&
 	    esw_attr->out_count > 1) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Rules with internal port can have only one destination");
 		return -EOPNOTSUPP;
 	}
 
+	/* Forward from tunnel/internal port to internal port is not supported */
+	if ((mlx5e_get_tc_tun(filter_dev) || netif_is_ovs_master(filter_dev)) &&
+	    esw_attr->dest_int_port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Forwarding from tunnel/internal port to internal port is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	err = actions_prepare_mod_hdr_actions(priv, flow, attr, extack);
 	if (err)
 		return err;
-- 
2.35.1



