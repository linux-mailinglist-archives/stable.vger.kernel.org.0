Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040431B65A5
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgDWUkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F884C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:39 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t14so8219432wrw.12
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XjT8FKgJgcft6uI1Uy9gJhNC3h1sSpDRsugW2iwNbXU=;
        b=xyaFlLpEa1q0PjSV73CqdMlgWkMI76o2m72TO4+AP6xXBBvdyi8F+Ew4s42HKX5c4R
         CWkxjOC2xM922NJURmNKnDO3scIfRs4I1QRCisrn9XCRNZroyyy7075HJA/mbKcIibcI
         EL2IPd5wFO58NHfcApeGUOUs8DlUMclZQzHS8JvEhJUcyVMS+qGuzXjuIQDopROO0Zty
         iZMfRNNZC55+pelTZrWyQ7bsXvnoCTOmPH6rZ6evR5ZpWaGKU6MmVxOEJuj4XboXKt0r
         LbxUCtqVln4G/FrVWcx8DCe7ojSwezJiCmSU7adUFRDmF9wbrtN800VFNOeTzuoWozGt
         5qzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XjT8FKgJgcft6uI1Uy9gJhNC3h1sSpDRsugW2iwNbXU=;
        b=hCOXuvlkRDx6b4VUdSuo+m6qTRkFKObUAVLfktRCYx32LerNxakhSFVWnO8db09jc3
         keE9EMRtcpmS3V+tNIA4BIEVM9DartnhwssTStgttQ0M3dBqBGhHg6O7qXtr11tv0m7v
         0H1Z+bMa7Qj3oS/YgLeDcEWQtNzAxX0WRLSnVNIK5P/T+Y+oCsvRCpre7mzeD/GJwIfr
         7QzVEg/EHm3r329H5FHEwyUhusDv3vE3Etn5fR97L0yHBmQOJOIeHGpR5dY5axyWMHj1
         jzCLJaHp9LJdPcslIVrP8qSaVAi0hWSi9E8m5bwAHFb6Byz5QFrKpYb6Db4cwfGYSSxL
         lOUw==
X-Gm-Message-State: AGi0PuaLMriBSUxJWdoQImXLFQJBRUC4k6DIGapIbn3aGaGl/O8aqVBs
        eOBi38KdLb2HE7+DfzDPEJuYWcfLjc4=
X-Google-Smtp-Source: APiQypL3zyn4LGnRZqLGv0J7H4hG6JwdCj5KI12CdsUmKhzKUp5QQmRc7sW8OvH6ByCvw5Kmfx0DfA==
X-Received: by 2002:adf:f98e:: with SMTP id f14mr6876378wrr.253.1587674437985;
        Thu, 23 Apr 2020 13:40:37 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Roman Gushchin <guro@fb.com>, Roman Penyaev <rpenyaev@suse.de>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 16/16] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Thu, 23 Apr 2020 21:40:14 +0100
Message-Id: <20200423204014.784944-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 7ea362427c170061b8822dd41bafaa72b3bcb9ad ]

If !area->pages statement is true where memory allocation fails, area is
freed.

In this case 'area->pages = pages' should not executed.  So move
'area->pages = pages' after if statement.

[akpm@linux-foundation.org: give area->pages the same treatment]
Link: http://lkml.kernel.org/r/20190830035716.GA190684@LGEARND20B15
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 mm/vmalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c9e6fc6a5fefe..49f15a460a7b3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1593,7 +1593,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
@@ -1602,13 +1601,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
-	area->pages = pages;
-	if (!area->pages) {
+
+	if (!pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
 		return NULL;
 	}
 
+	area->pages = pages;
+	area->nr_pages = nr_pages;
+
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
-- 
2.25.1

