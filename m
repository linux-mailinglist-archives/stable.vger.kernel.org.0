Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C200E1CA020
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEHBft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEHBfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 21:35:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0E6208E4;
        Fri,  8 May 2020 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588901747;
        bh=p66t++QEcmXGWyvKZsR/6dx7XY7ecH/xwXoI7luDbYo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jkGXfNUs6QL0Wwc7prBk5L1BxOvCtHoT86Un4Li1crmdr6UsqU+3oROBDqQlwJjM7
         QaOJ0NuSkmUlabvQK70dfy37qnpcgEKz7WXZSGHrF2Nx3vFQriyLyzr3W0cooJK/20
         X8+IvsS4onPm5UBpCki0BJM12nrjOcPwM4Wcu42U=
Date:   Thu, 07 May 2020 18:35:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        bhe@redhat.com, daniel.m.jordan@oracle.com, david@redhat.com,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/15] mm/page_alloc: fix watchdog soft lockups
 during set_zone_contiguous()
Message-ID: <20200508013546.5KqzoUC9B%akpm@linux-foundation.org>
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Without CONFIG_PREEMPT, it can happen that we get soft lockups detected,
e.g., while booting up.

[  105.608900] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
[  105.608933] Modules linked in:
[  105.608933] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-next-20200331+ #4
[  105.608933] Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
[  105.608933] RIP: 0010:__pageblock_pfn_to_page+0x134/0x1c0
[  105.608933] Code: 85 c0 74 71 4a 8b 04 d0 48 85 c0 74 68 48 01 c1 74 63 f6 01 04 74 5e 48 c1 e7 06 4c 8b 05 cc 991
[  105.608933] RSP: 0000:ffffb6d94000fe60 EFLAGS: 00010286 ORIG_RAX: ffffffffffffff13
[  105.608933] RAX: fffff81953250000 RBX: 000000000a4c9600 RCX: ffff8fe9ff7c1990
[  105.608933] RDX: ffff8fe9ff7dab80 RSI: 000000000a4c95ff RDI: 0000000293250000
[  105.608933] RBP: ffff8fe9ff7dab80 R08: fffff816c0000000 R09: 0000000000000008
[  105.608933] R10: 0000000000000014 R11: 0000000000000014 R12: 0000000000000000
[  105.608933] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  105.608933] FS:  0000000000000000(0000) GS:ffff8fe1ff400000(0000) knlGS:0000000000000000
[  105.608933] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  105.608933] CR2: 000000000f613000 CR3: 00000088cf20a000 CR4: 00000000000006f0
[  105.608933] Call Trace:
[  105.608933]  set_zone_contiguous+0x56/0x70
[  105.608933]  page_alloc_init_late+0x166/0x176
[  105.608933]  kernel_init_freeable+0xfa/0x255
[  105.608933]  ? rest_init+0xaa/0xaa
[  105.608933]  kernel_init+0xa/0x106
[  105.608933]  ret_from_fork+0x35/0x40

The issue becomes visible when having a lot of memory (e.g., 4TB) assigned
to a single NUMA node - a system that can easily be created using QEMU. 
Inside VMs on a hypervisor with quite some memory overcommit, this is
fairly easy to trigger.

Link: http://lkml.kernel.org/r/20200416073417.5003-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-watchdog-soft-lockups-during-set_zone_contiguous
+++ a/mm/page_alloc.c
@@ -1607,6 +1607,7 @@ void set_zone_contiguous(struct zone *zo
 		if (!__pageblock_pfn_to_page(block_start_pfn,
 					     block_end_pfn, zone))
 			return;
+		cond_resched();
 	}
 
 	/* We confirm that there is no hole */
_
