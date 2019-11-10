Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA36AF6298
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfKJCoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfKJCoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06A5215EA;
        Sun, 10 Nov 2019 02:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353848;
        bh=8biejw0ri68N+IXHHoIx/vMlktrcCZCWOLin0abQT2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIHwlobrFWUab1zmjiwdz9flyHwUIVNbWoJ5R9XLHIgnBkhx9rdXkvGbGyGZ8GLDL
         5eDVsb5BR9i9laps0X2a+nSVM77N1pPQYrKwyi2CqSkiqJzp3G1rFF8RY1ovpeFzcY
         BeZUuGKvFi/U4X5FiFSXXUOeARMpL5v4u8HBEeDs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Praneeth <sai.praneeth.prakhya@intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 135/191] efi/x86: Handle page faults occurring while running EFI runtime services
Date:   Sat,  9 Nov 2019 21:39:17 -0500
Message-Id: <20191110024013.29782-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

[ Upstream commit 3425d934fc0312f62024163736a7afe4de20c10f ]

Memory accesses performed by UEFI runtime services should be limited to:
- reading/executing from EFI_RUNTIME_SERVICES_CODE memory regions
- reading/writing from/to EFI_RUNTIME_SERVICES_DATA memory regions
- reading/writing by-ref arguments
- reading/writing from/to the stack.

Accesses outside these regions may cause the kernel to hang because the
memory region requested by the firmware isn't mapped in efi_pgd, which
causes a page fault in ring 0 and the kernel fails to handle it, leading
to die(). To save kernel from hanging, add an EFI specific page fault
handler which recovers from such faults by
1. If the efi runtime service is efi_reset_system(), reboot the machine
   through BIOS.
2. If the efi runtime service is _not_ efi_reset_system(), then freeze
   efi_rts_wq and schedule a new process.

The EFI page fault handler offers us two advantages:
1. Avoid potential hangs caused by buggy firmware.
2. Shout loud that the firmware is buggy and hence is not a kernel bug.

Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
[ardb: clarify commit log]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/efi.h              |  1 +
 arch/x86/mm/fault.c                     |  9 +++
 arch/x86/platform/efi/quirks.c          | 78 +++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c |  8 +++
 include/linux/efi.h                     |  8 ++-
 5 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index baa549f8e9188..45864898f7e50 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -138,6 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
+extern void efi_recover_from_page_fault(unsigned long phys_addr);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 1bcb7242ad79a..53e69c7c5cd18 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -16,6 +16,7 @@
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
+#include <linux/efi.h>			/* efi_recover_from_page_fault()*/
 #include <linux/mm_types.h>
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
@@ -25,6 +26,7 @@
 #include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 #include <asm/vm86.h>			/* struct vm86			*/
 #include <asm/mmu_context.h>		/* vma_pkey()			*/
+#include <asm/efi.h>			/* efi_recover_from_page_fault()*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -783,6 +785,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	if (is_errata93(regs, address))
 		return;
 
+	/*
+	 * Buggy firmware could access regions which might page fault, try to
+	 * recover from such faults.
+	 */
+	if (IS_ENABLED(CONFIG_EFI))
+		efi_recover_from_page_fault(address);
+
 	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 844d31cb8a0c7..669babcaf245a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -16,6 +16,7 @@
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 #include <asm/cpu_device_id.h>
+#include <asm/reboot.h>
 
 #define EFI_MIN_RESERVE 5120
 
@@ -654,3 +655,80 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 }
 
 #endif
