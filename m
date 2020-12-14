Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA20C2D9E3B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405812AbgLNRwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:52:32 -0500
Received: from mga06.intel.com ([134.134.136.31]:31424 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405207AbgLNRwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:52:31 -0500
IronPort-SDR: kXO12KTzcBQzN1GFsnfmaBn1NG/x064etYWXdAqBH1DN2KHVaPOiAKsDh+aao2x/9WFFskQijt
 bZNOez+l/fig==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="236332522"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="236332522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 09:51:40 -0800
IronPort-SDR: swtEm6rJkgTpQUODoA6cPGsO5yAoFSyHCEZcx0t2WvBuWoF1o65tuwV396Fr5Lw5vXtz0PdTJy
 Tvtg1ap/Oq+w==
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="367550992"
Received: from xshen14-linux.bj.intel.com ([10.238.155.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 09:51:38 -0800
From:   Xiaochen Shen <xiaochen.shen@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, bp@suse.de, tony.luck@intel.com
Cc:     fenghua.yu@intel.com, reinette.chatre@intel.com,
        pei.p.jia@intel.com, xiaochen.shen@intel.com
Subject: [PATCH 4.19] x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled
Date:   Tue, 15 Dec 2020 02:14:02 +0800
Message-Id: <1607969642-4202-1-git-send-email-xiaochen.shen@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607955955252233@kroah.com>
References: <1607955955252233@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 06c5fe9b12dde1b62821f302f177c972bb1c81f9 upstream.

The MBA software controller (mba_sc) is a feedback loop which
periodically reads MBM counters and tries to restrict the bandwidth
below a user-specified value. It tags along the MBM counter overflow
handler to do the updates with 1s interval in mbm_update() and
update_mba_bw().

The purpose of mbm_update() is to periodically read the MBM counters to
make sure that the hardware counter doesn't wrap around more than once
between user samplings. mbm_update() calls __mon_event_count() for local
bandwidth updating when mba_sc is not enabled, but calls mbm_bw_count()
instead when mba_sc is enabled. __mon_event_count() will not be called
for local bandwidth updating in MBM counter overflow handler, but it is
still called when reading MBM local bandwidth counter file
'mbm_local_bytes', the call path is as below:

  rdtgroup_mondata_show()
    mon_event_read()
      mon_event_count()
        __mon_event_count()

In __mon_event_count(), m->chunks is updated by delta chunks which is
calculated from previous MSR value (m->prev_msr) and current MSR value.
When mba_sc is enabled, m->chunks is also updated in mbm_update() by
mistake by the delta chunks which is calculated from m->prev_bw_msr
instead of m->prev_msr. But m->chunks is not used in update_mba_bw() in
the mba_sc feedback loop.

When reading MBM local bandwidth counter file, m->chunks was changed
unexpectedly by mbm_bw_count(). As a result, the incorrect local
bandwidth counter which calculated from incorrect m->chunks is shown to
the user.

Fix this by removing incorrect m->chunks updating in mbm_bw_count() in
MBM counter overflow handler, and always calling __mon_event_count() in
mbm_update() to make sure that the hardware local bandwidth counter
doesn't wrap around.

Test steps:
  # Run workload with aggressive memory bandwidth (e.g., 10 GB/s)
  git clone https://github.com/intel/intel-cmt-cat && cd intel-cmt-cat
  && make
  ./tools/membw/membw -c 0 -b 10000 --read

  # Enable MBA software controller
  mount -t resctrl resctrl -o mba_MBps /sys/fs/resctrl

  # Create control group c1
  mkdir /sys/fs/resctrl/c1

  # Set MB throttle to 6 GB/s
  echo "MB:0=6000;1=6000" > /sys/fs/resctrl/c1/schemata

  # Write PID of the workload to tasks file
  echo `pidof membw` > /sys/fs/resctrl/c1/tasks

  # Read local bytes counters twice with 1s interval, the calculated
  # local bandwidth is not as expected (approaching to 6 GB/s):
  local_1=`cat /sys/fs/resctrl/c1/mon_data/mon_L3_00/mbm_local_bytes`
  sleep 1
  local_2=`cat /sys/fs/resctrl/c1/mon_data/mon_L3_00/mbm_local_bytes`
  echo "local b/w (bytes/s):" `expr $local_2 - $local_1`

Before fix:
  local b/w (bytes/s): 11076796416

After fix:
  local b/w (bytes/s): 5465014272

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_monitor.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/monitor.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_monitor.c
for older stable trees.

Upstream commit abe8f12b4425 ("x86/resctrl: Remove unused struct
mbm_state::chunks_bw") removed unused struct mbm_state::chunks_bw. It
changes the code base in mbm_bw_count().
Apply the change against the code base in older stable trees.

Fixes: ba0f26d8529c (x86/intel_rdt/mba_sc: Prepare for feedback loop)
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1607063279-19437-1-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/intel_rdt_monitor.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index 3d4ec80..344e049 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -291,7 +291,6 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
 	m->chunks_bw += chunks;
-	m->chunks = m->chunks_bw;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -461,15 +460,14 @@ static void mbm_update(struct rdt_domain *d, int rmid)
 	}
 	if (is_mbm_local_enabled()) {
 		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
+		__mon_event_count(rmid, &rr);
 
 		/*
 		 * Call the MBA software controller only for the
 		 * control groups and when user has enabled
 		 * the software controller explicitly.
 		 */
-		if (!is_mba_sc(NULL))
-			__mon_event_count(rmid, &rr);
-		else
+		if (is_mba_sc(NULL))
 			mbm_bw_count(rmid, &rr);
 	}
 }
-- 
1.8.3.1

