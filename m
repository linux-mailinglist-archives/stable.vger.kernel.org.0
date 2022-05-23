Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C36531912
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbiEWRtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242409AbiEWRsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:48:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297B4AEE1D;
        Mon, 23 May 2022 10:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3E35BCE1714;
        Mon, 23 May 2022 17:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE1BC385A9;
        Mon, 23 May 2022 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326944;
        bh=XK2F6p7d/WIZRUdb45MDYHJw0InqyYcOPlFCpErby0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlaHy+/SaxGWYk4aSfhf9vPH1Bg4sGhWo2twwNsh7U4ZlURtqsk+6XoAPfPq1g94H
         bluuVyJ1Wgcg8eXJmrhJW7rjZmoR8lMyifpxbeU2jj9XjJckdbfdim9D2xsJHbfC1B
         HQ0Iygc5iXDpZ+R4q4K4sEeJgyvBNBypGru2hjq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 108/158] net/mlx5e: Remove HW-GRO from reported features
Date:   Mon, 23 May 2022 19:04:25 +0200
Message-Id: <20220523165849.017693297@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 6bbd723035badafe4a8eb17ccdecd96eae7a96d5 ]

We got reports of certain HW-GRO flows causing kernel call traces, which
might be related to firmware. To be on the safe side, disable the
feature for now and re-enable it once a driver/firmware fix is found.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4b83dd05afcd..3500faf08671 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4828,10 +4828,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
-	if (!!MLX5_CAP_GEN(mdev, shampo) &&
-	    mlx5e_check_fragmented_striding_rq_cap(mdev))
-		netdev->hw_features    |= NETIF_F_GRO_HW;
-
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |= NETIF_F_TSO;
-- 
2.35.1



