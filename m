Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C15215C3A
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgGFQv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbgGFQv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 12:51:29 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B886C061755
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 09:51:29 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a6so16755865ilq.13
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29F319nrIBHttIGsOBAGjLt8RaL0BtnN8/ZcPROrQ7A=;
        b=V54sf6h9s05XfF0LDKXng1pvcYb6G1z+/kaSG0Db6wsabFWdPTmokCcTcT0feftGrJ
         mkWDC3SzTdE9hSn8fSwyrcpaDCxHSNDS4IujLka9y79z3m39mKU10TFybt6ezHDXZD25
         FlxmV3HEAVh0rIv5PYVo3m3N4QNrY5Omm3/hDVI/7gZ/GfLi2dCfm8zwAgARtNXpbcQD
         A9rxtBQWuDX7Tg4vkJDdrU5w19xT4RvhGygoK5z1HUTbz+NbfYes6Qx4XHnbpvobMSN1
         7GWOvAZpa5WDUI1AK20c+s0f0+ezjsTORqWZ2+k57S/dKW+GXewtONAyUk+Us01SBTeN
         xKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29F319nrIBHttIGsOBAGjLt8RaL0BtnN8/ZcPROrQ7A=;
        b=nbT9rfcbBd8fbjPNN/ddv2iIX7bWIl1EOvCoAO7t2sxmnQsa02XKSjZ+pFezS/3u0U
         S6r0kMs6X8OuR6HnMPrXksUN7oAKSJ7TKbyTE/dpRZ8eZo/Wnz0Fvn7yWT4NkKaZzj7i
         KmR1HXwCYqLkckPhy/ggylZgIFHJhaTlodMAhe9+ZTew9MqAzhPxXrrMTOd5kvOsDWG7
         0SIA21ciO0Q+ffdt9FZI85uybL+L9uznOxvCHc7+6JiXLHBToi/IQLSHN+KenxJpwZo4
         elRlrEAYqRwPIuyPoT3Mj2E5jxtQ+v+rVHwXf7toMi/1FgHIPyujJtP/Yp7GEUX9pCsg
         xyiQ==
X-Gm-Message-State: AOAM532mBuLuOc8MoilGWkIZds7hE5/mqxVdKcPW6yIU2pK9g/2FRtxi
        8qrsfne0ZweUvoOuJLLidAZ00VP+Un6lJ0d77MkF3Q==
X-Google-Smtp-Source: ABdhPJxIzmUWrDyxO5bXmP/f7wDlvof2nYE+fSuYzsvlGhQh2zKbffa5E4RZxH5geb32WbV3b15DyAEXTQXbAHvsHAI=
X-Received: by 2002:a92:a197:: with SMTP id b23mr30126457ill.58.1594054288334;
 Mon, 06 Jul 2020 09:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200701231701.91029-1-suzuki.poulose@arm.com>
In-Reply-To: <20200701231701.91029-1-suzuki.poulose@arm.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Mon, 6 Jul 2020 10:51:17 -0600
Message-ID: <CANLsYkzSRkYD+f22V02yEA3R-MYGmjveKDkFAgAnDzgDhfbEkQ@mail.gmail.com>
Subject: Re: [PATCH] coresight: etm4x: Fix save/restore during cpu idle
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "# 4 . 7" <stable@vger.kernel.org>,
        Coresight ML <coresight@lists.linaro.org>,
        Mike Leach <mike.leach@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Jul 2020 at 17:17, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> The ETM state save/restore incorrectly reads/writes some of the 64bit
> registers (e.g, address comparators, vmid/cid comparators etc.) using
> 32bit accesses. Ensure we use the appropriate width accessors for
> the registers.
>
> Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Mike Leach <mike.leach@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  drivers/hwtracing/coresight/coresight-etm4x.c | 16 ++++++++--------
>  drivers/hwtracing/coresight/coresight-etm4x.h |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)

Applied - thanks.
Mathieu

>
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
> index 82fc2fab072a..be990457a8ea 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.c
> @@ -1206,8 +1206,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
>         }
>
>         for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
> -               state->trcacvr[i] = readl(drvdata->base + TRCACVRn(i));
> -               state->trcacatr[i] = readl(drvdata->base + TRCACATRn(i));
> +               state->trcacvr[i] = readq(drvdata->base + TRCACVRn(i));
> +               state->trcacatr[i] = readq(drvdata->base + TRCACATRn(i));
>         }
>
>         /*
> @@ -1218,10 +1218,10 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
>          */
>
>         for (i = 0; i < drvdata->numcidc; i++)
> -               state->trccidcvr[i] = readl(drvdata->base + TRCCIDCVRn(i));
> +               state->trccidcvr[i] = readq(drvdata->base + TRCCIDCVRn(i));
>
>         for (i = 0; i < drvdata->numvmidc; i++)
> -               state->trcvmidcvr[i] = readl(drvdata->base + TRCVMIDCVRn(i));
> +               state->trcvmidcvr[i] = readq(drvdata->base + TRCVMIDCVRn(i));
>
>         state->trccidcctlr0 = readl(drvdata->base + TRCCIDCCTLR0);
>         state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
> @@ -1319,18 +1319,18 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
>         }
>
>         for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
> -               writel_relaxed(state->trcacvr[i],
> +               writeq_relaxed(state->trcacvr[i],
>                                drvdata->base + TRCACVRn(i));
> -               writel_relaxed(state->trcacatr[i],
> +               writeq_relaxed(state->trcacatr[i],
>                                drvdata->base + TRCACATRn(i));
>         }
>
>         for (i = 0; i < drvdata->numcidc; i++)
> -               writel_relaxed(state->trccidcvr[i],
> +               writeq_relaxed(state->trccidcvr[i],
>                                drvdata->base + TRCCIDCVRn(i));
>
>         for (i = 0; i < drvdata->numvmidc; i++)
> -               writel_relaxed(state->trcvmidcvr[i],
> +               writeq_relaxed(state->trcvmidcvr[i],
>                                drvdata->base + TRCVMIDCVRn(i));
>
>         writel_relaxed(state->trccidcctlr0, drvdata->base + TRCCIDCCTLR0);
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
> index 7da022e87218..b8283e1d6d88 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x.h
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.h
> @@ -334,7 +334,7 @@ struct etmv4_save_state {
>         u64     trcacvr[ETM_MAX_SINGLE_ADDR_CMP];
>         u64     trcacatr[ETM_MAX_SINGLE_ADDR_CMP];
>         u64     trccidcvr[ETMv4_MAX_CTXID_CMP];
> -       u32     trcvmidcvr[ETM_MAX_VMID_CMP];
> +       u64     trcvmidcvr[ETM_MAX_VMID_CMP];
>         u32     trccidcctlr0;
>         u32     trccidcctlr1;
>         u32     trcvmidcctlr0;
> --
> 2.24.1
>
