Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECFE3ED67C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbhHPNVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240574AbhHPNTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5F563308;
        Mon, 16 Aug 2021 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119693;
        bh=pt6iFv0MJ0izqr0FWSVWQGj+RwalPi9oBmkgcCwmTXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4g9lrVuOCVCwSw2xyiffFA0vRamQbsRMe8Yj9cKf9LIyhwNVoX+KBV++A2FYrX1y
         VaS5G559o9kewG/eGCkckA+RdgWjG7K/Dw3BdfDLFIXiz18r4oPv/tIDHSKhJGlIIT
         51eX5jXlhRDBVVvNGhH+mo2e1Tg2Ej812YbdvwnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Szulik?= <pawel.szulik@intel.com>,
        Babu Moger <Babu.Moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.13 124/151] x86/resctrl: Fix default monitoring groups reporting
Date:   Mon, 16 Aug 2021 15:02:34 +0200
Message-Id: <20210816125448.147684576@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/x86/kernel/cpu/resctrl/monitor.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -285,15 +285,14 @@ static u64 mbm_overflow_count(u64 prev_m
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
@@ -305,12 +304,6 @@ static int __mon_event_count(u32 rmid, s
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
@@ -361,23 +354,29 @@ void mon_event_count(void *info)
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


