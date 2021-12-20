Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6A47ABBB
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhLTOik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:38:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52766 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhLTOiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7486BCE1107;
        Mon, 20 Dec 2021 14:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F809C36AF7;
        Mon, 20 Dec 2021 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011086;
        bh=nih9dZrU8O63ScahyWDZ8/H1Eobq4ZvyR31ISJE4lLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXYlzMaIzFgF5tfRQMgKfTZ0UcZJAuW6VERnDHwRhRfH2sLb+BMHR2L2gcv8hGylj
         eaQixpf5vaSFFb4gcxI+0tQtn8Ir8YjWnR4pkajy4AglV1fixDX/cu3Lwpb6s3/AOQ
         dV72DRI0T2iK+/JYD19WN6cyP1f2ejj2jykyh6f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.9 31/31] xen/netback: dont queue unlimited number of packages
Date:   Mon, 20 Dec 2021 15:34:31 +0100
Message-Id: <20211220143020.963547129@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit be81992f9086b230623ae3ebbc85ecee4d00a3d3 upstream.

In case a guest isn't consuming incoming network traffic as fast as it
is coming in, xen-netback is buffering network packages in unlimited
numbers today. This can result in host OOM situations.

Commit f48da8b14d04ca8 ("xen-netback: fix unlimited guest Rx internal
queue and carrier flapping") meant to introduce a mechanism to limit
the amount of buffered data by stopping the Tx queue when reaching the
data limit, but this doesn't work for cases like UDP.

When hitting the limit don't queue further SKBs, but drop them instead.
In order to be able to tell Rx packages have been dropped increment the
rx_dropped statistics counter in this case.

It should be noted that the old solution to continue queueing SKBs had
the additional problem of an overflow of the 32-bit rx_queue_len value
would result in intermittent Tx queue enabling.

This is part of XSA-392

Fixes: f48da8b14d04ca8 ("xen-netback: fix unlimited guest Rx internal queue and carrier flapping")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/rx.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -88,16 +88,19 @@ void xenvif_rx_queue_tail(struct xenvif_
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
-	if (skb_queue_empty(&queue->rx_queue))
-		xenvif_update_needed_slots(queue, skb);
-
-	__skb_queue_tail(&queue->rx_queue, skb);
-
-	queue->rx_queue_len += skb->len;
-	if (queue->rx_queue_len > queue->rx_queue_max) {
+	if (queue->rx_queue_len >= queue->rx_queue_max) {
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
+		kfree_skb(skb);
+		queue->vif->dev->stats.rx_dropped++;
+	} else {
+		if (skb_queue_empty(&queue->rx_queue))
+			xenvif_update_needed_slots(queue, skb);
+
+		__skb_queue_tail(&queue->rx_queue, skb);
+
+		queue->rx_queue_len += skb->len;
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
@@ -147,6 +150,7 @@ static void xenvif_rx_queue_drop_expired
 			break;
 		xenvif_rx_dequeue(queue);
 		kfree_skb(skb);
+		queue->vif->dev->stats.rx_dropped++;
 	}
 }
 


