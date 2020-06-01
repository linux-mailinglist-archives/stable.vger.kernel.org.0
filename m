Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EFA1EADEB
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgFAStr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgFASGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90DD2207D0;
        Mon,  1 Jun 2020 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034802;
        bh=5PdVzUgIIVWPSy0wNPz7EaDxgWyXOWdWg0/IFX5111o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zNkROCe+a4zSe/57DkmTbmdrbtCqBoL4VoIy0Ez9IzKu4m87Hy8FE/Yp0izUklCq
         Vyxvsh2YkXZRFBm+k60kXPMoNMRx7yfeUl2fQqmovZHsWnHnmRvVodrCI1LgeGo7NP
         iEal9Yh53eL/Aq7NMXZ/EJa6/UrXSA7IlByTdPX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 006/142] __netif_receive_skb_core: pass skb by reference
Date:   Mon,  1 Jun 2020 19:52:44 +0200
Message-Id: <20200601174038.705010673@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit c0bbbdc32febd4f034ecbf3ea17865785b2c0652 ]

__netif_receive_skb_core may change the skb pointer passed into it (e.g.
in rx_handler). The original skb may be freed as a result of this
operation.

The callers of __netif_receive_skb_core may further process original skb
by using pt_prev pointer returned by __netif_receive_skb_core thus
leading to unpleasant effects.

The solution is to pass skb by reference into __netif_receive_skb_core.

v2: Added Fixes tag and comment regarding ppt_prev and skb invariant.

Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4713,11 +4713,12 @@ static inline int nf_ingress(struct sk_b
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
+	struct sk_buff *skb = *pskb;
 	struct net_device *orig_dev;
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
@@ -4748,8 +4749,10 @@ another_round:
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
 		preempt_enable();
 
-		if (ret2 != XDP_PASS)
-			return NET_RX_DROP;
+		if (ret2 != XDP_PASS) {
+			ret = NET_RX_DROP;
+			goto out;
+		}
 		skb_reset_mac_len(skb);
 	}
 
@@ -4899,6 +4902,13 @@ drop:
 	}
 
 out:
+	/* The invariant here is that if *ppt_prev is not NULL
+	 * then skb should also be non-NULL.
+	 *
+	 * Apparently *ppt_prev assignment above holds this invariant due to
+	 * skb dereferencing near it.
+	 */
+	*pskb = skb;
 	return ret;
 }
 
@@ -4908,7 +4918,7 @@ static int __netif_receive_skb_one_core(
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -4986,7 +4996,7 @@ static void __netif_receive_skb_list_cor
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {


