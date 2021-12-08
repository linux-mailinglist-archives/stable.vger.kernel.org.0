Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B939A46D92A
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 18:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbhLHRG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 12:06:59 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39700 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhLHRG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 12:06:56 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 240B31FD26;
        Wed,  8 Dec 2021 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638983003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s4gf+GnBTZj35lejPEzW+m7/Sfx1dKT/0lrMZKP5eE4=;
        b=NXQl1lHMNCTYbYqIlsYcw1pvNAEHX4MnStYqOC567FSTozMGZZ1yNgUDWlHbmYhEhS7Y1d
        JMfrybbx/9rgom2Eojr1UDDFUHQhZLrMBYYej9N1NEP4bYiTLBck/HIv3AY+op21tU2EVV
        8hq9q9XNZtqRqeCyL4D8Ntkk1S9A8Q0=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8BCA7A3B93;
        Wed,  8 Dec 2021 17:03:22 +0000 (UTC)
Date:   Wed, 8 Dec 2021 18:03:22 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: mempolicy: fix THP allocations escaping mempolicy
 restrictions
Message-ID: <YbDlWiW5P7tlqlZj@dhcp22.suse.cz>
References: <20211208165343.22349-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208165343.22349-1-arbn@yandex-team.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 08-12-21 19:53:43, Andrey Ryabinin wrote:
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

Looks good to me.
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/mempolicy.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 10e9c87260ed..f6248affaf38 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2140,8 +2140,7 @@ struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>  			 * memory with both reclaim and compact as well.
>  			 */
>  			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
> -				page = __alloc_pages_node(hpage_node,
> -								gfp, order);
> +				page = __alloc_pages(gfp, order, hpage_node, nmask);
>  
>  			goto out;
>  		}
> -- 
> 2.32.0

-- 
Michal Hocko
SUSE Labs
