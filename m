Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1231FD7BF
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 23:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgFQVmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 17:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgFQVmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 17:42:52 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42BFF20897;
        Wed, 17 Jun 2020 21:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592430171;
        bh=AvojujWEJTmvje6FdWwJxojDYXA2LWMqHtw11UGkOlo=;
        h=Date:From:To:Subject:From;
        b=eHXPSlo7O80t1Ep711oxwyyENIpgWJUX1ZhIRVbKZfVHgwECACLaZ4uiC4+8w9VGy
         qJUgfZOm3ZZ1so9HbsPIcek5DV+OwYtM0a+okG8OUmlj4eYRHRPZXz+saw1FnrGXrn
         dgv6tXqpg26oX2PJJtRn/wCFDTh8Y08KfbZzg1HQ=
Date:   Wed, 17 Jun 2020 14:42:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mgorman@techsingularity.net, liwang@redhat.com, hughd@google.com,
        alex.shi@linux.alibaba.com, vbabka@suse.cz
Subject:  +
 mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch added
 to -mm tree
Message-ID: <20200617214250.mJmvC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: make capture control handling safe wrt interrupts
has been added to the -mm tree.  Its filename is
     mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: make capture control handling safe wrt interrupts

Hugh reports:

: While stressing compaction, one run oopsed on NULL capc->cc in
: __free_one_page()'s task_capc(zone): compact_zone_order() had been
: interrupted, and a page was being freed in the return from interrupt.
: 
: Though you would not expect it from the source, both gccs I was using (a
: 4.8.1 and a 7.5.0) had chosen to compile compact_zone_order() with the
: ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before callq
: compact_zone - long after the "current->capture_control = &capc".  An
: interrupt in between those finds capc->cc NULL (zeroed by an earlier rep
: stos).
: 
: This could presumably be fixed by a barrier() before setting
: current->capture_control in compact_zone_order(); but would also need more
: care on return from compact_zone(), in order not to risk leaking a page
: captured by interrupt just before capture_control is reset.
: 
: Maybe that is the preferable fix, but I felt safer for task_capc() to
: exclude the rather surprising possibility of capture at interrupt time.

I have checked that gcc10 also behaves the same.

The advantage of fix in compact_zone_order() is that we don't add another
test in the page freeing hot path, and that it might prevent future
problems if we stop exposing pointers to unitialized structures in current
task.

So this patch implements the suggestion for compact_zone_order() with
barrier() (and WRITE_ONCE() to prevent store tearing) for setting
current->capture_control, and prevents page leaking with
WRITE_ONCE/READ_ONCE in the proper order.

Link: http://lkml.kernel.org/r/20200616082649.27173-1-vbabka@suse.cz
Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-make-capture-control-handling-safe-wrt-interrupts
+++ a/mm/compaction.c
@@ -2316,15 +2316,26 @@ static enum compact_result compact_zone_
 		.page = NULL,
 	};
 
-	current->capture_control = &capc;
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
 
 	ret = compact_zone(&cc, &capc);
 
 	VM_BUG_ON(!list_empty(&cc.freepages));
 	VM_BUG_ON(!list_empty(&cc.migratepages));
 
-	*capture = capc.page;
-	current->capture_control = NULL;
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	*capture = READ_ONCE(capc.page);
 
 	return ret;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch
mm-page_alloc-use-unlikely-in-task_capc.patch
mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch

