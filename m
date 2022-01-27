Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F0849D688
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 01:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiA0AHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 19:07:31 -0500
Received: from mx1.mailbun.net ([170.39.20.100]:42890 "EHLO mx1.mailbun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbiA0AHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 19:07:31 -0500
Received: from localhost.localdomain (unknown [170.39.20.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ariadne@dereferenced.org)
        by mx1.mailbun.net (Postfix) with ESMTPSA id 1185B11A817;
        Thu, 27 Jan 2022 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dereferenced.org;
        s=mailbun; t=1643242051;
        bh=KrviaVq2nktezkC2TngWHh7lS7n6CoRmDUx4MPmAHSo=;
        h=From:To:Cc:Subject:Date;
        b=jqFlIp7Lw9yFEc4lYI6x1eZQlXDzyYVr4LfXMHNNIWSsXlrZvTnVdOfzD4QofzCoX
         L0LKOIALzXCOLL3m36vm1aneR45vxryLTfbBz/1WJV+SVhmpyvRBCkS8bbNbBZxWBX
         o+4QtnrUZEAxmVRJp2xDdOZYjkNjZXC33YpAqU1y/iiv1wfiUz3czf5TkioPgSGPul
         6OxdrZF60z3uBv3sC0uuMCHpO4tRitNzyjFKGBL++xo/h06vVpMiIAq0l2FYx1T+kB
         u2e0qbo/vhKIBvK7zF/mPMDp/MLP86Vm/bjzj2+NsZKpCzqBhOIFswilovgKMRJ1FP
         qnEtSkWD840MA==
From:   Ariadne Conill <ariadne@dereferenced.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: [PATCH v3] fs/exec: require argv[0] presence in do_execveat_common()
Date:   Thu, 27 Jan 2022 00:07:24 +0000
Message-Id: <20220127000724.15106-1-ariadne@dereferenced.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In several other operating systems, it is a hard requirement that the
second argument to execve(2) be the name of a program, thus prohibiting
a scenario where argc < 1.  POSIX 2017 also recommends this behaviour,
but it is not an explicit requirement[0]:

    The argument arg0 should point to a filename string that is
    associated with the process being started by one of the exec
    functions.

To ensure that execve(2) with argc < 1 is not a useful tool for
shellcode to use, we can validate this in do_execveat_common() and
fail for this scenario, effectively blocking successful exploitation
of CVE-2021-4034 and similar bugs which depend on execve(2) working
with argc < 1.

We use -EINVAL for this case, mirroring recent changes to FreeBSD and
OpenBSD.  -EINVAL is also used by QNX for this, while Solaris uses
-EFAULT.

In earlier versions of the patch, it was proposed that we create a
fake argv for applications to use when argc < 1, but it was concluded
that it would be better to just fail the execve(2) in these cases, as
launching a process with an empty or NULL argv[0] was likely to just
cause more problems.

Interestingly, Michael Kerrisk opened an issue about this in 2008[1],
but there was no consensus to support fixing this issue then.
Hopefully now that CVE-2021-4034 shows practical exploitative use[2]
of this bug in a shellcode, we can reconsider.

This issue is being tracked in the KSPP issue tracker[3].

There are a few[4][5] minor edge cases (primarily in test suites) that
are caught by this, but we plan to work with the projects to fix those
edge cases.

[0]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
[1]: https://bugzilla.kernel.org/show_bug.cgi?id=8408
[2]: https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
[3]: https://github.com/KSPP/linux/issues/176
[4]: https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
[5]: https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0

Changes from v2:
- Switch to using -EINVAL as the error code for this.
- Use pr_warn_once() to warn when an execve(2) is rejected due to NULL
  argv.

Changes from v1:
- Rework commit message significantly.
- Make the argv[0] check explicit rather than hijacking the error-check
  for count().

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Signed-off-by: Ariadne Conill <ariadne@dereferenced.org>
---
 fs/exec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 79f2c9483302..982730cfe3b8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1897,6 +1897,10 @@ static int do_execveat_common(int fd, struct filename *filename,
 	}
 
 	retval = count(argv, MAX_ARG_STRINGS);
+	if (retval == 0) {
+		pr_warn_once("Attempted to run process '%s' with NULL argv\n", bprm->filename);
+		retval = -EINVAL;
+	}
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
-- 
2.34.1

