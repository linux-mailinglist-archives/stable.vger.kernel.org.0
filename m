Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF86B39E01B
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFGPUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 11:20:38 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44664 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFGPUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 11:20:38 -0400
Received: from zn.tnic (p200300ec2f0b4f0010db370b6947fb68.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:4f00:10db:370b:6947:fb68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A2A6C1EC04CC;
        Mon,  7 Jun 2021 17:18:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623079125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ObAWYiNw/8+B9oIVqAJA/NZsNYIbjY5dG2+jmOLKwiU=;
        b=fPeDa61E+opxHRpiJBZvYmj0X7rKyD8PmnsF70je/x4d9FwQyRJ7OR9HFxvyDuFh7/8aUN
        XzvBtVEl06yriKr/iBWu2+uAZxI7w1y726RflMnDhVvkfVGtOfzCVlNTr1m+SiMfVb5N/E
        bLbd02ZKso0AQGMEiVw0MDkizCLctfQ=
Date:   Mon, 7 Jun 2021 17:18:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: Re: [patch V2 04/14] x86/pkru: Make the fpinit state update work
Message-ID: <YL44d9YtVJx4xS2t@zn.tnic>
References: <20210605234742.712464974@linutronix.de>
 <20210606001323.322361712@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210606001323.322361712@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 06, 2021 at 01:47:46AM +0200, Thomas Gleixner wrote:
> @@ -120,6 +121,8 @@ void __init check_bugs(void)
>  
>  	arch_smt_update();
>  
> +	pkru_propagate_default();

I guess this fits better at the end of identify_boot_cpu(), which is
pretty close to here, in the boot order.

Regardless, that function check_bugs() needs cleaning up as it has
collected a lot more stuff than just checking the bugs nasty.

> +void pkru_propagate_default(void)
>  {
> -	u32 init_pkru_value_snapshot = READ_ONCE(init_pkru_value);
> +	struct pkru_state *pk;
> +
> +	if (!boot_cpu_has(X86_FEATURE_OSPKE))

cpu_feature_enabled()

> +		return;
>  	/*
> -	 * Override the PKRU state that came from 'init_fpstate'
> -	 * with the baseline from the process.
> +	 * Force XFEATURE_PKRU to be set in the header otherwise
> +	 * get_xsave_addr() does not work and it needs to be set
> +	 * to make XRSTOR(S) load it.
>  	 */
> -	write_pkru(init_pkru_value_snapshot);
> +	init_fpstate.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
> +	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
> +	pk->pkru = READ_ONCE(init_pkru_value);
>  }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
