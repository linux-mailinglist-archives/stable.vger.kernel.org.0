Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C463499AB8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573630AbiAXVp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456552AbiAXVjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA00C0417CC;
        Mon, 24 Jan 2022 12:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0AC61502;
        Mon, 24 Jan 2022 20:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90950C340E5;
        Mon, 24 Jan 2022 20:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055904;
        bh=g5jYcDdJTtAaQIzC6WDSvOuOlk9FXh7FUac05QGiE4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKzkLk7K1Qkf1uOXTEU3pp8bcUxcCbautSWJjfGRXjoN8Lj8xBdmiPGlrCEbaHlM7
         QQMdjMG30aGDrBO3ytYDME8GXVAyFPl8EPYnivhwDDZ4/y9sDaxdudQfsjpP8PdHHZ
         TnoOLB1QlfeOxc0A7Cj547eg7I4dxxk6m2QZNS0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/846] net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path
Date:   Mon, 24 Jan 2022 19:37:02 +0100
Message-Id: <20220124184111.422529364@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit 45a98ef4922def8c679ca7c454403d1957fe70e7 ]

The inner_ipproto saves the inner IP protocol of the plain
text packet. This allows vendor's IPsec feature making offload
decision at skb's features_check and configuring hardware at
ndo_start_xmit, current code implenetation did not handle the
case where IPsec is used in tunnel mode.

Fix by handling the case when IPsec is used in tunnel mode by
reading the protocol of the plain text packet IP protocol.

Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 229544bc70c21..4dc4a7bbe51cf 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -647,10 +647,12 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
  * This requires hardware to know the inner packet type to calculate
  * the inner header checksum. Save inner ip protocol here to avoid
  * traversing the packet in the vendor's xmit code.
- * If the encap type is IPIP, just save skb->inner_ipproto. Otherwise,
- * get the ip protocol from the IP header.
+ * For IPsec tunnel mode save the ip protocol from the IP header of the
+ * plain text packet. Otherwise If the encap type is IPIP, just save
+ * skb->inner_ipproto in any other case get the ip protocol from the IP
+ * header.
  */
-static void xfrm_get_inner_ipproto(struct sk_buff *skb)
+static void xfrm_get_inner_ipproto(struct sk_buff *skb, struct xfrm_state *x)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	const struct ethhdr *eth;
@@ -658,6 +660,25 @@ static void xfrm_get_inner_ipproto(struct sk_buff *skb)
 	if (!xo)
 		return;
 
+	if (x->outer_mode.encap == XFRM_MODE_TUNNEL) {
+		switch (x->outer_mode.family) {
+		case AF_INET:
+			xo->inner_ipproto = ip_hdr(skb)->protocol;
+			break;
+		case AF_INET6:
+			xo->inner_ipproto = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+
+		return;
+	}
+
+	/* non-Tunnel Mode */
+	if (!skb->encapsulation)
+		return;
+
 	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
 		xo->inner_ipproto = skb->inner_ipproto;
 		return;
@@ -712,8 +733,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
 
-		if (skb->encapsulation)
-			xfrm_get_inner_ipproto(skb);
+		xfrm_get_inner_ipproto(skb, x);
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
-- 
2.34.1



