Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E846ED0D
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhLIQdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhLIQdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 11:33:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EE2C061746;
        Thu,  9 Dec 2021 08:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E040CE2687;
        Thu,  9 Dec 2021 16:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA18C004DD;
        Thu,  9 Dec 2021 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639067376;
        bh=je+VMTptlRRhblnNtVygK1kL8gLHzyY51wjzz0556fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJCcroQl8ypBDLI0giOF9hZj5Et7nv2syNZ/Pv+dVr19IDM+4KEmU5LdpbBWJ4kqs
         YCju4uz5n84xjeOC2AC2VNvF7KCH8U1xlKICHMQTzv9yeZ8E/ziVWmvSg5KbooypDS
         jxA/r2wPNBDMi7KEdKXPXr9Oi0UkrprDQ+ONn5jk6gL+nXXCPJGNf91WN1dLI6l1FQ
         k5VcpmadJtLZKjOAem1AJaxnPN3jeIa2bfPFPpz0tKXnHEZmgT9G/+qAMbdmab0gXD
         04qF2bOFT5anmR+Fu0lqr2O31qHQCjqF3okIe29CyhG0AC5l9Af3VGopHoT2r4A5PG
         phT7CNV8Yszkg==
Date:   Thu, 9 Dec 2021 18:29:27 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbIu55LZKoK3IVaF@kernel.org>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbIgsO/7oQW9h6wv@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 04:28:48PM +0100, Borislav Petkov wrote:
> On Thu, Dec 09, 2021 at 04:26:55PM +0100, Juergen Gross wrote:
> > Sigh. This will break Xen PV. Again. The comment above the call of
> > early_reserve_memory() tells you why.
> 
> I know. I was just looking at how to fix that particular thing and was
> going to find you on IRC to talk to you about it...

The memory reservation in arch/x86/platform/efi/efi.c depends on at least
two command line parameters, I think it's better put it back later in the
boot process and move efi_memblock_x86_reserve_range() out of
early_memory_reserve().

I.e. revert c0f2077baa41 ("x86/boot: Mark prepare_command_line() __init")
and 8d48bf8206f7 ("x86/boot: Pull up cmdline preparation and early param
parsing") and add the patch below on top.

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 49b596db5631..da36b8f8430b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -713,9 +713,6 @@ static void __init early_reserve_memory(void)
 
 	early_reserve_initrd();
 
-	if (efi_enabled(EFI_BOOT))
-		efi_memblock_x86_reserve_range();
-
 	memblock_x86_reserve_range_setup_data();
 
 	reserve_ibft_region();
@@ -890,6 +887,9 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	if (efi_enabled(EFI_BOOT)) {
+		efi_memblock_x86_reserve_range();
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux

-- 
Sincerely yours,
Mike.
