Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D114FCD6EE
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfJFRvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B2E218AC;
        Sun,  6 Oct 2019 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383936;
        bh=jbJz3uGLLHAyYLPhnl1Y9VCga/2gkSJPt8N1e4A7zik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d64BrhqY2WBDmUqty3N5xOvO0pthmcN0tdSHp5UzmBBd+0hztCqgZGq/FpM+X/m0u
         xhu5dGG4ej4dqwpq9rJzii0qbrpjAiv4ZwDJ68ZM49L4MtFgLdDUTF9tBTfdBYCgJ+
         RSnD1W4G8EyspRg04ntDrxstKzqEXDTL5k9v0Cck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 150/166] xen-netfront: do not use ~0U as error return value for xennet_fill_frags()
Date:   Sun,  6 Oct 2019 19:21:56 +0200
Message-Id: <20191006171225.552635495@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit a761129e3625688310aecf26e1be9e98e85f8eb5 ]

xennet_fill_frags() uses ~0U as return value when the sk_buff is not able
to cache extra fragments. This is incorrect because the return type of
xennet_fill_frags() is RING_IDX and 0xffffffff is an expected value for
ring buffer index.

In the situation when the rsp_cons is approaching 0xffffffff, the return
value of xennet_fill_frags() may become 0xffffffff which xennet_poll() (the
caller) would regard as error. As a result, queue->rx.rsp_cons is set
incorrectly because it is updated only when there is error. If there is no
error, xennet_poll() would be responsible to update queue->rx.rsp_cons.
Finally, queue->rx.rsp_cons would point to the rx ring buffer entries whose
queue->rx_skbs[i] and queue->grant_rx_ref[i] are already cleared to NULL.
This leads to NULL pointer access in the next iteration to process rx ring
buffer entries.

The symptom is similar to the one fixed in
commit 00b368502d18 ("xen-netfront: do not assume sk_buff_head list is
empty in error handling").

This patch changes the return type of xennet_fill_frags() to indicate
whether it is successful or failed. The queue->rx.rsp_cons will be
always updated inside this function.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -887,9 +887,9 @@ static int xennet_set_skb_gso(struct sk_
 	return 0;
 }
 
-static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
-				  struct sk_buff *skb,
-				  struct sk_buff_head *list)
+static int xennet_fill_frags(struct netfront_queue *queue,
+			     struct sk_buff *skb,
+			     struct sk_buff_head *list)
 {
 	RING_IDX cons = queue->rx.rsp_cons;
 	struct sk_buff *nskb;
@@ -908,7 +908,7 @@ static RING_IDX xennet_fill_frags(struct
 		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
 			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
 			kfree_skb(nskb);
-			return ~0U;
+			return -ENOENT;
 		}
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -919,7 +919,9 @@ static RING_IDX xennet_fill_frags(struct
 		kfree_skb(nskb);
 	}
 
-	return cons;
+	queue->rx.rsp_cons = cons;
+
+	return 0;
 }
 
 static int checksum_setup(struct net_device *dev, struct sk_buff *skb)
@@ -1045,8 +1047,7 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		i = xennet_fill_frags(queue, skb, &tmpq);
-		if (unlikely(i == ~0U))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
 			goto err;
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
@@ -1056,7 +1057,7 @@ err:
 
 		__skb_queue_tail(&rxq, skb);
 
-		queue->rx.rsp_cons = ++i;
+		i = ++queue->rx.rsp_cons;
 		work_done++;
 	}
 


