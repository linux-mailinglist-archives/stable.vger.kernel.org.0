Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430D44172E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhKAJeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232503AbhKAJcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE603611C6;
        Mon,  1 Nov 2021 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758658;
        bh=RfOAoIZHXPDWdVQfY1GGeh1/fhH4XB/qu00zO9Txl/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8W+eV2PEfh9Zm1GHLh8DgEPUHFpU+jEMY88e+E/HuqB46xKZtQFiET3TVCxwspdW
         i0LJLq7cy2Itvtr5jC33Jvl2S5czdCV1DNUNgmhkAjf9F5BdF44noEmtXa+g6m55gc
         JBh5/fyWJYt7ltqQAykDQBs6ZJVs05ky4xApvapg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.4 23/51] tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function
Date:   Mon,  1 Nov 2021 10:17:27 +0100
Message-Id: <20211101082505.874854191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -313,6 +313,7 @@ static int tcp_bpf_send_verdict(struct s
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
+	u32 eval = __SK_NONE;
 	int ret;
 
 more_data:
@@ -356,13 +357,24 @@ more_data:
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


