Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE8EFA25
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 10:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbfKEJxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 04:53:05 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46473 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbfKEJxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 04:53:05 -0500
Received: by mail-ot1-f65.google.com with SMTP id n23so6841408otr.13;
        Tue, 05 Nov 2019 01:53:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLPNcT9vjto8jhxSU5gnOX/RlS4+gk9Rpr1qFlmu5G0=;
        b=Qu22dcsfIoKdJEhK8eGwZNO0SBo8/srVUnVx1zwpoQ0gEgUN2IBsDD02EUKscq9c1e
         15X79glDEIDyxkVCdtG+TM24rK9QzdJRiYz/oAy0xH1yQOdyPy63ulKTT87tg6q91IDP
         XJM5GubkQg42XFvznip8ndrL48WLx+JJW5+6rO0rT1+sZHHJbBFkmpdl2xLP+YLTq7nl
         fXmmqKUkeIgQBtEcXa7QLFzCtNc3EJoc7pp2/o/3Z9fqzHo9lpfyacvT0Va/JoiPtrHn
         kp3iNTeNn786kOOq4jHrl6XISsPFjLh2lu38j+2rwA6hTmqoWXeD5uXvhALQB98sxs8M
         Qf+Q==
X-Gm-Message-State: APjAAAVRtPFWdj3r2zLeJNpFDeKTRiK63LMyr9fG/eVsg84TttTVjt5p
        fujfd2BM3S7gnlxMoeoa7fRWjnma6PGF7DuGp3o=
X-Google-Smtp-Source: APXvYqyeb1Ap09GKChPbIXVGFokrLltYfHhmkwQ5BAaxOCCE0bQQk5JmXL/MsCglDV47tC0YC0Lek4/H7PbHMTU4Yyw=
X-Received: by 2002:a9d:191e:: with SMTP id j30mr12466088ota.297.1572947584402;
 Tue, 05 Nov 2019 01:53:04 -0800 (PST)
MIME-Version: 1.0
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com> <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Nov 2019 10:52:53 +0100
Message-ID: <CAMuHMdXvFaPwqo2EHiBMTot05KggRNtL56JOrW_MUrBLL6NHxQ@mail.gmail.com>
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

On Tue, Nov 5, 2019 at 10:26 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Geert Uytterhoeven, Sent: Tuesday, November 5, 2019 5:50 PM
> > On Tue, Nov 5, 2019 at 3:48 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > According to the R-Car Gen2/3 manual, "Be sure to write the initial
> > > value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> > > To avoid unexpected behaviors, this patch fixes it. Note that
> > > the SPCHG bit of MACCTLR register description said "Only writing 1
> > > is valid and writing 0 is invalid" but this "invalid" means
> > > "ignored", not "prohibited". So, any documentation conflict doesn't
> > > exist about writing the MACCTLR register.
> > >
> > > Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> > > Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> > > Cc: <stable@vger.kernel.org> # v5.2+
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/pci/controller/pcie-rcar.c
> > > +++ b/drivers/pci/controller/pcie-rcar.c
> > > @@ -91,8 +91,12 @@
> > >  #define  LINK_SPEED_2_5GTS     (1 << 16)
> > >  #define  LINK_SPEED_5_0GTS     (2 << 16)
> > >  #define MACCTLR                        0x011058
> > > +#define  MACCTLR_RESERVED23_16 GENMASK(23, 16)
> >
> > MACCTLR_NFTS_MASK?
>
> I should have said on previous email thread [1] though,
> since SH7786 PCIE HW manual said NFTS (NFTS) but
> any R-Car SoCs' HW manual said just Reserved with H'FF,
> so that I prefer to describe RESERVED instead of NFTS.
> Do you agree?
>
> [1]
> https://marc.info/?l=linux-renesas-soc&m=157242422327368&w=2

My personal stance is to make it as easy as possible for the reader of
the code ("optimize for reading, not for writing"), as code is written once,
but read many more times later.
This is not the first time register bits were documented before, and changed
to reserved later.
In this case the resemblance to the SH7786 PCIe block is obvious, and
the SH7786 hardware user's manual is available publicly.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
