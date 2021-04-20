Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F31365CAF
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhDTPzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 11:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232303AbhDTPzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 11:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B923A613C3;
        Tue, 20 Apr 2021 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618934089;
        bh=KZq5/wRY4YGDVOPORw3nU8SC0AVzsWcVeDZv4TcVeDY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gqqC/lZMF78AIjK+lsYvmr4WeYe5ZzfxljlcTDFpJPdmD/iMCurTItPSMmY8qH3St
         LFMHXEd4bj9GBcX5akpIBLRU6sBCgmxrZgwmml38S2BadsFjKZrmvo5OeJkRcdd/c+
         a09cKwfoZT3RRWka6JkQUZalxHE1agf30nepJCsyc4HjP7K5MvgAFrRVM/4D3uRqKu
         0s6Y789OfQCvviSpha1bC93pp+yLuAT5oy2Y31IQxryQ6WQfvlBQ0OiDEHwjtRoYsy
         tF/d+Mt71HhkqbgPmI0mhMPnmcQnOMd/up7jkZiR5EhGpWA3vX4WME9ZVzQqKPFTB/
         0OP/iZ4zkTfRA==
Received: by mail-ej1-f44.google.com with SMTP id sd23so50385088ejb.12;
        Tue, 20 Apr 2021 08:54:49 -0700 (PDT)
X-Gm-Message-State: AOAM531bxZH+F/u9WK+v0IPJRdE2AlIByI+N9g1XC4nw3LtkcsBypHsx
        Ry7ftzMpnHwRtcCxWCvD6+zWTcwUx2HybMUFWw==
X-Google-Smtp-Source: ABdhPJzp3lYZdPdNVLhuX/2phA/xrwQbMnDUOzFFLWg1gmLwSoM6HCDWBOhQ5OgOMvK39G8i6DxgWSIwuIi02EQ5Cwg=
X-Received: by 2002:a17:907:217b:: with SMTP id rl27mr28429006ejb.359.1618934088130;
 Tue, 20 Apr 2021 08:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com> <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
In-Reply-To: <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Apr 2021 10:54:36 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
Message-ID: <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org,
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

On Tue, Apr 20, 2021 at 10:12 AM Alexandre TORGUE
<alexandre.torgue@foss.st.com> wrote:
>
>
>
> On 4/20/21 4:45 PM, Rob Herring wrote:
> > On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
> > <alexandre.torgue@foss.st.com> wrote:
> >>
> >> Hi,
> >
> > Greg or Sasha won't know what to do with this. Not sure who follows
> > the stable list either. Quentin sent the patch, but is not the author.
> > Given the patch in question is about consistency between EFI memory
> > map boot and DT memory map boot, copying EFI knowledgeable folks would
> > help (Ard B for starters).
>
> Ok thanks for the tips. I add Ard in the loop.

Sigh. If it was only Ard I was suggesting I would have done that
myself. Now everyone on the patch in question and relevant lists are
Cc'ed.

>
> Ard, let me know if other people have to be directly added or if I have
> to resend to another mailing list.
>
> thanks
> alex
>
> >
> >>
> >> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
> >> reserved-memory regions are no more "reserved" and make part of the
> >> kernel System RAM. This causes allocation failure for devices which try
> >> to take a reserved-memory region.
> >>
> >> It has been introduced by the following path:
> >>
> >> "fdt: Properly handle "no-map" field in the memory region
> >> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
> >> which replace memblock_remove by memblock_mark_nomap in no-map case.
> >>
> >> Reverting this patch it's fine.
> >>
> >> I add part of my DT (something is maybe wrong inside):
> >>
> >> memory@c0000000 {
> >>          reg = <0xc0000000 0x20000000>;
> >> };
> >>
> >> reserved-memory {
> >>          #address-cells = <1>;
> >>          #size-cells = <1>;
> >>          ranges;
> >>
> >>          gpu_reserved: gpu@d4000000 {
> >>                  reg = <0xd4000000 0x4000000>;
> >>                  no-map;
> >>          };
> >> };
> >>
> >> Sorry if this issue has already been raised and discussed.
> >>
> >> Thanks
> >> alex
