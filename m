Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BD39E893
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFGUmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFGUmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 16:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914DC610FB;
        Mon,  7 Jun 2021 20:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098462;
        bh=ZTSRCdJQLQRUpsc/9LGQx8Dex5CyWDX1smL+p0JRsck=;
        h=Date:From:To:Subject:From;
        b=b412pZo/bY/7yF4DBTIwmpDvUKTHZCotUToPm0IT0jX/za7uF6bAh3LVltTaAlad+
         m0/KHfJu/fRS1nU0S5T051ROgar+5tQcl/Gjm2QWaPWoTtpPzl6VJjQSJUdEq1YpVs
         A5/Wklg5zddbLfSF27SI1CxufA0MFuVegL+dY8v4=
Date:   Mon, 07 Jun 2021 13:41:02 -0700
From:   akpm@linux-foundation.org
To:     David.Laight@ACULAB.COM, dvyukov@google.com, elver@google.com,
        glider@google.com, hdanton@sina.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 kfence-use-task_idle-when-awaiting-allocation.patch removed from -mm tree
Message-ID: <20210607204102.wynuODwK4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: use TASK_IDLE when awaiting allocation
has been removed from the -mm tree.  Its filename was
     kfence-use-task_idle-when-awaiting-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: use TASK_IDLE when awaiting allocation

Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
allocation counts towards load.  However, for KFENCE, this does not make
any sense, since there is no busy work we're awaiting.

Instead, use TASK_IDLE via wait_event_idle() to not count towards load.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1185565
Link: https://lkml.kernel.org/r/20210521083209.3740269-1-elver@google.com
Fixes: 407f1d8c1b5f ("kfence: await for allocation using wait_event")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-use-task_idle-when-awaiting-allocation
+++ a/mm/kfence/core.c
@@ -627,10 +627,10 @@ static void toggle_allocation_gate(struc
 		 * During low activity with no allocations we might wait a
 		 * while; let's avoid the hung task warning.
 		 */
-		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
-				   sysctl_hung_task_timeout_secs * HZ / 2);
+		wait_event_idle_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+					sysctl_hung_task_timeout_secs * HZ / 2);
 	} else {
-		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+		wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
 	}
 
 	/* Disable static key and reset timer. */
_

Patches currently in -mm which might be from elver@google.com are

mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch
kfence-unconditionally-use-unbound-work-queue.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

