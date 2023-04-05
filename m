Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD21A6D8657
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 20:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbjDESyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 14:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjDESye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 14:54:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FDF3A9E
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 11:54:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54bfe7a161eso13738297b3.8
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 11:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680720871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oB2sMXwt0v6x8lwXtmYlxh/hoioeozIJIVJcuuQJKWA=;
        b=Ros0vevjUiwI3/TjUKg+KCeA5SHnfksHcC4OK3M0Fn4fXpXuUrynI6b8MaR9/c3jSk
         kYtK4Ske7kxweFphiQTIVIVAbS/Fuv7jZA8Wq1GWNo0oxzQ5Nh5pojz9jDp+do2ph3Jj
         IztRjzkxwy2vWa3oGo525fcM6H4ZEmqQU6p4rYHtfJsYsBqy2LUHEZvuMUuNIKTo/uqK
         Xwb0LLWXZaQYVo8lUIEKsrrCdSMMCxNVxpuQ+1xdxcKxOZL6ys2NO41rWyag1l5oLhzt
         LVX/O/QEV66s0ajoxgyOizIIfKMnIekWa445aOdc74s+Q8ItuYHAsLFXOFgFRUjGTZ12
         4y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680720871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oB2sMXwt0v6x8lwXtmYlxh/hoioeozIJIVJcuuQJKWA=;
        b=g03IJobv7zrZMh+TWZXmFv4S276ZVdnNdtHSKOzJN5aSD1WweVnKVhgi+l6zGiDCkv
         EUT3vXC0nuy38Nq2IUEZiZfP+r6TzIhhZfeYw/joEmOArzea3Jrd8SUSlbRdS+kG4hLx
         OrytcTJ9HcHmr+RE+OQ2dFS9I2QpjJkqYqjgnXzx1Ks2U1yw+iZBmyuhudhADXz8IFBS
         aaC6Kkwsn3keQEuEdNNU1ivtSy6qRCL3xMI+s6bixMQA4a48GnXs0hXvL6AFWMra/x56
         KqU9cQJuopYCnGjxhDxbPcO+23dY9bxvLcTTQQQ74ZoLTNeCjmC6cUiZwhISYvIzgct0
         1fZQ==
X-Gm-Message-State: AAQBX9fqqxCVF7GzGdtkMaI2jFBoW2CdYJofQFdBz0r7Cmoazaqrk8tJ
        vWubz7o2BY5dWrXO9nfq2TUL4HtVxlZE7qNn
X-Google-Smtp-Source: AKy350ZCAIete9IDtcJDwB8xbNQZBALRdtx0fEvZ0QLo3PyT+UesbYmBb8Uc0roxQG5ktSucSqhPRJ3viu7kH1ie
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a25:d986:0:b0:b8b:eea7:525c with SMTP
 id q128-20020a25d986000000b00b8beea7525cmr163875ybg.9.1680720871655; Wed, 05
 Apr 2023 11:54:31 -0700 (PDT)
Date:   Wed,  5 Apr 2023 18:54:26 +0000
In-Reply-To: <20230405185427.1246289-1-yosryahmed@google.com>
Mime-Version: 1.0
References: <20230405185427.1246289-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405185427.1246289-2-yosryahmed@google.com>
Subject: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We keep track of different types of reclaimed pages through
reclaim_state->reclaimed_slab, and we add them to the reported number
of reclaimed pages.  For non-memcg reclaim, this makes sense. For memcg
reclaim, we have no clue if those pages are charged to the memcg under
reclaim.

Slab pages are shared by different memcgs, so a freed slab page may have
only been partially charged to the memcg under reclaim.  The same goes for
clean file pages from pruned inodes (on highmem systems) or xfs buffer
pages, there is no simple way to currently link them to the memcg under
reclaim.

Stop reporting those freed pages as reclaimed pages during memcg reclaim.
This should make the return value of writing to memory.reclaim, and may
help reduce unnecessary reclaim retries during memcg charging.  Writing to
memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
for this case we want to include any freed pages, so use the
global_reclaim() check instead of !cgroup_reclaim().

Generally, this should make the return value of
try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.g.
freed a slab page that was mostly charged to the memcg under reclaim),
the return value of try_to_free_mem_cgroup_pages() can be underestimated,
but this should be fine. The freed pages will be uncharged anyway, and we
can charge the memcg the next time around as we usually do memcg reclaim
in a retry loop.

The next patch performs some cleanups around reclaim_state and adds an
elaborate comment explaining this to the code. This patch is kept
minimal for easy backporting.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: stable@vger.kernel.org
---

global_reclaim(sc) does not exist in kernels before 6.3. It can be
replaced with:
!cgroup_reclaim(sc) || mem_cgroup_is_root(sc->target_mem_cgroup)

---
 mm/vmscan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c1c5e8b24b8f..c82bd89f90364 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5346,8 +5346,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
 			   sc->nr_reclaimed - reclaimed);
 
-	sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
-	current->reclaim_state->reclaimed_slab = 0;
+	if (global_reclaim(sc)) {
+		sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
+		current->reclaim_state->reclaimed_slab = 0;
+	}
 
 	return success ? MEMCG_LRU_YOUNG : 0;
 }
@@ -6472,7 +6474,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	shrink_node_memcgs(pgdat, sc);
 
-	if (reclaim_state) {
+	if (reclaim_state && global_reclaim(sc)) {
 		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 		reclaim_state->reclaimed_slab = 0;
 	}
-- 
2.40.0.348.gf938b09366-goog

