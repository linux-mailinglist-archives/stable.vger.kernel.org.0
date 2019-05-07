Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6444B15ADC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfEGFtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729038AbfEGFkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD8C20B7C;
        Tue,  7 May 2019 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207623;
        bh=1hD+jyiWd7YHvDqUeKWSIvwnCseUwW7B6jDDJB43U8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7CiKVYkNOfu0uro3pHOuAs8tpt44sSzVHUgoKe448X8peTRcelE8GT+H+ZnL5o1W
         M+Sk+iY+39rMcDcjj6LnhlKMH6OfXmVC/0whLWtEKQ4o/sDoO667l8XnGE84+pcVbs
         wLdEypiwpBc9yCWuxqaSJH+9ka/qjfRTzOxySVbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct pages for the full memory section
Date:   Tue,  7 May 2019 01:37:51 -0400
Message-Id: <20190507053826.31622-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 2830bf6f05fb3e05bc4743274b806c821807a684 ]

If memory end is not aligned with the sparse memory section boundary,
the mapping of such a section is only partly initialized.  This may lead
to VM_BUG_ON due to uninitialized struct page access from
is_mem_section_removable() or test_pages_in_a_zone() function triggered
by memory_hotplug sysfs handlers:

Here are the the panic examples:
 CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_VM_PGFLAGS=y

 kernel parameter mem=2050M
 --------------------------
 page:000003d082008000 is uninitialized and poisoned
 page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
 Call Trace:
 ( test_pages_in_a_zone+0xde/0x160)
   show_valid_zones+0x5c/0x190
   dev_attr_show+0x34/0x70
   sysfs_kf_seq_show+0xc8/0x148
   seq_read+0x204/0x480
   __vfs_read+0x32/0x178
   vfs_read+0x82/0x138
   ksys_read+0x5a/0xb0
   system_call+0xdc/0x2d8
 Last Breaking-Event-Address:
   test_pages_in_a_zone+0xde/0x160
 Kernel panic - not syncing: Fatal exception: panic_on_oops

 kernel parameter mem=3075M
 --------------------------
 page:000003d08300c000 is uninitialized and poisoned
 page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
 Call Trace:
 ( is_mem_section_removable+0xb4/0x190)
   show_mem_removable+0x9a/0xd8
   dev_attr_show+0x34/0x70
   sysfs_kf_seq_show+0xc8/0x148
   seq_read+0x204/0x480
   __vfs_read+0x32/0x178
   vfs_read+0x82/0x138
   ksys_read+0x5a/0xb0
   system_call+0xdc/0x2d8
 Last Breaking-Event-Address:
   is_mem_section_removable+0xb4/0x190
 Kernel panic - not syncing: Fatal exception: panic_on_oops

Fix the problem by initializing the last memory section of each zone in
memmap_init_zone() till the very end, even if it goes beyond the zone end.

Michal said:

: This has alwways been problem AFAIU.  It just went unnoticed because we
: have zeroed memmaps during allocation before f7f99100d8d9 ("mm: stop
: zeroing memory during allocation in vmemmap") and so the above test
: would simply skip these ranges as belonging to zone 0 or provided a
: garbage.
:
: So I guess we do care for post f7f99100d8d9 kernels mostly and
: therefore Fixes: f7f99100d8d9 ("mm: stop zeroing memory during
: allocation in vmemmap")

Link: http://lkml.kernel.org/r/20181212172712.34019-2-zaslonko@linux.ibm.com
Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Pasha Tatashin <Pavel.Tatashin@microsoft.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 mm/page_alloc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 923deb33bf34..16c20d9e771f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5348,6 +5348,18 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 			__init_single_pfn(pfn, zone, nid);
 		}
 	}
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * If the zone does not span the rest of the section then
+	 * we should at least initialize those pages. Otherwise we
+	 * could blow up on a poisoned page in some paths which depend
+	 * on full sections being initialized (e.g. memory hotplug).
+	 */
+	while (end_pfn % PAGES_PER_SECTION) {
+		__init_single_page(pfn_to_page(end_pfn), end_pfn, zone, nid);
+		end_pfn++;
+	}
+#endif
 }
 
 static void __meminit zone_init_free_lists(struct zone *zone)
-- 
2.20.1

