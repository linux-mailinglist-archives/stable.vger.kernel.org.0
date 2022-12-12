Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2FD64A0B8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiLLN33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiLLN3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:29:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4A8655B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C426B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA4BC433D2;
        Mon, 12 Dec 2022 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851757;
        bh=Vo+zy6uTFPY4i8+o+hOqUO4ofphXuHBZn/n0T/RrBy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueYL/Jqjp8DC4CBYzQNY0pogQEmgGzC5grGb7HWKUelj3fKGQYjKmDXMhwG3TsiRD
         OLmlXUH7H1ezLP1kFtG/Vif3FnaYyWmapqJ6+5kO+gWcCPsdcx8IUkNJ/upRiAySuR
         PEzOJ9sPZFBLBDK6TshsRKDtlwZyMf8fTiko/TyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/123] xen/netback: dont call kfree_skb() with interrupts disabled
Date:   Mon, 12 Dec 2022 14:16:44 +0100
Message-Id: <20221212130928.512949781@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 74e7e1efdad45580cc3839f2a155174cf158f9b5 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So remove kfree_skb()
from the spin_lock_irqsave() section and use the already existing
"drop" label in xenvif_start_xmit() for dropping the SKB. At the
same time replace the dev_kfree_skb() call there with a call of
dev_kfree_skb_any(), as xenvif_start_xmit() can be called with
disabled interrupts.

This is XSA-424 / CVE-2022-42328 / CVE-2022-42329.

Fixes: be81992f9086 ("xen/netback: don't queue unlimited number of packages")
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/common.h    | 2 +-
 drivers/net/xen-netback/interface.c | 6 ++++--
 drivers/net/xen-netback/rx.c        | 8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 8174d7b2966c..adfd21aa5b6a 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -386,7 +386,7 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index e31936876e1f..e1a5610b1747 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -255,14 +255,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 932762177110..0ba754ebc5ba 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
-- 
2.35.1



