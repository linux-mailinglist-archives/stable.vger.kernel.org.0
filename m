Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE20313A534
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgANKFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgANKFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FD02467D;
        Tue, 14 Jan 2020 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996332;
        bh=YCf5PWWDVWJ847+R08vWx2HT4qX17hPoH9QOn8WjUZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWcupiyUgWFzd01gIE+s3gx3MEsfrZw4/TcnkRP86BrLTQqrCHjlq2IVd24yTmbT2
         YjD8PpKXxkMyagY6WKIFwk3CHQvnEPcv7Q3au9myctoQymoWAW8RUQaQkbo3pLWj4u
         4+owoXnGzGpUryxcRA4KF35pjvFFi4jtPe8KC4IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amanieu dAntras <amanieu@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 59/78] arm: Implement copy_thread_tls
Date:   Tue, 14 Jan 2020 11:01:33 +0100
Message-Id: <20200114094401.337985296@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amanieu d'Antras <amanieu@gmail.com>

commit 167ee0b82429cb5df272808c7a21370b7c961ab2 upstream.

This is required for clone3 which passes the TLS value through a
struct rather than a register.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@vger.kernel.org> # 5.3.x
Link: https://lore.kernel.org/r/20200102172413.654385-4-amanieu@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig          |    1 +
 arch/arm/kernel/process.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -73,6 +73,7 @@ config ARM
 	select HAVE_ARM_SMCCC if CPU_V7
 	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS if MMU
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -224,8 +224,8 @@ void release_thread(struct task_struct *
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 int
-copy_thread(unsigned long clone_flags, unsigned long stack_start,
-	    unsigned long stk_sz, struct task_struct *p)
+copy_thread_tls(unsigned long clone_flags, unsigned long stack_start,
+	    unsigned long stk_sz, struct task_struct *p, unsigned long tls)
 {
 	struct thread_info *thread = task_thread_info(p);
 	struct pt_regs *childregs = task_pt_regs(p);
@@ -259,7 +259,7 @@ copy_thread(unsigned long clone_flags, u
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value[0] = childregs->ARM_r3;
+		thread->tp_value[0] = tls;
 	thread->tp_value[1] = get_tpuser();
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);


