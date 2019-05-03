Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C711337D
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfECSHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 14:07:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45632 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfECSHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 14:07:46 -0400
Received: from zn.tnic (p200300EC2F0CA900ED4C00FAF1DC8C17.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:a900:ed4c:fa:f1dc:8c17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 92EBC1EC021C;
        Fri,  3 May 2019 20:07:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1556906864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FwwKpD3uSNoOFlcgjRaZh20WCk4wqtxh0zC+plzB4pw=;
        b=Cu4XJd4jGrp29+kEqnr+REiJv1Qd2B9YZMGQL2UaFxWfI5ulSgsbHfRtch5FWltjic14iM
        R1Aqhme6bHXuDEYP8AfIF2vhjUwFB6QII+qppOmUF8cnxd8Hu7CHr4jVy1M3jyIdIfNKpK
        HCMtvVT2Bgvrj+idGuaMF3C0kVTpAIA=
Date:   Fri, 3 May 2019 20:07:39 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190503180739.GF5020@zn.tnic>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
 <20190502165520.GC6565@zn.tnic>
 <bcb6c893-61e6-4b08-5b40-b1b2e24f495b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bcb6c893-61e6-4b08-5b40-b1b2e24f495b@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 11:21:15AM -0600, Paolo Bonzini wrote:
> Your observation that the API only exists on x86 and s390 has no bearing
> to whether the functions should be EXPORT_SYMBOL_GPL or EXPORT_SYMBOL.
> ARM has kernel_neon_begin/end, PPC has enable/disable_kernel_altivec.
> It's just that SIMD code is so arch-specific that nobody has bothered
> unifying the namings (or, nobody considers the different names a problem
> at all).

This is actually proving my point: there wasn't any real agreement on
what interfaces should be immutable so that out-of-tree code can use
them and us guaranteeing they won't change. Instead, it was a random
thing that just happened.

So if you have to use them in some out-of-tree module, you'd have to
do arch-specific hackery, obviously, because each arch does different
things.

So what happened is that out-of-tree module simply grabbed them and now
when we change our implementation, we broke it. And I care about this
why exactly?

So let me cut to the chase: you and Andy are arguing about what exactly?

* We should support out-of-tree code in general?

* We should support out-of-tree code if/when <fill in the specifics which
out-of-tree code should be supported by Linux and which not>?

* We should be free to change kernel interfaces and implementation as
we see fit, without paying attention to some out-of-tree, probably
license-incompatible, maybe even proprietary code? (I don't think it is
that, though).

* Something else I've missed.

So before we waste any more time with this, let's agree on the rules
first: do we support out-of-tree code and if so, how much and to what
degree?

This keeps happening so I think we should write it all down so that it
is crystal clear to all parties involved what can and cannot be done.
And then when we all agree, we can enforce those rules and then act
accordingly when changing implementations.

Maybe it is written down somewhere but I haven't found it yet so if you
do, pls point me to it.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
