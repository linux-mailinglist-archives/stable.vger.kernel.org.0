Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC52F43D5
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 06:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhAMF05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 00:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbhAMF04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 00:26:56 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B12C0617A5
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:53 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so542688pfk.1
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7IILliy6HAELOAf2o6Y4OfnqFvSJBzlwsRQjJedxot0=;
        b=dJSU9wJz/3rQWPdMgFSeLg9iISXgA+mrG+M6gt+bsIjssGtFTfPEsERPEUS/5t83/a
         LUUhWWNg/MtzqsN1Kcpq3X30J5yof6IfmScrbd2duBHq6YKTHipysgbq0GgU5xk6pS2e
         zjsxPKhbFQ3aQpWwXgTAKahmN+gYTipJrmzzMWPn1qre9ExAnmti5MKJc035HZOxbRYj
         iHy8ulllb0ZqY2Um8SLjP+3fu+8cZOBSSgRpFiASO+QylIjnslUNIoap6l6hYXze4wgD
         w4WSsWwgioG3c1Cy6a1OJW3JNITIUff9+LHkCpsmdjVxblAQrvZnTkHGQvdlc1TgFK6d
         1KbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7IILliy6HAELOAf2o6Y4OfnqFvSJBzlwsRQjJedxot0=;
        b=T91SlrFKBJSQpstZ6yBJ7JZgf3z1GvJ0XnWnifgHFfAN9G+V7vQp6yXbBRUeA+3mZJ
         cNxmlXLFjvq2DYvQYd8Zk4tXW/jMMeydlsenZ4AsTdEsgYBZ4iADZfJIxn9JThYP85VJ
         IBFc7cYXJ3JBENqdWvLYPRzvjKrT7D0sPKNouj/rMq+r3etq0jX9EjsgnYPjNmNZ0nFi
         fCx/7nSwN/kic7CPe2IdlYOdS9TeE7wfXYSF0p3aUld0xkKl786au0rcz8UP3wd8XMe1
         gu9ArD2q4ewmVk95vZ5GvXaUoa+FQePYB1MtiydjtTYexhhTQDtUQaKzlxjetnXTmnfq
         l70A==
X-Gm-Message-State: AOAM532hbUUY1I8F2dDQfPys4RWsrpggSLXMNKNUNlWYP6YSZ4M4r+g4
        tT2TRwE6rTAyN4nYEBIi1AN0LA==
X-Google-Smtp-Source: ABdhPJyzBXCuQ9SD6Bb7oZ1eb4Ev3kY+H2KEd84rW3RSKql2lLp9DD8eqP0VXQA4l2FJ/CVALwQ2ZQ==
X-Received: by 2002:a63:1110:: with SMTP id g16mr459913pgl.357.1610515552956;
        Tue, 12 Jan 2021 21:25:52 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id x15sm893081pfa.80.2021.01.12.21.25.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 21:25:52 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v4 5/6] mm: hugetlb: fix a race between isolating and freeing page
Date:   Wed, 13 Jan 2021 13:22:08 +0800
Message-Id: <20210113052209.75531-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210113052209.75531-1-songmuchun@bytedance.com>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a race between isolate_huge_page() and __free_huge_page().

CPU0:                                       CPU1:

if (PageHuge(page))
                                            put_page(page)
                                              __free_huge_page(page)
                                                  spin_lock(&hugetlb_lock)
                                                  update_and_free_page(page)
                                                    set_compound_page_dtor(page,
                                                      NULL_COMPOUND_DTOR)
                                                  spin_unlock(&hugetlb_lock)
  isolate_huge_page(page)
    // trigger BUG_ON
    VM_BUG_ON_PAGE(!PageHead(page), page)
    spin_lock(&hugetlb_lock)
    page_huge_active(page)
      // trigger BUG_ON
      VM_BUG_ON_PAGE(!PageHuge(page), page)
    spin_unlock(&hugetlb_lock)

When we isolate a HugeTLB page on CPU0. Meanwhile, we free it to the
buddy allocator on CPU1. Then, we can trigger a BUG_ON on CPU0. Because
it is already freed to the buddy allocator.

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 898e4ea43e13..a7ed22811672 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5575,9 +5575,9 @@ bool isolate_huge_page(struct page *page, struct list_head *list)
 {
 	bool ret = true;
 
-	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	if (!page_huge_active(page) || !get_page_unless_zero(page)) {
+	if (!PageHeadHuge(page) || !page_huge_active(page) ||
+	    !get_page_unless_zero(page)) {
 		ret = false;
 		goto unlock;
 	}
-- 
2.11.0

