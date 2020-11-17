Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703202B6040
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgKQNHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbgKQNHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:07:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD8324698;
        Tue, 17 Nov 2020 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618440;
        bh=c1RjsYpybytkZYv5J8jzew395hSj7ZM48MZi/yF+9rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC8w9cyJ5/MrVqd8NJ3esNthCKF+F7SRye2w3iRuRwa4wEvUMKetVYmhGUDXMblKk
         u6FyVGE9hrHVeBWdegSTmnKg9sDWhfS+j0lwzurYgqXYmklqwukEbDA9BVsC7uVb3o
         L031ndPWIMwKjOyHkoIITgR7DcTE+Qy2w7V7t4nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/64] can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context
Date:   Tue, 17 Nov 2020 14:04:32 +0100
Message-Id: <20201117122106.599646315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 2283f79b22684d2812e5c76fc2280aae00390365 ]

If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
not always, the case), the 'WARN_ON(in_irq)' in
net/core/skbuff.c#skb_release_head_state() might be triggered, under network
congestion circumstances, together with the potential risk of a NULL pointer
dereference.

The root cause of this issue is the call to kfree_skb() instead of
dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().

This patch prevents the skb to be freed within the call to netif_rx() by
incrementing its reference count with skb_get(). The skb is finally freed by
one of the in-irq-context safe functions: dev_consume_skb_any() or
dev_kfree_skb_any(). The "any" version is used because some drivers might call
can_get_echo_skb() in a normal context.

The reason for this issue to occur is that initially, in the core network
stack, loopback skb were not supposed to be received in hardware IRQ context.
The CAN stack is an exeption.

This bug was previously reported back in 2017 in [1] but the proposed patch
never got accepted.

While [1] directly modifies net/core/dev.c, we try to propose here a
smoother modification local to CAN network stack (the assumption
behind is that only CAN devices are affected by this issue).

[1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 9dd968ee792e0..3c0f141262ad5 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -466,7 +466,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
 	if (!skb)
 		return 0;
 
-	netif_rx(skb);
+	skb_get(skb);
+	if (netif_rx(skb) == NET_RX_SUCCESS)
+		dev_consume_skb_any(skb);
+	else
+		dev_kfree_skb_any(skb);
 
 	return len;
 }
-- 
2.27.0



