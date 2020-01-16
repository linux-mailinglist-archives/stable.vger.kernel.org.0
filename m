Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490EB13F477
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbgAPStz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389656AbgAPRJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DEA22464;
        Thu, 16 Jan 2020 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194558;
        bh=yS4+U9L26l/jpK/Ofpa4jBRq/FVeVyV/IFoiS10BGNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqc39T2T5c5l7W/IMK+X5douBPqOUvCGycLHd4iKJNxHL5EYweLaP05zjmkxk+BkF
         /7TWkl0D1fIh7p+wPkfBOd5rP++7Rxk2Qy2nEkinQhnXLhOYvrssqEjZKwtQfhZSzN
         QTUoL1Ua0hRE8fzYBYBP4lRHHNA6vCHWHd36abss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 439/671] fork,memcg: alloc_thread_stack_node needs to set tsk->stack
Date:   Thu, 16 Jan 2020 12:01:17 -0500
Message-Id: <20200116170509.12787-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

[ Upstream commit 1bf4580e00a248a2c86269125390eb3648e1877c ]

Commit 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
memcg charge fail") corrected two instances, but there was a third
instance of this bug.

Without setting tsk->stack, if memcg_charge_kernel_stack fails, it'll
execute free_thread_stack() on a dangling pointer.

Enterprise kernels are compiled with VMAP_STACK=y so this isn't
critical, but custom VMAP_STACK=n builds should have some performance
advantage, with the drawback of risking to fail fork because compaction
didn't succeed.  So as long as VMAP_STACK=n is a supported option it's
worth fixing it upstream.

Link: http://lkml.kernel.org/r/20190619011450.28048-1-aarcange@redhat.com
Fixes: 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1bd119530a49..1a2d18e98bf9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -240,7 +240,11 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
 					     THREAD_SIZE_ORDER);
 
-	return page ? page_address(page) : NULL;
+	if (likely(page)) {
+		tsk->stack = page_address(page);
+		return tsk->stack;
+	}
+	return NULL;
 #endif
 }
 
-- 
2.20.1

