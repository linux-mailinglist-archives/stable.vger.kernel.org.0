Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082C819C9C5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbgDBTRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53466 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389043AbgDBTRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id d77so4649478wmd.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fR75NvuHzXWg21/KSMcbyqxjqVfNasU7sbSgFf4Y3Rw=;
        b=i8Eo3y72Nb6T5m6OYWCDeUX7UAUNXWsCTUjfBwCFGo3TtQ1VFt85OQ63fiZhQXZwxS
         cqRi5V7cx699F5PSisCnQn6mYh7iwe+MgcZbA5vbEj/zaq2cNwsz0xDsICaloLRNwBxr
         8txLbiWDUUJQEOkY2n6yEGuQ5gSuipDiPUg76Cr4V6jvzz39XdoERTr6pHhLFMaWD9fN
         QqX2D9Cwuerv56wr+4LEYLLFTyB0mLI0OUJ+gTNkUVUs0a+IyJHx7NNqvI2i19D+AP0/
         LZPUULJLH1nt280acs8xV+Rc/fK/hMeUkch/N/pKko/1PF4xwT/llg+P0qTbVmp+CIeJ
         YyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fR75NvuHzXWg21/KSMcbyqxjqVfNasU7sbSgFf4Y3Rw=;
        b=iw+fvZHw3A5hWMbEMhvtxG9Ls57ej8SAd+LOMJFYbg2WhSINcOqSZWFACGzvBkfW9m
         S4dSse0mKqbi+C6kyMh6ZaXTmTkpNDGXCnPdaFBTgPvotIUUKZY6YM8lP9P9z3MtMizT
         pcUgRGJomncMbBXJ2bQ00qgqP5F9D8wwudTR6Ym5pkCyEimUZ5fnTw2HhB36SHqtWHPt
         Jc+z7jLLLSu52Wc8N2X3OE/6QOMWfhypqZLJ3FUDw98veyLScQ5GpvMqKJ6Gxa+YCEGA
         em98Q8GjqJIO+CzkWLlQEKUctBTo01u3q25vOw93pB+aBChViUFFi+DXEcQRlH/l8MAd
         kMng==
X-Gm-Message-State: AGi0PubC7y1cNfsV8xQUjQbm1tQdWJ15OC4RnFgQ2Ve6xJvNv8vICdTJ
        tzrOwHnVET6fhgG6uWoQ6OA2mcnbV5iVmw==
X-Google-Smtp-Source: APiQypIv4P1IsrN+Gno7DmGmSxiWzkRMFrXkzpt9+zjHDGmlJ5/qJBpmN0BSBPv7NZzrc6iqE3XUdw==
X-Received: by 2002:a7b:cb45:: with SMTP id v5mr4729003wmj.17.1585855037549;
        Thu, 02 Apr 2020 12:17:17 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 22/24] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Thu,  2 Apr 2020 20:17:45 +0100
Message-Id: <20200402191747.789097-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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
index dd66f1fb3fcf6..45e8d51d73233 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1624,7 +1624,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
@@ -1632,13 +1631,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
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

