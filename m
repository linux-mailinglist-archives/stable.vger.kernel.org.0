Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECF319C9A8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388989AbgDBTNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46768 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389223AbgDBTNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so5512846wru.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+EXFELOhHN3rDbwavFog4fv6o0gQhN+56+iO+SzE+uI=;
        b=UT+ezZY0/T5uP7nVZ/3sX2A+45n3BeDrDBaQW6UmqapoEq+PLepi/gpwFA/bNBX48O
         IlRim+O4G8WYnmEFOejQ1lgrLI/Z1XOz2XsZjPBxJdd9fxWTPijewhQ3Rn+gU1x+144p
         hDfWseAgNDeiaqUueTdZ1hzocT1y6eswXewB5Fr5s+1lIanWJuvTxAmdIxwbkFK1lz7+
         RTh/s6U17ABa3Zb5aekQiXLBKlMeUc7cznmZaFSDDdMLJc43rZrgv1j/I3m3RqQl+IOL
         mYZBTwe2FakuWViWrjtl0Yfv8fne/AqsyIO+M5auKQruhZF4TokKS5bdb3hp8Q73YZaV
         sm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+EXFELOhHN3rDbwavFog4fv6o0gQhN+56+iO+SzE+uI=;
        b=UqTM33naiKX5/FaOCJPrQkz5Z5i7qsfuHkcv+mhJn9zfwQOqw3LZ8hqgxoNW2O8FSz
         AabA+Qd173LHO0mzlCbVFGoK9yzbbM1EdSQOIkyZ01TwJHMbX1FZHXL4XgnDas1dG6gQ
         pIGORgfuWMCnVe+S7eU0nkVfFCSQHNkH7ndQ7YTxvr+NmascrYzdJxPSxBg3VdcW+8FW
         7RSFZvG+6RnJGEAQAGLwDg146tqmj9GnPwNTmRtkA8oi2uwM+bxUEwi7GGc1OnV5gpDl
         aBo18PnAyZcUaBziB/J2VOeHJ9v0cQ6MyDD77N2/d20S9ezudxY8XChpq8E9EylrJdee
         rA3Q==
X-Gm-Message-State: AGi0PubRcooc67tSEmn2JLn1smRZNhd4wcF2PJ8RJroyS3nK0eS3inCQ
        tD63VktZ26Ur5IMRmVE44Ul2dt6eJowKPg==
X-Google-Smtp-Source: APiQypJuHi3BS7MM/nSMqj/Q3SGlABIbIdN2ZjHw/Rf88bJF2HYvUqQKBP0d8jR2L5lAWDsTfLGaBg==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr5215019wrn.351.1585854813175;
        Thu, 02 Apr 2020 12:13:33 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 31/33] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Thu,  2 Apr 2020 20:13:51 +0100
Message-Id: <20200402191353.787836-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index 0b8852d80f440..30dc16d000ba0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1682,7 +1682,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
@@ -1690,13 +1689,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
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

