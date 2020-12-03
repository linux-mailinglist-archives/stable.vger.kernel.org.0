Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7C2CE2A1
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 00:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgLCX1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 18:27:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:51637 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLCX1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 18:27:13 -0500
IronPort-SDR: p72wGICYHJ6FGueZkYBIlwC/0chyuTXyZvTRRwuneTXo4vNAgrt2Bir486KUI+dHpYctSYucdM
 bsIeSNoCgx7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="172512669"
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="172512669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 15:26:17 -0800
IronPort-SDR: x8OssM1Ed5zcbgkQkNUJ1Y221zW9VIEJqsZlrdW8kXNai8PR21SiqOIDT/S3BmAihFTWPmOQgf
 I9O2yHMvDY7A==
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="482158932"
Received: from rchatre-mobl1.jf.intel.com ([10.54.70.7])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 15:26:16 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com
Cc:     kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a mask into helpers
Date:   Thu,  3 Dec 2020 15:25:48 -0800
Message-Id: <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1607036601.git.reinette.chatre@intel.com>
References: <cover.1607036601.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

The code of setting the CPU on which a task is running in a CPU mask is
moved into a couple of helpers. The new helper task_on_cpu() will be
reused shortly.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 47 +++++++++++++++++++-------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 6f4ca4bea625..68db7d2dec8f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -525,6 +525,38 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 	kfree(rdtgrp);
 }
 
+#ifdef CONFIG_SMP
+/* Get the CPU if the task is on it. */
+static bool task_on_cpu(struct task_struct *t, int *cpu)
+{
+	/*
+	 * This is safe on x86 w/o barriers as the ordering of writing to
+	 * task_cpu() and t->on_cpu is reverse to the reading here. The
+	 * detection is inaccurate as tasks might move or schedule before
+	 * the smp function call takes place. In such a case the function
+	 * call is pointless, but there is no other side effect.
+	 */
+	if (t->on_cpu) {
+		*cpu = task_cpu(t);
+
+		return true;
+	}
+
+	return false;
+}
+
+static void set_task_cpumask(struct task_struct *t, struct cpumask *mask)
+{
+	int cpu;
+
+	if (mask && task_on_cpu(t, &cpu))
+		cpumask_set_cpu(cpu, mask);
+}
+#else
+static inline void
+set_task_cpumask(struct task_struct *t, struct cpumask *mask) { }
+#endif
+
 struct task_move_callback {
 	struct callback_head	work;
 	struct rdtgroup		*rdtgrp;
@@ -2327,19 +2359,8 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			t->closid = to->closid;
 			t->rmid = to->mon.rmid;
 
-#ifdef CONFIG_SMP
-			/*
-			 * This is safe on x86 w/o barriers as the ordering
-			 * of writing to task_cpu() and t->on_cpu is
-			 * reverse to the reading here. The detection is
-			 * inaccurate as tasks might move or schedule
-			 * before the smp function call takes place. In
-			 * such a case the function call is pointless, but
-			 * there is no other side effect.
-			 */
-			if (mask && t->on_cpu)
-				cpumask_set_cpu(task_cpu(t), mask);
-#endif
+			/* If the task is on a CPU, set the CPU in the mask. */
+			set_task_cpumask(t, mask);
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
2.26.2

