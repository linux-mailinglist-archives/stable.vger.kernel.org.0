Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2201540644
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbiFGRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348176AbiFGRbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A911E48D;
        Tue,  7 Jun 2022 10:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1B0EB80B66;
        Tue,  7 Jun 2022 17:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563F8C385A5;
        Tue,  7 Jun 2022 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622980;
        bh=jAvgEEXR85e8NpvEaZfg8QBI9lEAwiM9PqabNo9ydrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no4gzsrqGIRFoN4IOsBtThgx4QMat0Tw+4hFjX9Zv/ekLFm0Q0B0BZ/dMnySsUI0k
         22mVOb4n2pU/tf0MvtiGI2WsIlQJmWnGca//TuBuZFs7nBRyYO86y1LZPMJg1SaKxt
         eWpd2nGhLpbe0yS0dxeL492RemuHQXIBVKwuG0rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/452] rxrpc: Dont let ack.previousPacket regress
Date:   Tue,  7 Jun 2022 19:01:50 +0200
Message-Id: <20220607164916.097506482@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 81524b6312535897707f2942695da1d359a5e56b ]

The previousPacket field in the rx ACK packet should never go backwards -
it's now the highest DATA sequence number received, not the last on
received (it used to be used for out of sequence detection).

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 4 ++--
 net/rxrpc/input.c       | 4 +++-
 net/rxrpc/output.c      | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 2fc93467780d..ed88552c237c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -662,7 +662,7 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
 
@@ -677,7 +677,7 @@ struct rxrpc_call {
 	/* Transmission-phase ACK management (ACKs we've received). */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
 	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
-	rxrpc_seq_t		acks_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index f11673cda217..2e61545ad8ca 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -453,7 +453,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	    !rxrpc_receiving_reply(call))
 		goto unlock;
 
-	call->ackr_prev_seq = seq0;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 
 	nr_subpackets = sp->nr_subpackets;
@@ -534,6 +533,9 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			ack_serial = serial;
 		}
 
+		if (after(seq0, call->ackr_highest_seq))
+			call->ackr_highest_seq = seq0;
+
 		/* Queue the packet.  We use a couple of memory barriers here as need
 		 * to make sure that rx_top is perceived to be set after the buffer
 		 * pointer and that the buffer pointer is set after the annotation and
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index a45c83f22236..46aae9b7006f 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -89,7 +89,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	pkt->ack.bufferSpace	= htons(8);
 	pkt->ack.maxSkew	= htons(0);
 	pkt->ack.firstPacket	= htonl(hard_ack + 1);
-	pkt->ack.previousPacket	= htonl(call->ackr_prev_seq);
+	pkt->ack.previousPacket	= htonl(call->ackr_highest_seq);
 	pkt->ack.serial		= htonl(serial);
 	pkt->ack.reason		= reason;
 	pkt->ack.nAcks		= top - hard_ack;
-- 
2.35.1



