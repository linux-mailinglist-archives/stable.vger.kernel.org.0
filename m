Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F78307FCE
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 21:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhA1Ulr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 15:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhA1Ulp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 15:41:45 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8DAC061574;
        Thu, 28 Jan 2021 12:41:04 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id z6so6705517wrq.10;
        Thu, 28 Jan 2021 12:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZQDBDX7ysZjWH15k/VD+oczZr4PH6075utJ1xgiXgY=;
        b=oHlkxnKaIiOGZACS9UxXHxQTNSI7Cf3kAEv/slmvz6Fr6NiFpmgruxfX4MNyTwkasB
         QYt4Sbp/LClgIHBtTOO4s/5Uqy5bSHlA42pmWC8og0ee5189WTurNXFr2P4RzcomIong
         1/XFeLRQMFdH/v8QAZ3J5KM6uki8FjmqPKj+M12CVNCm+QghYs4NKDF+z0M/TRUhZqg1
         CgUK9ZcnQYBG0T/c+iRTtaR6wn7EErMTDKGXXQYWa4oczFCR61YH0rmK/xOisN5q65We
         Mqd8EPEqgHiO35rl8Fe61apwXy+FKSFIL5ES5Wz2/ocpzoqu6faCNFqpR+5Xsy2Z9KdN
         /dUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZQDBDX7ysZjWH15k/VD+oczZr4PH6075utJ1xgiXgY=;
        b=EJZRdiO83TstL/sVpR/JszPXfpXXtd0wNc/OCijKXY1MJJISzfT2nkXPvhG+xRbLUe
         UOB7Y549TY3gZ5caWM8tjDD8qlx48r9MeyxOZUWgLWvmZspt2xbETjwijt+K74w35bFl
         Zq6e2ouQowxFk0r6bnQnvdgXFCH6//RlP3w2hgXsS/vHfdsfsd0aYZ/xGutjdVNU/UQo
         35h0Y3+NDh9inCc9hpIDBP5y1BoBSryc5zmwbJHB3D3VLfOkAouhCuRsRVHsZ70e5vGc
         9P+wXS9WQmFG4hHcnfVjQqZiRfsxAO6UBt7YM5I5c1nGSkcosg+tG13BOARyMOjREQAt
         CdrA==
X-Gm-Message-State: AOAM531cGN9poXZA4xC6XjG+WsuhqajreMObJXzKm214klvkC8XdTLqm
        etR/dTrpaabm++ly3RF2KuDYfYmDNEBrVehOreG6JRPkJgY=
X-Google-Smtp-Source: ABdhPJwlenfZHCOiOfMruxm3X3cs5f9FZfYo4d1ePGXG/fE7YrlvrE++5B7mIUl2kqjHSrrwt81TWvaGodsyTveDQsM=
X-Received: by 2002:adf:f749:: with SMTP id z9mr855909wrp.327.1611866463544;
 Thu, 28 Jan 2021 12:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20210127233946.1286386-1-eric@anholt.net> <20210127233946.1286386-2-eric@anholt.net>
In-Reply-To: <20210127233946.1286386-2-eric@anholt.net>
From:   Rob Clark <robdclark@gmail.com>
Date:   Thu, 28 Jan 2021 12:40:52 -0800
Message-ID: <CAF6AEGuXeU18cUKGogtJD7O4SPUgFVQZcw3H-MDXNR5HAXcgFw@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/msm: Fix races managing the OOB state for
 timestamp vs timestamps.
To:     Eric Anholt <eric@anholt.net>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        Sean Paul <sean@poorly.run>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 27, 2021 at 3:39 PM Eric Anholt <eric@anholt.net> wrote:
>
> Now that we're not racing with GPU setup, also fix races of timestamps
> against other timestamps.  In CI, we were seeing this path trigger
> timeouts on setting the GMU bit, especially on the first set of tests
> right after boot (it's probably easier to lose the race than one might
> think, given that we start many tests in parallel, and waiting for NFS
> to page in code probably means that lots of tests hit the same point
> of screen init at the same time).

Could you add the error msg to the commit msg, to make it more easily
searchable?

BR,
-R

> Signed-off-by: Eric Anholt <eric@anholt.net>
> Cc: stable@vger.kernel.org # v5.9
> ---
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> index 7424a70b9d35..e8f0b5325a7f 100644
> --- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> +++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> @@ -1175,6 +1175,9 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
>  {
>         struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
>         struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
> +       static DEFINE_MUTEX(perfcounter_oob);
> +
> +       mutex_lock(&perfcounter_oob);
>
>         /* Force the GPU power on so we can read this register */
>         a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
> @@ -1183,6 +1186,7 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
>                 REG_A6XX_RBBM_PERFCTR_CP_0_HI);
>
>         a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
> +       mutex_unlock(&perfcounter_oob);
>         return 0;
>  }
>
> --
> 2.30.0
>
