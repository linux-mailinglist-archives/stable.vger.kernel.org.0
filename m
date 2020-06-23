Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699902057E5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgFWQvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbgFWQvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 12:51:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CFCC061573;
        Tue, 23 Jun 2020 09:51:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 17so4001119wmo.1;
        Tue, 23 Jun 2020 09:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bg1C/maXc1yHDgyZ8N7KDhwmSTHqJRAHyYrqsJclewo=;
        b=mqlbr0HtalRaLV/mTAHk1BaZYRLajtzzuqOA2+xIlE7AFpAXzv6NUeqUeqKEUQlwLX
         l5zgIuas0ANzK8c/p/RVzTC8TwzZoJjhGuECNWqjYzxw2eUIHeaX19dSA6JsOFE7pzCd
         bZgOU/3pXAshIfBoutWFqGiniMWEyegzk+QZUs0G3s22hBkrCE0JIGhU8lmWLZh3mpMb
         TCJzyR+rCR7xtKssZCUDO1iE8cvoTbSTu12OfaEeVSGaQe5LilnfEZ9X2bAACBMwShMa
         K+KszQp30zSwChCOwZUwT1wzgpqRgLnHnd5PeO+xeLbJxAhePjlwb9yXjzsXOhL8SlPS
         g7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bg1C/maXc1yHDgyZ8N7KDhwmSTHqJRAHyYrqsJclewo=;
        b=lpQD0yh35vZl60rdjZnHADWTLWxaNjkT5I2zFUZS3w0i3zTbk0KSoPGqxeT2kPo3J8
         3mXxN9h9+h1DdzilP7nleTUzt1E5tkVlkXQtqId8TtJN7KW/IYwMnzRaTr+zkQh278Qg
         y+ojwEdL9e8P+umx95LokqiN4iy+exUKzlZqpflKFQaqWtSBcuRAqnGcDSgjjzVMJ8tF
         F22ynqRXjQENaDWs0lKTpzj1cnU10BIAUgG1b7Ul0TzkBNlJS/RgHAiJXWXtqU0MOHWq
         nQD+1wOIKgK07Ai88PKL9prp6EyWDUfnL9niAdcEcP9y1PTckDkkjjpcRA/nNJWUk+D4
         VX8g==
X-Gm-Message-State: AOAM531XoRp49CzmWcJzT3+uaFWHBvEj62IxWVy5tRcN+wLQEEoW6TyK
        RNihOjT8bmTzEwtNJ1s1+GJGTgOHvMd/+aBH1FsmVw==
X-Google-Smtp-Source: ABdhPJzXWe6A3dDxn3bWQEVxIsTa+qlEbGIxqOQmoCTQoQfdJpqdMBYbeYGxrWp7QJDkL5X7Bvoa+gqY9oAeDztKizQ=
X-Received: by 2002:a1c:3954:: with SMTP id g81mr11521140wma.73.1592931074567;
 Tue, 23 Jun 2020 09:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200622203122.25749-1-efremov@linux.com>
In-Reply-To: <20200622203122.25749-1-efremov@linux.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 23 Jun 2020 12:51:03 -0400
Message-ID: <CADnq5_MK=DmiP4Y_AkEX3RL6dLDdoMOkyEYfrSu6H3OCE9jh+w@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: fix fb_div check in ni_init_smc_spll_table()
To:     Denis Efremov <efremov@linux.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "for 3.8" <stable@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 5:56 PM Denis Efremov <efremov@linux.com> wrote:
>
> clk_s is checked twice in a row in ni_init_smc_spll_table().
> fb_div should be checked instead.
>
> Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied.  Thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
> index b57c37ddd164..c7fbb7932f37 100644
> --- a/drivers/gpu/drm/radeon/ni_dpm.c
> +++ b/drivers/gpu/drm/radeon/ni_dpm.c
> @@ -2127,7 +2127,7 @@ static int ni_init_smc_spll_table(struct radeon_device *rdev)
>                 if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
>                         ret = -EINVAL;
>
> -               if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
> +               if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_SHIFT))
>                         ret = -EINVAL;
>
>                 if (clk_v & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_SHIFT))
> --
> 2.26.2
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
