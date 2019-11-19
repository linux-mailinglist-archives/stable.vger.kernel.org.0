Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A041017FA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfKSFhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbfKSFg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04FF21783;
        Tue, 19 Nov 2019 05:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141818;
        bh=uGWYfVg65/HzkdeuzxNxaCvqxmyX3trBbFNbZSXOU/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05DA47/PdsFG8w/RoUTeigqsKUBv7R8PNfOj94mwnuDPcbPZcuCkE30WKDKA/3gku
         pn8+JcLZSEijpyDC+8Fq+tvTSk1dT74z6RCTJl5j70TyTY2VVKALgb/NV8un+1bEOx
         rCbZyUteWldEsMdzIpZB7Oe/K5XmGl7z6trCcRco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/422] s390/vdso: correct CFI annotations of vDSO functions
Date:   Tue, 19 Nov 2019 06:18:08 +0100
Message-Id: <20191119051417.848414867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 26f4414a45b808f83d42d6fd2fbf4a59ef25e84b ]

Correct stack frame overhead for 31-bit vdso, which should be 96 rather
then 160. This is done by reusing STACK_FRAME_OVERHEAD definition which
contains correct value based on build flags. This fixes stack unwinding
within vdso code for 31-bit processes. While at it replace all hard coded
stack frame overhead values with the same definition in vdso64 as well.

Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/clock_gettime.S | 19 ++++++++++---------
 arch/s390/kernel/vdso32/gettimeofday.S  |  3 ++-
 arch/s390/kernel/vdso64/clock_gettime.S | 25 +++++++++++++------------
 arch/s390/kernel/vdso64/gettimeofday.S  |  3 ++-
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index a9418bf975db5..ada5c11a16e5a 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -10,6 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
 #include <asm/dwarf.h>
+#include <asm/ptrace.h>
 
 	.text
 	.align 4
@@ -18,8 +19,8 @@
 __kernel_clock_gettime:
 	CFI_STARTPROC
 	ahi	%r15,-16
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 	basr	%r5,0
 0:	al	%r5,21f-0b(%r5)			/* get &_vdso_data */
 	chi	%r2,__CLOCK_REALTIME_COARSE
@@ -72,13 +73,13 @@ __kernel_clock_gettime:
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
 	lhi	%r2,0
 	ahi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 
 	/* CLOCK_MONOTONIC_COARSE */
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 9:	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	9b
@@ -158,17 +159,17 @@ __kernel_clock_gettime:
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
 	lhi	%r2,0
 	ahi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 
 	/* Fallback to system call */
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 19:	lhi	%r1,__NR_clock_gettime
 	svc	0
 	ahi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 	CFI_ENDPROC
diff --git a/arch/s390/kernel/vdso32/gettimeofday.S b/arch/s390/kernel/vdso32/gettimeofday.S
index 3c0db0fa6ad90..b23063fbc892c 100644
--- a/arch/s390/kernel/vdso32/gettimeofday.S
+++ b/arch/s390/kernel/vdso32/gettimeofday.S
@@ -10,6 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
 #include <asm/dwarf.h>
+#include <asm/ptrace.h>
 
 	.text
 	.align 4
@@ -19,7 +20,7 @@ __kernel_gettimeofday:
 	CFI_STARTPROC
 	ahi	%r15,-16
 	CFI_ADJUST_CFA_OFFSET 16
-	CFI_VAL_OFFSET 15, -160
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 	basr	%r5,0
 0:	al	%r5,13f-0b(%r5)			/* get &_vdso_data */
 1:	ltr	%r3,%r3				/* check if tz is NULL */
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index fac3ab5ec83a9..9d2ee79b90f25 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -10,6 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
 #include <asm/dwarf.h>
+#include <asm/ptrace.h>
 
 	.text
 	.align 4
@@ -18,8 +19,8 @@
 __kernel_clock_gettime:
 	CFI_STARTPROC
 	aghi	%r15,-16
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 	larl	%r5,_vdso_data
 	cghi	%r2,__CLOCK_REALTIME_COARSE
 	je	4f
@@ -56,13 +57,13 @@ __kernel_clock_gettime:
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
 	lghi	%r2,0
 	aghi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 
 	/* CLOCK_MONOTONIC_COARSE */
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 3:	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	3b
@@ -115,13 +116,13 @@ __kernel_clock_gettime:
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
 	lghi	%r2,0
 	aghi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 
 	/* CPUCLOCK_VIRT for this thread */
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 9:	lghi	%r4,0
 	icm	%r0,15,__VDSO_ECTG_OK(%r5)
 	jz	12f
@@ -142,17 +143,17 @@ __kernel_clock_gettime:
 	stg	%r4,8(%r3)
 	lghi	%r2,0
 	aghi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 
 	/* Fallback to system call */
-	CFI_DEF_CFA_OFFSET 176
-	CFI_VAL_OFFSET 15, -160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD+16
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 12:	lghi	%r1,__NR_clock_gettime
 	svc	0
 	aghi	%r15,16
-	CFI_DEF_CFA_OFFSET 160
+	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
 	br	%r14
 	CFI_ENDPROC
diff --git a/arch/s390/kernel/vdso64/gettimeofday.S b/arch/s390/kernel/vdso64/gettimeofday.S
index 6e1f0b421695a..aebe10dc7c99a 100644
--- a/arch/s390/kernel/vdso64/gettimeofday.S
+++ b/arch/s390/kernel/vdso64/gettimeofday.S
@@ -10,6 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
 #include <asm/dwarf.h>
+#include <asm/ptrace.h>
 
 	.text
 	.align 4
@@ -19,7 +20,7 @@ __kernel_gettimeofday:
 	CFI_STARTPROC
 	aghi	%r15,-16
 	CFI_ADJUST_CFA_OFFSET 16
-	CFI_VAL_OFFSET 15, -160
+	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 	larl	%r5,_vdso_data
 0:	ltgr	%r3,%r3				/* check if tz is NULL */
 	je	1f
-- 
2.20.1



