Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3F285DF6
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 13:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJGLO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 07:14:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48126 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgJGLO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 07:14:57 -0400
Received: from zn.tnic (p200300ec2f0910001a6e2c50840325bb.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1000:1a6e:2c50:8403:25bb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7BB7C1EC02FE;
        Wed,  7 Oct 2020 13:14:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1602069295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/xdW026KNaPmQBeTtUGM1jrwnoKelUBoR6snamoe8Mk=;
        b=WWR0azw394/bqAfeM1QrKKywuY6FL8sncnKP1c6Jsy5/nV4FI64e9Ce6bTymObhhMZSTJQ
        tY2/cXohj+igNLltUej9VZdet2ls3fKldavRyghQGERuOC+jrL87pXVPuy/GFK8mfRbawv
        1xVyypk7BuK0y9yahzf8ZmdDV9MEfpk=
Date:   Wed, 7 Oct 2020 13:14:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-tip-commits@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201007111447.GA23257@zn.tnic>
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 09:57:09AM -0000, tip-bot2 for Dan Williams wrote:
> +	/* Copy successful. Return zero */
> +.L_done_memcpy_trap:
> +	xorl %eax, %eax
> +.L_done:
> +	ret
> +SYM_FUNC_END(copy_mc_fragile)
> +EXPORT_SYMBOL_GPL(copy_mc_fragile)

That export together with CONFIG_MODVERSIONS causes

WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version generation failed, symbol will not be versioned.

here.

I don't see why tho...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
