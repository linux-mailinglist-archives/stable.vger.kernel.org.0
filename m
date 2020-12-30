Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4037B2E7C25
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 20:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgL3TeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 14:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3TeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 14:34:14 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291BC061799
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d187so30691862ybc.6
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 11:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=laN61xa2RITUtOWmIdEbP8wxzMAHFPN5hIXgm82l3m0=;
        b=tWvlbxgrqc3JGGuS6rHg7AyWWssFumrhaHYykU2sXVqwG7Z7oIV0Myb27YSlMqomCs
         oHQfZavNZ98Qpl4Vv2CgT9mKaEzM/DIaVxpFCkFy9xbj703l0NX21SZMJSrf6WAxiWhU
         JYQ2M/9qLuson7xdrcnbtIZ4d8QsFYuSJ8plCFrAkz+ewsuNvqn9gJB6sDZG55+54pAP
         pq5UA8nJuAF70uiKuF/7F9TjGeqlsooRLcRemsbLDy3Xlnl4JBYSrXH49vxcAcUcpQVl
         vQL/QU3fgyGj7pB57050TNwel4IGdVYRVoKBNHKTrSibMKN0ErVd54VSXV74PBdKb/te
         LwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=laN61xa2RITUtOWmIdEbP8wxzMAHFPN5hIXgm82l3m0=;
        b=uTtxH4R8/x7Ev0v8AHeOZ+8YcDjzjiv8jxYppTpo7vzlRaPfH8wYcIbjjLrlKmHm7M
         9JaN/YRvKaFlOMdPLJzuH3ILvEuRMufDoScHQOdj9xSsmbVxtrzZOHfwewThHQZ4m31+
         uHY03v9bjTaMjSUhbpEcAJx7KtzM/R3xOQL9ftlsrHVtamh2pg5Qyhy2Vv+heZokT8fV
         QhH30EnX/xKpFXwO3vJ0LjkA/ouG8g/p7QCJiaM2gvkjVsTMjvcrNCtzHGwPzAILa6ml
         +xhKh5Z37bJUqzZ9BTNYraPPi5gsiMvtwQiBHsJNA4NeDGCzvVCu8W+zqSwRCoURLclR
         kc4Q==
X-Gm-Message-State: AOAM533XkWXHBaM8SJtu0slFu+3sKQB9AUkCDxW4P4o+fvtj/p03lHoi
        Ks9jRG0aJgHMYHO9m+ivH9V0T9KsbEQ=
X-Google-Smtp-Source: ABdhPJyCLXORabA1P80fCWQKSxUmWKkH7k/ZQpKP/l5y0S7riBv6vNGfffN3VPSHAL34pozD5xVu3/3GVtE=
Sender: "surenb via sendgmr" <surenb@surenb1.mtv.corp.google.com>
X-Received: from surenb1.mtv.corp.google.com ([100.98.240.136]) (user=surenb
 job=sendgmr) by 2002:a25:3701:: with SMTP id e1mr83529034yba.50.1609356812915;
 Wed, 30 Dec 2020 11:33:32 -0800 (PST)
Date:   Wed, 30 Dec 2020 11:33:23 -0800
In-Reply-To: <20201230193323.2133009-1-surenb@google.com>
Message-Id: <20201230193323.2133009-3-surenb@google.com>
Mime-Version: 1.0
References: <20201230193323.2133009-1-surenb@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 2/2] l2tp: fix races with ipv4-mapped ipv6 addresses
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        syzbot+92fa328176eb07e4ac1a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit b954f94023dcc61388c8384f0f14eb8e42c863c5 upstream

The l2tp_tunnel_create() function checks for v4mapped ipv6
sockets and cache that flag, so that l2tp core code can
reusing it at xmit time.

If the socket is provided by the userspace, the connection
status of the tunnel sockets can change between the tunnel
creation and the xmit call, so that syzbot is able to
trigger the following splat:

BUG: KASAN: use-after-free in ip6_dst_idev include/net/ip6_fib.h:192
[inline]
BUG: KASAN: use-after-free in ip6_xmit+0x1f76/0x2260
net/ipv6/ip6_output.c:264
Read of size 8 at addr ffff8801bd949318 by task syz-executor4/23448

CPU: 0 PID: 23448 Comm: syz-executor4 Not tainted 4.16.0-rc4+ #65
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x194/0x24d lib/dump_stack.c:53
  print_address_description+0x73/0x250 mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report+0x23c/0x360 mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  ip6_dst_idev include/net/ip6_fib.h:192 [inline]
  ip6_xmit+0x1f76/0x2260 net/ipv6/ip6_output.c:264
  inet6_csk_xmit+0x2fc/0x580 net/ipv6/inet6_connection_sock.c:139
  l2tp_xmit_core net/l2tp/l2tp_core.c:1053 [inline]
  l2tp_xmit_skb+0x105f/0x1410 net/l2tp/l2tp_core.c:1148
  pppol2tp_sendmsg+0x470/0x670 net/l2tp/l2tp_ppp.c:341
  sock_sendmsg_nosec net/socket.c:630 [inline]
  sock_sendmsg+0xca/0x110 net/socket.c:640
  ___sys_sendmsg+0x767/0x8b0 net/socket.c:2046
  __sys_sendmsg+0xe5/0x210 net/socket.c:2080
  SYSC_sendmsg net/socket.c:2091 [inline]
  SyS_sendmsg+0x2d/0x50 net/socket.c:2087
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x453e69
RSP: 002b:00007f819593cc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f819593d6d4 RCX: 0000000000453e69
RDX: 0000000000000081 RSI: 000000002037ffc8 RDI: 0000000000000004
RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000004c3 R14: 00000000006f72e8 R15: 0000000000000000

