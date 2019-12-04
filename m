Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8989811332F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfLDSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731695AbfLDSO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:14:57 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A9820675;
        Wed,  4 Dec 2019 18:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483297;
        bh=YBmn3/Vt4SXeeCCxdUnbFSsQrjzvI2/wa7gF+wvhn00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyOnZW8hmSa967RD8Xk9VV6kK6IPG5bw7QsPXafMBlYlNyKbXDT+heYYbYMK+W9vm
         DVsYTpdzrVR5wqlrB65691pWMulJmsmNAFGVXIRWS+MgYKWEZOwn/3hWTZvrOqquj7
         z+0CMD2Dh6lDLHcZiBgAY56sTfsW6DQ8pO3Y/8S4=
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
Subject: [PATCH 4.9 082/125] vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA is n
Date:   Wed,  4 Dec 2019 18:56:27 +0100
Message-Id: <20191204175324.022451822@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
index 2228907d08ffd..d13617c7bcc4f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -335,14 +335,8 @@ extern unsigned long vm_total_pages;
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
index 3e2d016947479..f6df7cb8cbc0a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -442,6 +442,16 @@ static inline void mminit_validate_memmodel_limits(unsigned long *start_pfn,
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



