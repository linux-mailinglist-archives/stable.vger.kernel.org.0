Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF052F7B98
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbhAOMbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732787AbhAOMbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A882C23136;
        Fri, 15 Jan 2021 12:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713890;
        bh=tC6JJM1vmnXYySKfv9b0mXJx7CTs1lpaCXJ6pG71VEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zd9q0MD00j7HtiBLIwvzxxSOYv54HMpWh2TQzp04uRJW3dPBUqaG/4z4CtJlooXU0
         CdO3VJnaHsdjUwI3KKD3HYtaS0AqB5nY4Anm8T6k/f/YSX7q6mU/CtO8Ggolw+CJOP
         8qrr0EzaN1fHElPjv/vd8+/NWcPowljtoIhAs3dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4.14 07/28] x86/resctrl: Dont move a task to the same resource group
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115121957.106181858@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -432,6 +432,13 @@ static void update_task_closid_rmid(stru
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


