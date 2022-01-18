Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47632492E3E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbiARTOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:14:42 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60196 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244343AbiARTO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 14:14:28 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6673A1EC0495;
        Tue, 18 Jan 2022 20:14:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1642533262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ERiFXzh6NqwS4HsY/OsDLFVYh6aR15kreizWwmmn2Dk=;
        b=LWGg2KKjKGIPeoiWiKdeQBhPOZ7g99QefDy0/P3Fu27f2yI/KFr/20WVSDdGZcVZYR5430
        cPFezjkNTTVSQMGOTPf28mkDxcUrMfMiukBf2zq2CbP97aAhBCXHr6586P9DiEtdQB9pkF
        YmLa2GlWAhDpKnTEAzeAFiOTn9Cravk=
Date:   Tue, 18 Jan 2022 20:14:24 +0100
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
Message-ID: <YecRkGidIS10N0md@zn.tnic>
References: <20220114002843.2083382-1-lucas.demarchi@intel.com>
 <YeaLIs9t0jhovC28@zn.tnic>
 <20220118163656.fzzkwubgoe5gz36k@ldmartin-desk2>
 <Yeb4WKOFNDNbx6tH@zn.tnic>
 <20220118190558.2ququ4vdfjuahicm@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220118190558.2ququ4vdfjuahicm@ldmartin-desk2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 11:05:58AM -0800, Lucas De Marchi wrote:
> I think to make it similar how the PCI fixups work. Anyway, do you
> prefer that I change the QFLAG_APPLY_ONCE as above (including
> nvidia_bugs() and ati_bugs()) or a very minimal fix like below and
> nothing else?
> 
> ------8<------
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 391a4e2b8604..7b2a3230c42a 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -591,6 +591,13 @@ static void __init intel_graphics_quirks(int num, int slot, int func)
>  	u16 device;
>  	int i;
> +	/*
> +	 * Already reserved for integrated graphics, nothing to do for other
> +	 * (discrete) cards.
> +	 */
> +	if (resource_size(&intel_graphics_stolen_res))
> +		return;
> +
>  	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
>  	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
> @@ -703,7 +710,7 @@ static struct chipset early_qrk[] __initdata = {
>  	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
>  	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
> -	  QFLAG_APPLY_ONCE, intel_graphics_quirks },
> +	  0, intel_graphics_quirks },
>  	/*
>  	 * HPET on the current version of the Baytrail platform has accuracy
>  	 * problems: it will halt in deep idle state - so we disable it.
> ------8<------

This looks even cleaner to me but that's Bjorn's call in the end.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
