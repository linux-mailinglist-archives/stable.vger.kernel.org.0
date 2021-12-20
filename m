Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1776C47AD8B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhLTOwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbhLTOuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB9DC08E847;
        Mon, 20 Dec 2021 06:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43141611AD;
        Mon, 20 Dec 2021 14:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E5EC36AE9;
        Mon, 20 Dec 2021 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011577;
        bh=nih9dZrU8O63ScahyWDZ8/H1Eobq4ZvyR31ISJE4lLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Xh5ddYjlHOoW05MQOo00tRdHicPFxvf5U1kD6UHnsWPoOyxflAWsosjHtiMJ4DEX
         6QDqMJUcKIBspGimGLAcIkM2mhkbn8d12B5WultjrHUZUmvmaP10HpQoXKYUwNashs
         dOgXLYIW4K0FlLT5l708ooIt9oCmhXIp+rgD0f8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 71/71] xen/netback: dont queue unlimited number of packages
Date:   Mon, 20 Dec 2021 15:35:00 +0100
Message-Id: <20211220143028.085425310@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
 


