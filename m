Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D63CAB9B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbhGOTVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245063AbhGOTTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:19:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A78B613F5;
        Thu, 15 Jul 2021 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376435;
        bh=qYwvKRZxDsClmqX/CnzXKCt+vvf788CcY/7PJ+WeTLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDcXrbOMvqXqblZW8bNa+GTp8QEhRKCcRklyJyBWp1TUg/KGqZWowqbdiS5x4wbeH
         tswQUp4yt5ughqgh0W9qmwBBkGlPKGXUVRJvgYRxHDSsFOKEjhjty2NueoBWO3WtaZ
         kQgcL0us7HYzzSDisUrA6tLL+xgTbubsSItUvebA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.13 255/266] s390/vdso64: add sigreturn,rt_sigreturn and restart_syscall
Date:   Thu, 15 Jul 2021 20:40:10 +0200
Message-Id: <20210715182652.557225823@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 686341f2548b5a4c4ab1ee22427e046027ae1c9c upstream.

Add minimalistic trampolines to vdso64 so we can return from signal
without using the stack which requires pgm check handler hacks when
NX is enabled.

restart_syscall will be called from vdso to work around the architectural
limitation that the syscall number might be encoded in the svc instruction,
and therefore can not be changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vdso64/vdso64.lds.S        |    3 +++
 arch/s390/kernel/vdso64/vdso_user_wrapper.S |   17 +++++++++++++++++
 2 files changed, 20 insertions(+)

--- a/arch/s390/kernel/vdso64/vdso64.lds.S
+++ b/arch/s390/kernel/vdso64/vdso64.lds.S
@@ -137,6 +137,9 @@ VERSION
 		__kernel_clock_gettime;
 		__kernel_clock_getres;
 		__kernel_getcpu;
+		__kernel_restart_syscall;
+		__kernel_rt_sigreturn;
+		__kernel_sigreturn;
 	local: *;
 	};
 }
--- a/arch/s390/kernel/vdso64/vdso_user_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
@@ -37,3 +37,20 @@ vdso_func gettimeofday
 vdso_func clock_getres
 vdso_func clock_gettime
 vdso_func getcpu
+
+.macro vdso_syscall func,syscall
+	.globl __kernel_\func
+	.type  __kernel_\func,@function
+	.align 8
+__kernel_\func:
+	CFI_STARTPROC
+	svc	\syscall
+	/* Make sure we notice when a syscall returns, which shouldn't happen */
+	.word	0
+	CFI_ENDPROC
+	.size	__kernel_\func,.-__kernel_\func
+.endm
+
+vdso_syscall restart_syscall,__NR_restart_syscall
+vdso_syscall sigreturn,__NR_sigreturn
+vdso_syscall rt_sigreturn,__NR_rt_sigreturn


