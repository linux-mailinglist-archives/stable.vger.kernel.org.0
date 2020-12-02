Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E12CBADD
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 11:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbgLBKoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 05:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLBKop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 05:44:45 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0770C0613D4
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 02:43:59 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id b62so1211683otc.5
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 02:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9QLz5An3VwdrOS0On7n3zMhkM8iyrpXF4RrWtNNC2nQ=;
        b=YeNFvvcrLu+QyOFwERkqOiZyxAu2OSzJFeqVq2zqgsVJI47I/YyPZ3MGa48MADUGMw
         pU+0JUmXzMov/8DZCYY74Fuiu2JslaSSghEEYDihOK9IibYSVPbOPheHtRbMZawrlINy
         xaAB1LF3O3VGiRg5K09+3+E5OpeWlZ7kuTME7gcteIJ3SWPxb9RFui2xA3sg1+IZLmLw
         kta68kLjb+GNiJYBufU6WR7RVCXeveim0cNGaX5RZ5c4az4p8HDsxyDU9c0nejvRXKa2
         7hCq+/qA/63czc+7JxkICCvE3DRiNroliAh+GCR+I1A0qL48PNMs4AOy3rgzqiRBah1A
         yf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9QLz5An3VwdrOS0On7n3zMhkM8iyrpXF4RrWtNNC2nQ=;
        b=ia96RU9gGoUUpuednCXGhdo0/Psi+ST5wk9d8iUar8gp1TdsRv1wjQ+3ijJVnTtZXr
         4asOwRr2MvpIAasgpsT52VBYDL2+BKwUb/YDFPdUszPuK4gHOhpLj8+sCMNX8kBqOv9i
         MeeIIuydXvAJifNt/v6ThQ3N0Z/A439TINlXCQjHj2enpzhCoSNStSv6hgoG/pp8kEb3
         5ODxMyFoJRnxX3oUDOLgduIQPat2Tv3YjGScNEjoqSpXyQG3AKE8V+bvHxNDb9bSj5L1
         FYHz7s4b3/7PlQuvIsXnNT07CkPrIiZaEII2L4cQAxi/JqivGq+ZvKxTLgNHKHKUjelV
         jlOA==
X-Gm-Message-State: AOAM533sdNrowoQohjqQJry48eElCHHffAn7INc7mhx0uXa+5Y7m1/Jw
        94hHebbmeyAQsvLztDc0hgSbKvxEv8gj5cD6MTVZqw==
X-Google-Smtp-Source: ABdhPJwxL1OzJVnVfNZmSBpClLDif2edIi+wqSZRxCHBo0D5BEuuofkUgl4ThazR8DxEm7tRDU1T581F4Yni8XBqOHc=
X-Received: by 2002:a9d:6f0a:: with SMTP id n10mr1376770otq.268.1606905839217;
 Wed, 02 Dec 2020 02:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20201202071057.4877-1-andrey.zhizhikin@leica-geosystems.com>
 <CAHUa44HuNPmWufnxzqGLrwJqLxTkjCivYGaHvukEkk6nOd1r3g@mail.gmail.com> <AM6PR06MB4691764C8ABBF608837557D7A6F30@AM6PR06MB4691.eurprd06.prod.outlook.com>
In-Reply-To: <AM6PR06MB4691764C8ABBF608837557D7A6F30@AM6PR06MB4691.eurprd06.prod.outlook.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Wed, 2 Dec 2020 11:43:48 +0100
Message-ID: <CAHUa44GLP0JZPnX9Z1b6rNkzMttBWRvOo7QLuySmAmqCQFvpdg@mail.gmail.com>
Subject: Re: [PATCH] optee: extend normal memory check to also write-through
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     "op-tee@lists.trustedfirmware.org" <op-tee@lists.trustedfirmware.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 2, 2020 at 10:41 AM ZHIZHIKIN Andrey
<andrey.zhizhikin@leica-geosystems.com> wrote:
>
> Hello Jens,
>
> > -----Original Message-----
> > From: Jens Wiklander <jens.wiklander@linaro.org>
> > Sent: Wednesday, December 2, 2020 9:07 AM
> > To: ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
> > Cc: op-tee@lists.trustedfirmware.org; Linux Kernel Mailing List <linux-
> > kernel@vger.kernel.org>; stable@vger.kernel.org
> > Subject: Re: [PATCH] optee: extend normal memory check to also write-th=
rough
> >
> > This email is not from Hexagon=E2=80=99s Office 365 instance. Please be=
 careful while
