Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00A9586AA0
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiHAMTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiHAMTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:19:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E860C3F30A;
        Mon,  1 Aug 2022 04:59:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3EF7B80E8F;
        Mon,  1 Aug 2022 11:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A891C433D6;
        Mon,  1 Aug 2022 11:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355176;
        bh=8RHGLgjkKHYqDdMcrfdBSXF55Oh4lykvXOWSLicOJIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyfuoZ0p3IlGIH5XfSBESs3G29e7DQcJk8yTjLvHaLN7/pS9Vp5bLYQTrNhwDmQqO
         5Mx+jPImKJ/tHmU9FqDNBJiQJ8r58M3iKR/U/Y++rGdGXol/RY2XnjOhXHXWHHAwKA
         y+UKjsVchXRcHTk2QRmuzkZBLCgICFwM84q/MOVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 63/88] tcp: Fix data-races around sysctl_tcp_reflect_tos.
Date:   Mon,  1 Aug 2022 13:47:17 +0200
Message-Id: <20220801114140.947814449@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

[ Upstream commit 870e3a634b6a6cb1543b359007aca73fe6a03ac5 ]

While reading sysctl_tcp_reflect_tos, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 net/ipv6/tcp_ipv6.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a57f96b86874..1db9938163c4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1007,7 +1007,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
-		tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tos = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(inet_sk(sk)->tos & INET_ECN_MASK) :
 				inet_sk(sk)->tos;
@@ -1527,7 +1527,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	if (!dst) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5185c11dc444..979e0d7b2119 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -546,7 +546,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		if (np->repflow && ireq->pktopts)
 			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
 
-		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tclass = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(np->tclass & INET_ECN_MASK) :
 				np->tclass;
@@ -1314,7 +1314,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	/* Clone native IPv6 options from listening socket (if any)
-- 
2.35.1



