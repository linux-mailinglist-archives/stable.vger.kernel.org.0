Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69DD1B4221
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgDVK6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgDVKEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBA920774;
        Wed, 22 Apr 2020 10:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549853;
        bh=3Z78rl4P9hYinx2mcFD5H2B/ysypUpZ7mhR6Pul/n3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vT2dBowA4dm6PQ1UrRI6invSpCqHqVyZRkTBXBNzJ5DvTz41dVhPDHAXgG/u57RP4
         uf88nZ8hVA3HuivFPLMuDwKiuti/pn1pgn12Kni6ZqeLfdCEPFdfzkElCPRP1473nS
         yRLvud34EEH62+y4Ec1bHJIb5bNwqodM/zlOmzps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.9 033/125] signal: Extend exec_id to 64bits
Date:   Wed, 22 Apr 2020 11:55:50 +0200
Message-Id: <20200422095038.756745774@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c             |    2 +-
 include/linux/sched.h |    4 ++--
 kernel/signal.c       |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1353,7 +1353,7 @@ void setup_new_exec(struct linux_binprm
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-	current->self_exec_id++;
+	WRITE_ONCE(current->self_exec_id, current->self_exec_id + 1);
 	flush_signal_handlers(current, 0);
 }
 EXPORT_SYMBOL(setup_new_exec);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1720,8 +1720,8 @@ struct task_struct {
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
@@ -1660,7 +1660,7 @@ bool do_notify_parent(struct task_struct
 		 * This is only possible if parent == real_parent.
 		 * Check if it has changed security domain.
 		 */
-		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
+		if (tsk->parent_exec_id != READ_ONCE(tsk->parent->self_exec_id))
 			sig = SIGCHLD;
 	}
 


