Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B945E2F5F14
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 11:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbhANKkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 05:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbhANKkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 05:40:02 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B8C061573
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:48 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id j13so2967579pjz.3
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 02:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4WYNxXgkqgGvh7TvTAzouOPetrx1LoimOg0RJns9SBk=;
        b=ZBD5gnOQj7KeBVofomR1qkSaECGUOhQdp1osQN6ZOThgdZogDsFTBtZ/UPy/Fvhg/Y
         e4y1J16wFNiDZD0xLv/xzUuEu/Uy2Qf2zxHfYcnGBANteZOYViau06OYWLZ8Y7nvNS2+
         A+oSHmPV/G0UHoMjsWYib5rSXrmvJ2PJXUdgpMZKuCiMg/Ypi6YUEbmLiHSdolK65Wix
         MllM9G07BsivId819gXQKwHrDg3oT7skErXB7KzDU2X8hlExHeC4FMyn0d9oOO/cVnQm
         tgw5v56H0Tq8HN9pE1YFYF8daohNuRNHVQbP+hIiX6umTwGYRAurPbU4wFA8nWXeg921
         aGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4WYNxXgkqgGvh7TvTAzouOPetrx1LoimOg0RJns9SBk=;
        b=s151VFuQCUUZyG7aOxSOo1sq7N4nT9NnTZ+6z6Cavf+A1ZuMQeM04KRFn0jFoGoEcY
         WPH9GyT4buE1/PELZibVxbxtyiFq2HFaCdOmSN51PORS3V0rJZwmBTJa0X3Zdg++t8Gy
         f9PKonGNrpkFhvizc78ersNewap1A9MHLQVBkwSR5ydpwkyfUmVqDqMT0FnL8Zs5bALc
         iqBHyPB7Z7h9O+BBk2jb2i/iHVB5PcF5aPfWIUG47aYefZJTCBZmnnb11wNPsA/JSZp2
         t0DDuENOD0KEyg3RmCCJn6crTyOet9k/tbP1F7V39Z4CX1bpTjhJwowWG4vXIlDr43IZ
         Wlkw==
X-Gm-Message-State: AOAM533eYInuVaKVMftQ/ELHXa2xZvUv2REF/kXkILzkLzh5Bxbbl7De
        Z80WDtiwGYLNgZx6hHp4eemX6g==
X-Google-Smtp-Source: ABdhPJxyztuJ0uI2Xtsn9clsCA2I9Y1fjJWQwyTIuJw00n1p1nR234xsKV8aRN3YjRK92vlFEBAmxw==
X-Received: by 2002:a17:902:8a88:b029:dc:f3:6db2 with SMTP id p8-20020a1709028a88b02900dc00f36db2mr6991795plo.2.1610620728126;
        Thu, 14 Jan 2021 02:38:48 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id l12sm4970112pjq.7.2021.01.14.02.38.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 02:38:47 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v5 5/5] mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active
Date:   Thu, 14 Jan 2021 18:35:15 +0800
Message-Id: <20210114103515.12955-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210114103515.12955-1-songmuchun@bytedance.com>
References: <20210114103515.12955-1-songmuchun@bytedance.com>
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
index 43b7a044f248..6c5dfef682cc 100644
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

