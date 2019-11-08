Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386D7F4CC3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfKHNK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:10:57 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39280 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKHNK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:10:57 -0500
Received: by mail-il1-f195.google.com with SMTP id a7so4657358ild.6;
        Fri, 08 Nov 2019 05:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nahHqUz3/obBwpqlgIc7CwCj/FhH1UqSQVTekcxe7BA=;
        b=OR+SNRg8B5FpGfACVmeUC9pt4iY0Vkss6VVhaboxI2i70dB61cUT6e+fmHi0eBdQVp
         xOEqrJFBrvbLx777AsccJ7XtJ3EL9tNfbYKjEK3F41nzEq6kx1mPabhcp3PRoZE0k23T
         mFrWfUXkATA/fnwa/wq6PVR8uVEq75Q/+SjUZwko/mC2Kc3JnroaCMUKakzqRSEA15tZ
         o9DCgPfnBiaZ6sUYN2mtiQtLRMnVPqK8y9qNtIs0FiSJThAphZWYZph5r9CQg/znQyGV
         jYVfFeifAGZPpBtkrjc7y+VpJiVgBIRBtkcc3HdfxqRZHqmQOVpkCyRDC1Gr76wAiic9
         mmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nahHqUz3/obBwpqlgIc7CwCj/FhH1UqSQVTekcxe7BA=;
        b=ekTMiRsztUoml0rJVrcloZdNAsnflpVcUHH22C4TwEaOBSS9/7bPgKCmXeN+o+3+OI
         0ywmxCxt30VY5fE6u23cysXbAiljEf8n7FkSQuR5UyBRoLaRVIy+3/yOQbh7zj65u4hI
         QUDMlw92C695AgOaunWJAcVTZzhvHLrnSo7k2SLIu/g2WjFA+VvvymQC58z5ce+AO1XZ
         sd5DaP/z0LlUW2mRjsEhNRJCL+6wP5KWAGh6jk3dyIVF+YTUtDZvPR6Ccyjcn99MLKKe
         zlZ1pXUAmW6HNmn2ICLNUaDW1YxDpsfM2GxLpCyXnN1rjGPXBHs+u7hKQDnvB4aPh6/V
         TD3w==
X-Gm-Message-State: APjAAAXSvoQNKsatTtSm/tVH/tQSDOogaDexTc/KUSqN1AR3843raTM1
        03DwtJwT4Orqawb7fJOKplrmGYwJOFYv/CUF+lckkRCr
X-Google-Smtp-Source: APXvYqzAJU4sRg6jJnt/2BiUBevqIWVuv2bDwxN256RfPHia7sufV/QREhysjcqQtvzRFBxS0vnIPjqM1G310HnS5sU=
X-Received: by 2002:a92:cb84:: with SMTP id z4mr13137312ilo.78.1573218655594;
 Fri, 08 Nov 2019 05:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20191018130507.29893-1-aford173@gmail.com>
In-Reply-To: <20191018130507.29893-1-aford173@gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 8 Nov 2019 07:10:45 -0600
Message-ID: <CAHCN7xJ9aAHjHToM5mGixWvJb7hAOenST7Fkett84nNQdUghmA@mail.gmail.com>
Subject: Re: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
To:     linux-fbdev@vger.kernel.org
Cc:     Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Adam Ford <adam.ford@logicpd.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 8:05 AM Adam Ford <aford173@gmail.com> wrote:
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
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: stable@vger.kernel.org # linux-4.4.y only

This is basically the same patch as the only Tomi reviewed for 4.9,
but it is based on 4.4.

Is there any way these can be integrated?

thank you,

adam
>
> diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
> index 9200a8668b49..a57c3a5f4bf8 100644
> --- a/drivers/video/fbdev/omap2/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/dss/dss.c
> @@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
>  };
>
>  static const struct dss_features omap3630_dss_feats = {
> -       .fck_div_max            =       32,
> +       .fck_div_max            =       31,
>         .dss_fck_multiplier     =       1,
>         .parent_clk_name        =       "dpll4_ck",
>         .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> --
> 2.17.1
>
