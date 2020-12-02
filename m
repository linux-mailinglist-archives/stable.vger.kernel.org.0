Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E72CC34F
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 18:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgLBRSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 12:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgLBRSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 12:18:39 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493F6C0613CF;
        Wed,  2 Dec 2020 09:17:53 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n10so1306236pgv.8;
        Wed, 02 Dec 2020 09:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j95XgfQyD6IQevO7Sfx6Snpqb0qU+IHRMy1OGEHjQN0=;
        b=qPtUq62KAwgpe+xUnOaenURzwNPWmOmyNaI1oPkvd3gGD4Q3WpKszXuK9G4l+uAmMy
         Efkk0tUgtIhPfRYrZi/iFxiRkJGJFcgMwKZr831DLYyzGd17wX3yDjpuIl6ynoNOWG4F
         k0O/9Tc048UCjrh1/sHDQWXOb3LkGV+Fc35YXaeiYRvK6Ljbr7BYQXMxLTa5Ned+u/+U
         YXh5taabnZqzpSV3gGQNxXtfrHKnLUV0hkl5XpJVBozdvsAcyIGQmQqSqzwxYwGonlfs
         j3VdvgD7TO1qQWA8SZ9BylmAPvAAhiqTnx5w+Q0i+Rb5n9BYXzRIOfyogSxif0nPoksV
         3opQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j95XgfQyD6IQevO7Sfx6Snpqb0qU+IHRMy1OGEHjQN0=;
        b=ihy4dyzyMvzJ+XchVFpuc7sx5Q0QEyVlDzoWnkWdTQWCwJoM43A62HyUzpe6Ys2U4G
         pmwz4yrZOShGv/G/p2l+lQIijhZYfgrvccu5gWzwtTfzJQ+Yq6bQ6PUDzaivZJdmPETm
         9m5TU9ZbhPDM+Pe7T3425n2iyC8eXW6z6Vl++ZxnqaSohq2M/BXTRj5QyTvZpjuspvhs
         xl/7a9fYZkzoXxjYSx6Y6fmkQhbjAiLxfCwIz+TE7tprZUnXivoV8WYyTzpo6hn8Pr/w
         59dc2K2srHP1hXsF5U7jdxlN5qfbv9fIjEqagLXSxcH4aaXy/01mQP+1vIC7POJfXBzR
         JTTQ==
X-Gm-Message-State: AOAM532rmkkGRvVoDlUxNyuyeQC6Nde59tZndVMa/xgYV6/RVmUZ58Qo
        agQZghB4KlgqGAqbiQD2bWY=
X-Google-Smtp-Source: ABdhPJy4s49K0W2g2rcdA8qvIkrcUY5cCSwuuVjlQGkUvI14t6dFCmASfNvG19Ytc1CUKH9/wc5mRA==
X-Received: by 2002:a63:ff5d:: with SMTP id s29mr791475pgk.290.1606929472793;
        Wed, 02 Dec 2020 09:17:52 -0800 (PST)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id w63sm502454pfc.20.2020.12.02.09.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:17:51 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     guro@fb.com, ktkhai@virtuozzo.com, shakeelb@google.com,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v4 PATCH] mm: list_lru: set shrinker map bit when child nr_items is not zero
Date:   Wed,  2 Dec 2020 09:17:49 -0800
Message-Id: <20201202171749.264354-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When investigating a slab cache bloat problem, significant amount of
negative dentry cache was seen, but confusingly they neither got shrunk
by reclaimer (the host has very tight memory) nor be shrunk by dropping
cache.  The vmcore shows there are over 14M negative dentry objects on lru,
but tracing result shows they were even not scanned at all.  The further
investigation shows the memcg's vfs shrinker_map bit is not set.  So the
reclaimer or dropping cache just skip calling vfs shrinker.  So we have
to reboot the hosts to get the memory back.

I didn't manage to come up with a reproducer in test environment, and the
problem can't be reproduced after rebooting.  But it seems there is race
between shrinker map bit clear and reparenting by code inspection.  The
hypothesis is elaborated as below.

The memcg hierarchy on our production environment looks like:
                root
               /    \
          system   user

The main workloads are running under user slice's children, and it creates
and removes memcg frequently.  So reparenting happens very often under user
slice, but no task is under user slice directly.

So with the frequent reparenting and tight memory pressure, the below
hypothetical race condition may happen:

       CPU A                            CPU B
reparent
    dst->nr_items == 0
                                 shrinker:
                                     total_objects == 0
    add src->nr_items to dst
    set_bit
                                     return SHRINK_EMPTY
                                     clear_bit
child memcg offline
    replace child's kmemcg_id with
    parent's (in memcg_offline_kmem())
                                  list_lru_del() between shrinker runs
                                     see parent's kmemcg_id
                                     dec dst->nr_items
reparent again
    dst->nr_items may go negative
    due to concurrent list_lru_del()

                                 The second run of shrinker:
                                     read nr_items without any
                                     synchronization, so it may
                                     see intermediate negative
                                     nr_items then total_objects
                                     may return 0 coincidently

                                     keep the bit cleared
    dst->nr_items != 0
    skip set_bit
    add scr->nr_item to dst

After this point dst->nr_item may never go zero, so reparenting will not
set shrinker_map bit anymore.  And since there is no task under user
slice directly, so no new object will be added to its lru to set the
shrinker map bit either.  That bit is kept cleared forever.

How does list_lru_del() race with reparenting?  It is because
reparenting replaces children's kmemcg_id to parent's without protecting
from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
actually deleting items from child's lru, but dec'ing parent's nr_items,
so the parent's nr_items may go negative as commit
2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
free kmemcg_id on css offline") says.

Since it is impossible that dst->nr_items goes negative and
src->nr_items goes zero at the same time, so it seems we could set the
shrinker map bit iff src->nr_items != 0.  We could synchronize
list_lru_count_one() and reparenting with nlru->lock, but it seems
checking src->nr_items in reparenting is the simplest and avoids lock
contention.

Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
Suggested-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org> v4.19+
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
v4: * Fixed the spelling errors found by Shakeel
    * Added ack/review tag from Kirill and Shakeel
v3: * Revised commit log per Roman's suggestion
    * Added Roman's reviewed-by tag
v2: * Incorporated Roman's suggestion
    * Incorporated Kirill's suggestion
    * Changed the subject of patch to get align with the new fix
    * Added fixes tag
 mm/list_lru.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 5aa6e44bc2ae..fe230081690b 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -534,7 +534,6 @@ static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
 	struct list_lru_node *nlru = &lru->node[nid];
 	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *src, *dst;
-	bool set;
 
 	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
@@ -546,11 +545,12 @@ static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
 	dst = list_lru_from_memcg_idx(nlru, dst_idx);
 
 	list_splice_init(&src->list, &dst->list);
-	set = (!dst->nr_items && src->nr_items);
-	dst->nr_items += src->nr_items;
-	if (set)
+
+	if (src->nr_items) {
+		dst->nr_items += src->nr_items;
 		memcg_set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
-	src->nr_items = 0;
+		src->nr_items = 0;
+	}
 
 	spin_unlock_irq(&nlru->lock);
 }
-- 
2.26.2

