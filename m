Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698023EAA24
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 20:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbhHLSUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 14:20:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60186 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhHLSUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 14:20:49 -0400
Date:   Thu, 12 Aug 2021 18:20:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628792423;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdSEWpA4eYdj6EDd4MZ9kRKF2N2wRdJ7VjjHq4d3yn4=;
        b=fIvpDgiOlNZfP95qC5IAjViDOSGbrQEQTQFd4H1HIbfJit4uWtqy6lWZpPOA8K5G6qPnzn
        Vl3jcBGiakEwUxYYmKXYH/xRSYnJLVjq6L9sMjaKf/CIL7gNPjohMxtOHKtrJerGmrG5qd
        d+4D9hWRjBVP3uwzXBe0h75YL2IrEa1LqU5zuD0+tYbHfIVO1HJWOpBznBjSWi7Tkv1kfY
        b3zZoJcgNCBiAuXUtCeyWWlGWFa0cF8iJSo11lvcJ5LPgeAxHU5h6mzmM/X4wsfiM3n2b/
        VqunhrVmcFvBKbSmUIyj6fHqZcUfcF19RgvTGvLqLLgOYllHHX+AtP0HUq0ZEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628792423;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdSEWpA4eYdj6EDd4MZ9kRKF2N2wRdJ7VjjHq4d3yn4=;
        b=QNwTi7nVJ9sEXkW6WtqL7ZigQ40sUoOxCtViGV78Y3nt0HXm3b92xgN7jHKSeAhPlkBJEs
        PiwZ/UndmZfsrKBw==
From:   "tip-bot2 for Babu Moger" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix default monitoring groups reporting
Cc:     pawel.szulik@intel.com, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <162793309296.9224.15871659871696482080.stgit@bmoger-ubuntu>
References: <162793309296.9224.15871659871696482080.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Message-ID: <162879242193.395.18004814397189147411.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     064855a69003c24bd6b473b367d364e418c57625
Gitweb:        https://git.kernel.org/tip/064855a69003c24bd6b473b367d364e418c=
57625
Author:        Babu Moger <Babu.Moger@amd.com>
AuthorDate:    Mon, 02 Aug 2021 14:38:58 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 12 Aug 2021 20:12:20 +02:00

x86/resctrl: Fix default monitoring groups reporting

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
Reported-by: Pawe=C5=82 Szulik <pawel.szulik@intel.com>
Signed-off-by: Babu Moger <Babu.Moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D213311
Link: https://lkml.kernel.org/r/162793309296.9224.15871659871696482080.stgit@=
bmoger-ubuntu
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 27 ++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resc=
trl/monitor.c
index f07c10b..57e4bb6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -285,15 +285,14 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr=
, unsigned int width)
 	return chunks >>=3D shift;
 }
=20
-static int __mon_event_count(u32 rmid, struct rmid_read *rr)
+static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 {
 	struct mbm_state *m;
 	u64 chunks, tval;
=20
 	tval =3D __rmid_read(rmid, rr->evtid);
 	if (tval & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL)) {
-		rr->val =3D tval;
-		return -EINVAL;
+		return tval;
 	}
 	switch (rr->evtid) {
 	case QOS_L3_OCCUP_EVENT_ID:
@@ -305,12 +304,6 @@ static int __mon_event_count(u32 rmid, struct rmid_read =
*rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m =3D &rr->d->mbm_local[rmid];
 		break;
-	default:
-		/*
-		 * Code would never reach here because
-		 * an invalid event id would fail the __rmid_read.
-		 */
-		return -EINVAL;
 	}
=20
 	if (rr->first) {
@@ -361,23 +354,29 @@ void mon_event_count(void *info)
 	struct rdtgroup *rdtgrp, *entry;
 	struct rmid_read *rr =3D info;
 	struct list_head *head;
+	u64 ret_val;
=20
 	rdtgrp =3D rr->rgrp;
=20
-	if (__mon_event_count(rdtgrp->mon.rmid, rr))
-		return;
+	ret_val =3D __mon_event_count(rdtgrp->mon.rmid, rr);
=20
 	/*
-	 * For Ctrl groups read data from child monitor groups.
+	 * For Ctrl groups read data from child monitor groups and
+	 * add them together. Count events which are read successfully.
+	 * Discard the rmid_read's reporting errors.
 	 */
 	head =3D &rdtgrp->mon.crdtgrp_list;
=20
 	if (rdtgrp->type =3D=3D RDTCTRL_GROUP) {
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
-			if (__mon_event_count(entry->mon.rmid, rr))
-				return;
+			if (__mon_event_count(entry->mon.rmid, rr) =3D=3D 0)
+				ret_val =3D 0;
 		}
 	}
+
+	/* Report error if none of rmid_reads are successful */
+	if (ret_val)
+		rr->val =3D ret_val;
 }
=20
 /*
