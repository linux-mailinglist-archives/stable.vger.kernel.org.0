Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD4DD47C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393047AbfJRWYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbfJRWEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6394D2245C;
        Fri, 18 Oct 2019 22:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436290;
        bh=NynUHA4qevW95zKm+h3K9YX279or91FM4C/MRJ+5jkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQxPYW5YNaa63MhM5KQVz7VpSnaDzd5QZaC0Mp7fJ4lyY2AYtbJJ8iHoltuPa6IEt
         4haadkFYkmkcCkItEWvrUJDRh1FUHE61YRNkiQoQUtcuQvh5Oyd1NrXKQjPZzKYqQx
         Ro0dYAwhvhTRSAdjijbq7Rh4CpAnlGkoAocfINbo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 64/89] sched/vtime: Fix guest/system mis-accounting on task switch
Date:   Fri, 18 Oct 2019 18:02:59 -0400
Message-Id: <20191018220324.8165-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 68e7a4d66b0ce04bf18ff2ffded5596ab3618585 ]

vtime_account_system() assumes that the target task to account cputime
to is always the current task. This is most often true indeed except on
task switch where we call:

	vtime_common_task_switch(prev)
		vtime_account_system(prev)

Here prev is the scheduling-out task where we account the cputime to. It
doesn't match current that is already the scheduling-in task at this
stage of the context switch.

So we end up checking the wrong task flags to determine if we are
accounting guest or system time to the previous task.

As a result the wrong task is used to check if the target is running in
guest mode. We may then spuriously account or leak either system or
guest time on task switch.

Fix this assumption and also turn vtime_guest_enter/exit() to use the
task passed in parameter as well to avoid future similar issues.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wanpeng Li <wanpengli@tencent.com>
Fixes: 2a42eb9594a1 ("sched/cputime: Accumulate vtime on top of nsec clocksource")
Link: https://lkml.kernel.org/r/20190925214242.21873-1-frederic@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cputime.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 2305ce89a26cf..46ed4e1383e21 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -740,7 +740,7 @@ void vtime_account_system(struct task_struct *tsk)
 
 	write_seqcount_begin(&vtime->seqcount);
 	/* We might have scheduled out from guest path */
-	if (current->flags & PF_VCPU)
+	if (tsk->flags & PF_VCPU)
 		vtime_account_guest(tsk, vtime);
 	else
 		__vtime_account_system(tsk, vtime);
@@ -783,7 +783,7 @@ void vtime_guest_enter(struct task_struct *tsk)
 	 */
 	write_seqcount_begin(&vtime->seqcount);
 	__vtime_account_system(tsk, vtime);
-	current->flags |= PF_VCPU;
+	tsk->flags |= PF_VCPU;
 	write_seqcount_end(&vtime->seqcount);
 }
 EXPORT_SYMBOL_GPL(vtime_guest_enter);
@@ -794,7 +794,7 @@ void vtime_guest_exit(struct task_struct *tsk)
 
 	write_seqcount_begin(&vtime->seqcount);
 	vtime_account_guest(tsk, vtime);
-	current->flags &= ~PF_VCPU;
+	tsk->flags &= ~PF_VCPU;
 	write_seqcount_end(&vtime->seqcount);
 }
 EXPORT_SYMBOL_GPL(vtime_guest_exit);
-- 
2.20.1

