Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666F32F7AB0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbhAOMw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbhAOMwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 07:52:53 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53DC0617AA
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y12so5012493pji.1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DQl8rxWhauEyHy66Vw2doPr/OoHRTcPYRf3F3cd9RBM=;
        b=mIsdeXyKnr21oVN3m7ahGUHzVFAL4IKQyIJWWr/FkWMmfFnnyjTZGy7xsYs5jvm/+0
         2YzpGRQ3MzcBg96rpOAMkIXVw5klf4pNbHvBCUAFgR41iB1BjIoXFbr/7513Ach6TuGb
         tITWWoEYi3sJITZiRlZnZFGSYDIIGDyFzhjSOPTzD3BeXGHtYTBKwJYKffNEXNWGxDRK
         CqFaae/nb+uE2iJYLGmGJiCDG537+2wCuGux4ofJsnJgycNmpTdnUbu0rkjrQIHiPzs5
         r2vyyygnUARsYpZU/Ku5P/6pLAi0k8fktPSX0pqIBId7xjvIxgZlseTLzlukS+HFLkPC
         NN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQl8rxWhauEyHy66Vw2doPr/OoHRTcPYRf3F3cd9RBM=;
        b=c16C0XrGqal+OXzQeaWaXA3QAEfCDzC4cvv8NURhsIPZGM6SrLPB2dbb1JN0GLgtd4
         PUXRYlsifhzqmJyjxSWjje7jv+bN/lXslnVwb/mDUnqCT4ZHLtSRrmhUZKeqh8T/nFsS
         9x/6rdx++UjdzbtC3jzMD4lDRojakkpD+KBpJ7/EvpFG6hzx5mSwV9eagQ5S3RVtvK6z
         vMTn7PhghDdDMrj6Iisg//UiP+KOZ+qLV/Ji9QREpdTWbqUHFw+mHX+ERlZzMbaTK7g9
         f0xEzOrWb4tmzDOLV+Bu8Z5crS+7y+9J7etxZa+uaEwk4AUJtmn8iFh+eRBNRj+lGOGL
         VGhQ==
X-Gm-Message-State: AOAM532M1/f/kbyuwlOOmfkDHLTVgYw01PosNW2NuZokx53oHBd9GJ+Q
        gEWjfw5uaFP9yK6K0dnJDUbiZw==
X-Google-Smtp-Source: ABdhPJxzO1F+Kc413WL6P0dby5vR8c7bqbiw7shMdYNcdj83Zo+SOzQRLU5IUoiFalgATpr8wIPwPA==
X-Received: by 2002:a17:90a:3cc6:: with SMTP id k6mr10434490pjd.204.1610715089021;
        Fri, 15 Jan 2021 04:51:29 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id c5sm8193600pjo.4.2021.01.15.04.51.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 04:51:28 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v6 4/5] mm: hugetlb: fix a race between isolating and freeing page
Date:   Fri, 15 Jan 2021 20:49:41 +0800
Message-Id: <20210115124942.46403-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210115124942.46403-1-songmuchun@bytedance.com>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
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
index b99fe4a2b435..f2cef3cf1f85 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5572,9 +5572,9 @@ bool isolate_huge_page(struct page *page, struct list_head *list)
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

