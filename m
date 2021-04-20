Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFCE36615E
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 23:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhDTVGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 17:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhDTVGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 17:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8625613F6;
        Tue, 20 Apr 2021 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618952771;
        bh=vOBjMXDIMy+zl5MUYC7gubauHlSjbGUB4gjxD3PRR4w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WCbA9z/sUtYyNFYkHNIbegCci/4MG80OK4i2ZdilHi2K7d/7rNRAm8jmCFHyJWKGm
         U72l3htjsoHbW3hNDgZ9/f2GIO4Xcwg+Y1L/3yhBwJotu40fXkgH3qoqTKN+elXDK8
         U0PFVhvNHE+5tzABJ13x/XZYq7DYm7SE0gQVaYMxUYderYXFS0S/kLUty5TBQq6+Y6
         uaHFCB5tFkeJiWpmu0o/7QRltSIqmPkGwE1SCMIWyY82Kspt6EcoeSkxDRvWrhh3pM
         j0i0ofaG6SH03WbxxoZ5qiO2oQ+vy+ADpqVHlkMhM3npUqMCATOz9ar3aA1kU8HDVN
         OYywxOveuLrNw==
Received: by mail-qt1-f174.google.com with SMTP id o21so1672150qtp.7;
        Tue, 20 Apr 2021 14:06:11 -0700 (PDT)
X-Gm-Message-State: AOAM5338ckF7RAmuCQDakMyscwdbQLJKLhX+bXZToHIzCfut2aLa20R4
        hPoZzgydR9YsdH3AvHMZeLdW3rUBrNhgae6X5g==
X-Google-Smtp-Source: ABdhPJxR9Cm98ABiNFPyOMwL9/iq5rv9dvatoXQvyvDC+TMZuJah1HmSklQQc0ojSXRVxRBRPB7UTYPe9/P0MUR0Jvs=
X-Received: by 2002:ac8:5d52:: with SMTP id g18mr19266258qtx.380.1618952770704;
 Tue, 20 Apr 2021 14:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com> <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
In-Reply-To: <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Apr 2021 16:05:59 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJVUq2D9B5SwNc6VFOQFS_Qkry4ATwTYGRJE6qkpaFM+A@mail.gmail.com>
Message-ID: <CAL_JsqJVUq2D9B5SwNc6VFOQFS_Qkry4ATwTYGRJE6qkpaFM+A@mail.gmail.com>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 11:10 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 20 Apr 2021 at 17:54, Rob Herring <robh+dt@kernel.org> wrote:
> >
> > On Tue, Apr 20, 2021 at 10:12 AM Alexandre TORGUE
> > <alexandre.torgue@foss.st.com> wrote:
> > >
> > >
> > >
> > > On 4/20/21 4:45 PM, Rob Herring wrote:
> > > > On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
> > > > <alexandre.torgue@foss.st.com> wrote:
> > > >>
> > > >> Hi,
> > > >
> > > > Greg or Sasha won't know what to do with this. Not sure who follows
> > > > the stable list either. Quentin sent the patch, but is not the author.
> > > > Given the patch in question is about consistency between EFI memory
> > > > map boot and DT memory map boot, copying EFI knowledgeable folks would
> > > > help (Ard B for starters).
> > >
> > > Ok thanks for the tips. I add Ard in the loop.
> >
> > Sigh. If it was only Ard I was suggesting I would have done that
> > myself. Now everyone on the patch in question and relevant lists are
> > Cc'ed.
> >
>
> Thanks for the cc.
>
> > >
> > > Ard, let me know if other people have to be directly added or if I have
> > > to resend to another mailing list.
> > >
> > > thanks
> > > alex
> > >
> > > >
> > > >>
> > > >> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
> > > >> reserved-memory regions are no more "reserved" and make part of the
> > > >> kernel System RAM. This causes allocation failure for devices which try
> > > >> to take a reserved-memory region.
> > > >>
> > > >> It has been introduced by the following path:
> > > >>
> > > >> "fdt: Properly handle "no-map" field in the memory region
> > > >> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
> > > >> which replace memblock_remove by memblock_mark_nomap in no-map case.
> > > >>
>
> Why was this backported? It doesn't look like a bugfix to me.

Probably because of commit 8a5a75e5e9e5 ("of/fdt: Make sure no-map
does not remove already reserved regions") which was in the same
series.

'Properly handle' implies before it was 'improperly handled', so
sounds like a fix.

Rob
