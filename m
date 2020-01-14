Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10D13A5F5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgANKGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgANKGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B9D24676;
        Tue, 14 Jan 2020 10:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996411;
        bh=JNfAoog5+ccTMuc9E8lvj6TYLMclB4+LV964XkJSShc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8+SEGPvdh/+fktnvsBkHJUvcOJT6sxw7B7fyv8KGDfZDP/66Y0HdPCMlYm+Ime1W
         5nY6fmHLlduEFRMvvpAc6WDqtRv596RtByjF+29B412Weg5C+bgNPFUOAjpiGjZ2kD
         VM/JaZf4ofEzl9uBUEryf/O0Fbz5HP7+qWa3P7U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amanieu dAntras <amanieu@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 62/78] xtensa: Implement copy_thread_tls
Date:   Tue, 14 Jan 2020 11:01:36 +0100
Message-Id: <20200114094401.746640870@linuxfoundation.org>
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

commit c346b94f8c5d1b7d637522c908209de93305a8eb upstream.

This is required for clone3 which passes the TLS value through a
struct rather than a register.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: <stable@vger.kernel.org> # 5.3.x
Link: https://lore.kernel.org/r/20200102172413.654385-7-amanieu@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/Kconfig          |    1 +
 arch/xtensa/kernel/process.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -22,6 +22,7 @@ config XTENSA
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if MMU
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -202,8 +202,9 @@ int arch_dup_task_struct(struct task_str
  * involved.  Much simpler to just not copy those live frames across.
  */
 
-int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
-		unsigned long thread_fn_arg, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long usp_thread_fn,
+		unsigned long thread_fn_arg, struct task_struct *p,
+		unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
@@ -264,9 +265,8 @@ int copy_thread(unsigned long clone_flag
 			       &regs->areg[XCHAL_NUM_AREGS - len/4], len);
 		}
 
-		/* The thread pointer is passed in the '4th argument' (= a5) */
 		if (clone_flags & CLONE_SETTLS)
-			childregs->threadptr = childregs->areg[5];
+			childregs->threadptr = tls;
 	} else {
 		p->thread.ra = MAKE_RA_FOR_CALL(
 				(unsigned long)ret_from_kernel_thread, 1);


