Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE9548916
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349335AbiFMK5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350594AbiFMKzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:55:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3155621E21;
        Mon, 13 Jun 2022 03:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4653B80E5E;
        Mon, 13 Jun 2022 10:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C15C3411C;
        Mon, 13 Jun 2022 10:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116303;
        bh=jbhtL23dw1SOfwSe9CIJ573qi3P1HYRs60jkyA5yyuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rP705kCAYFd7auY/LH61pLpWBO6aqF3zavpHdW8L5bCUrw6a8E7yJGTa2BQcaTnMJ
         SH6EQ9PxaVTt3Kaium80+4Ndi4CqbVl2onnOd+YtgDOTb4dCxttsREUv3DzspnlT3v
         PnDwzl4CYXQI9lTMrrCUd7VGQ/7ckePNKQlM75G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/218] net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()
Date:   Mon, 13 Jun 2022 12:10:16 +0200
Message-Id: <20220613094925.386465718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e7e7104e2d5ddf3806a28695670f21bef471f1e1 ]

The "fsp->location" variable comes from user via ethtool_get_rxnfc().
Check that it is valid to prevent an out of bounds read.

Fixes: 7aab747e5563 ("net: ethernet: mediatek: add ethtool functions to configure RX flows of HW LRO")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index dbd16dd5aa04..ade72b46e93c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1579,6 +1579,9 @@ static int mtk_hwlro_get_fdir_entry(struct net_device *dev,
 	struct ethtool_rx_flow_spec *fsp =
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	if (fsp->location >= ARRAY_SIZE(mac->hwlro_ip))
+		return -EINVAL;
+
 	/* only tcp dst ipv4 is meaningful, others are meaningless */
 	fsp->flow_type = TCP_V4_FLOW;
 	fsp->h_u.tcp_ip4_spec.ip4dst = ntohl(mac->hwlro_ip[fsp->location]);
-- 
2.35.1



