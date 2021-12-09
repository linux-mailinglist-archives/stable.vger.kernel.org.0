Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010CC46E965
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 14:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhLINxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 08:53:36 -0500
Received: from foss.arm.com ([217.140.110.172]:57070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhLINxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 08:53:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EA0411B3;
        Thu,  9 Dec 2021 05:50:02 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.196.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584633F73B;
        Thu,  9 Dec 2021 05:50:01 -0800 (PST)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -V2] numa balancing: move some document to make it consistent with the code
In-Reply-To: <20211209004442.999696-1-ying.huang@intel.com>
References: <20211209004442.999696-1-ying.huang@intel.com>
Date:   Thu, 09 Dec 2021 13:49:58 +0000
Message-ID: <8735n1anw9.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/12/21 08:44, Huang Ying wrote:
> After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
> debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
> been moved to debugfs.  This patch move the document for these
> sysctls from
>
>   Documentation/admin-guide/sysctl/kernel.rst
>
> to
>
>   Documentation/scheduler/debug.txt
>

AFAIA new documentation files should be written in reST, and the "source"
file is .rst so the new one should be too (as much as Peter hates it).

Also, most files in there are named sched-*.rst, does that want to be
sched-debug.rst ?

> to make the document consistent with the code.
>
> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: stable@vger.kernel.org # since v5.13

> diff --git a/Documentation/scheduler/debug.txt b/Documentation/scheduler/debug.txt
> new file mode 100644
> index 000000000000..848d83c3123c
> --- /dev/null
> +++ b/Documentation/scheduler/debug.txt
> @@ -0,0 +1,48 @@
> +Scheduler debugfs
> +

How about a small intro?

---
diff --git a/Documentation/scheduler/debug.txt b/Documentation/scheduler/debug.txt
index 848d83c3123c..08600de5b90e 100644
--- a/Documentation/scheduler/debug.txt
+++ b/Documentation/scheduler/debug.txt
@@ -1,4 +1,10 @@
+=================
 Scheduler debugfs
+=================
+
+Booting a kernel with CONFIG_SCHED_DEBUG=y will give access to scheduler
+-specific debug files under /sys/kernel/debug/sched. Some of those files are
+described below.
 
 numa_balancing
 --------------
---

> +numa_balancing
> +--------------

I think you got the heading ordering wrong, see
  Documentation/doc-guide/sphinx.rst#Specific guidelines for the kernel documentation

IIRC Sphinx/reST only requires heading ordering to be consistent within a
given file, but having consistency throughout the project simplifies
reviewing/contributing. In this case, headings with "=" must appear before
headings with "-".

> +
> +`numa_balancing` directory is used to hold files to control NUMA
> +balancing feature.  If the system overhead from the feature is too
> +high then the rate the kernel samples for NUMA hinting faults may be
> +controlled by the `scan_period_min_ms, scan_delay_ms,
> +scan_period_max_ms, scan_size_mb` files.
> +
> +
> +scan_period_min_ms, scan_delay_ms, scan_period_max_ms, scan_size_mb
> +===================================================================
> +
> +Automatic NUMA balancing scans tasks address space and unmaps pages to
> +detect if pages are properly placed or if the data should be migrated to a
> +memory node local to where the task is running.  Every "scan delay" the task
> +scans the next "scan size" number of pages in its address space. When the
> +end of the address space is reached the scanner restarts from the beginning.
> +
> +In combination, the "scan delay" and "scan size" determine the scan rate.
> +When "scan delay" decreases, the scan rate increases.  The scan delay and
> +hence the scan rate of every task is adaptive and depends on historical
> +behaviour. If pages are properly placed then the scan delay increases,
> +otherwise the scan delay decreases.  The "scan size" is not adaptive but
> +the higher the "scan size", the higher the scan rate.
> +
> +Higher scan rates incur higher system overhead as page faults must be
> +trapped and potentially data must be migrated. However, the higher the scan
> +rate, the more quickly a tasks memory is migrated to a local node if the
> +workload pattern changes and minimises performance impact due to remote
> +memory accesses. These files control the thresholds for scan delays and
> +the number of pages scanned.
> +
> +``scan_period_min_ms`` is the minimum time in milliseconds to scan a
> +tasks virtual memory. It effectively controls the maximum scanning
> +rate for each task.
> +
> +``scan_delay_ms`` is the starting "scan delay" used for a task when it
> +initially forks.
> +
> +``scan_period_max_ms`` is the maximum time in milliseconds to scan a
> +tasks virtual memory. It effectively controls the minimum scanning
> +rate for each task.
> +
> +``scan_size_mb`` is how many megabytes worth of pages are scanned for
> +a given scan.
> --
> 2.30.2
