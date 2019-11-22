Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B274B106285
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfKVGCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbfKVGCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AC320718;
        Fri, 22 Nov 2019 06:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402565;
        bh=YBmn3/Vt4SXeeCCxdUnbFSsQrjzvI2/wa7gF+wvhn00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2v+J2YKNSvJB/uUgjQtTPRxeZDuLqV04AD6Djv/XEUTeKlrMkDOZ5VGMWGrv+AYoX
         ALWfE62VYHEqRzJwNoUzC6rmwjNaEF9R6Kc9qKRQ2Jp2OoaPcFsZmHHa7eFI/tOaMh
         W/cZP4pk16WiOrJLdHGBBmEyk4I0anvtAec8Vvvw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.9 69/91] vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA is n
Date:   Fri, 22 Nov 2019 01:01:07 -0500
Message-Id: <20191122060129.4239-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

