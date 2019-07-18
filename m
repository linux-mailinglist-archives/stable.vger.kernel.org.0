Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DDC6C79A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbfGRDZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389945AbfGRDFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:25 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C983204EC;
        Thu, 18 Jul 2019 03:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419124;
        bh=cMRELNw+IVtsFSkaR6gmehlYDl1+E35KaDgLU11yhAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPwqr8Ty0w/Y3Apy2LjkJBm9gkJc16ldKbBTPa0ILoHZ+7IUa8e69ol3Vl+bwgRhK
         HmjzYwjMeloI9G7afvQI9nx6o3N5NsyJUmxbgu5tqyrFHm3hZhqvbItHfFpXn8jcZ3
         48b8lonDR+iS7kZCJbExdM1aHx5OjHatZKjismB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 39/54] fork,memcg: alloc_thread_stack_node needs to set tsk->stack
Date:   Thu, 18 Jul 2019 12:01:34 +0900
Message-Id: <20190718030056.240131358@linuxfoundation.org>
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



