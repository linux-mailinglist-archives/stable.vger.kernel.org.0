Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BD2EFB0C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 11:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388466AbfKEK0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 05:26:34 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43761 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388022AbfKEK0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 05:26:33 -0500
Received: by mail-ot1-f66.google.com with SMTP id l14so2833024oti.10;
        Tue, 05 Nov 2019 02:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrM4WH7ocSeoIP0D4IPJEXJdoXpjHvezDNcy0lyrxPI=;
        b=uHNb91zdVwx1ch67levEKsnIAyvEA49hNNl4uBSsmn/SRglm6oS/D4SbF3H/l3Zlw/
         Ad9OUCX8WrEfCgRiA+iMuRrNaFto4nJ/gdJrDdDSxUGFLtu4UgbBWGMr2AkWXdTleUyn
         z+z6kCr+sp3KG/gtIiMdrKstBvfixkOW4oxjQ+tq2cUwMgIYR+FlWEVhfPa84hSgRKTc
         KD7mt8G5aBa1seu9vF69aYF79fzBy+UCnPwSExc2kDDQ94aqKXUzjnuuyqu5YYDeitkh
         zy7NFtPyLQpfkDc8SMh1kuDWxLZJfQqVbxafUx4nBhUrdNlhiYXvQs3Jceu6NU16ptfu
         i1Wg==
X-Gm-Message-State: APjAAAUrGzWglDfDrM3AHj/Mf/xkHMDBe80JfyiXIv8EttLCDRGrrv/w
        bn7wM6v5PKzxGgmgeTJ6XogdAA3Ajn+DGM12nimLnQ==
X-Google-Smtp-Source: APXvYqywAlKULKehwmF0jzj2vvJGTlbdVDUNqYoFvl1X3Ao+ET1o5TY/1F2axWN2/1Or/x8MxulRqbmKke+Rvy8DINU=
X-Received: by 2002:a9d:422:: with SMTP id 31mr20794682otc.107.1572949592429;
 Tue, 05 Nov 2019 02:26:32 -0800 (PST)
MIME-Version: 1.0
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
 <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CAMuHMdXvFaPwqo2EHiBMTot05KggRNtL56JOrW_MUrBLL6NHxQ@mail.gmail.com> <TYAPR01MB45440A377DBE627FFFCCC287D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB45440A377DBE627FFFCCC287D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Nov 2019 11:26:21 +0100
Message-ID: <CAMuHMdUW5Zb1FXf8OzOYJjZh=yxi3f_s0D-qy3Xw-HEGQRi54A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Tue, Nov 5, 2019 at 11:11 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Geert Uytterhoeven, Sent: Tuesday, November 5, 2019 6:53 PM
> > On Tue, Nov 5, 2019 at 10:26 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > > From: Geert Uytterhoeven, Sent: Tuesday, November 5, 2019 5:50 PM
> > > > On Tue, Nov 5, 2019 at 3:48 AM Yoshihiro Shimoda
> > > > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > > > According to the R-Car Gen2/3 manual, "Be sure to write the initial
> > > > > value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> > > > > To avoid unexpected behaviors, this patch fixes it. Note that
> > > > > the SPCHG bit of MACCTLR register description said "Only writing 1
> > > > > is valid and writing 0 is invalid" but this "invalid" means
> > > > > "ignored", not "prohibited". So, any documentation conflict doesn't
> > > > > exist about writing the MACCTLR register.
> > > > >
> > > > > Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > > > Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> > > > > Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> > > > > Cc: <stable@vger.kernel.org> # v5.2+
> > > > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > >
> > > > Thanks for your patch!
> > > >
> > > > > --- a/drivers/pci/controller/pcie-rcar.c
> > > > > +++ b/drivers/pci/controller/pcie-rcar.c
> > > > > @@ -91,8 +91,12 @@
> > > > >  #define  LINK_SPEED_2_5GTS     (1 << 16)
> > > > >  #define  LINK_SPEED_5_0GTS     (2 << 16)
> > > > >  #define MACCTLR                        0x011058
> > > > > +#define  MACCTLR_RESERVED23_16 GENMASK(23, 16)
> > > >
> > > > MACCTLR_NFTS_MASK?
> > >
> > > I should have said on previous email thread [1] though,
> > > since SH7786 PCIE HW manual said NFTS (NFTS) but
> > > any R-Car SoCs' HW manual said just Reserved with H'FF,
> > > so that I prefer to describe RESERVED instead of NFTS.
> > > Do you agree?
> > >
> > > [1]
> > > https://marc.info/?l=linux-renesas-soc&m=157242422327368&w=2
> >
> > My personal stance is to make it as easy as possible for the reader of
> > the code ("optimize for reading, not for writing"), as code is written once,
> > but read many more times later.
> > This is not the first time register bits were documented before, and changed
> > to reserved later.
> > In this case the resemblance to the SH7786 PCIe block is obvious, and
> > the SH7786 hardware user's manual is available publicly.
>
> Thank you for sharing your stance. I understood it. So, I'll fix it as following.
> Is it acceptable?
>
> #define  MACCTLR_NFTS_MASK      GENMASK(23, 16) /* The name is from SH7786 */

Sounds great to me.
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
