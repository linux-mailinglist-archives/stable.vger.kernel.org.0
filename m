Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68A0C88FC
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfJBMoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 08:44:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38865 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfJBMoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 08:44:22 -0400
Received: by mail-io1-f67.google.com with SMTP id u8so56480014iom.5;
        Wed, 02 Oct 2019 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K2EDNo6fdIk1yPYshgFY+LxCeMPIbUzUML1ZMzywDRM=;
        b=YByVcbYGwBrrXoTfRrEu+N9yzrjjw5L+sR+uOIyNX+ofw5xuvwwWx5Mo7LtEJ/sFY6
         LGqRFvAZGfiWD/HojLNYSLQrU91SCRcq77H3KQcesiDQxiH6VbJdTA/LqSK0RM89zT/+
         v/bJ7NYgtTGkEu2MIVwXIePCTUPAA3GjvI8DK+L1qkiQP5KBfHdLub3XFf81lauiC56L
         Dmb3Fd8wRFw7j/BRQf4s4OkKKJG+Zrjp/HOz1IrAepflC9YJ2d1XyWg4TpUZZ7XmY645
         +ocvicAL8VuwrtsgxsHL5QUCuvdlR42bmnLvle+dUsuwBfxFhYZLy6DkcyzhcULFTjIS
         PCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K2EDNo6fdIk1yPYshgFY+LxCeMPIbUzUML1ZMzywDRM=;
        b=TJylyyWF6E7HUYomzgOZM8WkE+ZbuSM95CpV6YxxTMzc/PNYblBGcJ5QubS7zqxbj2
         7rTROQcDqrZK+WF2xVt43Ga0NEVEjcOzozcdCSZaJ85ekVUgRQ7za3H8/fpQdK/1QweR
         ti3wykpsF3xeryN27H3NzSX5i2/DfMMNwqsUAAmFaczZd6SdYoj3OcawjkMqK+Q3cazP
         WGEGenjRyJYhqmGUAQf8Q971+CDoc0Ri+Ie0vXsYGARntZGxJpbEN3CcriygEARJZgIe
         Xu6mct1ZyTy4eFNTlKxJ2XP95O7MOXf46KvZJcx3sBgHHxL/zamSHf3kHjykM+cvab7a
         tEBQ==
X-Gm-Message-State: APjAAAXnPDQEpSOCAF5B7eRqufF7TtZGpTxKGe7MdNYkPoqvlHu/9MS1
        loeyXca/HfzrvOxZCW9Jy2R1Nbx7JWzGhiuCVQVtGEn+Fgo=
X-Google-Smtp-Source: APXvYqzF9cOJ1aDPvRHDfwikKgbCR0zT25G5dvOsc9grgCxxK+urmYa+3ZhC8DFiIN5cP4/smp+ud+JsYhZ8En+SGgg=
X-Received: by 2002:a92:9912:: with SMTP id p18mr4029749ili.78.1570020261376;
 Wed, 02 Oct 2019 05:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191002122542.8449-1-tomi.valkeinen@ti.com>
In-Reply-To: <20191002122542.8449-1-tomi.valkeinen@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 2 Oct 2019 07:44:10 -0500
Message-ID: <CAHCN7xKCSVSJ2h7Y-NF_TNDhB-LKH=aMmma4g8dH56POqDVWUA@mail.gmail.com>
Subject: Re: [PATCH] drm/omap: fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 2, 2019 at 7:25 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> correct, and using divider of 32 breaks DSS with a flood or underflows
> and sync losts. Dividers up to 31 seem to work fine.
>
> There is another patch to the DT files to limit the divider correctly,
> but as the DSS driver also needs to know the maximum divider to be able
> to iteratively find good rates, we also need to do the fix in the DSS
> driver.
>

When combined with the cock divider patch [1], this fixes a hanging
issue on a DM3730 with a 480x272 screen where the pixel clock is set
to 9MHz and the clock divider attempts to calculate a fclk and hangs.
I have always had to hack the divider to prevent the hang.

If possible, it would be nice to have this applied to 5.4 branch since
it will be an LTS kernel.

[1] - https://patchwork.kernel.org/cover/11170951/

Tested-by: Adam Ford <aford173@gmail.com>

> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Adam Ford <aford173@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/omapdrm/dss/dss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
> index e226324adb69..4bdd63b57100 100644
> --- a/drivers/gpu/drm/omapdrm/dss/dss.c
> +++ b/drivers/gpu/drm/omapdrm/dss/dss.c
> @@ -1083,7 +1083,7 @@ static const struct dss_features omap34xx_dss_feats = {
>
>  static const struct dss_features omap3630_dss_feats = {
>         .model                  =       DSS_MODEL_OMAP3,
> -       .fck_div_max            =       32,
> +       .fck_div_max            =       31,
>         .fck_freq_max           =       173000000,
>         .dss_fck_multiplier     =       1,
>         .parent_clk_name        =       "dpll4_ck",
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
>
