Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3677A159FA
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfEGFlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbfEGFlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:41:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B98C920675;
        Tue,  7 May 2019 05:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207709;
        bh=kpd7/k7r6GpIU1KFTkia1a6/RVNXjvMllUA/yCz3gjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WalPEDxiwuc97XY7zoNqWvyBY9SfCV0YQuY5qG6rQ2QaWFhY2kCS0Ux3BEFYzfwES
         36VGpwZFiCLn/EuoiDMfcAZRJ5iesaIHiCLWNvvv2+In6xDJC/+2t8gL070zfIKSZp
         0z9+wEPRah77F8ASYaC03zDZJHNdptLLJHXER91w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux@endlessm.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 12/25] x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T
Date:   Tue,  7 May 2019 01:41:09 -0400
Message-Id: <20190507054123.32514-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507054123.32514-1-sashal@kernel.org>
References: <20190507054123.32514-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit 0082517fa4bce073e7cf542633439f26538a14cc ]

Upon reboot, the Acer TravelMate X514-51T laptop appears to complete the
shutdown process, but then it hangs in BIOS POST with a black screen.

The problem is intermittent - at some points it has appeared related to
Secure Boot settings or different kernel builds, but ultimately we have
not been able to identify the exact conditions that trigger the issue to
come and go.

Besides, the EFI mode cannot be disabled in the BIOS of this model.

However, after extensive testing, we observe that using the EFI reboot
method reliably avoids the issue in all cases.

So add a boot time quirk to use EFI reboot on such systems.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203119
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux@endlessm.com
Link: http://lkml.kernel.org/r/20190412080152.3718-1-jian-hong@endlessm.com
[ Fix !CONFIG_EFI build failure, clarify the code and the changelog a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/reboot.c | 21 +++++++++++++++++++++
 include/linux/efi.h      |  7 ++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4a12362a194a..c55b11fe8e9f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -82,6 +82,19 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/*
+ * Some machines don't handle the default ACPI reboot method and
+ * require the EFI reboot method:
+ */
+static int __init set_efi_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_EFI && !efi_runtime_disabled()) {
+		reboot_type = BOOT_EFI;
+		pr_info("%s series board detected. Selecting EFI-method for reboot.\n", d->ident);
+	}
+	return 0;
+}
+
 void __noreturn machine_real_restart(unsigned int type)
 {
 	local_irq_disable();
@@ -167,6 +180,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
 		},
 	},
+	{	/* Handle reboot issue on Acer TravelMate X514-51T */
+		.callback = set_efi_reboot,
+		.ident = "Acer TravelMate X514-51T",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate X514-51T"),
+		},
+	},
 
 	/* Apple */
 	{	/* Handle problems with rebooting on Apple MacBook5 */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 80b1b8faf503..e6711bf9f0d1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1433,7 +1433,12 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,
 			   unsigned long size);
 
-bool efi_runtime_disabled(void);
+#ifdef CONFIG_EFI
+extern bool efi_runtime_disabled(void);
+#else
+static inline bool efi_runtime_disabled(void) { return true; }
+#endif
+
 extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
 
 /*
-- 
2.20.1

