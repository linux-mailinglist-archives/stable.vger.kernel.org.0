Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE86446EAF8
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 16:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhLIPWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 10:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbhLIPWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 10:22:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F74C0617A1;
        Thu,  9 Dec 2021 07:19:12 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0036A1EC0503;
        Thu,  9 Dec 2021 16:19:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639063146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hnVow05zGwYUceTmQ9hNcIsttLUONol/7cmMzWAEf8I=;
        b=FFpAdOmtSWfdBF9+MI0GQgEE1rFMGX0OYfSJLW0yse2A7TYV0P5+Bzc1xuW2Qa+g2twjh/
        N6jO011ZBqxqBBLblPN2uJCIhn/ieYzHNgex/3i6IEX7ezN+yhAOabdhgaY4qG8bSg0Oz/
        wrRhTf+QCC77yyB4DyO6b4rYFKwOvpE=
Date:   Thu, 9 Dec 2021 16:19:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     John Dorminy <jdorminy@redhat.com>
Cc:     tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbIeYIM6JEBgO3tG@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209143810.452527-1-jdorminy@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Hugh and Patrick.

On Thu, Dec 09, 2021 at 09:38:10AM -0500, John Dorminy wrote:
> Greetings;
> 
> It seems that this patch causes a mem= parameter to the kernel to have no effect, unfortunately... 
> 
> As far as I understand, the x86 mem parameter handler parse_memopt() (called by parse_early_param()) relies on being called after e820__memory_setup(): it simply removes any memory above the specified limit at that moment, allowing memory to later be hotplugged without regard for the initial limit. However, the initial non-hotplugged memory must already have been set up, in e820__memory_setup(), so that it can be removed in parse_memopt(); if parse_early_param() is called before e820__memory_setup(), as this change does, the parameter ends up having no effect.
> 
> I apologize that I don't know how to fix this, but I'm happy to test patches.

Yeah, people have been reporting boot failures with mem= on the cmdline.

I think I see why, can you try this one:

---
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6a190c7f4d71..6db971e61e4b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -862,6 +862,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	x86_configure_nx();
 
+	e820__memory_setup();
+
 	/*
 	 * This parses early params and it needs to run before
 	 * early_reserve_memory() because latter relies on such settings
@@ -884,7 +886,6 @@ void __init setup_arch(char **cmdline_p)
 	early_reserve_memory();
 
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
-	e820__memory_setup();
 	parse_setup_data();
 
 	copy_edd();
---

Leaving in the rest for the newly added folks.

> Typical dmesg output showing the lack of effect, built from the prior change and this change:
> 
> With a git tree synced to 8d48bf8206f77aa8687f0e241e901e5197e52423^ (working):
> [    0.000000] Command line: BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.16.0-rc1 root=UUID=a4f7bd84-4f29-40bc-8c98-f4a72d0856c4 ro net.ifnames=0 crashkernel=128M mem=4G
> ...
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
> [    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] user-defined physical RAM map:
> [    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usable
> [    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reserved
> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usable
> [    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
> [    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
> [    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
> [    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
> [    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> ...
> [    0.025617] Memory: 1762876K/2061136K available (16394K kernel code, 3568K rwdata, 10324K rodata, 2676K init, 4924K bss, 298000K reserved, 0K cma-reserved)
> 
> Synced 8d48bf8206f77aa8687f0e241e901e5197e52423 (not working):
> 
> [    0.000000] Command line: BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.16.0-rc4+ root=UUID=0e750e61-b92e-4708-a974-c50a3fb7e969 ro net.ifnames=0 crashkernel=128M mem=4G
> [    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usable
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] user-defined physical RAM map:
> [    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usable
> [    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reserved
> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usable
> [    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
> [    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
> [    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
> [    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
> [    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] user: [mem 0x0000000100000000-0x000000207fffffff] usable
> ...
> [    0.695267] Memory: 131657608K/134181712K available (16394K kernel code, 3568K rwdata, 10328K rodata, 2676K init, 4924K bss, 2523844K reserved, 0K cma-reserved)
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
