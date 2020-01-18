Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E34141814
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 15:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAROtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 09:49:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44893 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgAROtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 09:49:33 -0500
Received: from ip5f5bf7da.dynamic.kabel-deutschland.de ([95.91.247.218] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ispPm-0000RI-OH; Sat, 18 Jan 2020 14:49:30 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
        Serge Hallyn <serge@hallyn.com>, stable@vger.kernel.org
Subject: [GIT PULL] thread fixes v5.5-rc7
Date:   Sat, 18 Jan 2020 15:49:14 +0100
Message-Id: <20200118144914.25322-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Linus,

/* Summary */
Here is an urgent fix for ptrace_may_access() permission checking.

Commit 69f594a38967 ("ptrace: do not audit capability check when outputing
/proc/pid/stat") introduced the ability to opt out of audit
messages for accesses to various proc files since they are not violations of
policy. While doing so it switched the check from ns_capable() to
has_ns_capability{_noaudit}(). That means it switched from checking the
subjective credentials (ktask->cred) of the task to using the objective
credentials (ktask->real_cred). This is appears to be wrong. ptrace_has_cap()
is currently only used in ptrace_may_access() And is used to check whether the
calling task (subject) has the CAP_SYS_PTRACE capability in the provided user
namespace to operate on the target task (object).  According to the cred.h
comments this means the subjective credentials of the calling task need to be
used.

With this pr we switch ptrace_has_cap() to use security_capable() and thus back
to using the subjective credentials.

As one example where this might be particularly problematic, Jann pointed out
that in combination with the upcoming IORING_OP_OPENAT{2} feature, this bug
might allow unprivileged users to bypass the capability checks while
asynchronously opening files like /proc/*/mem, because the capability checks
for this would be performed against kernel credentials.

To illustrate on the former point about this being exploitable: When io_uring
creates a new context it records the subjective credentials of the caller.
Later on, when it starts to do work it creates a kernel thread and registers a
callback. The callback runs with kernel creds for ktask->real_cred and
ktask->cred. To prevent this from becoming a full-blown 0-day io_uring will
call override_cred() and override ktask->cred with the subjective credentials
of the creator of the io_uring instance. With ptrace_has_cap() currently
looking at ktask->real_cred this override will be ineffective and the caller
will be able to open arbitray proc files as mentioned above.
Luckily, this is currently not exploitable but will turn into a 0-day once
IORING_OP_OPENAT{2} land in v5.6. Let's fix it now.

To minimize potential regressions I successfully ran the criu testsuite. criu
makes heavy use of ptrace() and extensively hits ptrace_may_access() codepaths
and has a good change of detecting any regressions.
Additionally, I succesfully ran the ptrace and seccomp kernel tests.

/* Testing */
All patches have seen exposure in linux-next and are based on v5.5-rc6.
As mentioned above, the criu test-suite which is one of the test-suits make
massive use of ptrace and hitting ptrace_may_access() codepaths successfully
passed on a kernel with this fix:
################## ALL TEST(S) PASSED (TOTAL 178/SKIPPED 16) ###################
I've posted the full test-log at:
https://gitlab.com/snippets/1931214
Additionally, I succesfully ran the ptrace and seccomp kernel tests.
We also will add a regression test once IO_URING_OPENAT{2} has landed for v5.6
since this gives us a really easy test.

/* Conflicts */
At the time of creating this PR no merge conflicts were reported from
linux-next.

The following changes since commit b3a987b0264d3ddbb24293ebff10eddfc472f653:

  Linux 5.5-rc6 (2020-01-12 16:55:08 -0800)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/for-linus-2020-01-18

for you to fetch changes up to 6b3ad6649a4c75504edeba242d3fd36b3096a57f:

  ptrace: reintroduce usage of subjective credentials in ptrace_has_cap() (2020-01-18 13:51:39 +0100)

Please consider pulling these changes from the signed for-linus-2020-01-18 tag.

Thanks!
Christian

----------------------------------------------------------------
for-linus-2020-01-18

----------------------------------------------------------------
Christian Brauner (1):
      ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()

 kernel/ptrace.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)
