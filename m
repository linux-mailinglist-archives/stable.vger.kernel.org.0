Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61639C917C
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfJBTJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:09:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36110 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729381AbfJBTIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:22 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-00035x-Q7; Wed, 02 Oct 2019 20:08:15 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003fB-Ep; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Ravi Bangoria" <ravi.bangoria@linux.vnet.ibm.com>,
        "Stephane Eranian" <eranian@google.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Young Xiao" <92siuyang@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Will Deacon" <will.deacon@arm.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.918554389@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 66/87] perf/core: Fix perf_sample_regs_user() mm check
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

From: Peter Zijlstra <peterz@infradead.org>

commit 085ebfe937d7a7a5df1729f35a12d6d655fea68c upstream.

perf_sample_regs_user() uses 'current->mm' to test for the presence of
userspace, but this is insufficient, consider use_mm().

A better test is: '!(current->flags & PF_KTHREAD)', exec() clears
PF_KTHREAD after it sets the new ->mm but before it drops to userspace
for the first time.

Possibly obsoletes: bf05fc25f268 ("powerpc/perf: Fix oops when kthread execs user process")

Reported-by: Ravi Bangoria <ravi.bangoria@linux.vnet.ibm.com>
Reported-by: Young Xiao <92siuyang@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 4018994f3d87 ("perf: Add ability to attach user level registers dump to sample")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4581,7 +4581,7 @@ static void perf_sample_regs_user(struct
 				  struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
-		if (current->mm)
+		if (!(current->flags & PF_KTHREAD))
 			regs = task_pt_regs(current);
 		else
 			regs = NULL;

