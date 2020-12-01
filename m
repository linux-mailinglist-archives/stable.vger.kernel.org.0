Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E7F2CAA10
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391075AbgLARpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 12:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388004AbgLARpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 12:45:33 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B8DC0613D4;
        Tue,  1 Dec 2020 09:44:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v21so1523192plo.12;
        Tue, 01 Dec 2020 09:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFsYFDq/Q3GPLL9fHJin91E11XSOnALUjdSBz3nDiTA=;
        b=OTSGIxRd7dTA/pzOwvu61LDGszj5Y/x28kE4X9ua7nZJLWHxRjdC4qhrvhGwzPigrF
         7w1cRGCEerHd/XfeY8NhH+WtoOkY+OFlV8MJMTKq+Iqak77coNF85BoqZ/t9GpQbQUb3
         Vk2FKbnlXsRNb4s10eH0mN4LNo5OjKp4mCrQEn03zlgoD1ss7EPN0YP7LGAs9W1io82v
         lE62vmBmq1Y+HKMibEzCxdiAqglk/vJ1zlKaQRDks9CStLmgpJw0cU+xFwyq3ashvD75
         SBpVp93c8xYtsxE9y7nGHy3bZU330lZtnHXaHyTdsgO+raTa6yWoJnA8s+4sx4ffUhUc
         iDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFsYFDq/Q3GPLL9fHJin91E11XSOnALUjdSBz3nDiTA=;
        b=ouYoVZPFx8DyQsNDRG8wkEAOBhhoLqi5Z+kiGgVjBQ+RFhEZRpbi41dHzgm/qBZkkA
         Pqwvfr/XEq/Ivz3hI2Wlg0ILoopEcw5UD0HsRXnAB0WA66vD4i72nssbTKA+zFVr9qPw
         Vrjl50q/zAhVF23CP2ys5gk+MmeCRfubfebo8ovHincEBLMTH/yXCKEiYdL6TlLvNuqS
         X9aco0d3qESh3h/jLpB0W3/6NXv2OQ1Kd9yVgEx2s/+jpfYAMbGYZZ+fKFT7TL3cI8FT
         35CSSmWfZwJBvx/cfKkUuq3YaXS4PJIWL6lHkizuT4iTaoD7jij97+lze6jGTxbmxifR
         GSjA==
X-Gm-Message-State: AOAM531E3VtVTa0FuE8Pg9vMhXPV7oDtSegy+oqQdTrvx6+ESlkf/jsl
        J0ePavLDGEPzWGvHwaEkTSM=
X-Google-Smtp-Source: ABdhPJxmK2BHuXRNN5yxjcSqY1P5lL9gpXhjrIzx+Vi5k0D3ei1oy1FgKl9Wed5mX419vdnx4aBW7A==
X-Received: by 2002:a17:90b:ec2:: with SMTP id gz2mr3897592pjb.143.1606844692537;
        Tue, 01 Dec 2020 09:44:52 -0800 (PST)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id p15sm360909pjg.21.2020.12.01.09.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 09:44:51 -0800 (PST)
From:   Yang Shi <shy828301@gmail.com>
To:     guro@fb.com, ktkhai@virtuozzo.com, vdavydov.dev@gmail.com,
        shakeelb@google.com, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v2 PATCH] mm: list_lru: set shrinker map bit when child nr_items is not zero
Date:   Tue,  1 Dec 2020 09:44:49 -0800
Message-Id: <20201201174449.51435-1-shy828301@gmail.com>
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

    CPU A                            CPU B                         CPU C
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
                                                                 list_lru_del()
                                                                     see parent's kmemcg_id
                                                                     dec dst->nr_items
reparent again
    dst->nr_items may go negative
    due to concurrent list_lru_del()
    on CPU C
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

Can we move kmemcg_id replacement after reparenting?  No, because the
race with list_lru_del() may result in negative src->nr_items, but it
will never be fixed.  So the shrinker may never return SHRINK_EMPTY then
keep the shrinker map bit set always.  The shrinker will be always
called for nonsense.

Can we synchronize list_lru_del() and reparenting?  Yes, it could be
done.  But it seems we need introduce a new lock or use nlru->lock.  But
it sounds complicated to move kmemcg_id replacement code under nlru->lock.
And list_lru_del() may be called quite often to exacerbate some hot
path, i.e. dentry kill.

Since it is impossible that dst->nr_items goes negative and
src->nr_items goes zero at the same time, so it seems we could set the
shrinker map bit iff src->nr_items != 0.  We could synchronize
list_lru_count_one() and reparenting with nlru->lock, but it seems
checking src->nr_items in reparenting is the simplest and avoids lock
contention.

Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
Suggested-by: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org> v4.19+
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
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

