Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78816E67B9
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbfJ0VXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732392AbfJ0VXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:49 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64BF214E0;
        Sun, 27 Oct 2019 21:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211428;
        bh=uj/nMk69kdoKs9zEnM+inUkUZGttcH1k8me6Ogxz2RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kti/SFb3U7WAW/aQeu9pRgqA32mUvJtqnYnOK8neTBHc2I+BVSCjMMfUh1nFv3RmD
         hZvSIUvWnikfzMOPB88yeP/wHmkuNC1Eqp2sBW0ZOspZdcviupIXOv6n0tZUoRZwJc
         YgoaDiUb2NE4RTWhY8WOdEmD3QPKxawW9aBLrHRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 149/197] mm: memcg/slab: fix panic in __free_slab() caused by premature memcg pointer release
Date:   Sun, 27 Oct 2019 22:01:07 +0100
Message-Id: <20191027203359.737613185@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit b749ecfaf6c53ce79d6ab66afd2fc34189a073b1 upstream.

Karsten reported the following panic in __free_slab() happening on a s390x
machine:

  Unable to handle kernel pointer dereference in virtual kernel address space
  Failing address: 0000000000000000 TEID: 0000000000000483
  Fault in home space mode while using kernel ASCE.
  AS:00000000017d4007 R3:000000007fbd0007 S:000000007fbff000 P:000000000000003d
  Oops: 0004 ilc:3 Ý#1¨ PREEMPT SMP
  Modules linked in: tcp_diag inet_diag xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_at nf_nat
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-05872-g6133e3e4bada-dirty #14
  Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
  Krnl PSW : 0704d00180000000 00000000003cadb6 (__free_slab+0x686/0x6b0)
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
  Krnl GPRS: 00000000f3a32928 0000000000000000 000000007fbf5d00 000000000117c4b8
             0000000000000000 000000009e3291c1 0000000000000000 0000000000000000
             0000000000000003 0000000000000008 000000002b478b00 000003d080a97600
             0000000000000003 0000000000000008 000000002b478b00 000003d080a97600
             000000000117ba00 000003e000057db0 00000000003cabcc 000003e000057c78
  Krnl Code: 00000000003cada6: e310a1400004        lg      %r1,320(%r10)
             00000000003cadac: c0e50046c286        brasl   %r14,ca32b8
            #00000000003cadb2: a7f4fe36            brc     15,3caa1e
            >00000000003cadb6: e32060800024        stg     %r2,128(%r6)
             00000000003cadbc: a7f4fd9e            brc     15,3ca8f8
             00000000003cadc0: c0e50046790c        brasl   %r14,c99fd8
             00000000003cadc6: a7f4fe2c            brc     15,3caa
             00000000003cadc6: a7f4fe2c            brc     15,3caa1e
             00000000003cadca: ecb1ffff00d9        aghik   %r11,%r1,-1
  Call Trace:
  (<00000000003cabcc> __free_slab+0x49c/0x6b0)
   <00000000001f5886> rcu_core+0x5a6/0x7e0
   <0000000000ca2dea> __do_softirq+0xf2/0x5c0
   <0000000000152644> irq_exit+0x104/0x130
   <000000000010d222> do_IRQ+0x9a/0xf0
   <0000000000ca2344> ext_int_handler+0x130/0x134
   <0000000000103648> enabled_wait+0x58/0x128
  (<0000000000103634> enabled_wait+0x44/0x128)
   <0000000000103b00> arch_cpu_idle+0x40/0x58
   <0000000000ca0544> default_idle_call+0x3c/0x68
   <000000000018eaa4> do_idle+0xec/0x1c0
   <000000000018ee0e> cpu_startup_entry+0x36/0x40
   <000000000122df34> arch_call_rest_init+0x5c/0x88
   <0000000000000000> 0x0
  INFO: lockdep is turned off.
  Last Breaking-Event-Address:
   <00000000003ca8f4> __free_slab+0x1c4/0x6b0
  Kernel panic - not syncing: Fatal exception in interrupt

The kernel panics on an attempt to dereference the NULL memcg pointer.
When shutdown_cache() is called from the kmem_cache_destroy() context, a
memcg kmem_cache might have empty slab pages in a partial list, which are
still charged to the memory cgroup.

These pages are released by free_partial() at the beginning of
shutdown_cache(): either directly or by scheduling a RCU-delayed work
(if the kmem_cache has the SLAB_TYPESAFE_BY_RCU flag).  The latter case
is when the reported panic can happen: memcg_unlink_cache() is called
immediately after shrinking partial lists, without waiting for scheduled
RCU works.  It sets the kmem_cache->memcg_params.memcg pointer to NULL,
and the following attempt to dereference it by __free_slab() from the
RCU work context causes the panic.

To fix the issue, let's postpone the release of the memcg pointer to
destroy_memcg_params().  It's called from a separate work context by
slab_caches_to_rcu_destroy_workfn(), which contains a full RCU barrier.
This guarantees that all scheduled page release RCU works will complete
before the memcg pointer will be zeroed.

Big thanks for Karsten for the perfect report containing all necessary
information, his help with the analysis of the problem and testing of the
fix.

Link: http://lkml.kernel.org/r/20191010160549.1584316-1-guro@fb.com
Fixes: fb2f2b0adb98 ("mm: memcg/slab: reparent memcg kmem_caches on cgroup removal")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Karsten Graul <kgraul@linux.ibm.com>
Tested-by: Karsten Graul <kgraul@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -178,10 +178,13 @@ static int init_memcg_params(struct kmem
 
 static void destroy_memcg_params(struct kmem_cache *s)
 {
-	if (is_root_cache(s))
+	if (is_root_cache(s)) {
 		kvfree(rcu_access_pointer(s->memcg_params.memcg_caches));
-	else
+	} else {
+		mem_cgroup_put(s->memcg_params.memcg);
+		WRITE_ONCE(s->memcg_params.memcg, NULL);
 		percpu_ref_exit(&s->memcg_params.refcnt);
+	}
 }
 
 static void free_memcg_params(struct rcu_head *rcu)
@@ -253,8 +256,6 @@ static void memcg_unlink_cache(struct km
 	} else {
 		list_del(&s->memcg_params.children_node);
 		list_del(&s->memcg_params.kmem_caches_node);
-		mem_cgroup_put(s->memcg_params.memcg);
-		WRITE_ONCE(s->memcg_params.memcg, NULL);
 	}
 }
 #else


