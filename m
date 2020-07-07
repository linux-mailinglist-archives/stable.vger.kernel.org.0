Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA752171BA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgGGPYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgGGPYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865302065D;
        Tue,  7 Jul 2020 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135480;
        bh=hTbUvOF/JFnFT0p2wG5DgDAwt3T4hRgBb5o3JsrfnL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stsIRyTw5BC/gOI5khT4ngkd6gso54Z9zGJWCKC4i90/T4T7iR6xhSxcRjUEHicde
         I0QCUTjo2t5jUWWjObDnvbMQ87NBnII6VXRfNHmgUlma6yWVPCmtwTnt4hD/6hpDEF
         yLYWPFJgoVdX0IJayhzu92FV30pQmYMU7YEsKDv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 028/112] rxrpc: Fix race between incoming ACK parser and retransmitter
Date:   Tue,  7 Jul 2020 17:16:33 +0200
Message-Id: <20200707145802.326535482@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2ad6691d988c0c611362ddc2aad89e0fb50e3261 ]

There's a race between the retransmission code and the received ACK parser.
The problem is that the retransmission loop has to drop the lock under
which it is iterating through the transmission buffer in order to transmit
a packet, but whilst the lock is dropped, the ACK parser can crank the Tx
window round and discard the packets from the buffer.

The retransmission code then updated the annotations for the wrong packet
and a later retransmission thought it had to retransmit a packet that
wasn't there, leading to a NULL pointer dereference.

Fix this by:

 (1) Moving the annotation change to before we drop the lock prior to
     transmission.  This means we can't vary the annotation depending on
     the outcome of the transmission, but that's fine - we'll retransmit
     again later if it failed now.

 (2) Skipping the packet if the skb pointer is NULL.

The following oops was seen:

	BUG: kernel NULL pointer dereference, address: 000000000000002d
	Workqueue: krxrpcd rxrpc_process_call
	RIP: 0010:rxrpc_get_skb+0x14/0x8a
	...
	Call Trace:
	 rxrpc_resend+0x331/0x41e
	 ? get_vtime_delta+0x13/0x20
	 rxrpc_process_call+0x3c0/0x4ac
	 process_one_work+0x18f/0x27f
	 worker_thread+0x1a3/0x247
	 ? create_worker+0x17d/0x17d
	 kthread+0xe6/0xeb
	 ? kthread_delayed_work_timer_fn+0x83/0x83
	 ret_from_fork+0x1f/0x30

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 2a65ac41055f5..985fb89202d0c 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -248,7 +248,18 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		if (anno_type != RXRPC_TX_ANNO_RETRANS)
 			continue;
 
+		/* We need to reset the retransmission state, but we need to do
+		 * so before we drop the lock as a new ACK/NAK may come in and
+		 * confuse things
+		 */
+		annotation &= ~RXRPC_TX_ANNO_MASK;
+		annotation |= RXRPC_TX_ANNO_RESENT;
+		call->rxtx_annotations[ix] = annotation;
+
 		skb = call->rxtx_buffer[ix];
+		if (!skb)
+			continue;
+
 		rxrpc_get_skb(skb, rxrpc_skb_got);
 		spin_unlock_bh(&call->lock);
 
@@ -262,24 +273,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		spin_lock_bh(&call->lock);
-
-		/* We need to clear the retransmit state, but there are two
-		 * things we need to be aware of: A new ACK/NAK might have been
-		 * received and the packet might have been hard-ACK'd (in which
-		 * case it will no longer be in the buffer).
-		 */
-		if (after(seq, call->tx_hard_ack)) {
-			annotation = call->rxtx_annotations[ix];
-			anno_type = annotation & RXRPC_TX_ANNO_MASK;
-			if (anno_type == RXRPC_TX_ANNO_RETRANS ||
-			    anno_type == RXRPC_TX_ANNO_NAK) {
-				annotation &= ~RXRPC_TX_ANNO_MASK;
-				annotation |= RXRPC_TX_ANNO_UNACK;
-			}
-			annotation |= RXRPC_TX_ANNO_RESENT;
-			call->rxtx_annotations[ix] = annotation;
-		}
-
 		if (after(call->tx_hard_ack, seq))
 			seq = call->tx_hard_ack;
 	}
-- 
2.25.1



