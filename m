Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400A5F2224
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 23:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfKFWvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 17:51:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14114 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbfKFWvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 17:51:51 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6Mnqmm027630
        for <stable@vger.kernel.org>; Wed, 6 Nov 2019 14:51:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=dSwdKAQfYz7C+OHgnNdW7b0Q3n07QRmPPJ73bo3ipfs=;
 b=ELCF7P/V93Fe7uNaUwabJuRU0dYxANy+gb5uNyqdO6mL9Ait2b2wnPb8enAkMhhCCktx
 U7n9OpRSUMRVvfZug7YU210qR/xzwu+F+5q60JzYpTt0YP+fA8qilVga69X5hcKie+2l
 Pq65mdPSehvuKfdr3jE0xTJmNTPeUC/mkqU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0hsvk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 14:51:47 -0800
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 14:51:44 -0800
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 5E6AD19E16A81; Wed,  6 Nov 2019 14:51:44 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
CC:     Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>, <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH 1/2] mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
Date:   Wed, 6 Nov 2019 14:51:30 -0800
Message-ID: <20191106225131.3543616-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_08:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911060219
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've encountered a rcu stall in get_mem_cgroup_from_mm():

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
 (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
 <...>
 RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
 <...>
 __memcg_kmem_charge+0x55/0x140
 __alloc_pages_nodemask+0x267/0x320
 pipe_write+0x1ad/0x400
 new_sync_write+0x127/0x1c0
 __kernel_write+0x4f/0xf0
 dump_emit+0x91/0xc0
 writenote+0xa0/0xc0
 elf_core_dump+0x11af/0x1430
 do_coredump+0xc65/0xee0
 ? unix_stream_sendmsg+0x37d/0x3b0
 get_signal+0x132/0x7c0
 do_signal+0x36/0x640
 ? recalc_sigpending+0x17/0x50
 exit_to_usermode_loop+0x61/0xd0
 do_syscall_64+0xd4/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The problem is caused by an exiting task which is associated with
an offline memcg. We're iterating over and over in the
do {} while (!css_tryget_online()) loop, but obviously the memcg won't
become online and the exiting task won't be migrated to a live memcg.

Let's fix it by switching from css_tryget_online() to css_tryget().

As css_tryget_online() cannot guarantee that the memcg won't go
offline, the check is usually useless, except some rare cases
when for example it determines if something should be presented
to a user.

A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
css_tryget() instead of css_tryget_online() in task_get_css()").

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50f5bc55fcec..c5b5f74cfd4d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -939,7 +939,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 			if (unlikely(!memcg))
 				memcg = root_mem_cgroup;
 		}
-	} while (!css_tryget_online(&memcg->css));
+	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.17.1

