Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A639833C4E4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCOR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhCORsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FCA64F50;
        Mon, 15 Mar 2021 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830512;
        bh=PvDGtByI6GZ42Czv5iQvtECeFXQOOsK5aiYjXtAkxAc=;
        h=Date:From:To:Subject:From;
        b=RVg4aXqwoHq4qBBx4sjapOTwRik/uFPsAHEzudLE6ptGFwW9G7YGQRNhw9zxUW61v
         uERoaLRKWYtDYPK3zijCLHoTeHa2k7PcNnANxgMNKt3y1gPbfYULnoaGU8pVV/7Rl/
         KPksktGyj+aMgCPNYdzVB3jtEMjUBgQCPPVXoAME=
Date:   Mon, 15 Mar 2021 10:48:31 -0700
From:   akpm@linux-foundation.org
To:     fweimer@redhat.com, jannh@google.com, jeffv@google.com,
        jmorris@namei.org, keescook@chromium.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        rientjes@google.com, shakeelb@google.com, stable@vger.kernel.org,
        surenb@google.com, timmurray@google.com
Subject:  [merged]
 mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch
 removed from -mm tree
Message-ID: <20210315174831.Q2zUmWyps%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/madvise: replace ptrace attach requirement for process_madvise
has been removed from the -mm tree.  Its filename was
     mm-madvise-replace-ptrace-attach-requirement-for-process_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


