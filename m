Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5A46FE4F
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 10:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbhLJKDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 05:03:07 -0500
Received: from outbound-smtp10.blacknight.com ([46.22.139.15]:36915 "EHLO
        outbound-smtp10.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234244AbhLJKDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 05:03:07 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2021 05:03:06 EST
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp10.blacknight.com (Postfix) with ESMTPS id D85F41C3E76
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 09:52:26 +0000 (GMT)
Received: (qmail 28236 invoked from network); 10 Dec 2021 09:52:26 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.197.169])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 10 Dec 2021 09:52:26 -0000
Date:   Fri, 10 Dec 2021 09:52:25 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: mempolicy: fix THP allocations escaping mempolicy
 restrictions
Message-ID: <20211210095225.GP3366@techsingularity.net>
References: <20211208165343.22349-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20211208165343.22349-1-arbn@yandex-team.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 08, 2021 at 07:53:43PM +0300, Andrey Ryabinin wrote:
> alloc_pages_vma() may try to allocate THP page on the local
> NUMA node first:
> 	page = __alloc_pages_node(hpage_node,
> 		gfp | __GFP_THISNODE | __GFP_NORETRY, order);
> 
> And if the allocation fails it retries allowing remote memory:
> 
> 	if (!page && (gfp & __GFP_DIRECT_RECLAIM))
>     		page = __alloc_pages_node(hpage_node,
> 					gfp, order);
> 
> However, this retry allocation completely ignores memory policy
> nodemask allowing allocation to escape restrictions.
> 
> The first appearance of this bug seems to be the commit ac5b2c18911f
>  ("mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings")
> The bug disappeared later in the commit 89c83fb539f9
>  ("mm, thp: consolidate THP gfp handling into alloc_hugepage_direct_gfpmask")
> and reappeared again in slightly different form in the commit 76e654cc91bb
>  ("mm, page_alloc: allow hugepage fallback to remote nodes when madvised")
> 
> Fix this by passing correct nodemask to the __alloc_pages() call.
> 
> The demonstration/reproducer of the problem:
>  $ mount -oremount,size=4G,huge=always /dev/shm/
>  $ echo always > /sys/kernel/mm/transparent_hugepage/defrag
>  $ cat mbind_thp.c
>  #include <unistd.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <assert.h>
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <numaif.h>
> 
>  #define SIZE 2ULL << 30
>  int main(int argc, char **argv)
>  {
>    int fd;
>    unsigned long long i;
>    char *addr;
>    pid_t pid;
>    char buf[100];
>    unsigned long nodemask = 1;
> 
>    fd = open("/dev/shm/test", O_RDWR|O_CREAT);
>    assert(fd > 0);
>    assert(ftruncate(fd, SIZE) == 0);
> 
>    addr = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,
>                         MAP_SHARED, fd, 0);
> 
>    assert(mbind(addr, SIZE, MPOL_BIND, &nodemask, 2, MPOL_MF_STRICT|MPOL_MF_MOVE)==0);
>    for (i = 0; i < SIZE; i+=4096) {
>      addr[i] = 1;
>    }
>    pid = getpid();
>    snprintf(buf, sizeof(buf), "grep shm /proc/%d/numa_maps", pid);
>    system(buf);
>    sleep(10000);
> 
>    return 0;
>  }
>  $ gcc mbind_thp.c -o mbind_thp -lnuma
>  $ numactl -H
>  available: 2 nodes (0-1)
>  node 0 cpus: 0 2
>  node 0 size: 1918 MB
>  node 0 free: 1595 MB
>  node 1 cpus: 1 3
>  node 1 size: 2014 MB
>  node 1 free: 1731 MB
>  node distances:
>  node   0   1
>    0:  10  20
>    1:  20  10
>  $ rm -f /dev/shm/test; taskset -c 0 ./mbind_thp
>  7fd970a00000 bind:0 file=/dev/shm/test dirty=524288 active=0 N0=396800 N1=127488 kernelpagesize_kB=4
> 
> Fixes: ac5b2c18911f ("mm: thp: relax __GFP_THISNODE for MADV_HUGEPAGE mappings")
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> Cc: <stable@vger.kernel.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
