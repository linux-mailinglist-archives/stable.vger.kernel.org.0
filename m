Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D082F43D6
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 06:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbhAMF06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 00:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAMF04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 00:26:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB224C0617A6
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:57 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l23so443493pjg.1
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1Dj1BnCFYHHEbXxpzLfGjPuUeLA5YyfxkXrd8ZYcB0=;
        b=CkA9nt2K6f+62+T51zdVrYDbufK9iilFrW0pvsAhNTKoNhtmriES3uoKM1sUakUZZ5
         F/v6UK2sK8O39JyDaqatm8tzyyn0AJoI7H+IDejD4uJmwSTg6K9E1yy89mdOJnCEYjcW
         k69OZYyJnR0MBsFEE1C9ZZVCWBqjSkk7uH/vBI3RCr0KaxPha+Iow4xZr7VKSwS52VRL
         s8JtrAKwI/5cHrpqLI4hhvXK/oKOErZGwvmjzdqAbBNT+xCp3nPOswceWh3laeh0nZ89
         bkTQXsBeOJe6rDwxwZjLMtfYp2T+RluwSz5yFLGdXoqWtHGonU/iHNrM5mdXNrjzpb0c
         DcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1Dj1BnCFYHHEbXxpzLfGjPuUeLA5YyfxkXrd8ZYcB0=;
        b=KxxffIUXMg0pKYPiveOaR9HT9bPnOveDfG8GKjKIaBy6VmGRLf6QcJyGJFkpioFDEA
         wYj5g4E1JNnNhBYZChBocZOfLjXDa/V4oEtWWN8RVv+FKu/5vqNj/pVyuqTR+/6Z3k2D
         5bW0Xn6spa9cen46FAF+3RunEDsk4DuQYB5BWiQ2HLauqr/Ht3nBo4Z/MJakb4Y+SaWA
         oFZJBxJAsP3+fYTVSLlrtFLRxzTWkp/7Z6WicOsE/tNuhUQo7yVyzUboH3yF8eboak+R
         2x+r+DFkMnhDzEvnP6+1jT8yOxEZVZJA7Oozg6K6ZprfDxVkLF70969UvLqZWRaVhCyR
         Gkzg==
X-Gm-Message-State: AOAM533PcZZUhHWbQmh8Pl5aaE8ZY675bPB9Hmfvtxux//HKVir2NIjo
        V9F+Zg2W3vEUOwN2qjPNFS9AWg==
X-Google-Smtp-Source: ABdhPJy6z9arm0rLeW481RViIUW3vRvWLSVKc/kfyfaVXhVXVXDdIrIVxIDcum+7oWvZIYQX1oAJ8Q==
X-Received: by 2002:a17:90b:3011:: with SMTP id hg17mr424575pjb.22.1610515557266;
        Tue, 12 Jan 2021 21:25:57 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id x15sm893081pfa.80.2021.01.12.21.25.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 21:25:56 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v4 6/6] mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active
Date:   Wed, 13 Jan 2021 13:22:09 +0800
Message-Id: <20210113052209.75531-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210113052209.75531-1-songmuchun@bytedance.com>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The page_huge_active() can be called from scan_movable_pages() which
do not hold a reference count to the HugeTLB page. So when we call
page_huge_active() from scan_movable_pages(), the HugeTLB page can
be freed parallel. Then we will trigger a BUG_ON which is in the
page_huge_active() when CONFIG_DEBUG_VM is enabled. Just remove the
VM_BUG_ON_PAGE.

Fixes: 7e1f049efb86 ("mm: hugetlb: cleanup using paeg_huge_active()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a7ed22811672..8c6005a538a2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1360,8 +1360,7 @@ struct hstate *size_to_hstate(unsigned long size)
  */
 bool page_huge_active(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return PageHead(page) && PagePrivate(&page[1]);
+	return PageHeadHuge(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */
-- 
2.11.0

