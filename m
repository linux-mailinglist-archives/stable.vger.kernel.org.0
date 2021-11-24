Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99345C5CE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349177AbhKXOAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355761AbhKXN6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C65B633EE;
        Wed, 24 Nov 2021 13:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759316;
        bh=Wec3zMf/RLQI5VicQJuz1S5UEqF3tH0CD8MgH9a8aXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfmT3IZi5lCMajHgZ2aDMiZprzfrE1ce7nIq/Ge+fYiYeYYPRJvJjyFchhNm5UxGW
         4pmDRyYAiQNReOSOFdk2T6Ys6UEMrMPF2nNltNGxTWpHmFejLtxL1Thx1vE4aba/CL
         ggYuu0L6c3jBBqCcFfMOmSPE+qZZEsreNjnlC4oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Anjaneya Chagam <anjaneya.chagam@intel.com>
Subject: [PATCH 5.15 201/279] x86/boot: Pull up cmdline preparation and early param parsing
Date:   Wed, 24 Nov 2021 12:58:08 +0100
Message-Id: <20211124115725.677419727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 8d48bf8206f77aa8687f0e241e901e5197e52423 upstream.

Dan reports that Anjaneya Chagam can no longer use the efi=nosoftreserve
kernel command line parameter to suppress "soft reservation" behavior.

This is due to the fact that the following call-chain happens at boot:

early_reserve_memory
|-> efi_memblock_x86_reserve_range
    |-> efi_fake_memmap_early

which does

        if (!efi_soft_reserve_enabled())
                return;

and that would have set EFI_MEM_NO_SOFT_RESERVE after having parsed
"nosoftreserve".

However, parse_early_param() gets called *after* it, leading to the boot
cmdline not being taken into account.

Therefore, carve out the command line preparation into a separate
function which does the early param parsing too. So that it all goes
together.

And then call that function before early_reserve_memory() so that the
params would have been parsed by then.

Fixes: 8aa83e6395ce ("x86/setup: Call early_reserve_memory() earlier")
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Anjaneya Chagam <anjaneya.chagam@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |   66 ++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,6 +742,28 @@ dump_kernel_offset(struct notifier_block
 	return 0;
 }
 
+static char *prepare_command_line(void)
+{
+#ifdef CONFIG_CMDLINE_BOOL
+#ifdef CONFIG_CMDLINE_OVERRIDE
+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+#else
+	if (builtin_cmdline[0]) {
+		/* append boot loader cmdline to builtin */
+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
+	}
+#endif
+#endif
+
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+
+	parse_early_param();
+
+	return command_line;
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -831,6 +853,23 @@ void __init setup_arch(char **cmdline_p)
 	x86_init.oem.arch_setup();
 
 	/*
+	 * x86_configure_nx() is called before parse_early_param() (called by
+	 * prepare_command_line()) to detect whether hardware doesn't support
+	 * NX (so that the early EHCI debug console setup can safely call
+	 * set_fixmap()). It may then be called again from within noexec_setup()
+	 * during parsing early parameters to honor the respective command line
+	 * option.
+	 */
+	x86_configure_nx();
+
+	/*
+	 * This parses early params and it needs to run before
+	 * early_reserve_memory() because latter relies on such settings
+	 * supplied as early params.
+	 */
+	*cmdline_p = prepare_command_line();
+
+	/*
 	 * Do some memory reservations *before* memory is added to memblock, so
 	 * memblock allocations won't overwrite it.
 	 *
@@ -863,33 +902,6 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = __pa_symbol(__bss_start);
 	bss_resource.end = __pa_symbol(__bss_stop)-1;
 
-#ifdef CONFIG_CMDLINE_BOOL
-#ifdef CONFIG_CMDLINE_OVERRIDE
-	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-#else
-	if (builtin_cmdline[0]) {
-		/* append boot loader cmdline to builtin */
-		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
-		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
-	}
-#endif
-#endif
-
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-	/*
-	 * x86_configure_nx() is called before parse_early_param() to detect
-	 * whether hardware doesn't support NX (so that the early EHCI debug
-	 * console setup can safely call set_fixmap()). It may then be called
-	 * again from within noexec_setup() during parsing early parameters
-	 * to honor the respective command line option.
-	 */
-	x86_configure_nx();
-
-	parse_early_param();
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux


