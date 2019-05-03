Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23CF133E2
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 21:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfECTH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 15:07:59 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53526 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfECTH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 15:07:59 -0400
Received: from zn.tnic (p200300EC2F0CA900690D0772EBB26CCB.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:a900:690d:772:ebb2:6ccb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9E1451EC0229;
        Fri,  3 May 2019 21:07:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1556910477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XutbePJmEyY+rMx/pqoWxifl49Lqa5PJBKT9Bib1YJQ=;
        b=grk3ComRhG06ysNX2boEsej/IIRU/G5eipWbS5KucHxukGY4bGeH4C6uSedqZzbiTB/SZ1
        HcId82fWyDgKEATRDkt2WGHQJ+RJXsgHXm12JCTUlLhQ5fTu4dXEm+9MP+rYhbHrq5rkKV
        YBRqK1FmEWC85tyrILCuwHafLHVX1Ls=
Date:   Fri, 3 May 2019 21:07:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20190503190751.GG5020@zn.tnic>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <CALCETrWTCB9xLVdKCODghpeQpJ_3Rz3OwE8FB+5hjYXMYwYPLg@mail.gmail.com>
 <20190502165520.GC6565@zn.tnic>
 <bcb6c893-61e6-4b08-5b40-b1b2e24f495b@redhat.com>
 <20190503180739.GF5020@zn.tnic>
 <5BD87ACE-1200-4612-AA83-1590DA9E45E5@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5BD87ACE-1200-4612-AA83-1590DA9E45E5@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 11:54:54AM -0700, Andy Lutomirski wrote:
> I don’t think I or has said we should try to make these interfaces
> immutable.

How else would you have a stable interface for OOT modules? If at all,
that is.

> What I’m saying is that, since we’re exporting the symbol anyway
> and it’s not particularly Linuxy, that we shouldn’t say that only
> *GPL* out-of-tree modules may use it. It seems like anyone who wants
> to put the effort into tracking which kernel has which symbols and is
> willing to accept the utter instability of the interface may use it.

This is just silly: when we change it next time, it'll be the same
crying again. No, we don't want to do that. This keeps happening with
all kinds of symbols being exported and unexported.

> So if we ever unexport the symbol entirely, I won’t object.

Yah, and you'll break them again. That's just unnecesary pain each time.

> I object to what I consider to be the inappropriate claim that it’s
> a *GPL* export.

Yes, that is the problem. Jiri alluded to it too - I don't think it is
clear to people involved - me included - what exports should be done and
how. And what assurances - if any - we're giving.

> (I actually hope we unexport it once simd_get() and friends land —
> they’re a much better API, and we should migrate over to it.)

Same problem as above with those.

That's why we need some sort of an explicit ruling all sides will adhere
to.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