> > clicking links, opening attachments, or replying to this email.
> >
> >
> > Hi Andrey,
> >
> > On Wed, Dec 2, 2020 at 8:11 AM Andrey Zhizhikin <andrey.zhizhikin@leica=
-
> > geosystems.com> wrote:
> > >
> > > ARMv7 Architecture Reference Manual [1] section A3.5.5 details Normal
> > > memory type, together with cacheability attributes that could be
> > > applied to memory regions defined as "Normal memory".
> > >
> > > Section B2.1.2 of the Architecture Reference Manual [1] also provides
> > > details regarding the Memory attributes that could be assigned to
> > > particular memory regions, which includes the descrption of
> > > cacheability attributes and cache allocation hints.
> > >
> > > Memory type and cacheability attributes forms 2 separate definitions,
> > > where cacheability attributes defines a mechanism of coherency contro=
l
> > > rather than the type of memory itself.
> > >
> > > In other words: Normal memory type can be configured with several
> > > combination of cacheability attributes, namely:
> > > - Write-Through (WT)
> > > - Write-Back (WB) followed by cache allocation hint:
> > >   - Write-Allocate
> > >   - No Write-Allocate (also known as Read-Allocate)
> > >
> > > Those types are mapped in the kernel to corresponding macros:
> > > - Write-Through: L_PTE_MT_WRITETHROUGH
> > > - Write-Back Write-Allocate: L_PTE_MT_WRITEALLOC
> > > - Write-Back Read-Allocate: L_PTE_MT_WRITEBACK
> > >
> > > Current implementation of the op-tee driver takes in account only 2
> > > last memory region types, while performing a check if the memory bloc=
k
> > > is allocated as "Normal memory", leaving Write-Through allocations to
> > > be not considered.
> > >
> > > Extend verification mechanism to include also Normal memory regios,
> > > which are designated with Write-Through cacheability attributes.
> >
> > Are you trying to fix a real error with this or are you just trying to =
cover all cases? I
> > suspect the latter since you'd likely have coherency problems with OP-T=
EE in
> > Secure world if you used Write-Through instead.
>
> Yes, this aims to provide consistency in detection which memory blocks ca=
n be identified
> as Normal memory in ARMv7 architecture.

I think you're missing the purpose of this internal function. It's
there to check that the memory is mapped in a way compatible with what
OP-TEE is using in Secure world.

>
> WT coherency control and (especially) observability behavior is described=
 in section A3.5.5 of the
> ARMv7 RefMan, where it is stated that write operations performed on WT me=
mory locations
> are guaranteed to be visible to all observers inside and outside of cache=
 level.
>
> As the Write-Through (WT) provides a better coherency control, it does ma=
ke sense to include it
> into the verification performed by is_normal_memory() in order to provide=
 a possibility for
> future implementations to mitigate issues and select appropriate cache al=
location attributes
> for memory blocks used.
>
> > Correct me if I'm wrong, but "Write-Back Write-Allocate" and "Write-Bac=
k Read-Allocate"
> > are both compatible with each other as the "Allocate" part is just a hi=
nt.
>
> Correct, "Allocate" just designates the cache allocation hint. "Write-Bac=
k Read-Allocate" should
> actually be read as "Write-Back no Write-Allocate", with " Write-Allocate=
" being a hint. But since
> this is controlled by a TEX[0] - this hint is handled separately by L_PTE=
_MT_WRITEBACK and
> L_PTE_MT_WRITEALLOC macros.

B3.11.3 in the spec requires cache maintenance when changing from
Write-Back to Write-Through and vice versa, and we can't do that in
this design.

Cheers,
Jens

>
> >
> > Cheers,
> > Jens
> >
> > >
> > > Link: [1]:
> > > https://eur02.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fd=
eve
> > >
> > loper.arm.com%2Fdocumentation%2Fddi0406%2Fcd&amp;data=3D04%7C01%7C%7
> > Ca40
> > >
> > ffd35912f4fe3d97308d896993b87%7C1b16ab3eb8f64fe39f3e2db7fe549f6a%7C0%
> > 7
> > >
> > C1%7C637424932169074654%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAw
> > MDAiLC
> > >
> > JQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3Dc0jK2gT
> > m
> > > qrAyo0%2Ffr07t%2Fg5NbPdm4dh7Rl7alNWlaQc%3D&amp;reserved=3D0
> > > Fixes: 853735e40424 ("optee: add writeback to valid memory type")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Andrey Zhizhikin
> > > <andrey.zhizhikin@leica-geosystems.com>
> > > ---
> > >  drivers/tee/optee/call.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c inde=
x
> > > c981757ba0d4..8da27d02a2d6 100644
> > > --- a/drivers/tee/optee/call.c
> > > +++ b/drivers/tee/optee/call.c
> > > @@ -535,7 +535,8 @@ static bool is_normal_memory(pgprot_t p)  {  #if
> > > defined(CONFIG_ARM)
> > >         return (((pgprot_val(p) & L_PTE_MT_MASK) =3D=3D L_PTE_MT_WRIT=
EALLOC)
> > ||
> > > -               ((pgprot_val(p) & L_PTE_MT_MASK) =3D=3D L_PTE_MT_WRIT=
EBACK));
> > > +               ((pgprot_val(p) & L_PTE_MT_MASK) =3D=3D L_PTE_MT_WRIT=
EBACK) ||
> > > +               ((pgprot_val(p) & L_PTE_MT_MASK) =3D=3D
> > > + L_PTE_MT_WRITETHROUGH));
> > >  #elif defined(CONFIG_ARM64)
> > >         return (pgprot_val(p) & PTE_ATTRINDX_MASK) =3D=3D
> > > PTE_ATTRINDX(MT_NORMAL);  #else
> > > --
> > > 2.17.1
> > >
>
> Regards,
> Andrey
