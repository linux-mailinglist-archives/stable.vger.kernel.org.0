Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D6431FDD9
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 18:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBSR1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 12:27:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:27846 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhBSR1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 12:27:41 -0500
IronPort-SDR: xRBAIFzRxiS1+NFZza2XMtcaldFs5On+TLcvoPnsBGy8w7w+qIK5lW2w42IVry9TYJpChxeTTH
 dWsKGQSX/xDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="203196519"
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="203196519"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 09:25:56 -0800
IronPort-SDR: i86jnxvVXXy+Awa+I48RyYFBw1xpukl3obg9Bv1+XsBywag/allcLKm2s4cYlumn4uvQx8vanu
 Gbm/wqBAmAjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="365276113"
Received: from viggo.jf.intel.com (HELO localhost.localdomain) ([10.54.77.144])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2021 09:25:55 -0800
Subject: [PATCH 1/3] mm/vmscan: restore zone_reclaim_mode ABI
To:     dave@sr71.net
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, ben.widawsky@intel.com,
        osalvador@suse.de, rientjes@google.com, cl@linux.com,
        alex.shi@linux.alibaba.com, dwagner@suse.de, tobin@kernel.org,
        akpm@linux-foundation.org, ying.huang@intel.com,
        dan.j.williams@intel.com, cai@lca.pw, stable@vger.kernel.org
From:   Dave Hansen <dave.hansen@linux.intel.com>
Date:   Fri, 19 Feb 2021 09:25:55 -0800
References: <20210219172553.B1E1A317@viggo.jf.intel.com>
In-Reply-To: <20210219172553.B1E1A317@viggo.jf.intel.com>
Message-Id: <20210219172555.FF0CDF23@viggo.jf.intel.com>
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
mean one specific thing.  Users surely do not expect the meaning to
change from kernel to kernel.

The end result is that if someone had a script that did:

	sysctl vm.zone_reclaim_mode=1

it would have gone from enabling node reclaim for clean unmapped
pages to writing out pages during node reclaim after the commit in
question.  That's not great.

Put the bits back the way they were and add a comment so something
like this is a bit harder to do again.  Update the documentation to
make it clear that the first bit is ignored.

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
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi	2021-02-19 09:25:26.656663105 -0800
+++ b/Documentation/admin-guide/sysctl/vm.rst	2021-02-19 09:25:26.662663105 -0800
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
diff -puN mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi	2021-02-19 09:25:26.658663105 -0800
+++ b/mm/vmscan.c	2021-02-19 09:25:26.665663105 -0800
@@ -4095,8 +4095,13 @@ module_init(kswapd_init)
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
