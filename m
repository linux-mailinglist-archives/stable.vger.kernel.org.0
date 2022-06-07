Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB65E5414B5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358334AbiFGUVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358384AbiFGUTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257861D08A3;
        Tue,  7 Jun 2022 11:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91D4760906;
        Tue,  7 Jun 2022 18:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1613C385A2;
        Tue,  7 Jun 2022 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626610;
        bh=0VYyAQ2udBMl6TW3hWYknv3XLOr7ZmsuQTyd3In4K4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3B3x3X4VeWfENYHr4B+iq1KwSWxTWSH7ETu+S3KgpDQc71SLYJdVdaRUgXNDb/Bc
         4XNJDvN5oW7ZdOzZWW2632JxKMOuNaUHfcmw7L9kJijo2uLTVxLeXxPAuXjIhayrmn
         iYeUy83FIWk5vppopSnhJRLti4B+SqbvXdkLW6JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 441/772] rxrpc: Dont let ack.previousPacket regress
Date:   Tue,  7 Jun 2022 19:00:33 +0200
Message-Id: <20220607165001.994175066@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index cc1fe6d00eca..4ba51e6d3d85 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -679,7 +679,7 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
 
@@ -694,7 +694,7 @@ struct rxrpc_call {
 	/* Transmission-phase ACK management (ACKs we've received). */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
 	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
-	rxrpc_seq_t		acks_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 3da33b5c13b2..680b984ef87f 100644
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



