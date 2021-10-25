Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3025243A208
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbhJYToe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236830AbhJYTli (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:41:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04020610FD;
        Mon, 25 Oct 2021 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190598;
        bh=r2/PJs0znIkT0ty4CiIasvQpyO9PStZ1x0WDDOEs0AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUeLq8PbtOA7G44Pvvz+e0I733Ppir7k3Ye8lBGKI8LbWISy30xk52uYpOsAJfWvP
         p89R520jJmnfXshrztBuFFtO05hw0naFE7OvXvtMAclVlY+rdY6i3jBoHgWGvlpMvB
         aq8gxL2rMQc2gBLZNYTLnTdBOhA+dOEmstgM4m10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason-ch Chen <jason-ch.chen@mediatek.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 008/169] r8152: avoid to resubmit rx immediately
Date:   Mon, 25 Oct 2021 21:13:09 +0200
Message-Id: <20211025191018.801159667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit baf33d7a75642b4b38a87fdf1cd96b506df4849f ]

For the situation that the disconnect event comes very late when the
device is unplugged, the driver would resubmit the RX bulk transfer
after getting the callback with -EPROTO immediately and continually.
Finally, soft lockup occurs.

This patch avoids to resubmit RX immediately. It uses a workqueue to
schedule the RX NAPI. And the NAPI would resubmit the RX. It let the
disconnect event have opportunity to stop the submission before soft
lockup.

Reported-by: Jason-ch Chen <jason-ch.chen@mediatek.com>
Tested-by: Jason-ch Chen <jason-ch.chen@mediatek.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 79832374f78d..92fca5e9ed03 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -767,6 +767,7 @@ enum rtl8152_flags {
 	PHY_RESET,
 	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
+	RX_EPROTO,
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
@@ -1770,6 +1771,14 @@ static void read_bulk_callback(struct urb *urb)
 		rtl_set_unplug(tp);
 		netif_device_detach(tp->netdev);
 		return;
+	case -EPROTO:
+		urb->actual_length = 0;
+		spin_lock_irqsave(&tp->rx_lock, flags);
+		list_add_tail(&agg->list, &tp->rx_done);
+		spin_unlock_irqrestore(&tp->rx_lock, flags);
+		set_bit(RX_EPROTO, &tp->flags);
+		schedule_delayed_work(&tp->schedule, 1);
+		return;
 	case -ENOENT:
 		return;	/* the urb is in unlink state */
 	case -ETIME:
@@ -2425,6 +2434,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 	if (list_empty(&tp->rx_done))
 		goto out1;
 
+	clear_bit(RX_EPROTO, &tp->flags);
 	INIT_LIST_HEAD(&rx_queue);
 	spin_lock_irqsave(&tp->rx_lock, flags);
 	list_splice_init(&tp->rx_done, &rx_queue);
@@ -2441,7 +2451,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 
 		agg = list_entry(cursor, struct rx_agg, list);
 		urb = agg->urb;
-		if (urb->actual_length < ETH_ZLEN)
+		if (urb->status != 0 || urb->actual_length < ETH_ZLEN)
 			goto submit;
 
 		agg_free = rtl_get_free_rx(tp, GFP_ATOMIC);
@@ -6643,6 +6653,10 @@ static void rtl_work_func_t(struct work_struct *work)
 	    netif_carrier_ok(tp->netdev))
 		tasklet_schedule(&tp->tx_tl);
 
+	if (test_and_clear_bit(RX_EPROTO, &tp->flags) &&
+	    !list_empty(&tp->rx_done))
+		napi_schedule(&tp->napi);
+
 	mutex_unlock(&tp->control);
 
 out1:
-- 
2.33.0



