Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C394A40FA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358431AbiAaLB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33094 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358610AbiAaLAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AF860BC0;
        Mon, 31 Jan 2022 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCD6C340E8;
        Mon, 31 Jan 2022 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626824;
        bh=ZIeqG/4W3iMtANw1XSfN8K18a49BnpXQ6VvJzNGfFAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASoVHX3rMzBoYSfztU4k7pyIqAGJCxDf9rb49oXu5TSozp/K/zDing6f7WxbwIGqY
         kdRhPLoTrXqVefsh+QBsCW63kuS4OugwX90TujRJl931+1uw2F9eV5QBoVtmStzr8X
         n4jTktc3Ci1M17YFqOuH+dgaoX7biWxWB+n3L1MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/64] rxrpc: Adjust retransmission backoff
Date:   Mon, 31 Jan 2022 11:56:37 +0100
Message-Id: <20220131105217.437321340@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2c13c05c5ff4b9fc907b07f7311821910ebaaf8a ]

Improve retransmission backoff by only backing off when we retransmit data
packets rather than when we set the lost ack timer.

To this end:

 (1) In rxrpc_resend(), use rxrpc_get_rto_backoff() when setting the
     retransmission timer and only tell it that we are retransmitting if we
     actually have things to retransmit.

     Note that it's possible for the retransmission algorithm to race with
     the processing of a received ACK, so we may see no packets needing
     retransmission.

 (2) In rxrpc_send_data_packet(), don't bump the backoff when setting the
     ack_lost_at timer, as it may then get bumped twice.

With this, when looking at one particular packet, the retransmission
intervals were seen to be 1.5ms, 2ms, 3ms, 5ms, 9ms, 17ms, 33ms, 71ms,
136ms, 264ms, 544ms, 1.088s, 2.1s, 4.2s and 8.3s.

Fixes: c410bf01933e ("rxrpc: Fix the excessive initial retransmission timeout")
Suggested-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/164138117069.2023386.17446904856843997127.stgit@warthog.procyon.org.uk/
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 8 +++-----
 net/rxrpc/output.c     | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 9ff85ee8337cd..80e15310f1b29 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -157,7 +157,7 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
 	struct sk_buff *skb;
-	unsigned long resend_at, rto_j;
+	unsigned long resend_at;
 	rxrpc_seq_t cursor, seq, top;
 	ktime_t now, max_age, oldest, ack_ts;
 	int ix;
@@ -165,10 +165,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
-	rto_j = call->peer->rto_j;
-
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(rto_j));
+	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
@@ -213,7 +211,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	}
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
-	resend_at += jiffies + rto_j;
+	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer, retrans);
 	WRITE_ONCE(call->resend_at, resend_at);
 
 	if (unacked)
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index f8b632a5c6197..a4a6f8ee07201 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -426,7 +426,7 @@ done:
 			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
-				ack_lost_at = rxrpc_get_rto_backoff(call->peer, retrans);
+				ack_lost_at = rxrpc_get_rto_backoff(call->peer, false);
 				ack_lost_at += nowj;
 				WRITE_ONCE(call->ack_lost_at, ack_lost_at);
 				rxrpc_reduce_call_timer(call, ack_lost_at, nowj,
-- 
2.34.1



