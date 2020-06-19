Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C42008A3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 14:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgFSM0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733069AbgFSM0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 08:26:00 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFDBC0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:26:00 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k22so6971461qtm.6
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ErDRtNWur6DlOtsZhKoZCJU3PRzonhjDRYyrv/aOiFQ=;
        b=cFPJAn4rXWULJpdZyS3C16cxHfkDSaZx3o/BMXB+qB1YRxHyOumPp18gWAiQGV7S4D
         eewwcp1CA+GDR5RcKuYBLUUpLyPO6V3g+O2hxxI8fqm2E+oqGfBAlVy8upDGHoycEA4J
         HgoNskACJ0kyqAL+w1cBeJvQocDhB5ejAj5xsTW5UxdwRT4o6HJniGiadTu9DIquIV6r
         ud5yFHzKRgch4M3+UIKaVa/olu8EFQhL9MZ7GqkiK5q3T1CPAt2klyllyPVtuSVEGFVF
         t/29+QI/9cA86XcY361mO5D7yg1iv7p2MkzN2NpAOEypnsvyLyoUjVfvd3WlA8DncUVc
         R7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ErDRtNWur6DlOtsZhKoZCJU3PRzonhjDRYyrv/aOiFQ=;
        b=D3YMEd5HoR6/WkzwOvQdsb0Ql1GTKgtcMEOzXy7yxoWyUR3p1dmrly7kqZyQOIVTgJ
         tSAY7iB/z+z6wkefCISJkxI9smfO+o4H41GKZaTZHjk6RJ+45qYG//2cpyHLElydLkNj
         heYerfKkW/ry5MBkMj/+Vuqprk1NwGErcpgT5vbT++bfq3j+rfFcAhHBEVYBJfYxGscs
         SKDk7oetZ7EzVuHV7IkW9uahpUKkZUiXg4mGTqXNZpcIOYUf7miGpgY4C264n4et74Eo
         XWRcSnjIO+cSREUHgFT02IORAINdY41Js+UgfC3oBdhp/FY61w7cvI6jMp3HurIf7pLg
         1LSw==
X-Gm-Message-State: AOAM530YSWDrs18VyPs4QP+dhi68Iy0gWEV5nMYmj1weCuU+lJHlgKYS
        AQIGAW3fejYS+9wkXAw9ptIc3dZYLMk=
X-Google-Smtp-Source: ABdhPJzegsplnGxXQRuYhVhddvzOpciOLnpyAXSVgTbT03iOg6GD7adz+Kg5DHqu7wIF0lebX8fwDg==
X-Received: by 2002:aed:29c3:: with SMTP id o61mr3100734qtd.15.1592569559494;
        Fri, 19 Jun 2020 05:25:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id z77sm6519818qka.59.2020.06.19.05.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 05:25:58 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 2/3] mm: initialize deferred pages with interrupts enabled
Date:   Fri, 19 Jun 2020 08:25:54 -0400
Message-Id: <20200619122555.372957-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619122555.372957-1-pasha.tatashin@soleen.com>
References: <20200619122555.372957-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

commit da97f2d56bbd880b4138916a7ef96f9881a551b2 upstream.

Initializing struct pages is a long task and keeping interrupts disabled
for the duration of this operation introduces a number of problems.

1. jiffies are not updated for long period of time, and thus incorrect time
   is reported. See proposed solution and discussion here:
   lkml/20200311123848.118638-1-shile.zhang@linux.alibaba.com
2. It prevents farther improving deferred page initialization by allowing
   intra-node multi-threading.

We are keeping interrupts disabled to solve a rather theoretical problem
that was never observed in real world (See 3a2d7fa8a3d5).

Let's keep interrupts enabled. In case we ever encounter a scenario where
an interrupt thread wants to allocate large amount of memory this early in
boot we can deal with that by growing zone (see deferred_grow_zone()) by
the needed amount before starting deferred_init_memmap() threads.

Before:
[    1.232459] node 0 initialised, 12058412 pages in 1ms

After:
[    1.632580] node 0 initialised, 12051227 pages in 436ms

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-3-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 3d060856adfc59afb9d029c233141334cfaba418)
---
 include/linux/mmzone.h |  2 ++
 mm/page_alloc.c        | 20 +++++++-------------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1b9de7d220fb..6196fd16b7f4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -678,6 +678,8 @@ typedef struct pglist_data {
 	/*
 	 * Must be held any time you expect node_start_pfn,
 	 * node_present_pages, node_spanned_pages or nr_zones to stay constant.
+	 * Also synchronizes pgdat->first_deferred_pfn during deferred page
+	 * init.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7130e4445d3..b03da51dee5d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1843,6 +1843,13 @@ static int __init deferred_init_memmap(void *data)
 	BUG_ON(pgdat->first_deferred_pfn > pgdat_end_pfn(pgdat));
 	pgdat->first_deferred_pfn = ULONG_MAX;
 
+	/*
+	 * Once we unlock here, the zone cannot be grown anymore, thus if an
+	 * interrupt thread must allocate this early in boot, zone must be
+	 * pre-grown prior to start of deferred page initialization.
+	 */
+	pgdat_resize_unlock(pgdat, &flags);
+
 	/* Only the highest zone is deferred so find it */
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 		zone = pgdat->node_zones + zid;
@@ -1865,8 +1872,6 @@ static int __init deferred_init_memmap(void *data)
 		touch_nmi_watchdog();
 	}
 zone_empty:
-	pgdat_resize_unlock(pgdat, &flags);
-
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
@@ -1908,17 +1913,6 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 
 	pgdat_resize_lock(pgdat, &flags);
 
-	/*
-	 * If deferred pages have been initialized while we were waiting for
-	 * the lock, return true, as the zone was grown.  The caller will retry
-	 * this zone.  We won't return to this function since the caller also
-	 * has this static branch.
-	 */
-	if (!static_branch_unlikely(&deferred_pages)) {
-		pgdat_resize_unlock(pgdat, &flags);
-		return true;
-	}
-
 	/*
 	 * If someone grew this zone while we were waiting for spinlock, return
 	 * true, as there might be enough pages already.
-- 
2.25.1

