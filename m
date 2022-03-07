Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54D4CF5D4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiCGJbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiCGJ3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A702BDEF;
        Mon,  7 Mar 2022 01:28:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40DBA60C00;
        Mon,  7 Mar 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525DAC340E9;
        Mon,  7 Mar 2022 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645336;
        bh=6ZBj3r1Avvm002zaEoE/iDo0vTxoL/2Zm5ACvtb4eeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOktFm8ae/wWv0PVx4yPs4CaMNjXjSHLUGzPG68XkEW9o+rn6I43bOypOHN4JDdgm
         +P6vK8NvmaGcaT+iyJIlUtqBb14KPe/oq8sChQi9wL66M9YiHaVjSmmb+RQSqMoiZf
         ELClfBhAfVGWPfS1wbq2awKd+3wWm3+uPddlxvaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 63/64] Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"
Date:   Mon,  7 Mar 2022 10:19:36 +0100
Message-Id: <20220307091640.937915287@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

commit a6d95c5a628a09be129f25d5663a7e9db8261f51 upstream.

This reverts commit b515d2637276a3810d6595e10ab02c13bfd0b63a.

Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
should return at least 1280 for ipv6") in v5.14 breaks the TCP MSS
calculation in ipsec transport mode, resulting complete stalls of TCP
connections. This happens when the (P)MTU is 1280 or slighly larger.

The desired formula for the MSS is:
MSS = (MTU - ESP_overhead) - IP header - TCP header

However, the above commit clamps the (MTU - ESP_overhead) to a
minimum of 1280, turning the formula into
MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header

With the (P)MTU near 1280, the calculated MSS is too large and the
resulting TCP packets never make it to the destination because they
are over the actual PMTU.

The above commit also causes suboptimal double fragmentation in
xfrm tunnel mode, as described in
https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/

The original problem the above commit was trying to fix is now fixed
by commit 6596a0229541270fb8d38d989f91b78838e5e9da ("xfrm: fix MTU
regression").

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h    |    1 -
 net/ipv4/esp4.c       |    2 +-
 net/ipv6/esp6.c       |    2 +-
 net/xfrm/xfrm_state.c |   14 ++------------
 4 files changed, 4 insertions(+), 15 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1543,7 +1543,6 @@ void xfrm_sad_getinfo(struct net *net, s
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -499,7 +499,7 @@ static int esp_output(struct xfrm_state
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -440,7 +440,7 @@ static int esp6_output(struct xfrm_state
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2440,7 +2440,7 @@ void xfrm_state_delete_tunnel(struct xfr
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2471,17 +2471,7 @@ u32 __xfrm_state_mtu(struct xfrm_state *
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
-
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
-{
-	mtu = __xfrm_state_mtu(x, mtu);
-
-	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
-		return IPV6_MIN_MTU;
-
-	return mtu;
-}
+EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {


