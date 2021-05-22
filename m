Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8869538D77C
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhEVVOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 17:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhEVVOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 17:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF03E61019;
        Sat, 22 May 2021 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621717985;
        bh=U+/Ok390LQgS/2ep7W/m6BHptHOfeSbRZgV5j3VDw0Q=;
        h=Date:From:To:Subject:From;
        b=YwMHcZI7gb/pfz/WN8Yi1z+/1P54X2jc0IZt64fJV0D3gRnwRQp6mT47hnTGEvtQE
         eVGDxXM6gmbRGlgQiJuHcMVnUn0CwV+u8oEFZoRFMam17+8a0tb3ldjLQmcSqP9p48
         hAmBBTroLwEtljEXH0Nd9kbrqQPwt/TLGkh1S3YU=
Date:   Sat, 22 May 2021 14:13:04 -0700
From:   akpm@linux-foundation.org
To:     David.Laight@ACULAB.COM, dvyukov@google.com, elver@google.com,
        glider@google.com, hdanton@sina.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  + kfence-use-task_idle-when-awaiting-allocation.patch
 added to -mm tree
Message-ID: <20210522211304.BSGg6GZUy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: use TASK_IDLE when awaiting allocation
has been added to the -mm tree.  Its filename is
     kfence-use-task_idle-when-awaiting-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-use-task_idle-when-awaiting-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-use-task_idle-when-awaiting-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kfence-use-task_idle-when-awaiting-allocation.patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch
kfence-unconditionally-use-unbound-work-queue.patch

