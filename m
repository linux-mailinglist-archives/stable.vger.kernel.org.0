Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC9DEED88
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbfKDWHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390159AbfKDWHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:44 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D691214D8;
        Mon,  4 Nov 2019 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905263;
        bh=WK6Fj6UW/5yX61mTt1acXVagRpVt5foeko/k9T+Dt9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSyWhu5WF8UR9VdVwFJ8GoEBHj/7+0zVN3Mz72gMVQ+7qQz98wNBTrYKpWLO50poe
         Sa0Teo5Zomns8KLOtiDPh9oaIGYWqCAJ880LV2jyAk5+Y4gDj6DFG1Gphs4lVH0gp8
         NzqCnH/OjutZacEOcF7f3MfYTAXT7JyT0yPnl6u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, acme@kernel.org,
        gor@linux.ibm.com, hechaol@fb.com, heiko.carstens@de.ibm.com,
        linux-perf-users@vger.kernel.org, songliubraving@fb.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 084/163] perf/aux: Fix tracking of auxiliary trace buffer allocation
Date:   Mon,  4 Nov 2019 22:44:34 +0100
Message-Id: <20191104212146.358961827@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 5e6c3c7b1ec217c1c4c95d9148182302b9969b97 ]

The following commit from the v5.4 merge window:

  d44248a41337 ("perf/core: Rework memory accounting in perf_mmap()")

... breaks auxiliary trace buffer tracking.

If I run command 'perf record -e rbd000' to record samples and saving
them in the **auxiliary** trace buffer then the value of 'locked_vm' becomes
negative after all trace buffers have been allocated and released:

During allocation the values increase:

  [52.250027] perf_mmap user->locked_vm:0x87 pinned_vm:0x0 ret:0
  [52.250115] perf_mmap user->locked_vm:0x107 pinned_vm:0x0 ret:0
  [52.250251] perf_mmap user->locked_vm:0x188 pinned_vm:0x0 ret:0
  [52.250326] perf_mmap user->locked_vm:0x208 pinned_vm:0x0 ret:0
  [52.250441] perf_mmap user->locked_vm:0x289 pinned_vm:0x0 ret:0
  [52.250498] perf_mmap user->locked_vm:0x309 pinned_vm:0x0 ret:0
  [52.250613] perf_mmap user->locked_vm:0x38a pinned_vm:0x0 ret:0
  [52.250715] perf_mmap user->locked_vm:0x408 pinned_vm:0x2 ret:0
  [52.250834] perf_mmap user->locked_vm:0x408 pinned_vm:0x83 ret:0
  [52.250915] perf_mmap user->locked_vm:0x408 pinned_vm:0x103 ret:0
  [52.251061] perf_mmap user->locked_vm:0x408 pinned_vm:0x184 ret:0
  [52.251146] perf_mmap user->locked_vm:0x408 pinned_vm:0x204 ret:0
  [52.251299] perf_mmap user->locked_vm:0x408 pinned_vm:0x285 ret:0
  [52.251383] perf_mmap user->locked_vm:0x408 pinned_vm:0x305 ret:0
  [52.251544] perf_mmap user->locked_vm:0x408 pinned_vm:0x386 ret:0
  [52.251634] perf_mmap user->locked_vm:0x408 pinned_vm:0x406 ret:0
  [52.253018] perf_mmap user->locked_vm:0x408 pinned_vm:0x487 ret:0
  [52.253197] perf_mmap user->locked_vm:0x408 pinned_vm:0x508 ret:0
  [52.253374] perf_mmap user->locked_vm:0x408 pinned_vm:0x589 ret:0
  [52.253550] perf_mmap user->locked_vm:0x408 pinned_vm:0x60a ret:0
  [52.253726] perf_mmap user->locked_vm:0x408 pinned_vm:0x68b ret:0
  [52.253903] perf_mmap user->locked_vm:0x408 pinned_vm:0x70c ret:0
  [52.254084] perf_mmap user->locked_vm:0x408 pinned_vm:0x78d ret:0
  [52.254263] perf_mmap user->locked_vm:0x408 pinned_vm:0x80e ret:0

The value of user->locked_vm increases to a limit then the memory
is tracked by pinned_vm.

During deallocation the size is subtracted from pinned_vm until
it hits a limit. Then a larger value is subtracted from locked_vm
leading to a large number (because of type unsigned):

  [64.267797] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x78d
  [64.267826] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x70c
  [64.267848] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x68b
  [64.267869] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x60a
  [64.267891] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x589
  [64.267911] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x508
  [64.267933] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x487
  [64.267952] perf_mmap_close mmap_user->locked_vm:0x408 pinned_vm:0x406
  [64.268883] perf_mmap_close mmap_user->locked_vm:0x307 pinned_vm:0x406
  [64.269117] perf_mmap_close mmap_user->locked_vm:0x206 pinned_vm:0x406
  [64.269433] perf_mmap_close mmap_user->locked_vm:0x105 pinned_vm:0x406
  [64.269536] perf_mmap_close mmap_user->locked_vm:0x4 pinned_vm:0x404
  [64.269797] perf_mmap_close mmap_user->locked_vm:0xffffffffffffff84 pinned_vm:0x303
  [64.270105] perf_mmap_close mmap_user->locked_vm:0xffffffffffffff04 pinned_vm:0x202
  [64.270374] perf_mmap_close mmap_user->locked_vm:0xfffffffffffffe84 pinned_vm:0x101
  [64.270628] perf_mmap_close mmap_user->locked_vm:0xfffffffffffffe04 pinned_vm:0x0

This value sticks for the user until system is rebooted, causing
follow-on system calls using locked_vm resource limit to fail.

Note: There is no issue using the normal trace buffer.

In fact the issue is in perf_mmap_close(). During allocation auxiliary
trace buffer memory is either traced as 'extra' and added to 'pinned_vm'
or trace as 'user_extra' and added to 'locked_vm'. This applies for
normal trace buffers and auxiliary trace buffer.

However in function perf_mmap_close() all auxiliary trace buffer is
subtraced from 'locked_vm' and never from 'pinned_vm'. This breaks the
ballance.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: acme@kernel.org
Cc: gor@linux.ibm.com
Cc: hechaol@fb.com
Cc: heiko.carstens@de.ibm.com
Cc: linux-perf-users@vger.kernel.org
Cc: songliubraving@fb.com
Fixes: d44248a41337 ("perf/core: Rework memory accounting in perf_mmap()")
Link: https://lkml.kernel.org/r/20191021083354.67868-1-tmricht@linux.ibm.com
[ Minor readability edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2ff44d7308dd7..53173883513c1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5524,8 +5524,10 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		perf_pmu_output_stop(event);
 
 		/* now it's safe to free the pages */
-		atomic_long_sub(rb->aux_nr_pages, &mmap_user->locked_vm);
-		atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
+		if (!rb->aux_mmap_locked)
+			atomic_long_sub(rb->aux_nr_pages, &mmap_user->locked_vm);
+		else
+			atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
 
 		/* this has to be the last one */
 		rb_free_aux(rb);
-- 
2.20.1



