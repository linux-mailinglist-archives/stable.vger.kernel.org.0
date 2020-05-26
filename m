Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C8199010
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgCaJIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730793AbgCaJIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E2620787;
        Tue, 31 Mar 2020 09:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645722;
        bh=1V9krcCmZuB1V+rTsau6j1FmzkI174XQlHz6yYPQc34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WivyVJA8Qi19knp4hHi2iwJgP+C0YVcrTxcQfXcjlM5yTTiUARYpPBgKPAPDA793J
         kdp9GNfvz7iING/FaHalqGJXf2uPlmpKP/Qox63Tzyar/VbpZCPWFlPY4ZcUJDWYTx
         4+YxnxJbKS12U3UjfPouioiQD1LSZJp+QmxGBnhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.5 143/170] bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free
Date:   Tue, 31 Mar 2020 10:59:17 +0200
Message-Id: <20200331085438.574570462@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 90db6d772f749e38171d04619a5e3cd8804a6d02 upstream.

The bucket->lock is not needed in the sock_hash_free and sock_map_free
calls, in fact it is causing a splat due to being inside rcu block.

| BUG: sleeping function called from invalid context at net/core/sock.c:2935
| in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
| 3 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
| CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  ___might_sleep.cold+0xa6/0xb6
|  lock_sock_nested+0x28/0x90
|  sock_map_free+0x5f/0x180
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50

The reason we have stab->lock and bucket->locks in sockmap code is to
handle checking EEXIST in update/delete cases. We need to be careful during
an update operation that we check for EEXIST and we need to ensure that the
psock object is not in some partial state of removal/insertion while we do
this. So both map_update_common and sock_map_delete need to guard from being
run together potentially deleting an entry we are checking, etc. But by the
time we get to the tear-down code in sock_{ma[|hash}_free we have already
disconnected the map and we just did synchronize_rcu() in the line above so
no updates/deletes should be in flight. Because of this we can drop the
bucket locks from the map free'ing code, noting no update/deletes can be
in-flight.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/sock_map.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk map and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
-	raw_spin_lock_bh(&stab->lock);
 	for (i = 0; i < stab->map.max_entries; i++) {
 		struct sock **psk = &stab->sks[i];
 		struct sock *sk;
@@ -248,7 +251,6 @@ static void sock_map_free(struct bpf_map
 			release_sock(sk);
 		}
 	}
-	raw_spin_unlock_bh(&stab->lock);
 
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
@@ -863,10 +865,13 @@ static void sock_hash_free(struct bpf_ma
 	struct hlist_node *node;
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk map and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
 	for (i = 0; i < htab->buckets_num; i++) {
 		bucket = sock_hash_select_bucket(htab, i);
-		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
 			lock_sock(elem->sk);
@@ -875,7 +880,6 @@ static void sock_hash_free(struct bpf_ma
 			rcu_read_unlock();
 			release_sock(elem->sk);
 		}
-		raw_spin_unlock_bh(&bucket->lock);
 	}
 
 	/* wait for psock readers accessing its map link */


