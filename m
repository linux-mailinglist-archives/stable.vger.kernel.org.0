Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800132F24E3
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404185AbhALAZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:23 -0500
Received: from mail.skyhub.de ([5.9.137.197]:56758 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404235AbhALAKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 19:10:09 -0500
Received: from zn.tnic (p200300ec2f088f0064dd88f751605e0c.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8f00:64dd:88f7:5160:5e0c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E011C1EC04CB;
        Tue, 12 Jan 2021 01:09:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610410168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hiQ2aT0sAgvveKCKw+n+ctbke87ZB3mfcJ48rJ15WaA=;
        b=NsLcVrbXvB8OcvgEN8y1ZJhIB4cKQy1qxYzOGUW0gOgqXZBZw9fhwTrH4s3Ab8Ys9vAmKC
        ETk1YqW4/5NjMpkALcoZxvI+YzsxaEQZiqLmXUYShLWlgItlAbAgGMRQrg9eU3i46ENf8L
        bkO8j99EZtA1GiOIuXGUs0+76MEHRJ4=
Date:   Tue, 12 Jan 2021 01:09:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Krzysztof Mazur <krzysiek@podlesie.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210112000923.GK25645@zn.tnic>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201228160631.32732-1-krzysiek@podlesie.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 05:06:31PM +0100, Krzysztof Mazur wrote:
> When enabled, the MMX 3DNow! optimized memcpy() is used very early,
> even before FPU is initialized. It worked fine, but commit
> 7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
> to default in kernel_fpu_begin()") broke that. After that commit
> the kernel crashes just after "Booting the kernel." message.

Have you figured out in the meantime what exactly is causing the
breakage?

Does it boot if you comment out

+       if (boot_cpu_has(X86_FEATURE_FPU))
+               asm volatile ("fninit");

in kernel_fpu_begin()?

I'm guessing K7 doesn't have X86_FEATURE_XMM so the LDMXCSR won't
matter...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
