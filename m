Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F5414BBAF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgA1OB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgA1OBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B6124683;
        Tue, 28 Jan 2020 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220114;
        bh=uwgvlv15vQsuyHotZFmUErIIFdmdFA6njzevUyYb6Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBOna2vwnRECoZVhKUqRohgQxmUMoDcItXN4KkdIl4y84nFCS32ixBUDyHS7bb+Rl
         fObq4VkjL5Aw5l66yhgQqfQXc0s4mc6ld/PqSncZ9CGjqWjM/LwX50qgX5WH295Yrz
         PGN3sGacMxcznsXghQRtzt0WdjbuT33dGef6Y4oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 023/104] net: Fix packet reordering caused by GRO and listified RX cooperation
Date:   Tue, 28 Jan 2020 14:59:44 +0100
Message-Id: <20200128135820.474088756@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit c80794323e82ac6ab45052ebba5757ce47b4b588 ]

Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
skbs") introduces batching of GRO_NORMAL packets in napi_frags_finish,
and commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()") adds the same to napi_skb_finish. However,
dev_gro_receive (that is called just before napi_{frags,skb}_finish) can
also pass skbs to the networking stack: e.g., when the GRO session is
flushed, napi_gro_complete is called, which passes pp directly to
netif_receive_skb_internal, skipping napi->rx_list. It means that the
packet stored in pp will be handled by the stack earlier than the
packets that arrived before, but are still waiting in napi->rx_list. It
leads to TCP reorderings that can be observed in the TCPOFOQueue counter
in netstat.

This commit fixes the reordering issue by making napi_gro_complete also
use napi->rx_list, so that all packets going through GRO will keep their
order. In order to keep napi_gro_flush working properly, gro_normal_list
calls are moved after the flush to clear napi->rx_list.

iwlwifi calls napi_gro_flush directly and does the same thing that is
done by gro_normal_list, so the same change is applied there:
napi_gro_flush is moved to be before the flush of napi->rx_list.

A few other drivers also use napi_gro_flush (brocade/bna/bnad.c,
cortina/gemini.c, hisilicon/hns3/hns3_enet.c). The first two also use
napi_complete_done afterwards, which performs the gro_normal_list flush,
so they are fine. The latter calls napi_gro_receive right after
napi_gro_flush, so it can end up with non-empty napi->rx_list anyway.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Alexander Lobakin <alobakin@dlink.ru>
Cc: Edward Cree <ecree@solarflare.com>
Acked-by: Alexander Lobakin <alobakin@dlink.ru>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c |    4 -
 net/core/dev.c                               |   64 +++++++++++++--------------
 2 files changed, 35 insertions(+), 33 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1537,13 +1537,13 @@ out:
 
 	napi = &rxq->napi;
 	if (napi->poll) {
+		napi_gro_flush(napi, false);
+
 		if (napi->rx_count) {
 			netif_receive_skb_list(&napi->rx_list);
 			INIT_LIST_HEAD(&napi->rx_list);
 			napi->rx_count = 0;
 		}
-
-		napi_gro_flush(napi, false);
 	}
 
 	iwl_pcie_rxq_restock(trans, rxq);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5270,9 +5270,29 @@ static void flush_all_backlogs(void)
 	put_online_cpus();
 }
 
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
+ * pass the whole batch up to the stack.
+ */
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	if (++napi->rx_count >= gro_normal_batch)
+		gro_normal_list(napi);
+}
+
 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
-static int napi_gro_complete(struct sk_buff *skb)
+static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
@@ -5305,7 +5325,8 @@ static int napi_gro_complete(struct sk_b
 	}
 
 out:
-	return netif_receive_skb_internal(skb);
+	gro_normal_one(napi, skb);
+	return NET_RX_SUCCESS;
 }
 
 static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
@@ -5318,7 +5339,7 @@ static void __napi_gro_flush_chain(struc
 		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
 			return;
 		skb_list_del_init(skb);
-		napi_gro_complete(skb);
+		napi_gro_complete(napi, skb);
 		napi->gro_hash[index].count--;
 	}
 
@@ -5421,7 +5442,7 @@ static void gro_pull_from_frag0(struct s
 	}
 }
 
-static void gro_flush_oldest(struct list_head *head)
+static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 {
 	struct sk_buff *oldest;
 
@@ -5437,7 +5458,7 @@ static void gro_flush_oldest(struct list
 	 * SKB to the chain.
 	 */
 	skb_list_del_init(oldest);
-	napi_gro_complete(oldest);
+	napi_gro_complete(napi, oldest);
 }
 
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
@@ -5513,7 +5534,7 @@ static enum gro_result dev_gro_receive(s
 
 	if (pp) {
 		skb_list_del_init(pp);
-		napi_gro_complete(pp);
+		napi_gro_complete(napi, pp);
 		napi->gro_hash[hash].count--;
 	}
 
@@ -5524,7 +5545,7 @@ static enum gro_result dev_gro_receive(s
 		goto normal;
 
 	if (unlikely(napi->gro_hash[hash].count >= MAX_GRO_SKBS)) {
-		gro_flush_oldest(gro_head);
+		gro_flush_oldest(napi, gro_head);
 	} else {
 		napi->gro_hash[hash].count++;
 	}
@@ -5672,26 +5693,6 @@ struct sk_buff *napi_get_frags(struct na
 }
 EXPORT_SYMBOL(napi_get_frags);
 
-/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static void gro_normal_list(struct napi_struct *napi)
-{
-	if (!napi->rx_count)
-		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
-}
-
-/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
- * pass the whole batch up to the stack.
- */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
-{
-	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >= gro_normal_batch)
-		gro_normal_list(napi);
-}
-
 static gro_result_t napi_frags_finish(struct napi_struct *napi,
 				      struct sk_buff *skb,
 				      gro_result_t ret)
@@ -5979,8 +5980,6 @@ bool napi_complete_done(struct napi_stru
 				 NAPIF_STATE_IN_BUSY_POLL)))
 		return false;
 
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		unsigned long timeout = 0;
 
@@ -5996,6 +5995,9 @@ bool napi_complete_done(struct napi_stru
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
 				      HRTIMER_MODE_REL_PINNED);
 	}
+
+	gro_normal_list(n);
+
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
 		local_irq_save(flags);
@@ -6327,8 +6329,6 @@ static int napi_poll(struct napi_struct
 		goto out_unlock;
 	}
 
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		/* flush too old packets
 		 * If HZ < 1000, flush all packets.
@@ -6336,6 +6336,8 @@ static int napi_poll(struct napi_struct
 		napi_gro_flush(n, HZ >= 1000);
 	}
 
+	gro_normal_list(n);
+
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
 	 */


