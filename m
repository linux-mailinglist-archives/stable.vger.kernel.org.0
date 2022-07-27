Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1285830D0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242788AbiG0RmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242802AbiG0Rlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C2189647;
        Wed, 27 Jul 2022 09:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07686B821BE;
        Wed, 27 Jul 2022 16:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DB9C433C1;
        Wed, 27 Jul 2022 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940711;
        bh=klKyENgDMgQoTOB1na83eS8HEPD+pBR+wp44LUbuklY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbd8c//+lRo1TJnAncv2uHH2HkHMAryE3H9jBsdkIZ9LXRm8YIaNTWEfqLGH1OCcT
         Ziu45p7f9bWyUcQuMVT03ba+qEqk9+6QOdqzw6a8pQXQGmxF35DHNABKj2ERHOloSU
         N+So08HIxpCBiQq6sWYAVUJgwL3fVqPYGxQr/thU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 121/158] tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
Date:   Wed, 27 Jul 2022 18:13:05 +0200
Message-Id: <20220727161026.301572600@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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
index 8d02972e46cd..4f5de382e192 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1421,8 +1421,8 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
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
index 5cda762a43dd..5bcd12a9d8ff 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1896,7 +1896,7 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle &&
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) &&
 		    (s32)(tcp_jiffies32 - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto &&
 		    !ca_ops->cong_control)
 			tcp_cwnd_application_limited(sk);
-- 
2.35.1



