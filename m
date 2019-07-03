Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7A5DC29
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfGCCQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfGCCQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C08E21882;
        Wed,  3 Jul 2019 02:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120180;
        bh=CXypkWf8I4WajPrb0acNINufJkDjdlHLijhFneaHr+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+i1UEnzuaXjn12OchshjgINtru4+IXV5OElcGw24Ghy0N+WQffOzmxir8UdtFq/C
         9o+tskdhVC5L8WFqrTpDYcRiSx3scMsD4PIbVX56OrtXqiMIN1qt6+L3zA21PZ6yTw
         reu3LX9iGeJtwHj90U4AgTtVXhfki6FWFWzWn+B4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 38/39] fork,memcg: alloc_thread_stack_node needs to set tsk->stack
Date:   Tue,  2 Jul 2019 22:15:13 -0400
Message-Id: <20190703021514.17727-38-sashal@kernel.org>
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
index 2628f3773ca8..ee24fea0eede 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -245,7 +245,11 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
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

