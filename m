Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF8A32E7FD
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhCEMYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhCEMYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B2965023;
        Fri,  5 Mar 2021 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947050;
        bh=JzGixYtf5+BvuzhWznR9rZ5FAYG6cscO50k4x1rw86E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzYZTUPcHUQaPYwDGZT7sFGSOo+I0peNTkUXqsbP0/BvaiaI9UO9H7eV5sIHRfqmR
         xIQRYGSbwlYNiUfZPWw6yLVX5vxJCVtIUPSj0yOWMJeWHUdpIBGB5sHOc3q5FqXJDc
         1H4z2xXX7Uzb54cDigiKv5aE/h84rvswP19kXzAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 029/104] net: dsa: tag_rtl4_a: Support also egress tags
Date:   Fri,  5 Mar 2021 13:20:34 +0100
Message-Id: <20210305120904.607248623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 86dd9868b8788a9063893a97649594af93cd5aa6 upstream.

Support also transmitting frames using the custom "8899 A"
4 byte tag.

Qingfang came up with the solution: we need to pad the
ethernet frame to 60 bytes using eth_skb_pad(), then the
switch will happily accept frames with custom tags.

Cc: Mauri Sandberg <sandberg@mailfence.com>
Reported-by: DENG Qingfang <dqfext@gmail.com>
Fixes: efd7fe68f0c6 ("net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_rtl4_a.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -12,9 +12,7 @@
  *
  * The 2 bytes tag form a 16 bit big endian word. The exact
  * meaning has been guessed from packet dumps from ingress
- * frames, as no working egress traffic has been available
- * we do not know the format of the egress tags or if they
- * are even supported.
+ * frames.
  */
 
 #include <linux/etherdevice.h>
@@ -36,17 +34,34 @@
 static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	/*
-	 * Just let it pass thru, we don't know if it is possible
-	 * to tag a frame with the 0x8899 ethertype and direct it
-	 * to a specific port, all attempts at reverse-engineering have
-	 * ended up with the frames getting dropped.
-	 *
-	 * The VLAN set-up needs to restrict the frames to the right port.
-	 *
-	 * If you have documentation on the tagging format for RTL8366RB
-	 * (tag type A) then please contribute.
-	 */
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 *tag;
+	u16 *p;
+	u16 out;
+
+	/* Pad out to at least 60 bytes */
+	if (unlikely(eth_skb_pad(skb)))
+		return NULL;
+	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
+		return NULL;
+
+	netdev_dbg(dev, "add realtek tag to package to port %d\n",
+		   dp->index);
+	skb_push(skb, RTL4_A_HDR_LEN);
+
+	memmove(skb->data, skb->data + RTL4_A_HDR_LEN, 2 * ETH_ALEN);
+	tag = skb->data + 2 * ETH_ALEN;
+
+	/* Set Ethertype */
+	p = (u16 *)tag;
+	*p = htons(RTL4_A_ETHERTYPE);
+
+	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
+	/* The lower bits is the port numer */
+	out |= (u8)dp->index;
+	p = (u16 *)(tag + 2);
+	*p = htons(out);
+
 	return skb;
 }
 


