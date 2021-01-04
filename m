Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EED2E99C8
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbhADQDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbhADQDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB59F22473;
        Mon,  4 Jan 2021 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776182;
        bh=85umLspZZLssTIHeORxeLKC/V3HMsM1Z+tGZq32MKVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XecT9/OyrQg7dQ30KPRpCCLN94JUdq2igXhkbeK4s92aFYV8vbgYBTXwAcLK2RDz1
         SPDZkCSH3O+3QCrkO/3IT1Nn9G528BftoJbfosD/TzX40ekTk3mRwKvrTjkA9QInPQ
         oKrjv1t+99cDUdy6tgwVrCcyN4EBYagoDzF8RUu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/63] s390: always clear kernel stack backchain before calling functions
Date:   Mon,  4 Jan 2021 16:57:51 +0100
Message-Id: <20210104155711.617987277@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6343dca0dbeb6..71203324ff42b 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -406,6 +406,7 @@ ENTRY(system_call)
 	mvc	__PT_PSW(16,%r11),__LC_SVC_OLD_PSW
 	mvc	__PT_INT_CODE(4,%r11),__LC_SVC_ILC
 	stg	%r14,__PT_FLAGS(%r11)
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	ENABLE_INTS
 .Lsysc_do_svc:
 	# clear user controlled register to prevent speculative use
@@ -422,7 +423,6 @@ ENTRY(system_call)
 	jnl	.Lsysc_nr_ok
 	slag	%r8,%r1,3
 .Lsysc_nr_ok:
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	stg	%r2,__PT_ORIG_GPR2(%r11)
 	stg	%r7,STACK_FRAME_OVERHEAD(%r15)
 	lg	%r9,0(%r8,%r10)			# get system call add.
@@ -712,8 +712,8 @@ ENTRY(pgm_check_handler)
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
@@ -734,8 +734,8 @@ ENTRY(pgm_check_handler)
 # PER event in supervisor state, must be kprobes
 #
 .Lpgm_kprobe:
-	RESTORE_SM_CLEAR_PER
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+	RESTORE_SM_CLEAR_PER
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	brasl	%r14,do_per_trap
 	j	.Lpgm_return
@@ -777,10 +777,10 @@ ENTRY(io_int_handler)
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
@@ -980,10 +980,10 @@ ENTRY(ext_int_handler)
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



