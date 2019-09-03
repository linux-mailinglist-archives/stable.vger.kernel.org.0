Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C35A6F10
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbfICQ20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbfICQ2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5267A23431;
        Tue,  3 Sep 2019 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528105;
        bh=Cd42BbHH5UF+TyBnCjl/rXkhEI+SJZOhpWmiAdM/aIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5IBgNLWSHiP7PGJKnGUBT1uulqGW6MlADtxnUy4a1thNgG1Qqwa5QEcgTDW7fyyV
         59ns7us25ijh5B3rXDMxiu75pnhT+qFU0kDd7Pac+a0jqbFXzNNjNBG3DLUtgnecCj
         c2YlzalEoXO0qggVexz2w4R7H4G8OL+7mWgBO0mY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 111/167] signal/arc: Use force_sig_fault where appropriate
Date:   Tue,  3 Sep 2019 12:24:23 -0400
Message-Id: <20190903162519.7136-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 15773ae938d8d93d982461990bebad6e1d7a1830 ]

Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/fault.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index f28db0b112a30..a0366f9dca051 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -66,14 +66,12 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	struct vm_area_struct *vma = NULL;
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	siginfo_t info;
+	int si_code;
 	int ret;
 	vm_fault_t fault;
 	int write = regs->ecr_cause & ECR_C_PROTV_STORE;  /* ST/EX */
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
-	clear_siginfo(&info);
-
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
@@ -91,7 +89,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 			return;
 	}
 
-	info.si_code = SEGV_MAPERR;
+	si_code = SEGV_MAPERR;
 
 	/*
 	 * If we're in an interrupt or have no user
@@ -119,7 +117,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	 * we can handle it..
 	 */
 good_area:
-	info.si_code = SEGV_ACCERR;
+	si_code = SEGV_ACCERR;
 
 	/* Handle protection violation, execute on heap or stack */
 
@@ -204,11 +202,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs)) {
 		tsk->thread.fault_address = address;
-		info.si_signo = SIGSEGV;
-		info.si_errno = 0;
-		/* info.si_code has been set above */
-		info.si_addr = (void __user *)address;
-		force_sig_info(SIGSEGV, &info, tsk);
+		force_sig_fault(SIGSEGV, si_code, (void __user *)address, tsk);
 		return;
 	}
 
@@ -243,9 +237,5 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 		goto no_context;
 
 	tsk->thread.fault_address = address;
-	info.si_signo = SIGBUS;
-	info.si_errno = 0;
-	info.si_code = BUS_ADRERR;
-	info.si_addr = (void __user *)address;
-	force_sig_info(SIGBUS, &info, tsk);
+	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)address, tsk);
 }
-- 
2.20.1

