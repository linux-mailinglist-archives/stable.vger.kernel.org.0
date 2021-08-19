Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF8C3F1699
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhHSJuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhHSJuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 05:50:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DDEC061575;
        Thu, 19 Aug 2021 02:49:25 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a9so7770457ybr.5;
        Thu, 19 Aug 2021 02:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=baqn3nFJ4OCTZu2mfJfEIksHZD7gejF7HwEVWCcEoaQ=;
        b=X2xgmIDbeZp2Ko+ImEdETlccj2ISP/5yZyWVeEyyC8OZGhekNYG0ut5Vh3rGFyfYQa
         +vO7O1JJx06Yk9j173yO72pZXd06vbqAPCGzPssRgjTqIMvY5kn45zdttUsWTZjBD5O/
         kyYzC0Op2LAQ2xwaFeOmvIKD1TRVaohPIcWTJBx73Su8V609yIcxQSr5ktow/HUEeel8
         hxHKEAyyM3OZvKOIYHuXgFaEO3AUHMzvGEMJQdL7e1LJaVUm51o4L+vFvzUkVmJw9XP/
         d+VtaPaljEyDiVPyQQNRPdK2A8PFiY5PzvbMTeu0F1gG/4cg7T3dMqHvshTsHcNUAx9G
         dRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=baqn3nFJ4OCTZu2mfJfEIksHZD7gejF7HwEVWCcEoaQ=;
        b=l64MoKVzpjhbp1O8qbzsRfHdxFubkv6WM1DUlHRNJRtXHTyjnFj4GO2bGS0++Mr28Q
         pfFtNsN4RjslI5EWwcwrL2OPtuOKg9HyY2UZix2nmjReS1o+JkWLM6RFGXg/XC4oHz75
         uMLpOTjBa+w1KzL0NrUSvLVdsUIaI7DpjKWV6wBXBwWVzJ8YUsCLfuFMdVolMe/p1uZ3
         PFMZfiZyqaLVhVUTSHv5sP4Ie3tjiCjSlO+KS//bQGfl55K6RFhxnmiLicJJc4AsmbR+
         x1CW+xS7uHeLNdbjJrCUqf5Aht4HmcxYZQC8Mu5XrJbvCnf0ndI+iCz8UBApeG0lvtXQ
         3N9Q==
X-Gm-Message-State: AOAM532ESXNV9Qzp6DRDiuF6QMQ9XA9VIQbPdq9d53VFE4u1+tq8N58d
        pKoNnjUo5wMnd+0s5f/RllVlWp262xzJh5UKg4Y=
X-Google-Smtp-Source: ABdhPJyvT3ptpUVFYprs2pXgbIQba2dfM+Mw9N3mgrKFKcuQJ7PSyA/LCEE8nGZkk6PYfyVA1GcRstI/+e3gEonQqvw=
X-Received: by 2002:a25:3046:: with SMTP id w67mr17605524ybw.134.1629366564492;
 Thu, 19 Aug 2021 02:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
 <20210819093226.13955-2-lukas.bulwahn@gmail.com> <475fa73c-5eef-a60c-c70f-9f6ea7a079d8@csgroup.eu>
In-Reply-To: <475fa73c-5eef-a60c-c70f-9f6ea7a079d8@csgroup.eu>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Thu, 19 Aug 2021 11:49:20 +0200
Message-ID: <CAKXUXMww0jcqdonHLdajQaPRR2Ru6OVMFd+99r55XUEin6Nv=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc: kvm: rectify selection to PPC_DAWR
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 11:45 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 19/08/2021 =C3=A0 11:32, Lukas Bulwahn a =C3=A9crit :
> > Commit a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
> > selects the non-existing config PPC_DAWR_FORCE_ENABLE for config
> > KVM_BOOK3S_64_HANDLER. As this commit also introduces a config PPC_DAWR=
,
> > it probably intends to select PPC_DAWR instead.
> >
> > Rectify the selection in config KVM_BOOK3S_64_HANDLER to PPC_DAWR.
> >
> > The issue was identified with ./scripts/checkkconfigsymbols.py.
> >
> > Fixes: a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> >   arch/powerpc/kvm/Kconfig | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> > index e45644657d49..aa29ea56c80a 100644
> > --- a/arch/powerpc/kvm/Kconfig
> > +++ b/arch/powerpc/kvm/Kconfig
> > @@ -38,7 +38,7 @@ config KVM_BOOK3S_32_HANDLER
> >   config KVM_BOOK3S_64_HANDLER
> >       bool
> >       select KVM_BOOK3S_HANDLER
> > -     select PPC_DAWR_FORCE_ENABLE
> > +     select PPC_DAWR
>
> That's useless, see https://elixir.bootlin.com/linux/v5.14-rc6/source/arc=
h/powerpc/Kconfig#L267
>
> In arch/powerpc/Kconfig, you already have:
>
>         select PPC_DAWR                         if PPC64
>

Ah, I see. Then, it is just a needless and non-effective select here,
and then select can be deleted completely.

I will send a patch series v2.

Lukas
