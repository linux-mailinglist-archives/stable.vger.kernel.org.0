Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936A8148212
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403842AbgAXLZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403836AbgAXLZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:25:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F6E206D4;
        Fri, 24 Jan 2020 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865102;
        bh=e/Q65EoOC/T9/Yf5HKWoSq1rPBPyrAcJUgEkmtb5s5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSiYHlIqp+c+fU1zADKD7lVwi5oZIjc3uWz+excug3FD+PS3nAhmSZMtOe4dEXz49
         4M4tV3aR4gNaIJw0gYtYGLLRtdhiDzbmvE8kiLbLgNjhcNSS5c7ilpHx2bHcP+13pH
         g4tXTkwv1syYBDUMArJDAr8x51s52nkM60hE9Grk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 454/639] fork,memcg: alloc_thread_stack_node needs to set tsk->stack
Date:   Fri, 24 Jan 2020 10:30:24 +0100
Message-Id: <20200124093144.002461222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1bd119530a492..1a2d18e98bf99 100644
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



