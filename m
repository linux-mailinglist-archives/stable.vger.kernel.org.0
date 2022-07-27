Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31090582B8A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiG0QfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiG0Qd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91354CA0;
        Wed, 27 Jul 2022 09:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65DFB61A18;
        Wed, 27 Jul 2022 16:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717FCC433C1;
        Wed, 27 Jul 2022 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939206;
        bh=nlvdTIxtAYCEdBL21ccMnOE+BSAX/2yiE3wFKtIeH2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jpn/6Ga1jSLEu/cFyq2DIEP/8Q9JnaNCfZ1ErKwTWFzpyo06+3AI+4hCnJpOJAJVe
         qwV7jgzzvM/aJK0aVFGoZI9XZAHLF8wMusSfZxpaaXlV0sLtmEC3yUfh9bdHpxjX/H
         SwiPlgGKg8XElC621exg3s3vbLkESdREoxXTcyeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/62] tcp: Fix data-races around sysctl_tcp_reordering.
Date:   Wed, 27 Jul 2022 18:10:28 +0200
Message-Id: <20220727161004.958032909@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 46778cd16e6a5ad1b2e3a91f6c057c907379418e ]

While reading sysctl_tcp_reordering, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c         |  2 +-
 net/ipv4/tcp_input.c   | 10 +++++++---
 net/ipv4/tcp_metrics.c |  3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f7795488b0ad..b1b121d5076c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -436,7 +436,7 @@ void tcp_init_sock(struct sock *sk)
 	tp->snd_cwnd_clamp = ~0;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
-	tp->reordering = sock_net(sk)->ipv4.sysctl_tcp_reordering;
+	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
 	tcp_assign_congestion_control(sk);
 
 	tp->tsoffset = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 92f5068c7680..afe195e03a95 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1982,6 +1982,7 @@ void tcp_enter_loss(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool new_recovery = icsk->icsk_ca_state < TCP_CA_Recovery;
+	u8 reordering;
 
 	tcp_timeout_mark_lost(sk);
 
@@ -2002,10 +2003,12 @@ void tcp_enter_loss(struct sock *sk)
 	/* Timeout in disordered state after receiving substantial DUPACKs
 	 * suggests that the degree of reordering is over-estimated.
 	 */
+	reordering = READ_ONCE(net->ipv4.sysctl_tcp_reordering);
 	if (icsk->icsk_ca_state <= TCP_CA_Disorder &&
-	    tp->sacked_out >= net->ipv4.sysctl_tcp_reordering)
+	    tp->sacked_out >= reordering)
 		tp->reordering = min_t(unsigned int, tp->reordering,
-				       net->ipv4.sysctl_tcp_reordering);
+				       reordering);
+
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
 	tcp_ecn_queue_cwr(tp);
@@ -3303,7 +3306,8 @@ static inline bool tcp_may_raise_cwnd(const struct sock *sk, const int flag)
 	 * new SACK or ECE mark may first advance cwnd here and later reduce
 	 * cwnd in tcp_fastretrans_alert() based on more states.
 	 */
-	if (tcp_sk(sk)->reordering > sock_net(sk)->ipv4.sysctl_tcp_reordering)
+	if (tcp_sk(sk)->reordering >
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering))
 		return flag & FLAG_FORWARD_PROGRESS;
 
 	return flag & FLAG_DATA_ACKED;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 03b51cdcc731..61843c6d7a47 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -425,7 +425,8 @@ void tcp_update_metrics(struct sock *sk)
 		if (!tcp_metric_locked(tm, TCP_METRIC_REORDERING)) {
 			val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 			if (val < tp->reordering &&
-			    tp->reordering != net->ipv4.sysctl_tcp_reordering)
+			    tp->reordering !=
+			    READ_ONCE(net->ipv4.sysctl_tcp_reordering))
 				tcp_metric_set(tm, TCP_METRIC_REORDERING,
 					       tp->reordering);
 		}
-- 
2.35.1



