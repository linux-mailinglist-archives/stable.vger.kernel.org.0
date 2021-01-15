Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD52F7AA2
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733312AbhAOMwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388472AbhAOMwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 07:52:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C67C0617A5
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:21 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j13so5139853pjz.3
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=en8qVXfeyVDqIIP8px6ejCNcDJPI30a78TjFLPR7Emo=;
        b=gSveUx2iscz2XVqox7kgx2aC826PqbTW5LQGAxIMyQpp1IKFTUdQhSOL2xfJrz9tcN
         mVbNIMy2wF24Yy0Crl8F9sdwYyMYe7OOkoZBLGaGqkH6HEoPHi/Z/K4whKyw8GHWgN64
         3MMZMNnxzVeWl7xlHeRD/52qnh4l6ul6jMJHUki6yZZswJ/u2/GHCT54p2TCuj/3/ZKo
         3CbjTZWuYIJFLmhVahvSyjfqHqVny9mJ05o36FtwR0lHUKa1U2ybhtXUAxTfQ36M9iB1
         toYjk/EV3MFmIAGDvNnfF0vSER2eid/B3Qa0fdGZ4R0ZN53aGxq8xaE4trghArmB+nkw
         AYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=en8qVXfeyVDqIIP8px6ejCNcDJPI30a78TjFLPR7Emo=;
        b=L90HE8HQVExKQymdpMlfqlYlsXWkv++IcoNemG4SLpMDIVwjihy81xfC9kqDzgTulU
         RQhGSWkfwxputmuft7fcPamHI6Ge2Tdo44WpvsUa9CBMGrtaL5wWCV9gEc4gTMWjanIn
         qvTbAyAiRO3DWIxJIPZs5RIHbEYfYyT+5YLyqKdd4vDqs4t4/HoU2QCngoXgVLdFbKra
         cHQ8S/o88gEYoNyDkn1ZU0i09AtTemKSM7j9EM18JZZmS9v+oDosd/enhBWI8h09cpy8
         YlTCa7TIWbOdQqZdAumtwxWOLplPqvf6dLojsmJyW2ygTKUEnlLEXnfYm6AhQaGoqgOR
         kTbg==
X-Gm-Message-State: AOAM532809pR+XLO3F6yUhsu8J6xlx85ZuMp5aPFvPoocSxS/UVhiTCW
        w9vS3Hq0SENYwmG9koFYo7Kt0g==
X-Google-Smtp-Source: ABdhPJxJPmVGEhmpm8RkxK2vrqONkxXaGgxb7wCpNiuTFdu5fvFVYrtOBP4aFoPAaOFsUeMFtez0Ww==
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr1679368pja.47.1610715080481;
        Fri, 15 Jan 2021 04:51:20 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id c5sm8193600pjo.4.2021.01.15.04.51.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 04:51:19 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: [PATCH v6 2/5] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Fri, 15 Jan 2021 20:49:39 +0800
Message-Id: <20210115124942.46403-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210115124942.46403-1-songmuchun@bytedance.com>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a new hugetlb page is allocated during fallocate it will not be
marked as active (set_page_huge_active) which will result in a later
isolate_huge_page failure when the page migration code would like to
move that page. Such a failure would be unexpected and wrong.

Only export set_page_huge_active, just leave clear_page_huge_active
as static. Because there are no external users.

Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: stable@vger.kernel.org
---
 fs/hugetlbfs/inode.c    | 3 ++-
 include/linux/hugetlb.h | 2 ++
 mm/hugetlb.c            | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b5c109703daa..21c20fd5f9ee 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -735,9 +735,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
+		set_page_huge_active(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
-		 * page_put due to reference from alloc_huge_page()
+		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
 		put_page(page);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ebca2ef02212..b5807f23caf8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -770,6 +770,8 @@ static inline void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
 }
 #endif
 
+void set_page_huge_active(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1f3bf1710b66..4741d60f8955 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1348,7 +1348,7 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-static void set_page_huge_active(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
-- 
2.11.0

