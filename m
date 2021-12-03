Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEC4467D08
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382462AbhLCSRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 13:17:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36536 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbhLCSRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 13:17:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFB9262C80;
        Fri,  3 Dec 2021 18:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1010DC53FAD;
        Fri,  3 Dec 2021 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638555228;
        bh=E90SW7IezprzON0XL09cv7YjYR918uAvsP1m3+lB75U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mUZBFxgDYgPpfatw21IfMbBLSAWSrGYfF4nrh3zsDvHkmLW8kIW0V44NIuaJ9ZHk4
         PcCp570Minqx39sXU+ffHYl/rBlXmH9m0CigeeKsdTUqbnTWcGDP8SniUbxow5jfJH
         Ra6wfVQQmaQvo1hWkKm9fsDOqNGaJHfzchiYj8VPuFVgDVJO0EWkF+XR+RRs0FNBmF
         SnGnVrYqrgm5ktlPUZAbLUrDWFdxPXmKKWDsp3PqF341ayJ0aN7egKSOzGVp+s+Y7X
         RwaxX+KXMvlnQhqdb9FAW699sV1t2iyQK2krFDitQNV4ZxD+AVPQQUCtXAquVAFVCq
         ymkFmido93uNg==
Received: by mail-oi1-f179.google.com with SMTP id u74so7311155oie.8;
        Fri, 03 Dec 2021 10:13:48 -0800 (PST)
X-Gm-Message-State: AOAM5335VRoyx7NRtTBGlR9ktA16RFXvXtHgCOkqDCUFGeWjJp4eDWep
        x7pninEX7YYS5bEBtSc8efZmFtjRuNK+G0wllCw=
X-Google-Smtp-Source: ABdhPJwqDfN3YlV4nM2a1pe/9ZpwcgcOtGI/Dw4iZR82jtHqY0rmw12khrU6X6Kt61PNKhsOnkINyfsWJ9tYXwSAG7Y=
X-Received: by 2002:a05:6808:12:: with SMTP id u18mr11260456oic.174.1638555227284;
 Fri, 03 Dec 2021 10:13:47 -0800 (PST)
MIME-Version: 1.0
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com> <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic> <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
 <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com> <15ceb556-0b56-2833-206e-0cf9b9d2cb45@amd.com>
 <CAMj1kXHKxObuebZJMWQQwg014rYzvoBgWPZxfCYakuf+GSoqhg@mail.gmail.com> <6d6b4982-ce69-4fd4-1bb8-5c35b360a95f@amd.com>
In-Reply-To: <6d6b4982-ce69-4fd4-1bb8-5c35b360a95f@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Dec 2021 19:13:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFkL8AkgE431CJWsD2T7uXh5PiR44iXLBKfTQQuDuNbyg@mail.gmail.com>
Message-ID: <CAMj1kXFkL8AkgE431CJWsD2T7uXh5PiR44iXLBKfTQQuDuNbyg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Dec 2021 at 17:22, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 12/3/21 4:30 AM, Ard Biesheuvel wrote:
> > On Wed, 1 Dec 2021 at 15:06, Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>
> >> On 10/27/21 12:04 PM, Tom Lendacky wrote:
> >>>
> >>>
> >>> On 10/27/21 11:59 AM, Ard Biesheuvel wrote:
> >>>> On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
> >>>>>
> >>>>> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
> >>>>>> I could take it, but since it will ultimately go through -tip anyway,
> >>>>>> perhaps better if they just take it directly? (This will change after
> >>>>>> the next -rc1 though)
> >>>>>>
> >>>>>> Boris?
> >>>>>
> >>>>> Yeah, I'm being told this is not urgent enough to rush in now so you
> >>>>> could queue it into your fixes branch for 5.16 once -rc1 is out and send
> >>>>> it to Linus then. The stable tag is just so it gets backported to the
> >>>>> respective trees.
> >>>>>
> >>>>> But if you prefer I should take it, then I can queue it after -rc1.
> >>>>> It'll boil down to the same thing though.
> >>>>>
> >>>>
> >>>> No, in that case, I can take it myself.
> >>>>
> >>>> Tom, does that work for you?
> >>>
> >>> Yup, that works for me. Thanks guys!
> >>
> >> I don't see this in any tree yet, so just a gentle reminder in case it
> >> dropped off the radar.
> >>
> >
> > Apologies for the delay, I've pushed this out to -next now.
> >
> > Before I send it to Linus, can you please confirm (for my peace of
> > mind) how this only affects systems that have memory encryption
> > available and enabled in the first place?
>
> Certainly.
>
> An early_memremap() call uses the FIXMAP_PAGE_NORMAL protection value for
> performing the mapping. Prior to performing the actual mapping though, a
> call to early_memremap_pgprot_adjust() is made to possibly alter the
> protection value, but only if memory encryption is active.
>
> Changing the call to early_memremap_prot() and providing
> pgprot_encrypted(FIXMAP_PAGE_NORMAL) as the protection value results in an
> equivalent call to early_memremap() when memory encryption is not active.
> This is because the pgprot_encrypted() is, in effect, a NOP when memory
> encryption is not active.
>
> So when memory encryption is not available or active, the result of an
> early_memremap_prot() call with a protection value of
> pgprot_encrypted(FIXMAP_PAGE_NORMAL) is equivalent to an early_memremap()
> call.
>
> Let me know if that answers your question.
>

It does, thanks.
