Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC9B2B6289
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbgKQN32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbgKQN30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 224BD2078E;
        Tue, 17 Nov 2020 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619764;
        bh=dLHs5/OgqfER8dfaafMMG2L4JrCjgESHbhuOxVoh1aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYDUzR18wQbvs7VgWweXUdjIs9wQ66smUCWOdMgBCIkN6rBPkeL6mM+ceWQnuB3fo
         qpV+HfsfJfO4ASh8/3OOwCcigTwg9few9JC/fWu5pfb3O30MRCYeXykonKyTiD0HmU
         i3vhbVgw6wst1elwrEoiJiLegR8T853nq58Ux5zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>,
        Wade Mealing <wmealing@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 149/151] perf/core: Fix race in the perf_mmap_close() function
Date:   Tue, 17 Nov 2020 14:06:19 +0100
Message-Id: <20201117122128.679016771@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

commit f91072ed1b7283b13ca57fcfbece5a3b92726143 upstream.

There's a possible race in perf_mmap_close() when checking ring buffer's
mmap_count refcount value. The problem is that the mmap_count check is
not atomic because we call atomic_dec() and atomic_read() separately.

  perf_mmap_close:
  ...
   atomic_dec(&rb->mmap_count);
   ...
   if (atomic_read(&rb->mmap_count))
      goto out_put;

   <ring buffer detach>
   free_uid

out_put:
  ring_buffer_put(rb); /* could be last */

The race can happen when we have two (or more) events sharing same ring
buffer and they go through atomic_dec() and then they both see 0 as refcount
value later in atomic_read(). Then both will go on and execute code which
is meant to be run just once.

The code that detaches ring buffer is probably fine to be executed more
than once, but the problem is in calling free_uid(), which will later on
demonstrate in related crashes and refcount warnings, like:

  refcount_t: addition on 0; use-after-free.
  ...
  RIP: 0010:refcount_warn_saturate+0x6d/0xf
  ...
  Call Trace:
  prepare_creds+0x190/0x1e0
  copy_creds+0x35/0x172
  copy_process+0x471/0x1a80
  _do_fork+0x83/0x3a0
  __do_sys_wait4+0x83/0x90
  __do_sys_clone+0x85/0xa0
  do_syscall_64+0x5b/0x1e0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Using atomic decrease and check instead of separated calls.

Tested-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Wade Mealing <wmealing@redhat.com>
Fixes: 9bb5d40cd93c ("perf: Fix mmap() accounting hole");
Link: https://lore.kernel.org/r/20200916115311.GE2301783@krava
[sudip: used ring_buffer]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5596,11 +5596,11 @@ static void perf_pmu_output_stop(struct
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-
 	struct ring_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
+	bool detach_rest = false;
 
 	if (event->pmu->event_unmapped)
 		event->pmu->event_unmapped(event, vma->vm_mm);
@@ -5631,7 +5631,8 @@ static void perf_mmap_close(struct vm_ar
 		mutex_unlock(&event->mmap_mutex);
 	}
 
-	atomic_dec(&rb->mmap_count);
+	if (atomic_dec_and_test(&rb->mmap_count))
+		detach_rest = true;
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
 		goto out_put;
@@ -5640,7 +5641,7 @@ static void perf_mmap_close(struct vm_ar
 	mutex_unlock(&event->mmap_mutex);
 
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (atomic_read(&rb->mmap_count))
+	if (!detach_rest)
 		goto out_put;
 
 	/*


