Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB398111E80
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfLCWxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbfLCWxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78127214AF;
        Tue,  3 Dec 2019 22:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413618;
        bh=oNBqdYSXAouMXgZlhci/zN6zu5Zhf9kVY0HjsV12KZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQ5UaGXYksVPPYQavu0N0PSoIt5oFJZkAs833i+HGfWFsyP19lgxsJpaXa5SxU4FE
         ivyL/9w9rBafbFxWvs1lPR0+LJH8iAp5TnzFO274J84mnHsBs48NJ+oK0S9T4o9GBA
         DJF0LhqTg3SXk66IWipaV+Xlg98pAlY+juBQy80w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 197/321] vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA is n
Date:   Tue,  3 Dec 2019 23:34:23 +0100
Message-Id: <20191203223437.369093981@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit 8b09549c2bfd9f3f8f4cdad74107ef4f4ff9cdd7 ]

Commit fa5e084e43eb ("vmscan: do not unconditionally treat zones that
fail zone_reclaim() as full") changed the return value of
node_reclaim().  The original return value 0 means NODE_RECLAIM_SOME
after this commit.

While the return value of node_reclaim() when CONFIG_NUMA is n is not
changed.  This will leads to call zone_watermark_ok() again.

This patch fixes the return value by adjusting to NODE_RECLAIM_NOSCAN.
Since node_reclaim() is only called in page_alloc.c, move it to
mm/internal.h.

Link: http://lkml.kernel.org/r/20181113080436.22078-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swap.h |  6 ------
 mm/internal.h        | 10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7bd0a6f2ac2b0..ee8f9f554a9e1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -371,14 +371,8 @@ extern unsigned long vm_total_pages;
 extern int node_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
 #else
 #define node_reclaim_mode 0
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
-{
-	return 0;
-}
 #endif
 
 extern int page_evictable(struct page *page);
diff --git a/mm/internal.h b/mm/internal.h
index 87256ae1bef86..397183c8fe47b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -444,6 +444,16 @@ static inline void mminit_validate_memmodel_limits(unsigned long *start_pfn,
 #define NODE_RECLAIM_SOME	0
 #define NODE_RECLAIM_SUCCESS	1
 
+#ifdef CONFIG_NUMA
+extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+#else
+static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
+				unsigned int order)
+{
+	return NODE_RECLAIM_NOSCAN;
+}
+#endif
+
 extern int hwpoison_filter(struct page *p);
 
 extern u32 hwpoison_filter_dev_major;
-- 
2.20.1



