Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C9D548B22
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355102AbiFMMbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358028AbiFMM3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD64810FD;
        Mon, 13 Jun 2022 04:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A29E61435;
        Mon, 13 Jun 2022 11:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6F0C34114;
        Mon, 13 Jun 2022 11:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118396;
        bh=5D0IZZWPFi+1oOM2xxdSo5Ie1OhxFGHul5okAN/8C+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW7oT1HXhXPYHsYGCd3UX4+o/ZOXCkWhbFj4ybeF5zQ//hYYmusFm7q5F6CgjyNol
         9DRu+66dp2kv98S0IGrLc9VXc+3nknwFLfpln2uHORVWIpc9Wf5CB7qgcIYsWNBbex
         flkvNKTBQ2T4VgVpjqByrE25IJvSc9urrXTrji2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/172] nfp: only report pause frame configuration for physical device
Date:   Mon, 13 Jun 2022 12:10:21 +0200
Message-Id: <20220613094905.066941386@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

[ Upstream commit 0649e4d63420ebc8cbebef3e9d39e12ffc5eb9fa ]

Only report pause frame configuration for physical device. Logical
port of both PCI PF and PCI VF do not support it.

Fixes: 9fdc5d85a8fe ("nfp: update ethtool reporting of pauseframe control")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index cd0c9623f7dd..e0b801d10739 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -286,8 +286,6 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
@@ -295,6 +293,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	port = nfp_port_from_netdev(netdev);
 	eth_port = nfp_port_get_eth_port(port);
 	if (eth_port) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 		cmd->base.autoneg = eth_port->aneg != NFP_ANEG_DISABLED ?
 			AUTONEG_ENABLE : AUTONEG_DISABLE;
 		nfp_net_set_fec_link_mode(eth_port, cmd);
-- 
2.35.1



