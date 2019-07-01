Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90114D0F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfEFOra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbfEFOr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FCD2087F;
        Mon,  6 May 2019 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154048;
        bh=DosLYsdqqwnMkYfm9X+s9Msj92hI9YNM9I/2sCXWpPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVo2hrr2zwpZg0P0kBGUkkVHI+b156Idwx/bl1KZAmX93dyToc5zEORYzG9Y4dPxm
         dZMkZW4yZPcd3aYaUGLtFsyPHQaBxMYylWQYbJ3G0AoYGggPefUVyswee2zlEmtVo6
         HZsX/wJF0KmUva2uddeMkbm4g20le2Va50nGCk/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 19/62] arm64: mm: print out correct page table entries
Date:   Mon,  6 May 2019 16:32:50 +0200
Message-Id: <20190506143052.725394517@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristina Martsenko <kristina.martsenko@arm.com>

commit 67ce16ec15ce9d97d3d85e72beabbc5d7017193e upstream.

When we take a fault that can't be handled, we print out the page table
entries associated with the faulting address. In some cases we currently
print out the wrong entries. For a faulting TTBR1 address, we sometimes
print out TTBR0 table entries instead, and for a faulting TTBR0 address
we sometimes print out TTBR1 table entries. Fix this by choosing the
tables based on the faulting address.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
[will: zero-extend addrs to 64-bit, don't walk swapper w/ TTBR0 addr]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/system_misc.h |    2 -
 arch/arm64/mm/fault.c                |   36 ++++++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -40,7 +40,7 @@ void hook_debug_fault_code(int nr, int (
 			   int sig, int code, const char *name);
 
 struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
+extern void show_pte(unsigned long addr);
 extern void __show_regs(struct pt_regs *);
 
 extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -79,18 +79,33 @@ static inline int notify_page_fault(stru
 #endif
 
 /*
- * Dump out the page tables associated with 'addr' in mm 'mm'.
+ * Dump out the page tables associated with 'addr' in the currently active mm.
  */
-void show_pte(struct mm_struct *mm, unsigned long addr)
+void show_pte(unsigned long addr)
 {
+	struct mm_struct *mm;
 	pgd_t *pgd;
 
-	if (!mm)
+	if (addr < TASK_SIZE) {
+		/* TTBR0 */
+		mm = current->active_mm;
+		if (mm == &init_mm) {
+			pr_alert("[%016lx] user address but active_mm is swapper\n",
+				 addr);
+			return;
+		}
+	} else if (addr >= VA_START) {
+		/* TTBR1 */
 		mm = &init_mm;
+	} else {
+		pr_alert("[%016lx] address between user and kernel address ranges\n",
+			 addr);
+		return;
+	}
 
 	pr_alert("pgd = %p\n", mm->pgd);
 	pgd = pgd_offset(mm, addr);
-	pr_alert("[%08lx] *pgd=%016llx", addr, pgd_val(*pgd));
+	pr_alert("[%016lx] *pgd=%016llx", addr, pgd_val(*pgd));
 
 	do {
 		pud_t *pud;
@@ -176,8 +191,8 @@ static bool is_el1_instruction_abort(uns
 /*
  * The kernel tried to access some page that wasn't present.
  */
-static void __do_kernel_fault(struct mm_struct *mm, unsigned long addr,
-			      unsigned int esr, struct pt_regs *regs)
+static void __do_kernel_fault(unsigned long addr, unsigned int esr,
+			      struct pt_regs *regs)
 {
 	/*
 	 * Are we prepared to handle this kernel fault?
@@ -194,7 +209,7 @@ static void __do_kernel_fault(struct mm_
 		 (addr < PAGE_SIZE) ? "NULL pointer dereference" :
 		 "paging request", addr);
 
-	show_pte(mm, addr);
+	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
 	do_exit(SIGKILL);
@@ -216,7 +231,7 @@ static void __do_user_fault(struct task_
 		pr_info("%s[%d]: unhandled %s (%d) at 0x%08lx, esr 0x%03x\n",
 			tsk->comm, task_pid_nr(tsk), inf->name, sig,
 			addr, esr);
-		show_pte(tsk->mm, addr);
+		show_pte(addr);
 		show_regs(regs);
 	}
 
@@ -232,7 +247,6 @@ static void __do_user_fault(struct task_
 static void do_bad_area(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 {
 	struct task_struct *tsk = current;
-	struct mm_struct *mm = tsk->active_mm;
 	const struct fault_info *inf;
 
 	/*
@@ -243,7 +257,7 @@ static void do_bad_area(unsigned long ad
 		inf = esr_to_fault_info(esr);
 		__do_user_fault(tsk, addr, esr, inf->sig, inf->code, regs);
 	} else
-		__do_kernel_fault(mm, addr, esr, regs);
+		__do_kernel_fault(addr, esr, regs);
 }
 
 #define VM_FAULT_BADMAP		0x010000
@@ -454,7 +468,7 @@ retry:
 	return 0;
 
 no_context:
-	__do_kernel_fault(mm, addr, esr, regs);
+	__do_kernel_fault(addr, esr, regs);
 	return 0;
 }
 


