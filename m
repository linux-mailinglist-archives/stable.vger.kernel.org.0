Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD7468FAA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 04:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhLFDUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 22:20:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:35596 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhLFDUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Dec 2021 22:20:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="237049278"
X-IronPort-AV: E=Sophos;i="5.87,290,1631602800"; 
   d="scan'208";a="237049278"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 19:17:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,290,1631602800"; 
   d="scan'208";a="478972618"
Received: from yhuang6-desk2.sh.intel.com ([10.239.159.50])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 19:17:15 -0800
From:   Huang Ying <ying.huang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH] numa balancing: remove some outdated document
Date:   Mon,  6 Dec 2021 11:16:45 +0800
Message-Id: <20211206031645.3412350-1-ying.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
been moved to debugfs.  This patch removes the document for the
sysctls to keep the document consistent with the code.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org # since v5.13
---
 Documentation/admin-guide/sysctl/kernel.rst | 46 +--------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 426162009ce9..d2679ea6936e 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -609,51 +609,7 @@ be migrated to a local memory node.
 The unmapping of pages and trapping faults incur additional overhead that
 ideally is offset by improved memory locality but there is no universal
 guarantee. If the target workload is already bound to NUMA nodes then this
-feature should be disabled. Otherwise, if the system overhead from the
-feature is too high then the rate the kernel samples for NUMA hinting
-faults may be controlled by the `numa_balancing_scan_period_min_ms,
-numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
-numa_balancing_scan_size_mb`_, and numa_balancing_settle_count sysctls.
-
-
-numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb
-===============================================================================================================================
-
-
-Automatic NUMA balancing scans tasks address space and unmaps pages to
-detect if pages are properly placed or if the data should be migrated to a
-memory node local to where the task is running.  Every "scan delay" the task
-scans the next "scan size" number of pages in its address space. When the
-end of the address space is reached the scanner restarts from the beginning.
-
-In combination, the "scan delay" and "scan size" determine the scan rate.
-When "scan delay" decreases, the scan rate increases.  The scan delay and
-hence the scan rate of every task is adaptive and depends on historical
-behaviour. If pages are properly placed then the scan delay increases,
-otherwise the scan delay decreases.  The "scan size" is not adaptive but
-the higher the "scan size", the higher the scan rate.
-
-Higher scan rates incur higher system overhead as page faults must be
-trapped and potentially data must be migrated. However, the higher the scan
-rate, the more quickly a tasks memory is migrated to a local node if the
-workload pattern changes and minimises performance impact due to remote
-memory accesses. These sysctls control the thresholds for scan delays and
-the number of pages scanned.
-
-``numa_balancing_scan_period_min_ms`` is the minimum time in milliseconds to
-scan a tasks virtual memory. It effectively controls the maximum scanning
-rate for each task.
-
-``numa_balancing_scan_delay_ms`` is the starting "scan delay" used for a task
-when it initially forks.
-
-``numa_balancing_scan_period_max_ms`` is the maximum time in milliseconds to
-scan a tasks virtual memory. It effectively controls the minimum scanning
-rate for each task.
-
-``numa_balancing_scan_size_mb`` is how many megabytes worth of pages are
-scanned for a given scan.
-
+feature should be disabled.
 
 oops_all_cpu_backtrace
 ======================
-- 
2.30.2

