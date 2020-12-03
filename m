Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CD62CE15F
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgLCWKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 17:10:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43588 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgLCWKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 17:10:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Lrpwa004871;
        Thu, 3 Dec 2020 22:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=23yexcHdOapSPAxxWiXrX5VndJabrs3xPZqc8iWgG4k=;
 b=YfiLPGk3+WXqYcec59yf4oBokHYF+nbt7VP+uvNG+YHBlXAyKM1uZrjTNaw5QtT14P2y
 DLC7bzajN3gR6QcyZjpmUq2/nCP5PNRN4c+V9It1nKQa5phYWGiMOBwziOP8pW5xa4ur
 u0B1sapFoqDVwTc817L+xJw3WGZhf45k6S/Uag1h6k9mgawVuTrOUrGt75kLFLaMcWKv
 0p8lrxvynTxigZpm78mDw0rqw3gPHRhm+NsVC4S6ItoUOiO58MPOdRwxVbwmKcjQDbb7
 5+9QosemEnKRZgRIn4Im8pdO9gRW20UUAL7TYhrFXD4osv6a7MBSMEEXhyADQ4MD/JkZ HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyr0gan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 22:04:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LuRHV003859;
        Thu, 3 Dec 2020 22:02:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f2furp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 22:02:56 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3M2s8C021245;
        Thu, 3 Dec 2020 22:02:54 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 14:02:54 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Cc:     Mina Almasry <almasrymina@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Shuah Khan <shuah@kernel.org>,
        Adrian Moreno <amorenoz@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlb_cgroup: fix offline of hugetlb cgroup with reservations
Date:   Thu,  3 Dec 2020 14:02:42 -0800
Message-Id: <20201203220242.158165-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 1adc4d419aa2 ("hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations")
Cc: <stable@vger.kernel.org>
Reported-by: Adrian Moreno <amorenoz@redhat.com>
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb_cgroup.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 1f87aec9ab5c..9182848dda3e 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -82,11 +82,8 @@ static inline bool hugetlb_cgroup_have_usage(struct hugetlb_cgroup *h_cg)
 
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
@@ -202,9 +199,10 @@ static void hugetlb_cgroup_css_offline(struct cgroup_subsys_state *css)
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
-- 
2.28.0

