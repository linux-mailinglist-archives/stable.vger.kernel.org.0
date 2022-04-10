Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CFE4FABE4
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 06:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiDJElR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 00:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiDJElQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 00:41:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAEB634E;
        Sat,  9 Apr 2022 21:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAA36B80B86;
        Sun, 10 Apr 2022 04:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95800C385A1;
        Sun, 10 Apr 2022 04:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565543;
        bh=QS/jb0j3kOaa2Lnwf4XbyyqD3ttLVGMRaigYk5q/g+M=;
        h=Date:To:From:Subject:From;
        b=hQYxHeJMKjQ/AFZngP75qbhZkTfkDkfzdTj15jwNsW2tVLRIU/mLwIeWx+C8l5DEx
         3ALkZviZPY2Ylxb/f8n7a+3RyQYxTdOmCFpcDXVOVQg1jOoRWXBvj7bCD/jK1Cq2ul
         ly48TCbqugJEU2kgIagYhjtkqzacFJGqT63hVJEs=
Date:   Sat, 09 Apr 2022 21:39:02 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, peterz@infradead.org, jcmvbkbc@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] highmem-fix-checks-in-__kmap_local_sched_inout.patch removed from -mm tree
Message-Id: <20220410043903.95800C385A1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: highmem: fix checks in __kmap_local_sched_{in,out}
has been removed from the -mm tree.  Its filename was
     highmem-fix-checks-in-__kmap_local_sched_inout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: highmem: fix checks in __kmap_local_sched_{in,out}

When CONFIG_DEBUG_KMAP_LOCAL is enabled __kmap_local_sched_{in,out} check
that even slots in the tsk->kmap_ctrl.pteval are unmapped.  The slots are
initialized with 0 value, but the check is done with pte_none.  0 pte
however does not necessarily mean that pte_none will return true.  e.g. 
on xtensa it returns false, resulting in the following runtime warnings:

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:627 __kmap_local_sched_out+0x51/0x108
 CPU: 0 PID: 101 Comm: touch Not tainted 5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_out+0x51/0x108
   __schedule+0x71a/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:664 __kmap_local_sched_in+0x50/0xe0
 CPU: 0 PID: 101 Comm: touch Tainted: G        W         5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_in+0x50/0xe0
   finish_task_switch$isra$0+0x1ce/0x2f8
   __schedule+0x86e/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

Fix it by replacing !pte_none(pteval) with pte_val(pteval) != 0.

Link: https://lkml.kernel.org/r/20220403235159.3498065-1-jcmvbkbc@gmail.com
Fixes: 5fbda3ecd14a ("sched: highmem: Store local kmaps in task struct")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~highmem-fix-checks-in-__kmap_local_sched_inout
+++ a/mm/highmem.c
@@ -624,7 +624,7 @@ void __kmap_local_sched_out(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
@@ -661,7 +661,7 @@ void __kmap_local_sched_in(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are


