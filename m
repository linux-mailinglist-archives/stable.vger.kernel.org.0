Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7586C78C
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbfGRDFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389933AbfGRDFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:23 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B062173B;
        Thu, 18 Jul 2019 03:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419122;
        bh=poCa17KB4EoV73zCLWQXwNerWkkC8XFA9xpyH2sxeZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fekfe2NEVS+Ujgb+iRlmTVhyEttZ8u0x+C5cLvu7I/8EZ4dtjd09JGBq7usd7rLwf
         Gi3+DzMbROfhTGSlYWjnDcNzjaQ8SRYzUEeesInGilCfjygnjRopZaDxhLrFNikw51
         SY6LjDuNxG1fXbj0FFvA2ug4BDMSGG33QtWfCmEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Wind Yu <yuzhoujian@didichuxing.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 38/54] mm/oom_kill.c: fix uninitialized oc->constraint
Date:   Thu, 18 Jul 2019 12:01:33 +0900
Message-Id: <20190718030056.186241465@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



