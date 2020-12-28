Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF00F2E3E39
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503265AbgL1OZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503235AbgL1OZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16103221F0;
        Mon, 28 Dec 2020 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165500;
        bh=GCqwiNM8CKthXJ1MkSyPy+fQbPxcDeXb+PrvpbBfHwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHR5GtBezNceWOrO9CQy081OgFi2PaFLeYmelsH+7C63hV9h4kFmPmSoeOcykPPaf
         CgUSVkAMZDpiaY48HxIgIN6F+oRTZddCxOOUrr66CzlYDPeer0xDm74AwrTcm8vZvX
         D2SlDYlec36Gs+YhmII3xGNpv0g8iAe6TIcljekg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 5.10 554/717] s390/idle: fix accounting with machine checks
Date:   Mon, 28 Dec 2020 13:49:12 +0100
Message-Id: <20201228125047.482308932@linuxfoundation.org>
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

commit 454efcf82ea17d7efeb86ebaa20775a21ec87d27 upstream.

When a machine check interrupt is triggered during idle, the code
is using the async timer/clock for idle time calculation. It should use
the machine check enter timer/clock which is passed to the macro.

Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Cc: <stable@vger.kernel.org> # 5.8
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.S |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -110,7 +110,7 @@ _LPP_OFFSET	= __LC_LPP
 #endif
 	.endm
 
-	.macro	SWITCH_ASYNC savearea,timer
+	.macro	SWITCH_ASYNC savearea,timer,clock
 	tmhh	%r8,0x0001		# interrupting from user ?
 	jnz	4f
 #if IS_ENABLED(CONFIG_KVM)
@@ -143,8 +143,8 @@ _LPP_OFFSET	= __LC_LPP
 	la	%r4,8(%r4)
 	brct	%r1,1b
 
-2:	mvc	__CLOCK_IDLE_EXIT(8,%r2), __LC_INT_CLOCK
-	mvc	__TIMER_IDLE_EXIT(8,%r2), __LC_ASYNC_ENTER_TIMER
+2:	mvc	__CLOCK_IDLE_EXIT(8,%r2), \clock
+	mvc	__TIMER_IDLE_EXIT(8,%r2), \timer
 	# account system time going idle
 	ni	__LC_CPU_FLAGS+7,255-_CIF_ENABLED_WAIT
 
@@ -761,7 +761,7 @@ ENTRY(io_int_handler)
 	stmg	%r8,%r15,__LC_SAVE_AREA_ASYNC
 	lg	%r12,__LC_CURRENT
 	lmg	%r8,%r9,__LC_IO_OLD_PSW
-	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_ENTER_TIMER
+	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_ENTER_TIMER,__LC_INT_CLOCK
 	stmg	%r0,%r7,__PT_R0(%r11)
 	# clear user controlled registers to prevent speculative use
 	xgr	%r0,%r0
@@ -961,7 +961,7 @@ ENTRY(ext_int_handler)
 	stmg	%r8,%r15,__LC_SAVE_AREA_ASYNC
 	lg	%r12,__LC_CURRENT
 	lmg	%r8,%r9,__LC_EXT_OLD_PSW
-	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_ENTER_TIMER
+	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_ENTER_TIMER,__LC_INT_CLOCK
 	stmg	%r0,%r7,__PT_R0(%r11)
 	# clear user controlled registers to prevent speculative use
 	xgr	%r0,%r0
@@ -1183,7 +1183,7 @@ ENTRY(mcck_int_handler)
 	TSTMSK	__LC_MCCK_CODE,MCCK_CODE_PSW_IA_VALID
 	jno	.Lmcck_panic
 4:	ssm	__LC_PGM_NEW_PSW	# turn dat on, keep irqs off
-	SWITCH_ASYNC __LC_GPREGS_SAVE_AREA+64,__LC_MCCK_ENTER_TIMER
+	SWITCH_ASYNC __LC_GPREGS_SAVE_AREA+64,__LC_MCCK_ENTER_TIMER,__LC_MCCK_CLOCK
 .Lmcck_skip:
 	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
 	stmg	%r0,%r7,__PT_R0(%r11)


