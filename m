Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D12C59518A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiHPE7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiHPE6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:58:20 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10CA2E1
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660596717; x=1692132717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g45hQiYpHuZKRD9qX9gU6W1zMf8KZxYzYMdux857Q2w=;
  b=pnIp67HTga8LUU7Rt0AqpFgB9Pt9Krv//3cWR8OHiq5fdy6VLt86euu6
   kwTd48FctqcQcZ6BD/AK8ccsOxbvyupaNOA+Shkyoo5hFgMhjZj+xhPMy
   LQbriCoQPvauQoXwOYLUaEABgdr5Q2UcyFoPYivEU2C1+mFZKimgO0+WO
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,239,1654560000"; 
   d="scan'208";a="119449113"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 20:51:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id D3B089347F;
        Mon, 15 Aug 2022 20:51:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 15 Aug 2022 20:51:36 +0000
Received: from dev-dsk-kuniyu-2c-0edd2a20.us-west-2.amazon.com (10.43.161.123)
 by EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 15 Aug 2022 20:51:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Date:   Mon, 15 Aug 2022 20:51:29 +0000
Message-ID: <20220815205129.6335-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165919469116877@kroah.com>
References: <165919469116877@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.123]
X-ClientProxiedBy: EX13D12UWC003.ant.amazon.com (10.43.162.12) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

commit 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 upstream.

This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.

This to-be-reverted commit was meant to apply a stricter rule for the
stack to enter pingpong mode. However, the condition used to check for
interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
jiffy based and might be too coarse, which delays the stack entering
pingpong mode.
We revert this patch so that we no longer use the above condition to
determine interactive session, and also reduce pingpong threshold to 1.

Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
Reported-by: LemmyHuang <hlm3280@163.com>
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220721204404.388396-1-weiwan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/inet_connection_sock.h | 10 +---------
 net/ipv4/tcp_output.c              | 15 ++++++---------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 13792c0ef46e..2e5f2c8b0663 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -318,7 +318,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -334,12 +334,4 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 {
 	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
 }
-
-static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ack.pingpong < U8_MAX)
-		icsk->icsk_ack.pingpong++;
-}
 #endif /* _INET_CONNECTION_SOCK_H */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ef749a47768a..7f9004ae44a4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -166,16 +166,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
-	/* If this is the first data packet sent in response to the
-	 * previous received data,
-	 * and it is a reply for ato after last received packet,
-	 * increase pingpong count.
-	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
-		inet_csk_inc_pingpong_cnt(sk);
-
 	tp->lsndtime = now;
+
+	/* If it is a reply for ato after last received
+	 * packet, enter pingpong mode.
+	 */
+	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_enter_pingpong_mode(sk);
 }
 
 /* Account for an ACK we sent. */
-- 
2.37.1

