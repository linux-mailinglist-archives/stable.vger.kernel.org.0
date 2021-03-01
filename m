Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C6E3291B9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbhCAUbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238699AbhCAUYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FBA165403;
        Mon,  1 Mar 2021 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621955;
        bh=37dKgdLpzs8/0e34RHsBPLueAh+R+liTrxox0oIBtc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpUJzpmpxZcBGriUn3eMnrDfqbA4VUIj2p6OfoYmhDNR0U1SowYoh3sb9jd0EeXQj
         RbXV/sKwaKVM25lBEkG5z/Gw5FotzIcwLXEhPmqwbJ0/DWa9Xh5fV1CsW8a9ti4FgE
         s+MF5F5AFqcXsV2zO2gTPdrnxRY6BBMlK+2pVO+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 705/775] mm/vmscan: restore zone_reclaim_mode ABI
Date:   Mon,  1 Mar 2021 17:14:33 +0100
Message-Id: <20210301161236.194203607@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 519983645a9f2ec339cabfa0c6ef7b09be985dd0 upstream.

I went to go add a new RECLAIM_* mode for the zone_reclaim_mode sysctl.
Like a good kernel developer, I also went to go update the
documentation.  I noticed that the bits in the documentation didn't
match the bits in the #defines.

The VM never explicitly checks the RECLAIM_ZONE bit.  The bit is,
however implicitly checked when checking 'node_reclaim_mode==0'.  The
RECLAIM_ZONE #define was removed in a cleanup.  That, by itself is fine.

But, when the bit was removed (bit 0) the _other_ bit locations also got
changed.  That's not OK because the bit values are documented to mean
one specific thing.  Users surely do not expect the meaning to change
from kernel to kernel.

The end result is that if someone had a script that did:

	sysctl vm.zone_reclaim_mode=1

it would have gone from enabling node reclaim for clean unmapped pages
to writing out pages during node reclaim after the commit in question.
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/vm.rst |   10 +++++-----
 mm/vmscan.c                             |    9 +++++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
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
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
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


