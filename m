Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C25521AD2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiEJOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245215AbiEJN5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384012CCD16;
        Tue, 10 May 2022 06:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65FC9615E9;
        Tue, 10 May 2022 13:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F1AC385C2;
        Tue, 10 May 2022 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189935;
        bh=7UDtlGi6A/Gn3d8hvqZBkSdisAh77sQVG6YWWiHMq/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qktXuVQzRBc+mqIGXjbI/lm/wWyAQerGlW42KpjTqlpm30q2Ze58jZkj7igk0IxZ7
         EAp7BBfxKEz3zgtu5ii8Pp1Wuo+g2nJe130DIvo0NpKJTKeKj3Z0PKwSJlLtOj78+r
         DBJsptFO1/jIDAmXZuZrX7gffERynLLoungEPCNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 075/140] net/mlx5e: TC, fix decap fallback to uplink when int port not supported
Date:   Tue, 10 May 2022 15:07:45 +0200
Message-Id: <20220510130743.760248346@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

commit e3fdc71bcb6ffe1d4870a89252ba296a9558e294 upstream.

When resolving the decap route device for a tunnel decap rule,
the result may be an OVS internal port device.

Prior to adding the support for internal port offload, such case
would result in using the uplink as the default decap route device
which allowed devices that can't support internal port offload
to offload this decap rule.

This behavior got broken by adding the internal port offload which
will fail in case the device can't support internal port offload.

To restore the old behavior, use the uplink device as the decap
route as before when internal port offload is not supported.

Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -713,6 +713,7 @@ int mlx5e_tc_tun_route_lookup(struct mlx
 			      struct net_device *filter_dev)
 {
 	struct mlx5_esw_flow_attr *esw_attr = flow_attr->esw_attr;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_int_port *int_port;
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	u16 vport_num;
@@ -747,7 +748,7 @@ int mlx5e_tc_tun_route_lookup(struct mlx
 		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
 						      misc_parameters.vxlan_vni);
 		esw_attr->rx_tun_attr->decap_vport = vport_num;
-	} else if (netif_is_ovs_master(attr.route_dev)) {
+	} else if (netif_is_ovs_master(attr.route_dev) && mlx5e_tc_int_port_supported(esw)) {
 		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
 						 attr.route_dev->ifindex,
 						 MLX5E_TC_INT_PORT_INGRESS);


