Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9E3CA9A2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242444AbhGOTHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242394AbhGOTGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82237613FE;
        Thu, 15 Jul 2021 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375776;
        bh=qYwvKRZxDsClmqX/CnzXKCt+vvf788CcY/7PJ+WeTLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdCHtxXcfeLLUECxYQVI6fzBlLQPqCaoUi9PanzH6tmJQl/laV6k/l4brtnIiz8k9
         qPb6mNiiMhNfK/3V6hLBfV+Oe7zFbBYwp5Yn3g6vwK+LEQimgUjEwaN5wZTkM8E0N7
         DSodWsWh/zb4JNurqcksA5qPDAGLYBvwTsVk+5ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.12 231/242] s390/vdso64: add sigreturn,rt_sigreturn and restart_syscall
Date:   Thu, 15 Jul 2021 20:39:53 +0200
Message-Id: <20210715182633.531536608@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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


