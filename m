Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EEE4417C3
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhKAJju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232620AbhKAJhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F5D96128A;
        Mon,  1 Nov 2021 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758809;
        bh=RRqlQEZ47fdGBwq+opIEfcwMmp66tYLJ3Yj1NnoxAe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAzUG9fxCZOGpW12Nqoetg2tJ69Uk/0GIgtGtu3DkQH+uWgO5UtuYoPFTCsX05P1G
         PggK9cMp0VUcAgcyX7v5rZvej26qyJ8c9+dRY1RMwoYsQW0uVzY5xDZHkxNrPDVbro
         rUKBH+i7v9faAOh8/83UST0FfjdM1LIYZ6aHB3SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.10 36/77] tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function
Date:   Mon,  1 Nov 2021 10:17:24 +0100
Message-Id: <20211101082519.419310564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

commit cd9733f5d75c94a32544d6ce5be47e14194cf137 upstream.

With two Msgs, msgA and msgB and a user doing nonblocking sendmsg calls (or
multiple cores) on a single socket 'sk' we could get the following flow.

 msgA, sk                               msgB, sk
 -----------                            ---------------
 tcp_bpf_sendmsg()
 lock(sk)
 psock = sk->psock
                                        tcp_bpf_sendmsg()
                                        lock(sk) ... blocking
tcp_bpf_send_verdict
if (psock->eval == NONE)
   psock->eval = sk_psock_msg_verdict
 ..
 < handle SK_REDIRECT case >
   release_sock(sk)                     < lock dropped so grab here >
   ret = tcp_bpf_sendmsg_redir
                                        psock = sk->psock
                                        tcp_bpf_send_verdict
 lock_sock(sk) ... blocking on B
                                        if (psock->eval == NONE) <- boom.
                                         psock->eval will have msgA state

The problem here is we dropped the lock on msgA and grabbed it with msgB.
Now we have old state in psock and importantly psock->eval has not been
cleared. So msgB will run whatever action was done on A and the verdict
program may never see it.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211012052019.184398-1-liujian56@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bpf.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -317,6 +317,7 @@ static int tcp_bpf_send_verdict(struct s
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
+	u32 eval = __SK_NONE;
 	int ret;
 
 more_data:
@@ -360,13 +361,24 @@ more_data:
 	case __SK_REDIRECT:
 		sk_redir = psock->sk_redir;
 		sk_msg_apply_bytes(psock, tosend);
+		if (!psock->apply_bytes) {
+			/* Clean up before releasing the sock lock. */
+			eval = psock->eval;
+			psock->eval = __SK_NONE;
+			psock->sk_redir = NULL;
+		}
 		if (psock->cork) {
 			cork = true;
 			psock->cork = NULL;
 		}
 		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
+
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+
+		if (eval == __SK_REDIRECT)
+			sock_put(sk_redir);
+
 		lock_sock(sk);
 		if (unlikely(ret < 0)) {
 			int free = sk_msg_free_nocharge(sk, msg);


