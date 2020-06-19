Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BA2008A4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFSM0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733063AbgFSMZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 08:25:59 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00CFC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:25:58 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er17so4323677qvb.8
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kw6dC+AwL0270Qh6aBSl6rxU82P9FZlXOVi7O4a23y8=;
        b=Y1aWKKDhKY+RSfaQQ3Jn8lOUjdX22c7tKA8B8H+ufdGf7smGVWXkoqIKR2dXKRnt5V
         i8OvMgAZrmiFbFZ9P9EYo6d1e8BehgSylM9tNrl0fBp3fTy2/xQg7mhGjZqNpApfyLaH
         shZ12aujLTihwnRs5dBgURcD1PcD10EeYEXstRMpyhNH61hBcJHa4NSKTjkef3TCM/lQ
         pZwTW53grP+gPoiujjS4Rojbz0QndWkCwmfM3n1FoiutkJvARq8FBfkUFxGgoETMmHNi
         WdlkXuxqmSkBv+3W2qC4F8aSY4lxm96gckYZaAdCDsbs5FvHwCsIKZO0oHpEd6Z/zy5r
         g4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kw6dC+AwL0270Qh6aBSl6rxU82P9FZlXOVi7O4a23y8=;
        b=UFfKhUKmq0mKUSeO+UR/LWmsG1113RPYF/to1DTakxVNwUHnxBpTVd6jric/2UV0kk
         iGLqTGdxJtFI01m/i4J3DuTxxLtDMzEBseKnJs8iinJnnKwzAfXatDqUHlrqrTOwBiJx
         B9YbDuc9C83iFDacSXJhZM2VHL5kYbGcSkHQYZunRcwWdtpF4qDsa7nJCX95xjNfnIjG
         5g0RzFE3tiRD+zEEsBY5qG2V0SxDqcMwDy1CddWd29AM4GNSWytwlNWrjjA57jzgs2/h
         6xYJ7lsLgarH/mVWLJsPGonrGVZqFIp4hSfb1+NJlPaFIapf+Ys9d6cIjM2qU9Oe+iBI
         yaCg==
X-Gm-Message-State: AOAM531YjoiHPITz4j8sJDAvtZUwEYLMOtnROEuxZDasSaOxba4C9sKT
        1ZrFTu/v5MJs7pWaTYtzIHGiwBKVTA8=
X-Google-Smtp-Source: ABdhPJwB+FtxBO06pXuncWvlXCrg11+xFqDCvaxZZZbzhQ/vwm37W8AnZvhxlSiOFjZ3WZWFU3GjRQ==
X-Received: by 2002:a05:6214:1812:: with SMTP id o18mr8639970qvw.194.1592569557811;
        Fri, 19 Jun 2020 05:25:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id z77sm6519818qka.59.2020.06.19.05.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 05:25:56 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 1/3] mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init
Date:   Fri, 19 Jun 2020 08:25:53 -0400
Message-Id: <20200619122555.372957-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 117003c32771df617acf66e140fbdbdeb0ac71f5 upstream.

Patch series "initialize deferred pages with interrupts enabled", v4.

Keep interrupts enabled during deferred page initialization in order to
make code more modular and allow jiffies to update.

Original approach, and discussion can be found here:
 http://lkml.kernel.org/r/20200311123848.118638-1-shile.zhang@linux.alibaba.com

This patch (of 3):

deferred_init_memmap() disables interrupts the entire time, so it calls
touch_nmi_watchdog() periodically to avoid soft lockup splats.  Soon it
will run with interrupts enabled, at which point cond_resched() should be
used instead.

deferred_grow_zone() makes the same watchdog calls through code shared
with deferred init but will continue to run with interrupts disabled, so
it can't call cond_resched().

Pull the watchdog calls up to these two places to allow the first to be
changed later, independently of the second.  The frequency reduces from
twice per pageblock (init and free) to once per max order block.

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: James Morris <jmorris@namei.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-2-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 13cc653122b7..f7130e4445d3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1692,7 +1692,6 @@ static void __init deferred_free_pages(unsigned long pfn,
 		} else if (!(pfn & nr_pgmask)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
-			touch_nmi_watchdog();
 		} else {
 			nr_free++;
 		}
@@ -1722,7 +1721,6 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 			continue;
 		} else if (!page || !(pfn & nr_pgmask)) {
 			page = pfn_to_page(pfn);
-			touch_nmi_watchdog();
 		} else {
 			page++;
 		}
@@ -1862,8 +1860,10 @@ static int __init deferred_init_memmap(void *data)
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn)
+	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
+	}
 zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
@@ -1947,6 +1947,7 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 		first_deferred_pfn = spfn;
 
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
 
 		/* We should only stop along section boundaries */
 		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
-- 
2.25.1

