Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772AE5C02E0
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiIUP4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiIUPym (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255B69F74A;
        Wed, 21 Sep 2022 08:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BC8B830A9;
        Wed, 21 Sep 2022 15:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3142C433D7;
        Wed, 21 Sep 2022 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775404;
        bh=5wcpnd2fFHVNfLTOXzF1tU+HPio+ol1f7lC4fqNRIXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPxmuKlhg0mSmJewRaVDxPe8V7epWeWetiiowj9ihyQcTjR9Y4y6XVZT686ilblIl
         QBE03LAPypdxh0ejTsm9slTs7oRV7iQASwLI/3oITc7GwY8cBDqKS6n28eRH3YZ3oN
         f5QwR6Wbhc/k9JQujk6pnff9L0Q7iHLI+uPavnlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>,
        Sewook Seo <sewookseo@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 42/45] net: Find dst with sks xfrm policy not ctl_sk
Date:   Wed, 21 Sep 2022 17:46:32 +0200
Message-Id: <20220921153648.413441860@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sewookseo <sewookseo@google.com>

commit e22aa14866684f77b4f6b6cae98539e520ddb731 upstream.

If we set XFRM security policy by calling setsockopt with option
IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
struct. However tcp_v6_send_response doesn't look up dst_entry with the
actual socket but looks up with tcp control socket. This may cause a
problem that a RST packet is sent without ESP encryption & peer's TCP
socket can't receive it.
This patch will make the function look up dest_entry with actual socket,
if the socket has XFRM policy(sock_policy), so that the TCP response
packet via this function can be encrypted, & aligned on the encrypted
TCP socket.

Tested: We encountered this problem when a TCP socket which is encrypted
in ESP transport mode encryption, receives challenge ACK at SYN_SENT
state. After receiving challenge ACK, TCP needs to send RST to
establish the socket at next SYN try. But the RST was not encrypted &
peer TCP socket still remains on ESTABLISHED state.
So we verified this with test step as below.
[Test step]
1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED).
2. Client tries a new connection on the same TCP ports(src & dst).
3. Server will return challenge ACK instead of SYN,ACK.
4. Client will send RST to server to clear the SOCKET.
5. Client will retransmit SYN to server on the same TCP ports.
[Expected result]
The TCP connection should be established.

Cc: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Sehee Lee <seheele@google.com>
Signed-off-by: Sewook Seo <sewookseo@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h   |    2 ++
 net/ipv4/ip_output.c |    2 +-
 net/ipv4/tcp_ipv4.c  |    2 ++
 net/ipv6/tcp_ipv6.c  |    5 ++++-
 4 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1190,6 +1190,8 @@ int __xfrm_sk_clone_policy(struct sock *
 
 static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
 {
+	if (!sk_fullsock(osk))
+		return 0;
 	sk->sk_policy[0] = NULL;
 	sk->sk_policy[1] = NULL;
 	if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1704,7 +1704,7 @@ void ip_send_unicast_reply(struct sock *
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
 	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
-	rt = ip_route_output_key(net, &fl4);
+	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt))
 		return;
 
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -817,6 +817,7 @@ static void tcp_v4_send_reset(const stru
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+		xfrm_sk_clone_policy(ctl_sk, sk);
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -825,6 +826,7 @@ static void tcp_v4_send_reset(const stru
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1001,7 +1001,10 @@ static void tcp_v6_send_response(const s
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+	if (sk && sk->sk_state != TCP_TIME_WAIT)
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL); /*sk's xfrm_policy can be referred*/
+	else
+		dst = ip6_dst_lookup_flow(net, ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,


