Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B201F15AD41
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 17:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgBLQW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 11:22:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45487 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgBLQW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 11:22:27 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so1461151pfg.12;
        Wed, 12 Feb 2020 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/S/gu5ls056hur5YDfXFsWlqa/VXA1YVt8W07oi8A0=;
        b=t4Q/rqVY5SzGQA3770fHEw4TUpO31savs1Ccvpjf9zd84waVs3yJM9pfnejClHR1UE
         Lkp0sns0cE09dZfQRmq0oBofdY/9iVWCF74zdbMQWdFJsibQaCR/Wkpk7VSi5NCMrOTn
         FesMXEcb+2UEfy27+9j8iysokL7EZwdF07767X/5FXrobZfLI+8TCaTcIPe70Um0JggX
         qSAcy19J5mp5d1/lU2nLrFTadHzRHzD3f4cQ18i84bdKvjuTVxHi5uvrNXN+xyysxxE3
         ZpdgdexrOcsf6Xy54p3acue3hOABe+IBI5+5XfOCRiOmULIb1TFF6cTljQJOB3NDRPp0
         ixNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i/S/gu5ls056hur5YDfXFsWlqa/VXA1YVt8W07oi8A0=;
        b=iXiImyetsOCpIi7UdS+AzadsCa22PyGGlZPe8/eErvuSqkDhDuqrhpArfNmSoJVrR+
         zmaKaWXJzyZdxt6iS+g++Qfob/8MlcTCI6ILTM2fyrgoroJl9u4UaXbXtkS+/MgTgv8b
         HuYgmUBecjXFpcFLQoUg0mXmsJy62mGNv2tB6fViMp1fv9aYHydGRDIuf69SLbumfxVM
         46oR4V/paCEvfNtrPmW9yoBs+9bOdTDPQJtpfHy8Pkq706gGcFaAcZ1uVnE5ZrexQye2
         6uoUdipD4vKRsHj5vUYaFrEGkOLQaYJr3oEGxK9hsBYCBYoTp5ithy5i5UIG5KA9bRBw
         lCuw==
X-Gm-Message-State: APjAAAVOOmOERCT0jiqddL9ujbTky35kidzTGRXAe4OUEFK9DHfRZ+Tq
        f1WG8PxxMJth3Kv7TxWj2wk/OVwSIH8V+VNbqfk=
X-Google-Smtp-Source: APXvYqyxHKklmuKov1yA4Urj79T+gfbmYj+Vp5gE+wLeOgEhYafxRpjw4Lg5cY3ZnSZXyB3yPILql+1nG6BAZerDyog=
X-Received: by 2002:a63:583:: with SMTP id 125mr9258604pgf.100.1581524546569;
 Wed, 12 Feb 2020 08:22:26 -0800 (PST)
MIME-Version: 1.0
References: <20200128110102.11522-1-martin@kaiser.cx> <20200128110102.11522-2-martin@kaiser.cx>
In-Reply-To: <20200128110102.11522-2-martin@kaiser.cx>
From:   PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date:   Wed, 12 Feb 2020 21:52:15 +0530
Message-ID: <CANc+2y4Suv0iZ38uxC97U0x73RcKnKiRnjcC-xNh9gNZYn3aUQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] hwrng: imx-rngc - fix an error path
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Martin,

On Tue, 28 Jan 2020 at 16:31, Martin Kaiser <martin@kaiser.cx> wrote:
>
> Make sure that the rngc interrupt is masked if the rngc self test fails.
> Self test failure means that probe fails as well. Interrupts should be
> masked in this case, regardless of the error.
>
> Cc: stable@vger.kernel.org
> Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 30cf00f8e9a0..0576801944fd 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -105,8 +105,10 @@ static int imx_rngc_self_test(struct imx_rngc *rngc)
>                 return -ETIMEDOUT;
>         }
>
> -       if (rngc->err_reg != 0)
> +       if (rngc->err_reg != 0) {
> +               imx_rngc_irq_mask_clear(rngc);
>                 return -EIO;
> +       }
>
>         return 0;
>  }
> --
> 2.20.1
>

Looks good to me. You can add
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Regards,
PrasannaKumar
