Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D173A2F5F12
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 11:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbhANKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 05:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbhANKju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 05:39:50 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4BDC0613D6
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:43 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id q20so3097795pfu.8
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cYwNXoL62ufowFhR51LMghCmA8txi2r5XxTjm0v6q4=;
        b=WAckzXA3NYKMKzPO7d3fxmhmFa8XPvuFtpLdTcYJt0gP2l6AyanNdZetxWYn6M6gh8
         EKuAhkJ6BYRwelX6ez+H0e0UwT09Rsu1xybpU2VtIhSNwzQ4q564A5sHSawFcgoY9os5
         aRZU6FJl2PWqX/JDf7WGYUMv6bB57KPfWNlRn5mAAwJ4TbBZjzwFRwyh+fKQFrlN9HMc
         AvQvmaLzm4gORcjnaSbXJ8kNWYLsxPdqFhs/H/MNrGp7PBz5QrXC8MhkbZ1saUcpzFhT
         28eZaFI5C/HuYjZZMBu5/YFIV5rta7rOuHR6JMNWnCGh2KIUhh/mpFuG8LKNOD1QzfZ+
         KVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cYwNXoL62ufowFhR51LMghCmA8txi2r5XxTjm0v6q4=;
        b=IhkqVQruaFUoJmLMLCDybvjJkOzmGRsVYwIJr8zE9bp17Y8W2uFlFWrJgxLFXrWquU
         XIPKLihj1bAkOvT54Zu4K3SKufssfqp43qKTMHbQ8qUh/kTod4LbqdALPDVKNnwR/ip9
         QbHWILITW5HFNNfdsLKaSMtCnXOdewyfbkvjyGGF+KwU1RjiivRQGqpdthEO7SXb/x3g
         zWfEPxOx0GoA5mNI3PnS9UZppUEdNPMX4WkugXo0wlL6uCo2wp4GXmUVWwq8rxVRTPUd
         vjJq9ppa1b+yU6Wan968WaE0i4cDgrL8O75oJS/rMErVgFIH+PfUMRpEPhjUmygj5EK3
         x00A==
X-Gm-Message-State: AOAM530R+5ouFdBSlnx0hAvqeMSM5ZXdttI96cmNk8HOBYo0vfm2zD0T
        MNWG39IrGZkeV+WYssB3o3OsVA==
X-Google-Smtp-Source: ABdhPJxXNYBJ+M1mhSEdHS3f5xG3SEV5dk5DG3dTkVKcMRSTqqZO27UWtQjHKdl0bxjQxbvpmqv9PA==
X-Received: by 2002:a63:1c09:: with SMTP id c9mr6887350pgc.185.1610620723225;
        Thu, 14 Jan 2021 02:38:43 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id l12sm4970112pjq.7.2021.01.14.02.38.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 02:38:42 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v5 4/5] mm: hugetlb: fix a race between isolating and freeing page
Date:   Thu, 14 Jan 2021 18:35:14 +0800
Message-Id: <20210114103515.12955-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210114103515.12955-1-songmuchun@bytedance.com>
References: <20210114103515.12955-1-songmuchun@bytedance.com>
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
index 1b789d1fd06b..43b7a044f248 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5574,9 +5574,9 @@ bool isolate_huge_page(struct page *page, struct list_head *list)
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

