Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF425D493A
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfJKUMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 16:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbfJKUMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 16:12:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFD0E20673;
        Fri, 11 Oct 2019 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570824725;
        bh=I/jW8mj+7LWCdUQ3mdyXaS3oBAXXzP5bphPsz/77eE0=;
        h=Date:From:To:Subject:From;
        b=rGhaxmfMQpHmOf/4aQ1KiQ5PyZ4JJjd5cT7znF0T3OZ9QL+K9dmMmh6m8Em0baDZ+
         cxlUPujuCe8k0CFvxCvsiw7SGrhi3N45oCf7XJdMfO4PQYfQELjq7LvWIb8jfpBivx
         lTFD4OgsfVE0PVrpIeTUYtQaCR4trzGSZ3ubFcpg=
Date:   Fri, 11 Oct 2019 13:12:04 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, kgraul@linux.ibm.com, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, stable@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-memcg-slab-fix-panic-in-=5F=5Ffree=5Fslab-caused-by-prema?=
 =?US-ASCII?Q?ture-memcg-pointer-release.patch?= added to -mm tree
Message-ID: <20191011201204.Br0usHWuz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix panic in __free_slab() caused by prematur=
e memcg pointer release
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-panic-in-__free_slab-caused-by-premature-memcg-point=
er-release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-panic-in-__f=
ree_slab-caused-by-premature-memcg-pointer-release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-panic-in-__f=
ree_slab-caused-by-premature-memcg-pointer-release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: fix panic in __free_slab() caused by premature mem=
cg pointer release

Karsten reported the following panic in __free_slab() happening on a s390x
machine:

349.361168=C2=A8 Unable to handle kernel pointer dereference in virtual ker=
nel address space
349.361210=C2=A8 Failing address: 0000000000000000 TEID: 0000000000000483
349.361223=C2=A8 Fault in home space mode while using kernel ASCE.
349.361240=C2=A8 AS:00000000017d4007 R3:000000007fbd0007 S:000000007fbff000=
 P:000000000000003d
