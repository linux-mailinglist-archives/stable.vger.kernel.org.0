Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594401F44C4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgFISIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:08:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41492 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388195AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001p0-W4; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vwi-Ru; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Tue, 09 Jun 2020 19:04:37 +0100
Message-ID: <lsq.1591725832.311723066@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 46/61] signal: Extend exec_id to 64bits
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit d1e7fd6462ca9fc76650fbe6ca800e35b24267da upstream.

Replace the 32bit exec_id with a 64bit exec_id to make it impossible
to wrap the exec_id counter.  With care an attacker can cause exec_id
wrap and send arbitrary signals to a newly exec'd parent.  This
bypasses the signal sending checks if the parent changes their
credentials during exec.

The severity of this problem can been seen that in my limited testing
of a 32bit exec_id it can take as little as 19s to exec 65536 times.
Which means that it can take as little as 14 days to wrap a 32bit
exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
days.  Even my slower timing is in the uptime of a typical server.
Which means self_exec_id is simply a speed bump today, and if exec
gets noticably faster self_exec_id won't even be a speed bump.

Extending self_exec_id to 64bits introduces a problem on 32bit
architectures where reading self_exec_id is no longer atomic and can
take two read instructions.  Which means that is is possible to hit
a window where the read value of exec_id does not match the written
value.  So with very lucky timing after this change this still
remains expoiltable.

I have updated the update of exec_id on exec to use WRITE_ONCE
and the read of exec_id in do_notify_parent to use READ_ONCE
to make it clear that there is no locking between these two
locations.

Link: https://lore.kernel.org/kernel-hardening/20200324215049.GA3710@pi3.com.pl
Fixes: 2.3.23pre2
Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
[bwh: Backported to 3.16:
 - Use ACCESS_ONCE()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exec.c             | 2 +-
 include/linux/sched.h | 4 ++--
 kernel/signal.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1182,7 +1182,7 @@ void setup_new_exec(struct linux_binprm
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-	current->self_exec_id++;
+	ACCESS_ONCE(current->self_exec_id) = current->self_exec_id + 1;
 	flush_signal_handlers(current, 0);
 }
 EXPORT_SYMBOL(setup_new_exec);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1427,8 +1427,8 @@ struct task_struct {
 	struct seccomp seccomp;
 
 /* Thread group tracking */
-   	u32 parent_exec_id;
-   	u32 self_exec_id;
+	u64 parent_exec_id;
+	u64 self_exec_id;
 /* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
  * mempolicy */
 	spinlock_t alloc_lock;
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1679,7 +1679,7 @@ bool do_notify_parent(struct task_struct
 		 * This is only possible if parent == real_parent.
 		 * Check if it has changed security domain.
 		 */
-		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
+		if (tsk->parent_exec_id != ACCESS_ONCE(tsk->parent->self_exec_id))
 			sig = SIGCHLD;
 	}
 

