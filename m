Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D001CADC4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgEHNEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbgEHMsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C0F206D6;
        Fri,  8 May 2020 12:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942133;
        bh=63mWrDenOfyWtIaxJqhgasiakcPCm97DHNs3RjYaL8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tThTPVjjIRxmgCfIjZzAOPVnT4Wu3tL5OfIpQ8Lmr4F8+Y/ZX/eR9J8dyPsa4vWD
         R1EQ6d8HqNVoAgkCVO+Jt9gBJTxudCoGJ+31LFHaXxDn5WgatgrrpUKjt4IHP2JQEZ
         pLHe8PYxQO6gLyv5tU18Oz3nFPk+KlquY3uWjTsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 309/312] macvlan: Fix potential use-after free for broadcasts
Date:   Fri,  8 May 2020 14:35:00 +0200
Message-Id: <20200508123146.249842508@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 260916dfb48c374f7840f3b86e69afd3afdb6e96 upstream.

When we postpone a broadcast packet we save the source port in
the skb if it is local.  However, the source port can disappear
before we get a chance to process the packet.

This patch fixes this by holding a ref count on the netdev.

It also delays the skb->cb modification until after we allocate
the new skb as you should not modify shared skbs.

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvlan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -305,6 +305,8 @@ static void macvlan_process_broadcast(st
 
 		rcu_read_unlock();
 
+		if (src)
+			dev_put(src->dev);
 		kfree_skb(skb);
 
 		cond_resched();
@@ -312,6 +314,7 @@ static void macvlan_process_broadcast(st
 }
 
 static void macvlan_broadcast_enqueue(struct macvlan_port *port,
+				      const struct macvlan_dev *src,
 				      struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
@@ -321,8 +324,12 @@ static void macvlan_broadcast_enqueue(st
 	if (!nskb)
 		goto err;
 
+	MACVLAN_SKB_CB(nskb)->src = src;
+
 	spin_lock(&port->bc_queue.lock);
 	if (skb_queue_len(&port->bc_queue) < MACVLAN_BC_QUEUE_LEN) {
+		if (src)
+			dev_hold(src->dev);
 		__skb_queue_tail(&port->bc_queue, nskb);
 		err = 0;
 	}
@@ -432,8 +439,7 @@ static rx_handler_result_t macvlan_handl
 			goto out;
 		}
 
-		MACVLAN_SKB_CB(skb)->src = src;
-		macvlan_broadcast_enqueue(port, skb);
+		macvlan_broadcast_enqueue(port, src, skb);
 
 		return RX_HANDLER_PASS;
 	}


