Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F4E450398
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKOLjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:39:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44242 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhKOLj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:39:28 -0500
Date:   Mon, 15 Nov 2021 11:36:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636976181;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrHBkY1MQHLMn12QQixBwQeDPnRgvdltq+kM0eEfr+M=;
        b=jsjRpKOokSmmb48TSaL/EU1NJQCxLCMUT6Ud1j/ymRhKk7rGd5Wb6ZLvCFk7IZuU2Kj8fP
        /r5guHSy53Fa1dFfdNI+gZA4ZYqhyZpMx4/iyUW+DoJTBdsx9lWFf3a5IGtL+2kUi614UI
        9sF7SE/DL+lBbqx5RGRIEgr6Iig9L9RqEWfk2HdcY8zgj1XSNt3LgWAxLeAZlyvL1PPaDK
        b99mPFzEuJLxNaBCpC2bnJDInSihvmwL83L+THd07Ph7/whu8A1mndvbQC0GSgtokVx+/C
        9JLEfXAFKhCzERsKsuPRoeJIzByhR7RivIO7dYeoddzCpFqu42LMt/GFAMk/ng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636976181;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrHBkY1MQHLMn12QQixBwQeDPnRgvdltq+kM0eEfr+M=;
        b=6sER1bgPm5NSoEGO4Er46zS4HZItAKjbP670N6/cyT09CMec+SftTEuPM9Ttgg2wnumky/
        z3GX4hUB8GSxeRBw==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Anjaneya Chagam <anjaneya.chagam@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com>
References: <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com>
MIME-Version: 1.0
Message-ID: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8d48bf8206f77aa8687f0e241e901e5197e52423
Gitweb:        https://git.kernel.org/tip/8d48bf8206f77aa8687f0e241e901e5197e52423
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Fri, 05 Nov 2021 10:41:51 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 15 Nov 2021 12:27:40 +01:00

x86/boot: Pull up cmdline preparation and early param parsing

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
---
 arch/x86/kernel/setup.c | 66 +++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 49b596d..c410be7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,6 +742,28 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
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
