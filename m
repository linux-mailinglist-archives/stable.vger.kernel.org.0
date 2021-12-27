Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2560047FDB4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhL0Nqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbhL0Nol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:44:41 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22213C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 05:44:40 -0800 (PST)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 12E562E1EAB;
        Mon, 27 Dec 2021 16:44:38 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id OFj3EMUXur-ibLWK0Wc;
        Mon, 27 Dec 2021 16:44:38 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1640612678; bh=CrBnHSCdEp70FGp3/ITRV3lwA1CUFOCa8gmkQWHGz70=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=pPmgqIIew5gAp9t1UaCQkUhghba8dxglZdtdnRRRPz80wkTrdBaOHRtF9izM9N+Jw
         cEhEbhYZ5sNqBsWV5JvejPCjE5z35LBvXwXX9FPFXrITrnznQP8zGXhotqWTH/S4Nz
         DYvjEZYkj7ZU/Rep6QR1CQIdBwKUPb9JabIdAhnI=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 9g5L4Q3bJD-ibPWB0Jj;
        Mon, 27 Dec 2021 16:44:37 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     aarcange@redhat.com, akpm@linux-foundation.org,
        mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com,
        torvalds@linux-foundation.org,
        Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH 5.4] mm: mempolicy: fix THP allocations escaping mempolicy restrictions
Date:   Mon, 27 Dec 2021 16:45:39 +0300
Message-Id: <20211227134539.1447-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1640608459160181@kroah.com>
References: <1640608459160181@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 mm/mempolicy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 87d165923fee..2c4082f71d25 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2143,8 +2143,9 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 			 * memory as well.
 			 */
 			if (!page && (gfp & __GFP_DIRECT_RECLAIM))
-				page = __alloc_pages_node(hpage_node,
-						gfp | __GFP_NORETRY, order);
+				page = __alloc_pages_nodemask(gfp | __GFP_NORETRY,
+							order, hpage_node,
+							nmask);
 
 			goto out;
 		}
-- 
2.32.0