+
+/*
+ * If any access by any efi runtime service causes a page fault, then,
+ * 1. If it's efi_reset_system(), reboot through BIOS.
+ * 2. If any other efi runtime service, then
+ *    a. Return error status to the efi caller process.
+ *    b. Disable EFI Runtime Services forever and
+ *    c. Freeze efi_rts_wq and schedule new process.
+ *
+ * @return: Returns, if the page fault is not handled. This function
+ * will never return if the page fault is handled successfully.
+ */
+void efi_recover_from_page_fault(unsigned long phys_addr)
+{
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return;
+
+	/*
+	 * Make sure that an efi runtime service caused the page fault.
+	 * "efi_mm" cannot be used to check if the page fault had occurred
+	 * in the firmware context because efi=old_map doesn't use efi_pgd.
+	 */
+	if (efi_rts_work.efi_rts_id == NONE)
+		return;
+
+	/*
+	 * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
+	 * page faulting on these addresses isn't expected.
+	 */
+	if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
+		return;
+
+	/*
+	 * Print stack trace as it might be useful to know which EFI Runtime
+	 * Service is buggy.
+	 */
+	WARN(1, FW_BUG "Page fault caused by firmware at PA: 0x%lx\n",
+	     phys_addr);
+
+	/*
+	 * Buggy efi_reset_system() is handled differently from other EFI
+	 * Runtime Services as it doesn't use efi_rts_wq. Although,
+	 * native_machine_emergency_restart() says that machine_real_restart()
+	 * could fail, it's better not to compilcate this fault handler
+	 * because this case occurs *very* rarely and hence could be improved
+	 * on a need by basis.
+	 */
+	if (efi_rts_work.efi_rts_id == RESET_SYSTEM) {
+		pr_info("efi_reset_system() buggy! Reboot through BIOS\n");
+		machine_real_restart(MRR_BIOS);
+		return;
+	}
+
+	/*
+	 * Before calling EFI Runtime Service, the kernel has switched the
+	 * calling process to efi_mm. Hence, switch back to task_mm.
+	 */
+	arch_efi_call_virt_teardown();
+
+	/* Signal error status to the efi caller process */
+	efi_rts_work.status = EFI_ABORTED;
+	complete(&efi_rts_work.efi_rts_comp);
+
+	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
+
+	/*
+	 * Call schedule() in an infinite loop, so that any spurious wake ups
+	 * will never run efi_rts_wq again.
+	 */
+	for (;;) {
+		set_current_state(TASK_IDLE);
+		schedule();
+	}
+
+	return;
+}
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b31e3d3729a6d..e2abfdb5cee6a 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
 ({									\
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
+		pr_warn_once("EFI Runtime Services are disabled!\n");	\
+		goto exit;						\
+	}								\
+									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
 	INIT_WORK(&efi_rts_work.work, efi_call_rts);			\
 	efi_rts_work.arg1 = _arg1;					\
@@ -79,6 +84,8 @@ struct efi_runtime_work efi_rts_work;
 	else								\
 		pr_err("Failed to queue work to efi_rts_wq.\n");	\
 									\
+exit:									\
+	efi_rts_work.efi_rts_id = NONE;					\
 	efi_rts_work.status;						\
 })
 
@@ -400,6 +407,7 @@ static void virt_efi_reset_system(int reset_type,
 			"could not get exclusive access to the firmware\n");
 		return;
 	}
+	efi_rts_work.efi_rts_id = RESET_SYSTEM;
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
 	up(&efi_runtime_lock);
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9d4c25090fd04..9a86f467b8911 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1666,8 +1666,13 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
-/* efi_runtime_service() function identifiers */
+/*
+ * efi_runtime_service() function identifiers.
+ * "NONE" is used by efi_recover_from_page_fault() to check if the page
+ * fault happened while executing an efi runtime service.
+ */
 enum efi_rts_ids {
+	NONE,
 	GET_TIME,
 	SET_TIME,
 	GET_WAKEUP_TIME,
@@ -1677,6 +1682,7 @@ enum efi_rts_ids {
 	SET_VARIABLE,
 	QUERY_VARIABLE_INFO,
 	GET_NEXT_HIGH_MONO_COUNT,
+	RESET_SYSTEM,
 	UPDATE_CAPSULE,
 	QUERY_CAPSULE_CAPS,
 };
-- 
2.20.1

