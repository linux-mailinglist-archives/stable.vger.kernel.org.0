Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D10548FC4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbiFMLRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353558AbiFMLQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6889412D0E;
        Mon, 13 Jun 2022 03:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 148CDB80EA8;
        Mon, 13 Jun 2022 10:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F08C3411C;
        Mon, 13 Jun 2022 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116699;
        bh=0803O+sGdXm+AjIa2pvoY9c2gJkfPeQ36W24jSpkMS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1ZOCTD6Br8aDEmyt8SPfH/s9qbNLSNOHvkRoH5nX9T/uBV6t4tbuDT8lv5ObuEUL
         sq3kFib3Oi/mFE5S5DCakFDtUX6uF7yXBZb3lBJZtNLgDlKHhUqjBCKZNVquPPlLRN
         2ZMGuaH8G+TZ9q9yhwS3euPfKTSqzNFKZcjF0tMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/411] rxrpc: Dont let ack.previousPacket regress
Date:   Mon, 13 Jun 2022 12:07:06 +0200
Message-Id: <20220613094933.251967746@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 8e72b77b33a9..8ca7afe0ac26 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -668,7 +668,7 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
 
@@ -679,7 +679,7 @@ struct rxrpc_call {
 	/* Transmission-phase ACK management (ACKs we've received). */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
 	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
-	rxrpc_seq_t		acks_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 164dcd8d684a..8eafa3463b88 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -454,7 +454,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	    !rxrpc_receiving_reply(call))
 		goto unlock;
 
-	call->ackr_prev_seq = seq0;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 
 	nr_subpackets = sp->nr_subpackets;
@@ -535,6 +534,9 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			ack_serial = serial;
 		}
 
+		if (after(seq0, call->ackr_highest_seq))
+			call->ackr_highest_seq = seq0;
+
 		/* Queue the packet.  We use a couple of memory barriers here as need
 		 * to make sure that rx_top is perceived to be set after the buffer
 		 * pointer and that the buffer pointer is set after the annotation and
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index a4a6f8ee0720..7f1c8116e030 100644
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



