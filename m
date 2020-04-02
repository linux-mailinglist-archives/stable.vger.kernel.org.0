Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A06A19C981
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgDBTLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40427 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731892AbgDBTLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id s8so3441551wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=T0ZLg9OVS5LPGUTR/MUK1s5R+uH5HTAX/aXfIPj67qI=;
        b=l9vWx4OtmGW6zHw3O6bkrvK1uHb48ZIh2tVo8W4IA6xT+YuN3bSIwp4G4O7s5tQviF
         FOkayv1EJsPcOjM4w+Py52tEsAMg+VQLeoMqIp5QC8uVvByKXUKqH/O16xRBkYskTgoo
         B+TIvY7MH7AdpEb2hpA7qByg/tsnCdZ4/p2f2qJMn7WFza1ICrAFEqWmfqkb4jQ+5kK+
         rzvRrJG00rLWFsRWIixSukwPgQSszO5AV4C5TOfNLZTazablBST2sUodNTqr3mjwMQnY
         RoOHBW83YjYw6BVVoIYUry5nsfWPCdZJUb6bFCARwmckw3WvBHetQaJv6PJksiVsoZNR
         bMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0ZLg9OVS5LPGUTR/MUK1s5R+uH5HTAX/aXfIPj67qI=;
        b=IRJpPnhu7vJDod2cDnhCo1Z1okeIctmhucLjYyyGqJR3eftVlArIx6+/bMAhSMhs3G
         /QyCRJtmrBLmaqpQSHQYctm9CenDB3XgZxHeM8/5G6g3lsh0oB0LmIedXc08Fwe8hhEg
         dJSjji6pOWpHOQUefdArD96FT58ue2JZsxR0YG1MOWvQq5zlD7SdUMPuGb4J/fyMsucU
         zBQ2nfb09iUAuEltRgQBadYCNWMqPAwCi6XnPRMvk5JrAASSqbRvLjlMNR4fC1lDW+C8
         yc6Sx7HVB1nkYnafK/rZa7LIwGHXZaM6IaLyb6hqLyp8t4LTIT+6wZaF+m6YuP/mQAkW
         0iVg==
X-Gm-Message-State: AGi0PuYczrxeUBH6tZXkvoHLrjARIONfWgwzI/6xOq3PLP5AYezszs+I
        OLkWuk/zbz4KDO5LcV8O0b75hKwbqs2Skg==
X-Google-Smtp-Source: APiQypJkkF+4se+o4rryNcLV9gaP8VkE2DxebkrGaXDYWIUPHUrBphK6q5/eiJTWEIfae799NmC+Ew==
X-Received: by 2002:a5d:6450:: with SMTP id d16mr4904339wrw.151.1585854700038;
        Thu, 02 Apr 2020 12:11:40 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:39 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 12/14] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Thu,  2 Apr 2020 20:12:18 +0100
Message-Id: <20200402191220.787381-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
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
index 958d6ba9ee2d1..be65161f97531 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1668,7 +1668,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
@@ -1676,13 +1675,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
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

