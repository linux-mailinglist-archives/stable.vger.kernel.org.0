Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515433F665C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbhHXRXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238906AbhHXRUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E0E61B01;
        Tue, 24 Aug 2021 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824600;
        bh=oLyHG1QY97lmFj2v8oQmseuWe0Vyeh/5WCM8bOcForc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa5fKFwJw13tjgVxDJP0OJxhZxOg4T7YhIgGmq6CBgraZH0MDr7R7vheJtBRmz94z
         4NcKqYQEa4a68KTkOoR75ozM6uX2OhAVE+YWu0oS5/Pk0NhNdBT+7/2Vzwp9LiAaFz
         uwxWpVIuACLL+L2HhEg18XnEV3VNNF1cqxNQs6HSwiBSJrdp2h2lVeWlsUDTHfjpIn
         pXYuhqizYUEEKCe/JSLzmTfP1YlwhMNT/l5+pQsvdBp4pp6sg5T9qiCQQjN5e77J2i
         HJtdxZlBVBNxhEamWX72JYexwgxuHuNeh7W0XlIqnaE1p61P4HK32T9OBrgIgnV/wO
         DhJa44K+2pFIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Babu Moger <Babu.Moger@amd.com>,
        =?UTF-8?q?Pawe=C5=82=20Szulik?= <pawel.szulik@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 29/84] x86/resctrl: Fix default monitoring groups reporting
Date:   Tue, 24 Aug 2021 13:01:55 -0400
Message-Id: <20210824170250.710392-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Babu Moger <Babu.Moger@amd.com>

commit 064855a69003c24bd6b473b367d364e418c57625 upstream.

Creating a new sub monitoring group in the root /sys/fs/resctrl leads to
getting the "Unavailable" value for mbm_total_bytes and mbm_local_bytes
on the entire filesystem.

Steps to reproduce:

  1. mount -t resctrl resctrl /sys/fs/resctrl/

  2. cd /sys/fs/resctrl/

  3. cat mon_data/mon_L3_00/mbm_total_bytes
     23189832

  4. Create sub monitor group:
  mkdir mon_groups/test1

  5. cat mon_data/mon_L3_00/mbm_total_bytes
     Unavailable

When a new monitoring group is created, a new RMID is assigned to the
new group. But the RMID is not active yet. When the events are read on
the new RMID, it is expected to report the status as "Unavailable".

When the user reads the events on the default monitoring group with
multiple subgroups, the events on all subgroups are consolidated
together. Currently, if any of the RMID reads report as "Unavailable",
then everything will be reported as "Unavailable".

Fix the issue by discarding the "Unavailable" reads and reporting all
the successful RMID reads. This is not a problem on Intel systems as
Intel reports 0 on Inactive RMIDs.

Fixes: d89b7379015f ("x86/intel_rdt/cqm: Add mon_data")
Reported-by: Paweł Szulik <pawel.szulik@intel.com>
Signed-off-by: Babu Moger <Babu.Moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213311
Link: https://lkml.kernel.org/r/162793309296.9224.15871659871696482080.stgit@bmoger-ubuntu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel_rdt_monitor.c | 27 ++++++++++++-------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index 5dfa5ab9a5ae..6eeb17dfde48 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -233,15 +233,14 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr)
 	return chunks >>= shift;
 }
 
-static int __mon_event_count(u32 rmid, struct rmid_read *rr)
+static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 {
 	struct mbm_state *m;
 	u64 chunks, tval;
 
 	tval = __rmid_read(rmid, rr->evtid);
 	if (tval & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL)) {
-		rr->val = tval;
-		return -EINVAL;
+		return tval;
 	}
 	switch (rr->evtid) {
 	case QOS_L3_OCCUP_EVENT_ID:
@@ -253,12 +252,6 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m = &rr->d->mbm_local[rmid];
 		break;
-	default:
-		/*
-		 * Code would never reach here because
-		 * an invalid event id would fail the __rmid_read.
-		 */
-		return -EINVAL;
 	}
 
 	if (rr->first) {
@@ -308,23 +301,29 @@ void mon_event_count(void *info)
 	struct rdtgroup *rdtgrp, *entry;
 	struct rmid_read *rr = info;
 	struct list_head *head;
+	u64 ret_val;
 
 	rdtgrp = rr->rgrp;
 
-	if (__mon_event_count(rdtgrp->mon.rmid, rr))
-		return;
+	ret_val = __mon_event_count(rdtgrp->mon.rmid, rr);
 
 	/*
-	 * For Ctrl groups read data from child monitor groups.
+	 * For Ctrl groups read data from child monitor groups and
+	 * add them together. Count events which are read successfully.
+	 * Discard the rmid_read's reporting errors.
 	 */
 	head = &rdtgrp->mon.crdtgrp_list;
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
-			if (__mon_event_count(entry->mon.rmid, rr))
-				return;
+			if (__mon_event_count(entry->mon.rmid, rr) == 0)
+				ret_val = 0;
 		}
 	}
+
+	/* Report error if none of rmid_reads are successful */
+	if (ret_val)
+		rr->val = ret_val;
 }
 
 /*
-- 
2.30.2

