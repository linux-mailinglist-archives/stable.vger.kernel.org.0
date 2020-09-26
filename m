Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FA5279614
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 03:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgIZB6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 21:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2932087D;
        Sat, 26 Sep 2020 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085488;
        bh=lW+h60mQehOfV6L6n3TAUxrGnIpl0G//yZIy+1x0y2Q=;
        h=Date:From:To:Subject:From;
        b=QqVCr6RYRU68yNSUc7xA2b74zGTixYCTBPSkAbvwSLTt3dTLiRkmJD5N+YFnf4InZ
         u8fjJEGW9rCNgDw5PmQ+q2t6dHJ0gWDVPK+FA0QVeWbkim3F33Gr6hWEpu/kIUENgU
         3qQCXPFBlznsN00ABJMqiUsSSVulx5Gnp4HpTVQM=
Date:   Fri, 25 Sep 2020 18:58:08 -0700
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, rostedt@goodmis.org,
        songliubraving@fb.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, zhouchengming@bytedance.com
Subject:  [merged]
 kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch removed from
 -mm tree
Message-ID: <20200926015808.ScNJv8sRj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kprobes: fix kill kprobe which has been marked as gone
has been removed from the -mm tree.  Its filename was
     kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: kprobes: fix kill kprobe which has been marked as gone

If a kprobe is marked as gone, we should not kill it again.  Otherwise, we
can disarm the kprobe more than once.  In that case, the statistics of
kprobe_ftrace_enabled can unbalance which can lead to that kprobe do not
work.

Link: https://lkml.kernel.org/r/20200822030055.32383-1-songmuchun@bytedance.com
Fixes: e8386a0cb22f ("kprobes: support probing module __exit function")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c~kprobes-fix-kill-kprobe-which-has-been-marked-as-gone
+++ a/kernel/kprobes.c
@@ -2140,6 +2140,9 @@ static void kill_kprobe(struct kprobe *p
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	if (WARN_ON_ONCE(kprobe_gone(p)))
+		return;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2419,7 +2422,10 @@ static int kprobes_module_callback(struc
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry(p, head, hlist)
+		hlist_for_each_entry(p, head, hlist) {
+			if (kprobe_gone(p))
+				continue;
+
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2436,6 +2442,7 @@ static int kprobes_module_callback(struc
 				 */
 				kill_kprobe(p);
 			}
+		}
 	}
 	if (val == MODULE_STATE_GOING)
 		remove_module_kprobe_blacklist(mod);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

