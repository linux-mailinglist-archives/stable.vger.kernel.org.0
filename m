Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406D4667608
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbjALO2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbjALO1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7785D410
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41571B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9134FC433D2;
        Thu, 12 Jan 2023 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533102;
        bh=u2G7KsNvx1t4p0w3cv/P1PjhwpUFctrHwEigoF/gCIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnUEVb+G5xY+oTuuHRbB/K1iOJS0Bu7jYReR9iIyYhaKZJgLmhml1BrdLIbPQgmJb
         nj3xid0eY3E0xKynqSRbp/Z+D77JogsSoiNPTb5u+XW60s1Je3yHJhzvzcqR+vIYHs
         8mmviQeFStrjOFXgkggIipCFZuu3FN9xV9NBN7gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/783] IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces
Date:   Thu, 12 Jan 2023 14:50:56 +0100
Message-Id: <20230112135540.076291764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit dbc94a0fb81771a38733c0e8f2ea8c4fa6934dc1 ]

There are 2 ways to create IPoIB PKEY child interfaces:
1) Writing a PKEY to /sys/class/net/<ib parent interface>/create_child.
2) Using netlink with iproute.

While with sysfs the child interface has the same number of tx and
rx queues as the parent, with netlink there will always be 1 tx
and 1 rx queue for the child interface. That's because the
get_num_tx/rx_queues() netlink ops are missing and the default value
of 1 is taken for the number of queues (in rtnl_create_link()).

This change adds the get_num_tx/rx_queues() ops which allows for
interfaces with multiple queues to be created over netlink. This
constant only represents the max number of tx and rx queues on that
net device.

Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Link: https://lore.kernel.org/r/f4a42c8aa43c02d5ae5559a60c3e5e0f18c82531.1670485816.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 5b05cf3837da..28e9b70844e4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -42,6 +42,11 @@ static const struct nla_policy ipoib_policy[IFLA_IPOIB_MAX + 1] = {
 	[IFLA_IPOIB_UMCAST]	= { .type = NLA_U16 },
 };
 
+static unsigned int ipoib_get_max_num_queues(void)
+{
+	return min_t(unsigned int, num_possible_cpus(), 128);
+}
+
 static int ipoib_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -173,6 +178,8 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.changelink	= ipoib_changelink,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
+	.get_num_rx_queues = ipoib_get_max_num_queues,
+	.get_num_tx_queues = ipoib_get_max_num_queues,
 };
 
 struct rtnl_link_ops *ipoib_get_link_ops(void)
-- 
2.35.1



