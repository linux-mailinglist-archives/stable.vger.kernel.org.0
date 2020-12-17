Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57B92DDB80
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgLQWcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 17:32:24 -0500
Received: from mga12.intel.com ([192.55.52.136]:41197 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbgLQWcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 17:32:23 -0500
IronPort-SDR: iIKQ4Ca/5PTsczxJmfAyUadvNRbG7G80o7ywYlFAUl9WPl/bSsLZ0Ca5T49lpjM3PQRzC2sz7x
 aJiRc/0PkqYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="154567843"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="154567843"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:31:42 -0800
IronPort-SDR: VqKR+OZkx2vGMgXKQh2kve/nbEtSTYgcQ33lmw/l/rw7KucudRcdkxnHiMLEFLpTCEszZL+B4S
 Kbw+WwiDruTQ==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="387836632"
Received: from rchatre-mobl1.jf.intel.com ([10.54.70.7])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:31:41 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com
Cc:     kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH V2 2/4] x86/resctrl: Don't move a task to the same resource group
Date:   Thu, 17 Dec 2020 14:31:19 -0800
Message-Id: <962ede65d8e95be793cb61102cca37f7bb018e66.1608243147.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1608243147.git.reinette.chatre@intel.com>
References: <cover.1608243147.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

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
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
---
V1->V2:
* No changes

 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index c5937a12d731..4042e1eb4f5d 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -552,6 +552,13 @@ static void update_task_closid_rmid(struct task_struct *t)
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

