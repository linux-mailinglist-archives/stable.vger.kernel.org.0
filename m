Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F01DFED47
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfKPPm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfKPPm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:59 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E152A2073B;
        Sat, 16 Nov 2019 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918978;
        bh=GSCFckh0COSe5QATUp9lJMLCywara0keVaTL3MvZHLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9W0+BN2mcfL/1zBZdOJZS20GqAjPoDKuQInrf4N0yDTWmrL9HZQ9NKzDQZGhIlJU
         X7cFsPG9cFqfX5Uz8AnvwsB2Z7xUVlc2vjrIxR4vLnVeOfHb/xT5gi7Alz1I69VKmU
         b/gkbjKReWpKBMa7cph4Sn1imKVodnsndX4mp3Jk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jithu Joseph <jithu.joseph@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, fenghua.yu@intel.com,
        tony.luck@intel.com, gavin.hindman@intel.com, hpa@zytor.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 088/237] x86/intel_rdt: Prevent pseudo-locking from using stale pointers
Date:   Sat, 16 Nov 2019 10:38:43 -0500
Message-Id: <20191116154113.7417-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jithu Joseph <jithu.joseph@intel.com>

[ Upstream commit b61b8bba18fe2b63d38fdaf9b83de25e2d787dfe ]

When the last CPU in an rdt_domain goes offline, its rdt_domain struct gets
freed. Current pseudo-locking code is unaware of this scenario and tries to
dereference the freed structure in a few places.

Add checks to prevent pseudo-locking code from doing this.

While further work is needed to seamlessly restore resource groups (not
just pseudo-locking) to their configuration when the domain is brought back
online, the immediate issue of invalid pointers is addressed here.

Fixes: f4e80d67a5274 ("x86/intel_rdt: Resctrl files reflect pseudo-locked information")
Fixes: 443810fe61605 ("x86/intel_rdt: Create debugfs files for pseudo-locking testing")
Fixes: 746e08590b864 ("x86/intel_rdt: Create character device exposing pseudo-locked region")
Fixes: 33dc3e410a0d9 ("x86/intel_rdt: Make CPU information accessible for pseudo-locked regions")
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fenghua.yu@intel.com
Cc: tony.luck@intel.com
Cc: gavin.hindman@intel.com
Cc: hpa@zytor.com
Link: https://lkml.kernel.org/r/231f742dbb7b00a31cc104416860e27dba6b072d.1539384145.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt.c             |  7 ++++
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c | 12 +++++--
 arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c | 10 ++++++
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c    | 38 +++++++++++++++------
 4 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt.c b/arch/x86/kernel/cpu/intel_rdt.c
index abb71ac704433..4025fc6dd8f62 100644
--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -610,6 +610,13 @@ static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 			cancel_delayed_work(&d->cqm_limbo);
 		}
 
+		/*
+		 * rdt_domain "d" is going to be freed below, so clear
+		 * its pointer from pseudo_lock_region struct.
+		 */
+		if (d->plr)
+			d->plr->d = NULL;
+
 		kfree(d->ctrl_val);
 		kfree(d->mbps_val);
 		kfree(d->rmid_busy_llc);
diff --git a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
index 627e5c809b33d..efa4a519f5e55 100644
--- a/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
+++ b/arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c
@@ -408,8 +408,16 @@ int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			for_each_alloc_enabled_rdt_resource(r)
 				seq_printf(s, "%s:uninitialized\n", r->name);
 		} else if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
-			seq_printf(s, "%s:%d=%x\n", rdtgrp->plr->r->name,
-				   rdtgrp->plr->d->id, rdtgrp->plr->cbm);
+			if (!rdtgrp->plr->d) {
+				rdt_last_cmd_clear();
+				rdt_last_cmd_puts("Cache domain offline\n");
+				ret = -ENODEV;
+			} else {
+				seq_printf(s, "%s:%d=%x\n",
+					   rdtgrp->plr->r->name,
+					   rdtgrp->plr->d->id,
+					   rdtgrp->plr->cbm);
+			}
 		} else {
 			closid = rdtgrp->closid;
 			for_each_alloc_enabled_rdt_resource(r) {
diff --git a/arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c b/arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c
index 912d53939f4f4..a999a58ca3318 100644
--- a/arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c
+++ b/arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c
@@ -1116,6 +1116,11 @@ static int pseudo_lock_measure_cycles(struct rdtgroup *rdtgrp, int sel)
 		goto out;
 	}
 
+	if (!plr->d) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	plr->thread_done = 0;
 	cpu = cpumask_first(&plr->d->cpu_mask);
 	if (!cpu_online(cpu)) {
@@ -1429,6 +1434,11 @@ static int pseudo_lock_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	plr = rdtgrp->plr;
 
+	if (!plr->d) {
+		mutex_unlock(&rdtgroup_mutex);
+		return -ENODEV;
+	}
+
 	/*
 	 * Task is required to run with affinity to the cpus associated
 	 * with the pseudo-locked region. If this is not the case the task
diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 2013699a5c54a..4f099b48d1ece 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -268,17 +268,27 @@ static int rdtgroup_cpus_show(struct kernfs_open_file *of,
 			      struct seq_file *s, void *v)
 {
 	struct rdtgroup *rdtgrp;
+	struct cpumask *mask;
 	int ret = 0;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 
 	if (rdtgrp) {
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			seq_printf(s, is_cpu_list(of) ? "%*pbl\n" : "%*pb\n",
-				   cpumask_pr_args(&rdtgrp->plr->d->cpu_mask));
-		else
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			if (!rdtgrp->plr->d) {
+				rdt_last_cmd_clear();
+				rdt_last_cmd_puts("Cache domain offline\n");
+				ret = -ENODEV;
+			} else {
+				mask = &rdtgrp->plr->d->cpu_mask;
+				seq_printf(s, is_cpu_list(of) ?
+					   "%*pbl\n" : "%*pb\n",
+					   cpumask_pr_args(mask));
+			}
+		} else {
 			seq_printf(s, is_cpu_list(of) ? "%*pbl\n" : "%*pb\n",
 				   cpumask_pr_args(&rdtgrp->cpu_mask));
+		}
 	} else {
 		ret = -ENOENT;
 	}
@@ -1180,6 +1190,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 	struct rdt_resource *r;
 	struct rdt_domain *d;
 	unsigned int size;
+	int ret = 0;
 	bool sep;
 	u32 ctrl;
 
@@ -1190,11 +1201,18 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 	}
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
-		seq_printf(s, "%*s:", max_name_width, rdtgrp->plr->r->name);
-		size = rdtgroup_cbm_to_size(rdtgrp->plr->r,
-					    rdtgrp->plr->d,
-					    rdtgrp->plr->cbm);
-		seq_printf(s, "%d=%u\n", rdtgrp->plr->d->id, size);
+		if (!rdtgrp->plr->d) {
+			rdt_last_cmd_clear();
+			rdt_last_cmd_puts("Cache domain offline\n");
+			ret = -ENODEV;
+		} else {
+			seq_printf(s, "%*s:", max_name_width,
+				   rdtgrp->plr->r->name);
+			size = rdtgroup_cbm_to_size(rdtgrp->plr->r,
+						    rdtgrp->plr->d,
+						    rdtgrp->plr->cbm);
+			seq_printf(s, "%d=%u\n", rdtgrp->plr->d->id, size);
+		}
 		goto out;
 	}
 
@@ -1224,7 +1242,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 out:
 	rdtgroup_kn_unlock(of->kn);
 
-	return 0;
+	return ret;
 }
 
 /* rdtgroup information files for one cache resource. */
-- 
2.20.1

