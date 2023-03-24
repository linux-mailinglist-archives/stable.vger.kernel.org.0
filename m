Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400D06C880C
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 23:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCXWGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjCXWGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 18:06:35 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7DE1E5F8
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 15:06:34 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y5so4011867ybu.3
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 15:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679695593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AW96lDx5vwowhGiHzDVKGLsiV7fUhA67Ww+wttjBEwU=;
        b=kpJyuBzmaRYbioRqb5vGqry2GHgycmPyUnnxvdAANb2s+I5+UckR9viLl/8kUnwtsf
         Q7+LDDM69Vu2oFwkJGdq0pk81UJndycZyxuRQhPnR7WIn7TI116XPFHuAu6wWLccOc8o
         2sBeL91RE2283BvpWqZ1lLdl5THJKMNCJ+BTayM2nZ2dJsHu0EO7S7GQgtCqrYSJvdwW
         UU7aT8YPVkRLG1i0zyfT4IEd5slRhq8VTdfFrM8OfTioFMwOV0gD8IBlT0YtUSuoNtQu
         539xnoMEbH6SAZf8TaExkU7HmF+MVxlf2Ed51omRr2X6PZWYSIxHlxDf25bEFwSFH7oV
         //iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AW96lDx5vwowhGiHzDVKGLsiV7fUhA67Ww+wttjBEwU=;
        b=4UeExowutavaQ8AWjDAxLUYS0yHx1j58vBQzaoFiOTcKLakQPtk6f1tOJrAVDmobgs
         8fAoUJ5z5fE40PUsRJewkh1dwm/AALwcRvCdlRE8hQfJHTXBBx1sIzbL8ynuZZ3LRK2Z
         O1QdU+ixpzMbd6vHawtSoW2MBo6CBcrA47340zrI2jIq8PQ75Sj1ReIoGigVorPYLp4Z
         0T530T/FzjCTrp3Rm1oA3yxW/70Pb1H46yHAjaEeGJejuYUA0xVu0IRJtKKIvBKrvczZ
         kJSmLiB9JTbTNZSV0cu2KqKwrX0u/friDv+N/3S4HDEEiS7unJB3OJo7JgxM+R7oN0oW
         2sKQ==
X-Gm-Message-State: AAQBX9cY5oPJRt7xkCrDGjenc2MLCIME2AtNdl43dyw5gx8kEIXaa07W
        WI3ClCW69k8WGeBHyxlpTTsb4pkvv7m2MsAY1ACIMQ==
X-Google-Smtp-Source: AKy350b22KWd/52YQxPAH9uA2YhVFFyLDy325ozIEZ34++SQJC7q83qVmJTG2A31rDN5OZEc70zCmWabGGvncpkmyxQ=
X-Received: by 2002:a05:6902:1501:b0:b4c:9333:2a2 with SMTP id
 q1-20020a056902150100b00b4c933302a2mr1857678ybu.9.1679695593310; Fri, 24 Mar
 2023 15:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230306100722.28485-1-johan+linaro@kernel.org> <20230306100722.28485-7-johan+linaro@kernel.org>
In-Reply-To: <20230306100722.28485-7-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Sat, 25 Mar 2023 00:06:21 +0200
Message-ID: <CAA8EJpoMKRY_w1eM6XVx6R3+2Mi3y=AbbvXQcFF-ccTfV_j2AQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] drm/msm: fix vram leak on bind errors
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Craig Tatlor <ctatlor97@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Mar 2023 at 12:09, Johan Hovold <johan+linaro@kernel.org> wrote:
>
> Make sure to release the VRAM buffer also in a case a subcomponent fails
> to bind.
>
> Fixes: d863f0c7b536 ("drm/msm: Call msm_init_vram before binding the gpu")
> Cc: stable@vger.kernel.org      # 5.11
> Cc: Craig Tatlor <ctatlor97@gmail.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/gpu/drm/msm/msm_drv.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


-- 
With best wishes
Dmitry
