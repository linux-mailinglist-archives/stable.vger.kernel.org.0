Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6FD28BA6C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbgJLOI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgJLNcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E0482074F;
        Mon, 12 Oct 2020 13:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509544;
        bh=V6sTFayAGiEYnfb+Hq0fDTDH/IIa3If7oH8PKbGKk7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxUddXNcsVNlI/9q7WQ6t1SQUB63nFkmOCCbTWDrQ5ZZI7V8wtdHpze8TiQVYfBiO
         GZthEX7Yuw+cEJsPlfppGcaJmeos+3/gpTSdADqsAJweOjAIrPRv70wVZ+8QdVveeo
         WrMlUZSpk0cLUggI3xcp5HX22PrYVw9P+DkCHq6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/39] drivers/net/wan/hdlc: Set skb->protocol before transmitting
Date:   Mon, 12 Oct 2020 15:26:37 +0200
Message-Id: <20201012132628.493149245@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 9fb030a70431a2a2a1b292dbf0b2f399cc072c16 ]

This patch sets skb->protocol before transmitting frames on the HDLC
device, so that a user listening on the HDLC device with an AF_PACKET
socket will see outgoing frames' sll_protocol field correctly set and
consistent with that of incoming frames.

1. Control frames in hdlc_cisco and hdlc_ppp

When these drivers send control frames, skb->protocol is not set.

This value should be set to htons(ETH_P_HDLC), because when receiving
control frames, their skb->protocol is set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, which then calls
cisco_type_trans or ppp_type_trans. The skb->protocol of control frames
is set to htons(ETH_P_HDLC) so that the control frames can be received
by hdlc_rcv in hdlc.c, which calls cisco_rx or ppp_rx to process the
control frames.

2. hdlc_fr

When this driver sends control frames, skb->protocol is set to internal
values used in this driver.

When this driver sends data frames (from upper stacked PVC devices),
skb->protocol is the same as that of the user data packet being sent on
the upper PVC device (for normal PVC devices), or is htons(ETH_P_802_3)
(for Ethernet-emulating PVC devices).

However, skb->protocol for both control frames and data frames should be
set to htons(ETH_P_HDLC), because when receiving, all frames received on
the HDLC device will have their skb->protocol set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, and because this
driver doesn't provide a type_trans function in struct hdlc_proto,
all frames will have their skb->protocol set to htons(ETH_P_HDLC).
The frames are then received by hdlc_rcv in hdlc.c, which calls fr_rx
to process the frames (control frames are consumed and data frames
are re-received on upper PVC devices).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 drivers/net/wan/hdlc_fr.c    | 3 +++
 drivers/net/wan/hdlc_ppp.c   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index f8ed079d8bc3e..7a6f851d9843a 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -120,6 +120,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	skb_put(skb, sizeof(struct cisco_packet));
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 89541cc90e877..74d46f7e77eaa 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -435,6 +435,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (pvc->state.fecn) /* TX Congestion counter */
 				dev->stats.tx_compressed++;
 			skb->dev = pvc->frad;
+			skb->protocol = htons(ETH_P_HDLC);
+			skb_reset_network_header(skb);
 			dev_queue_xmit(skb);
 			return NETDEV_TX_OK;
 		}
@@ -557,6 +559,7 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	skb_put(skb, i);
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index a2559f213daed..473a9b8ec9ba5 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -254,6 +254,7 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 	skb_queue_tail(&tx_queue, skb);
 }
-- 
2.25.1



