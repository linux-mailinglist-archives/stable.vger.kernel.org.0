Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18DA12209D
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfLQA4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:56:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35090 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003M9-K9; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005b2-Gg; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>
Date:   Tue, 17 Dec 2019 00:47:14 +0000
Message-ID: <lsq.1576543535.863806012@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 100/136] net: fix sk_page_frag() recursion from
 memory reclaim
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 20eb4f29b60286e0d6dc01d9c260b4bd383c58fb upstream.

sk_page_frag() optimizes skb_frag allocations by using per-task
skb_frag cache when it knows it's the only user.  The condition is
determined by seeing whether the socket allocation mask allows
blocking - if the allocation may block, it obviously owns the task's
context and ergo exclusively owns current->task_frag.

Unfortunately, this misses recursion through memory reclaim path.
Please take a look at the following backtrace.

 [2] RIP: 0010:tcp_sendmsg_locked+0xccf/0xe10
     ...
     tcp_sendmsg+0x27/0x40
     sock_sendmsg+0x30/0x40
     sock_xmit.isra.24+0xa1/0x170 [nbd]
     nbd_send_cmd+0x1d2/0x690 [nbd]
     nbd_queue_rq+0x1b5/0x3b0 [nbd]
     __blk_mq_try_issue_directly+0x108/0x1b0
     blk_mq_request_issue_directly+0xbd/0xe0
     blk_mq_try_issue_list_directly+0x41/0xb0
     blk_mq_sched_insert_requests+0xa2/0xe0
     blk_mq_flush_plug_list+0x205/0x2a0
     blk_flush_plug_list+0xc3/0xf0
 [1] blk_finish_plug+0x21/0x2e
     _xfs_buf_ioapply+0x313/0x460
     __xfs_buf_submit+0x67/0x220
     xfs_buf_read_map+0x113/0x1a0
     xfs_trans_read_buf_map+0xbf/0x330
     xfs_btree_read_buf_block.constprop.42+0x95/0xd0
     xfs_btree_lookup_get_block+0x95/0x170
     xfs_btree_lookup+0xcc/0x470
     xfs_bmap_del_extent_real+0x254/0x9a0
     __xfs_bunmapi+0x45c/0xab0
     xfs_bunmapi+0x15/0x30
     xfs_itruncate_extents_flags+0xca/0x250
     xfs_free_eofblocks+0x181/0x1e0
     xfs_fs_destroy_inode+0xa8/0x1b0
     destroy_inode+0x38/0x70
     dispose_list+0x35/0x50
     prune_icache_sb+0x52/0x70
     super_cache_scan+0x120/0x1a0
     do_shrink_slab+0x120/0x290
     shrink_slab+0x216/0x2b0
     shrink_node+0x1b6/0x4a0
     do_try_to_free_pages+0xc6/0x370
     try_to_free_mem_cgroup_pages+0xe3/0x1e0
     try_charge+0x29e/0x790
     mem_cgroup_charge_skmem+0x6a/0x100
     __sk_mem_raise_allocated+0x18e/0x390
     __sk_mem_schedule+0x2a/0x40
 [0] tcp_sendmsg_locked+0x8eb/0xe10
     tcp_sendmsg+0x27/0x40
     sock_sendmsg+0x30/0x40
     ___sys_sendmsg+0x26d/0x2b0
     __sys_sendmsg+0x57/0xa0
     do_syscall_64+0x42/0x100
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

In [0], tcp_send_msg_locked() was using current->page_frag when it
called sk_wmem_schedule().  It already calculated how many bytes can
be fit into current->page_frag.  Due to memory pressure,
sk_wmem_schedule() called into memory reclaim path which called into
xfs and then IO issue path.  Because the filesystem in question is
backed by nbd, the control goes back into the tcp layer - back into
tcp_sendmsg_locked().

nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
sense - it's in the process of freeing memory and wants to be able to,
e.g., drop clean pages to make forward progress.  However, this
confused sk_page_frag() called from [2].  Because it only tests
whether the allocation allows blocking which it does, it now thinks
current->page_frag can be used again although it already was being
used in [0].

After [2] used current->page_frag, the offset would be increased by
the used amount.  When the control returns to [0],
current->page_frag's offset is increased and the previously calculated
number of bytes now may overrun the end of allocated memory leading to
silent memory corruptions.

Fix it by adding gfpflags_normal_context() which tests sleepable &&
!reclaim and use it to determine whether to use current->task_frag.

v2: Eric didn't like gfp flags being tested twice.  Introduce a new
    helper gfpflags_normal_context() and combine the two tests.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: Keep testing __GFP_WAIT flag instead of
 __GFP_DIRECT_RECLAIM.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -168,6 +168,28 @@ static inline int allocflags_to_migratet
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
 
+/**
+ * gfpflags_normal_context - is gfp_flags a normal sleepable context?
+ * @gfp_flags: gfp_flags to test
+ *
+ * Test whether @gfp_flags indicates that the allocation is from the
+ * %current context and allowed to sleep.
+ *
+ * An allocation being allowed to block doesn't mean it owns the %current
+ * context.  When direct reclaim path tries to allocate memory, the
+ * allocation context is nested inside whatever %current was doing at the
+ * time of the original allocation.  The nested allocation may be allowed
+ * to block but modifying anything %current owns can corrupt the outer
+ * context's expectations.
+ *
+ * %true result from this function indicates that the allocation context
+ * can sleep and use anything that's associated with %current.
+ */
+static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
+{
+	return (gfp_flags & (__GFP_WAIT | __GFP_MEMALLOC)) == __GFP_WAIT;
+}
+
 #ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2103,12 +2103,17 @@ struct sk_buff *sk_stream_alloc_skb(stru
  * sk_page_frag - return an appropriate page_frag
  * @sk: socket
  *
- * If socket allocation mode allows current thread to sleep, it means its
- * safe to use the per task page_frag instead of the per socket one.
+ * Use the per task page_frag instead of the per socket one for
+ * optimization when we know that we're in the normal context and owns
+ * everything that's associated with %current.
+ *
+ * Testing __GFP_WAIT isn't enough here as direct reclaim may nest
+ * inside other socket operations and end up recursing into sk_page_frag()
+ * while it's already in use.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (sk->sk_allocation & __GFP_WAIT)
+	if (gfpflags_normal_context(sk->sk_allocation))
 		return &current->task_frag;
 
 	return &sk->sk_frag;

