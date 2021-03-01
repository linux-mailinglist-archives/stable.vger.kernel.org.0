Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A113291DF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbhCAUfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243331AbhCAU1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:27:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03ED265422;
        Mon,  1 Mar 2021 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622038;
        bh=rN8CIbaJiUOmdwGHNiBW6HOTjYrlrSvOFa9Eb47v6No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTwl60P1C+dHqFSAPvLvfgU6RHt4hZaVFX8jA+gZxC0+3as1uLByg4oRzJxEhMw9M
         XmShhXe026edyhkdWreZ6g9QGAAsCrPcrj/+0u+zIV/oprI8SqmMmeyJ5q/z57fox/
         ykfs7gmCxNPHg9ujCaNZ46xSm+5ivJ2GYvEXDM2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.11 735/775] um: defer killing userspace on page table update failures
Date:   Mon,  1 Mar 2021 17:15:03 +0100
Message-Id: <20210301161237.665643324@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a7d48886cacf8b426e0079bca9639d2657cf2d38 upstream.

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
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/shared/skas/mm_id.h |    1 +
 arch/um/kernel/tlb.c                |    7 +++----
 arch/um/os-Linux/skas/process.c     |    4 ++++
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -12,6 +12,7 @@ struct mm_id {
 		int pid;
 	} u;
 	unsigned long stack;
+	int kill;
 };
 
 #endif
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -352,12 +352,11 @@ void fix_range_common(struct mm_struct *
 
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
 
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -249,6 +249,7 @@ static int userspace_tramp(void *stack)
 }
 
 int userspace_pid[NR_CPUS];
+int kill_userspace_mm[NR_CPUS];
 
 /**
  * start_userspace() - prepare a new userspace process
@@ -342,6 +343,8 @@ void userspace(struct uml_pt_regs *regs,
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


