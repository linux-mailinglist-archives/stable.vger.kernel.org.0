Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5827935BD0C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhDLIrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhDLIqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC5B561243;
        Mon, 12 Apr 2021 08:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217163;
        bh=FQJbzzytCx483H7KJVt/YJXUP21vVBFtQmovjuBIkC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjpaHGaJRunsQKzAxZANzgsZ8i58jY4/+cprjDF1/Rt1UOvA5TloonRyD4KkmdLJM
         PuY4OKhzthHpXe7yvnHqcMl40AXpHzejzDrsGZDPUNwQeMB0n7WwLfkJxDjSbNtjIx
         e2UbPYYYMk9KeimLvhbQbV87zufW3wDl1bk7O8hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 027/111] bpf, sockmap: Fix sk->prot unhash op reset
Date:   Mon, 12 Apr 2021 10:40:05 +0200
Message-Id: <20210412084005.138857863@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 1c84b33101c82683dee8b06761ca1f69e78c8ee7 upstream.

In '4da6a196f93b1' we fixed a potential unhash loop caused when
a TLS socket in a sockmap was removed from the sockmap. This
happened because the unhash operation on the TLS ctx continued
to point at the sockmap implementation of unhash even though the
psock has already been removed. The sockmap unhash handler when a
psock is removed does the following,

 void sock_map_unhash(struct sock *sk)
 {
	void (*saved_unhash)(struct sock *sk);
	struct sk_psock *psock;

	rcu_read_lock();
	psock = sk_psock(sk);
	if (unlikely(!psock)) {
		rcu_read_unlock();
		if (sk->sk_prot->unhash)
			sk->sk_prot->unhash(sk);
		return;
	}
        [...]
 }

The unlikely() case is there to handle the case where psock is detached
but the proto ops have not been updated yet. But, in the above case
with TLS and removed psock we never fixed sk_prot->unhash() and unhash()
points back to sock_map_unhash resulting in a loop. To fix this we added
this bit of code,

 static inline void sk_psock_restore_proto(struct sock *sk,
                                          struct sk_psock *psock)
 {
       sk->sk_prot->unhash = psock->saved_unhash;

This will set the sk_prot->unhash back to its saved value. This is the
correct callback for a TLS socket that has been removed from the sock_map.
Unfortunately, this also overwrites the unhash pointer for all psocks.
We effectively break sockmap unhash handling for any future socks.
Omitting the unhash operation will leave stale entries in the map if
a socket transition through unhash, but does not do close() op.

To fix set unhash correctly before calling into tls_update. This way the
TLS enabled socket will point to the saved unhash() handler.

Fixes: 4da6a196f93b1 ("bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/161731441904.68884.15593917809745631972.stgit@john-XPS-13-9370
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -355,13 +355,17 @@ static inline void sk_psock_update_proto
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-	sk->sk_prot->unhash = psock->saved_unhash;
-
 	if (psock->sk_proto) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 		bool has_ulp = !!icsk->icsk_ulp_data;
 
 		if (has_ulp) {
+			/* TLS does not have an unhash proto in SW cases, but we need
+			 * to ensure we stop using the sock_map unhash routine because
+			 * the associated psock is being removed. So use the original
+			 * unhash handler.
+			 */
+			WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
 			tcp_update_ulp(sk, psock->sk_proto,
 				       psock->saved_write_space);
 		} else {


