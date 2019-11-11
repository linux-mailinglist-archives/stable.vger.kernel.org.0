Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2772F7E95
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfKKSk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfKKSk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:40:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6517621655;
        Mon, 11 Nov 2019 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497656;
        bh=zTepxkX2P1xCUjXtiV1k2pw07QNHafJI06Bug3nuHbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0PSfnBCzRBmXbKrO2TNtZRrZnhH8QnV0BeQgnei7N3joo3r9I/4MTbB+u0EvWzH4
         5+LP7ad/V83ker9WNPo8kpkKNLY6U4i5ccRKbkRW7LDVQI4/fnoek73g2Z4Vzvi/pM
         TpAd7+DncoubRVQ0HZ9BBMcbtHUfU2IOKWGWS2zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 019/125] mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges
Date:   Mon, 11 Nov 2019 19:27:38 +0100
Message-Id: <20191111181442.518063788@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 869712fd3de5a90b7ba23ae1272278cddc66b37b upstream.

While upgrading from 4.16 to 5.2, we noticed these allocation errors in
the log of the new kernel:

  SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
    cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
    node 0: slabs: 5, objs: 170, free: 0

        slab_out_of_memory+1
        ___slab_alloc+969
        __slab_alloc+14
        kmem_cache_alloc+346
        inet_twsk_alloc+60
        tcp_time_wait+46
        tcp_fin+206
        tcp_data_queue+2034
        tcp_rcv_state_process+784
        tcp_v6_do_rcv+405
        __release_sock+118
        tcp_close+385
        inet_release+46
        __sock_release+55
        sock_close+17
        __fput+170
        task_work_run+127
        exit_to_usermode_loop+191
        do_syscall_64+212
        entry_SYSCALL_64_after_hwframe+68

accompanied by an increase in machines going completely radio silent
under memory pressure.

One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account
sock objects to kmemcg"), which made these slab caches subject to cgroup
memory accounting and control.

The problem with that is that cgroups, unlike the page allocator, do not
maintain dedicated atomic reserves.  As a cgroup's usage hovers at its
limit, atomic allocations - such as done during network rx - can fail
consistently for extended periods of time.  The kernel is not able to
operate under these conditions.

We don't want to revert the culprit patch, because it indeed tracks a
potentially substantial amount of memory used by a cgroup.

We also don't want to implement dedicated atomic reserves for cgroups.
There is no point in keeping a fixed margin of unused bytes in the
cgroup's memory budget to accomodate a consumer that is impossible to
predict - we'd be wasting memory and get into configuration headaches,
not unlike what we have going with min_free_kbytes.  We do this for
physical mem because we have to, but cgroups are an accounting game.

Instead, account these privileged allocations to the cgroup, but let
them bypass the configured limit if they have to.  This way, we get the
benefits of accounting the consumed memory and have it exert pressure on
the rest of the cgroup, but like with the page allocator, we shift the
burden of reclaimining on behalf of atomic allocations onto the regular
allocations that can block.

Link: http://lkml.kernel.org/r/20191022233708.365764-1-hannes@cmpxchg.org
Fixes: e699e2c6a654 ("net, mm: account sock objects to kmemcg")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2225,6 +2225,15 @@ retry:
 	}
 
 	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (gfp_mask & __GFP_ATOMIC)
+		goto force;
+
+	/*
 	 * Unlike in global OOM situations, memcg is not in a physical
 	 * memory shortage.  Allow dying and OOM-killed tasks to
 	 * bypass the last charges so that they can exit quickly and


