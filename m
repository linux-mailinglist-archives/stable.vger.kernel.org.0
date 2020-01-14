Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4341C13A5E5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgANKFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729745AbgANKFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CED124684;
        Tue, 14 Jan 2020 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996329;
        bh=6jKw0O+CyPMH+hrct7EUfZqs7cAxZ67cxAcmQxPZ5Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEcujaff86P/cqKh3kS60WtdPZGId6CJSwj0CKWnhof+t7MlS1/Kz6ekaOX50E/6m
         y/sg7hY5XsS8SDwJjU+5XGJuweesV83iFbe14jVOV0KlRLnuc9CRKioII59AmdEa88
         iT+wOSU9GglItY3xBfmI3L+1rzECzpMcTD2kXmiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amanieu dAntras <amanieu@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 58/78] arm64: Implement copy_thread_tls
Date:   Tue, 14 Jan 2020 11:01:32 +0100
Message-Id: <20200114094401.225685284@linuxfoundation.org>
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

commit a4376f2fbcc8084832f2f114577c8d68234c7903 upstream.

This is required for clone3 which passes the TLS value through a
struct rather than a register.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@vger.kernel.org> # 5.3.x
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200102172413.654385-3-amanieu@gmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Kconfig          |    1 +
 arch/arm64/kernel/process.c |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -139,6 +139,7 @@ config ARM64
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -360,8 +360,8 @@ int arch_dup_task_struct(struct task_str
 
 asmlinkage void ret_from_fork(void) asm("ret_from_fork");
 
-int copy_thread(unsigned long clone_flags, unsigned long stack_start,
-		unsigned long stk_sz, struct task_struct *p)
+int copy_thread_tls(unsigned long clone_flags, unsigned long stack_start,
+		unsigned long stk_sz, struct task_struct *p, unsigned long tls)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
@@ -394,11 +394,11 @@ int copy_thread(unsigned long clone_flag
 		}
 
 		/*
-		 * If a TLS pointer was passed to clone (4th argument), use it
-		 * for the new thread.
+		 * If a TLS pointer was passed to clone, use it for the new
+		 * thread.
 		 */
 		if (clone_flags & CLONE_SETTLS)
-			p->thread.uw.tp_value = childregs->regs[3];
+			p->thread.uw.tp_value = tls;
 	} else {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->pstate = PSR_MODE_EL1h;


