Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7012E7982
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgL3NKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgL3NEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C4C224B2;
        Wed, 30 Dec 2020 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333428;
        bh=B8sRCYS5qh9+zcGkFDgIeCz9Eslebiu0pW6OFXK1dUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onDk4JTvoOfLEEFant/jY6mwZ3fzwakqGpHCyt4n4Ub9QGz03BKtGV1A8ov+aqr2G
         4+KvVNI9Ld6TIGBcrjJ3WdUQnUF2BdwRE68yHER3mL0PdpZaqqQmuyhGZa4Gd7aaeh
         X1RsU8u8Ntfb7r/gWBVz/YV2ImqjolEsiBiCPmWrMGWldCscFVT6opn0jve1mz+t7c
         kJMJi/mFmKCh2/F3Wua9qpsBcSrk+9fYpXO+HrN5dQ/s8JaKNMNfxz/53nBj4NKWU6
         rxersIhYJgUDhtDD0Ygr922ZtsrKDUqBPFBuR8kb9DcgAqnI47pb/ljRP8VicK4btm
         rkCE6av1UiTQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/31] s390: always clear kernel stack backchain before calling functions
Date:   Wed, 30 Dec 2020 08:03:07 -0500
Message-Id: <20201230130314.3636961-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9365965db0c7ca7fc81eee27c21d8522d7102c32 ]

Clear the kernel stack backchain before potentially calling the
lockdep trace_hardirqs_off/on functions. Without this walking the
kernel backchain, e.g. during a panic, might stop too early.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 92beb14446449..9bdf3dbd04247 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -390,6 +390,7 @@ ENTRY(system_call)
 	mvc	__PT_PSW(16,%r11),__LC_SVC_OLD_PSW
 	mvc	__PT_INT_CODE(4,%r11),__LC_SVC_ILC
 	stg	%r14,__PT_FLAGS(%r11)
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	ENABLE_INTS
 .Lsysc_do_svc:
 	# clear user controlled register to prevent speculative use
@@ -406,7 +407,6 @@ ENTRY(system_call)
 	jnl	.Lsysc_nr_ok
 	slag	%r8,%r1,3
 .Lsysc_nr_ok:
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	stg	%r2,__PT_ORIG_GPR2(%r11)
 	stg	%r7,STACK_FRAME_OVERHEAD(%r15)
 	lg	%r9,0(%r8,%r10)			# get system call add.
@@ -696,8 +696,8 @@ ENTRY(pgm_check_handler)
 	mvc	__THREAD_per_address(8,%r14),__LC_PER_ADDRESS
 	mvc	__THREAD_per_cause(2,%r14),__LC_PER_CODE
 	mvc	__THREAD_per_paid(1,%r14),__LC_PER_ACCESS_ID
-6:	RESTORE_SM_CLEAR_PER
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+6:	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+	RESTORE_SM_CLEAR_PER
 	larl	%r1,pgm_check_table
 	llgh	%r10,__PT_INT_CODE+2(%r11)
 	nill	%r10,0x007f
@@ -718,8 +718,8 @@ ENTRY(pgm_check_handler)
 # PER event in supervisor state, must be kprobes
 #
 .Lpgm_kprobe:
-	RESTORE_SM_CLEAR_PER
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+	RESTORE_SM_CLEAR_PER
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	brasl	%r14,do_per_trap
 	j	.Lpgm_return
@@ -761,10 +761,10 @@ ENTRY(io_int_handler)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	mvc	__PT_INT_CODE(12,%r11),__LC_SUBCHANNEL_ID
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	TSTMSK	__LC_CPU_FLAGS,_CIF_IGNORE_IRQ
 	jo	.Lio_restore
 	TRACE_IRQS_OFF
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 .Lio_loop:
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	lghi	%r3,IO_INTERRUPT
@@ -964,10 +964,10 @@ ENTRY(ext_int_handler)
 	mvc	__PT_INT_PARM(4,%r11),__LC_EXT_PARAMS
 	mvc	__PT_INT_PARM_LONG(8,%r11),0(%r1)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	TSTMSK	__LC_CPU_FLAGS,_CIF_IGNORE_IRQ
 	jo	.Lio_restore
 	TRACE_IRQS_OFF
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	lghi	%r3,EXT_INTERRUPT
 	brasl	%r14,do_IRQ
-- 
2.27.0

