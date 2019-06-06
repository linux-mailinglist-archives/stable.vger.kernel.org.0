Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70BA37193
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 12:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfFFKZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 06:25:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55058 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfFFKZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 06:25:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so1849754wme.4
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 03:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RQPlTg6uUpRE5oDmTjzARjoKoGmiagH9gmTW8/5dICA=;
        b=UHQRx9Q/KPp0M2GSy4P9+yc1sYzXq6q24bkA1bqR34fF2QbVm13+ho75oqFRknjsgC
         SVVUmntzGH5wu64W+PUJ2neWS8USpW69Onp6mWIbCMvnkt63kIyE5iIvhMWBbfYfR2yY
         piidjN91uUZWF7z90ZuS4wSIEBr2PpAb03rs1gpvC0LXDh1HVP/ds7h0IMoGABHWIrGT
         VZks4dQi0P4RPa3OrKE7kfGroD+4lSUVh7ix1eHnE8FVbQHMlgBV/i8ICTZq7hNs/3J/
         omvf6NHpSdeIdewEohYNsMq4fW2F9dCP8zjQ9tpWYNaUL/pGuolExMYF5nW506KlfTCm
         558g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RQPlTg6uUpRE5oDmTjzARjoKoGmiagH9gmTW8/5dICA=;
        b=B/fOAbUkQk7LL2ofFXqSwAb/eQNXW317qas4Ya8xbFKD5EVeVj4hSfJ1oDD8v30RO6
         kJLDj9nUC94iHHSArbib9Dgq2V3GtDVrjn/enAwkIkYleJfy+Z0T6y05TwHDgJRCu8Og
         l6Juh7AsuOkn0rNkOOTgQv2XEWfSv/h3qSUShNULIlnZq0MOGSKClXD/hz++IxkpJUc5
         ATHo/ju/BWHJaRVAdeWfN/3966F9l2o5wXUqOToD/ZcBcyhgw5Y5HwdrX7B11WIBSVY0
         4mH3l37oHmj+tWHN2jsvjO62xeMUDycd1B/00B60IrOwqlQUVsVKS0IEfk203ZP3j5Qa
         7+HA==
X-Gm-Message-State: APjAAAUJpaTqEFtt1wqmLx1MyXgjlNZJnGtn9HdQflmzLtGsp91gkbEb
        0JRS0V8DOF55WA4ngSV2r487dA==
X-Google-Smtp-Source: APXvYqxtP51Qaz6shxqnhOZ9cKxoIVrRs3bzSOFLOZkb/NNy24Ga1KGipcJ1DF27pOigk4ZUHRtsJg==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr13914013wmb.115.1559816730398;
        Thu, 06 Jun 2019 03:25:30 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99ee:9f00:43cc:cfbf])
        by smtp.gmail.com with ESMTPSA id u23sm1146611wmj.33.2019.06.06.03.25.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 03:25:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     eb@emlix.com
Cc:     linux-efi@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, ndesaulniers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-4.9-stable] efi/libstub: Unify command line param parsing
Date:   Thu,  6 Jun 2019 12:25:13 +0200
Message-Id: <20190606102513.16321-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.

Merge the parsing of the command line carried out in arm-stub.c with
the handling in efi_parse_options(). Note that this also fixes the
missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
command line should supersede the one passed by the firmware.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bhe@redhat.com
Cc: bhsharma@redhat.com
Cc: bp@alien8.de
Cc: eugene@hp.com
Cc: evgeny.kalugin@intel.com
Cc: jhugo@codeaurora.org
Cc: leif.lindholm@linaro.org
Cc: linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com
Cc: roy.franz@cavium.com
Cc: rruigrok@codeaurora.org
Link: http://lkml.kernel.org/r/20170404160910.28115-1-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ardb: fix up merge conflicts with 4.9.180]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This fixes the GCC build issue reported by Eike.

Note that testing of arm64 stable kernels should cover CONFIG_RANDOMIZE_BASE,
since it has a profound impact on how the kernel binary gets put together.

 drivers/firmware/efi/libstub/arm-stub.c        | 23 ++++++--------------
 drivers/firmware/efi/libstub/arm64-stub.c      |  4 +---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 19 +++++++++-------
 drivers/firmware/efi/libstub/efistub.h         |  2 ++
 include/linux/efi.h                            |  2 +-
 5 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 993aa56755f6..726d1467b778 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,7 +18,6 @@
 
 #include "efistub.h"
 
-bool __nokaslr;
 
 static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
@@ -268,18 +267,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/* check whether 'nokaslr' was passed on the command line */
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		static const u8 default_cmdline[] = CONFIG_CMDLINE;
-		const u8 *str, *cmdline = cmdline_ptr;
-
-		if (IS_ENABLED(CONFIG_CMDLINE_FORCE))
-			cmdline = default_cmdline;
-		str = strstr(cmdline, "nokaslr");
-		if (str == cmdline || (str > cmdline && *(str - 1) == ' '))
-			__nokaslr = true;
-	}
-
 	si = setup_graphics(sys_table);
 
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
@@ -291,9 +278,13 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
-	status = efi_parse_options(cmdline_ptr);
-	if (status != EFI_SUCCESS)
-		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
+	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
+	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
+	    cmdline_size == 0)
+		efi_parse_options(CONFIG_CMDLINE);
+
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
+		efi_parse_options(cmdline_ptr);
 
 	secure_boot = efi_get_secureboot(sys_table);
 	if (secure_boot > 0)
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 959d9b8d4845..f7a6970e9abc 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -24,8 +24,6 @@
 
 #include "efistub.h"
 
-extern bool __nokaslr;
-
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	u64 tg;
@@ -60,7 +58,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	u64 phys_seed = 0;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		if (!__nokaslr) {
+		if (!nokaslr()) {
 			status = efi_get_random_bytes(sys_table_arg,
 						      sizeof(phys_seed),
 						      (u8 *)&phys_seed);
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 09d10dcf1fc6..1c963c4d1bde 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,13 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+static int __section(.data) __nokaslr;
+
+int __pure nokaslr(void)
+{
+	return __nokaslr;
+}
+
 /*
  * Allow the platform to override the allocation granularity: this allows
  * systems that have the capability to run with a larger page size to deal
@@ -351,17 +358,13 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
  * environments, first in the early boot environment of the EFI boot
  * stub, and subsequently during the kernel boot.
  */
-efi_status_t efi_parse_options(char *cmdline)
+efi_status_t efi_parse_options(char const *cmdline)
 {
 	char *str;
 
-	/*
-	 * Currently, the only efi= option we look for is 'nochunk', which
-	 * is intended to work around known issues on certain x86 UEFI
-	 * versions. So ignore for now on other architectures.
-	 */
-	if (!IS_ENABLED(CONFIG_X86))
-		return EFI_SUCCESS;
+	str = strstr(cmdline, "nokaslr");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__nokaslr = 1;
 
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fac67992bede..d0e5acab547f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -15,6 +15,8 @@
  */
 #undef __init
 
+extern int __pure nokaslr(void);
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e6711bf9f0d1..02c4f16685b6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1427,7 +1427,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
-efi_status_t efi_parse_options(char *cmdline);
+efi_status_t efi_parse_options(char const *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,
-- 
2.20.1

