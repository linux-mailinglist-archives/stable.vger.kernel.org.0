Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2973147AB73
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhLTOgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhLTOgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:36:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF064C06175B;
        Mon, 20 Dec 2021 06:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8022EB80EE4;
        Mon, 20 Dec 2021 14:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B08C36AE7;
        Mon, 20 Dec 2021 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010999;
        bh=t1dMpFf3j5CuNqrxOKolOP8OviOWu3ZjwbgahhGG8DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2O5YNEjYlHq6gtCv/2zFSaG+vhdM6OhUt5xITQ3Q2O2zD6zfNeKlSvjgJpe6KMm1w
         aAAATCAwvJ90bRog8YZRE38dIY/IJOBkmEI8QOOF5Llgyn7m625Ic1wWtAQdtcGnt3
         hUWhgCOmAeWnSK0kNI6JbZhwWPJwxCvaRZGgFeWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.4 23/23] xen/netback: dont queue unlimited number of packages
Date:   Mon, 20 Dec 2021 15:34:24 +0100
Message-Id: <20211220143018.590839553@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
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
 drivers/net/xen-netback/netback.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -189,11 +189,15 @@ void xenvif_rx_queue_tail(struct xenvif_
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
-	__skb_queue_tail(&queue->rx_queue, skb);
-
-	queue->rx_queue_len += skb->len;
-	if (queue->rx_queue_len > queue->rx_queue_max)
+	if (queue->rx_queue_len >= queue->rx_queue_max) {
 		netif_tx_stop_queue(netdev_get_tx_queue(queue->vif->dev, queue->id));
+		kfree_skb(skb);
+		queue->vif->dev->stats.rx_dropped++;
+	} else {
+		__skb_queue_tail(&queue->rx_queue, skb);
+
+		queue->rx_queue_len += skb->len;
+	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
 }
@@ -243,6 +247,7 @@ static void xenvif_rx_queue_drop_expired
 			break;
 		xenvif_rx_dequeue(queue);
 		kfree_skb(skb);
+		queue->vif->dev->stats.rx_dropped++;
 	}
 }
 


