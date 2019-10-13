Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F68D56B2
	for <lists+stable@lfdr.de>; Sun, 13 Oct 2019 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfJMP4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 11:56:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36391 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfJMP4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Oct 2019 11:56:21 -0400
Received: by mail-io1-f65.google.com with SMTP id b136so32104526iof.3;
        Sun, 13 Oct 2019 08:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S/Ip8+Jxgd0rwhnDB/VueXGj42PNw7fZm2CTH/h8LA0=;
        b=fWNrk6Wcf+1CR3jVL77n57LtxfF1y1ZDj2mm47rK7/Y9WeAIv1x8CeFfrzxDCchZWL
         BE/1a9QgyMg5tnm20+H4PTXgX6g/aMooAtkid42a4OrX/6wwDx1wKv2ZaZBTwf/HaXCp
         8PJ834/B4T3qrwtk9K6atZnNJDqKHfCtCi+BKY/zZutyiKDvGO7XtrVfmVGB2+qel0/n
         ibUKMeEg1f3KhIL+hd5evfvDQQFqaIgF/J7W2p8ZUoN4x+tCmpl7Ceyb54JzrxfgL4bg
         C640oz/u2TELXug7xsIyZPtSUN/RZ9Mo1WZyiEvEcLO+bXCol6HGMqnlUCkB4ZMQSnSE
         v/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S/Ip8+Jxgd0rwhnDB/VueXGj42PNw7fZm2CTH/h8LA0=;
        b=CHDleDUL4sOX6HdKGCYt+wLVCahnK3ngJOUn9aPDV9ziMBkEz+AkPc2dRzXUnw0eyB
         gc7wUL2i2LG8os0F2YnawCuqL8ij1iH0Z37LTBv9pmPg/AT/hJs+gxuhrZedF+yUyvK5
         aT1i6boAtKZD8AA1nbTTSpq05D65yg+E9KTjpzd+Bq+LjPujuSRUhMdacZtI19SoaJJt
         w8FSG/posWdCQHFYQ4U6krloEU42UAu/z1iOcr02XdTaLphtKDSAwsgPPL2kd4PfX+ek
         Jr0jPbSzJHY1O3IACRoCY3AAO0nvSYt7WjHAJqnHWFVPM3CjyKQAigumI4XgmAOsttTS
         7eNw==
X-Gm-Message-State: APjAAAXHV0xHWuapzARfY05Z8h08bWwhz/6v4NcSp278Ul3qwzCS103U
        j3W/QbumudzGR14DajGoQHEZzrGAAWBr0vgQXOk=
X-Google-Smtp-Source: APXvYqwmSVFuQ3GFsuRZS3O4VKiiy3+iPXNr/Rrh2XRbTKykEf2L7RTXUXG2yXe9DRPmJV1QDLo8BJypHPQgdllTf4g=
X-Received: by 2002:a05:6638:3a6:: with SMTP id z6mr15738134jap.33.1570982180198;
 Sun, 13 Oct 2019 08:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191002122542.8449-1-tomi.valkeinen@ti.com>
In-Reply-To: <20191002122542.8449-1-tomi.valkeinen@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Sun, 13 Oct 2019 10:56:09 -0500
Message-ID: <CAHCN7xLjGkLHMWejEk-3vJ-OwzjB+BXtnPWoonh4mAVxbkzMWQ@mail.gmail.com>
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

Tomi,

Is there any way you can do a patch for the FB version for the older
4.9 and 4.14 kernels?  I think they are still defaulting to the omapfb
instead of DRM, so the underflow issue still appears by default and
the patch only impacts the DRM version of the driver.  If not, do you
have any objections if I submit a patch to stable for those two LTS
branches?

thanks,

adam
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
