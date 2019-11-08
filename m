Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C892F4CB4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKHNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:09:42 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:43484 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKHNJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:09:42 -0500
Received: by mail-il1-f193.google.com with SMTP id r9so5056894ilq.10;
        Fri, 08 Nov 2019 05:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJF/YD72i5fHPPeqzHZ2BQYlNx1MC8h3ru4+Z6Wwmbo=;
        b=o8Gr6k0BMdvpPgMU7PhMawO0XyFRTbc5aM4fQ75VGr43ItlOqf+zqnJQTevQ/NqjQn
         +NFpKCU+OypZTM+6ml4/xooGa0TBkBO/2fvkfHAedilZS5vdrVRLfqzH28nAv7xVhon/
         hdHDlhR0T2x8QPfP/DWWSy9CMUl+QwEz9un/P8ZhMz4wEYkx85yNhVMRR62IU5CFwoje
         2bqxkTymSdX5k74tFHqgifSAuBhAkaEnokxl0xBC3ao05slXKgmlL6XHOzuCtAE+4uKa
         i3/HK5GmWkmkWrnAH6ZzW3pcai0hsJELLvJYRLc/MiLEcicWTH3+MCJ5cd0p+pJ19PQs
         uODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJF/YD72i5fHPPeqzHZ2BQYlNx1MC8h3ru4+Z6Wwmbo=;
        b=gwktir3PThVcCY2BH3y9t+pRWSaZjrkPe898FpiReUKCA6iCcJt3MusSj0P2Ucl5rs
         nL3qHHXzxchDOD1MdDj6WEnQpV2HFlPDe7Xv17w1kNuzveUjdR7BuXYTV4cTlumKp+3G
         PkiQp14D0ODM63TTlyFTkRZjXAL1DjtTsx7F0AgKBnOliidSsslNl/hDNQucD9tkHOzh
         dBE1+LYfPFy9QnhfPS4c7JhnBGkH5NGarj9FFCaQZNAhDW/MLCRdsTQi34cAReIqk30q
         8g2GaWl63uAGqYcquePPdp1d90iAbEfS2bruiGuuPlYQlupZ7Rw5OakR4OKGRxjxQYT4
         ED1w==
X-Gm-Message-State: APjAAAUtc4M3b6b6Te+JJ4S2S2YoE0tS1zGNgURo/0Gtb0IlxW0m9OtT
        T7Mpx35sikunGUl01Eefx7Ol2Bq3ZJjhxxFvwgb7rQtw
X-Google-Smtp-Source: APXvYqwWYULlI3VvKJhU0KPPMIqzkdyHNpZENx+E3UNKg1yimmZ3T04hQGKbD7uSJQlLhcwRQFiH8wA81wgQGD7jBQ0=
X-Received: by 2002:a92:5c4f:: with SMTP id q76mr12172286ilb.158.1573218581134;
 Fri, 08 Nov 2019 05:09:41 -0800 (PST)
MIME-Version: 1.0
References: <20191018124938.29313-1-aford173@gmail.com> <7b8b6eba-2cb3-9b25-66e2-e128cc09ceb4@ti.com>
In-Reply-To: <7b8b6eba-2cb3-9b25-66e2-e128cc09ceb4@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 8 Nov 2019 07:09:31 -0600
Message-ID: <CAHCN7xJjX4jWhcRstJV02py0D4Wq_XHoWt9aHTxXANEOwdp+rg@mail.gmail.com>
Subject: Re: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     linux-fbdev@vger.kernel.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Ford <adam.ford@logicpd.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 3:42 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> On 18/10/2019 15:49, Adam Ford wrote:
> > The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> > (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> > correct, and using divider of 32 breaks DSS with a flood or underflows
> > and sync losts. Dividers up to 31 seem to work fine.
> >
> > There is another patch to the DT files to limit the divider correctly,
> > but as the DSS driver also needs to know the maximum divider to be able
> > to iteratively find good rates, we also need to do the fix in the DSS
> > driver.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: stable@vger.kernel.org #linux-4.9.y+
> >
> > diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > index 48c6500c24e1..4429ad37b64c 100644
> > --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > @@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
> >   };
> >
> >   static const struct dss_features omap3630_dss_feats = {
> > -     .fck_div_max            =       32,
> > +     .fck_div_max            =       31,
> >       .dss_fck_multiplier     =       1,
> >       .parent_clk_name        =       "dpll4_ck",
> >       .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> >
>
> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

What is the next step to get these integrated into 4.9+?

adam
>
>   Tomi
>
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
