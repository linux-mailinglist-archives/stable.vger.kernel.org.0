Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4A34922F5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiARJkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:40:53 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58936 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbiARJkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 04:40:53 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B641A1EC018C;
        Tue, 18 Jan 2022 10:40:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1642498847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1krZRAcW2/qQOgGBfGLOIoGvqo818a87chwmI8ChMGc=;
        b=R3Ufj3Pf/CNEgauoGpET//WwMKJG+l61x23bQgi9j9qbI/UOOuP+c//D/a/Y1cg/zM1qNI
        DnrbsJI+HcRo/41FnqORyxRyzSKvdDt2Hkno7oHAJFUFUaFRXtq5xfUPWrizsxq6LSH/5V
        8cKjJ3CaWuTO+CfsbKRH/JVUGmMWEAs=
Date:   Tue, 18 Jan 2022 10:40:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/5] x86/quirks: Fix stolen detection with integrated
 + discrete GPU
Message-ID: <YeaLIs9t0jhovC28@zn.tnic>
References: <20220114002843.2083382-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220114002843.2083382-1-lucas.demarchi@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

n Thu, Jan 13, 2022 at 04:28:39PM -0800, Lucas De Marchi wrote:
> early_pci_scan_bus() does a depth-first traversal, possibly calling
> the quirk functions for each device based on vendor, device and class
> from early_qrk table. intel_graphics_quirks() however uses PCI_ANY_ID
> and does additional filtering in the quirk.
> 
> If there is an Intel integrated + discrete GPU the quirk may be called
> first for the discrete GPU based on the PCI topology. Then we will fail
> to reserve the system stolen memory for the integrated GPU, because we
> will already have marked the quirk as "applied".

Who is "we"?

Please use passive voice in your commit message: no "we" or "I", etc,
and describe your changes in imperative mood.

Bottom line is: personal pronouns are ambiguous in text, especially with
so many parties/companies/etc developing the kernel so let's avoid them
please.

> This was reproduced in a setup with Alderlake-P (integrated) + DG2
> (discrete), with the following PCI topology:
> 
> 	- 00:01.0 Bridge
> 	  `- 03:00.0 DG2
> 	- 00:02.0 Integrated GPU
> 
> So, stop using the QFLAG_APPLY_ONCE flag, replacing it with a static
> local variable. We can set this variable in the right place, inside
> intel_graphics_quirks(), only when the quirk was actually applied, i.e.
> when we find the integrated GPU based on the intel_early_ids table.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> ---
> 
> v5: apply fix before the refactor
> 
>  arch/x86/kernel/early-quirks.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 1ca3a56fdc2d..de9a76eb544e 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -589,10 +589,14 @@ intel_graphics_stolen(int num, int slot, int func,
>  
>  static void __init intel_graphics_quirks(int num, int slot, int func)
>  {
> +	static bool quirk_applied __initdata;
>  	const struct intel_early_ops *early_ops;
>  	u16 device;
>  	int i;
>  
> +	if (quirk_applied)
> +		return;
> +
>  	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
>  
>  	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
> @@ -605,6 +609,8 @@ static void __init intel_graphics_quirks(int num, int slot, int func)
>  
>  		intel_graphics_stolen(num, slot, func, early_ops);
>  
> +		quirk_applied = true;
> +
>  		return;
>  	}

So I wonder: why can't you simply pass in a static struct chipset *
pointer into the early_qrk[i].f function and in there you can set
QFLAG_APPLIED or so, so that you can mark that the quirk is applied by
using the nice, per-quirk flags someone has already added instead of
this ugly static variable?

Patch 3 especially makes me go, huh?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
