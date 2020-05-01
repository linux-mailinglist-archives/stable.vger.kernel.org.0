Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C911C1642
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgEANmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731548AbgEANmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36EFC205C9;
        Fri,  1 May 2020 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340563;
        bh=Tgvy8L/qcTQAd0WfpP+tRSfrskJUjHDc5vwMG2Vn+uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPK7shIoIQTI5i22g1QXWjiWimpbDNvNizyDGPcNoTsrPpQJnKDTZBXP+RjAFULiB
         /msuLjusjpUGHe671avQuSsHkYrcyLi77zlRsgodBBB/B15veVUzsjEO8pAGFC5uNF
         vKvx7+bSoX5v4KE1xmCsKXuCxbk/tssezbzSCsTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 033/106] rxrpc: Fix DATA Tx to disable nofrag for UDP on AF_INET6 socket
Date:   Fri,  1 May 2020 15:23:06 +0200
Message-Id: <20200501131547.931293506@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 0e631eee17dcea576ab922fa70e4fdbd596ee452 upstream.

Fix the DATA packet transmission to disable nofrag for UDPv4 on an AF_INET6
socket as well as UDPv6 when trying to transmit fragmentably.

Without this, packets filled to the normal size used by the kernel AFS
client of 1412 bytes be rejected by udp_sendmsg() with EMSGSIZE
immediately.  The ->sk_error_report() notification hook is called, but
rxrpc doesn't generate a trace for it.

This is a temporary fix; a more permanent solution needs to involve
changing the size of the packets being filled in accordance with the MTU,
which isn't currently done in AF_RXRPC.  The reason for not doing so was
that, barring the last packet in an rx jumbo packet, jumbos can only be
assembled out of 1412-byte packets - and the plan was to construct jumbos
on the fly at transmission time.

Also, there's no point turning on IPV6_MTU_DISCOVER, since IPv6 has to
engage in this anyway since fragmentation is only done by the sender.  We
can then condense the switch-statement in rxrpc_send_data_packet().

Fixes: 75b54cb57ca3 ("rxrpc: Add IPv6 support")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/local_object.c |    9 ---------
 net/rxrpc/output.c       |   42 +++++++++++-------------------------------
 2 files changed, 11 insertions(+), 40 deletions(-)

--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -165,15 +165,6 @@ static int rxrpc_open_socket(struct rxrp
 			goto error;
 		}
 
-		/* we want to set the don't fragment bit */
-		opt = IPV6_PMTUDISC_DO;
-		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_MTU_DISCOVER,
-					(char *) &opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
-
 		/* Fall through and set IPv4 options too otherwise we don't get
 		 * errors from IPv4 packets sent through the IPv6 socket.
 		 */
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -474,41 +474,21 @@ send_fragmentable:
 	skb->tstamp = ktime_get_real();
 
 	switch (conn->params.local->srx.transport.family) {
+	case AF_INET6:
 	case AF_INET:
 		opt = IP_PMTUDISC_DONT;
-		ret = kernel_setsockopt(conn->params.local->socket,
-					SOL_IP, IP_MTU_DISCOVER,
-					(char *)&opt, sizeof(opt));
-		if (ret == 0) {
-			ret = kernel_sendmsg(conn->params.local->socket, &msg,
-					     iov, 2, len);
-			conn->params.peer->last_tx_at = ktime_get_seconds();
-
-			opt = IP_PMTUDISC_DO;
-			kernel_setsockopt(conn->params.local->socket, SOL_IP,
-					  IP_MTU_DISCOVER,
-					  (char *)&opt, sizeof(opt));
-		}
-		break;
-
-#ifdef CONFIG_AF_RXRPC_IPV6
-	case AF_INET6:
-		opt = IPV6_PMTUDISC_DONT;
-		ret = kernel_setsockopt(conn->params.local->socket,
-					SOL_IPV6, IPV6_MTU_DISCOVER,
-					(char *)&opt, sizeof(opt));
-		if (ret == 0) {
-			ret = kernel_sendmsg(conn->params.local->socket, &msg,
-					     iov, 2, len);
-			conn->params.peer->last_tx_at = ktime_get_seconds();
+		kernel_setsockopt(conn->params.local->socket,
+				  SOL_IP, IP_MTU_DISCOVER,
+				  (char *)&opt, sizeof(opt));
+		ret = kernel_sendmsg(conn->params.local->socket, &msg,
+				     iov, 2, len);
+		conn->params.peer->last_tx_at = ktime_get_seconds();
 
-			opt = IPV6_PMTUDISC_DO;
-			kernel_setsockopt(conn->params.local->socket,
-					  SOL_IPV6, IPV6_MTU_DISCOVER,
-					  (char *)&opt, sizeof(opt));
-		}
+		opt = IP_PMTUDISC_DO;
+		kernel_setsockopt(conn->params.local->socket,
+				  SOL_IP, IP_MTU_DISCOVER,
+				  (char *)&opt, sizeof(opt));
 		break;
-#endif
 
 	default:
 		BUG();


