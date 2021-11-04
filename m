Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98231445258
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 12:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhKDLnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 07:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhKDLnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 07:43:21 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B89BC061714;
        Thu,  4 Nov 2021 04:40:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f2b005f7e04e061602c85.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:2b00:5f7e:4e0:6160:2c85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 279B01EC0521;
        Thu,  4 Nov 2021 12:40:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636026040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HeCtM04lRduzY1cbTvwTJgI7ye/vnc7jVcYn50BVUig=;
        b=BUcdkkKW7NhQqPmz/aZYQN+8ZHLlYbWMgwBrqu+FUHCTvPN9JcwSjPAuVQH1cFMb35k+Er
        lsXvpYB8mrG6ljrYMOuWydiL9NiqzvYpvkjRCNBkomIHKcqUrDWh9BZs00htRKdj7cceiB
        sM5HaBth4T3DmA1DZ23E46mLpnR46Fo=
Date:   Thu, 4 Nov 2021 12:40:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Williams, Dan J" <dan.j.williams@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "marmarek@invisiblethingslab.com" <marmarek@invisiblethingslab.com>,
        "Chagam, Anjaneya" <anjaneya.chagam@intel.com>,
        "bp@suse.de" <bp@suse.de>, "x86@kernel.org" <x86@kernel.org>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YYPGsUNm0UXcYKOA@zn.tnic>
References: <20210920120421.29276-1-jgross@suse.com>
 <163233113662.25758.10031107028271701591.tip-bot2@tip-bot2>
 <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e8dd8993c38702ee6dd73b3c11f158617e665607.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Mike.

On Thu, Nov 04, 2021 at 05:38:54AM +0000, Williams, Dan J wrote:
> By inspection, this commit looks like the source of the problem because
> early_reserve_memory() now runs before parse_early_param().

Yah, I see it too:

early_reserve_memory
|-> efi_memblock_x86_reserve_range
    |-> efi_fake_memmap_early

which does

        if (!efi_soft_reserve_enabled())
                return;

and that would have set EFI_MEM_NO_SOFT_RESERVE after having parsed
"nosoftreserve".

And parse_early_param() happens later.

Uuuf, that early memory reservation dance is not going to be over,
ever...

Well, I guess we can do something like this below. The intent being to
carve out the command line preparation into a separate function which
does the early param parsing too. So that it all goes together.

And then call that function before early_reserve_memory() so that the
params have been parsed by then.

Looking at the changed flow, I think we should be ok but I've said that
a bunch of times already regarding this memory reservation early and
something in our house of cards called early boot order always broke.

Damn.

---
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 40ed44ead063..05f69e7d84dc 100644
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
@@ -830,6 +852,23 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	/*
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
+	 * supplies as early params.
+	 */
+	*cmdline_p = prepare_command_line();
+
 	/*
 	 * Do some memory reservations *before* memory is added to memblock, so
 	 * memblock allocations won't overwrite it.
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


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
