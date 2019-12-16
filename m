Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81F412155B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732183AbfLPSVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:21:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732206AbfLPSVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:21:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3472166E;
        Mon, 16 Dec 2019 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520468;
        bh=1r5YjeyGQ+rXDX+mIuVThFKde5JhDHGx5ysOG9BpUgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1W5dj+BW6lnehEN4YXVehrUloXvzgZrpWPeF+NxZG33SKCYAGQ8lFjVay57U4LY/
         UET9w78pR3Ih+sx7cBiXVP/6joF2M/MB9504e/hMz30g1oxzflxLReXpm/WIdzDjcr
         JF6b1MCwKvY8UufDQD2KVhsV1Uibg+wdOM+xBS54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 166/177] mm: memcg/slab: wait for !root kmem_cache refcnt killing on root kmem_cache destruction
Date:   Mon, 16 Dec 2019 18:50:22 +0100
Message-Id: <20191216174849.819168766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit a264df74df38855096393447f1b8f386069a94b9 upstream.

Christian reported a warning like the following obtained during running
some KVM-related tests on s390:

    WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
    Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
    CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
    Hardware name: IBM 2964 NC9 712 (LPAR)
    Workqueue: events sysfs_slab_remove_workfn
    Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
               R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
    Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
               0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
               0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
               0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
    Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
               0000001529746848: 47000700            bc         0,1792
              #000000152974684c: a7f40001            brc        15,152974684e
              >0000001529746850: a7f4fff2            brc        15,1529746834
               0000001529746854: 0707                bcr        0,%r7
               0000001529746856: 0707                bcr        0,%r7
               0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
               000000152974685e: a738ffff            lhi        %r3,-1
    Call Trace:
    ([<000003e009263d00>] 0x3e009263d00)
     [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
     [<0000001529b04882>] kobject_put+0xaa/0xe8
     [<000000152918cf28>] process_one_work+0x1e8/0x428
     [<000000152918d1b0>] worker_thread+0x48/0x460
     [<00000015291942c6>] kthread+0x126/0x160
     [<0000001529b22344>] ret_from_fork+0x28/0x30
     [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
    Last Breaking-Event-Address:
     [<000000152974684c>] percpu_ref_exit+0x4c/0x58
    ---[ end trace b035e7da5788eb09 ]---

The problem occurs because kmem_cache_destroy() is called immediately
after deleting of a memcg, so it races with the memcg kmem_cache
deactivation.

flush_memcg_workqueue() at the beginning of kmem_cache_destroy() is
supposed to guarantee that all deactivation processes are finished, but
failed to do so.  It waits for an rcu grace period, after which all
children kmem_caches should be deactivated.  During the deactivation
percpu_ref_kill() is called for non root kmem_cache refcounters, but it
requires yet another rcu grace period to finish the transition to the
atomic (dead) state.

So in a rare case when not all children kmem_caches are destroyed at the
moment when the root kmem_cache is about to be gone, we need to wait
another rcu grace period before destroying the root kmem_cache.

This issue can be triggered only with dynamically created kmem_caches
which are used with memcg accounting.  In this case per-memcg child
kmem_caches are created.  They are deactivated from the cgroup removing
path.  If the destruction of the root kmem_cache is racing with the
removal of the cgroup (both are quite complicated multi-stage
processes), the described issue can occur.  The only known way to
trigger it in the real life, is to unload some kernel module which
creates a dedicated kmem_cache, used from different memory cgroups with
GFP_ACCOUNT flag.  If the unloading happens immediately after calling
rmdir on the corresponding cgroup, there is some chance to trigger the
issue.

Link: http://lkml.kernel.org/r/20191129025011.3076017-1-guro@fb.com
Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -904,6 +904,18 @@ static void flush_memcg_workqueue(struct
 	 * previous workitems on workqueue are processed.
 	 */
 	flush_workqueue(memcg_kmem_cache_wq);
+
+	/*
+	 * If we're racing with children kmem_cache deactivation, it might
+	 * take another rcu grace period to complete their destruction.
+	 * At this moment the corresponding percpu_ref_kill() call should be
+	 * done, but it might take another rcu grace period to complete
+	 * switching to the atomic mode.
+	 * Please, note that we check without grabbing the slab_mutex. It's safe
+	 * because at this moment the children list can't grow.
+	 */
+	if (!list_empty(&s->memcg_params.children))
+		rcu_barrier();
 }
 #else
 static inline int shutdown_memcg_caches(struct kmem_cache *s)


