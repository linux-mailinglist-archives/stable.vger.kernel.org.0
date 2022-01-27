Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3E849D767
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 02:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiA0BQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 20:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiA0BQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 20:16:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F00BC06161C;
        Wed, 26 Jan 2022 17:16:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E899961BA6;
        Thu, 27 Jan 2022 01:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1E2C340E3;
        Thu, 27 Jan 2022 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643246175;
        bh=uLqWNtUu13fXsRxorO4KmhxNjYRx1qPXQMlnr0nbUQw=;
        h=Date:From:To:Subject:From;
        b=I5CKJnaK29K/JfodIxfnFSElua05wfzrOtn5C6fPw/8QCp1WOkGykkOctgPD9cxcJ
         I8ZP1c5cY0W1XkzAkwJk03KIxNzw8isXQP/YTqfztVDsayHsS+lHht4FRxsmzRSm26
         yohwSAJoHpi6QUxUB+2wixaItvD5oDf2+iQ0t/wg=
Date:   Wed, 26 Jan 2022 17:16:14 -0800
From:   akpm@linux-foundation.org
To:     ariadne@dereferenced.org, brauner@kernel.org, dalias@libc.org,
        ebiederm@xmission.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  +
 fs-exec-require-argv-presence-in-do_execveat_common.patch added to -mm tree
Message-ID: <20220127011614.XRNUP1KGA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/exec: require argv[0] presence in do_execveat_common()
has been added to the -mm tree.  Its filename is
     fs-exec-require-argv-presence-in-do_execveat_common.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-exec-require-argv-presence-in-do_execveat_common.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-exec-require-argv-presence-in-do_execveat_common.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ariadne Conill <ariadne@dereferenced.org>
Subject: fs/exec: require argv[0] presence in do_execveat_common()

In several other operating systems, it is a hard requirement that the
second argument to execve(2) be the name of a program, thus prohibiting a
scenario where argc < 1.  POSIX 2017 also recommends this behaviour, but
it is not an explicit requirement[0]:

    The argument arg0 should point to a filename string that is
    associated with the process being started by one of the exec
    functions.

To ensure that execve(2) with argc < 1 is not a useful tool for shellcode
to use, we can validate this in do_execveat_common() and fail for this
scenario, effectively blocking successful exploitation of CVE-2021-4034
and similar bugs which depend on execve(2) working with argc < 1.

We use -EINVAL for this case, mirroring recent changes to FreeBSD and
OpenBSD.  -EINVAL is also used by QNX for this, while Solaris uses
-EFAULT.

In earlier versions of the patch, it was proposed that we create a fake
argv for applications to use when argc < 1, but it was concluded that it
would be better to just fail the execve(2) in these cases, as launching a
process with an empty or NULL argv[0] was likely to just cause more
problems.

Interestingly, Michael Kerrisk opened an issue about this in 2008[1], but
there was no consensus to support fixing this issue then.  Hopefully now
that CVE-2021-4034 shows practical exploitative use[2] of this bug in a
shellcode, we can reconsider.

This issue is being tracked in the KSPP issue tracker[3].

There are a few[4][5] minor edge cases (primarily in test suites) that are
caught by this, but we plan to work with the projects to fix those edge
cases.

[0]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
[1]: https://bugzilla.kernel.org/show_bug.cgi?id=8408
[2]: https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
[3]: https://github.com/KSPP/linux/issues/176
[4]: https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
[5]: https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0

Link: https://lkml.kernel.org/r/20220127000724.15106-1-ariadne@dereferenced.org
Signed-off-by: Ariadne Conill <ariadne@dereferenced.org>
Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/exec.c~fs-exec-require-argv-presence-in-do_execveat_common
+++ a/fs/exec.c
@@ -1897,6 +1897,10 @@ static int do_execveat_common(int fd, st
 	}
 
 	retval = count(argv, MAX_ARG_STRINGS);
+	if (retval == 0) {
+		pr_warn_once("Attempted to run process '%s' with NULL argv\n", bprm->filename);
+		retval = -EINVAL;
+	}
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
_

Patches currently in -mm which might be from ariadne@dereferenced.org are

fs-exec-require-argv-presence-in-do_execveat_common.patch

