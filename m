Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594D7582CCA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiG0Qug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiG0Qtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:49:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922D861B3A;
        Wed, 27 Jul 2022 09:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C3BB8200C;
        Wed, 27 Jul 2022 16:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9830CC433C1;
        Wed, 27 Jul 2022 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939576;
        bh=N0ML1pABLswN1NQFGoqdU3MrpRpK1IRhmHHuJ+pi9Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf6EqTFu5jbNSbuLYMxTzJUfQT3iKUeTR3z4Ih+JmtbF92zgy3BH1D84ftLgDmhqW
         /TyaDsZ2plgNmlZ9mXpTfuXxZvCdrk4tPmn/pyiH5/wd8AbDc3D3nDSJ1oUvkIZaqK
         lxO6tNaOuafwvVHUDC83EvlkNttA1gfcrHc3T4V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/105] ip: Fix data-races around sysctl_ip_fwd_update_priority.
Date:   Wed, 27 Jul 2022 18:10:16 +0200
Message-Id: <20220727161013.301876371@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 7bf9e18d9a5e99e3c83482973557e9f047b051e7 ]

While reading sysctl_ip_fwd_update_priority, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 432e05d32892 ("net: ipv4: Control SKB reprioritization after forwarding")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 net/ipv4/ip_forward.c                                 | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5f143ca16c01..d2887ae508bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8038,13 +8038,14 @@ static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
 static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
-	bool usp = net->ipv4.sysctl_ip_fwd_update_priority;
 	char rgcr_pl[MLXSW_REG_RGCR_LEN];
 	u64 max_rifs;
+	bool usp;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_RIFS))
 		return -EIO;
 	max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
+	usp = READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority);
 
 	mlxsw_reg_rgcr_pack(rgcr_pl, true, true);
 	mlxsw_reg_rgcr_max_router_interfaces_set(rgcr_pl, max_rifs);
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 00ec819f949b..29730edda220 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -151,7 +151,7 @@ int ip_forward(struct sk_buff *skb)
 	    !skb_sec_path(skb))
 		ip_rt_send_redirect(skb);
 
-	if (net->ipv4.sysctl_ip_fwd_update_priority)
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority))
 		skb->priority = rt_tos2priority(iph->tos);
 
 	return NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
-- 
2.35.1



