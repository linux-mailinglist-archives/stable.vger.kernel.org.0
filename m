Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1B160464
	for <lists+stable@lfdr.de>; Sun, 16 Feb 2020 15:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgBPOxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Feb 2020 09:53:03 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37933 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgBPOxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Feb 2020 09:53:02 -0500
Received: by mail-pj1-f65.google.com with SMTP id j17so6070735pjz.3
        for <stable@vger.kernel.org>; Sun, 16 Feb 2020 06:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uTrfCCTzwmDGorzNe6SDOvqoePQqHhkw4MOPZZ+3oow=;
        b=Oll20V6ldVBPGVrKV3WkA5Tqj1qlmz4EaNLvHBZdUwjwKAgzsHYy/OLmp9/p0rMXuV
         tLhBzl5x9DvL2HeVLPWV8OWN/ORwuSZBcITQ/n1jKOw634lHaWx0zlBR7KsCAfx1Gx2n
         nKV/Favxc52Qj7tNHa4kEue/UcbRRctl5D3CNe3hpYaPVDUhKeJRqQBCj42cq/WtGh41
         C103WrkvOk77Vvvntb08QNeu2LQFbXoeoNfLzxIX7x/51mRO6RIOPCgbgM8Mgu/Ib2Ya
         evoazV2qi/Sne/mlqQtwa4PmoMVUhEZ+Q99jdzvYpS+cqSYDO6dt448yJVsUQyZSGLUO
         wbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uTrfCCTzwmDGorzNe6SDOvqoePQqHhkw4MOPZZ+3oow=;
        b=L4akzIXmCNOP+CZZD85eTn70dhN8WnUgBZCwlHXBBdsrb+N1yetTbo2yPzFVRAxvFC
         iqWwGRYKcZzHdkSKIhEMEJPrq4b2MJ3fORr4QRj41tKTuvnVkRxxlebl8xE6qWxDGCo2
         R7UEaoaaKYeIUokGCqR0ZYjPulodN5YiYCSzTUd3Pg53u4563YYdwAM8uLFHSVPZPxJl
         wD+I9CuVwnVKqJLRSkRECy0x9CI0xtGxODgkX+gNYQndZ/L+rnm//YPIEYB7eXwH7PQh
         bawrCwqP4lDS5i9M/UVs5eb1+1yhS0Zm2iTWiN8KIJ58ZOMECUAEf6Plokw4PvdxJbvE
         /3zg==
X-Gm-Message-State: APjAAAXPPbUCSKa+VP3WqSUZjIYrtIdJqr68hchZDImvIrunfoEt55fw
        SsfILnqlUitm+FBoyriN2ow=
X-Google-Smtp-Source: APXvYqw+5h9pi+c9mHEM/Eva36Sgq5EJjrRx1Qg0lPWybD+CfFuEWt2rcDr2OR591D4J+5bPwu6+eg==
X-Received: by 2002:a17:90a:bf81:: with SMTP id d1mr14651583pjs.21.1581864782138;
        Sun, 16 Feb 2020 06:53:02 -0800 (PST)
Received: from snappy-silo-1.localdomain (107.182.183.158.16clouds.com. [107.182.183.158])
        by smtp.gmail.com with ESMTPSA id x25sm13471428pfp.30.2020.02.16.06.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 06:53:01 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        chris@chrisdown.name
Cc:     linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for reclaiming itself
Date:   Sun, 16 Feb 2020 09:52:49 -0500
Message-Id: <20200216145249.6900-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.18.2
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
them won't be changed until next recalculation in this function. After
either or both of them are set, the next reclaimer to relcaim this memcg
may be a different reclaimer, e.g. this memcg is also the root memcg of
the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
the old values of them will be used to calculate scan count, that is not
proper. We should reset them to zero in this case.

Here's an example of this issue.

    root_mem_cgroup
         /
        A   memory.max=1024M memory.min=512M memory.current=800M

Once kswapd is waked up, it will try to scan all MEMCGs, including
this A, and it will assign memory.emin of A with 512M.
After that, A may reach its hard limit(memory.max), and then it will
do memcg reclaim. Because A is the root of this reclaimer, so it will
not calculate its memory.emin. So the memory.emin is the old value
512M, and then this old value will be used in
mem_cgroup_protection() in get_scan_count() to get the scan count.
That is not proper.

Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: stable@vger.kernel.org
---
 mm/memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6f6dc8712e39..df7fedbfc211 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6250,8 +6250,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 
 	if (!root)
 		root = root_mem_cgroup;
-	if (memcg == root)
+	if (memcg == root) {
+		/*
+		 * Reset memory.(emin, elow) for reclaiming the memcg
+		 * itself.
+		 */
+		if (memcg != root_mem_cgroup) {
+			memcg->memory.emin = 0;
+			memcg->memory.elow = 0;
+		}
 		return MEMCG_PROT_NONE;
+	}
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
-- 
2.14.1

