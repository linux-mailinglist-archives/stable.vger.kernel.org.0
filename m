Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA8C3AEFBD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhFUQlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhFUQjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD37D61437;
        Mon, 21 Jun 2021 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293002;
        bh=AlZxMTimW7gPGtuJO0fGZ+pM38Qe9O+6Uqp/tfm3fPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EaigIEWp7jEY3JwzWXVEUxF+zW2+l4tV9nrgKnt19S8x/x6E8/8gqw7qeQd/O2mK
         FijQsPUfPy6boIPeC+viTyFsdkDDbzE/7doMUNJlC6qnmIo7nYW+6f9Z6l8CExYQaa
         gHMeJ1GevuBA6DVjua7+50g1P1gftwQlv+UcAHWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Kaustubh Pandey <kapandey@codeaurora.org>
Subject: [PATCH 5.12 029/178] udp: fix race between close() and udp_abort()
Date:   Mon, 21 Jun 2021 18:14:03 +0200
Message-Id: <20210621154922.876383898@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit a8b897c7bcd47f4147d066e22cc01d1026d7640e ]

Kaustubh reported and diagnosed a panic in udp_lib_lookup().
The root cause is udp_abort() racing with close(). Both
racing functions acquire the socket lock, but udp{v6}_destroy_sock()
release it before performing destructive actions.

We can't easily extend the socket lock scope to avoid the race,
instead use the SOCK_DEAD flag to prevent udp_abort from doing
any action when the critical race happens.

Diagnosed-and-tested-by: Kaustubh Pandey <kapandey@codeaurora.org>
Fixes: 5d77dca82839 ("net: diag: support SOCK_DESTROY for UDP sockets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 10 ++++++++++
 net/ipv6/udp.c |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c586a6bb8c6d..3dd340679d09 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2576,6 +2576,9 @@ void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	bool slow = lock_sock_fast(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_flush_pending_frames(sk);
 	unlock_sock_fast(sk, slow);
 	if (static_branch_unlikely(&udp_encap_needed_key)) {
@@ -2826,10 +2829,17 @@ int udp_abort(struct sock *sk, int err)
 {
 	lock_sock(sk);
 
+	/* udp{v6}_destroy_sock() sets it under the sk lock, avoid racing
+	 * with close()
+	 */
+	if (sock_flag(sk, SOCK_DEAD))
+		goto out;
+
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
 	__udp_disconnect(sk, 0);
 
+out:
 	release_sock(sk);
 
 	return 0;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fd..29288f134d7a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1597,6 +1597,9 @@ void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	lock_sock(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_v6_flush_pending_frames(sk);
 	release_sock(sk);
 
-- 
2.30.2



