Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7B3F568E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390258AbfKHTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403817AbfKHTJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B252087E;
        Fri,  8 Nov 2019 19:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240165;
        bh=rkWc8IbdEaSvrxsOfVoAZ+1MbxALwcX4Njf18RbH3vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HgA9tv1cZMjYzZwEYu3mzAXz7BcJdi+I3W8T5kd1UI17Y8gBCRd5oFQZBsGPFxXP
         TvlzXdw2QzGuuNRCD6QO5qQK55xkA1A5iSg+ABk/rVwqSY5UGAD1170Gh8f0RMsUqL
         IFyY4pXnMW8lhcG34n6JzIWrxfToAbN33DhH/m5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 109/140] rxrpc: Fix handling of last subpacket of jumbo packet
Date:   Fri,  8 Nov 2019 19:50:37 +0100
Message-Id: <20191108174911.749361622@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f9c32435ab7221d1d6cb35738fa85a2da012b23e ]

When rxrpc_recvmsg_data() sets the return value to 1 because it's drained
all the data for the last packet, it checks the last-packet flag on the
whole packet - but this is wrong, since the last-packet flag is only set on
the final subpacket of the last jumbo packet.  This means that a call that
receives its last packet in a jumbo packet won't complete properly.

Fix this by having rxrpc_locate_data() determine the last-packet state of
the subpacket it's looking at and passing that back to the caller rather
than having the caller look in the packet header.  The caller then needs to
cache this in the rxrpc_call struct as rxrpc_locate_data() isn't then
called again for this packet.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Fixes: e2de6c404898 ("rxrpc: Use info in skbuff instead of reparsing a jumbo packet")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/recvmsg.c     |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -596,6 +596,7 @@ struct rxrpc_call {
 	int			debug_id;	/* debug ID for printks */
 	unsigned short		rx_pkt_offset;	/* Current recvmsg packet offset */
 	unsigned short		rx_pkt_len;	/* Current recvmsg packet len */
+	bool			rx_pkt_last;	/* Current recvmsg packet is last */
 
 	/* Rx/Tx circular buffer, depending on phase.
 	 *
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -267,11 +267,13 @@ static int rxrpc_verify_packet(struct rx
  */
 static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
 			     u8 *_annotation,
-			     unsigned int *_offset, unsigned int *_len)
+			     unsigned int *_offset, unsigned int *_len,
+			     bool *_last)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned int offset = sizeof(struct rxrpc_wire_header);
 	unsigned int len;
+	bool last = false;
 	int ret;
 	u8 annotation = *_annotation;
 	u8 subpacket = annotation & RXRPC_RX_ANNO_SUBPACKET;
@@ -281,6 +283,8 @@ static int rxrpc_locate_data(struct rxrp
 	len = skb->len - offset;
 	if (subpacket < sp->nr_subpackets - 1)
 		len = RXRPC_JUMBO_DATALEN;
+	else if (sp->rx_flags & RXRPC_SKB_INCL_LAST)
+		last = true;
 
 	if (!(annotation & RXRPC_RX_ANNO_VERIFIED)) {
 		ret = rxrpc_verify_packet(call, skb, annotation, offset, len);
@@ -291,6 +295,7 @@ static int rxrpc_locate_data(struct rxrp
 
 	*_offset = offset;
 	*_len = len;
+	*_last = last;
 	call->conn->security->locate_data(call, skb, _offset, _len);
 	return 0;
 }
@@ -309,7 +314,7 @@ static int rxrpc_recvmsg_data(struct soc
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top, seq;
 	size_t remain;
-	bool last;
+	bool rx_pkt_last;
 	unsigned int rx_pkt_offset, rx_pkt_len;
 	int ix, copy, ret = -EAGAIN, ret2;
 
@@ -319,6 +324,7 @@ static int rxrpc_recvmsg_data(struct soc
 
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
+	rx_pkt_last = call->rx_pkt_last;
 
 	if (call->state >= RXRPC_CALL_SERVER_ACK_REQUEST) {
 		seq = call->rx_hard_ack;
@@ -329,6 +335,7 @@ static int rxrpc_recvmsg_data(struct soc
 	/* Barriers against rxrpc_input_data(). */
 	hard_ack = call->rx_hard_ack;
 	seq = hard_ack + 1;
+
 	while (top = smp_load_acquire(&call->rx_top),
 	       before_eq(seq, top)
 	       ) {
@@ -356,7 +363,8 @@ static int rxrpc_recvmsg_data(struct soc
 		if (rx_pkt_offset == 0) {
 			ret2 = rxrpc_locate_data(call, skb,
 						 &call->rxtx_annotations[ix],
-						 &rx_pkt_offset, &rx_pkt_len);
+						 &rx_pkt_offset, &rx_pkt_len,
+						 &rx_pkt_last);
 			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_next, seq,
 					    rx_pkt_offset, rx_pkt_len, ret2);
 			if (ret2 < 0) {
@@ -396,13 +404,12 @@ static int rxrpc_recvmsg_data(struct soc
 		}
 
 		/* The whole packet has been transferred. */
-		last = sp->hdr.flags & RXRPC_LAST_PACKET;
 		if (!(flags & MSG_PEEK))
 			rxrpc_rotate_rx_window(call);
 		rx_pkt_offset = 0;
 		rx_pkt_len = 0;
 
-		if (last) {
+		if (rx_pkt_last) {
 			ASSERTCMP(seq, ==, READ_ONCE(call->rx_top));
 			ret = 1;
 			goto out;
@@ -415,6 +422,7 @@ out:
 	if (!(flags & MSG_PEEK)) {
 		call->rx_pkt_offset = rx_pkt_offset;
 		call->rx_pkt_len = rx_pkt_len;
+		call->rx_pkt_last = rx_pkt_last;
 	}
 done:
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_data_return, seq,


