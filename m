Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690342F43CE
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 06:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbhAMF0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 00:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbhAMF0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 00:26:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E01AC061795
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id my11so1857151pjb.1
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQxBzrH/aoWEdG3IjoZ+7PAOMjNKjJoK1+V0rHsE7hs=;
        b=squ9zmJAhHIGqokb1c1CENeZTx1PBd+M1MWOPjBpY2CspZ7CWbwStQxbPHEkzGDfVw
         r3GllIzxRSrFSki7Hs7vOhtOSTmatJJybzgdTqoXbnFCV327hVJLS2GNi3Kv1waVcmoM
         nfuiNcJICOfTESCwE6oXVXep6SiDdNj1CtPav0peKhrYdFCbKaLoqflQDZrBEgbRmG7d
         gauTrw3fsWXuPN0zQhnuAexRRfzsZPDkbYM9nuIVz52PFAAiHIZBxJ2nMWJ2Raiggkq8
         wD08ZfI/qBKg8Jf7EEcspHVrWm+4x2U+v9XYP1386+QaQ0WyKvEtmA4zU/v803Lz/YZG
         NPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQxBzrH/aoWEdG3IjoZ+7PAOMjNKjJoK1+V0rHsE7hs=;
        b=eHCc8Q0pbwGBb3PU3k2RYdbIZJ5Z5me3QFT30cgTbbtSKEytB8vsp9A0J2mdMPM/C/
         BIQRW2s0GIcE8rCRIChc8C57Vo/mqcrBnOwzg+A5Ve9U7CEmWa2Zcr4+lHlRAvCmz0Dn
         1/DfU1FAIpn+XUNsAEs2db7M+J5Q/cCNEAZcRdYuZuajPV7GfTJaa3kiI1u1QBgd6dJh
         nctp7Xqm+Y6itvPjNvDpehXfT5QyvWMUSBDHVMXUtylg6KhxTRKDEvf7N+Ki+loxrrqh
         /ZPrNuqaNB8a6kbAIxMHLftGkddQWgTJZvWAF1aklBIM+y4hCfCbLL54jLBfZWt2r3ZP
         vfMw==
X-Gm-Message-State: AOAM531DUXkWS+/2rDxUOpdHgL0OyBMIeUGUBNB44ZmftJKjwlMVeVkZ
        lUAGW7hZwdLVTFnhQslLf4T6hQ==
X-Google-Smtp-Source: ABdhPJwg4fxKWfXnYhu4nWUKg61Xld9nJTPPDMfQW0uTj27Vgs5KMWDaoF8RkSjjah+MGrBywkQArQ==
X-Received: by 2002:a17:90a:68ce:: with SMTP id q14mr350311pjj.223.1610515539949;
        Tue, 12 Jan 2021 21:25:39 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id x15sm893081pfa.80.2021.01.12.21.25.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 21:25:39 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v4 2/6] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Wed, 13 Jan 2021 13:22:05 +0800
Message-Id: <20210113052209.75531-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210113052209.75531-1-songmuchun@bytedance.com>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
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

