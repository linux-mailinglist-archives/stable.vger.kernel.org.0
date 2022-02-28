Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0F84C7715
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiB1SLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240951AbiB1SJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F11D60CF8;
        Mon, 28 Feb 2022 09:49:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22D64B810DB;
        Mon, 28 Feb 2022 17:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62477C340E7;
        Mon, 28 Feb 2022 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070524;
        bh=CBgevf1pY8eY7xOWrAXmwUj5QG1zUH/pjtrJvDnC8rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCibI38lwK2yi6GFCRr6RlZT4UQIOWuSQuVYuWToxZdAR+gzKTMrtkSoYwb/Uhfh/
         3z7KuQsvhprhjx6Op/VDNUhDe58kTObGMPnJAjvHud7wKR5MVnKUxZu28fH2iryXHm
         hV9eJtvbX3H3S4XxYGHKHfbgfA2+K4IF6l0FrT+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 103/164] net: use sk_is_tcp() in more places
Date:   Mon, 28 Feb 2022 18:24:25 +0100
Message-Id: <20220228172409.132500311@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 42f67eea3ba36cef2dce2e853de6ddcb2e89eb39 ]

Move sk_is_tcp() to include/net/sock.h and use it where we can.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 6 ------
 include/net/sock.h    | 5 +++++
 net/core/skbuff.c     | 6 ++----
 net/core/sock.c       | 6 ++----
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 584d94be9c8b0..18a717fe62eb0 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -507,12 +507,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
-static inline bool sk_is_tcp(const struct sock *sk)
-{
-	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
-}
-
 static inline bool sk_is_udp(const struct sock *sk)
 {
 	return sk->sk_type == SOCK_DGRAM &&
diff --git a/include/net/sock.h b/include/net/sock.h
index d47e9658da285..4e575735563a7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2654,6 +2654,11 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
 			   &skb_shinfo(skb)->tskey);
 }
 
+static inline bool sk_is_tcp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 92edd03c2cd1c..2b2e19afef158 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4849,8 +4849,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 	serr->header.h4.iif = skb->dev ? skb->dev->ifindex : 0;
 	if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
-		if (sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM)
+		if (sk_is_tcp(sk))
 			serr->ee.ee_data -= sk->sk_tskey;
 	}
 
@@ -4919,8 +4918,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 	if (tsonly) {
 #ifdef CONFIG_INET
 		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
-		    sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM) {
+		    sk_is_tcp(sk)) {
 			skb = tcp_get_timestamping_opt_stats(sk, orig_skb,
 							     ack_skb);
 			opt_stats = true;
diff --git a/net/core/sock.c b/net/core/sock.c
index 7de234693a3bf..d18e4ffd84820 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -874,8 +874,7 @@ int sock_set_timestamping(struct sock *sk, int optname,
 
 	if (val & SOF_TIMESTAMPING_OPT_ID &&
 	    !(sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)) {
-		if (sk->sk_protocol == IPPROTO_TCP &&
-		    sk->sk_type == SOCK_STREAM) {
+		if (sk_is_tcp(sk)) {
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
@@ -1372,8 +1371,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_ZEROCOPY:
 		if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
-			if (!((sk->sk_type == SOCK_STREAM &&
-			       sk->sk_protocol == IPPROTO_TCP) ||
+			if (!(sk_is_tcp(sk) ||
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
 				ret = -ENOTSUPP;
-- 
2.34.1



