Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4551A7D1
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346350AbiEDRHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356145AbiEDREz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B05A506C7;
        Wed,  4 May 2022 09:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26760616F8;
        Wed,  4 May 2022 16:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675A6C385AA;
        Wed,  4 May 2022 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683233;
        bh=dnzaqGXBBJIvI/n5Ws4cMPAF+KjiNExyNeJrmtj7ppc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIWNHpkCILo84mvGI369nQZezKc33UpMJNG66+XYkjjOhAjcPuV75EKLP/25i6l/G
         Fu8vEhOA2DVMEI6WKzOTF8dNfGQmRoTDVPGPpdVQyiUMHcLn3aL1FotmGNPZCyve6S
         P1wk90OD5DCN9+kPnW7UoTVv4oSUNym/xSAnQhb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/177] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Wed,  4 May 2022 18:44:39 +0200
Message-Id: <20220504153100.801021821@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit b253a0680ceadc5d7b4acca7aa2d870326cad8ad ]

If an ACK (s)acks multiple skbs, we favor the information
from the most recently sent skb by choosing the skb with
the highest prior_delivered count. But in the interval
between receiving ACKs, we send multiple skbs with the same
prior_delivered, because the tp->delivered only changes
when we receive an ACK.

We used RACK's solution, copying tcp_rack_sent_after() as
tcp_skb_sent_after() helper to determine "which packet was
sent last?". Later, we will use tcp_skb_sent_after() instead
in RACK.

Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1650422081-22153-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h   |  6 ++++++
 net/ipv4/tcp_rate.c | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 31d384c3778a..71a9aeae693d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1026,6 +1026,7 @@ struct rate_sample {
 	int  losses;		/* number of packets marked lost upon ACK */
 	u32  acked_sacked;	/* number of packets newly (S)ACKed upon ACK */
 	u32  prior_in_flight;	/* in flight before this ACK */
+	u32  last_end_seq;	/* end_seq of most recently ACKed packet */
 	bool is_app_limited;	/* is sample from packet with bubble in pipe? */
 	bool is_retrans;	/* is sample from retransmission? */
 	bool is_ack_delayed;	/* is this (likely) a delayed ACK? */
@@ -1148,6 +1149,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
 		  bool is_sack_reneg, struct rate_sample *rs);
 void tcp_rate_check_app_limited(struct sock *sk);
 
+static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
+{
+	return t1 > t2 || (t1 == t2 && after(seq1, seq2));
+}
+
 /* These functions determine how the current flow behaves in respect of SACK
  * handling. SACK is negotiated with the peer, and therefore it can vary
  * between different flows.
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 0de693565963..6ab197928abb 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -73,26 +73,31 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
  *
  * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
  * called multiple times. We favor the information from the most recently
- * sent skb, i.e., the skb with the highest prior_delivered count.
+ * sent skb, i.e., the skb with the most recently sent time and the highest
+ * sequence.
  */
 void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 			    struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
+	u64 tx_tstamp;
 
 	if (!scb->tx.delivered_mstamp)
 		return;
 
+	tx_tstamp = tcp_skb_timestamp_us(skb);
 	if (!rs->prior_delivered ||
-	    after(scb->tx.delivered, rs->prior_delivered)) {
+	    tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
+			       scb->end_seq, rs->last_end_seq)) {
 		rs->prior_delivered  = scb->tx.delivered;
 		rs->prior_mstamp     = scb->tx.delivered_mstamp;
 		rs->is_app_limited   = scb->tx.is_app_limited;
 		rs->is_retrans	     = scb->sacked & TCPCB_RETRANS;
+		rs->last_end_seq     = scb->end_seq;
 
 		/* Record send time of most recently ACKed packet: */
-		tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
+		tp->first_tx_mstamp  = tx_tstamp;
 		/* Find the duration of the "send phase" of this window: */
 		rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
 						     scb->tx.first_tx_mstamp);
-- 
2.35.1



