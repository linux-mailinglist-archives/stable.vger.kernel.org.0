Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23652F5DFF
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbhANJpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbhANJpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 04:45:04 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB5C061786;
        Thu, 14 Jan 2021 01:44:32 -0800 (PST)
Received: from zn.tnic (p200300ec2f1aa900dc6a18505a7e3253.dip0.t-ipconnect.de [IPv6:2003:ec:2f1a:a900:dc6a:1850:5a7e:3253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7A7F21EC04DF;
        Thu, 14 Jan 2021 10:44:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610617470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IhJhyfTFkRRRrVajxJ0ZNRUtaSQG9x8tTIZfVOZztUo=;
        b=br7TELCX+sXIAs1Jycl3nIAzl91fQdlpyN9jlfBixlJZU4vs7lALUUoG/tH7DXmS1zMGLp
        vO+NWgXDjnOHUlER23dm9wD9/4UVvrP7x3CRD2Vg/oCb/72r3vONZaM+gpefYJeyrc9Ej0
        HYSlMJC+/t6cgATWMarOQBvABgCHRY8=
Date:   Thu, 14 Jan 2021 10:44:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Krzysztof Mazur <krzysiek@podlesie.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210114094425.GA12284@zn.tnic>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114092218.GA26786@shrek.podlesie.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 10:22:18AM +0100, Krzysztof Mazur wrote:
> So, I'm guessing that the K7 does not like ldmxcsr(), when FXSR
> or/and XMM are not enabled in CR4 (in fpu__init_cpu_generic()).
> I verified that by adding kernel_fpu_begin()+kernel_fpu_end()
> pair, before and after cr4_set_bits() in fpu__init_cpu_generic()
> (on a kernel with disabled early MMX-optimized memcpy).

Ah, ok, that makes sense. If X86_CR4_OSFXSR is not set, we cannot use
legacy SSE1 insns and LDMXCSR is one of them.

I believe the correct fix should be

	if (unlikely(in_interrupt()) || !(cr4_read_shadow() & X86_CR4_OSFXSR))
		return __memcpy(to, from, len);

in _mmx_memcpy() as you had it in your first patch.

Wanna try it and if it works, send a proper patch?

Also pls put a comment above it that that CR4 bit needs to be tested
before using SSE insns.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
