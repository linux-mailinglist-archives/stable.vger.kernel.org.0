Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4985C7468F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403967AbfGYFjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403993AbfGYFjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:39:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2AB822C7C;
        Thu, 25 Jul 2019 05:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033150;
        bh=KSrQa5ZxQQspKGIAMLddBTsakG3q+15HKrrPZhyAXIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLVI5GUPwJiPekqtI8aDn/lrR+GSexTUkFc9CmZj8HlO1Ds+6f0jZLvNMWIzNbXlL
         CQulCUieXc6P0Gem5TACZQm5Z5aiV+YDu/2kp+1nsMgrd8IRM/o8yv24kk35zMpjuI
         DJ0FPcYdsVzq/7xbVu4ciyMWUYOCM2HsHlxSyFSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/271] mt7601u: fix possible memory leak when the device is disconnected
Date:   Wed, 24 Jul 2019 21:19:37 +0200
Message-Id: <20190724191704.455455275@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 23377c200b2eb48a60d0f228b2a2e75ed6ee6060 ]

When the device is disconnected while passing traffic it is possible
to receive out of order urbs causing a memory leak since the skb linked
to the current tx urb is not removed. Fix the issue deallocating the skb
cleaning up the tx ring. Moreover this patch fixes the following kernel
warning

[   57.480771] usb 1-1: USB disconnect, device number 2
[   57.483451] ------------[ cut here ]------------
[   57.483462] TX urb mismatch
[   57.483481] WARNING: CPU: 1 PID: 32 at drivers/net/wireless/mediatek/mt7601u/dma.c:245 mt7601u_complete_tx+0x165/00
[   57.483483] Modules linked in:
[   57.483496] CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.2.0-rc1+ #72
[   57.483498] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-2.fc30 04/01/2014
[   57.483502] Workqueue: usb_hub_wq hub_event
[   57.483507] RIP: 0010:mt7601u_complete_tx+0x165/0x1e0
[   57.483510] Code: 8b b5 10 04 00 00 8b 8d 14 04 00 00 eb 8b 80 3d b1 cb e1 00 00 75 9e 48 c7 c7 a4 ea 05 82 c6 05 f
[   57.483513] RSP: 0000:ffffc900000a0d28 EFLAGS: 00010092
[   57.483516] RAX: 000000000000000f RBX: ffff88802c0a62c0 RCX: ffffc900000a0c2c
[   57.483518] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff810a8371
[   57.483520] RBP: ffff88803ced6858 R08: 0000000000000000 R09: 0000000000000001
[   57.483540] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000046
[   57.483542] R13: ffff88802c0a6c88 R14: ffff88803baab540 R15: ffff88803a0cc078
[   57.483548] FS:  0000000000000000(0000) GS:ffff88803eb00000(0000) knlGS:0000000000000000
[   57.483550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.483552] CR2: 000055e7f6780100 CR3: 0000000028c86000 CR4: 00000000000006a0
[   57.483554] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   57.483556] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   57.483559] Call Trace:
[   57.483561]  <IRQ>
[   57.483565]  __usb_hcd_giveback_urb+0x77/0xe0
[   57.483570]  xhci_giveback_urb_in_irq.isra.0+0x8b/0x140
[   57.483574]  handle_cmd_completion+0xf5b/0x12c0
[   57.483577]  xhci_irq+0x1f6/0x1810
[   57.483581]  ? lockdep_hardirqs_on+0x9e/0x180
[   57.483584]  ? _raw_spin_unlock_irq+0x24/0x30
[   57.483588]  __handle_irq_event_percpu+0x3a/0x260
[   57.483592]  handle_irq_event_percpu+0x1c/0x60
[   57.483595]  handle_irq_event+0x2f/0x4c
[   57.483599]  handle_edge_irq+0x7e/0x1a0
[   57.483603]  handle_irq+0x17/0x20
[   57.483607]  do_IRQ+0x54/0x110
[   57.483610]  common_interrupt+0xf/0xf
[   57.483612]  </IRQ>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 21 ++++++++++++++++-----
 drivers/net/wireless/mediatek/mt7601u/tx.c  |  4 ++--
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index bc36712cfffc..47cebb2ec05c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -241,14 +241,25 @@ static void mt7601u_complete_tx(struct urb *urb)
 	struct sk_buff *skb;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->tx_lock, flags);
+	switch (urb->status) {
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+	case -ENOENT:
+		return;
+	default:
+		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
+				    urb->status);
+		/* fall through */
+	case 0:
+		break;
+	}
 
-	if (mt7601u_urb_has_error(urb))
-		dev_err(dev->dev, "Error: TX urb failed:%d\n", urb->status);
+	spin_lock_irqsave(&dev->tx_lock, flags);
 	if (WARN_ONCE(q->e[q->start].urb != urb, "TX urb mismatch"))
 		goto out;
 
 	skb = q->e[q->start].skb;
+	q->e[q->start].skb = NULL;
 	trace_mt_tx_dma_done(dev, skb);
 
 	__skb_queue_tail(&dev->tx_skb_done, skb);
@@ -448,10 +459,10 @@ static void mt7601u_free_tx_queue(struct mt7601u_tx_queue *q)
 {
 	int i;
 
-	WARN_ON(q->used);
-
 	for (i = 0; i < q->entries; i++)  {
 		usb_poison_urb(q->e[i].urb);
+		if (q->e[i].skb)
+			mt7601u_tx_status(q->dev, q->e[i].skb);
 		usb_free_urb(q->e[i].urb);
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/tx.c b/drivers/net/wireless/mediatek/mt7601u/tx.c
index 3600e911a63e..4d81c45722fb 100644
--- a/drivers/net/wireless/mediatek/mt7601u/tx.c
+++ b/drivers/net/wireless/mediatek/mt7601u/tx.c
@@ -117,9 +117,9 @@ void mt7601u_tx_status(struct mt7601u_dev *dev, struct sk_buff *skb)
 	info->status.rates[0].idx = -1;
 	info->flags |= IEEE80211_TX_STAT_ACK;
 
-	spin_lock(&dev->mac_lock);
+	spin_lock_bh(&dev->mac_lock);
 	ieee80211_tx_status(dev->hw, skb);
-	spin_unlock(&dev->mac_lock);
+	spin_unlock_bh(&dev->mac_lock);
 }
 
 static int mt7601u_skb_rooms(struct mt7601u_dev *dev, struct sk_buff *skb)
-- 
2.20.1



