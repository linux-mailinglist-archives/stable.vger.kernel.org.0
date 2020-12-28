Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F17E2E402D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437879AbgL1Osi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441675AbgL1OWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E80F229C4;
        Mon, 28 Dec 2020 14:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165291;
        bh=gDMSkKdkI6DuwgGljiqXB6oVSHWFOZH1OMuzsX0sd3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxcLn54tm+T52zNvjH3fXEpVmF24GHvwZZu6s0f7CPjngvyU1AkLf8097kMuG0bFr
         PgTWwyK/xP2MkaF0ekyWSa0vcSbB/aifXweFlE3Y+bolRfRmL1ICDY086tvzPMX5pL
         AwyCT0a9zqAcIpnSMOaQ+lnFLdS6EK6LBOGSnAS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/717] mm: memcg/slab: fix use after free in obj_cgroup_charge
Date:   Mon, 28 Dec 2020 13:47:28 +0100
Message-Id: <20201228125042.539219061@linuxfoundation.org>
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

[ Upstream commit eefbfa7fd678805b38a46293e78543f98f353d3e ]

The rcu_read_lock/unlock only can guarantee that the memcg will not be
freed, but it cannot guarantee the success of css_get to memcg.

If the whole process of a cgroup offlining is completed between reading a
objcg->memcg pointer and bumping the css reference on another CPU, and
there are exactly 0 external references to this memory cgroup (how we get
to the obj_cgroup_charge() then?), css_get() can change the ref counter
from 0 back to 1.

Link: https://lkml.kernel.org/r/20201028035013.99711-2-songmuchun@bytedance.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 74b85077f89ad..a717728cc7b4a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3247,8 +3247,10 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * independently later.
 	 */
 	rcu_read_lock();
+retry:
 	memcg = obj_cgroup_memcg(objcg);
-	css_get(&memcg->css);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 
 	nr_pages = size >> PAGE_SHIFT;
-- 
2.27.0



