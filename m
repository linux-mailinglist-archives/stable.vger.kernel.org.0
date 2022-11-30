Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF7D63DF96
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiK3Ssy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiK3Ssl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B515E9E7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1182261D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF95C433D6;
        Wed, 30 Nov 2022 18:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834115;
        bh=9KhG1zB3tGAjBmWnTeqqbsGcJyBzz5h0YLKS50PZGPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVLL7O6zHmEw3BABZMkdDnWAsO7FdGYC+/GMXMw6eDl/J8iqNsdqTn8rpqu3l/wC9
         cjnp69eV7jhMfqVRMeokU/VYElqQ30GMBgcTY7ON68PERH7TR/t8w+nf75jr9nlqhn
         iYyC2taXYuKancYXxsa1Bqm5xRDuybIeY2yLTTWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 134/289] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
Date:   Wed, 30 Nov 2022 19:21:59 +0100
Message-Id: <20221130180547.176189102@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index da6e3b20cd75..60379ad7ae06 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -136,6 +136,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * This unhashes the socket and releases the local port, if necessary.
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fd44638ec16b..f9ed81a0ddbb 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -967,6 +967,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	dccp_set_state(sk, DCCP_CLOSED);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe9a6022db66..ef8013e2134f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -323,6 +323,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * if necessary.
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 	ip_rt_put(rt);
 	sk->sk_route_caps = 0;
 	inet->inet_dport = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e54eee80ce5f..5516cfb96c48 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -340,6 +340,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 late_failure:
 	tcp_set_state(sk, TCP_CLOSE);
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+		inet_reset_saddr(sk);
 failure:
 	inet->inet_dport = 0;
 	sk->sk_route_caps = 0;
-- 
2.35.1



