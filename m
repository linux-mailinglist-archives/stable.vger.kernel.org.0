Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB714A5437
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 01:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiBAAlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 19:41:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiBAAlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 19:41:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABACD6116C;
        Tue,  1 Feb 2022 00:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6D6C340E8;
        Tue,  1 Feb 2022 00:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643676062;
        bh=8dhFxQXXNlU2CSrnoggskuWDFb5eEQnvKm9lwi/UP8Y=;
        h=Date:To:From:Subject:From;
        b=BjJ0socoV3TclQY/vorcp1Wt9Fk2Yni9Txbl9zIZ3N0OIkBOhROXTMgD1sF2Ey/Kf
         B3vJ/XCdT00F3wsjj/hIZ6CykXy1+bUHjpUQj7i5XhqiXG4upil7a596tgJtvxkWju
         AfuQdoqnfZk4hWIY3vi+1z8nDQ4BYlFsBimjKJ8E=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 16:41:00 -0800
Date:   Mon, 31 Jan 2022 16:41:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        mtk.manpages@gmail.com, ebiederm@xmission.com, dalias@libc.org,
        brauner@kernel.org, ariadne@dereferenced.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + exec-force-single-empty-string-when-argv-is-empty.patch added to -mm tree
Message-Id: <20220201004100.BF6D6C340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: exec: force single empty string when argv is empty
has been added to the -mm tree.  Its filename is
     exec-force-single-empty-string-when-argv-is-empty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/exec-force-single-empty-string-when-argv-is-empty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/exec-force-single-empty-string-when-argv-is-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: force single empty string when argv is empty

Quoting[1] Ariadne Conill:

"In several other operating systems, it is a hard requirement that the
second argument to execve(2) be the name of a program, thus prohibiting
a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
but it is not an explicit requirement[2]:

    The argument arg0 should point to a filename string that is
    associated with the process being started by one of the exec
    functions.
...
Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
but there was no consensus to support fixing this issue then.
Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
of this bug in a shellcode, we can reconsider.

This issue is being tracked in the KSPP issue tracker[5]."

While the initial code searches[6][7] turned up what appeared to be
mostly corner case tests, trying to that just reject argv == NULL
(or an immediately terminated pointer list) quickly started tripping[8]
existing userspace programs.

The next best approach is forcing a single empty string into argv and
adjusting argc to match. The number of programs depending on argc == 0
seems a smaller set than those calling execve with a NULL argv.

Account for the additional stack space in bprm_stack_limits(). Inject an
empty string when argc == 0 (and set argc = 1). Warn about the case so
userspace has some notice about the change:

    process './argc0' launched './argc0' with NULL argv: empty string added

Additionally WARN() and reject NULL argv usage for kernel threads.

[1] https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org/
[2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
[3] https://bugzilla.kernel.org/show_bug.cgi?id=8408
[4] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
[5] https://github.com/KSPP/linux/issues/176
[6] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
[7] https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
[8] https://lore.kernel.org/lkml/20220131144352.GE16385@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20220201000947.2453721-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>Reported-by: Ariadne Conill <ariadne@dereferenced.org>
Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/fs/exec.c~exec-force-single-empty-string-when-argv-is-empty
+++ a/fs/exec.c
@@ -495,8 +495,14 @@ static int bprm_stack_limits(struct linu
 	 * the stack. They aren't stored until much later when we can't
 	 * signal to the parent that the child has run out of stack space.
 	 * Instead, calculate it here so it's possible to fail gracefully.
+	 *
+	 * In the case of argc = 0, make sure there is space for adding a
+	 * empty string (which will bump argc to 1), to ensure confused
+	 * userspace programs don't start processing from argv[1], thinking
+	 * argc can never be 0, to keep them from walking envp by accident.
+	 * See do_execveat_common().
 	 */
-	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
+	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
 	if (limit <= ptr_size)
 		return -E2BIG;
 	limit -= ptr_size;
@@ -1897,6 +1903,9 @@ static int do_execveat_common(int fd, st
 	}
 
 	retval = count(argv, MAX_ARG_STRINGS);
+	if (retval == 0)
+		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
+			     current->comm, bprm->filename);
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
@@ -1923,6 +1932,19 @@ static int do_execveat_common(int fd, st
 	if (retval < 0)
 		goto out_free;
 
+	/*
+	 * When argv is empty, add an empty string ("") as argv[0] to
+	 * ensure confused userspace programs that start processing
+	 * from argv[1] won't end up walking envp. See also
+	 * bprm_stack_limits().
+	 */
+	if (bprm->argc == 0) {
+		retval = copy_string_kernel("", bprm);
+		if (retval < 0)
+			goto out_free;
+		bprm->argc = 1;
+	}
+
 	retval = bprm_execve(bprm, fd, filename, flags);
 out_free:
 	free_bprm(bprm);
@@ -1951,6 +1973,8 @@ int kernel_execve(const char *kernel_fil
 	}
 
 	retval = count_strings_kernel(argv);
+	if (WARN_ON_ONCE(retval == 0))
+		retval = -EINVAL;
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
_

Patches currently in -mm which might be from keescook@chromium.org are

kconfigdebug-make-debug_info-selectable-from-a-choice.patch
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
exec-force-single-empty-string-when-argv-is-empty.patch

