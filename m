Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948C449257
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFQVTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbfFQVTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C695020861;
        Mon, 17 Jun 2019 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806357;
        bh=01A+5FQdFk3a/VescfSS65qNI0btr0uawUD+sFtJ9B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvvxQ/zrD2OZc/+Wkbndwb2SlYy9rpPsCUwmL8ysG6JZlcYNmnFL971pfhtRKilrz
         VGLC4rnRpvsCFprrlFJ5hQ2e7jlPHRke4dkF0267mgARjT5OI4ktKxrO4Qk6NXFA1P
         vMTgYoj4v0jUgcCe2tWScyKqUAPGmF3jeyh/eNdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Wu Fangsuo <fangsuowu@asrmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Pankaj Suryawanshi <pankaj.suryawanshi@einfochips.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 024/115] mm/vmscan.c: fix trying to reclaim unevictable LRU page
Date:   Mon, 17 Jun 2019 23:08:44 +0200
Message-Id: <20190617210801.162984798@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit a58f2cef26e1ca44182c8b22f4f4395e702a5795 upstream.

There was the below bug report from Wu Fangsuo.

On the CMA allocation path, isolate_migratepages_range() could isolate
unevictable LRU pages and reclaim_clean_page_from_list() can try to
reclaim them if they are clean file-backed pages.

  page:ffffffbf02f33b40 count:86 mapcount:84 mapping:ffffffc08fa7a810 index:0x24
  flags: 0x19040c(referenced|uptodate|arch_1|mappedtodisk|unevictable|mlocked)
  raw: 000000000019040c ffffffc08fa7a810 0000000000000024 0000005600000053
  raw: ffffffc009b05b20 ffffffc009b05b20 0000000000000000 ffffffc09bf3ee80
  page dumped because: VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page))
  page->mem_cgroup:ffffffc09bf3ee80
  ------------[ cut here ]------------
  kernel BUG at /home/build/farmland/adroid9.0/kernel/linux/mm/vmscan.c:1350!
  Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 7125 Comm: syz-executor Tainted: G S              4.14.81 #3
  Hardware name: ASR AQUILAC EVB (DT)
  task: ffffffc00a54cd00 task.stack: ffffffc009b00000
  PC is at shrink_page_list+0x1998/0x3240
  LR is at shrink_page_list+0x1998/0x3240
  pc : [<ffffff90083a2158>] lr : [<ffffff90083a2158>] pstate: 60400045
  sp : ffffffc009b05940
  ..
     shrink_page_list+0x1998/0x3240
     reclaim_clean_pages_from_list+0x3c0/0x4f0
     alloc_contig_range+0x3bc/0x650
     cma_alloc+0x214/0x668
     ion_cma_allocate+0x98/0x1d8
     ion_alloc+0x200/0x7e0
     ion_ioctl+0x18c/0x378
     do_vfs_ioctl+0x17c/0x1780
     SyS_ioctl+0xac/0xc0

Wu found it's due to commit ad6b67041a45 ("mm: remove SWAP_MLOCK in
ttu").  Before that, unevictable pages go to cull_mlocked so that we
can't reach the VM_BUG_ON_PAGE line.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1502,7 +1502,7 @@ unsigned long reclaim_clean_pages_from_l
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
 		if (page_is_file_cache(page) && !PageDirty(page) &&
-		    !__PageMovable(page)) {
+		    !__PageMovable(page) && !PageUnevictable(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}


