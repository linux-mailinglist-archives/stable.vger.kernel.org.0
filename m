Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5619C9E2
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389538AbgDBTSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43073 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389536AbgDBTSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id 91so3659897wri.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ejsyYkV67my8PwTROUOSfaRKUGUd6Fd+i+j/6EoUNmA=;
        b=Agq0V/onx7aTzVHzQFUtOL3Dun4mQrB2HFHMNc9sVjpar5koE7Ku2CFeBJWMNwRi+Y
         ind8Z6cS8ot8mIQO/HjWO4Bmi9FC8qLqiSbpzjCitHVgk3GIB4rMqtkyliDleBj2dlaa
         3slTB/9IUf5scJGwKdlfBG6g52ItpDTQcm6RP67SwNIMKueDdFmxzynkZMokk+cF8WtU
         rGf/70I++ZLgTF4NLcxOexnsgfthQ+to4SV6Ev0zwgK4B6u1bUXvK4rhf5K8VsxhKX+h
         vG5RIYRT/bifgkOq/HJ0D8kVyVnJKlWshpxMLkjYs+w/QPDwkXsiuVuk2b2TLxwZJICW
         dYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ejsyYkV67my8PwTROUOSfaRKUGUd6Fd+i+j/6EoUNmA=;
        b=D8jdnOHV55TN4muDL8USmVyqpZSrgvLkuToBF3xiHySVGSDPgIPKUD/T31qBCKpp9c
         LdCAaAGr/BEByiZgqDlIKkQndBgCVX9E+7IdE+LieBxO7N1m+S0g8THIdgXirdRlShr0
         K4GV3XuvBrQD8UCs6IS3S3Tqh5XBPYkt3VhyogbJ6U/z9oDAPPbwzcy7aBBREQ/pMf5P
         bAplruWkKFbXSFdzZ5GF5Ckemqn+vtvfWY3JgO0PADeC1K9vlfBeBiRokNw+CNVBG2ai
         N46yMSehAsyZzU0IaZrcAJbgKo9Od2ocCY+bVQUQuOBIR59faSuIZp/6NkHOGH0051ke
         PWGA==
X-Gm-Message-State: AGi0PuYiBFvX24ZJfrGhipXyRkxwNdq0PrcBEJltF3RzR0JLlf27DoMu
        gfiVB/TvTLAZKU9lO9ddvx/mKZFYFazzNw==
X-Google-Smtp-Source: APiQypI1VhxURYSkdNtMzXezh3T2RtxhlihS8FALwO8pivlMwlgpX8ISs58IOFRqxhhau6QSNW5G+w==
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr5270394wrx.226.1585855101572;
        Thu, 02 Apr 2020 12:18:21 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 19/20] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Thu,  2 Apr 2020 20:18:55 +0100
Message-Id: <20200402191856.789622-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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
index d118e59a2bef5..21d292e45599f 100644
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

