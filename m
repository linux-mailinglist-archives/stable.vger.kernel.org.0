Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017734929E
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfFQVWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729026AbfFQVWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080062089E;
        Mon, 17 Jun 2019 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806522;
        bh=eoircKri8yZq6TBBlqggoJktGga+3JD24JCOXyw7Q5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2jogH6bllmQ+FkN+iB8DSvwGI4DJgYYb/MiTZkmZZLKusw57fF/5JE8UJqncyV6n
         +g3oFCE/zSx/PujfOunqd2oW+vdvum+aEo/rmFF+dIQMxEOndrV6bkzni1wColZjtR
         aFKsuJzLvRKKkqBleQtwocXpkDTiJ2yacRzIBTl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Zweigle <Oliver.Zweigle@faro.com>,
        Bernd Eckstein <3ernd.Eckstein@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 080/115] usbnet: ipheth: fix racing condition
Date:   Mon, 17 Jun 2019 23:09:40 +0200
Message-Id: <20190617210804.063164863@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 94d250fae48e6f873d8362308f5c4d02cd1b1fd2 ]

Fix a racing condition in ipheth.c that can lead to slow performance.

Bug: In ipheth_tx(), netif_wake_queue() may be called on the callback
ipheth_sndbulk_callback(), _before_ netif_stop_queue() is called.
When this happens, the queue is stopped longer than it needs to be,
thus reducing network performance.

Fix: Move netif_stop_queue() in front of usb_submit_urb(). Now the order
is always correct. In case, usb_submit_urb() fails, the queue is woken up
again as callback will not fire.

Testing: This racing condition is usually not noticeable, as it has to
occur very frequently to slowdown the network. The callback from the USB
is usually triggered slow enough, so the situation does not appear.
However, on a Ubuntu Linux on VMWare Workstation, running on Windows 10,
the we loose the race quite often and the following speedup can be noticed:

Without this patch: Download:  4.10 Mbit/s, Upload:  4.01 Mbit/s
With this patch:    Download: 36.23 Mbit/s, Upload: 17.61 Mbit/s

Signed-off-by: Oliver Zweigle <Oliver.Zweigle@faro.com>
Signed-off-by: Bernd Eckstein <3ernd.Eckstein@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 3d8a70d3ea9b..3d71f1716390 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -437,17 +437,18 @@ static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
 			  dev);
 	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
+	netif_stop_queue(net);
 	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
 	if (retval) {
 		dev_err(&dev->intf->dev, "%s: usb_submit_urb: %d\n",
 			__func__, retval);
 		dev->net->stats.tx_errors++;
 		dev_kfree_skb_any(skb);
+		netif_wake_queue(net);
 	} else {
 		dev->net->stats.tx_packets++;
 		dev->net->stats.tx_bytes += skb->len;
 		dev_consume_skb_any(skb);
-		netif_stop_queue(net);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.20.1



