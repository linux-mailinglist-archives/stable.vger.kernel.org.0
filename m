Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B0447F200
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 06:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhLYFMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 00:12:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 00:12:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00743B80AEA;
        Sat, 25 Dec 2021 05:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627B7C36AE5;
        Sat, 25 Dec 2021 05:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409156;
        bh=uNyKebTzcIdoglhu867uyKUwwjmt/U1M4h+OErPnlAs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z4spDwkGBXW72yMFNbBX5Rad5oFe+mgXRuhMnaY/X3gioxuD37YNttVgc6opgB/yf
         m4tgra8mjYTWXbFBJ1lwhDO+Bo5dlzIIyXDYUp6tYLcGeIxoG9jmyttquldDkBy2KB
         82L/avVMYi4MQMmfBI0h+qslNE2i/JvCQZiVlq88=
Date:   Fri, 24 Dec 2021 21:12:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        arbn@yandex-team.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 2/9] mm: mempolicy: fix THP allocations escaping
 mempolicy restrictions
Message-ID: <20211225051235.JoA_I5IqL%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: mm: mempolicy: fix THP allocations escaping mempolicy restrictions

alloc_pages_vma() may try to allocate THP page on the local NUMA node
first:

	page = __alloc_pages_node(hpage_node,
		gfp | __GFP_THISNODE | __GFP_NORETRY, order);

And if the allocation fails it retries allowing remote memory:

	if (!page && (gfp & __GFP_DIRECT_RECLAIM))
    		page = __alloc_pages_node(hpage_node,
					gfp, order);

However, this retry allocation completely ignores memory policy nodemask
allowing allocation to escape restrictions.

The first appearance of this bug seems to be the commit ac5b2c18911f
 ("mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings")
The bug disappeared later in the commit 89c83fb539f9
 ("mm, thp: consolidate THP gfp handling into alloc_hugepage_direct_gfpmask")
and reappeared again in slightly different form in the commit 76e654cc91bb
 ("mm, page_alloc: allow hugepage fallback to remote nodes when madvised")

Fix this by passing correct nodemask to the __alloc_pages() call.

The demonstration/reproducer of the problem:
 $ mount -oremount,size=4G,huge=always /dev/shm/
 $ echo always > /sys/kernel/mm/transparent_hugepage/defrag
 $ cat mbind_thp.c
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <assert.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <numaif.h>

 #define SIZE 2ULL << 30
 int main(int argc, char **argv)
 {
   int fd;
   unsigned long long i;
   char *addr;
   pid_t pid;
   char buf[100];
   unsigned long nodemask = 1;

   fd = open("/dev/shm/test", O_RDWR|O_CREAT);
   assert(fd > 0);
   assert(ftruncate(fd, SIZE) == 0);

   addr = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,
                        MAP_SHARED, fd, 0);

   assert(mbind(addr, SIZE, MPOL_BIND, &nodemask, 2, MPOL_MF_STRICT|MPOL_MF_MOVE)==0);
   for (i = 0; i < SIZE; i+=4096) {
     addr[i] = 1;
   }
   pid = getpid();
   snprintf(buf, sizeof(buf), "grep shm /proc/%d/numa_maps", pid);
   system(buf);
   sleep(10000);

   return 0;
 }
 $ gcc mbind_thp.c -o mbind_thp -lnuma
 $ numactl -H
 available: 2 nodes (0-1)
 node 0 cpus: 0 2
 node 0 size: 1918 MB
 node 0 free: 1595 MB
 node 1 cpus: 1 3
 node 1 size: 2014 MB
 node 1 free: 1731 MB
 node distances:
 node   0   1
   0:  10  20
   1:  20  10
 $ rm -f /dev/shm/test; taskset -c 0 ./mbind_thp
 7fd970a00000 bind:0 file=/dev/shm/test dirty=524288 active=0 N0=396800 N1=127488 kernelpagesize_kB=4

Link: https://lkml.kernel.org/r/20211208165343.22349-1-arbn@yandex-team.com
Fixes: ac5b2c18911f ("mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-thp-allocations-escaping-mempolicy-restrictions
+++ a/mm/mempolicy.c
@@ -2140,8 +2140,7 @@ struct page *alloc_pages_vma(gfp_t gfp,
 			 * memory with both reclaim and compact as well.
 			 */
 			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
-				page = __alloc_pages_node(hpage_node,
-								gfp, order);
+				page = __alloc_pages(gfp, order, hpage_node, nmask);
 
 			goto out;
 		}
_
