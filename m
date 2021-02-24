Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341403244FC
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 21:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhBXUKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 15:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235385AbhBXUJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE8564F23;
        Wed, 24 Feb 2021 20:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197356;
        bh=6uZAIWo00IIlfca439cq6f0bs6LY/39RlcishU7qFJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=S9O5QbeZKjn956bTm527aEuDSv+5HUVYmBTRmRGq6PUGt892WCBjgHCNgiA/lFZtS
         8hBD/I4ICCbHqovlrvcQAnEaHvIcNeA8BEQXD2xoTtmwkFl8Ls99ivazAKQOp06Qpt
         EQKJ39Uizh8yDk4GrrJIGU3Xsjfv+A+IptZe1PKU=
Date:   Wed, 24 Feb 2021 12:09:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        ben.widawsky@intel.com, cai@lca.pw, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        dwagner@suse.de, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, rientjes@google.com, stable@vger.kernel.org,
        tobin@kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 152/173] mm/vmscan: restore zone_reclaim_mode ABI
Message-ID: <20210224200915.lASg4FukJ%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/vmscan: restore zone_reclaim_mode ABI

I went to go add a new RECLAIM_* mode for the zone_reclaim_mode
sysctl.  Like a good kernel developer, I also went to go update the
documentation.  I noticed that the bits in the documentation didn't
match the bits in the #defines.

The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
however implicitly checked when checking 'node_reclaim_mode==0'.  The
RECLAIM_ZONE #define was removed in a cleanup.  That, by itself is
fine.

But, when the bit was removed (bit 0) the _other_ bit locations also got
changed.  That's not OK because the bit values are documented to mean one
specific thing.  Users surely do not expect the meaning to change from
kernel to kernel.

The end result is that if someone had a script that did:

	sysctl vm.zone_reclaim_mode=1

it would have gone from enabling node reclaim for clean unmapped pages to
writing out pages during node reclaim after the commit in question. 
That's not great.

Put the bits back the way they were and add a comment so something like
this is a bit harder to do again.  Update the documentation to make it
clear that the first bit is ignored.

Link: https://lkml.kernel.org/r/20210219172555.FF0CDF23@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: 648b5cf368e0 ("mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE")
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   10 +++++-----
 mm/vmscan.c                             |    9 +++++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-zone_reclaim_mode-abi
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -983,11 +983,11 @@ that benefit from having their data cach
 left disabled as the caching effect is likely to be more important than
 data locality.
 
-zone_reclaim may be enabled if it's known that the workload is partitioned
-such that each partition fits within a NUMA node and that accessing remote
-memory would cause a measurable performance reduction.  The page allocator
-will then reclaim easily reusable pages (those page cache pages that are
-currently not used) before allocating off node pages.
+Consider enabling one or more zone_reclaim mode bits if it's known that the
+workload is partitioned such that each partition fits within a NUMA node
+and that accessing remote memory would cause a measurable performance
+reduction.  The page allocator will take additional actions before
+allocating off node pages.
 
 Allowing zone reclaim to write out pages stops processes that are
 writing large amounts of data from dirtying pages on other nodes. Zone
--- a/mm/vmscan.c~mm-vmscan-restore-zone_reclaim_mode-abi
+++ a/mm/vmscan.c
@@ -4085,8 +4085,13 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
+/*
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
+ * ABI.  New bits are OK, but existing bits can never change.
+ */
+#define RECLAIM_ZONE  (1<<0)   /* Run shrink_inactive_list on the zone */
+#define RECLAIM_WRITE (1<<1)   /* Writeout pages during reclaim */
+#define RECLAIM_UNMAP (1<<2)   /* Unmap pages during reclaim */
 
 /*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
_
