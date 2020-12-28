Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C62E3FC2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503259AbgL1OZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503250AbgL1OZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510F120731;
        Mon, 28 Dec 2020 14:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165497;
        bh=YsNWC9QPj/tB4tfx3OBGJz9UKKByDqFrrZuimQ/Tfko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf/EOlr5TI1TrYAc17gG/5a+qYZhFgEEO/eUqpxHmaDSrprYyrT/xsyPvSLxKLM+4
         q19Ooq3XVGTXV9kK7VT5fVhSsl7UT3iy166Zz2LDieyztB5pr89Vj579VOv2p438zP
         YsiNDBnqUUgrbgt20J/ULByGShMWV7eYoqemrVFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 5.10 553/717] s390/idle: add missing mt_cycles calculation
Date:   Mon, 28 Dec 2020 13:49:11 +0100
Message-Id: <20201228125047.431022393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit e259b3fafa7de362b04ecd86e7fa9a9e9273e5fb upstream.

During removal of the critical section cleanup the calculation
of mt_cycles during idle was removed. This causes invalid
accounting on systems with SMT enabled.

Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Cc: <stable@vger.kernel.org> # 5.8
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.S |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -112,7 +112,7 @@ _LPP_OFFSET	= __LC_LPP
 
 	.macro	SWITCH_ASYNC savearea,timer
 	tmhh	%r8,0x0001		# interrupting from user ?
-	jnz	2f
+	jnz	4f
 #if IS_ENABLED(CONFIG_KVM)
 	lgr	%r14,%r9
 	larl	%r13,.Lsie_gmap
@@ -125,9 +125,25 @@ _LPP_OFFSET	= __LC_LPP
 #endif
 0:	larl	%r13,.Lpsw_idle_exit
 	cgr	%r13,%r9
-	jne	1f
+	jne	3f
 
-	mvc	__CLOCK_IDLE_EXIT(8,%r2), __LC_INT_CLOCK
+	larl	%r1,smp_cpu_mtid
+	llgf	%r1,0(%r1)
+	ltgr	%r1,%r1
+	jz	2f			# no SMT, skip mt_cycles calculation
+	.insn	rsy,0xeb0000000017,%r1,5,__SF_EMPTY+80(%r15)
+	larl	%r3,mt_cycles
+	ag	%r3,__LC_PERCPU_OFFSET
+	la	%r4,__SF_EMPTY+16(%r15)
+1:	lg	%r0,0(%r3)
+	slg	%r0,0(%r4)
+	alg	%r0,64(%r4)
+	stg	%r0,0(%r3)
+	la	%r3,8(%r3)
+	la	%r4,8(%r4)
+	brct	%r1,1b
+
+2:	mvc	__CLOCK_IDLE_EXIT(8,%r2), __LC_INT_CLOCK
 	mvc	__TIMER_IDLE_EXIT(8,%r2), __LC_ASYNC_ENTER_TIMER
 	# account system time going idle
 	ni	__LC_CPU_FLAGS+7,255-_CIF_ENABLED_WAIT
@@ -146,17 +162,17 @@ _LPP_OFFSET	= __LC_LPP
 	mvc	__LC_LAST_UPDATE_TIMER(8),__TIMER_IDLE_EXIT(%r2)
 
 	nihh	%r8,0xfcfd		# clear wait state and irq bits
-1:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
+3:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
 	slgr	%r14,%r15
 	srag	%r14,%r14,STACK_SHIFT
-	jnz	3f
+	jnz	5f
 	CHECK_STACK \savearea
 	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	j	4f
-2:	UPDATE_VTIME %r14,%r15,\timer
+	j	6f
+4:	UPDATE_VTIME %r14,%r15,\timer
 	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
-3:	lg	%r15,__LC_ASYNC_STACK	# load async stack
-4:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
+5:	lg	%r15,__LC_ASYNC_STACK	# load async stack
+6:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	.endm
 
 	.macro UPDATE_VTIME w1,w2,enter_timer


