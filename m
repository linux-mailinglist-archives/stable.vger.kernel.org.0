Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01D4784CA
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 07:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhLQGEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 01:04:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:32358 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhLQGEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Dec 2021 01:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639721081; x=1671257081;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bFEVMJxeRa9ekTrfK0RrMtiUWZHIrEtrBM4r//TN7XA=;
  b=WOn1VqUTlCknE0hAjOXSM58UwVPFSywKeMpmmkpj9snIi5n2KZ2ko/xZ
   16x+3MbcM/0X65fNJBx2ohM9POX5iJDXsDXXnZZlIuJr7rtfSsdENtbEQ
   sStsA3wgB0NUubs6oYiV223wFiWLUhkaVNunOxELODKqGhoYQuFLP4yT8
   Q1jzQ2yIsWjeuB48dDCS9qlgFNZ5xW5dbNJvT9sNKRDutyXipYk72zPs1
   WNex4Sj7jgl0xGbpdmuOfVgSmUtsfxqxdtlAADV+YO+p+dpBSUBQNlmDo
   a8lOJbzu2bSi4NQl915g4Aj3WP8bHnd7bT/aZh49Y1c6bxxy+c4cBucRF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="219703183"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="219703183"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:04:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="506641621"
Received: from unknown (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.13.11])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:04:38 -0800
From:   Huang Ying <ying.huang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH -V3 RESEND] numa balancing: move some document to make it consistent with the code
Date:   Fri, 17 Dec 2021 14:04:26 +0800
Message-Id: <20211217060426.3076856-1-ying.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
been moved to debugfs.  This patch move the document for these
sysctls from

  Documentation/admin-guide/sysctl/kernel.rst

to

  Documentation/scheduler/sched-debug.rst

to make the document consistent with the code.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/sysctl/kernel.rst | 46 +-----------------
 Documentation/scheduler/index.rst           |  1 +
 Documentation/scheduler/sched-debug.rst     | 54 +++++++++++++++++++++
 3 files changed, 56 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/scheduler/sched-debug.rst

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 0e486f41185e..603469d42fb9 100644
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
diff --git a/Documentation/scheduler/index.rst b/Documentation/scheduler/index.rst
index 88900aabdbf7..30cca8a37b3b 100644
--- a/Documentation/scheduler/index.rst
+++ b/Documentation/scheduler/index.rst
@@ -17,6 +17,7 @@ Linux Scheduler
     sched-nice-design
     sched-rt-group
     sched-stats
+    sched-debug
 
     text_files
 
diff --git a/Documentation/scheduler/sched-debug.rst b/Documentation/scheduler/sched-debug.rst
new file mode 100644
index 000000000000..4d3d24f2a439
--- /dev/null
+++ b/Documentation/scheduler/sched-debug.rst
@@ -0,0 +1,54 @@
+=================
+Scheduler debugfs
+=================
+
+Booting a kernel with CONFIG_SCHED_DEBUG=y will give access to
+scheduler specific debug files under /sys/kernel/debug/sched. Some of
+those files are described below.
+
+numa_balancing
+==============
+
+`numa_balancing` directory is used to hold files to control NUMA
+balancing feature.  If the system overhead from the feature is too
+high then the rate the kernel samples for NUMA hinting faults may be
+controlled by the `scan_period_min_ms, scan_delay_ms,
+scan_period_max_ms, scan_size_mb` files.
+
+
+scan_period_min_ms, scan_delay_ms, scan_period_max_ms, scan_size_mb
+-------------------------------------------------------------------
+
+Automatic NUMA balancing scans tasks address space and unmaps pages to
+detect if pages are properly placed or if the data should be migrated to a
+memory node local to where the task is running.  Every "scan delay" the task
+scans the next "scan size" number of pages in its address space. When the
+end of the address space is reached the scanner restarts from the beginning.
+
+In combination, the "scan delay" and "scan size" determine the scan rate.
+When "scan delay" decreases, the scan rate increases.  The scan delay and
+hence the scan rate of every task is adaptive and depends on historical
+behaviour. If pages are properly placed then the scan delay increases,
+otherwise the scan delay decreases.  The "scan size" is not adaptive but
+the higher the "scan size", the higher the scan rate.
+
+Higher scan rates incur higher system overhead as page faults must be
+trapped and potentially data must be migrated. However, the higher the scan
+rate, the more quickly a tasks memory is migrated to a local node if the
+workload pattern changes and minimises performance impact due to remote
+memory accesses. These files control the thresholds for scan delays and
+the number of pages scanned.
+
+``scan_period_min_ms`` is the minimum time in milliseconds to scan a
+tasks virtual memory. It effectively controls the maximum scanning
+rate for each task.
+
+``scan_delay_ms`` is the starting "scan delay" used for a task when it
+initially forks.
+
+``scan_period_max_ms`` is the maximum time in milliseconds to scan a
+tasks virtual memory. It effectively controls the minimum scanning
+rate for each task.
+
+``scan_size_mb`` is how many megabytes worth of pages are scanned for
+a given scan.
-- 
2.30.2

