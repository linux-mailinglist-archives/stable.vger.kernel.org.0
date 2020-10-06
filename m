Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ADE285372
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 22:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgJFUvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 16:51:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:19137 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbgJFUvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 16:51:12 -0400
IronPort-SDR: a6QM8dw4z4V548MFSkh3NQL+Of0/m/hlDtuT+4JxOg5Zy7/lSM9k6SpixUNVDieFcB7tAxX7+X
 oGsLttuV5MjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="152454188"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="152454188"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 13:51:11 -0700
IronPort-SDR: ThRDdl6ikpNqol+iBAMJr2C3/ya8aMME4bycWZ8aQD0E7KThJqin9g/T9Jzm9zzRM7Y6OeAOsT
 EnV0ez9kGbqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="342499677"
Received: from viggo.jf.intel.com (HELO localhost.localdomain) ([10.54.77.144])
  by fmsmga004.fm.intel.com with ESMTP; 06 Oct 2020 13:51:10 -0700
Subject: [RFC][PATCH 01/12] mm/vmscan: restore zone_reclaim_mode ABI
To:     linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, ben.widawsky@intel.com,
        rientjes@google.com, alex.shi@linux.alibaba.com, dwagner@suse.de,
        tobin@kernel.org, cl@linux.com, akpm@linux-foundation.org,
        ying.huang@intel.com, dan.j.williams@intel.com, cai@lca.pw,
        stable@vger.kernel.org
From:   Dave Hansen <dave.hansen@linux.intel.com>
Date:   Tue, 06 Oct 2020 13:51:06 -0700
References: <20201006205103.268F74A9@viggo.jf.intel.com>
In-Reply-To: <20201006205103.268F74A9@viggo.jf.intel.com>
Message-Id: <20201006205106.52F4D02E@viggo.jf.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I went to go add a new RECLAIM_* mode for the zone_reclaim_mode
sysctl.  Like a good kernel developer, I also went to go update the
documentation.  I noticed that the bits in the documentation didn't
match the bits in the #defines.

The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
however implicitly checked when checking 'node_reclaim_mode==0'.
The RECLAIM_ZONE #define was removed in a cleanup.  That, by itself
is fine.

But, when the bit was removed (bit 0) the _other_ bit locations also
got changed.  That's not OK because the bit values are documented to
mean one specific thing and users surely rely on them meaning that one
thing and not changing from kernel to kernel.  The end result is that
if someone had a script that did:

	sysctl vm.zone_reclaim_mode=1

This script would have gone from enalbing node reclaim for clean
unmapped pages to writing out pages during node reclaim after the
commit in question.  That's not great.

Put the bits back the way they were and add a comment so something
like this is a bit harder to do again.  Update the documentation to
make it clear that the first bit is ignored.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: 648b5cf368e0 ("mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE")
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: stable@vger.kernel.org

--

Changes from v2:
 * Update description to indicate that bit0 was used for clean
   unmapped page node reclaim.
---

 b/Documentation/admin-guide/sysctl/vm.rst |   10 +++++-----
 b/mm/vmscan.c                             |    9 +++++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi Documentation/admin-guide/sysctl/vm.rst
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi	2020-10-06 13:39:20.595818443 -0700
+++ b/Documentation/admin-guide/sysctl/vm.rst	2020-10-06 13:39:20.601818443 -0700
@@ -976,11 +976,11 @@ that benefit from having their data cach
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
diff -puN mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi	2020-10-06 13:39:20.597818443 -0700
+++ b/mm/vmscan.c	2020-10-06 13:39:20.602818443 -0700
@@ -4083,8 +4083,13 @@ module_init(kswapd_init)
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
