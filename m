Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CC9228A26
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 22:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGUUta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 16:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUUt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 16:49:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B8E20717;
        Tue, 21 Jul 2020 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595364568;
        bh=sFDPbRrZ8r+/PiGLHBuN4i4zwMJ8TfW2SYocOT0d+RE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2PqVVB+xfBifSjLmKdKcj2mAwvJ+ZifdX6HPKjgwSUQjU1rkxBsTNRZa9wdaRhIB/
         HB9RYO4Y6yUO5uPjKyDGVBAh2BhBtGN8zfaI6PVfU/z9evfilJg4DUN7PPbMKfe8eA
         cUKuUBdA1bMJcAl1dl+Jlmm1JRx24UzUe39N780Q=
Date:   Tue, 21 Jul 2020 13:49:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cai@lca.pw, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        peterz@infradead.org, stable@vger.kernel.org
Subject:  + fork-silence-a-false-postive-warning-in-__mmdrop.patch
 added to -mm tree
Message-ID: <20200721204928.ScSj1rpgM%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fork: silence a false postive warning in __mmdrop
has been added to the -mm tree.  Its filename is
     fork-silence-a-false-postive-warning-in-__mmdrop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-silence-a-false-postive-warning-in-__mmdrop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-silence-a-false-postive-warning-in-__mmdrop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: fork: silence a false postive warning in __mmdrop

commit bf2c59fce407 ("sched/core: Fix illegal RCU from offline CPUs")
delayed,

idle->active_mm = &init_mm;

into finish_cpu() instead of idle_task_exit() which results in a false
positive warning that was originally designed in the commit 3eda69c92d47
("kernel/fork.c: detect early free of a live mm").

 WARNING: CPU: 127 PID: 72976 at kernel/fork.c:697
 __mmdrop+0x230/0x2c0
 do_exit+0x424/0xfa0
 Call Trace:
 do_exit+0x424/0xfa0
 do_group_exit+0x64/0xd0
 sys_exit_group+0x24/0x30
 system_call_exception+0x108/0x1d0
 system_call_common+0xf0/0x278

Link: http://lkml.kernel.org/r/20200604150344.1796-1-cai@lca.pw
Fixes: bf2c59fce407 ("sched/core: Fix illegal RCU from offline CPUs")
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/fork.c~fork-silence-a-false-postive-warning-in-__mmdrop
+++ a/kernel/fork.c
@@ -694,7 +694,6 @@ void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	WARN_ON_ONCE(mm == current->mm);
-	WARN_ON_ONCE(mm == current->active_mm);
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_subscriptions_destroy(mm);
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch
mm-page_alloc-silence-a-kasan-false-positive.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
mm-annotate-a-data-race-in-page_zonenum.patch

