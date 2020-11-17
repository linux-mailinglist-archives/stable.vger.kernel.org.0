Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508F82B6631
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgKQNJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgKQNJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:09:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56962225B;
        Tue, 17 Nov 2020 13:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618563;
        bh=sqohEiHw2DyEKnZcJxyoc6VpB1kp/IeXQp8ti6EM8Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGtVdMgj6QLdJ70S666tJTYjGf6IumxpnxEktEIyzlTZrulkLwzZOet8f9fI3yaBN
         Gpi0w1hVWlwfM71cjLuneEMM6PUZnS7cmeHmpm/IY0rAev8NsnWDGpuWT6aDZ/68TF
         Gcip6z63gSI8Ocd6sAM29gCsMeMIArhpkLQb5RCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/78] can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context
Date:   Tue, 17 Nov 2020 14:04:37 +0100
Message-Id: <20201117122109.652553599@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
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
index ffc5467a1ec2b..aa2158fabf2ac 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -496,7 +496,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
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



