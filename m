Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74020F0E00
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 05:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfKFE4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 23:56:32 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34819 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730528AbfKFE4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 23:56:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id z6so19773414otb.2
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 20:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNl0SHnN7vD9n+DBD3M8lM/x0tJoz22JKGDM/y74qf8=;
        b=Zom8xELa0Q+363dyeYAqesoajRTgp/nD4/uxdv/iRaS6YU4ddRMvwi26Z8/kT7jtYa
         xbhpVKoOVQG0VouZni+vX05kxcTjKfgvjBpOfmj3msXSFy9cX5i+/AV8gjeleFse2lOQ
         ggQlJhRrNtRuiGvXmlL7rlf6rdDBH6qHwd7nu/vltlxO5gDN++uuC7ncRzS3dRp1ab33
         0rfFA/HrEwq/qoDlwqI3kM2yxnndPX6i9oZQskOOt6klV4DU6d/Mii55ojMlCTNUAPXG
         l4VgiOVRef26ZK5Gk9EF/z1j1b1O8sXSNtCzDLTmN5PwWIj5cEjDAYWz5AAVW74usoYr
         pR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNl0SHnN7vD9n+DBD3M8lM/x0tJoz22JKGDM/y74qf8=;
        b=gTijXBUnELIin6MugbclZOyiHokw0eM0JdhsgW51bMiBv8fu+jTqlQB7DWDTVp3lKp
         C8zygJy5oEUp4vgoz/6n5jazwf26MMblXVvnVSBblIHpdLqj7ZP4/W7shKOsIil+38wP
         LEnM0kRznJFoCGZfam5u3Di14l0q0enYGH1mtuo8qmYT32tETJM0fv0CJi5T0EO9vDMJ
         8CfFIAU+uwLkz8YpciJIy6GcoZKPS4O1nu7WjxqINlr6S0why3BLE+UiSflx8RnT1GLF
         yzwLITpTnYusCR3AobV65wmGsu+g+NpkwejvwcJTvzZVQrFTUNCRIvxuaNRkhtCOMfOL
         lnew==
X-Gm-Message-State: APjAAAWYC2OezFXOMl/c9uH80g/8BTSR25AJ41vOFRVp9H3xcnuf//Yi
        SdOnhN2I/asg+NREwGPLXnFAuUI7UKsoBwoJq9ja6cxNzyQ=
X-Google-Smtp-Source: APXvYqyNvGpKKTA/4tLkAPRJ4Kr8XYLx4zybvcrz0y/GfQqYUhXSfClJBJitO+bLoCY4+OvCDQlak++yvDdonPxG9MU=
X-Received: by 2002:a9d:630c:: with SMTP id q12mr346670otk.332.1573016190908;
 Tue, 05 Nov 2019 20:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
 <20191105102902.GB29852@willie-the-truck> <CALAqxLVT-SK0-nNUmbDWa3kkZED2z+pcryzuue9c=n42shu3kA@mail.gmail.com>
In-Reply-To: <CALAqxLVT-SK0-nNUmbDWa3kkZED2z+pcryzuue9c=n42shu3kA@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 5 Nov 2019 20:56:19 -0800
Message-ID: <CALAqxLVEGwA1bybiu+xfxsZRRTMTDmArCF0Ak1JbR55f-rwRtw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 9:06 AM John Stultz <john.stultz@linaro.org> wrote:
> On Tue, Nov 5, 2019 at 2:29 AM Will Deacon <will@kernel.org> wrote:
> >
> > Hi John,
> >
> > On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> > > On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > >
> > > > Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> > > > and made dirty on a subsequent write either through the hardware DBM
> > > > (dirty bit management) mechanism or through a write page fault. A clean
> > > > pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> > > > clear.
> > > >
> > > > The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> > > > PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> > > > bit handling out of set_pte_at()"), it was the responsibility of
> > > > set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> > > > software PTE_DIRTY bit was not set. However, the above commit removed
> > > > the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> > > > set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> > > > unchanged. The result is that shared+writable mappings are now dirty by
> > > > default
> > > >
> > > > Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> > > > In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> > > > attributes.
> > > >
> > > > Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> > > > Cc: <stable@vger.kernel.org> # 4.14.x-
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > >
> > > Hey,
> > >   So I'm not yet sure why, but I've just validated that this patch is
> > > causing trouble with booting AOSP on HiKey960 with 5.4-rc6 (-rc5 works
> > > fine).
> >
> > Hmm. Annoying this wasn't spotted by CI.
> >
> > > Its odd, because the system does boot and is alive, but seems to stall
> > > out at the boot animation, and userland never finishes coming up to
> > > the home screen. It just sits there without a useful error message
> > > that I can find so far.  Reverting just this patch seems to solve it
> > > and it boots all the way.
> >
> > Given that I don't think the HiKey960 supports h/w DBM, my initial guess
> > is that the GPU is stuck on a page fault.
> >
> > > I'll try to dig further to see what might be going on (the mali driver
> > > is a prime suspect here), but I wanted to raise the flag since we're
> > > at the end of the -rc cycle.
> >
> > What exactly are you using for the mali driver?
>
> I've got an old r10p0 bifrost blob we were given and kernel patches
> I've carried forward since then.
>
> Again, I don't want to distract you too much for something that may be
> related to a blob driver. I mostly just wanted to raise a flag in case
> there was something off that might affect others.

Just as a further detail (about to close up for the day), I'm also
seeing this issue on the HiKey board as well. Similarly reverting
747a70e60b72 resolves it.
Its a mali blob driver too, but a different one (utgard) which makes
me suspect this might be a real issue w/ something in AOSP.

I'll be testing on a db845c tomorrow morning to see if I can trigger
it there as well.

thanks
-john
