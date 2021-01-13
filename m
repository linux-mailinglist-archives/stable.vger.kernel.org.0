Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE23A2F5484
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 22:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbhAMVKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 16:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbhAMVHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 16:07:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317ADC061786
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 13:08:18 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kznNG-005vE7-1g; Wed, 13 Jan 2021 22:08:14 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-um@lists.infradead.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] um: defer killing userspace on page table update failures
Date:   Wed, 13 Jan 2021 22:08:03 +0100
Message-Id: <20210113220803.92a83b1591ae.I9425b924e7d9483efde4c0ba5bd0c0bed018472a@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113220803.0d97c6c96aae.I91e62e7568b2834a3922202a05700c972deaca3f@changeid>
References: <20210113220803.0d97c6c96aae.I91e62e7568b2834a3922202a05700c972deaca3f@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases we can get to fix_range_common() with mmap_sem held,
and in others we get there without it being held. For example, we
get there with it held from sys_mprotect(), and without it held
from fork_handler().

Avoid any issues in this and simply defer killing the task until
it runs the next time. Do it on the mm so that another task that
shares the same mm can't continue running afterwards.

Cc: stable@vger.kernel.org
Fixes: 468f65976a8d ("um: Fix hung task in fix_range_common()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 arch/um/include/shared/skas/mm_id.h | 1 +
 arch/um/kernel/tlb.c                | 7 +++----
 arch/um/os-Linux/skas/process.c     | 4 ++++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/um/include/shared/skas/mm_id.h b/arch/um/include/shared/skas/mm_id.h
index 4337b4ced095..e82e203f5f41 100644
--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -12,6 +12,7 @@ struct mm_id {
 		int pid;
 	} u;
 	unsigned long stack;
+	int kill;
 };
 
 #endif
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 89468da6bf88..5be1b0da9f3b 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -352,12 +352,11 @@ void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 
 	/* This is not an else because ret is modified above */
 	if (ret) {
+		struct mm_id *mm_idp = &current->mm->context.id;
+
 		printk(KERN_ERR "fix_range_common: failed, killing current "
 		       "process: %d\n", task_tgid_vnr(current));
-		/* We are under mmap_lock, release it such that current can terminate */
-		mmap_write_unlock(current->mm);
-		force_sig(SIGKILL);
-		do_signal(&current->thread.regs);
+		mm_idp->kill = 1;
 	}
 }
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 0621d521208e..02c4741ade5e 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -249,6 +249,7 @@ static int userspace_tramp(void *stack)
 }
 
 int userspace_pid[NR_CPUS];
+int kill_userspace_mm[NR_CPUS];
 
 /**
  * start_userspace() - prepare a new userspace process
@@ -342,6 +343,8 @@ void userspace(struct uml_pt_regs *regs, unsigned long *aux_fp_regs)
 	interrupt_end();
 
 	while (1) {
+		if (kill_userspace_mm[0])
+			fatal_sigsegv();
 
 		/*
 		 * This can legitimately fail if the process loads a
@@ -663,4 +666,5 @@ void reboot_skas(void)
 void __switch_mm(struct mm_id *mm_idp)
 {
 	userspace_pid[0] = mm_idp->u.pid;
+	kill_userspace_mm[0] = mm_idp->kill;
 }
-- 
2.26.2

