Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63892594A8
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgIAPly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgIAPlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26CD92064B;
        Tue,  1 Sep 2020 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974911;
        bh=MCxPakGL9ABd29OvlEbGaratiOtRqPYeKeb2GiLmDas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utSV06jOcicgv2IKHL9+mnVL13cNhTykQZJd2MPdpUeYyJs6lrmZxjpGOsy8iE4WN
         /IhjI1ntU29VRsb9XaeRBU6LT2KgphHoeE/xcs1rB2B4m6lPMZjgkKt+8zOb1M3fTe
         W9Jq1WDjYgxmRNbCrxQ30RsWfeAlk64d+IsEIk4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 137/255] drivers/net/wan/hdlc_x25: Added needed_headroom and a skb->len check
Date:   Tue,  1 Sep 2020 17:09:53 +0200
Message-Id: <20200901151007.275354466@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 77b981c82c1df7c7ad32a046f17f007450b46954 ]

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Added needed_headroom and set hard_header_len to 0

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes.
So the value of needed_headroom in this driver should be 3 - 1.

Because this driver has no header_ops, according to the logic of
af_packet.c, the value of hard_header_len should be 0.

Reason of setting needed_headroom and hard_header_len at this place:

This driver is written using the API of the hdlc module, the hdlc
module enables this driver (the protocol driver) to run on any hardware
that has a driver (the hardware driver) written using the API of the
hdlc module.

Two other hdlc protocol drivers - hdlc_ppp and hdlc_raw_eth, also set
things like hard_header_len at this place. In hdlc_ppp, it sets
hard_header_len after attach_hdlc_protocol and before setting dev->type.
In hdlc_raw_eth, it sets hard_header_len by calling ether_setup after
attach_hdlc_protocol and after memcpy the settings.

3. Reset needed_headroom when detaching protocols (in hdlc.c)

When detaching a protocol from a hardware device, the hdlc module will
reset various parameters of the device (including hard_header_len) to
the default values. We add needed_headroom here so that needed_headroom
will also be reset.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc.c     |  1 +
 drivers/net/wan/hdlc_x25.c | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index dfc16770458d8..386ed2aa31fd9 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -230,6 +230,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
 	dev->hard_header_len	 = 16;
+	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
 }
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f70336bb6f524..f52b9fed05931 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -107,8 +107,14 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int result;
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
 
-	/* X.25 to LAPB */
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
@@ -294,6 +300,15 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+
+		/* There's no header_ops so hard_header_len should be 0. */
+		dev->hard_header_len = 0;
+		/* When transmitting data:
+		 * first we'll remove a pseudo header of 1 byte,
+		 * then we'll prepend an LAPB header of at most 3 bytes.
+		 */
+		dev->needed_headroom = 3 - 1;
+
 		dev->type = ARPHRD_X25;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
-- 
2.25.1



