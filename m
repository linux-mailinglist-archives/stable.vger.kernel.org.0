Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0262E3DF4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438153AbgL1OWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438156AbgL1OWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 582B42063A;
        Mon, 28 Dec 2020 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165289;
        bh=gnELdCjELm98NJSssu0Y6p/tT9x6O8zCKJr0XYtKegc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwMx1nf+BTK74P0qGNDeMa1Qnh0B8NYo/44IFeZ3gWRpC9JFLSWrf8i1iDBY1FhuD
         oGqcBeZ7xbBooNOYmq+678E8BEiV+PQKyaFyx7nKciaxtjtrylzbO8diHhnG6mWlUe
         hi5/vyIL8YMxNNlWf4pmHmEjN67iPJdVj6GW5uyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Adrian Reber <areber@redhat.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/717] mm: memcg/slab: fix return of child memcg objcg for root memcg
Date:   Mon, 28 Dec 2020 13:47:27 +0100
Message-Id: <20201228125042.489584214@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 2f7659a314736b32b66273dbf91c19874a052fde ]

Consider the following memcg hierarchy.

                    root
                   /    \
                  A      B

If we failed to get the reference on objcg of memcg A, the
get_obj_cgroup_from_current can return the wrong objcg for the root
memcg.

Link: https://lkml.kernel.org/r/20201029164429.58703-1-songmuchun@bytedance.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Adrian Reber <areber@redhat.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29459a6ce1c7a..74b85077f89ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2987,6 +2987,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
+		objcg = NULL;
 	}
 	rcu_read_unlock();
 
-- 
2.27.0



