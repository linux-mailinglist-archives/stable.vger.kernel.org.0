Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96A647FCA5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhL0Me2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhL0Me2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:34:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A56BC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 04:34:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CF7460FE4
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCAEC36AE7;
        Mon, 27 Dec 2021 12:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640608467;
        bh=BS0hljxwoL24w/gcDMrNFMP7WIkm5S9tUAlzexP5Fyk=;
        h=Subject:To:Cc:From:Date:From;
        b=iTJ0dglbFwrJY1CY/2jC2bJvHe7ZhBzw3fUZyc3nqSarwnS/PCRZjDokydQOLX9UT
         Jm5HuYByJPpv5mO+06s6XhU6VgyH3u9571g8N4RJXfeBDiCLhvriITMJL5+OXWduFe
         l6NQGSN8U1WRpnklzDK8OBrRLy5cyXqaYKa2gcT8=
Subject: FAILED: patch "[PATCH] mm: mempolicy: fix THP allocations escaping mempolicy" failed to apply to 5.4-stable tree
To:     arbn@yandex-team.com, aarcange@redhat.com,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        mhocko@suse.com, rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 13:34:19 +0100
Message-ID: <1640608459160181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 338635340669d5b317c7e8dcf4fff4a0f3651d87 Mon Sep 17 00:00:00 2001
From: Andrey Ryabinin <arbn@yandex-team.com>
Date: Fri, 24 Dec 2021 21:12:35 -0800
Subject: [PATCH] mm: mempolicy: fix THP allocations escaping mempolicy
 restrictions

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
("mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings").

The bug disappeared later in the commit 89c83fb539f9 ("mm, thp:
consolidate THP gfp handling into alloc_hugepage_direct_gfpmask") and
reappeared again in slightly different form in the commit 76e654cc91bb
("mm, page_alloc: allow hugepage fallback to remote nodes when
madvised")

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 10e9c87260ed..f6248affaf38 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2140,8 +2140,7 @@ struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 			 * memory with both reclaim and compact as well.
 			 */
 			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
-				page = __alloc_pages_node(hpage_node,
-								gfp, order);
+				page = __alloc_pages(gfp, order, hpage_node, nmask);
 
 			goto out;
 		}

