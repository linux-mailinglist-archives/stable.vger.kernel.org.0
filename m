Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52661991C2
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgCaJVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbgCaJJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:09:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FBD20675;
        Tue, 31 Mar 2020 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645780;
        bh=sK3YWrsln2c5DjXqe0JsNqeS0055gUJoHOjeSG4dO8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+z/efKm6rATIVkKSqh7vesmVvMTesmwqYXKo7sZW1CZ9sAMSYGAK9tohLxUSP/IC
         7akxJjbyuQAP7TUvErjPQLXTI2ivGz4PZM6L8F9O8nRN2Xqi/TBf8/We0dpPWGhT+g
         724xkYqYEwtjKikxJGwvTbwbpV8cEXQfxTSamiuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 5.5 163/170] staging: wfx: annotate nested gc_list vs tx queue locking
Date:   Tue, 31 Mar 2020 10:59:37 +0200
Message-Id: <20200331085440.081276284@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit e2525a95cc0887c7dc0549cb5d0ac3e796e1d54c upstream.

Lockdep is complaining about recursive locking, because it can't make
a difference between locked skb_queues. Annotate nested locks and avoid
double bh_disable/enable.

[...]
insmod/815 is trying to acquire lock:
cb7d6418 (&(&list->lock)->rlock){+...}, at: wfx_tx_queues_clear+0xfc/0x198 [wfx]

but task is already holding lock:
cb7d61f4 (&(&list->lock)->rlock){+...}, at: wfx_tx_queues_clear+0xa0/0x198 [wfx]

[...]
Possible unsafe locking scenario:

      CPU0
      ----
 lock(&(&list->lock)->rlock);
 lock(&(&list->lock)->rlock);

Cc: stable@vger.kernel.org
Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/5e30397af95854b4a7deea073b730c00229f42ba.1581416843.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wfx/queue.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/staging/wfx/queue.c
+++ b/drivers/staging/wfx/queue.c
@@ -132,12 +132,12 @@ static void wfx_tx_queue_clear(struct wf
 	spin_lock_bh(&queue->queue.lock);
 	while ((item = __skb_dequeue(&queue->queue)) != NULL)
 		skb_queue_head(gc_list, item);
-	spin_lock_bh(&stats->pending.lock);
+	spin_lock_nested(&stats->pending.lock, 1);
 	for (i = 0; i < ARRAY_SIZE(stats->link_map_cache); ++i) {
 		stats->link_map_cache[i] -= queue->link_map_cache[i];
 		queue->link_map_cache[i] = 0;
 	}
-	spin_unlock_bh(&stats->pending.lock);
+	spin_unlock(&stats->pending.lock);
 	spin_unlock_bh(&queue->queue.lock);
 }
 
@@ -213,9 +213,9 @@ void wfx_tx_queue_put(struct wfx_dev *wd
 
 	++queue->link_map_cache[tx_priv->link_id];
 
-	spin_lock_bh(&stats->pending.lock);
+	spin_lock_nested(&stats->pending.lock, 1);
 	++stats->link_map_cache[tx_priv->link_id];
-	spin_unlock_bh(&stats->pending.lock);
+	spin_unlock(&stats->pending.lock);
 	spin_unlock_bh(&queue->queue.lock);
 }
 
@@ -244,11 +244,11 @@ static struct sk_buff *wfx_tx_queue_get(
 		__skb_unlink(skb, &queue->queue);
 		--queue->link_map_cache[tx_priv->link_id];
 
-		spin_lock_bh(&stats->pending.lock);
+		spin_lock_nested(&stats->pending.lock, 1);
 		__skb_queue_tail(&stats->pending, skb);
 		if (!--stats->link_map_cache[tx_priv->link_id])
 			wakeup_stats = true;
-		spin_unlock_bh(&stats->pending.lock);
+		spin_unlock(&stats->pending.lock);
 	}
 	spin_unlock_bh(&queue->queue.lock);
 	if (wakeup_stats)
@@ -266,10 +266,10 @@ int wfx_pending_requeue(struct wfx_dev *
 	spin_lock_bh(&queue->queue.lock);
 	++queue->link_map_cache[tx_priv->link_id];
 
-	spin_lock_bh(&stats->pending.lock);
+	spin_lock_nested(&stats->pending.lock, 1);
 	++stats->link_map_cache[tx_priv->link_id];
 	__skb_unlink(skb, &stats->pending);
-	spin_unlock_bh(&stats->pending.lock);
+	spin_unlock(&stats->pending.lock);
 	__skb_queue_tail(&queue->queue, skb);
 	spin_unlock_bh(&queue->queue.lock);
 	return 0;


