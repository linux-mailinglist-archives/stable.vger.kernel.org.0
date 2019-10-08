Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F978D00A2
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfJHSUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 14:20:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E06C2070B;
        Tue,  8 Oct 2019 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570558829;
        bh=SJoyQA8rpYenxgrnVWe1jR7JC/TuDXYdVMLS4k0kHFo=;
        h=Date:From:To:Subject:From;
        b=KvhC0tZNnNBwupuCpdVDoaSwj8m/KCx4zY+Ck/DZhsvSOeMC5f1eYS5cqFKWz+r8q
         5aDz6ww5sxFBHYi0O3p9eFejVri+YeNQQfXqmAM7TCKWiSPlUzc2DMJyktm3/KvuBq
         HrBAYtHWVFq2NOlVmfumjZCs3SLBUID8uvn8xZY8=
Date:   Tue, 08 Oct 2019 11:20:29 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, xypron.glpk@gmx.de
Subject:  [merged]
 kernel-sysctlc-do-not-override-max_threads-provided-by-userspace.patch
 removed from -mm tree
Message-ID: <20191008182029.byQLOWETR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: do not override max_threads provided by userspace
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-do-not-override-max_threads-provided-by-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: kernel/sysctl.c: do not override max_threads provided by userspace

Partially revert 16db3d3f1170 ("kernel/sysctl.c: threads-max observe
limits") because the patch is causing a regression to any workload which
needs to override the auto-tuning of the limit provided by kernel.

set_max_threads is implementing a boot time guesstimate to provide a
sensible limit of the concurrently running threads so that runaways will
not deplete all the memory.  This is a good thing in general but there are
workloads which might need to increase this limit for an application to
run (reportedly WebSpher MQ is affected) and that is simply not possible
after the mentioned change.  It is also very dubious to override an admin
decision by an estimation that doesn't have any direct relation to
correctness of the kernel operation.

Fix this by dropping set_max_threads from sysctl_max_threads so any value
is accepted as long as it fits into MAX_THREADS which is important to
check because allowing more threads could break internal robust futex
restriction.  While at it, do not use MIN_THREADS as the lower boundary
because it is also only a heuristic for automatic estimation and admin
might have a good reason to stop new threads to be created even when below
this limit.

This became more severe when we switched x86 from 4k to 8k kernel stacks. 
Starting since 6538b8ea886e ("x86_64: expand kernel stack to 16K") (3.16)
we use THREAD_SIZE_ORDER = 2 and that halved the auto-tuned value.

In the particular case
3.12
kernel.threads-max = 515561

4.4
kernel.threads-max = 200000

Neither of the two values is really insane on 32GB machine.

I am not sure we want/need to tune the max_thread value further.  If
anything the tuning should be removed altogether if proven not useful in
general.  But we definitely need a way to override this auto-tuning.

Link: http://lkml.kernel.org/r/20190922065801.GB18814@dhcp22.suse.cz
Fixes: 16db3d3f1170 ("kernel/sysctl.c: threads-max observe limits")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~kernel-sysctlc-do-not-override-max_threads-provided-by-userspace
+++ a/kernel/fork.c
@@ -2925,7 +2925,7 @@ int sysctl_max_threads(struct ctl_table
 	struct ctl_table t;
 	int ret;
 	int threads = max_threads;
-	int min = MIN_THREADS;
+	int min = 1;
 	int max = MAX_THREADS;
 
 	t = *table;
@@ -2937,7 +2937,7 @@ int sysctl_max_threads(struct ctl_table
 	if (ret || !write)
 		return ret;
 
-	set_max_threads(threads);
+	max_threads = threads;
 
 	return 0;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are


