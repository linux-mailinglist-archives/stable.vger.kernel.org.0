Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EED2058C7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbgFWRfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733274AbgFWRfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B958120706;
        Tue, 23 Jun 2020 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933744;
        bh=2ubDCHODXZNNgKbQOQukr/eKLce8EHPTK8F1h0as8Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfZlSVEYHVIpDQ//GmShSUAvf/8ndVTwKTt2AetorbmaLdNunxmG/8X4PNtGe37Cn
         xGYBsb7NmDpLZxsjAuarCZD7lwpZ7PSDn2H/yFL6vXcnhp9Rr4I0bmgjYiJ/n5QBnZ
         OrnwE6U2lW/pgIxs3BgHstPCQDd8z+3bg+fdjdBM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 17/28] s390/ptrace: pass invalid syscall numbers to tracing
Date:   Tue, 23 Jun 2020 13:35:12 -0400
Message-Id: <20200623173523.1355411-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
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
index 3ae64914bd144..9584e743102b7 100644
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
index 3f29646313e82..fca78b269349d 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -848,11 +848,9 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
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
 		goto skip;
-- 
2.25.1

