Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB79582E91
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiG0RO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiG0ROW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6551F77577;
        Wed, 27 Jul 2022 09:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33ABFB821BA;
        Wed, 27 Jul 2022 16:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85717C433B5;
        Wed, 27 Jul 2022 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940157;
        bh=/sNS45vza5QLdinTFdHl9PLVW8EEHm8+8B8Nb2az7V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNLhIFWZpWL/n3AfTFITq+bH3/R8HBzaQI5SFsMxdBhD9oLiYkl5qlX9ahvj84hCS
         C6Fj4zZDOZ+q4w7MwrQGlnUaeNJ24LTSjSuDHAtIely/Mo3bs6Ngq1gYPJJbq8cT7d
         kmAkLfn7mM+sbQPNOeihQyDXIbAWe+iduHPBA78A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/201] tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
Date:   Wed, 27 Jul 2022 18:10:29 +0200
Message-Id: <20220727161032.941053058@linuxfoundation.org>
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

[ Upstream commit 4845b5713ab18a1bb6e31d1fbb4d600240b8b691 ]

While reading sysctl_tcp_slow_start_after_idle, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 35089bb203f4 ("[TCP]: Add tcp_slow_start_after_idle sysctl.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0c609d10c320..8ce8aafeef0f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1390,8 +1390,8 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 delta;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
-	    ca_ops->cong_control)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) ||
+	    tp->packets_out || ca_ops->cong_control)
 		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3b71d8735995..94f7841f7bfb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1901,7 +1901,7 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle &&
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) &&
 		    (s32)(tcp_jiffies32 - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto &&
 		    !ca_ops->cong_control)
 			tcp_cwnd_application_limited(sk);
-- 
2.35.1



