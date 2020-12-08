Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9282D1F46
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgLHArf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgLHArf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 19:47:35 -0500
Date:   Mon, 07 Dec 2020 16:46:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388394;
        bh=zUWxD+wImBg7cELnxorlezM0MwN7gceIg0wVtw59kRA=;
        h=From:To:Subject:From;
        b=RvMSYGrwqh7jyNj1Tce/P6JuRsimbu+pwZAC5PVm3jo1NjjioiQruO9g1twBXCq+H
         Zet22/tBwnikpHvCBWYgz5SW/fmpJ/gwKYHZ39qzVPLO7Tc5AMyB8ZOh7+TiOf6fG0
         aa9mp/Z0XwFY9chP+hZFKs1bFZCm5GZJfeiqosIc=
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, amorenoz@redhat.com, gthelen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com,
        shuah@kernel.org, stable@vger.kernel.org
Subject:  [merged]
 hugetlb_cgroup-fix-offline-of-hugetlb-cgroup-with-reservations.patch
 removed from -mm tree
Message-ID: <20201208004633.mXUsIPLpX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix offline of hugetlb cgroup with reservations
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-fix-offline-of-hugetlb-cgroup-with-reservations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb_cgroup: fix offline of hugetlb cgroup with reservations

Adrian Moreno was ruuning a kubernetes 1.19 + containerd/docker workload
using hugetlbfs.  In this environment the issue is reproduced by:
1 - Start a simple pod that uses the recently added HugePages medium
    feature (pod yaml attached)
2 - Start a DPDK app. It doesn't need to run successfully (as in transfer
    packets) nor interact with real hardware. It seems just initializing
    the EAL layer (which handles hugepage reservation and locking) is
    enough to trigger the issue
3 - Delete the Pod (or let it "Complete").

This would result in a kworker thread going into a tight loop (top output):
 1425 root      20   0       0      0      0 R  99.7   0.0   5:22.45
kworker/28:7+cgroup_destroy

'perf top -g' reports:
-   63.28%     0.01%  [kernel]                    [k] worker_thread
   - 49.97% worker_thread
      - 52.64% process_one_work
         - 62.08% css_killed_work_fn
            - hugetlb_cgroup_css_offline
                 41.52% _raw_spin_lock
               - 2.82% _cond_resched
                    rcu_all_qs
                 2.66% PageHuge
      - 0.57% schedule
         - 0.57% __schedule

We are spinning in the do-while loop in hugetlb_cgroup_css_offline.
Worse yet, we are holding the master cgroup lock (cgroup_mutex) while
infinitely spinning.  Little else can be done on the system as the
cgroup_mutex can not be acquired.

Do note that the issue can be reproduced by simply offlining a hugetlb
cgroup containing pages with reservation counts.

The loop in hugetlb_cgroup_css_offline is moving page counts from the
cgroup being offlined to the parent cgroup.  This is done for each hstate,
and is repeated until hugetlb_cgroup_have_usage returns false.  The routine
moving counts (hugetlb_cgroup_move_parent) is only moving 'usage' counts.
The routine hugetlb_cgroup_have_usage is checking for both 'usage' and
'reservation' counts.  Discussion about what to do with reservation
counts when reparenting was discussed here:

https://lore.kernel.org/linux-kselftest/CAHS8izMFAYTgxym-Hzb_JmkTK1N_S9tGN71uS6MFV+R7swYu5A@mail.gmail.com/

The decision was made to leave a zombie cgroup for with reservation
counts.  Unfortunately, the code checking reservation counts was
incorrectly added to hugetlb_cgroup_have_usage.

To fix the issue, simply remove the check for reservation counts.  While
fixing this issue, a related bug in hugetlb_cgroup_css_offline was noticed.
The hstate index is not reinitialized each time through the do-while loop.
Fix this as well.

Link: https://lkml.kernel.org/r/20201203220242.158165-1-mike.kravetz@oracle.com
Fixes: 1adc4d419aa2 ("hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations")
Reported-by: Adrian Moreno <amorenoz@redhat.com>
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-fix-offline-of-hugetlb-cgroup-with-reservations
+++ a/mm/hugetlb_cgroup.c
@@ -82,11 +82,8 @@ static inline bool hugetlb_cgroup_have_u
 
 	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
 		if (page_counter_read(
-			    hugetlb_cgroup_counter_from_cgroup(h_cg, idx)) ||
-		    page_counter_read(hugetlb_cgroup_counter_from_cgroup_rsvd(
-			    h_cg, idx))) {
+				hugetlb_cgroup_counter_from_cgroup(h_cg, idx)))
 			return true;
-		}
 	}
 	return false;
 }
@@ -202,9 +199,10 @@ static void hugetlb_cgroup_css_offline(s
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
 	struct hstate *h;
 	struct page *page;
-	int idx = 0;
+	int idx;
 
 	do {
+		idx = 0;
 		for_each_hstate(h) {
 			spin_lock(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


