Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526A1365CEA
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 18:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhDTQLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 12:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhDTQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 12:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511F2613CA;
        Tue, 20 Apr 2021 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618935039;
        bh=JmvIBFjNFzY+Tbh/Rvhur6HjvhdR6YOR20xkk+tupLA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mo7Wq1Qo5/LMo+zGtDwSIGtakFBsrF4XZG0VFBhIfYWH2wSEc4Uqd6FtUKg8nMufW
         uonku8qX1V8WQXtLJIUtEEutxqewkPDlPLE8MPojwm6WiVjFo0L03jXrj8BSnFbrAj
         Kpplxep9BKuMpk6jp92VaVX3f49oTmqtV04ahy1ceyf0NGQmEleZWFf0mCEv+1Cgpz
         IlunToNhctxWLMe1YMtQAG9SDrGxk/rEHY+8bLnPBv3329Luadc3s+MCccmq7MS/uW
         7CwyuCUamZxp/8eyBs7XnV8TFqnCuJJL4uHFiD4qwSJXG5cbQBG8xNb3rPC3DD5LCB
         hnElrtFD/CLWQ==
Received: by mail-ot1-f52.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso13779691otl.0;
        Tue, 20 Apr 2021 09:10:39 -0700 (PDT)
X-Gm-Message-State: AOAM533Iz5xgC5543nnOSXejPtGikZA5djLWGgRy3SSzS8Mgwmf8qBVe
        m5eKrCDbXc10Hh6ZPNY9P/5kFGJMqfHB1JwvHcw=
X-Google-Smtp-Source: ABdhPJwJYzzV7y6P8YWEeQcFAUMKTStDy/CzVY5/ZIb5abLOvYetwnEASw2bBgIIB8EPcE2oeWurf5DhK/lCN3R/+mQ=
X-Received: by 2002:a9d:311:: with SMTP id 17mr1508765otv.77.1618935038443;
 Tue, 20 Apr 2021 09:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com> <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
In-Reply-To: <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 20 Apr 2021 18:10:27 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
Message-ID: <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Rob Herring <robh+dt@kernel.org>
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

On Tue, 20 Apr 2021 at 17:54, Rob Herring <robh+dt@kernel.org> wrote:
>
> On Tue, Apr 20, 2021 at 10:12 AM Alexandre TORGUE
> <alexandre.torgue@foss.st.com> wrote:
> >
> >
> >
> > On 4/20/21 4:45 PM, Rob Herring wrote:
> > > On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
> > > <alexandre.torgue@foss.st.com> wrote:
> > >>
> > >> Hi,
> > >
> > > Greg or Sasha won't know what to do with this. Not sure who follows
> > > the stable list either. Quentin sent the patch, but is not the author.
> > > Given the patch in question is about consistency between EFI memory
> > > map boot and DT memory map boot, copying EFI knowledgeable folks would
> > > help (Ard B for starters).
> >
> > Ok thanks for the tips. I add Ard in the loop.
>
> Sigh. If it was only Ard I was suggesting I would have done that
> myself. Now everyone on the patch in question and relevant lists are
> Cc'ed.
>

Thanks for the cc.

> >
> > Ard, let me know if other people have to be directly added or if I have
> > to resend to another mailing list.
> >
> > thanks
> > alex
> >
> > >
> > >>
> > >> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
> > >> reserved-memory regions are no more "reserved" and make part of the
> > >> kernel System RAM. This causes allocation failure for devices which try
> > >> to take a reserved-memory region.
> > >>
> > >> It has been introduced by the following path:
> > >>
> > >> "fdt: Properly handle "no-map" field in the memory region
> > >> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
> > >> which replace memblock_remove by memblock_mark_nomap in no-map case.
> > >>

Why was this backported? It doesn't look like a bugfix to me.

> > >> Reverting this patch it's fine.
> > >>
> > >> I add part of my DT (something is maybe wrong inside):
> > >>
> > >> memory@c0000000 {
> > >>          reg = <0xc0000000 0x20000000>;
> > >> };
> > >>
> > >> reserved-memory {
> > >>          #address-cells = <1>;
> > >>          #size-cells = <1>;
> > >>          ranges;
> > >>
> > >>          gpu_reserved: gpu@d4000000 {
> > >>                  reg = <0xd4000000 0x4000000>;
> > >>                  no-map;
> > >>          };
> > >> };
> > >>
> > >> Sorry if this issue has already been raised and discussed.
> > >>

Could you explain why it fails? The region is clearly part of system
memory, and tagged as no-map, so the patch in itself is not
unreasonable. However, we obviously have code that relies on how the
region is represented in /proc/iomem, so it would be helpful to get
some insight into why this is the case.

In any case, the mere fact that this causes a regression should be
sufficient justification to revert/withdraw it from v5.4, as I don't
see a reason why it was merged there in the first place. (It has no
fixes tag or cc:stable)
