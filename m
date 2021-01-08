Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0751F2EEE7B
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 09:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbhAHIT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 03:19:26 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48886 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAHIT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 03:19:26 -0500
Date:   Fri, 08 Jan 2021 08:18:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610093923;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q65QGZu7U1uTBRcwZxKM6PUCnxFUGixRYAOQnjlYh2g=;
        b=HAk1fcRQHl8k+byNRqd3Yyo4t/QyqYHEpyQcIBNjpiBn+D3kYpBNCoI4si99oeDFkkgPnB
        IX1cu8uAw6KEUG8Qnq8/ERuUOTTsjU4heqM6G8bb2JoS44xaSGY/a5mhGgl3EGIIHhy57L
        98URmjv6j02ER2DZL2oktDJ+SPrd5oXXutxjOE4xGeUK7m11hwo1Cwc5j5KdwgnE1mNBxJ
        WlTDS0qhk3iIUa0yPCn2WoIUb6IcvcFQvIHG2vcQOtOwkyuyTIlDKrOYXJyuhIOrGKxDiW
        xGTdZAanOw7liRIsBVuyknupPwej43L3KulfGO2ZW33YV1M3dt9uaq5t6fGmDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610093923;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q65QGZu7U1uTBRcwZxKM6PUCnxFUGixRYAOQnjlYh2g=;
        b=i3RI9UGD66QmVQXmkgPTcN2OStN6FQSHWQKgLP31gYdei0czcwiwGlneP3n6zRUN/kJDTI
        xaAsi9sUFdPq6HDA==
From:   "tip-bot2 for Fenghua Yu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Don't move a task to the same resource group
Cc:     Shakeel Butt <shakeelb@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C962ede65d8e95be793cb61102cca37f7bb018e66=2E16082?=
 =?utf-8?q?43147=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3C962ede65d8e95be793cb61102cca37f7bb018e66=2E160824?=
 =?utf-8?q?3147=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <161009392288.414.6204730563015001676.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a0195f314a25582b38993bf30db11c300f4f4611
Gitweb:        https://git.kernel.org/tip/a0195f314a25582b38993bf30db11c300f4f4611
Author:        Fenghua Yu <fenghua.yu@intel.com>
AuthorDate:    Thu, 17 Dec 2020 14:31:19 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 08 Jan 2021 09:08:03 +01:00

x86/resctrl: Don't move a task to the same resource group

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
index 1c6f8a6..460f3e0 100644
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
