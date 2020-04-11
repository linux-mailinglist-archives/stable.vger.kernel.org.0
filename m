Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7C41A5523
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgDKXJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbgDKXJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFF621744;
        Sat, 11 Apr 2020 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646571;
        bh=zY9i8hyLHhjgWq/N6JuPLuPuh7fBhTMv4eTbcr4flE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKA/6dntbMj/port6mveLsgR/dKFdomBbZiC+40j5Vk1jQs8gElxUlGkd10M7/PSp
         mUS66hq0YogS1kHnmIIe/jLDt1iQklI0sQfAYrzpKB69zy8WRNNWvYZ4r0nKbz1mgk
         0j2ikRCOSsE6cirQRZdjmPJ1ditHhzehKhmDNdmA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Santosh S <santosh@fossix.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 118/121] powerpc/pseries: Handle UE event for memcpy_mcsafe
Date:   Sat, 11 Apr 2020 19:07:03 -0400
Message-Id: <20200411230706.23855-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit efbc4303b255bb80ab1283794b36dd5fe1fb0ec3 ]

memcpy_mcsafe has been implemented for power machines which is used
by pmem infrastructure, so that an UE encountered during memcpy from
pmem devices would not result in panic instead a right error code
is returned. The implementation expects machine check handler to ignore
the event and set nip to continue the execution from fixup code.

Appropriate changes are already made to powernv machine check handler,
make similar changes to pseries machine check handler to ignore the
the event and set nip to continue execution at the fixup entry if we
hit UE at an instruction with a fixup entry.

while we are at it, have a common function which searches the exception
table entry and updates nip with fixup address, and any future common
changes can be made in this function that are valid for both architectures.

powernv changes are made by
commit 895e3dceeb97 ("powerpc/mce: Handle UE event for memcpy_mcsafe")

Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Reviewed-by: Santosh S <santosh@fossix.org>
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200326184916.31172-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mce.h       |  2 ++
 arch/powerpc/kernel/mce.c            | 14 ++++++++++++++
 arch/powerpc/kernel/mce_power.c      |  8 ++------
 arch/powerpc/platforms/pseries/ras.c |  3 +++
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/mce.h
index 6a6ddaabdb34d..376a395daf329 100644
--- a/arch/powerpc/include/asm/mce.h
+++ b/arch/powerpc/include/asm/mce.h
@@ -218,6 +218,8 @@ extern void machine_check_queue_event(void);
 extern void machine_check_print_event_info(struct machine_check_event *evt,
 					   bool user_mode, bool in_guest);
 unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr);
+extern void mce_common_process_ue(struct pt_regs *regs,
+				  struct mce_error_info *mce_err);
 #ifdef CONFIG_PPC_BOOK3S_64
 void flush_and_reload_slb(void);
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index 34c1001e9e8bf..8077b5fb18a79 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/export.h>
 #include <linux/irq_work.h>
+#include <linux/extable.h>
 
 #include <asm/machdep.h>
 #include <asm/mce.h>
@@ -251,6 +252,19 @@ void machine_check_queue_event(void)
 	/* Queue irq work to process this event later. */
 	irq_work_queue(&mce_event_process_work);
 }
+
+void mce_common_process_ue(struct pt_regs *regs,
+			   struct mce_error_info *mce_err)
+{
+	const struct exception_table_entry *entry;
+
+	entry = search_kernel_exception_table(regs->nip);
+	if (entry) {
+		mce_err->ignore_event = true;
+		regs->nip = extable_fixup(entry);
+	}
+}
+
 /*
  * process pending MCE event from the mce event queue. This function will be
  * called during syscall exit.
diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index 1cbf7f1a4e3d8..067b094bfeff5 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -579,14 +579,10 @@ static long mce_handle_ue_error(struct pt_regs *regs,
 				struct mce_error_info *mce_err)
 {
 	long handled = 0;
-	const struct exception_table_entry *entry;
 
-	entry = search_kernel_exception_table(regs->nip);
-	if (entry) {
-		mce_err->ignore_event = true;
-		regs->nip = extable_fixup(entry);
+	mce_common_process_ue(regs, mce_err);
+	if (mce_err->ignore_event)
 		return 1;
-	}
 
 	/*
 	 * On specific SCOM read via MMIO we may get a machine check
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 1d7f973c647b3..aa6208c8d4f09 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -558,6 +558,9 @@ static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
 	switch (mce_log->error_type) {
 	case MC_ERROR_TYPE_UE:
 		mce_err.error_type = MCE_ERROR_TYPE_UE;
+		mce_common_process_ue(regs, &mce_err);
+		if (mce_err.ignore_event)
+			disposition = RTAS_DISP_FULLY_RECOVERED;
 		switch (err_sub_type) {
 		case MC_ERROR_UE_IFETCH:
 			mce_err.u.ue_error_type = MCE_UE_ERROR_IFETCH;
-- 
2.20.1

