Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D990B549444
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350274AbiFMMbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353000AbiFMMaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:30:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780255B3E9;
        Mon, 13 Jun 2022 04:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D79E2CE1177;
        Mon, 13 Jun 2022 11:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895AAC34114;
        Mon, 13 Jun 2022 11:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118422;
        bh=TbIVwNAzOSKxF5R/qnhW5wcuDO7VyITaYh+xHBnqW6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLiRvGOhT+ZxdI9pCVXwLkoYzZJH0PshGxQQ/AT9R51tsjNjq6r3YErMsiSHvP9U+
         rUrOiKHrwP3ISLS7FFY2X1oq/b5oICZ0UafWFEnOqdHtjhlXg5muy6gv0OnHgvNfew
         jbYhdSWCZh6XQplk/cU9nJ6n5JuX4NLY7iV0MNtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/172] net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()
Date:   Mon, 13 Jun 2022 12:10:11 +0200
Message-Id: <20220613094902.670036675@linuxfoundation.org>
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
index 7d7dc0754a3a..789642647cd3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1966,6 +1966,9 @@ static int mtk_hwlro_get_fdir_entry(struct net_device *dev,
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



