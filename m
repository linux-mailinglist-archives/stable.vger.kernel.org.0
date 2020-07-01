Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80C3210F4A
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgGAP3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 11:29:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:27246 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgGAP3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 11:29:54 -0400
IronPort-SDR: u12ehlGk2bZD2+A79AS0I94QhNN2Eh0SgqbDX7H3RiOwt1tXQLsEAIXNl1T+zbIPQW9eMayYSI
 2XhUw2Nqb0uw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="211664191"
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="211664191"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 08:29:53 -0700
IronPort-SDR: MATPxC2NxKlfAgUDaGpHd5kBCQSE7i0usf4jUnqYf9Kqooj4xzplQR/F0CEfB8wloMMj/uwBQ+
 6nCJR6paZMvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="295592133"
Received: from viggo.jf.intel.com (HELO localhost.localdomain) ([10.54.77.144])
  by orsmga002.jf.intel.com with ESMTP; 01 Jul 2020 08:29:53 -0700
Subject: [PATCH 1/3] mm/vmscan: restore zone_reclaim_mode ABI
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>,
        ben.widawsky@intel.com, alex.shi@linux.alibaba.com,
        dwagner@suse.de, tobin@kernel.org, cl@linux.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        dan.j.williams@intel.com, cai@lca.pw, stable@vger.kernel.org
From:   Dave Hansen <dave.hansen@linux.intel.com>
Date:   Wed, 01 Jul 2020 08:26:23 -0700
References: <20200701152621.D520E62B@viggo.jf.intel.com>
In-Reply-To: <20200701152621.D520E62B@viggo.jf.intel.com>
Message-Id: <20200701152623.384AF0A7@viggo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
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

That script went from doing nothing to writing out pages during
node reclaim after the commit in question.  That's not great.

Put the bits back the way they were and add a comment so something
like this is a bit harder to do again.  Update the documentation to
make it clear that the first bit is ignored.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: 648b5cf368e0 ("mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE")
Cc: Ben Widawsky <ben.widawsky@intel.com>
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
---

 b/Documentation/admin-guide/sysctl/vm.rst |   10 +++++-----
 b/mm/vmscan.c                             |    9 +++++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi Documentation/admin-guide/sysctl/vm.rst
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-vmscan-restore-old-zone_reclaim_mode-abi	2020-07-01 08:22:11.354955336 -0700
+++ b/Documentation/admin-guide/sysctl/vm.rst	2020-07-01 08:22:11.360955336 -0700
@@ -948,11 +948,11 @@ that benefit from having their data cach
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
--- a/mm/vmscan.c~mm-vmscan-restore-old-zone_reclaim_mode-abi	2020-07-01 08:22:11.356955336 -0700
+++ b/mm/vmscan.c	2020-07-01 08:22:11.362955336 -0700
@@ -4090,8 +4090,13 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
+/*
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
+ * ABI.  New bits are OK, but existing bits can never change.
+ */
+#define RECLAIM_ZONE  (1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
+#define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
 
 /*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
_
