Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B421B4319
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgDVLUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgDVLUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD67C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so1958299wrr.0
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fR75NvuHzXWg21/KSMcbyqxjqVfNasU7sbSgFf4Y3Rw=;
        b=vzi3tbUjo/3bh53PcL1u/EGZ+IKQimXLhw2VPWV5+o3yjdf3alybsMMW8gF+rn/2/+
         DmwCm+dWo+5KQIHtzr7nRViMoDl9LgHw90b2YynnCi01X4unaCswi+1rE7VyBzfhGoap
         eFCU84aTyRxmHzZhJC7UNRT1iFfAmbKdIcJVzRstStyeNs7L8ml9y6GPoXUTDl/87AB9
         8Tbcbw0m1Nd6WyjN/q0UNaeYJBTEfiwNjPBSzB7Netcd22XX/bU3lYn9aUk9kn6kftss
         9pLMU7JnXWNa1LEcGfwjtSJamO5xbXvVqTa5CT8LlrhPT2Tgx2+bd7KMVmsrOwZBN0d2
         Z4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fR75NvuHzXWg21/KSMcbyqxjqVfNasU7sbSgFf4Y3Rw=;
        b=Er2WKNSQTuV9a4aJYuwi45Lrdc8wEyt7TCtVtkqkLavdCr03qvgTVRhg/InpjzxG++
         TTl1VDioarFrb2NFl4G20eRPh9YsP+CCZ+45+XqWG7RKtq26MsDcPMXvyQNQWgy9FHNe
         EODcYG8NbsNLPwMQB+12JSmjDvl3MNmt2gA7u/tTawJzUlSj5F9r0Lk2i02Tf6VZZWIy
         BAcSWKAxpP1MKNf1RzFo5+I93+oY2lKpE9atma1eaZ3bmJmW2MNNC3oDJ2yh9rVZXGxf
         cFjdROJ+vVki5IP9WT7kS/XsIjwc5QlksfZs7RTJJQfrpI6eGT63E2uh+93PvnM5m8Vi
         g6VQ==
X-Gm-Message-State: AGi0PuZDBjaMdVIKI5v8Sa0bYSEo4NCGsLk4k5scaiAgyLKFeN64J6gB
        WnY/BCRONr57Nkxf4N6SRk/Htw61gM4=
X-Google-Smtp-Source: APiQypLvLmRLrGlmVC+W7DNBUrWf6ogMeinjTl+MyKIL4hwPaB0iPbnbKHcGGGHTU2YHcCvb+auktg==
X-Received: by 2002:adf:84c1:: with SMTP id 59mr29786457wrg.350.1587554430322;
        Wed, 22 Apr 2020 04:20:30 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:29 -0700 (PDT)
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
Subject: [PATCH 4.9 20/21] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Wed, 22 Apr 2020 12:19:56 +0100
Message-Id: <20200422111957.569589-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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

