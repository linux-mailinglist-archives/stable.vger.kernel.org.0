Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E51E2EBE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390364AbgEZS6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbgEZS6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECEC9208B3;
        Tue, 26 May 2020 18:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519512;
        bh=gLO9TxPKPmQEBtghshP8SXnLozpdrF8yCro+cbXp6Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBVjCgci6yaiWEL4RIt3y5KY0ximKvEY4G5oTrYhE/c82KhkhXmYXVAQy/k8FfMiQ
         wInXwWJnPo87vw4v8aTfFm4GASYmKx4eegZZ8TCKGUz4OGyqmcApcvuOOmPOUlROqr
         cqxmy4f59ly1wFgtIEp4MUtMZ95MkqJwTCPLhaIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "R. Parameswaran" <rparames@brocade.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 31/64] L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
Date:   Tue, 26 May 2020 20:53:00 +0200
Message-Id: <20200526183922.781834308@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "R. Parameswaran" <parameswaran.r7@gmail.com>

commit b784e7ebfce8cfb16c6f95e14e8532d0768ab7ff upstream.

Existing L2TP kernel code does not derive the optimal MTU for Ethernet
pseudowires and instead leaves this to a userspace L2TP daemon or
operator. If an MTU is not specified, the existing kernel code chooses
an MTU that does not take account of all tunnel header overheads, which
can lead to unwanted IP fragmentation. When L2TP is used without a
control plane (userspace daemon), we would prefer that the kernel does a
better job of choosing a default pseudowire MTU, taking account of all
tunnel header overheads, including IP header options, if any. This patch
addresses this.

Change-set here uses the new kernel function, kernel_sock_ip_overhead(),
to factor the outer IP overhead on the L2TP tunnel socket (including
IP Options, if any) when calculating the default MTU for an Ethernet
pseudowire, along with consideration of the inner Ethernet header.

Signed-off-by: R. Parameswaran <rparames@brocade.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_eth.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -30,6 +30,9 @@
 #include <net/xfrm.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
 
 #include "l2tp_core.h"
 
@@ -206,6 +209,53 @@ static void l2tp_eth_show(struct seq_fil
 }
 #endif
 
+static void l2tp_eth_adjust_mtu(struct l2tp_tunnel *tunnel,
+				struct l2tp_session *session,
+				struct net_device *dev)
+{
+	unsigned int overhead = 0;
+	struct dst_entry *dst;
+	u32 l3_overhead = 0;
+
+	/* if the encap is UDP, account for UDP header size */
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
+		overhead += sizeof(struct udphdr);
+		dev->needed_headroom += sizeof(struct udphdr);
+	}
+	if (session->mtu != 0) {
+		dev->mtu = session->mtu;
+		dev->needed_headroom += session->hdr_len;
+		return;
+	}
+	l3_overhead = kernel_sock_ip_overhead(tunnel->sock);
+	if (l3_overhead == 0) {
+		/* L3 Overhead couldn't be identified, this could be
+		 * because tunnel->sock was NULL or the socket's
+		 * address family was not IPv4 or IPv6,
+		 * dev mtu stays at 1500.
+		 */
+		return;
+	}
+	/* Adjust MTU, factor overhead - underlay L3, overlay L2 hdr
+	 * UDP overhead, if any, was already factored in above.
+	 */
+	overhead += session->hdr_len + ETH_HLEN + l3_overhead;
+
+	/* If PMTU discovery was enabled, use discovered MTU on L2TP device */
+	dst = sk_dst_get(tunnel->sock);
+	if (dst) {
+		/* dst_mtu will use PMTU if found, else fallback to intf MTU */
+		u32 pmtu = dst_mtu(dst);
+
+		if (pmtu != 0)
+			dev->mtu = pmtu;
+		dst_release(dst);
+	}
+	session->mtu = dev->mtu - overhead;
+	dev->mtu = session->mtu;
+	dev->needed_headroom += session->hdr_len;
+}
+
 static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct net_device *dev;
@@ -249,10 +299,7 @@ static int l2tp_eth_create(struct net *n
 	}
 
 	dev_net_set(dev, net);
-	if (session->mtu == 0)
-		session->mtu = dev->mtu - session->hdr_len;
-	dev->mtu = session->mtu;
-	dev->needed_headroom += session->hdr_len;
+	l2tp_eth_adjust_mtu(tunnel, session, dev);
 
 	priv = netdev_priv(dev);
 	priv->dev = dev;


