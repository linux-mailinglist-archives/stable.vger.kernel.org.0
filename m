Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D976414557D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgAVNWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVNW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:29 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C4E62468C;
        Wed, 22 Jan 2020 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699348;
        bh=AZh0/pB0q2KopdriTAOIAUemGtq0gw/o3+IlVV507gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIh1oDvXENvYrBxG76Ga+z3qHERYu9PXPffYrT03s29qxFaIQkIAK5FIyvJTB1207
         tlY3p8DFf7e9beD6LF3S8XZq3r9tgMGMwks6voBc3048KAx1vIJn5jOZPtLT8ozQlN
         0vzjLp3AIIG/WxFHjOQRwALaDxc+g85onBODxtm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH 5.4 110/222] bpf: Sockmap/tls, push write_space updates through ulp updates
Date:   Wed, 22 Jan 2020 10:28:16 +0100
Message-Id: <20200122092841.611847883@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 33bfe20dd7117dd81fd896a53f743a233e1ad64f upstream.

When sockmap sock with TLS enabled is removed we cleanup bpf/psock state
and call tcp_update_ulp() to push updates to TLS ULP on top. However, we
don't push the write_space callback up and instead simply overwrite the
op with the psock stored previous op. This may or may not be correct so
to ensure we don't overwrite the TLS write space hook pass this field to
the ULP and have it fixup the ctx.

This completes a previous fix that pushed the ops through to the ULP
but at the time missed doing this for write_space, presumably because
write_space TLS hook was added around the same time.

Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-4-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/skmsg.h |   12 ++++++++----
 include/net/tcp.h     |    6 ++++--
 net/ipv4/tcp_ulp.c    |    6 ++++--
 net/tls/tls_main.c    |   10 +++++++---
 4 files changed, 23 insertions(+), 11 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -355,17 +355,21 @@ static inline void sk_psock_restore_prot
 					  struct sk_psock *psock)
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
-	sk->sk_write_space = psock->saved_write_space;
 
 	if (psock->sk_proto) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 		bool has_ulp = !!icsk->icsk_ulp_data;
 
-		if (has_ulp)
-			tcp_update_ulp(sk, psock->sk_proto);
-		else
+		if (has_ulp) {
+			tcp_update_ulp(sk, psock->sk_proto,
+				       psock->saved_write_space);
+		} else {
 			sk->sk_prot = psock->sk_proto;
+			sk->sk_write_space = psock->saved_write_space;
+		}
 		psock->sk_proto = NULL;
+	} else {
+		sk->sk_write_space = psock->saved_write_space;
 	}
 }
 
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2132,7 +2132,8 @@ struct tcp_ulp_ops {
 	/* initialize ulp */
 	int (*init)(struct sock *sk);
 	/* update ulp */
-	void (*update)(struct sock *sk, struct proto *p);
+	void (*update)(struct sock *sk, struct proto *p,
+		       void (*write_space)(struct sock *sk));
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
 	/* diagnostic */
@@ -2147,7 +2148,8 @@ void tcp_unregister_ulp(struct tcp_ulp_o
 int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
-void tcp_update_ulp(struct sock *sk, struct proto *p);
+void tcp_update_ulp(struct sock *sk, struct proto *p,
+		    void (*write_space)(struct sock *sk));
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -96,17 +96,19 @@ void tcp_get_available_ulp(char *buf, si
 	rcu_read_unlock();
 }
 
-void tcp_update_ulp(struct sock *sk, struct proto *proto)
+void tcp_update_ulp(struct sock *sk, struct proto *proto,
+		    void (*write_space)(struct sock *sk))
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	if (!icsk->icsk_ulp_ops) {
+		sk->sk_write_space = write_space;
 		sk->sk_prot = proto;
 		return;
 	}
 
 	if (icsk->icsk_ulp_ops->update)
-		icsk->icsk_ulp_ops->update(sk, proto);
+		icsk->icsk_ulp_ops->update(sk, proto, write_space);
 }
 
 void tcp_cleanup_ulp(struct sock *sk)
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -798,15 +798,19 @@ out:
 	return rc;
 }
 
-static void tls_update(struct sock *sk, struct proto *p)
+static void tls_update(struct sock *sk, struct proto *p,
+		       void (*write_space)(struct sock *sk))
 {
 	struct tls_context *ctx;
 
 	ctx = tls_get_ctx(sk);
-	if (likely(ctx))
+	if (likely(ctx)) {
+		ctx->sk_write_space = write_space;
 		ctx->sk_proto = p;
-	else
+	} else {
 		sk->sk_prot = p;
+		sk->sk_write_space = write_space;
+	}
 }
 
 static int tls_get_info(const struct sock *sk, struct sk_buff *skb)


