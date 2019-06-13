Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD9244FAD
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfFMW4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfFMW4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 18:56:16 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9A22147A;
        Thu, 13 Jun 2019 22:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560466575;
        bh=FtOxDO4JKv93XRJe1X4iIyJm0BOSI57idnCjr9vCVUc=;
        h=Date:From:To:Subject:From;
        b=AnEFW+LfGt8b2U/YmJXO6jIApwWbmXHg0yWmsjueFCXweVBj8GaaddxX8vtPK5AGz
         O3j9gltB3cYZCd4DQ9Er9KBWzUa/Rk8pKY9zyv+NtPPWYaWeanvYx4mmgN2x2eippu
         M6kvB4ZWAmjahw3+6G6TdtqjwzkpBRXlfiKG83zQ=
Date:   Thu, 13 Jun 2019 15:56:15 -0700
From:   akpm@linux-foundation.org
To:     stable@vger.kernel.org, pankaj.suryawanshi@einfochips.com,
        mhocko@suse.com, fangsuowu@asrmicro.com, minchan@kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/16] mm/vmscan.c: fix trying to reclaim
 unevictable LRU page
Message-ID: <20190613225615.Xi2rR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmscan.c: fix trying to reclaim unevictable LRU page

There was the below bug report from Wu Fangsuo.

On the CMA allocation path, isolate_migratepages_range() could isolate
unevictable LRU pages and reclaim_clean_page_from_list() can try to
reclaim them if they are clean file-backed pages.

7200 [  680.491097] c4 7125 (syz-executor) page:ffffffbf02f33b40 count:86 mapcount:84 mapping:ffffffc08fa7a810 index:0x24
7201 [  680.531186] c4 7125 (syz-executor) flags: 0x19040c(referenced|uptodate|arch_1|mappedtodisk|unevictable|mlocked)
7202 [  680.544987] c0 7125 (syz-executor) raw: 000000000019040c ffffffc08fa7a810 0000000000000024 0000005600000053
7203 [  680.556162] c0 7125 (syz-executor) raw: ffffffc009b05b20 ffffffc009b05b20 0000000000000000 ffffffc09bf3ee80
7204 [  680.566860] c0 7125 (syz-executor) page dumped because: VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page))
7205 [  680.578038] c0 7125 (syz-executor) page->mem_cgroup:ffffffc09bf3ee80
7206 [  680.585467] c0 7125 (syz-executor) ------------[ cut here ]------------
7207 [  680.592466] c0 7125 (syz-executor) kernel BUG at /home/build/farmland/adroid9.0/kernel/linux/mm/vmscan.c:1350!
7223 [  680.603663] c0 7125 (syz-executor) Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
7224 [  680.611436] c0 7125 (syz-executor) Modules linked in:
7225 [  680.616769] c0 7125 (syz-executor) CPU: 0 PID: 7125 Comm: syz-executor Tainted: G S              4.14.81 #3
7226 [  680.626826] c0 7125 (syz-executor) Hardware name: ASR AQUILAC EVB (DT)
7227 [  680.633623] c0 7125 (syz-executor) task: ffffffc00a54cd00 task.stack: ffffffc009b00000
7228 [  680.641917] c0 7125 (syz-executor) PC is at shrink_page_list+0x1998/0x3240
7229 [  680.649144] c0 7125 (syz-executor) LR is at shrink_page_list+0x1998/0x3240
7230 [  680.656303] c0 7125 (syz-executor) pc : [<ffffff90083a2158>] lr : [<ffffff90083a2158>] pstate: 60400045
7231 [  680.666086] c0 7125 (syz-executor) sp : ffffffc009b05940
..
7342 [  681.671308] c0 7125 (syz-executor) [<ffffff90083a2158>] shrink_page_list+0x1998/0x3240
7343 [  681.679567] c0 7125 (syz-executor) [<ffffff90083a3dc0>] reclaim_clean_pages_from_list+0x3c0/0x4f0
7344 [  681.688793] c0 7125 (syz-executor) [<ffffff900837ed64>] alloc_contig_range+0x3bc/0x650
7347 [  681.717421] c0 7125 (syz-executor) [<ffffff90084925cc>] cma_alloc+0x214/0x668
7348 [  681.724892] c0 7125 (syz-executor) [<ffffff90091e4d78>] ion_cma_allocate+0x98/0x1d8
7349 [  681.732872] c0 7125 (syz-executor) [<ffffff90091e0b20>] ion_alloc+0x200/0x7e0
7350 [  681.740302] c0 7125 (syz-executor) [<ffffff90091e154c>] ion_ioctl+0x18c/0x378
7351 [  681.747738] c0 7125 (syz-executor) [<ffffff90084c6824>] do_vfs_ioctl+0x17c/0x1780
7352 [  681.755514] c0 7125 (syz-executor) [<ffffff90084c7ed4>] SyS_ioctl+0xac/0xc0

Wu found it's due to ad6b67041a45 ("mm: remove SWAP_MLOCK in ttu"). 
Before that, unevictable pages go to cull_mlocked so that we can't reach
the VM_BUG_ON_PAGE line.

To fix the issue, this patch filters out unevictable LRU pages from the
reclaim_clean_pages_from_list in CMA.

Link: http://lkml.kernel.org/r/20190524071114.74202-1-minchan@kernel.org
Fixes: ad6b67041a45 ("mm: remove SWAP_MLOCK in ttu")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Wu Fangsuo <fangsuowu@asrmicro.com>
Debugged-by: Wu Fangsuo <fangsuowu@asrmicro.com>
Tested-by: Wu Fangsuo <fangsuowu@asrmicro.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Suryawanshi <pankaj.suryawanshi@einfochips.com>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-fix-trying-to-reclaim-unevicable-lru-page
+++ a/mm/vmscan.c
@@ -1505,7 +1505,7 @@ unsigned long reclaim_clean_pages_from_l
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
 		if (page_is_file_cache(page) && !PageDirty(page) &&
-		    !__PageMovable(page)) {
+		    !__PageMovable(page) && !PageUnevictable(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}
_
