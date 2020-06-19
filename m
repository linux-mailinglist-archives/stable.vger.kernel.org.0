Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317422009EF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbgFSNYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731869AbgFSNYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C7AC0613EF
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:35 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q198so1027117qka.2
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=V0D9xk3SI/T+CK0VAFMcSpiPR6QOFoVjZ9Qrcy//Ru8=;
        b=ZmEn8W2rf0qhXWjz+lLdOuHloLGq0rbzXdEXswVZ7JTHztTvATDl8Cnt4BYbA3VNbW
         u5aOVw3bL1fQwRkIzcp6yxMz2rw6pZuKBau18aMkZS5PfjLD7bgnfhvMjR/qLaNW3RIC
         F6W9QDSPU21u1FgheX/nsD2cgfXBOqL1/3gJqV2pMAfRxmtQmyX5yviXPGfw9x8fvaie
         FHt1DOrSkmAe8wVs0LsyFWfxdW8sKKcCgRmfo6zPhPXsdyApvQkhvSA7agiapPSEPuDa
         eQnWBBtMvj2rhnrOPaX/l8LuSBV45pa1CoFdfz3dpXEkzqZKZzq3vcEbbEIK3OwzrTqz
         22/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V0D9xk3SI/T+CK0VAFMcSpiPR6QOFoVjZ9Qrcy//Ru8=;
        b=PSUct0vDc4e2iuYu2993I7u1R/xSMMbGMS8W+KXhmYzYxu3kncG0loI95oDGmIGTD0
         qqnmE4bKyzwcLXlffycjnyatpcLgkxF6sSZe28zX1gzVghf6XGg5CmqhcU0DRiR2q1b+
         GlPxiVWie6y+CuHwyviYRlceqhQl9Ou+bKemOfu/JC0JMJ3GhbMGk2chuHrDZ4sIuMMX
         wavgU9PMFha5DMloe98rLephl6blOoP9ovs/UpVz4Hi37xhXoWsB+TeOleGWPdRmGeA7
         byAbfeMYnVLR2ShR56IjzcvDXdWagA5zkmTTfZUHkL3fcypW1vMfeTnNfvVKCjs7xEi6
         fdGg==
X-Gm-Message-State: AOAM5325kUqNACLKGpN3ut4sqV5Afze8zMQ4zPQs5jAodDbqv0m2SD7p
        NbWRP8DRZLYOTBRa8IvhRiQsnAtn/Uc=
X-Google-Smtp-Source: ABdhPJzEDKYkRbnpMX1nwnzbjFhQhbIAoJoyJGTooKk6d0wZzB70o392Vyan/IxQFKDb3uFsmpKgqA==
X-Received: by 2002:a05:620a:8c1:: with SMTP id z1mr3344438qkz.431.1592573074019;
        Fri, 19 Jun 2020 06:24:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:33 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 5/7] mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init
Date:   Fri, 19 Jun 2020 09:24:23 -0400
Message-Id: <20200619132425.425063-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
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
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
---
 mm/page_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2821e9824831..182f1198a406 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1493,7 +1493,6 @@ static void __init deferred_free_pages(unsigned long pfn,
 		} else if (!(pfn & nr_pgmask)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
-			touch_nmi_watchdog();
 		} else {
 			nr_free++;
 		}
@@ -1523,7 +1522,6 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 			continue;
 		} else if (!page || !(pfn & nr_pgmask)) {
 			page = pfn_to_page(pfn);
-			touch_nmi_watchdog();
 		} else {
 			page++;
 		}
@@ -1663,8 +1661,10 @@ static int __init deferred_init_memmap(void *data)
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
 
@@ -1748,6 +1748,7 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 		first_deferred_pfn = spfn;
 
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
 
 		/* We should only stop along section boundaries */
 		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
-- 
2.25.1

