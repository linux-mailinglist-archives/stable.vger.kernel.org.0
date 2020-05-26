Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C844E1E2B7F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbgEZTFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391039AbgEZTFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD29F20776;
        Tue, 26 May 2020 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519946;
        bh=6S1ZVz/Nu5RytmAE3pYQv0MP7oNAREJUuYy1rCPjnqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vUQUahlpKw073u36B4W8Jg3PG+mUZF2R/QHAk1IHh5DLH8lK4VGgm5IC/7HmaP5L
         peNT1Y2xVeW5gQMe1sFTYGgF3Rr4Sb0i5vyPz1W6kYwzcpA6nGFBi1gxqgWITaj+2K
         e5ZYzQ+VXX5aQkcRpXiiT5qMAVngMHHMpQJOLQ6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 79/81] rxrpc: Trace discarded ACKs
Date:   Tue, 26 May 2020 20:53:54 +0200
Message-Id: <20200526183935.810869824@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d1f129470e6cb79b8b97fecd12689f6eb49e27fe ]

Add a tracepoint to track received ACKs that are discarded due to being
outside of the Tx window.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h | 35 +++++++++++++++++++++++++++++++++++
 net/rxrpc/input.c            | 12 ++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 0924119bcfa4..bc5b232440b6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1549,6 +1549,41 @@ TRACE_EVENT(rxrpc_notify_socket,
 		      __entry->serial)
 	    );
 
+TRACE_EVENT(rxrpc_rx_discard_ack,
+	    TP_PROTO(unsigned int debug_id, rxrpc_serial_t serial,
+		     rxrpc_seq_t first_soft_ack, rxrpc_seq_t call_ackr_first,
+		     rxrpc_seq_t prev_pkt, rxrpc_seq_t call_ackr_prev),
+
+	    TP_ARGS(debug_id, serial, first_soft_ack, call_ackr_first,
+		    prev_pkt, call_ackr_prev),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	debug_id	)
+		    __field(rxrpc_serial_t,	serial		)
+		    __field(rxrpc_seq_t,	first_soft_ack)
+		    __field(rxrpc_seq_t,	call_ackr_first)
+		    __field(rxrpc_seq_t,	prev_pkt)
+		    __field(rxrpc_seq_t,	call_ackr_prev)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->debug_id		= debug_id;
+		    __entry->serial		= serial;
+		    __entry->first_soft_ack	= first_soft_ack;
+		    __entry->call_ackr_first	= call_ackr_first;
+		    __entry->prev_pkt		= prev_pkt;
+		    __entry->call_ackr_prev	= call_ackr_prev;
+			   ),
+
+	    TP_printk("c=%08x r=%08x %08x<%08x %08x<%08x",
+		      __entry->debug_id,
+		      __entry->serial,
+		      __entry->first_soft_ack,
+		      __entry->call_ackr_first,
+		      __entry->prev_pkt,
+		      __entry->call_ackr_prev)
+	    );
+
 #endif /* _TRACE_RXRPC_H */
 
 /* This part must be outside protection */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index d9beb28fc32f..4cc3b54ebc49 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -879,8 +879,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		return;
+	}
 
 	buf.info.rxMTU = 0;
 	ioffset = offset + nr_acks + 3;
@@ -892,8 +896,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		goto out;
+	}
 	call->acks_latest_ts = skb->tstamp;
 	call->acks_latest = sp->hdr.serial;
 
-- 
2.25.1



