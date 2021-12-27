Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F748039D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhL0TET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41104 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhL0TEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9FF4B81130;
        Mon, 27 Dec 2021 19:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BACFC36AE7;
        Mon, 27 Dec 2021 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631852;
        bh=Mr+NttxtWNF53BfdE0xN0WW+YLTli/OdT1Qb9/0vxQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3uxJGD8Gn4mVN9ssKbiBxhkfzFhgaTtOFNT4dTfn2W5Es3l92NqimwOf/sGOfge4
         1DHFl+ixamhTQCtBRS79LebGlN3oOcyVRk7OqByAiOnbhWTCbF+Io2lgdNQNienHYr
         tcgjO9/0hwYgPxDUbWVSX1w2lUklQkK/rWMQbDbGN48U6Bh098/G4ryQpD47YoeNRB
         /Z8XDChVPIJm7ndw9LXO29rBaAbQanOjRdlZtrqnvvO7GgWIuTVVzFV1iVu8MCcOP9
         +bGrktqeeJX4YmESfui5ddX5WiAUi2HCclyxo4UQCAIWF4bPXWBBbgdF9Qgc5OqPeL
         ahxmalqSbbPHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, rppt@kernel.org,
        akpm@linux-foundation.org, rafael.j.wysocki@intel.com,
        peterz@infradead.org, andriy.shevchenko@linux.intel.com,
        jgross@suse.com
Subject: [PATCH AUTOSEL 5.15 11/26] Revert "x86/boot: Pull up cmdline preparation and early param parsing"
Date:   Mon, 27 Dec 2021 14:03:12 -0500
Message-Id: <20211227190327.1042326-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit fbe6183998546f8896ee0b620ece86deff5a2fd1 ]

This reverts commit 8d48bf8206f77aa8687f0e241e901e5197e52423.

It turned out to be a bad idea as it broke supplying mem= cmdline
parameters due to parse_memopt() requiring preparatory work like setting
up the e820 table in e820__memory_setup() in order to be able to exclude
the range specified by mem=.

Pulling that up would've broken Xen PV again, see threads at

  https://lkml.kernel.org/r/20210920120421.29276-1-jgross@suse.com

due to xen_memory_setup() needing the first reservations in
early_reserve_memory() - kernel and initrd - to have happened already.

This could be fixed again by having Xen do those reservations itself...

Long story short, revert this and do a simpler fix in a later patch.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211213112757.2612-3-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/setup.c | 66 +++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d71267081153f..40ed44ead0631 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,28 +742,6 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
 	return 0;
 }
 
-static char *prepare_command_line(void)
-{
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
-
-	parse_early_param();
-
-	return command_line;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -852,23 +830,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
-	/*
-	 * x86_configure_nx() is called before parse_early_param() (called by
-	 * prepare_command_line()) to detect whether hardware doesn't support
-	 * NX (so that the early EHCI debug console setup can safely call
-	 * set_fixmap()). It may then be called again from within noexec_setup()
-	 * during parsing early parameters to honor the respective command line
-	 * option.
-	 */
-	x86_configure_nx();
-
-	/*
-	 * This parses early params and it needs to run before
-	 * early_reserve_memory() because latter relies on such settings
-	 * supplied as early params.
-	 */
-	*cmdline_p = prepare_command_line();
-
 	/*
 	 * Do some memory reservations *before* memory is added to memblock, so
 	 * memblock allocations won't overwrite it.
@@ -902,6 +863,33 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = __pa_symbol(__bss_start);
 	bss_resource.end = __pa_symbol(__bss_stop)-1;
 
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
+	*cmdline_p = command_line;
+
+	/*
+	 * x86_configure_nx() is called before parse_early_param() to detect
+	 * whether hardware doesn't support NX (so that the early EHCI debug
+	 * console setup can safely call set_fixmap()). It may then be called
+	 * again from within noexec_setup() during parsing early parameters
+	 * to honor the respective command line option.
+	 */
+	x86_configure_nx();
+
+	parse_early_param();
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux
-- 
2.34.1

