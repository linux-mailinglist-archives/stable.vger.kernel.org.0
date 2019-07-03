Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9775DBF2
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfGCCSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbfGCCSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB5C821874;
        Wed,  3 Jul 2019 02:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120330;
        bh=mUb06GlPkIZX2TWwchCmZNTU+3knEUqDQHpJxoUKJdk=;
        h=From:To:Cc:Subject:Date:From;
        b=LoJOSwo9PDA55/C33iQ9iLSWy3SuETzmFvyITBNgAAYGqzEW9qBtqNJDtG1ky0Sab
         DAi2kvjjsoCcC1dfaZ/IO5PE8sn6/d5B0ka8S0pbAYg1tM05zaAoakP9CyKgkrTe+c
         M5T5y9yjQM83fGbzSWi3oy5oVHjDG9rGYa7M7SPY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.vnet.ibm.com>,
        Young Xiao <92siuyang@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 1/8] perf/core: Fix perf_sample_regs_user() mm check
Date:   Tue,  2 Jul 2019 22:18:40 -0400
Message-Id: <20190703021847.18542-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 085ebfe937d7a7a5df1729f35a12d6d655fea68c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7929526e96e2..93d7333c64d8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5492,7 +5492,7 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (current->mm) {
+	} else if (!(current->flags & PF_KTHREAD)) {
 		perf_get_regs_user(regs_user, regs, regs_user_copy);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
-- 
2.20.1

