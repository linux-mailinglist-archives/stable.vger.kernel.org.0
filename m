Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00F6188037
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCQLIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgCQLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DEC620735;
        Tue, 17 Mar 2020 11:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443292;
        bh=JIdyo+37I2+6TGmwXEWLR/ub0pIGz6sZ9Z5rPS9o31I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA67FONQ1QmLeVrdZKaPN4QoDYg5A/dsDNTd7WfNhRgKUoqR8QprbS9//ADTne6Ib
         0Pb/8aZG8I+VGPVVDCIrKdiLQSotMviNOVM1L0z2+tem8n9ZR6YSVlfo+BuMvVGrZI
         QHSQMnUi5aLm4/Vo3C71bewcSifXSx+OHmrSClkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 037/151] net: memcg: late association of sock to memcg
Date:   Tue, 17 Mar 2020 11:54:07 +0100
Message-Id: <20200317103329.274213369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
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
@@ -6683,20 +6683,6 @@ void mem_cgroup_sk_alloc(struct sock *sk
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
@@ -1830,7 +1830,10 @@ struct sock *sk_clone_lock(const struct
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
@@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock
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


