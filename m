Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C140D11940C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfLJVND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbfLJVND (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60832465B;
        Tue, 10 Dec 2019 21:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012382;
        bh=W4y7qxt9zncxLFVbblXwIze/qP8OdDiCDJPyJRUsryA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+Srg/kam+97uMeVdyrOa77SUXunhtAKtWaAdmiOdiU14ooLKckT28aVq2bGe7P1j
         lHHmgWe13L/tq9b7VHgcJ2QyMl8WezjGhiCczQgVL3shVevVtLZ0yf+zZis38Tvn1W
         NfEnCztCTqpFRdSg2bqARl23vVwIUFLXjaDWabcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 305/350] perf/core: Fix the mlock accounting, again
Date:   Tue, 10 Dec 2019 16:06:50 -0500
Message-Id: <20191210210735.9077-266-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit 36b3db03b4741b8935b68fffc7e69951d8d70a89 ]

Commit:

  5e6c3c7b1ec2 ("perf/aux: Fix tracking of auxiliary trace buffer allocation")

tried to guess the correct combination of arithmetic operations that would
undo the AUX buffer's mlock accounting, and failed, leaking the bottom part
when an allocation needs to be charged partially to both user->locked_vm
and mm->pinned_vm, eventually leaving the user with no locked bonus:

  $ perf record -e intel_pt//u -m1,128 uname
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.061 MB perf.data ]

  $ perf record -e intel_pt//u -m1,128 uname
  Permission error mapping pages.
  Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
  or try again with a smaller value of -m/--mmap_pages.
  (current value: 1,128)

Fix this by subtracting both locked and pinned counts when AUX buffer is
unmapped.

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 00a014670ed02..8f66a4833dedd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5607,10 +5607,8 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		perf_pmu_output_stop(event);
 
 		/* now it's safe to free the pages */
-		if (!rb->aux_mmap_locked)
-			atomic_long_sub(rb->aux_nr_pages, &mmap_user->locked_vm);
-		else
-			atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
+		atomic_long_sub(rb->aux_nr_pages - rb->aux_mmap_locked, &mmap_user->locked_vm);
+		atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
 
 		/* this has to be the last one */
 		rb_free_aux(rb);
-- 
2.20.1

