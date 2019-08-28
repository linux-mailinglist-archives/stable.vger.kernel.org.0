Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03BC9FF1C
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfH1KIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:08:07 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:43748 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfH1KIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 06:08:06 -0400
Received: by mail-vs1-f67.google.com with SMTP id s5so1446708vsi.10
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 03:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sn4yw0E9TKPLwxftu4m5ARFie3IbTDxCQ5r7TqQo9U4=;
        b=BRk0IPySV9XSuj9WYCy2fuKFMHY8nXsk7XvbXjFYSBhb0u6IV5dGWafooaj0t2aQyq
         rUTO2SaKzM98TsjuAKjLvI3jXEFyYm5k/RfTSza19mTiH00JgFKwDNwP3cDjOHbeKk6p
         ZxLoe2WHEzkpGbrKCI26e3LhQzyS+HWiyXJsxzv/uXLlH4pF/Fob6BRHn6WvHFnY+rVo
         cX9i+6SfCFDWH+b02A0qsrrWbp/BbTMeuVJx+icPGuyCMZUP/Xl8fcIG8Z2MC5pMZQFX
         edyHz8o5nxhzX26C/Qx/L6AzkZLwXyz52/c260jw2dtu5fY/cxVqSDBVB4a8KpdZuKhT
         hNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sn4yw0E9TKPLwxftu4m5ARFie3IbTDxCQ5r7TqQo9U4=;
        b=NXPI+61MvSQtekq9yoPHV1eipxfciVLtYYkQKe6uBtJNHN0KA1webqeXexYJTrHLLw
         gFnOn7ADWitgIEeqTTu/iJc28B2bvrXVrDammKTQuoEhKtFYwWRoNLjNEdBD1uh7Sta3
         52ZnSRAYr5uFvSRcGUP/VEni11Fxz8tyJCl/q5vix48QrXFv19CK3anephSKFUbFsAff
         Zz9JaublVgRcCT8Vl85BOSJbF4PW6n0tGzQz8oEC0Zh677pHlNcUxd9rCZDp47rYKCeT
         e4/edbdJ9n021bgNLHwHVtdzpQ8l9cO13LNZXTGdnmnAVv2J/FcAOR/umoXMcO85WwSR
         tVIg==
X-Gm-Message-State: APjAAAWzaEzdo+pDH5e0LDj5gq5SdzLXvfzeuwIljjmNN9H42NXzw/Bg
        xul5/AWnYOBLNqvjmG9nnYA5otK3aG0dP8XxL3FqCg==
X-Google-Smtp-Source: APXvYqyWIEa2x8ksFDFrt9pZ7Ky1siEEg+wFL0HVAfhUFX1Jk0jOZO/1JKgzcChYcoEkwi+CXofRyI2OQ3hbRX9RsCY=
X-Received: by 2002:a67:e287:: with SMTP id g7mr1818738vsf.200.1566986885818;
 Wed, 28 Aug 2019 03:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190827081043.15443-1-ulf.hansson@linaro.org> <20190827181518.2e7aaa44@fido6>
In-Reply-To: <20190827181518.2e7aaa44@fido6>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 28 Aug 2019 12:07:29 +0200
Message-ID: <CAPDyKFqz-JD6V8_uYDyi87hOF4JJL_b_2uHhmwgfo1dS6SO+5A@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Fix init of SD cards reporting an invalid VDD range
To:     Philip Langdale <philipl@overt.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Aug 2019 at 03:15, Philip Langdale <philipl@overt.org> wrote:
>
> On Tue, 27 Aug 2019 10:10:43 +0200
> Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> > The OCR register defines the supported range of VDD voltages for SD
> > cards. However, it has turned out that some SD cards reports an
> > invalid voltage range, for example having bit7 set.
> >
> > When a host supports MMC_CAP2_FULL_PWR_CYCLE and some of the voltages
> > from the invalid VDD range, this triggers the core to run a power
> > cycle of the card to try to initialize it at the lowest common
> > supported voltage. Obviously this fails, since the card can't support
> > it.
> >
> > Let's fix this problem, by clearing invalid bits from the read OCR
> > register for SD cards, before proceeding with the VDD voltage
> > negotiation.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Philip Langdale <philipl@overt.org>
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > ---
> >  drivers/mmc/core/sd.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> > index d681e8aaca83..fe914ff5f5d6 100644
> > --- a/drivers/mmc/core/sd.c
> > +++ b/drivers/mmc/core/sd.c
> > @@ -1292,6 +1292,12 @@ int mmc_attach_sd(struct mmc_host *host)
> >                       goto err;
> >       }
> >
> > +     /*
> > +      * Some SD cards claims an out of spec VDD voltage range.
> > Let's treat
> > +      * these bits as being in-valid and especially also bit7.
> > +      */
> > +     ocr &= ~0x7FFF;
> > +
> >       rocr = mmc_select_voltage(host, ocr);
> >
> >       /*
>
> Looks right. Tried it out and worked as expected.
>
> Reviewed-by: Philip Langdale <philipl@overt.org>

Thanks! I add your tested-by tag as well!

Kind regards
Uffe
