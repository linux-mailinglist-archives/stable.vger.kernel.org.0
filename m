Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840082D62C8
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392119AbgLJQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391024AbgLJQ6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 11:58:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBACFC0613CF;
        Thu, 10 Dec 2020 08:57:59 -0800 (PST)
Date:   Thu, 10 Dec 2020 16:57:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607619477;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Dk+j8f4SMBkGP28rH/XZ3AY/EJSuuo9gA+ZZVs/63k=;
        b=VNN/U0j9Wtq4QkXkU+0wu4smU0dheKziZZCxe0pFpPB1/5nF4pU+k0shP9XTXJFsQGTeYk
        6QOe7/s814BPpC/5YrXB50M65Mt9e2J+jcwx6MCnLOcm0UwFYE5phnHWX/PdOPqj6FeLMG
        A2sGrR+Mt4D8AOwPVGp9pMeg/Md8r1GDf+wK8RVmVceVhfFwOkhWdr4LKHOViQsRsWzEvR
        eLStud9B7Te+aZrREVvWQFithajWyl7LNWJWgjkDFiQ964LCRK+xfJqW11n/p3bVvkDv0m
        uR7hBTwgNpiOIEbekx5A4A7tq9xv/C/pKa8LnriauBWoC/WlSZFs/pPNO/VncA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607619477;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Dk+j8f4SMBkGP28rH/XZ3AY/EJSuuo9gA+ZZVs/63k=;
        b=HYCznEtDo2zPHpsHs9QyKNoAT3jX/Gs/oWzTRtTp79FkIIwoMO/ueNrA2jAWHoQWLTZI9J
        kz5FgkZyXkanZYCQ==
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix incorrect local bandwidth when
 mba_sc is enabled
Cc:     Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1607063279-19437-1-git-send-email-xiaochen.shen@intel.com>
References: <1607063279-19437-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <160761947623.3364.17511692146380778670.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     06c5fe9b12dde1b62821f302f177c972bb1c81f9
Gitweb:        https://git.kernel.org/tip/06c5fe9b12dde1b62821f302f177c972bb1c81f9
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Fri, 04 Dec 2020 14:27:59 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 10 Dec 2020 17:52:37 +01:00

x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled

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
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 54dffe5..a98519a 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -279,7 +279,6 @@ static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 		return;
 
 	chunks = mbm_overflow_count(m->prev_bw_msr, tval, rr->r->mbm_width);
-	m->chunks += chunks;
 	cur_bw = (chunks * r->mon_scale) >> 20;
 
 	if (m->delta_comp)
@@ -450,15 +449,14 @@ static void mbm_update(struct rdt_resource *r, struct rdt_domain *d, int rmid)
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
