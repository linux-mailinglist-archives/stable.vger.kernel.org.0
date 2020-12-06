Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5343E2D0476
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgLFLpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgLFLpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:49 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 15/46] net/packet: fix packet receive on L3 devices without visible hard header
Date:   Sun,  6 Dec 2020 12:17:23 +0100
Message-Id: <20201206111557.197220214@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit d549699048b4b5c22dd710455bcdb76966e55aa3 ]

In the patchset merged by commit b9fcf0a0d826
("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
did not have header_ops were given one for the purpose of protocol parsing
on af_packet transmit path.

That change made af_packet receive path regard these devices as having a
visible L3 header and therefore aligned incoming skb->data to point to the
skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
reset their mac_header prior to ingress and therefore their incoming
packets became malformed.

Ideally these devices would reset their mac headers, or af_packet would be
able to rely on dev->hard_header_len being 0 for such cases, but it seems
this is not the case.

Fix by changing af_packet RX ll visibility criteria to include the
existence of a '.create()' header operation, which is used when creating
a device hard header - via dev_hard_header() - by upper layers, and does
not exist in these L3 devices.

As this predicate may be useful in other situations, add it as a common
dev_has_header() helper in netdevice.h.

Fixes: b9fcf0a0d826 ("Merge branch 'support-AF_PACKET-for-layer-3-devices'")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20201121062817.3178900-1-eyal.birger@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    5 +++++
 net/packet/af_packet.c    |   38 +++++++++++++++++++++-----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3103,6 +3103,11 @@ static inline bool dev_validate_header(c
 	return false;
 }
 
+static inline bool dev_has_header(const struct net_device *dev)
+{
+	return dev->header_ops && dev->header_ops->create;
+}
+
 typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr,
 			   int len, int size);
 int register_gifconf(unsigned int family, gifconf_func_t *gifconf);
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -93,38 +93,42 @@
 
 /*
    Assumptions:
-   - if device has no dev->hard_header routine, it adds and removes ll header
-     inside itself. In this case ll header is invisible outside of device,
-     but higher levels still should reserve dev->hard_header_len.
-     Some devices are enough clever to reallocate skb, when header
-     will not fit to reserved space (tunnel), another ones are silly
-     (PPP).
+   - If the device has no dev->header_ops->create, there is no LL header
+     visible above the device. In this case, its hard_header_len should be 0.
+     The device may prepend its own header internally. In this case, its
+     needed_headroom should be set to the space needed for it to add its
+     internal header.
+     For example, a WiFi driver pretending to be an Ethernet driver should
+     set its hard_header_len to be the Ethernet header length, and set its
+     needed_headroom to be (the real WiFi header length - the fake Ethernet
+     header length).
    - packet socket receives packets with pulled ll header,
      so that SOCK_RAW should push it back.
 
 On receive:
 -----------
 
-Incoming, dev->hard_header!=NULL
+Incoming, dev_has_header(dev) == true
    mac_header -> ll header
    data       -> data
 
-Outgoing, dev->hard_header!=NULL
+Outgoing, dev_has_header(dev) == true
    mac_header -> ll header
    data       -> ll header
 
-Incoming, dev->hard_header==NULL
-   mac_header -> UNKNOWN position. It is very likely, that it points to ll
-		 header.  PPP makes it, that is wrong, because introduce
-		 assymetry between rx and tx paths.
+Incoming, dev_has_header(dev) == false
+   mac_header -> data
+     However drivers often make it point to the ll header.
+     This is incorrect because the ll header should be invisible to us.
    data       -> data
 
-Outgoing, dev->hard_header==NULL
-   mac_header -> data. ll header is still not built!
+Outgoing, dev_has_header(dev) == false
+   mac_header -> data. ll header is invisible to us.
    data       -> data
 
 Resume
-  If dev->hard_header==NULL we are unlikely to restore sensible ll header.
+  If dev_has_header(dev) == false we are unable to restore the ll header,
+    because it is invisible to us.
 
 
 On transmit:
@@ -2066,7 +2070,7 @@ static int packet_rcv(struct sk_buff *sk
 
 	skb->dev = dev;
 
-	if (dev->header_ops) {
+	if (dev_has_header(dev)) {
 		/* The device has an explicit notion of ll header,
 		 * exported to higher levels.
 		 *
@@ -2195,7 +2199,7 @@ static int tpacket_rcv(struct sk_buff *s
 	if (!net_eq(dev_net(dev), sock_net(sk)))
 		goto drop;
 
-	if (dev->header_ops) {
+	if (dev_has_header(dev)) {
 		if (sk->sk_type != SOCK_DGRAM)
 			skb_push(skb, skb->data - skb_mac_header(skb));
 		else if (skb->pkt_type == PACKET_OUTGOING) {


