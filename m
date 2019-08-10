Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902AF88DA8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHJUoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:44:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54868 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbfHJUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDW-00053r-KH; Sat, 10 Aug 2019 21:43:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003iD-K8; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Laight" <David.Laight@aculab.com>,
        "Willem de Bruijn" <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.152150829@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 119/157] packet: validate msg_namelen in send directly
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 486efdc8f6ce802b27e15921d2353cc740c55451 upstream.

Packet sockets in datagram mode take a destination address. Verify its
length before passing to dev_hard_header.

Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
established behavior. Directly compare msg_namelen to dev->addr_len.

Change v1->v2: initialize addr in all paths

Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2278,8 +2278,8 @@ static int tpacket_snd(struct packet_soc
 	void *ph;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
 	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
+	unsigned char *addr = NULL;
 	int tp_len, size_max;
-	unsigned char *addr;
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen;
@@ -2289,7 +2289,6 @@ static int tpacket_snd(struct packet_soc
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-		addr	= NULL;
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2299,10 +2298,13 @@ static int tpacket_snd(struct packet_soc
 						sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_put;
+		if (po->sk.sk_socket->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_put;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;
@@ -2435,7 +2437,7 @@ static int packet_snd(struct socket *soc
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	unsigned char *addr;
+	unsigned char *addr = NULL;
 	int err, reserve = 0;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int offset = 0;
@@ -2453,7 +2455,6 @@ static int packet_snd(struct socket *soc
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-		addr	= NULL;
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2461,10 +2462,13 @@ static int packet_snd(struct socket *soc
 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_unlock;
+		if (sock->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_unlock;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;

