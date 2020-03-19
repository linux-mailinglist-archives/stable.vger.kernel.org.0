Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAE818B4FC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCSNOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbgCSNOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F77921D7F;
        Thu, 19 Mar 2020 13:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623674;
        bh=saqBANQJbeRvoQmiKiyt2ebe9H6CFM0oj10gcBaJu5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZtNOiraMMTGD78ivO8096Z2l8oQRX0v1XAqlnV0zZ6gn1h5l7jO58nsw5+gxwKDe
         Ailq6/neRDt7h2CdFz7vwxheEnIImD29wH/sIOjbtCeFMfYVXPIBgGy3Jomxv+8xxo
         05jgdU1jtN2MPQTO+usDEmaWLuHVj5dciaVB4sHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 16/99] net: memcg: late association of sock to memcg
Date:   Thu, 19 Mar 2020 14:02:54 +0100
Message-Id: <20200319123946.565820734@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit d752a4986532cb6305dfd5290a614cde8072769d ]

If a TCP socket is allocated in IRQ context or cloned from unassociated
(i.e. not associated to a memcg) in IRQ context then it will remain
unassociated for its whole life. Almost half of the TCPs created on the
system are created in IRQ context, so, memory used by such sockets will
not be accounted by the memcg.

This issue is more widespread in cgroup v1 where network memory
accounting is opt-in but it can happen in cgroup v2 if the source socket
for the cloning was created in root memcg.

To fix the issue, just do the association of the sockets at the accept()
time in the process context and then force charge the memory buffer
already used and reserved by the socket.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c                 |   14 --------------
 net/core/sock.c                 |    5 ++++-
 net/ipv4/inet_connection_sock.c |   20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5867,20 +5867,6 @@ void mem_cgroup_sk_alloc(struct sock *sk
 	if (!mem_cgroup_sockets_enabled)
 		return;
 
-	/*
-	 * Socket cloning can throw us here with sk_memcg already
-	 * filled. It won't however, necessarily happen from
-	 * process context. So the test for root memcg given
-	 * the current task's memcg won't help us in this case.
-	 *
-	 * Respecting the original socket's memcg is a better
-	 * decision in this case.
-	 */
-	if (sk->sk_memcg) {
-		css_get(&sk->sk_memcg->css);
-		return;
-	}
-
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
 	if (in_interrupt())
 		return;
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1684,7 +1684,10 @@ struct sock *sk_clone_lock(const struct
 		atomic_set(&newsk->sk_zckey, 0);
 
 		sock_reset_flag(newsk, SOCK_DONE);
-		mem_cgroup_sk_alloc(newsk);
+
+		/* sk->sk_memcg will be populated at accept() time */
+		newsk->sk_memcg = NULL;
+
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -475,6 +475,26 @@ struct sock *inet_csk_accept(struct sock
 		}
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
+
+	if (mem_cgroup_sockets_enabled) {
+		int amt;
+
+		/* atomically get the memory usage, set and charge the
+		 * sk->sk_memcg.
+		 */
+		lock_sock(newsk);
+
+		/* The sk has not been accepted yet, no need to look at
+		 * sk->sk_wmem_queued.
+		 */
+		amt = sk_mem_pages(newsk->sk_forward_alloc +
+				   atomic_read(&sk->sk_rmem_alloc));
+		mem_cgroup_sk_alloc(newsk);
+		if (newsk->sk_memcg && amt)
+			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
+
+		release_sock(newsk);
+	}
 out:
 	release_sock(sk);
 	if (req)


