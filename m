Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C003302AE6
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbhAYS4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731397AbhAYS4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:56:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E8722460;
        Mon, 25 Jan 2021 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600921;
        bh=mcVexRWC00imAWCq17eajfuVS7gvHY2Z29gdQV1BR1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnT/nYmjOCK/hg7Z2PNgXU0ko33FlAC4Pizxieo6ODZU+wNzrCGp7rv39iVMvY0/6
         mjvn0BPETZK6JXTF0qEkuoRnaiul9RVSwuGy6kFDjoCteAI//qnrKbLeWNH+kSlTfT
         OmaO5Pl8dHix6NWnDXXpg9wDfO1MOW83HyGp4svQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Dias <rdias@singlestore.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 192/199] tcp: Fix potential use-after-free due to double kfree()
Date:   Mon, 25 Jan 2021 19:40:14 +0100
Message-Id: <20210125183224.274965988@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

commit c89dffc70b340780e5b933832d8c3e045ef3791e upstream.

Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
socket into ehash and sets NULL to ireq_opt. Otherwise,
tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
socket.

The commit 01770a1661657 ("tcp: fix race condition when creating child
sockets from syncookies") added a new path, in which more than one cores
create full sockets for the same SYN cookie. Currently, the core which
loses the race frees the full socket without resetting inet_opt, resulting
in that both sock_put() and reqsk_put() call kfree() for the same memory:

  sock_put
    sk_free
      __sk_free
        sk_destruct
          __sk_destruct
            sk->sk_destruct/inet_sock_destruct
              kfree(rcu_dereference_protected(inet->inet_opt, 1));

  reqsk_put
    reqsk_free
      __reqsk_free
        req->rsk_ops->destructor/tcp_v4_reqsk_destructor
          kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));

Calling kmalloc() between the double kfree() can lead to use-after-free, so
this patch fixes it by setting NULL to inet_opt before sock_put().

As a side note, this kind of issue does not happen for IPv6. This is
because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
correspond to ireq_opt in IPv4.

Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
CC: Ricardo Dias <rdias@singlestore.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210118055920.82516-1-kuniyu@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1590,6 +1590,8 @@ struct sock *tcp_v4_syn_recv_sock(const
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
+		newinet->inet_opt = NULL;
+
 		if (!req_unhash && found_dup_sk) {
 			/* This code path should only be executed in the
 			 * syncookie case only
@@ -1597,8 +1599,6 @@ struct sock *tcp_v4_syn_recv_sock(const
 			bh_unlock_sock(newsk);
 			sock_put(newsk);
 			newsk = NULL;
-		} else {
-			newinet->inet_opt = NULL;
 		}
 	}
 	return newsk;


