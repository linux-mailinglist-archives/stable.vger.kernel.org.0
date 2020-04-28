Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A587F1BCA0E
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgD1SpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731472AbgD1Soo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1D3206D6;
        Tue, 28 Apr 2020 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099483;
        bh=p1mEFL7GZrCu3Wlff4cQ8A8VxqTd/adu9gpNmAseRug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFDi/IQhF3k2tCPq3RyXJS+tMLFgTJhQzVXGFaX4wSE5RoLrIRbS9RPX1Y7TDyPAU
         U6CXD7TeUYTdKSAa2cRU0JJeLVbvQDfHxoG3J8Ku+jAW2uWsMxtAGVomIYNzzYohD+
         jC6dtUqkDxDr6Y4ZVfglqMcxRMerS/dL1A9m6Mms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.4 168/168] s390/mm: fix page table upgrade vs 2ndary address mode accesses
Date:   Tue, 28 Apr 2020 20:25:42 +0200
Message-Id: <20200428182251.805577126@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 316ec154810960052d4586b634156c54d0778f74 upstream.

A page table upgrade in a kernel section that uses secondary address
mode will mess up the kernel instructions as follows:

Consider the following scenario: two threads are sharing memory.
On CPU1 thread 1 does e.g. strnlen_user().  That gets to
        old_fs = enable_sacf_uaccess();
        len = strnlen_user_srst(src, size);
and
                "   la    %2,0(%1)\n"
                "   la    %3,0(%0,%1)\n"
                "   slgr  %0,%0\n"
                "   sacf  256\n"
                "0: srst  %3,%2\n"
in strnlen_user_srst().  At that point we are in secondary space mode,
control register 1 points to kernel page table and instruction fetching
happens via c1, rather than usual c13.  Interrupts are not disabled, for
obvious reasons.

On CPU2 thread 2 does MAP_FIXED mmap(), forcing the upgrade of page table
from 3-level to e.g. 4-level one.  We'd allocated new top-level table,
set it up and now we hit this:
                notify = 1;
                spin_unlock_bh(&mm->page_table_lock);
        }
        if (notify)
                on_each_cpu(__crst_table_upgrade, mm, 0);
OK, we need to actually change over to use of new page table and we
need that to happen in all threads that are currently running.  Which
happens to include the thread 1.  IPI is delivered and we have
static void __crst_table_upgrade(void *arg)
{
        struct mm_struct *mm = arg;

        if (current->active_mm == mm)
                set_user_asce(mm);
        __tlb_flush_local();
}
run on CPU1.  That does
static inline void set_user_asce(struct mm_struct *mm)
{
        S390_lowcore.user_asce = mm->context.asce;
OK, user page table address updated...
        __ctl_load(S390_lowcore.user_asce, 1, 1);
... and control register 1 set to it.
        clear_cpu_flag(CIF_ASCE_PRIMARY);
}

IPI is run in home space mode, so it's fine - insns are fetched
using c13, which always points to kernel page table.  But as soon
as we return from the interrupt, previous PSW is restored, putting
CPU1 back into secondary space mode, at which point we no longer
get the kernel instructions from the kernel mapping.

The fix is to only fixup the control registers that are currently in use
for user processes during the page table update.  We must also disable
interrupts in enable_sacf_uaccess to synchronize the cr and
thread.mm_segment updates against the on_each-cpu.

Fixes: 0aaba41b58bc ("s390: remove all code using the access register mode")
Cc: stable@vger.kernel.org # 4.15+
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/lib/uaccess.c |    4 ++++
 arch/s390/mm/pgalloc.c  |   16 ++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -64,10 +64,13 @@ mm_segment_t enable_sacf_uaccess(void)
 {
 	mm_segment_t old_fs;
 	unsigned long asce, cr;
+	unsigned long flags;
 
 	old_fs = current->thread.mm_segment;
 	if (old_fs & 1)
 		return old_fs;
+	/* protect against a concurrent page table upgrade */
+	local_irq_save(flags);
 	current->thread.mm_segment |= 1;
 	asce = S390_lowcore.kernel_asce;
 	if (likely(old_fs == USER_DS)) {
@@ -83,6 +86,7 @@ mm_segment_t enable_sacf_uaccess(void)
 		__ctl_load(asce, 7, 7);
 		set_cpu_flag(CIF_ASCE_SECONDARY);
 	}
+	local_irq_restore(flags);
 	return old_fs;
 }
 EXPORT_SYMBOL(enable_sacf_uaccess);
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -70,8 +70,20 @@ static void __crst_table_upgrade(void *a
 {
 	struct mm_struct *mm = arg;
 
-	if (current->active_mm == mm)
-		set_user_asce(mm);
+	/* we must change all active ASCEs to avoid the creation of new TLBs */
+	if (current->active_mm == mm) {
+		S390_lowcore.user_asce = mm->context.asce;
+		if (current->thread.mm_segment == USER_DS) {
+			__ctl_load(S390_lowcore.user_asce, 1, 1);
+			/* Mark user-ASCE present in CR1 */
+			clear_cpu_flag(CIF_ASCE_PRIMARY);
+		}
+		if (current->thread.mm_segment == USER_DS_SACF) {
+			__ctl_load(S390_lowcore.user_asce, 7, 7);
+			/* enable_sacf_uaccess does all or nothing */
+			WARN_ON(!test_cpu_flag(CIF_ASCE_SECONDARY));
+		}
+	}
 	__tlb_flush_local();
 }
 


