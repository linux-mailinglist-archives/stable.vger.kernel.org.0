Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9C295397
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505298AbgJUUo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 16:44:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505026AbgJUUo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 16:44:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LKiCWd162250;
        Wed, 21 Oct 2020 20:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=1b8YRCjA/uvkQdkZbUeVGHOgdFx9CEWFOQ/Jb+PIWWc=;
 b=EYv7vOYML6S00NFk6CmZRhtPZjcDRyjPbSE/XlfY4XUadiruIkhpj3opG4bAhexwH6BB
 kshbgx8yq6RGLixVHCBloBss3vB4QHBz7ChITvtcQn6lyRIiXOgiogA2MQgB3p+zhb4x
 FjNkEdZPbu0Fx3awiSWcQDQyjnFoTT5rb6ycleitsq0U8WAiRN2YtiWnpPsu9Pm5vF90
 tET7OqHukLmH/PFuQlTOHW+hBvaoUtBxa/RIUc5KNWnaGawZWkOVWpdWk/Q2DccuItSk
 8PkHql863X/Dlas7TTjEjmNOjKYxCmUUXtD5NxP6UnhenPQNrz+XkSUVh0qDXyrM7LKj pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16k3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 20:44:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LKZ0ik100071;
        Wed, 21 Oct 2020 20:44:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 348ahy1bh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 20:44:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09LKiff1003552;
        Wed, 21 Oct 2020 20:44:41 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 13:44:41 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlb_cgroup: fix reservation accounting
Date:   Wed, 21 Oct 2020 13:44:26 -0700
Message-Id: <20201021204426.36069-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Privoznik was using "free page reporting" in QEMU/virtio-balloon
with hugetlbfs and hit the warning below.  QEMU with free page hinting
uses fallocate(FALLOC_FL_PUNCH_HOLE) to discard pages that are reported
as free by a VM. The reporting granularity is in pageblock granularity.
So when the guest reports 2M chunks, we fallocate(FALLOC_FL_PUNCH_HOLE)
one huge page in QEMU.

[  315.251417] ------------[ cut here ]------------
[  315.251424] WARNING: CPU: 7 PID: 6636 at mm/page_counter.c:57 page_counter_uncharge+0x4b/0x50
[  315.251425] Modules linked in: ...
[  315.251466] CPU: 7 PID: 6636 Comm: qemu-system-x86 Not tainted 5.9.0 #137
[  315.251467] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS PRO/X570 AORUS PRO, BIOS F21 07/31/2020
[  315.251469] RIP: 0010:page_counter_uncharge+0x4b/0x50
...
[  315.251479] Call Trace:
[  315.251485]  hugetlb_cgroup_uncharge_file_region+0x4b/0x80
[  315.251487]  region_del+0x1d3/0x300
[  315.251489]  hugetlb_unreserve_pages+0x39/0xb0
[  315.251492]  remove_inode_hugepages+0x1a8/0x3d0
[  315.251495]  ? tlb_finish_mmu+0x7a/0x1d0
[  315.251497]  hugetlbfs_fallocate+0x3c4/0x5c0
[  315.251519]  ? kvm_arch_vcpu_ioctl_run+0x614/0x1700 [kvm]
[  315.251522]  ? file_has_perm+0xa2/0xb0
[  315.251524]  ? inode_security+0xc/0x60
[  315.251525]  ? selinux_file_permission+0x4e/0x120
[  315.251527]  vfs_fallocate+0x146/0x290
[  315.251529]  __x64_sys_fallocate+0x3e/0x70
[  315.251531]  do_syscall_64+0x33/0x40
[  315.251533]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
...
[  315.251542] ---[ end trace 4c88c62ccb1349c9 ]---

Investigation of the issue uncovered bugs in hugetlb cgroup reservation
accounting.  This patch addresses the found issues.

Fixes: 075a61d07a8e ("hugetlb_cgroup: add accounting for shared mappings")
Cc: <stable@vger.kernel.org>
Reported-by: Michal Privoznik <mprivozn@redhat.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 67fc6383995b..b853a11de14f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -655,6 +655,8 @@ static long region_del(struct resv_map *resv, long f, long t)
 			}
 
 			del += t - f;
+			hugetlb_cgroup_uncharge_file_region(
+				resv, rg, t - f);
 
 			/* New entry for end of split region */
 			nrg->from = t;
@@ -667,9 +669,6 @@ static long region_del(struct resv_map *resv, long f, long t)
 			/* Original entry is trimmed */
 			rg->to = f;
 
-			hugetlb_cgroup_uncharge_file_region(
-				resv, rg, nrg->to - nrg->from);
-
 			list_add(&nrg->link, &rg->link);
 			nrg = NULL;
 			break;
@@ -685,17 +684,17 @@ static long region_del(struct resv_map *resv, long f, long t)
 		}
 
 		if (f <= rg->from) {	/* Trim beginning of region */
-			del += t - rg->from;
-			rg->from = t;
-
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
 							    t - rg->from);
-		} else {		/* Trim end of region */
-			del += rg->to - f;
-			rg->to = f;
 
+			del += t - rg->from;
+			rg->from = t;
+		} else {		/* Trim end of region */
 			hugetlb_cgroup_uncharge_file_region(resv, rg,
 							    rg->to - f);
+
+			del += rg->to - f;
+			rg->to = f;
 		}
 	}
 
@@ -2454,6 +2453,9 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
+		if (deferred_reserve)
+			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
+					pages_per_huge_page(h), page);
 	}
 	return page;
 
-- 
2.25.4

