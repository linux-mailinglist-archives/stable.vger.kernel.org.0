Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8262E6644
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbgL1QLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388361AbgL1NWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2834206ED;
        Mon, 28 Dec 2020 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161758;
        bh=QfqfVDkEZadu+swJT4ZFbYm03D2i4eGeVCEs5nTdaNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8GJw0yqHZ1nHobG643+y4jGFKqkXSxYvkurDL4nGUNat0EqJlxXmMz5ohJ3rhBQg
         Ew6aGixtoAb7pm7CVs/jk/r4piyNIfYoNISWOrybtGVTfPNI9POKSJycfUn8y7Dx3S
         7bJTsQDJq5jNUyPxhEofoT+YSjqWJY93QRHXxV/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 054/346] x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled
Date:   Mon, 28 Dec 2020 13:46:13 +0100
Message-Id: <20201228124922.403987487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

commit 06c5fe9b12dde1b62821f302f177c972bb1c81f9 upstream

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

Fixes: ba0f26d8529c (x86/intel_rdt/mba_sc: Prepare for feedback loop)
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1607063279-19437-1-git-send-email-xiaochen.shen@intel.com
[sudip: manual backport to file at old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel_rdt_monitor.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -290,7 +290,6 @@ static void mbm_bw_count(u32 rmid, struc
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval);
-	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -460,15 +459,14 @@ static void mbm_update(struct rdt_domain
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


