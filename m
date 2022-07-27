Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D64582CF7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiG0Qwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240667AbiG0QwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC1154AE6;
        Wed, 27 Jul 2022 09:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 794C8B821BE;
        Wed, 27 Jul 2022 16:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62FEC433C1;
        Wed, 27 Jul 2022 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939638;
        bh=+ataAdu/2uX3V3y/uBCGrRq5NP1kqtr1ad7fMIFK04M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGi3MUvqCyRfQD2MYZov6bLiyK78DX+BctK8XVh+6JDrjVHGIfL/hzmjgSDN6rY7r
         tj4NSfxVezjOAhRfDaONPlCFZKp+AIuqatiuGOUmwlylGNWvhVtfr85aqgfaPn8sd3
         7Ulailk5xEU+py7SNcnPhDL7AzAOHLSlgI4E+3wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/105] tcp: Fix data-races around sysctl_tcp_reordering.
Date:   Wed, 27 Jul 2022 18:10:36 +0200
Message-Id: <20220727161014.094510118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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
index 19c13ad5c121..5582b05d0638 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -440,7 +440,7 @@ void tcp_init_sock(struct sock *sk)
 	tp->snd_cwnd_clamp = ~0;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
-	tp->reordering = sock_net(sk)->ipv4.sysctl_tcp_reordering;
+	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
 	tcp_assign_congestion_control(sk);
 
 	tp->tsoffset = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f514d0b4b1e0..070e7015e9c9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2099,6 +2099,7 @@ void tcp_enter_loss(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool new_recovery = icsk->icsk_ca_state < TCP_CA_Recovery;
+	u8 reordering;
 
 	tcp_timeout_mark_lost(sk);
 
@@ -2119,10 +2120,12 @@ void tcp_enter_loss(struct sock *sk)
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
@@ -3411,7 +3414,8 @@ static inline bool tcp_may_raise_cwnd(const struct sock *sk, const int flag)
 	 * new SACK or ECE mark may first advance cwnd here and later reduce
 	 * cwnd in tcp_fastretrans_alert() based on more states.
 	 */
-	if (tcp_sk(sk)->reordering > sock_net(sk)->ipv4.sysctl_tcp_reordering)
+	if (tcp_sk(sk)->reordering >
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering))
 		return flag & FLAG_FORWARD_PROGRESS;
 
 	return flag & FLAG_DATA_ACKED;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 6b27c481fe18..8d7e32f4abf6 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -428,7 +428,8 @@ void tcp_update_metrics(struct sock *sk)
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



