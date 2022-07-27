Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14C9582DF9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbiG0RFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbiG0REk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B344E60E;
        Wed, 27 Jul 2022 09:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65190601D2;
        Wed, 27 Jul 2022 16:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695E4C433C1;
        Wed, 27 Jul 2022 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939959;
        bh=2vd55fXTxnJeCDvZnoUJYpKKNmBwqMVbZenpWU+mA8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSuAwFsuP01GGiN2LZAc76kvJ84rCx1Uwq0lsekEwQ/A3xaERPqqr3uy60Ar7M4Mb
         7Nh0fwoxASgSdkDw8t44qJNY0aAjAbzslvbbimPjSzSXnuchxnCIyAZIoKCuy/F8Tq
         5riijQRnTCNPO5Xe2cVFfgbASSy/wnUG5kQ/6KTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/201] ip: Fix data-races around sysctl_ip_fwd_update_priority.
Date:   Wed, 27 Jul 2022 18:09:20 +0200
Message-Id: <20220727161029.244221383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 6ef4ca8599ac..d17156c11ef8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9787,13 +9787,14 @@ static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
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



