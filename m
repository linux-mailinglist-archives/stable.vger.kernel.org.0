Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED121D82CC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgERR7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732046AbgERR7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A8A5207C4;
        Mon, 18 May 2020 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824764;
        bh=JnO/HTljguYyDlXacpcME3iHeEzv1y1UnnpJKpBEuR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlVWc6igl7F2HGFsKa7Yr24qElvV4yTvpziqGuQgGLehGp3eOgLk8ftRRuO1xYVDQ
         a1Jw1egkIRRoZfwoML1B/5qOvc2/KtBwPgzb+fFtDEUVagvdRceBpdbO88c6fJ+E1Z
         gQfoNC3ACBd0lhq7JuDjImUrRan3Lw226ehLwc5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.4 142/147] bpf: Fix sk_psock refcnt leak when receiving message
Date:   Mon, 18 May 2020 19:37:45 +0200
Message-Id: <20200518173530.694837877@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 18f02ad19e2c2a1d9e1d55a4e1c0cbf51419151c upstream.

tcp_bpf_recvmsg() invokes sk_psock_get(), which returns a reference of
the specified sk_psock object to "psock" with increased refcnt.

When tcp_bpf_recvmsg() returns, local variable "psock" becomes invalid,
so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in several exception handling paths
of tcp_bpf_recvmsg(). When those error scenarios occur such as "flags"
includes MSG_ERRQUEUE, the function forgets to decrease the refcnt
increased by sk_psock_get(), causing a refcnt leak.

Fix this issue by calling sk_psock_put() or pulling up the error queue
read handling when those error scenarios occur.

Fixes: e7a5f1f1cd000 ("bpf/sockmap: Read psock ingress_msg before sk_receive_queue")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/1587872115-42805-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_bpf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -121,14 +121,17 @@ int tcp_bpf_recvmsg(struct sock *sk, str
 	struct sk_psock *psock;
 	int copied, ret;
 
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
-	    sk_psock_queue_empty(psock))
+	    sk_psock_queue_empty(psock)) {
+		sk_psock_put(sk, psock);
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	}
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);