This change addresses the issues:
* explicitly checking for TCP_ESTABLISHED for user space provided sockets
* dropping the v4mapped flag usage - it can become outdated - and
  explicitly invoking ipv6_addr_v4mapped() instead

The issue is apparently there since ancient times.

v1 -> v2: (many thanks to Guillaume)
 - with csum issue introduced in v1
 - replace pr_err with pr_debug
 - fix build issue with IPV6 disabled
 - move l2tp_sk_is_v4mapped in l2tp_core.c

v2 -> v3:
 - don't update inet_daddr for v4mapped address, unneeded
 - drop rendundant check at creation time

Reported-and-tested-by: syzbot+92fa328176eb07e4ac1a@syzkaller.appspotmail.com
Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/l2tp/l2tp_core.c | 38 ++++++++++++++++++--------------------
 net/l2tp/l2tp_core.h |  3 ---
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a8f575bf9b7c..15f8bd0364c2 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -112,6 +112,13 @@ struct l2tp_net {
 	spinlock_t l2tp_session_hlist_lock;
 };
 
+#if IS_ENABLED(CONFIG_IPV6)
+static bool l2tp_sk_is_v6(struct sock *sk)
+{
+	return sk->sk_family == PF_INET6 &&
+	       !ipv6_addr_v4mapped(&sk->sk_v6_daddr);
+}
+#endif
 
 static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
 {
@@ -1136,7 +1143,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
 	skb->ignore_df = 1;
 	skb_dst_drop(skb);
 #if IS_ENABLED(CONFIG_IPV6)
-	if (tunnel->sock->sk_family == PF_INET6 && !tunnel->v4mapped)
+	if (l2tp_sk_is_v6(tunnel->sock))
 		error = inet6_csk_xmit(tunnel->sock, skb, NULL);
 	else
 #endif
@@ -1199,6 +1206,15 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 		goto out_unlock;
 	}
 
+	/* The user-space may change the connection status for the user-space
+	 * provided socket at run time: we must check it under the socket lock
+	 */
+	if (tunnel->fd >= 0 && sk->sk_state != TCP_ESTABLISHED) {
+		kfree_skb(skb);
+		ret = NET_XMIT_DROP;
+		goto out_unlock;
+	}
+
 	inet = inet_sk(sk);
 	fl = &inet->cork.fl;
 	switch (tunnel->encap) {
@@ -1214,7 +1230,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 
 		/* Calculate UDP checksum if configured to do so */
 #if IS_ENABLED(CONFIG_IPV6)
-		if (sk->sk_family == PF_INET6 && !tunnel->v4mapped)
+		if (l2tp_sk_is_v6(sk))
 			udp6_set_csum(udp_get_no_check6_tx(sk),
 				      skb, &inet6_sk(sk)->saddr,
 				      &sk->sk_v6_daddr, udp_len);
@@ -1620,24 +1636,6 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	if (cfg != NULL)
 		tunnel->debug = cfg->debug;
 
-#if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == PF_INET6) {
-		struct ipv6_pinfo *np = inet6_sk(sk);
-
-		if (ipv6_addr_v4mapped(&np->saddr) &&
-		    ipv6_addr_v4mapped(&sk->sk_v6_daddr)) {
-			struct inet_sock *inet = inet_sk(sk);
-
-			tunnel->v4mapped = true;
-			inet->inet_saddr = np->saddr.s6_addr32[3];
-			inet->inet_rcv_saddr = sk->sk_v6_rcv_saddr.s6_addr32[3];
-			inet->inet_daddr = sk->sk_v6_daddr.s6_addr32[3];
-		} else {
-			tunnel->v4mapped = false;
-		}
-	}
-#endif
-
 	/* Mark socket as an encapsulation socket. See net/ipv4/udp.c */
 	tunnel->encap = encap;
 	if (encap == L2TP_ENCAPTYPE_UDP) {
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 2b9b6fb67ae9..57c1810f1a32 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -191,9 +191,6 @@ struct l2tp_tunnel {
 	struct sock		*sock;		/* Parent socket */
 	int			fd;		/* Parent fd, if tunnel socket
 						 * was created by userspace */
-#if IS_ENABLED(CONFIG_IPV6)
-	bool			v4mapped;
-#endif
 
 	struct work_struct	del_work;
 
-- 
2.29.2.729.g45daf8777d-goog

