Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8511AE036
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 16:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgDQOwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 10:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgDQOwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 10:52:06 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17067C061A0C;
        Fri, 17 Apr 2020 07:52:06 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jPSLa-0001RS-72; Fri, 17 Apr 2020 16:52:02 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id ACDB31C0072;
        Fri, 17 Apr 2020 16:52:01 +0200 (CEST)
Date:   Fri, 17 Apr 2020 14:52:01 -0000
From:   "tip-bot2 for Reinette Chatre" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix invalid attempt at removing the
 default resource group
Cc:     Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: =?utf-8?q?=3C884cbe1773496b5dbec1b6bd11bb50cffa83603d=2E15844?=
 =?utf-8?q?61853=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3C884cbe1773496b5dbec1b6bd11bb50cffa83603d=2E158446?=
 =?utf-8?q?1853=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <158713512124.28353.17303343964081994383.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b0151da52a6d4f3951ea24c083e7a95977621436
Gitweb:        https://git.kernel.org/tip/b0151da52a6d4f3951ea24c083e7a95977621436
Author:        Reinette Chatre <reinette.chatre@intel.com>
AuthorDate:    Tue, 17 Mar 2020 09:26:45 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 17 Apr 2020 16:26:23 +02:00

x86/resctrl: Fix invalid attempt at removing the default resource group

The default resource group ("rdtgroup_default") is associated with the
root of the resctrl filesystem and should never be removed. New resource
groups can be created as subdirectories of the resctrl filesystem and
they can be removed from user space.

There exists a safeguard in the directory removal code
(rdtgroup_rmdir()) that ensures that only subdirectories can be removed
by testing that the directory to be removed has to be a child of the
root directory.

A possible deadlock was recently fixed with

  334b0f4e9b1b ("x86/resctrl: Fix a deadlock due to inaccurate reference").

This fix involved associating the private data of the "mon_groups"
and "mon_data" directories to the resource group to which they belong
instead of NULL as before. A consequence of this change was that
the original safeguard code preventing removal of "mon_groups" and
"mon_data" found in the root directory failed resulting in attempts to
remove the default resource group that ends in a BUG:

  kernel BUG at mm/slub.c:3969!
  invalid opcode: 0000 [#1] SMP PTI

  Call Trace:
  rdtgroup_rmdir+0x16b/0x2c0
  kernfs_iop_rmdir+0x5c/0x90
  vfs_rmdir+0x7a/0x160
  do_rmdir+0x17d/0x1e0
  do_syscall_64+0x55/0x1d0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by improving the directory removal safeguard to ensure that
subdirectories of the resctrl root directory can only be removed if they
are a child of the resctrl filesystem's root _and_ not associated with
the default resource group.

Fixes: 334b0f4e9b1b ("x86/resctrl: Fix a deadlock due to inaccurate reference")
Reported-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/884cbe1773496b5dbec1b6bd11bb50cffa83603d.1584461853.git.reinette.chatre@intel.com
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 064e9ef..9d4e73a 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3072,7 +3072,8 @@ static int rdtgroup_rmdir(struct kernfs_node *kn)
 	 * If the rdtgroup is a mon group and parent directory
 	 * is a valid "mon_groups" directory, remove the mon group.
 	 */
-	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn) {
+	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn &&
+	    rdtgrp != &rdtgroup_default) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			ret = rdtgroup_ctrl_remove(kn, rdtgrp);
