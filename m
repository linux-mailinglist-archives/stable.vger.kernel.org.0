Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908C3961E9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhEaOrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhEaOpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BB261C89;
        Mon, 31 May 2021 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469342;
        bh=kdjzop78knCLkR4VrgYLtpxAmxAhLQBeZYKw52Pzjhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8ZINK5z+w1mL8SzhPn/9XIgxwdrLnUcOYTHNDNaCt9PMX8uH0aU/+u9AaeUFMNRy
         kR0mf8g3InGoqJ8/s0WG73kqpJTMzTMd6XLDV868gMJ90+uIqIWmrC+U3MJH/yyqkQ
         L/lPpfYw4mVdQGy7s+MSDzvKZsd0acDRjXk2FsKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 134/296] tipc: wait and exit until all work queues are done
Date:   Mon, 31 May 2021 15:13:09 +0200
Message-Id: <20210531130708.397745526@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 04c26faa51d1e2fe71cf13c45791f5174c37f986 upstream.

On some host, a crash could be triggered simply by repeating these
commands several times:

  # modprobe tipc
  # tipc bearer enable media udp name UDP1 localip 127.0.0.1
  # rmmod tipc

  [] BUG: unable to handle kernel paging request at ffffffffc096bb00
  [] Workqueue: events 0xffffffffc096bb00
  [] Call Trace:
  []  ? process_one_work+0x1a7/0x360
  []  ? worker_thread+0x30/0x390
  []  ? create_worker+0x1a0/0x1a0
  []  ? kthread+0x116/0x130
  []  ? kthread_flush_work_fn+0x10/0x10
  []  ? ret_from_fork+0x35/0x40

When removing the TIPC module, the UDP tunnel sock will be delayed to
release in a work queue as sock_release() can't be done in rtnl_lock().
If the work queue is schedule to run after the TIPC module is removed,
kernel will crash as the work queue function cleanup_beareri() code no
longer exists when trying to invoke it.

To fix it, this patch introduce a member wq_count in tipc_net to track
the numbers of work queues in schedule, and  wait and exit until all
work queues are done in tipc_exit_net().

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/core.c      |    2 ++
 net/tipc/core.h      |    2 ++
 net/tipc/udp_media.c |    2 ++
 3 files changed, 6 insertions(+)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -119,6 +119,8 @@ static void __net_exit tipc_exit_net(str
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&tipc_net(net)->crypto_tx);
 #endif
+	while (atomic_read(&tn->wq_count))
+		cond_resched();
 }
 
 static void __net_exit tipc_pernet_pre_exit(struct net *net)
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -149,6 +149,8 @@ struct tipc_net {
 #endif
 	/* Work item for net finalize */
 	struct tipc_net_work final_work;
+	/* The numbers of work queues in schedule */
+	atomic_t wq_count;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -812,6 +812,7 @@ static void cleanup_bearer(struct work_s
 		kfree_rcu(rcast, rcu);
 	}
 
+	atomic_dec(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	dst_cache_destroy(&ub->rcast.dst_cache);
 	udp_tunnel_sock_release(ub->ubsock);
 	synchronize_net();
@@ -832,6 +833,7 @@ static void tipc_udp_disable(struct tipc
 	RCU_INIT_POINTER(ub->bearer, NULL);
 
 	/* sock_release need to be done outside of rtnl lock */
+	atomic_inc(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	INIT_WORK(&ub->work, cleanup_bearer);
 	schedule_work(&ub->work);
 }


