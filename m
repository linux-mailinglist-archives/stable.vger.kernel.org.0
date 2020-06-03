Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662B71ED8D1
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 00:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgFCW73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 18:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 18:59:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394BA208C9;
        Wed,  3 Jun 2020 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591225168;
        bh=Eo0iVHwymPjpBKKY2eWD6HyHUS0Y9lbGKl/QcxieEA8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SX2BQDJKzU7emeG03seDZtocklzQ1rHPhphkSG10NTtk4h71in4G0qcor3HTHwTxA
         Ad4Cd0BoI9J6K+S9UO95HbKKfI6g3+P3Rv1Rby7GIn0QYKNm9AHk1nrodmuv9eGHYW
         JHMGDgtNDDr6V3p4F4eBHR3E7Bm1mEvfJucOuVDg=
Date:   Wed, 03 Jun 2020 15:59:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        daniel.m.jordan@oracle.com, david@redhat.com, jmorris@namei.org,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, sashal@kernel.org,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, yiwei@redhat.com
Subject:  [patch 051/131] mm: call cond_resched() from
 deferred_init_memmap()
Message-ID: <20200603225927.oWsDfB6-g%akpm@linux-foundation.org>
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm: call cond_resched() from deferred_init_memmap()

Now that deferred pages are initialized with interrupts enabled we can
replace touch_nmi_watchdog() with cond_resched(), as it was before
3a2d7fa8a3d5.

For now, we cannot do the same in deferred_grow_zone() as it is still
initializes pages with interrupts disabled.

This change fixes RCU problem described in
https://lkml.kernel.org/r/20200401104156.11564-2-david@redhat.com

[   60.474005] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   60.475000] rcu:  1-...0: (0 ticks this GP) idle=02a/1/0x4000000000000000 softirq=1/1 fqs=15000
[   60.475000] rcu:  (detected by 0, t=60002 jiffies, g=-1199, q=1)
[   60.475000] Sending NMI from CPU 0 to CPUs 1:
[    1.760091] NMI backtrace for cpu 1
[    1.760091] CPU: 1 PID: 20 Comm: pgdatinit0 Not tainted 4.18.0-147.9.1.el8_1.x86_64 #1
[    1.760091] Hardware name: Red Hat KVM, BIOS 1.13.0-1.module+el8.2.0+5520+4e5817f3 04/01/2014
[    1.760091] RIP: 0010:__init_single_page.isra.65+0x10/0x4f
[    1.760091] Code: 48 83 cf 63 48 89 f8 0f 1f 40 00 48 89 c6 48 89 d7 e8 6b 18 80 ff 66 90 5b c3 31 c0 b9 10 00 00 00 49 89 f8 48 c1 e6 33 f3 ab <b8> 07 00 00 00 48 c1 e2 36 41 c7 40 34 01 00 00 00 48 c1 e0 33 41
[    1.760091] RSP: 0000:ffffba783123be40 EFLAGS: 00000006
[    1.760091] RAX: 0000000000000000 RBX: fffffad34405e300 RCX: 0000000000000000
[    1.760091] RDX: 0000000000000000 RSI: 0010000000000000 RDI: fffffad34405e340
[    1.760091] RBP: 0000000033f3177e R08: fffffad34405e300 R09: 0000000000000002
[    1.760091] R10: 000000000000002b R11: ffff98afb691a500 R12: 0000000000000002
[    1.760091] R13: 0000000000000000 R14: 000000003f03ea00 R15: 000000003e10178c
[    1.760091] FS:  0000000000000000(0000) GS:ffff9c9ebeb00000(0000) knlGS:0000000000000000
[    1.760091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.760091] CR2: 00000000ffffffff CR3: 000000a1cf20a001 CR4: 00000000003606e0
[    1.760091] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.760091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.760091] Call Trace:
[    1.760091]  deferred_init_pages+0x8f/0xbf
[    1.760091]  deferred_init_memmap+0x184/0x29d
[    1.760091]  ? deferred_free_pages.isra.97+0xba/0xba
[    1.760091]  kthread+0x112/0x130
[    1.760091]  ? kthread_flush_work_fn+0x10/0x10
[    1.760091]  ret_from_fork+0x35/0x40
[   89.123011] node 0 initialised, 1055935372 pages in 88650ms

Link: http://lkml.kernel.org/r/20200403140952.17177-4-pasha.tatashin@soleen.com
Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Yiqian Wei <yiwei@redhat.com>
Tested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-call-cond_resched-from-deferred_init_memmap
+++ a/mm/page_alloc.c
@@ -1870,7 +1870,7 @@ static int __init deferred_init_memmap(v
 	 */
 	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		touch_nmi_watchdog();
+		cond_resched();
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
_
