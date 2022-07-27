Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826B7582CD9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiG0QvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbiG0Quu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6419061D8F;
        Wed, 27 Jul 2022 09:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B9A61A24;
        Wed, 27 Jul 2022 16:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43205C433C1;
        Wed, 27 Jul 2022 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939592;
        bh=oLuofaZzXhRDN7d9d6KpMVZa4bYXqOlIP0G4Leb4uJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/243BHaAqGMjjc8/0mbnSSCrwGtKmBhGeovJ2LVpFb+mgsmleCQ4MK0cCuBb1tg1
         L9EVF6jQvMOv/rfEdm1pZMnr2i/Iye8a/r2vOMBOnonrP3m2IUAMeg6bbDpRnq1l58
         i4AKdmt9wB+Pl52Q4zaPztlxepAWNlwXaI1MU0RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/105] tcp: Fix data-races around sysctl_tcp_base_mss.
Date:   Wed, 27 Jul 2022 18:10:22 +0200
Message-Id: <20220727161013.550990320@linuxfoundation.org>
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
index 423ec09ad831..9f3eec8e7e4c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1766,7 +1766,7 @@ void tcp_mtup_init(struct sock *sk)
 	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
-	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
+	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, READ_ONCE(net->ipv4.sysctl_tcp_base_mss));
 	icsk->icsk_mtup.probe_size = 0;
 	if (icsk->icsk_mtup.enabled)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 3c0d689cafac..795716fd3761 100644
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



