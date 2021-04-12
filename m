Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E367335BDFF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhDLI4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238643AbhDLIyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E2E61247;
        Mon, 12 Apr 2021 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217545;
        bh=yBZaTr86OwOgcrrKgd9PrgxNtHgFhLVTq8vlOp9NkAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVWt0CnyvFeXQzBwaTwW/9aCcm2AfnNebOdVDv6zZzLK5ju01i02q+TmgkWdect4Q
         1MfbMEqLlHTK0MRpAJzxFPFA+afdmcX/AJwqtVUbqyEreh7AlbeWPmaOQrCqBVenLr
         l2AmsMy4OpC/QpAVPG83iNUhBHwdtxD7KmKn9aW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 052/188] bpf, sockmap: Fix sk->prot unhash op reset
Date:   Mon, 12 Apr 2021 10:39:26 +0200
Message-Id: <20210412084015.375217149@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
 include/linux/skmsg.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -349,8 +349,13 @@ static inline void sk_psock_update_proto
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-	sk->sk_prot->unhash = psock->saved_unhash;
 	if (inet_csk_has_ulp(sk)) {
+		/* TLS does not have an unhash proto in SW cases, but we need
+		 * to ensure we stop using the sock_map unhash routine because
+		 * the associated psock is being removed. So use the original
+		 * unhash handler.
+		 */
+		WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
 		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 	} else {
 		sk->sk_write_space = psock->saved_write_space;


