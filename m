Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17121471E20
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 22:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhLLVyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 16:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhLLVyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 16:54:50 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1923EC061751
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:54:50 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r5so12894595pgi.6
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=/8OVRsiJPfzycoIBaFUpLiGCJmaXlbPVHF8mSMiMH8Q=;
        b=CK9gp77MV7+++wTuD9Dnlo1hbvqdDY/TAgf3/ilq0yvk+lX1vXOK5hoMSQwLxizUWb
         3w0owubA6vZcK+HkgOC0YFDFniDHMmfUwK64M6PN4j77H1LVLge/hFLCM6osSgy/6NEU
         gN5y1eA7Zt1tlJap17Tg2PeKa2Yxlin9C/3RZBnFm80wtoDXylstMmEE1AFWiQ/NVWPv
         Wlr6YrnVCoySZf/cCKWFils7XJMAhjAuoS06p2zHHoNlWCgb5iLt2ohlpNwJCgNU3EbG
         BIKNF+ZrrCL4o5U3vzb1JHAySbzw+GS3Seya6Meu9KoRexynWVqp1QHP+TTtRThPmMhl
         GUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=/8OVRsiJPfzycoIBaFUpLiGCJmaXlbPVHF8mSMiMH8Q=;
        b=QdhV9qfuhbPw9Q+oTQ+EVVtY82Z7MkKNqnSTBngAjaa1gaQvWSUD20X/Vna1wUNgFx
         EhhtSXVq4OdbZBKd7gIcInIXCeiGIimHaUH9ZlBUGovczgc2tL7i03jnWL0YvSimj9Hw
         vphWxwDSxQl9KwMiAtK46EY+7QH25Hn8mXVNV9KBKqGYwMyBVL0cvJiTRezR40U0y0uB
         UxVhow/PNB0i7EbAQOIK0/b60QBSaDeYuO8dZtVDZcyUWC8lBTAXf0ihlZVhF4Cuf0tb
         o0rwczOGE7XRjryK90l9wmTqg91/GPSSYVGTIyftOz5785xksZsjreSTHmd1NbN8h24j
         P6aQ==
X-Gm-Message-State: AOAM5302HkJQxLj+WZCYS7AOr0bjSufy2VqaC69X4xZCM3/tGJjoOSPU
        oqe/BzWkW5NNtMK8SfhsVggk5Q==
X-Google-Smtp-Source: ABdhPJxEOncPjiiHwNG4PyZWuUZriuA4oPsmp+FV3usicBq7H9vO9U7c0ZnxSFcO5QCrzz3C8NAGCA==
X-Received: by 2002:a63:e4f:: with SMTP id 15mr49410974pgo.336.1639346089303;
        Sun, 12 Dec 2021 13:54:49 -0800 (PST)
Received: from [2620:15c:29:204:73a:117b:b001:2508] ([2620:15c:29:204:73a:117b:b001:2508])
        by smtp.gmail.com with ESMTPSA id g1sm7934295pgm.23.2021.12.12.13.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 13:54:48 -0800 (PST)
Date:   Sun, 12 Dec 2021 13:54:47 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] mm: mempolicy: fix THP allocations escaping mempolicy
 restrictions
In-Reply-To: <20211208165343.22349-1-arbn@yandex-team.com>
Message-ID: <d2545429-3d33-65c3-4bb6-f08a593f24@google.com>
References: <20211208165343.22349-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Dec 2021, Andrey Ryabinin wrote:

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

Acked-by: David Rientjes <rientjes@google.com>
