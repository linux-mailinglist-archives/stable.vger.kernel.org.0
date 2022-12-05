Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DB7643247
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiLETZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiLETZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B1926124
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44E11612FB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598FBC433C1;
        Mon,  5 Dec 2022 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268048;
        bh=Y+4xl1S/Avm7ArvBM3OMahKepe8+qINUtjbIuBjOSZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyfBASsAVFXD+Gnn9EVpJg/MRgJbRNwzcu6WEaVmIL44jfKskLmfz1U2p1Q23n73z
         mxTTcwbe2r6k7cUnDagc1QbzILftwmpmWoIRsUCS3nR9CSzeXRxfvV3/YR67r3pgos
         GCoApfh9CxK8c+5ffbewmrU/yGmoP+jY2i/+JwiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/105] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
Date:   Mon,  5 Dec 2022 20:09:01 +0100
Message-Id: <20221205190804.130005429@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 77934dc6db0d2b111a8f2759e9ad2fb67f5cffa5 ]

When connect() is called on a socket bound to the wildcard address,
we change the socket's saddr to a local address.  If the socket
fails to connect() to the destination, we have to reset the saddr.

However, when an error occurs after inet_hash6?_connect() in
(dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
the socket bound to the address.

>From the user's point of view, whether saddr is reset or not varies
with errno.  Let's fix this inconsistent behaviour.

Note that after this patch, the repro [0] will trigger the WARN_ON()
in inet_csk_get_port() again, but this patch is not buggy and rather
fixes a bug papering over the bhash2's bug for which we need another
fix.

For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
by this sequence:

  s1 = socket()
  s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  s1.bind(('127.0.0.1', 10000))
  s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
  # or s1.connect(('127.0.0.1', 10000))

  s2 = socket()
  s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  s2.bind(('0.0.0.0', 10000))
  s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL

  s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);

[0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09

Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv4.c     | 2 ++
 net/dccp/ipv6.c     | 2 ++
 net/ipv4/tcp_ipv4.c | 2 ++
 net/ipv6/tcp_ipv6.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 7e93087d1366..c021d5dde8f7 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -134,6 +134,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index ae4851fdbe9e..72803e1ea10a 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -957,6 +957,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6549e07ce19c..bd374eac9a75 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -328,6 +328,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7a5a7a4265cf..babf69b2403b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -327,6 +327,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
-- 
2.35.1



