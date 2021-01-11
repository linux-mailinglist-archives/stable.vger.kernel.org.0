Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36CB2F24DF
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404027AbhALAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:55464 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbhAKXW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 18:22:28 -0500
IronPort-SDR: TWotZNRv+xD4wmCLaQz8vkV40n5m96YpTeJA7waidHdgOF/3Man7/5Ht3vVPy2PqIeigobf5V9
 U1WJDMtCiAYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="174443398"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="174443398"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 15:21:48 -0800
IronPort-SDR: pUUPMeApWvf36wfQKzsB3BjGzMYsmymcMjrPEDMSkJMXrPoXGoYPkBDshkptmcwb3cmQmY0kAo
 Z6kdLK8wPbCw==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="363304245"
Received: from rchatre-mobl1.jf.intel.com ([10.54.70.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 15:21:48 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Fenghua Yu <fenghua.yu@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.4 2/2] x86/resctrl: Don't move a task to the same resource group
Date:   Mon, 11 Jan 2021 15:21:41 -0800
Message-Id: <189c5c33fe6def640b0ac8807cf819d7541bfa46.1610394119.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <3a470a8ff17dfcf1a3d5afc189b74050a2634c2a.1610394119.git.reinette.chatre@intel.com>
References: <3a470a8ff17dfcf1a3d5afc189b74050a2634c2a.1610394119.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

commit a0195f314a25582b38993bf30db11c300f4f4611 upstream

Shakeel Butt reported in [1] that a user can request a task to be moved
to a resource group even if the task is already in the group. It just
wastes time to do the move operation which could be costly to send IPI
to a different CPU.

Add a sanity check to ensure that the move operation only happens when
the task is not already in the resource group.

[1] https://lore.kernel.org/lkml/CALvZod7E9zzHwenzf7objzGKsdBmVwTgEJ0nPgs0LUFU3SN5Pw@mail.gmail.com/

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/962ede65d8e95be793cb61102cca37f7bb018e66.1608243147.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 91af816e631b..28f786289fce 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -546,6 +546,13 @@ static void update_task_closid_rmid(struct task_struct *t)
 static int __rdtgroup_move_task(struct task_struct *tsk,
 				struct rdtgroup *rdtgrp)
 {
+	/* If the task is already in rdtgrp, no need to move the task. */
+	if ((rdtgrp->type == RDTCTRL_GROUP && tsk->closid == rdtgrp->closid &&
+	     tsk->rmid == rdtgrp->mon.rmid) ||
+	    (rdtgrp->type == RDTMON_GROUP && tsk->rmid == rdtgrp->mon.rmid &&
+	     tsk->closid == rdtgrp->mon.parent->closid))
+		return 0;
+
 	/*
 	 * Set the task's closid/rmid before the PQR_ASSOC MSR can be
 	 * updated by them.
-- 
2.26.2

