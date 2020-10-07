Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB2286514
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgJGQpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 12:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgJGQpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 12:45:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71777C0613D3;
        Wed,  7 Oct 2020 09:45:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f09100045b18ec36a87abe5.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1000:45b1:8ec3:6a87:abe5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D41C31EC047F;
        Wed,  7 Oct 2020 18:45:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1602089139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BpY6gUKTWzEYkINvPSqqI2YsulivByStbap9m27bho0=;
        b=DtbuS8j81k051ez/MeZ30OZV4HPt1B5e3K/LX42yWJ5KOa6yuHNUzl4tm6S0P/65/P+r0s
        1QizNIFhYK9QzYusw+89q8yyHi4OtJHvxWN1pu6+q/7gcLbiFpxaMc1uLM3Mnc9+5nLlrD
        mYk1wBhRT2tPYhmpII1Cf/5VJSjDbvU=
Date:   Wed, 7 Oct 2020 18:45:36 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-tip-commits@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201007164536.GJ5607@zn.tnic>
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007111447.GA23257@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 01:14:47PM +0200, Borislav Petkov wrote:
> On Tue, Oct 06, 2020 at 09:57:09AM -0000, tip-bot2 for Dan Williams wrote:
> > +	/* Copy successful. Return zero */
> > +.L_done_memcpy_trap:
> > +	xorl %eax, %eax
> > +.L_done:
> > +	ret
> > +SYM_FUNC_END(copy_mc_fragile)
> > +EXPORT_SYMBOL_GPL(copy_mc_fragile)
> 
> That export together with CONFIG_MODVERSIONS causes
> 
> WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version generation failed, symbol will not be versioned.
> 
> here.
> 
> I don't see why tho...

It doesn't look like it is toolchain-specific and in both cases,
copy_mc_fragile's checksum is 0.

SUSE Leap 15.1:

Name           : binutils                                        
Version        : 2.32-lp151.3.6.1

$ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL

debian testing:

Package: binutils
Version: 2.35-2

$ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers 
0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
