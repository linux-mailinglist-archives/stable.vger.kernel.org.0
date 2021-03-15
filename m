Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E621E33B716
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCON7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhCON6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD3564F29;
        Mon, 15 Mar 2021 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816701;
        bh=30qpCNvgCAC4jJqpN+nWjFnoFgCNXtc8piRFPskl9po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APv1OVLoW9KoyDkuukBCZ2HQnT2QPWP7vgJoMYloxZ/I57Rizb6gDI6Qft/z5hKpz
         Kvb1kRZ29+nnWT/0MmAgCRt2zer0rGzS5MwjD+avW4AWaUu+6j+dEcvdrTwt3pQt52
         EVDIHwdxbgWsp7q2YqeapSiWdbLiSlaghy6znjjI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 07/95] net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0
Date:   Mon, 15 Mar 2021 14:56:37 +0100
Message-Id: <20210315135740.512744339@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Balazs Nemeth <bnemeth@redhat.com>

commit d348ede32e99d3a04863e9f9b28d224456118c27 upstream.

A packet with skb_inner_network_header(skb) == skb_network_header(skb)
and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
from the packet. Subsequently, the call to skb_mac_gso_segment will
again call mpls_gso_segment with the same packet leading to an infinite
loop. In addition, ensure that the header length is a multiple of four,
which should hold irrespective of the number of stacked labels.

Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mpls/mpls_gso.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -18,6 +18,7 @@
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/mpls.h>
 
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
@@ -31,6 +32,8 @@ static struct sk_buff *mpls_gso_segment(
 
 	skb_reset_network_header(skb);
 	mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
+	if (unlikely(!mpls_hlen || mpls_hlen % MPLS_HLEN))
+		goto out;
 	if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
 		goto out;
 


