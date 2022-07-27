Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C27582E0C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbiG0RGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241408AbiG0RFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E556FA12;
        Wed, 27 Jul 2022 09:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE4CB821AC;
        Wed, 27 Jul 2022 16:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA178C433C1;
        Wed, 27 Jul 2022 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939979;
        bh=Aid4IAVsSs6Fbb/FVel6SEzfAF0WvHKpepDi6p/fNCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qQqs0Q4SIZta5N6CCg0evgKadDOkMXB5omcpUqCZkmwDQnMwQTNSVA/z6kfIYFzx
         Mn1VzLg/LK3yaFXzpaIQBYdOEx27MfPaw9RgHMpN/KVLR6B+B+OaFCm8gr0VeS3yj1
         Q9AKVDAbbIfc3GL/qwxJvkhHFRer9bJaT26Rlht8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/201] tcp: Fix data-races around sysctl_tcp_mtu_probing.
Date:   Wed, 27 Jul 2022 18:09:27 +0200
Message-Id: <20220727161029.536150791@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

[ Upstream commit f47d00e077e7d61baf69e46dde3210c886360207 ]

While reading sysctl_tcp_mtu_probing, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5d424d5a674f ("[TCP]: MTU probing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 net/ipv4/tcp_timer.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0bd5c334ccce..1acfd4298a01 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1765,7 +1765,7 @@ void tcp_mtup_init(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
 
-	icsk->icsk_mtup.enabled = net->ipv4.sysctl_tcp_mtu_probing > 1;
+	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
 	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d..98bb00e29e1e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -163,7 +163,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	int mss;
 
 	/* Black hole detection */
-	if (!net->ipv4.sysctl_tcp_mtu_probing)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing))
 		return;
 
 	if (!icsk->icsk_mtup.enabled) {
-- 
2.35.1



