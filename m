Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644CD2F62B7
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 15:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhANOIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 09:08:23 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58908 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbhANOIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 09:08:22 -0500
Received: from zn.tnic (p200300ec2f1aa9000d5c8ff8171504e8.dip0.t-ipconnect.de [IPv6:2003:ec:2f1a:a900:d5c:8ff8:1715:4e8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7237F1EC04F9;
        Thu, 14 Jan 2021 15:07:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610633261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=w853tYYUeVGIoj6sCsCDNuPQ7rgNkQpk7zDo4VYDixc=;
        b=l3+5ksPp7yPYG6tYsUIG/S3IE7yC9I8M7mqYbPAwOV9+HDR4cjz/mJbo0VQMziQzjmQ7Yy
        zO9JIPmDRaBh3xGIycUin3BmOa93pyIjWuWDdWdin6cY0Y7Wy32+197GTJScMR+xJPyjhU
        PbWApaZUIjb3Ig9oVauEYbhSsmmaZQ4=
Date:   Thu, 14 Jan 2021 15:07:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Krzysztof Mazur <krzysiek@podlesie.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210114140737.GD12284@zn.tnic>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net>
 <20210114094425.GA12284@zn.tnic>
 <20210114123657.GA6358@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114123657.GA6358@shrek.podlesie.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 01:36:57PM +0100, Krzysztof Mazur wrote:
> The OSFXSR must be set only on CPUs with SSE. There
> are some CPUs with 3DNow!, but without SSE and FXSR (like AMD
> Geode LX, which is still used in many embedded systems).
> So, I've changed that to:
> 
> if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
> 		unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))

Why?

X86_CR4_OSFXSR won't ever be set on those CPUs but the test will be
performed anyway. So there's no need for boot_cpu_has().

> However, except for some embedded systems, probably almost nobody uses
> that code today, and the most imporant is avoiding future breakage.

Yes, exactly. K7 is a don't-care performance-wise nowadays.

> And I'm not sure which approach is better. Because that CR4 test tests
> for a feature that is not used in mmx_memcpy(), but it's used in
> kernel_fpu_begin(). And in future kernel_fpu_begin() may change and
> require also other stuff. So I think that the best approach would be
> delay any FPU optimized memcpy() after fpu__init_system() is executed.

I'd prefer the simplest approach as this code is almost never used. So
no need to complicate things unnecessarily.

> Subject: [PATCH] x86/lib: don't use mmx_memcpy() to early

s/to/too/

> The MMX 3DNow! optimized memcpy() is used very early,
> even before FPU is initialized in the kernel. It worked fine, but commit
> 7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
> to default in kernel_fpu_begin()") broke that. After that
> commit the kernel_fpu_begin() assumes that FXSR is enabled in
> the CR4 register on all processors with SSE. Because memcpy() is used
> before FXSR is enabled, the kernel crashes just after "Booting the kernel."
> message. It affects all kernels with CONFIG_X86_USE_3DNOW (enabled when
> some AMD/Cyrix processors are selected) on processors with SSE
> (like AMD K7, which supports both MMX 3DNow! and SSE).
> 

Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")

...

Thx. 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
