Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39F13AA05
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbfFIQyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbfFIQyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:54:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189C9204EC;
        Sun,  9 Jun 2019 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099289;
        bh=lAiU1RIanTfQNtNoN4gO/C1h84Mc1DG0kARE30guHgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fehB3Rf6aY2s5SGEf0lT+RxvO35xrlvGW57VEOjBYMLciWu8Rll4dLnit278QN6xt
         90fpEraZORNFU4qqtDL7Vq87FUnI4fMdBa2NSzN7Jkldq/tOoKMT6+IWtLLznaD1n0
         CVKt+UwYthTsqU5gdy9vj07JkhflVxIFw6PmjXyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, bhe@redhat.com,
        bhsharma@redhat.com, bp@alien8.de, eugene@hp.com,
        evgeny.kalugin@intel.com, jhugo@codeaurora.org,
        leif.lindholm@linaro.org, linux-efi@vger.kernel.org,
        mark.rutland@arm.com, roy.franz@cavium.com,
        rruigrok@codeaurora.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 60/83] efi/libstub: Unify command line param parsing
Date:   Sun,  9 Jun 2019 18:42:30 +0200
Message-Id: <20190609164132.986580103@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/arm-stub.c        |   23 +++++++----------------
 drivers/firmware/efi/libstub/arm64-stub.c      |    4 +---
 drivers/firmware/efi/libstub/efi-stub-helper.c |   19 +++++++++++--------
 drivers/firmware/efi/libstub/efistub.h         |    2 ++
 include/linux/efi.h                            |    2 +-
 5 files changed, 22 insertions(+), 28 deletions(-)

--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,7 +18,6 @@
 
 #include "efistub.h"
 
-bool __nokaslr;
 
 static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
@@ -268,18 +267,6 @@ unsigned long efi_entry(void *handle, ef
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
@@ -291,9 +278,13 @@ unsigned long efi_entry(void *handle, ef
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
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -24,8 +24,6 @@
 
 #include "efistub.h"
 
-extern bool __nokaslr;
-
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	u64 tg;
@@ -60,7 +58,7 @@ efi_status_t handle_kernel_image(efi_sys
 	u64 phys_seed = 0;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		if (!__nokaslr) {
+		if (!nokaslr()) {
 			status = efi_get_random_bytes(sys_table_arg,
 						      sizeof(phys_seed),
 						      (u8 *)&phys_seed);
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
@@ -351,17 +358,13 @@ void efi_free(efi_system_table_t *sys_ta
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
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -15,6 +15,8 @@
  */
 #undef __init
 
+extern int __pure nokaslr(void);
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1427,7 +1427,7 @@ efi_status_t handle_cmdline_files(efi_sy
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
-efi_status_t efi_parse_options(char *cmdline);
+efi_status_t efi_parse_options(char const *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,


