Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5468B2009F4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbgFSNYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbgFSNYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:37 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6F3C0613F0
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z1so7140145qtn.2
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=46d1xNWzm/veCkXrmLXd2XOA6eel5z1TmUHG5VT9uhM=;
        b=BHOd5l6TG1flLxIFgp758XhqsMYXz5flD/uCDcLV7hqkH6Br+/1+ubSDElcCohWs3I
         0HFHntfAl9iIGO5fkz3IhocC2Wo0lNX1a5qOWKVnXQnCng5dbhmJ8eoruZ9X1CSIzM1E
         TwJtElRNqGKTi5LxiWI6aUoSTTNuvaKYJ/8DI6asxh2SP83gBkfdnemSwwi+NHqJeWIv
         Nn+CfDUoBZn7CLnHxEDGmDDwMgHZsXFvtzlbBbgZp3ZmjXiPG24cB56B6WAg9guf9Xdc
         1kf2D75cnig6LA1UcNZQZGqrzB0RqKF8wlHnqxTO1HRycNpj3Ehb46DFMdi2O1fpkqay
         D6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46d1xNWzm/veCkXrmLXd2XOA6eel5z1TmUHG5VT9uhM=;
        b=ba4vJtdDxswzLpkkXjzL9F4r4pu7bM4s2TrIsOxjx6cLjKxJGw7I+vyqSjiiz3Dnov
         +3bAfHB6HuO++S9ED4YcOccIXP67ZpyCOoA+O2N+yx6RAD1fBdv4hNuht0H9UD5AHhra
         8tDT9JkpeLM5CeRns2wMcYNTmdmjXhJUVU2AGp9YKpbqBXIBUtfmuvrfElrUocXGhhM6
         pW/deejyo4pXm0A5etrBl0Ki4GcKU9opS46ymvwv2pa5wn+kXkCuWG0F3JcTbN/HPNGI
         6aLSsUtN/T8Mg59hr6TzgC3RCFQbsVK1S0WVax7TZCPTcdxzZpC5juCuG+toDc2oQ6/r
         xfZA==
X-Gm-Message-State: AOAM533/Wxe7AaEDLhH8zbim6ngps5NeFUObLBjtc/jTP8r5QYo8fbKM
        WETxTsAeOxMFGMsPXqCpYaVOgrOrGG8=
X-Google-Smtp-Source: ABdhPJxlIK236nhod0z0R2oGrtuLIhou0iH8rzj8sE+8Xqa5P/AraWjFdhusundNqdUSAYKvwMtjSQ==
X-Received: by 2002:ac8:7413:: with SMTP id p19mr3331731qtq.387.1592573075402;
        Fri, 19 Jun 2020 06:24:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:34 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 6/7] mm: initialize deferred pages with interrupts enabled
Date:   Fri, 19 Jun 2020 09:24:24 -0400
Message-Id: <20200619132425.425063-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
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
---
 include/linux/mmzone.h |  6 ++++--
 mm/page_alloc.c        | 20 +++++++-------------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d6791e2df30a..fba0eee85392 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -636,8 +636,10 @@ typedef struct pglist_data {
 #endif
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 	/*
-	 * Must be held any time you expect node_start_pfn, node_present_pages
-	 * or node_spanned_pages stay constant.
+	 * Must be held any time you expect node_start_pfn,
+	 * node_present_pages, node_spanned_pages or nr_zones to stay constant.
+	 * Also synchronizes pgdat->first_deferred_pfn during deferred page
+	 * init.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 182f1198a406..05c27edbe076 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1644,6 +1644,13 @@ static int __init deferred_init_memmap(void *data)
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
@@ -1666,8 +1673,6 @@ static int __init deferred_init_memmap(void *data)
 		touch_nmi_watchdog();
 	}
 zone_empty:
-	pgdat_resize_unlock(pgdat, &flags);
-
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
@@ -1709,17 +1714,6 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 
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