349.361340=C2=A8 Oops: 0004 ilc:3 =C3=9D#1=C2=A8 PREEMPT SMP
349.361349=C2=A8 Modules linked in: tcp_diag inet_diag xt_tcpudp ip6t_rpfil=
ter ip6t_REJECT \
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat ip6table=
_mangle \
ip6table_raw ip6table_security iptable_at nf_nat
349.361436=C2=A8 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-05872-g613=
3e3e4bada-dirty #14
349.361445=C2=A8 Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
349.361450=C2=A8 Krnl PSW : 0704d00180000000 00000000003cadb6 (__free_slab+=
0x686/0x6b0)
349.361464=C2=A8            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 P=
M:0 RI:0 EA:3
349.361470=C2=A8 Krnl GPRS: 00000000f3a32928 0000000000000000 000000007fbf5=
d00 000000000117c4b8
349.361475=C2=A8            0000000000000000 000000009e3291c1 0000000000000=
000 0000000000000000
349.361481=C2=A8            0000000000000003 0000000000000008 000000002b478=
b00 000003d080a97600
349.361481=C2=A8            0000000000000003 0000000000000008 000000002b478=
b00 000003d080a97600
349.361486=C2=A8            000000000117ba00 000003e000057db0 00000000003ca=
bcc 000003e000057c78
349.361500=C2=A8 Krnl Code: 00000000003cada6: e310a1400004        lg      %=
r1,320(%r10)
349.361500=C2=A8            00000000003cadac: c0e50046c286        brasl   %=
r14,ca32b8
349.361500=C2=A8           #00000000003cadb2: a7f4fe36            brc     1=
5,3caa1e
349.361500=C2=A8           >00000000003cadb6: e32060800024        stg     %=
r2,128(%r6)
349.361500=C2=A8            00000000003cadbc: a7f4fd9e            brc     1=
5,3ca8f8
349.361500=C2=A8            00000000003cadc0: c0e50046790c        brasl   %=
r14,c99fd8
349.361500=C2=A8            00000000003cadc6: a7f4fe2c            brc     1=
5,3caa
349.361500=C2=A8            00000000003cadc6: a7f4fe2c            brc     1=
5,3caa1e
349.361500=C2=A8            00000000003cadca: ecb1ffff00d9        aghik   %=
r11,%r1,-1
349.361619=C2=A8 Call Trace:
349.361627=C2=A8 (=C3=9D<00000000003cabcc>=C2=A8 __free_slab+0x49c/0x6b0)
349.361634=C2=A8  =C3=9D<00000000001f5886>=C2=A8 rcu_core+0x5a6/0x7e0
349.361643=C2=A8  =C3=9D<0000000000ca2dea>=C2=A8 __do_softirq+0xf2/0x5c0
349.361652=C2=A8  =C3=9D<0000000000152644>=C2=A8 irq_exit+0x104/0x130
349.361659=C2=A8  =C3=9D<000000000010d222>=C2=A8 do_IRQ+0x9a/0xf0
349.361667=C2=A8  =C3=9D<0000000000ca2344>=C2=A8 ext_int_handler+0x130/0x134
349.361674=C2=A8  =C3=9D<0000000000103648>=C2=A8 enabled_wait+0x58/0x128
349.361681=C2=A8 (=C3=9D<0000000000103634>=C2=A8 enabled_wait+0x44/0x128)
349.361688=C2=A8  =C3=9D<0000000000103b00>=C2=A8 arch_cpu_idle+0x40/0x58
349.361695=C2=A8  =C3=9D<0000000000ca0544>=C2=A8 default_idle_call+0x3c/0x68
349.361704=C2=A8  =C3=9D<000000000018eaa4>=C2=A8 do_idle+0xec/0x1c0
349.361748=C2=A8  =C3=9D<000000000018ee0e>=C2=A8 cpu_startup_entry+0x36/0x40
349.361756=C2=A8  =C3=9D<000000000122df34>=C2=A8 arch_call_rest_init+0x5c/0=
x88
349.361761=C2=A8  =C3=9D<0000000000000000>=C2=A8 0x0
349.361765=C2=A8 INFO: lockdep is turned off.
349.361769=C2=A8 Last Breaking-Event-Address:
349.361774=C2=A8  =C3=9D<00000000003ca8f4>=C2=A8 __free_slab+0x1c4/0x6b0
349.361781=C2=A8 Kernel panic - not syncing: Fatal exception in interrupt

The kernel panics on an attempt to dereference the NULL memcg pointer.
When shutdown_cache() is called from the kmem_cache_destroy() context, a
memcg kmem_cache might have empty slab pages in a partial list, which are
still charged to the memory cgroup.  These pages are released by
free_partial() at the beginning of shutdown_cache(): either directly or by
scheduling a RCU-delayed work (if the kmem_cache has the
SLAB_TYPESAFE_BY_RCU flag).  The latter case is when the reported panic
can happen: memcg_unlink_cache() is called immediately after shrinking
partial lists, without waiting for scheduled RCU works.  It sets the
kmem_cache->memcg_params.memcg pointer to NULL, and the following attempt
to dereference it by __free_slab() from the RCU work context causes the
panic.

To fix the issue, let's postpone the release of the memcg pointer to
destroy_memcg_params().  It's called from a separate work context by
slab_caches_to_rcu_destroy_workfn(), which contains a full RCU barrier.=20
This guarantees that all scheduled page release RCU works will complete
before the memcg pointer will be zeroed.

Big thanks for Karsten for the perfect report containing all necessary
information, his help with the analysis of the problem and testing of the
fix.

Link: http://lkml.kernel.org/r/20191010160549.1584316-1-guro@fb.com
Fixes: fb2f2b0adb98 ("mm: memcg/slab: reparent memcg kmem_caches on cgroup =
removal")
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
---

 mm/slab_common.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/slab_common.c~mm-memcg-slab-fix-panic-in-__free_slab-caused-by-pre=
mature-memcg-pointer-release
+++ a/mm/slab_common.c
@@ -178,10 +178,13 @@ static int init_memcg_params(struct kmem
=20
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
=20
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
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-panic-in-__free_slab-caused-by-premature-memcg-pointer-re=
lease.patch

