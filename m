Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263112D6056
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391958AbgLJPrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391222AbgLJOjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:33 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Moreno <amorenoz@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Mina Almasry <almasrymina@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shuah Khan <shuah@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 55/75] hugetlb_cgroup: fix offline of hugetlb cgroup with reservations
Date:   Thu, 10 Dec 2020 15:27:20 +0100
Message-Id: <20201210142608.763373590@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 7a5bde37983d37783161681ff7c6122dfd081791 upstream.

Adrian Moreno was ruuning a kubernetes 1.19 + containerd/docker workload
using hugetlbfs.  In this environment the issue is reproduced by:

 - Start a simple pod that uses the recently added HugePages medium
   feature (pod yaml attached)

 - Start a DPDK app. It doesn't need to run successfully (as in transfer
   packets) nor interact with real hardware. It seems just initializing
   the EAL layer (which handles hugepage reservation and locking) is
   enough to trigger the issue

 - Delete the Pod (or let it "Complete").

This would result in a kworker thread going into a tight loop (top output):

   1425 root      20   0       0      0      0 R  99.7   0.0   5:22.45 kworker/28:7+cgroup_destroy

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
cgroup being offlined to the parent cgroup.  This is done for each
hstate, and is repeated until hugetlb_cgroup_have_usage returns false.
The routine moving counts (hugetlb_cgroup_move_parent) is only moving
'usage' counts.  The routine hugetlb_cgroup_have_usage is checking for
both 'usage' and 'reservation' counts.  Discussion about what to do with
reservation counts when reparenting was discussed here:

https://lore.kernel.org/linux-kselftest/CAHS8izMFAYTgxym-Hzb_JmkTK1N_S9tGN71uS6MFV+R7swYu5A@mail.gmail.com/

The decision was made to leave a zombie cgroup for with reservation
counts.  Unfortunately, the code checking reservation counts was
incorrectly added to hugetlb_cgroup_have_usage.

To fix the issue, simply remove the check for reservation counts.  While
fixing this issue, a related bug in hugetlb_cgroup_css_offline was
noticed.  The hstate index is not reinitialized each time through the
do-while loop.  Fix this as well.

Fixes: 1adc4d419aa2 ("hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations")
Reported-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201203220242.158165-1-mike.kravetz@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb_cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
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


