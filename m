Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7A582E0D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbiG0RGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiG0RGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE36FA1E;
        Wed, 27 Jul 2022 09:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93779601D6;
        Wed, 27 Jul 2022 16:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773A9C433D6;
        Wed, 27 Jul 2022 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939982;
        bh=vGECSNQYe+TmL3K/N9ppIzMcy/1IbI0ocNu9D1LRQFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYhX3fAy7QS73g7dZRE6wSKPlXOfnqNUxqDEf5tsh9ynQqhgzpUcs3JUO2PVrYoN4
         3uUhqsth9jgzd9ii4XtC7qfq7p0vIBgcIGNKFutMs7/nmsQDJ9OJEjWg8TypGmT6vV
         MWibUqyP0tq6VoJU49QpjEI/Wpuc03xGOKpkFDMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/201] tcp: Fix data-races around sysctl_tcp_base_mss.
Date:   Wed, 27 Jul 2022 18:09:28 +0200
Message-Id: <20220727161029.569159430@linuxfoundation.org>
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

[ Upstream commit 88d78bc097cd8ebc6541e93316c9d9bf651b13e8 ]

While reading sysctl_tcp_base_mss, it can be changed concurrently.
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
index 1acfd4298a01..53277a9a2300 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1768,7 +1768,7 @@ void tcp_mtup_init(struct sock *sk)
 	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
-	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
+	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, READ_ONCE(net->ipv4.sysctl_tcp_base_mss));
 	icsk->icsk_mtup.probe_size = 0;
 	if (icsk->icsk_mtup.enabled)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 98bb00e29e1e..04063c7e33ba 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -171,7 +171,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
 	} else {
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
-		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
+		mss = min(READ_ONCE(net->ipv4.sysctl_tcp_base_mss), mss);
 		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
 		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
-- 
2.35.1



