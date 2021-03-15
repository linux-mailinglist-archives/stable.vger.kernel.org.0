Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A84E33B627
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhCON5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhCON4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6DA464EEC;
        Mon, 15 Mar 2021 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816606;
        bh=qOnis5ASUbtP4DBaEjgypEoRm67TjZW/8eJm0wxkdp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrXtmtVSqN2Vp3UCSymhIWNuHLkF58R+eKAvZQC6++gu3f1q43JO/ePjTUmcxnpyH
         dlOIbz2GgbT3LYD5qn7jRKaqVOzub9lLApaEN9TRcWfg5icuevH0whzmtGredAKMqT
         H6zOVo8MFYGUfvMClvJd/TXMlM3+PctOYSkmO1jI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 009/290] net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0
Date:   Mon, 15 Mar 2021 14:51:42 +0100
Message-Id: <20210315135542.257552702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -14,6 +14,7 @@
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/mpls.h>
 
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
@@ -27,6 +28,8 @@ static struct sk_buff *mpls_gso_segment(
 
 	skb_reset_network_header(skb);
 	mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
+	if (unlikely(!mpls_hlen || mpls_hlen % MPLS_HLEN))
+		goto out;
 	if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
 		goto out;
 


