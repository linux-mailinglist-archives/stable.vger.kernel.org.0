Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2345E882
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 08:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359173AbhKZHhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 02:37:52 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:36073 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353785AbhKZHfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 02:35:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.wei@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyLwjxL_1637911948;
Received: from localhost(mailfrom:yang.wei@linux.alibaba.com fp:SMTPD_---0UyLwjxL_1637911948)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 15:32:38 +0800
From:   Yang Wei <albin.yangwei@alibaba-inc.com>
To:     gregkh@linuxfoundation.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org
Cc:     stable@vger.kernel.org, yang.wei@linux.alibaba.com
Subject: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array() and set_memory_array_wb()
Date:   Fri, 26 Nov 2021 15:32:26 +0800
Message-Id: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Wei <yang.wei@linux.alibaba.com>

We found _set_memory_array() and set_memory_array_wb() takes more than
500ms in kernel space in the following scenario.
So use this patch to trigger schedule for each page, to avoid other
threads getting stuck.

    0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
    0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
    0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
    0xffffffff8107796f reserve_memtype  ([kernel.kallsyms])
    0xffffffff81075e98 _set_memory_array  ([kernel.kallsyms])
    0xffffffffc0ef6083 nv_alloc_system_pages  [nvidia] ([kernel.kallsyms])

    0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
    0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
    0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
    0xffffffff8107745a free_memtype.part.7  ([kernel.kallsyms])
    0xffffffff8107606e set_memory_array_wb  ([kernel.kallsyms])
    0xffffffffc0ef6291 nv_free_system_pages  [nvidia]([kernel.kallsyms])

Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
---
 arch/x86/mm/pageattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 101f3ad..f7c67b8 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1625,6 +1625,7 @@ static int _set_memory_array(unsigned long *addr, int addrinarray,
 					new_type, NULL);
 		if (ret)
 			goto out_free;
+		cond_resched();
 	}
 
 	/* If WC, set to UC- first and then WC */
@@ -1989,6 +1990,7 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		start = page_to_pfn(pages[i]) << PAGE_SHIFT;
 		end = start + PAGE_SIZE;
 		free_memtype(start, end);
+		cond_resched();
 	}
 
 	return 0;
-- 
1.8.3.1

