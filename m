Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300125DB87
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfGCCQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbfGCCQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1253A2187F;
        Wed,  3 Jul 2019 02:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120178;
        bh=0VqhOrySUpgW0ddkrrcTG2M+nPD6bjN6ICpW5L0wvWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=so/bqVAcjFTT3cgV0vgcX76LQO1yvZo/p22MmF9G1Y6/HJqn66DsuzkWvDCUZFHP6
         YMOVj2HVGXOp9cYMVmQr1XIgUpmeWHLA+plw56h3gVHdaLvfFGTAUHrt4xesAtxyGw
         wmUHyntC1zbfIQRr8E6oq5hL4RKbP+y7lB+6FHQs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Wind Yu <yuzhoujian@didichuxing.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.1 37/39] mm/oom_kill.c: fix uninitialized oc->constraint
Date:   Tue,  2 Jul 2019 22:15:12 -0400
Message-Id: <20190703021514.17727-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 432b1de0de02a83f64695e69a2d83cbee10c236f ]

In dump_oom_summary() oc->constraint is used to show oom_constraint_text,
but it hasn't been set before.  So the value of it is always the default
value 0.  We should inititialize it before.

Bellow is the output when memcg oom occurs,

before this patch:
  oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null), cpuset=/,mems_allowed=0,oom_memcg=/foo,task_memcg=/foo,task=bash,pid=7997,uid=0

after this patch:
  oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null), cpuset=/,mems_allowed=0,oom_memcg=/foo,task_memcg=/foo,task=bash,pid=13681,uid=0

Link: http://lkml.kernel.org/r/1560522038-15879-1-git-send-email-laoar.shao@gmail.com
Fixes: ef8444ea01d7 ("mm, oom: reorganize the oom report in dump_header")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wind Yu <yuzhoujian@didichuxing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/oom_kill.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3a2484884cfd..263efad6fc7e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -985,8 +985,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-static void check_panic_on_oom(struct oom_control *oc,
-			       enum oom_constraint constraint)
+static void check_panic_on_oom(struct oom_control *oc)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -996,7 +995,7 @@ static void check_panic_on_oom(struct oom_control *oc,
 		 * does not panic for cpuset, mempolicy, or memcg allocation
 		 * failures.
 		 */
-		if (constraint != CONSTRAINT_NONE)
+		if (oc->constraint != CONSTRAINT_NONE)
 			return;
 	}
 	/* Do not panic for oom kills triggered by sysrq */
@@ -1033,7 +1032,6 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
-	enum oom_constraint constraint = CONSTRAINT_NONE;
 
 	if (oom_killer_disabled)
 		return false;
@@ -1069,10 +1067,10 @@ bool out_of_memory(struct oom_control *oc)
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA and memcg) that may require different handling.
 	 */
-	constraint = constrained_alloc(oc);
-	if (constraint != CONSTRAINT_MEMORY_POLICY)
+	oc->constraint = constrained_alloc(oc);
+	if (oc->constraint != CONSTRAINT_MEMORY_POLICY)
 		oc->nodemask = NULL;
-	check_panic_on_oom(oc, constraint);
+	check_panic_on_oom(oc);
 
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
 	    current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
-- 
2.20.1

