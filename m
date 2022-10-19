Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E960416D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiJSKon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiJSKnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:43:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3F0157F59;
        Wed, 19 Oct 2022 03:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55EE0B823AA;
        Wed, 19 Oct 2022 08:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC23CC433C1;
        Wed, 19 Oct 2022 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169563;
        bh=xNMqv/ZsY0vx5mTBDBy94sW1JDIi2qFUa783AYIVEJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+JK6u6rPR6uPtMcJTziYve+ffdwEtZMwHiSAdyFfSbb1h5czmuIVpAJeZPjo9rdL
         I24qXgV65mBK1YJUkccI7Sp3GIP6wy19or6IwS0+GDcWGVuDGDrK19JPopqAIbhHFm
         kQyLKMn3jB5zFpp++ZR5Y/TbB+FmYPHPgv3KTerQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 323/862] netfilter: nft_fib: Fix for rpath check with VRF devices
Date:   Wed, 19 Oct 2022 10:26:50 +0200
Message-Id: <20221019083304.295705229@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 2a8a7c0eaa8747c16aa4a48d573aa920d5c00a5c ]

Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
dropping vrf packets by mistake") but for nftables fib expression:
Add special treatment of VRF devices so that typical reverse path
filtering via 'fib saddr . iif oif' expression works as expected.

Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
 net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index b75cac69bd7e..7ade04ff972d 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	if (priv->flags & NFTA_FIB_F_IIF)
+		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 8970d0b4faeb..1d7e520d9966 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
+	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
+		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
+		fl6->flowi6_oif = dev->ifindex;
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -197,7 +200,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev)
+	if (oif && oif != rt->rt6i_idev->dev &&
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
 		goto put_rt_err;
 
 	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
-- 
2.35.1



