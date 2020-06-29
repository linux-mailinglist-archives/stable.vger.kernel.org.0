Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB6620D9D8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbgF2Tvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387728AbgF2Tkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D27248F8;
        Mon, 29 Jun 2020 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444448;
        bh=yjNpRv8q3GfXREcKPByLoH2E7axhZx/JhrTgyTbmn9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjSc7a0IzzEDxeJqoNnzWHUjKIQfKE/7vA6xh9UWjP2Ap4O9WUiaqq9R4G14c59M1
         ecAKTu/ALFhXwZdcdVSSfjE6jYcm3bRmu2Ahy+ld2duhuwMzQWdHnhWr2hQw87Ox2a
         uIyyshyOKavBaB9l3+BqjuB69S5p00nEZA9t9Az8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/178] s390/ptrace: pass invalid syscall numbers to tracing
Date:   Mon, 29 Jun 2020 11:24:33 -0400
Message-Id: <20200629152523.2494198-129-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 00332c16b1604242a56289ff2b26e283dbad0812 ]

tracing expects to see invalid syscalls, so pass it through.
The syscall path in entry.S checks the syscall number before
looking up the handler, so it is still safe.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S  | 2 +-
 arch/s390/kernel/ptrace.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index bc85987727f09..c544b7a11ebb3 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -368,9 +368,9 @@ ENTRY(system_call)
 	jnz	.Lsysc_nr_ok
 	# svc 0: system call number in %r1
 	llgfr	%r1,%r1				# clear high word in r1
+	sth	%r1,__PT_INT_CODE+2(%r11)
 	cghi	%r1,NR_syscalls
 	jnl	.Lsysc_nr_ok
-	sth	%r1,__PT_INT_CODE+2(%r11)
 	slag	%r8,%r1,3
 .Lsysc_nr_ok:
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index ad71132374f0c..5a2b1501d9983 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -844,11 +844,9 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	 * call number to gprs[2].
 	 */
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    (tracehook_report_syscall_entry(regs) ||
-	     regs->gprs[2] >= NR_syscalls)) {
+	    tracehook_report_syscall_entry(regs)) {
 		/*
-		 * Tracing decided this syscall should not happen or the
-		 * debugger stored an invalid system call number. Skip
+		 * Tracing decided this syscall should not happen. Skip
 		 * the system call and the system call restart handling.
 		 */
 		clear_pt_regs_flag(regs, PIF_SYSCALL);
-- 
2.25.1

