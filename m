Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2D126BEB
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfLSTAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729010AbfLSSwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE50227BF;
        Thu, 19 Dec 2019 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781554;
        bh=jsqRNr+nBO4O6L99PWysluidD0j+SGeRfT7rFs8TGZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H71FkbnLr95j+WGp25gDwUj96cJJdVI97m/N1Cmt4t6IluwxtQ4EdmrHoo3JSt/WM
         ffPJM10KlhsPf97P7k5w+tljwRlfcXEwPhQ9ojCWUpzkqwc/HXKxKJWNGzMtEiQlfw
         fe1RFec9QGtU4pR1RzVJQqVJd2xXQlYgxx/1/nZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/47] net: dsa: fix flow dissection on Tx path
Date:   Thu, 19 Dec 2019 19:34:18 +0100
Message-Id: <20191219182900.428437738@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit 8bef0af09a5415df761b04fa487a6c34acae74bc ]

Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
ability to override protocol and network offset during flow dissection
for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
in order to fix skb hashing for RPS on Rx path.

However, skb_hash() and added part of code can be invoked not only on
Rx, but also on Tx path if we have a multi-queued device and:
 - kernel is running on UP system or
 - XPS is not configured.

The call stack in this two cases will be like: dev_queue_xmit() ->
__dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
skb_tx_hash() -> skb_get_hash().

The problem is that skbs queued for Tx have both network offset and
correct protocol already set up even after inserting a CPU tag by DSA
tagger, so calling tag_ops->flow_dissect() on this path actually only
breaks flow dissection and hashing.

This can be observed by adding debug prints just before and right after
tag_ops->flow_dissect() call to the related block of code:

Before the patch:

Rx path (RPS):

[   19.240001] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   19.244271] tag_ops->flow_dissect()
[   19.247811] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */

[   19.215435] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   19.219746] tag_ops->flow_dissect()
[   19.223241] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */

[   18.654057] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   18.658332] tag_ops->flow_dissect()
[   18.661826] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */

Tx path (UP system):

[   18.759560] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */
[   18.763933] tag_ops->flow_dissect()
[   18.767485] Tx: proto: 0x920b, nhoff: 34	/* junk */

[   22.800020] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */
[   22.804392] tag_ops->flow_dissect()
[   22.807921] Tx: proto: 0x920b, nhoff: 34	/* junk */

[   16.898342] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */
[   16.902705] tag_ops->flow_dissect()
[   16.906227] Tx: proto: 0x920b, nhoff: 34	/* junk */

After:

Rx path (RPS):

[   16.520993] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   16.525260] tag_ops->flow_dissect()
[   16.528808] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */

[   15.484807] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   15.490417] tag_ops->flow_dissect()
[   15.495223] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */

[   17.134621] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
[   17.138895] tag_ops->flow_dissect()
[   17.142388] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */

Tx path (UP system):

[   15.499558] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */

[   20.664689] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */

[   18.565782] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */

In order to fix that we can add the check 'proto == htons(ETH_P_XDSA)'
to prevent code from calling tag_ops->flow_dissect() on Tx.
I also decided to initialize 'offset' variable so tagger callbacks can
now safely leave it untouched without provoking a chaos.

Fixes: 43e665287f93 ("net-next: dsa: fix flow dissection")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -630,9 +630,10 @@ bool __skb_flow_dissect(const struct sk_
 		nhoff = skb_network_offset(skb);
 		hlen = skb_headlen(skb);
 #if IS_ENABLED(CONFIG_NET_DSA)
-		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev))) {
+		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
+			     proto == htons(ETH_P_XDSA))) {
 			const struct dsa_device_ops *ops;
-			int offset;
+			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
 			if (ops->flow_dissect &&


