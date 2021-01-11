Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0E2F24D7
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403900AbhALAZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:21 -0500
Received: from mga18.intel.com ([134.134.136.126]:34567 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403914AbhAKXNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 18:13:51 -0500
IronPort-SDR: NyLT4vvUS0nwUG+oZWjytQZetvRvRQ+j252V7an1LNo3jZTjbTfLOn19VhmmhYS0vsY4WVxYnX
 p+AcB0AxKU5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="165631553"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="165631553"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 15:13:09 -0800
IronPort-SDR: 9CxYW+oBHbUSDqDSaW7OQcQBLmOBaWHTzkMO7I3f9GoKCu+eY0OgZOBc76XGMDTHzFJZdx1Yui
 LH3i2iqkDl9w==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="464316903"
Received: from rchatre-mobl1.jf.intel.com ([10.54.70.7])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 15:13:07 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Fenghua Yu <fenghua.yu@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4.14 2/2] x86/resctrl: Don't move a task to the same resource group
Date:   Mon, 11 Jan 2021 15:12:58 -0800
Message-Id: <5316a67c4a42a2ddf39df3b9a7c246ab7dff5348.1610394049.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <27e975e8975fc10f806d6ede8c28e56872b853cc.1610394049.git.reinette.chatre@intel.com>
References: <27e975e8975fc10f806d6ede8c28e56872b853cc.1610394049.git.reinette.chatre@intel.com>
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

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
for older stable trees.

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/962ede65d8e95be793cb61102cca37f7bb018e66.1608243147.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 2132e20613f1..10d8f5cbb510 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -432,6 +432,13 @@ static void update_task_closid_rmid(struct task_struct *t)
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

