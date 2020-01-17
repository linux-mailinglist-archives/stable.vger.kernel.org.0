Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99148141322
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 22:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgAQVbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 16:31:04 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45330 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQVbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 16:31:03 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so27507927ioi.12
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 13:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCU/PYaiWyucY+/YzsxEM57VENsddFqK2SuGsLdtQgw=;
        b=YQPtGhpCgkNN818oKIS1hoUv8HqTzo1YAwSKOsFHC05vICs/mRY74WprxPz6gHurUr
         sSd9L8bRCLJU7rFZ2Ldg8tntXrNL2el3Huev/FxS8bUmFyu+NtWvDVX6ChYNy4vHkiSk
         kt8kLMLfdzsrtbfRiV1KNdpudmDSsQr0wG8nqj1So1DFtefX9Hm8I5RGArgoQF7rVrMm
         FrlAl0g7JcA5ZBclvgtROAXVV0Rd5dW1xCOIUyMCCpbFJm1z9NKC+NmdTbjqFHc+Lc5l
         6IENMfdQZ88SW+pODJBDx8Xr+cKbUN5MgwOS3WxvGRYajKzaCn2aT6Z4+vapGOwTC5/w
         W2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCU/PYaiWyucY+/YzsxEM57VENsddFqK2SuGsLdtQgw=;
        b=f4wGWDnD9y8R+8HlfnMiyCE2A5EX5XE+3mIym8qvo7/oP4GhK5c4mqyxQVP/fKNNXN
         ejKoUxvxGrzqoXJhOqvBTrx/Phe/L+ksvdaVnHSx5Jf3TYkVKg8tgf4d3AxTGftnKWTZ
         Ny1Kw51AzZ5le0RLTLeftH5uipK7G0/mUtO7wcOqGc3YoFZOl8fo8wQLjy0vHpe0reHB
         eYoolwFCFuwX3M5KLH8QRNC8hXyub8LpcuRirFJ5BOb07dJwcjSXC6Iw6hYJQAWv+4Uf
         QKujC7Q8v8NCa0z5PxQWDzdK51aetCSXWpq4DMOYPXP1WsybseZYq9lI4hcPL9Smiwcw
         /D0Q==
X-Gm-Message-State: APjAAAU1iPMj3xuvmvdJNdqwnR+LBkOJ8gj84ae6fa5fsGtjCJC5jSNQ
        +aYasB3g5k6w/GdycAA0ji4q4rD9lP337gUCHF3EqgKglSU=
X-Google-Smtp-Source: APXvYqyqSodtv5T4u65HbMpSp2aZaRaEVN2DzjGYbj2pbhHclIbe1/yAZpzJDpRl5KgKexy6rPH+2SOorY0mItIkNTs=
X-Received: by 2002:a5e:8d14:: with SMTP id m20mr31162687ioj.282.1579296662919;
 Fri, 17 Jan 2020 13:31:02 -0800 (PST)
MIME-Version: 1.0
References: <20200117200537.9279-1-esben@geanix.com> <20200117200537.9279-3-esben@geanix.com>
In-Reply-To: <20200117200537.9279-3-esben@geanix.com>
From:   Han Xu <xhnjupt@gmail.com>
Date:   Fri, 17 Jan 2020 15:30:51 -0600
Message-ID: <CA+EcR22w7gTtyhbaikXsEHhSUhrm2RRGBNbJWQTxF8Gsx7c4WA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mtd: rawnand: gpmi: Restore nfc timing setup after suspend/resume
To:     Esben Haabendal <esben@geanix.com>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 2:06 PM Esben Haabendal <esben@geanix.com> wrote:
>
> As we reset the GPMI block at resume, the timing parameters setup by a
> previous exec_op is lost.  Rewriting GPMI timing registers on first exec_op
> after resume fixes the problem.
>
> Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
> Cc: stable@vger.kernel.org
> Signed-off-by: Esben Haabendal <esben@geanix.com>
> ---
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index 879df8402446..b9d5d55a5edb 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -2727,6 +2727,10 @@ static int gpmi_pm_resume(struct device *dev)
>                 return ret;
>         }
>
> +       /* Set flag to get timing setup restored for next exec_op */
> +       if (this->hw.clk_rate)
> +               this->hw.must_apply_timings = true;
> +

Acked-by: Han Xu <han.xu@nxp.com>

>         /* re-init the BCH registers */
>         ret = bch_set_geometry(this);
>         if (ret) {
> --
> 2.25.0
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/



-- 
Sincerely,

Han XU
