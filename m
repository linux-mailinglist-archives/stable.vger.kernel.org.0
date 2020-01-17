Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8853314131B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgAQVai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 16:30:38 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:41326 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgAQVai (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 16:30:38 -0500
Received: by mail-il1-f193.google.com with SMTP id f10so22433549ils.8
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 13:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fwUDKdVDVPF9fiX1Os8c+YJ8FeIeDDAgq4WvIPa/3eY=;
        b=Ejng6wdrW6yC/iNH+1VNpMx75kR7aqIBSm06ARTmp6oujT6u3PezSGJObjE/hNh0MH
         +QCfEtiNi2fRllOh+tjh5NW17zUt1u37uSRP5Ca+9yG/KtK4MjzG1h9TivNTcsVLj/zb
         KTWity7lCozfwKOehQTLw7ck2Oz5qU/y9pLzk3LDlT0VMMsiiqQpqQ1XTUVt3tY4zzYq
         UhP2slw4jXzYDrcHzgnvAjYTVQFgVgYbK4Oc3H3k11d3VclWdfXsyE59Gvfqh/SSeEu4
         UrEodfuqk9hg6o+Wz4TkP0m/KbbVI1RB3K4g1og+VrgNfp7K5uvlyhFbo56o6uPKH0j6
         oEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fwUDKdVDVPF9fiX1Os8c+YJ8FeIeDDAgq4WvIPa/3eY=;
        b=LZtzSam7XtXDlzoaUijXBxJC2itLldKGyik4Pjrgi0o1HzobnMXpzXVuhM+Y6JzL5T
         UfUAH0inHEHRgJ70cjvXbyZsDUSV8MHBRdepn8QI+0riZ8ddIZgEEX4sH/rL2o+D1BP8
         URfiWFm3JvbIh5vuvT6S5+TFYPwo8BEA6poYBn7MsHfk2Z2bNknXcbqfzugAP7QTWT0d
         orWcmPCdcbiIaXvMcYJfp9zBm+B/kgtzIFZ7i2VbGBHYLp9X1eSn3I1T7y2mNBJYAbxu
         qlK5Ez6s2BrjKRJ+vF4p2lyQBt55FbWEVymxR/k87njpOCujI6NdjUJqdwU+2qtRBgHn
         MqKg==
X-Gm-Message-State: APjAAAXlkpcOSBmQWweZdm/G8ugl4clE+c0LvcW31g4UkvvefMXPOdYC
        scIPjdnknnAuEkSbft9BWM5zWAe+pEuT3J/dids=
X-Google-Smtp-Source: APXvYqx9WCvLe5ev4yxrUK8FfE1LNjRob54Psy2nzrwMrpCUCLh0gu4riG0TOkXkU9xwitVW40l2dqmPhpnn6+gTWAc=
X-Received: by 2002:a92:d30d:: with SMTP id x13mr567709ila.170.1579296637824;
 Fri, 17 Jan 2020 13:30:37 -0800 (PST)
MIME-Version: 1.0
References: <20200117200537.9279-1-esben@geanix.com> <20200117200537.9279-2-esben@geanix.com>
In-Reply-To: <20200117200537.9279-2-esben@geanix.com>
From:   Han Xu <xhnjupt@gmail.com>
Date:   Fri, 17 Jan 2020 15:30:26 -0600
Message-ID: <CA+EcR23iNa8Pgvo3z-d+FES0WwxzOxKgOXk69BbynLqAg1FQcA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mtd: rawnand: gpmi: Fix suspend/resume problem
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

On Fri, Jan 17, 2020 at 2:05 PM Esben Haabendal <esben@geanix.com> wrote:
>
> On system resume, the gpmi clock must be enabled before accessing gpmi
> block.  Without this, resume causes something like
>
> [  661.348790] gpmi_reset_block(5cbb0f7e): module reset timeout
> [  661.348889] gpmi-nand 1806000.gpmi-nand: Error setting GPMI : -110
> [  661.348928] PM: dpm_run_callback(): platform_pm_resume+0x0/0x44 returns -110
> [  661.348961] PM: Device 1806000.gpmi-nand failed to resume: error -110
>
> Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
> Cc: stable@vger.kernel.org
> Signed-off-by: Esben Haabendal <esben@geanix.com>
> ---
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index 334fe3130285..879df8402446 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -148,6 +148,10 @@ static int gpmi_init(struct gpmi_nand_data *this)
>         struct resources *r = &this->resources;
>         int ret;
>
> +       ret = pm_runtime_get_sync(this->dev);
> +       if (ret < 0)
> +               return ret;
> +
>         ret = gpmi_reset_block(r->gpmi_regs, false);
>         if (ret)
>                 goto err_out;
> @@ -179,8 +183,9 @@ static int gpmi_init(struct gpmi_nand_data *this)
>          */
>         writel(BM_GPMI_CTRL1_DECOUPLE_CS, r->gpmi_regs + HW_GPMI_CTRL1_SET);
>
> -       return 0;
>  err_out:
> +       pm_runtime_mark_last_busy(this->dev);
> +       pm_runtime_put_autosuspend(this->dev);
>         return ret;
>  }
>

Acked-by: Han Xu <han.xu@nxp.com>

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
