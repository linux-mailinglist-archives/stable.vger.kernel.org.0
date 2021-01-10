Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A42F073F
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 13:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbhAJMmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 07:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbhAJMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 07:42:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAB6C0617A3
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 04:41:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id e2so8038565plt.12
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 04:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffJDakXCDHXSBit9htKSivl1vC+lnq1/j37kP5/245Q=;
        b=cUxJC0PDgtphFqteTncK1MMWPA0tvaGir94in2c2J8OS1SoLVX445ms53I6WXgvgZt
         omcPb99wACh3cWgOjXnBmpbdfO6TGUoKvW5FkIAjWnK2WaGBlkaGuWe3fil1eko5nnNz
         0fEHHF+vbssaLNNJZQ4OERgj1TxSq9doOTw9wn6N/E1c9kvgMXSW8khp42cxCiEKOYZc
         YIT82Ffe2Dm5QVfgBXtzGRcUq66thL3sVDK8CB/y+caCXc3MflE+iN6IsmWSE3r9Wr0Q
         dmMPD1A8lozfusvXZFMUOYroviV/u8043Bi2YD3mEM6yJnOAy79Fj1HAx7kIXVvsPX6M
         uFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffJDakXCDHXSBit9htKSivl1vC+lnq1/j37kP5/245Q=;
        b=Fvf2xg7V87n9+aRZNQnSO5zjH7M3MadzbI4C14Pl3DgO3KN8QaQU4Xv2kroHgXbf2R
         uD6Ox3XEswAtrkPKU32XPuJndqBCJA6ICslmErCXcpoYJ3GlxBaUu50RmQpuvjHUkdIv
         FNcG5ET9Di+k5DQ9ellFwWvOCb4ENVrs3lfwYVnwVhmxsdk6HmjCsLGfEgc0W6dy1j+J
         LyiuWZ2xuaDtn5MYwnxdFQqnd1dgJwSKwHkzOL35izqtum2H0GSIRbh4zkrB3KmA9NdP
         IKMNK+06XfwETFlLKzXImiOT4hDKEc6g8Jjknj2gzHYF67oRJAbG0CmzYVEE+83MRk7D
         hgrQ==
X-Gm-Message-State: AOAM532yMe3GaBoDTe4404y4eX0FM9XpHm/bjdIn0F9iOCH0JogVRLTj
        d6BjHjjj3IbuPR/d4SCSF1rMXg==
X-Google-Smtp-Source: ABdhPJyZ047vfaPcWkl/qH5UFf8rFpsGc+XXjNkX+M8hjJ33pepyB/KnD8+n6in94OwlD32paX1+4g==
X-Received: by 2002:a17:902:b782:b029:dc:251:423f with SMTP id e2-20020a170902b782b02900dc0251423fmr12395450pls.30.1610282492291;
        Sun, 10 Jan 2021 04:41:32 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id p9sm16176960pfq.136.2021.01.10.04.41.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Jan 2021 04:41:31 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/6] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Sun, 10 Jan 2021 20:40:13 +0800
Message-Id: <20210110124017.86750-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210110124017.86750-1-songmuchun@bytedance.com>
References: <20210110124017.86750-1-songmuchun@bytedance.com>
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

