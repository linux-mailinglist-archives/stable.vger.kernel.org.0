Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7C2B637B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbgKQNig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732618AbgKQNi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5687F20870;
        Tue, 17 Nov 2020 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620306;
        bh=GH6uK6l6HEJSxpMYqN9TM0ijOWml2e28K2QeSufjeio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvylJbgw4X+aR1m28vQPHYzg/RBTYGPoUg+bgnWIUWGtQOFIwFACaeCa1zoHDxGFO
         NaE5Dcd3dqQT0jPGBvP3F5M+gz9fnjJ6qS+XbEC9SThSx+kJa8e5p1O5K43eVdwv6z
         jy+pPHN8T1qYh7GmIO6czQ3RdLUTC1wvteZ1XLcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 174/255] mm: memcontrol: fix missing wakeup polling thread
Date:   Tue, 17 Nov 2020 14:05:14 +0100
Message-Id: <20201117122147.393445197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 8b21ca0218d29cc6bb7028125c7e5a10dfb4730c ]

When we poll the swap.events, we can miss being woken up when the swap
event occurs.  Because we didn't notify.

Fixes: f3a53a3a1e5b ("mm, memcontrol: implement memory.swap.events")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Tejun Heo <tj@kernel.org>
Link: https://lkml.kernel.org/r/20201105161936.98312-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d0b036123c6ab..fa635207fe96d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -897,12 +897,19 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
+	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
+			  event == MEMCG_SWAP_FAIL;
+
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	cgroup_file_notify(&memcg->events_local_file);
+	if (!swap_event)
+		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		cgroup_file_notify(&memcg->events_file);
+		if (swap_event)
+			cgroup_file_notify(&memcg->swap_events_file);
+		else
+			cgroup_file_notify(&memcg->events_file);
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
-- 
2.27.0



