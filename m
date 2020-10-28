Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040DE29D535
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgJ1V7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbgJ1V57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 17:57:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E7224724;
        Wed, 28 Oct 2020 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922279;
        bh=qCq38WYmSwWnWFPkzuuVGybemJXQIWZGNzOjtEz5PJw=;
        h=Date:From:To:Subject:From;
        b=coJA5Xtw90DrvMxdqiHpAlx52FXCObNdsyHpy0/3AeQqS81w52h7poHMhhjLuCaXC
         laRfxn0A+TQeRmI2GdG4v5oxYFAGQtG+tQiqwlrWY/5jZd3ea1mm+fZpN4f1mLch1D
         leYGPPYApmVFpHER/1PBWEwyAFzSpdveDylDAshw=
Date:   Wed, 28 Oct 2020 14:57:57 -0700
From:   akpm@linux-foundation.org
To:     cheloha@linux.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        ldufour@linux.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com, penberg@kernel.org,
        richard.weiyang@gmail.com, rientjes@google.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-slub-fix-panic-in-slab_alloc_node.patch added to -mm
 tree
Message-ID: <20201028215757.p9jgp6Cxa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/slub: fix panic in slab_alloc_node()
has been added to the -mm tree.  Its filename is
     mm-slub-fix-panic-in-slab_alloc_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-panic-in-slab_alloc_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-panic-in-slab_alloc_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm/slub: fix panic in slab_alloc_node()

While doing memory hot-unplug operation on a PowerPC VM running 1024 CPUs
with 11TB of ram, I hit the following panic:

BUG: Kernel NULL pointer dereference on read at 0x00000007
Faulting instruction address: 0xc000000000456048
Oops: Kernel access of bad area, sig: 11 [#2]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp
CPU: 160 PID: 1 Comm: systemd Tainted: G      D           5.9.0 #1
NIP:  c000000000456048 LR: c000000000455fd4 CTR: c00000000047b350
REGS: c00006028d1b77a0 TRAP: 0300   Tainted: G      D            (5.9.0)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24004228  XER: 00000000
CFAR: c00000000000f1b0 DAR: 0000000000000007 DSISR: 40000000 IRQMASK: 0
GPR00: c000000000455fd4 c00006028d1b7a30 c000000001bec800 0000000000000000
GPR04: 0000000000000dc0 0000000000000000 00000000000374ef c00007c53df99320
GPR08: 000007c53c980000 0000000000000000 000007c53c980000 0000000000000000
GPR12: 0000000000004400 c00000001e8e4400 0000000000000000 0000000000000f6a
GPR16: 0000000000000000 c000000001c25930 c000000001d62528 00000000000000c1
GPR20: c000000001d62538 c00006be469e9000 0000000fffffffe0 c0000000003c0ff8
GPR24: 0000000000000018 0000000000000000 0000000000000dc0 0000000000000000
GPR28: c00007c513755700 c000000001c236a4 c00007bc4001f800 0000000000000001
NIP [c000000000456048] __kmalloc_node+0x108/0x790
LR [c000000000455fd4] __kmalloc_node+0x94/0x790
Call Trace:
[c00006028d1b7a30] [c00007c51af92000] 0xc00007c51af92000 (unreliable)
[c00006028d1b7aa0] [c0000000003c0ff8] kvmalloc_node+0x58/0x110
[c00006028d1b7ae0] [c00000000047b45c] mem_cgroup_css_online+0x10c/0x270
[c00006028d1b7b30] [c000000000241fd8] online_css+0x48/0xd0
[c00006028d1b7b60] [c00000000024af14] cgroup_apply_control_enable+0x2c4/0x470
[c00006028d1b7c40] [c00000000024e838] cgroup_mkdir+0x408/0x5f0
[c00006028d1b7cb0] [c0000000005a4ef0] kernfs_iop_mkdir+0x90/0x100
[c00006028d1b7cf0] [c0000000004b8168] vfs_mkdir+0x138/0x250
[c00006028d1b7d40] [c0000000004baf04] do_mkdirat+0x154/0x1c0
[c00006028d1b7dc0] [c000000000032b38] system_call_exception+0xf8/0x200
[c00006028d1b7e20] [c00000000000c740] system_call_common+0xf0/0x27c
Instruction dump:
e93e0000 e90d0030 39290008 7cc9402a e94d0030 e93e0000 7ce95214 7f89502a
2fbc0000 419e0018 41920230 e9270010 <89290007> 7f994800 419e0220 7ee6bb78

This pointing to the following code:

mm/slub.c:2851
        if (unlikely(!object || !node_match(page, node))) {
c000000000456038:       00 00 bc 2f     cmpdi   cr7,r28,0
c00000000045603c:       18 00 9e 41     beq     cr7,c000000000456054 <__kmalloc_node+0x114>
node_match():
mm/slub.c:2491
        if (node != NUMA_NO_NODE && page_to_nid(page) != node)
c000000000456040:       30 02 92 41     beq     cr4,c000000000456270 <__kmalloc_node+0x330>
page_to_nid():
include/linux/mm.h:1294
c000000000456044:       10 00 27 e9     ld      r9,16(r7)
c000000000456048:       07 00 29 89     lbz     r9,7(r9)	<<<< r9 = NULL
node_match():
mm/slub.c:2491
c00000000045604c:       00 48 99 7f     cmpw    cr7,r25,r9
c000000000456050:       20 02 9e 41     beq     cr7,c000000000456270 <__kmalloc_node+0x330>

The panic occurred in slab_alloc_node() when checking for the page's node:
	object = c->freelist;
	page = c->page;
	if (unlikely(!object || !node_match(page, node))) {
		object = __slab_alloc(s, gfpflags, node, addr, c);
		stat(s, ALLOC_SLOWPATH);

The issue is that object is not NULL while page is NULL which is odd but
may happen if the cache flush happened after loading object but before
loading page.  Thus checking for the page pointer is required too.

The cache flush is done through an inter processor interrupt when a piece
of memory is off-lined.  That interrupt is triggered when a memory
hot-unplug operation is initiated and offline_pages() is calling the
slub's MEM_GOING_OFFLINE callback slab_mem_going_offline_callback() which
is calling flush_cpu_slab().  If that interrupt is caught between the
reading of c->freelist and the reading of c->page, this could lead to such
a situation.  That situation is expected and the later call to
this_cpu_cmpxchg_double() will detect the change to c->freelist and redo
the whole operation.

In commit 6159d0f5c03e ("mm/slub.c: page is always non-NULL in
node_match()") check on the page pointer has been removed assuming that
page is always valid when it is called.  It happens that this is not true
in that particular case, so check for page before calling node_match()
here.

Link: https://lkml.kernel.org/r/20201027190406.33283-1-ldufour@linux.ibm.com
Fixes: 6159d0f5c03e ("mm/slub.c: page is always non-NULL in node_match()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-panic-in-slab_alloc_node
+++ a/mm/slub.c
@@ -2852,7 +2852,7 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node))) {
+	if (unlikely(!object || !page || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are

mm-slub-fix-panic-in-slab_alloc_node.patch

