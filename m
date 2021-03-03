Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7132C845
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378751AbhCDAfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245133AbhCCXGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 18:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B777664F0A;
        Wed,  3 Mar 2021 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614812641;
        bh=y56Tef6M/HP0OYwY83KU9xu+WI1PLL8ezELGAzx5/b0=;
        h=Date:From:To:Subject:From;
        b=2l0tzIn0lkAbhQ7oOETLSx8RYylFMEoD5mkEKAvP7R/gG7I1FZo4w7mJDRkxEd8No
         w0mkBH4Dypie/oJN6kZekal7dRtGz0SPGQQo44z6qSk/1Qi3pPxnkYZ07Z0FqBck1J
         DCaCGj8QDVAo9SWdkBmgNwZ/7hYFCwRJ0Z0AbscY=
Date:   Wed, 03 Mar 2021 15:04:00 -0800
From:   akpm@linux-foundation.org
To:     fweimer@redhat.com, jannh@google.com, jeffv@google.com,
        jmorris@namei.org, keescook@chromium.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        rientjes@google.com, shakeelb@google.com, stable@vger.kernel.org,
        surenb@google.com, timmurray@google.com
Subject:  +
 mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch
 added to -mm tree
Message-ID: <20210303230400.6XXOzp3J5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/madvise: replace ptrace attach requirement for process_madvise
has been added to the -mm tree.  Its filename is
     mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/madvise: replace ptrace attach requirement for process_madvise

process_madvise currently requires ptrace attach capability. 
PTRACE_MODE_ATTACH gives one process complete control over another
process.  It effectively removes the security boundary between the two
processes (in one direction).  Granting ptrace attach capability even to a
system process is considered dangerous since it creates an attack surface.
This severely limits the usage of this API.

The operations process_madvise can perform do not affect the correctness
of the operation of the target process; they only affect where the data is
physically located (and therefore, how fast it can be accessed).  What we
want is the ability for one process to influence another process in order
to optimize performance across the entire system while leaving the
security boundary intact.

Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ and
CAP_SYS_NICE.  PTRACE_MODE_READ to prevent leaking ASLR metadata and
CAP_SYS_NICE for influencing process performance.

Link: https://lkml.kernel.org/r/20210303185807.2160264-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-replace-ptrace-attach-requirement-for-process_madvise
+++ a/mm/madvise.c
@@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto release_task;
 	}
 
-	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
+	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
+	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
 		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		goto release_task;
 	}
 
+	/*
+	 * Require CAP_SYS_NICE for influencing process performance. Note that
+	 * only non-destructive hints are currently supported.
+	 */
+	if (!capable(CAP_SYS_NICE)) {
+		ret = -EPERM;
+		goto release_mm;
+	}
+
 	total_len = iov_iter_count(&iter);
 
 	while (iov_iter_count(&iter)) {
@@ -1218,6 +1228,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	if (ret == 0)
 		ret = total_len - iov_iter_count(&iter);
 
+release_mm:
 	mmput(mm);
 release_task:
 	put_task_struct(task);
_

Patches currently in -mm which might be from surenb@google.com are

mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch

