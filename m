Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49747FFF3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbhL0PmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbhL0Pki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D415AC0698DD;
        Mon, 27 Dec 2021 07:39:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 375E0CE10DC;
        Mon, 27 Dec 2021 15:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289D2C36AE7;
        Mon, 27 Dec 2021 15:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619554;
        bh=UfI2l7MKdpIDdmbm6n9Ia6bMEuxjDiEvpZnBpVYoEyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9GVMv3uC4V27fZGqtzz8RmHflyz4LrcBr/BECkLkEFA/tM1uWK7ggMvO3lRTiSPj
         CFu/pynWbWRG43YzFKq9/j8MCPXSZVi8L2el8NLYfwWE2Dl1r5D/1HUrB5UyKz7afD
         D9zcBUE3JLwGpqrd5D0WY2RKmd8JxKuySBZ76XSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 64/76] mm: mempolicy: fix THP allocations escaping mempolicy restrictions
Date:   Mon, 27 Dec 2021 16:31:19 +0100
Message-Id: <20211227151326.910063787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <arbn@yandex-team.com>

commit 338635340669d5b317c7e8dcf4fff4a0f3651d87 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2222,8 +2222,8 @@ alloc_pages_vma(gfp_t gfp, int order, st
 			 * memory with both reclaim and compact as well.
 			 */
 			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
-				page = __alloc_pages_node(hpage_node,
-								gfp, order);
+				page = __alloc_pages_nodemask(gfp, order,
+							hpage_node, nmask);
 
 			goto out;
 		}


