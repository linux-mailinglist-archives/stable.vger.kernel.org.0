Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801C935BF6C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbhDLJGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239075AbhDLJCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D712F61277;
        Mon, 12 Apr 2021 09:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218068;
        bh=/nZERJHpbCS2/9x9axfPN9D6Maa+awKKzpED7hgcqSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joiAXtJQtSlADtHR8EMQD+/nSGXmrQYq1Z8hPggbiDVrByk0FtH07OBgQBS4Y0kd4
         eKXUDIoOpZ6vPtga4lEoNgmjShyD55cBniGJFkNhYKp4ODsvG6km0VDsoxfySNwOH9
         m7fhl78a8m3v4WP55AeFpP6QdPaOqO81D/X1YWiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.11 060/210] bpf, sockmap: Fix incorrect fwd_alloc accounting
Date:   Mon, 12 Apr 2021 10:39:25 +0200
Message-Id: <20210412084017.999589711@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 144748eb0c445091466c9b741ebd0bfcc5914f3d upstream.

Incorrect accounting fwd_alloc can result in a warning when the socket
is torn down,

 [18455.319240] WARNING: CPU: 0 PID: 24075 at net/core/stream.c:208 sk_stream_kill_queues+0x21f/0x230
 [...]
 [18455.319543] Call Trace:
 [18455.319556]  inet_csk_destroy_sock+0xba/0x1f0
 [18455.319577]  tcp_rcv_state_process+0x1b4e/0x2380
 [18455.319593]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319617]  ? tcp_finish_connect+0x1e0/0x1e0
 [18455.319631]  ? sk_reset_timer+0x15/0x70
 [18455.319646]  ? tcp_schedule_loss_probe+0x1b2/0x240
 [18455.319663]  ? lock_release+0xb2/0x3f0
 [18455.319676]  ? __release_sock+0x8a/0x1b0
 [18455.319690]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319704]  ? lock_release+0x3f0/0x3f0
 [18455.319717]  ? __tcp_close+0x2c6/0x790
 [18455.319736]  ? tcp_v4_do_rcv+0x168/0x370
 [18455.319750]  tcp_v4_do_rcv+0x168/0x370
 [18455.319767]  __release_sock+0xbc/0x1b0
 [18455.319785]  __tcp_close+0x2ee/0x790
 [18455.319805]  tcp_close+0x20/0x80

This currently happens because on redirect case we do skb_set_owner_r()
with the original sock. This increments the fwd_alloc memory accounting
on the original sock. Then on redirect we may push this into the queue
of the psock we are redirecting to. When the skb is flushed from the
queue we give the memory back to the original sock. The problem is if
the original sock is destroyed/closed with skbs on another psocks queue
then the original sock will not have a way to reclaim the memory before
being destroyed. Then above warning will be thrown

  sockA                          sockB

  sk_psock_strp_read()
   sk_psock_verdict_apply()
     -- SK_REDIRECT --
     sk_psock_skb_redirect()
                                skb_queue_tail(psock_other->ingress_skb..)

  sk_close()
   sock_map_unref()
     sk_psock_put()
       sk_psock_drop()
         sk_psock_zap_ingress()

At this point we have torn down our own psock, but have the outstanding
skb in psock_other. Note that SK_PASS doesn't have this problem because
the sk_psock_drop() logic releases the skb, its still associated with
our psock.

To resolve lets only account for sockets on the ingress queue that are
still associated with the current socket. On the redirect case we will
check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
or received with sk_psock_skb_ingress memory will be claimed on psock_other.

Fixes: 6fa9201a89898 ("bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/161731444013.68884.4021114312848535993.stgit@john-XPS-13-9370
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skmsg.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -488,6 +488,7 @@ static int sk_psock_skb_ingress_self(str
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
+	skb_set_owner_r(skb, sk);
 	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
 }
 
@@ -791,7 +792,6 @@ static void sk_psock_tls_verdict_apply(s
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -809,10 +809,6 @@ int sk_psock_tls_strp_read(struct sk_pso
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		/* We skip full set_owner_r here because if we do a SK_PASS
-		 * or SK_DROP we can skip skb memory accounting and use the
-		 * TLS context.
-		 */
 		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -881,12 +877,13 @@ static void sk_psock_strp_read(struct st
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -957,12 +954,13 @@ static int sk_psock_verdict_recv(read_de
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:


