Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB9F157B32
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgBJN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbgBJMg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0B4620838;
        Mon, 10 Feb 2020 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338188;
        bh=8ZzzrsQnJJ0TULN/Xqd/x3Y2vrdR9yMH4ESJCqx+HcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiA2az5zDWUEMCPNLvCg6W7jK74dGSWEOpz6i7Kw6rwb8VnNXCL0qgSHpMrUbT2Cj
         AauSPG64BdxB0zmxkCMK5QDI5mUmmPRPt+U50p5ZX+AD5bqzUwcvGSlzxGSXWdJIeA
         rAuL0wEIdRmYQmF95qy6+PKn621cB27F6sVhzJ9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/195] mm: return zero_resv_unavail optimization
Date:   Mon, 10 Feb 2020 04:34:07 -0800
Message-Id: <20200210122323.673345339@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pavel.tatashin@microsoft.com>

[ Upstream commit ec393a0f014eaf688a3dbe8c8a4cbb52d7f535f9 ]

When checking for valid pfns in zero_resv_unavail(), it is not necessary
to verify that pfns within pageblock_nr_pages ranges are valid, only the
first one needs to be checked.  This is because memory for pages are
allocated in contiguous chunks that contain pageblock_nr_pages struct
pages.

Link: http://lkml.kernel.org/r/20181002143821.5112-3-msys.mizuma@gmail.com
Signed-off-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 19f2e77d1c50b..8a00c32191263 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6456,6 +6456,29 @@ void __init free_area_init_node(int nid, unsigned long *zones_size,
 }
 
 #if defined(CONFIG_HAVE_MEMBLOCK) && !defined(CONFIG_FLAT_NODE_MEM_MAP)
+
+/*
+ * Zero all valid struct pages in range [spfn, epfn), return number of struct
+ * pages zeroed
+ */
+static u64 zero_pfn_range(unsigned long spfn, unsigned long epfn)
+{
+	unsigned long pfn;
+	u64 pgcnt = 0;
+
+	for (pfn = spfn; pfn < epfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
+			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
+				+ pageblock_nr_pages - 1;
+			continue;
+		}
+		mm_zero_struct_page(pfn_to_page(pfn));
+		pgcnt++;
+	}
+
+	return pgcnt;
+}
+
 /*
  * Only struct pages that are backed by physical memory are zeroed and
  * initialized by going through __init_single_page(). But, there are some
@@ -6471,7 +6494,6 @@ void __init free_area_init_node(int nid, unsigned long *zones_size,
 void __init zero_resv_unavail(void)
 {
 	phys_addr_t start, end;
-	unsigned long pfn;
 	u64 i, pgcnt;
 	phys_addr_t next = 0;
 
@@ -6481,34 +6503,18 @@ void __init zero_resv_unavail(void)
 	pgcnt = 0;
 	for_each_mem_range(i, &memblock.memory, NULL,
 			NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, NULL) {
-		if (next < start) {
-			for (pfn = PFN_DOWN(next); pfn < PFN_UP(start); pfn++) {
-				if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages)))
-					continue;
-				mm_zero_struct_page(pfn_to_page(pfn));
-				pgcnt++;
-			}
-		}
+		if (next < start)
+			pgcnt += zero_pfn_range(PFN_DOWN(next), PFN_UP(start));
 		next = end;
 	}
-	for (pfn = PFN_DOWN(next); pfn < max_pfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages)))
-			continue;
-		mm_zero_struct_page(pfn_to_page(pfn));
-		pgcnt++;
-	}
-
+	pgcnt += zero_pfn_range(PFN_DOWN(next), max_pfn);
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
 	 * firmware is using some of this memory, or for some other reasons.
-	 * Once memblock is changed so such behaviour is not allowed: i.e.
-	 * list of "reserved" memory must be a subset of list of "memory", then
-	 * this code can be removed.
 	 */
 	if (pgcnt)
 		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
-
 }
 #endif /* CONFIG_HAVE_MEMBLOCK && !CONFIG_FLAT_NODE_MEM_MAP */
 
-- 
2.20.1



