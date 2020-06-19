Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F1B200D29
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgFSOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389751AbgFSOx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7252821556;
        Fri, 19 Jun 2020 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578436;
        bh=GDRe5UXHyTkLLKAsaFIBnW7hzRPAaDJwUWpMCb6AdOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtXtRXxhwLSQIbrqgHOUREdREkvwsFc7TKfmK0bcGTL58USVlJ6iFkeYRWpbyfTdF
         dfG07O4lHlBTGA7lRsk+a8pge1FgmXIXwPTFv25DWoLNRANk0kh+iWCHu48RCNovmo
         UYlmb+ac3+81/m/sM3TOqn7SDKAEHz1LXqbTgHX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 005/267] tun: correct header offsets in napi frags mode
Date:   Fri, 19 Jun 2020 16:29:50 +0200
Message-Id: <20200619141649.114558389@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 96aa1b22bd6bb9fccf62f6261f390ed6f3e7967f ]

Tun in IFF_NAPI_FRAGS mode calls napi_gro_frags. Unlike netif_rx and
netif_gro_receive, this expects skb->data to point to the mac layer.

But skb_probe_transport_header, __skb_get_hash_symmetric, and
xdp_do_generic in tun_get_user need skb->data to point to the network
header. Flow dissection also needs skb->protocol set, so
eth_type_trans has to be called.

Ensure the link layer header lies in linear as eth_type_trans pulls
ETH_HLEN. Then take the same code paths for frags as for not frags.
Push the link layer header back just before calling napi_gro_frags.

By pulling up to ETH_HLEN from frag0 into linear, this disables the
frag0 optimization in the special case when IFF_NAPI_FRAGS is used
with zero length iov[0] (and thus empty skb->linear).

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Petar Penkov <ppenkov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1870,8 +1870,11 @@ drop:
 		skb->dev = tun->dev;
 		break;
 	case IFF_TAP:
-		if (!frags)
-			skb->protocol = eth_type_trans(skb, tun->dev);
+		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+			err = -ENOMEM;
+			goto drop;
+		}
+		skb->protocol = eth_type_trans(skb, tun->dev);
 		break;
 	}
 
@@ -1927,8 +1930,11 @@ drop:
 	}
 
 	if (frags) {
+		u32 headlen;
+
 		/* Exercise flow dissector code path. */
-		u32 headlen = eth_get_headlen(skb->data, skb_headlen(skb));
+		skb_push(skb, ETH_HLEN);
+		headlen = eth_get_headlen(skb->data, skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
 			this_cpu_inc(tun->pcpu_stats->rx_dropped);


