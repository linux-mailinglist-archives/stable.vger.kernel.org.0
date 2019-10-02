Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ADCC91D6
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfJBTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35608 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729213AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00036B-NH; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003e7-No; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jann Horn" <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Kees Cook" <keescook@chromium.org>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.8393023@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 53/87] ptrace: restore smp_rmb() in __ptrace_may_access()
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit f6581f5b55141a95657ef5742cf6a6bfa20a109f upstream.

Restore the read memory barrier in __ptrace_may_access() that was deleted
a couple years ago. Also add comments on this barrier and the one it pairs
with to explain why they're there (as far as I understand).

Fixes: bfedb589252c ("mm: Add a user_ns owner to mm_struct and fix ptrace permission checks")
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cred.c   |  9 +++++++++
 kernel/ptrace.c | 10 ++++++++++
 2 files changed, 19 insertions(+)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -439,6 +439,15 @@ int commit_creds(struct cred *new)
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal = 0;
+		/*
+		 * If a task drops privileges and becomes nondumpable,
+		 * the dumpability change must become visible before
+		 * the credential change; otherwise, a __ptrace_may_access()
+		 * racing with this change may be able to attach to a task it
+		 * shouldn't be able to attach to (as if the task had dropped
+		 * privileges without becoming nondumpable).
+		 * Pairs with a read barrier in __ptrace_may_access().
+		 */
 		smp_wmb();
 	}
 
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -324,6 +324,16 @@ static int __ptrace_may_access(struct ta
 	return -EPERM;
 ok:
 	rcu_read_unlock();
+	/*
+	 * If a task drops privileges and becomes nondumpable (through a syscall
+	 * like setresuid()) while we are trying to access it, we must ensure
+	 * that the dumpability is read after the credentials; otherwise,
+	 * we may be able to attach to a task that we shouldn't be able to
+	 * attach to (as if the task had dropped privileges without becoming
+	 * nondumpable).
+	 * Pairs with a write barrier in commit_creds().
+	 */
+	smp_rmb();
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&

