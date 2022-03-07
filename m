Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5C44CFA82
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiCGKWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiCGKSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:18:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E8811A14;
        Mon,  7 Mar 2022 01:57:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A51EB80F9F;
        Mon,  7 Mar 2022 09:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAF6C340E9;
        Mon,  7 Mar 2022 09:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647070;
        bh=6Xy0AKRL44ozFeTAM65g/vCWA1q1e1weDYiab9eY6vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j380FBhdc9FXjYDEtfwx/xoSO4obMolH6vSbZh2Z2p/MlJ/fHpp+j+S+ye0mv39BM
         BPixKJSJty4GzdSbu9C1lPt63THO0Vifc1RFBPgRIkBKU+lfRptE6das47tKEIgPb2
         OQY3iD2/yuY4lS2SKU7mXgZwxP0iBGyN7nqhDHGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.16 181/186] Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"
Date:   Mon,  7 Mar 2022 10:20:19 +0100
Message-Id: <20220307091659.142180374@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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
@@ -1567,7 +1567,6 @@ void xfrm_sad_getinfo(struct net *net, s
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -671,7 +671,7 @@ static int esp_output(struct xfrm_state
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -708,7 +708,7 @@ static int esp6_output(struct xfrm_state
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2571,7 +2571,7 @@ void xfrm_state_delete_tunnel(struct xfr
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2602,17 +2602,7 @@ u32 __xfrm_state_mtu(struct xfrm_state *
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


