Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D667C13E2AF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgAPQ5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgAPQ5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F9824656;
        Thu, 16 Jan 2020 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193858;
        bh=2ORim8Gw6y+bmu+5x5k72nRgq8wbF79nDQI30E8GLT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPS+JBy+Jv8U5PBu929m44qExknZs5B/l5iXVWng3Dhu5O2yn/MX67rOCStdo9mcs
         ghi8AjtZDp01GB4HLNFImOuRFUz1gQUj4j6DtFRdbqUC8ZmhXRmvPSnonQ/LQDHITP
         DlnIb/V3O2i+6ecfcwVwooBfjYZRfQNK8TJRzt3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 107/671] fork, memcg: fix cached_stacks case
Date:   Thu, 16 Jan 2020 11:45:38 -0500
Message-Id: <20200116165502.8838-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit ba4a45746c362b665e245c50b870615f02f34781 ]

Commit 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
memcg charge fail") fixes a crash caused due to failed memcg charge of
the kernel stack.  However the fix misses the cached_stacks case which
this patch fixes.  So, the same crash can happen if the memcg charge of
a cached stack is failed.

Link: http://lkml.kernel.org/r/20190102180145.57406-1-shakeelb@google.com
Fixes: 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on memcg charge fail")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5718c5decc55..1bd119530a49 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -216,6 +216,7 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 		memset(s->addr, 0, THREAD_SIZE);
 
 		tsk->stack_vm_area = s;
+		tsk->stack = s->addr;
 		return s->addr;
 	}
 
-- 
2.20.1

