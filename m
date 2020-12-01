Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7792CAE58
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 22:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgLAV0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 16:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgLAV0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 16:26:36 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927D8C0613D4;
        Tue,  1 Dec 2020 13:25:56 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s63so1993924pgc.8;
        Tue, 01 Dec 2020 13:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6AH1ye9fcQ8nEEAvfgVavcXuDhAsKsHPZtAf/e+wA6w=;
        b=s1gOsSbNUBq/F4jbyfdn6LKmnFZ7L3RcucNI9foFNgpc7TbE239wWPabc3qM7xGtz5
         QEwcvuZFUgbc5HdHqVX2poAQ3dp5kTkBiYqtNI4izLeA3bZZVL8PHjKxi3aMkqcRKcpj
         y0aRYKU7o6OayWkMoNEjHCsM2dnfV/X77A4Aqm/mnaB7VPc7uJllfHlUONrWAHMa/eLl
         ZRqBfxg1BzQRNByJsv3tQ26zMEih64PLoBhvb9N2X+QWcIEIbkSJwtBZYRzUTNmhDOPA
         XNqyAQaWoX/ukxWZ2QxE4g2be8jtmAyWtWYhsfnfZ+bx4RrDl8OWlDxBkZ1K2bRJPpqL
         L8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6AH1ye9fcQ8nEEAvfgVavcXuDhAsKsHPZtAf/e+wA6w=;
        b=T3OkS9KA83Wnwbd2x5s9qCdJpp3R4JmxbwJqmtH5vS4x+dYs7Jl61lh21tSelscln1
         eEYyS5+cUy9mJBsy4INlcssmCLIOw06JrJ+Pwj8w54XgXx9CUkAKAG1IGCM3zfsREuQn
         i4RlE+/pT3mtagvbXbAlRCFw3iWLsg16WRoJFjYlQVw+70F7dNnxle6W02gvWvcCBFYQ
         yuY8W2mzyNjiXOE+d5tCT0M0NfqLAlV2Wg681BuLOkl6S9lM23sVPDRFqhswq6AbDC8t
         OE23o/f/fKDGd2tgDBq9/3QGD8PP57ukqj9O3tz9TY9SeAnzmxEJTrbYcNjwsIbWCKcF
         KOig==
X-Gm-Message-State: AOAM5331mrQp2DWMSXpmNqcljTUMtfzBWx/VG2OCvrR/0j5hctPDQAy6
        apZJXpAsLIgRoiHoX8za4nE=
X-Google-Smtp-Source: ABdhPJzZF8tDdP0ExXOYybudhGqHhffhrCgLWTD49FXQSd5GtdGgJF9fqTo4wtIyI71M11h8o0CBMw==
X-Received: by 2002:a65:66d3:: with SMTP id c19mr739264pgw.215.1606857956144;
        Tue, 01 Dec 2020 13:25:56 -0800 (PST)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id l141sm670433pfd.124.2020.12.01.13.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 13:25:55 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     guro@fb.com, ktkhai@virtuozzo.com, vdavydov.dev@gmail.com,
        shakeelb@google.com, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v3 PATCH] mm: list_lru: set shrinker map bit when child nr_items is not zero
Date:   Tue,  1 Dec 2020 13:25:53 -0800
Message-Id: <20201201212553.52164-1-shy828301@gmail.com>
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
                                     retrun SHRINK_EMPTY
                                     clear_bit
child memcg offline
    replace child's kmemcg_id to
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
                                     may return 0 conincidently

                                     keep the bit cleared
    dst->nr_items != 0
    skip set_bit
    add scr->nr_item to dst

After this point dst->nr_item may never go zero, so reparenting will not
set shrinker_map bit anymore.  And since there is no task under user
slice directly, so no new object will be added to its lru to set the
shrinker map bit either.  That bit is kept cleared forever.

How does list_lru_del() race with reparenting?  It is because
reparenting replaces childen's kmemcg_id to parent's without protecting
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
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org> v4.19+
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
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

