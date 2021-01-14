Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75F2F5F0E
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 11:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbhANKjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 05:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbhANKjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 05:39:19 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4D8C061757
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:34 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c12so3088544pfo.10
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=en8qVXfeyVDqIIP8px6ejCNcDJPI30a78TjFLPR7Emo=;
        b=Bb7SJUlOhKJC1ZzQyZRdMOsjlGvbnabYiGk73Uj/BFVF0fB4N9cHrQZRz2Ef0yCHtz
         E0ImuUx5/qPYjt+BO6+mt+i77HasP85vbfStHl0AMkjYZqvfQSCxTA3TCeXYPLtQ4PdS
         wXUz0Vic6sDxivwltEBJrz0GNebiJ66Ifr5RSYWWTDZRSXY1mLyQS2MVg9LAIwfSmSIB
         ybUqD2JIN8GSVmVAYNSBQysheqB+R0Jvdgx6W74b6s7lDL0K76LNty3kEJEGvFMEPns6
         PWIZ0FhmKAbsQgfRtHki3p7AhVx6ukdkvuhjAEY2WIARmoHDLMLmhZAA8T6SGZVfeqmz
         JyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=en8qVXfeyVDqIIP8px6ejCNcDJPI30a78TjFLPR7Emo=;
        b=fuP5kPqRyh00l70v6v7G2REaBPehNC9l541nNC/P70+RyEhCAwABnRjllwDyAdREk0
         XkosNGCJyvmKvobYsGTod97taYJEgef3Xbdu8YB3Cw79xH8V2gX+o0Ve0a77Zd19xiOY
         uJpg/T3NGzaRkLzlRysybeCgfbLpYNtdCTT1kSr3S2/xxhM+xxar9XfMcfF3YyBrG7ci
         6YfzBzxWLOd0n5rgYM+Yobzvzsoxtpfk1L8teCZNQV2ms+mORAo226UyiO/GqP2C+iYj
         44i8cIW3H1GqN9zxa2yIAd3knoZYIGJtRPHQMV5Ci/56mMV73zt9XYCpFi0gKpRkfKFK
         meEg==
X-Gm-Message-State: AOAM533N2PnHdmkGK3m6zWNbB2bh5x87aG711KBKDJlj/5sTD93Kpr6x
        JDomfPEU/5WHcrzi9bRB3XkG1g==
X-Google-Smtp-Source: ABdhPJzYhufPXUdWQ/iuHCLrwoMhWfXjHdW3SAj4YRCzZdLGSVm2HIBKmnA9RKGGOzKXrViUuR2j/w==
X-Received: by 2002:a63:7904:: with SMTP id u4mr6863861pgc.41.1610620714482;
        Thu, 14 Jan 2021 02:38:34 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id l12sm4970112pjq.7.2021.01.14.02.38.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 02:38:33 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: [PATCH v5 2/5] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Thu, 14 Jan 2021 18:35:12 +0800
Message-Id: <20210114103515.12955-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210114103515.12955-1-songmuchun@bytedance.com>
References: <20210114103515.12955-1-songmuchun@bytedance.com>
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

