Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE55B5FDD
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiILSHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 14:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiILSG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 14:06:57 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A2140E24
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:06:51 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k10so16172974lfm.4
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 11:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=YId2qFc2g35/E70lSaVSWi+LP5D0a4HgnSmJlhd/KK8=;
        b=jHsdErwX5dPLdoPW3dgGmcCoDgcakypIm+495tvOKtQL9QPtt8V7/gJ1h9q5lB7rwn
         6gFbbO3m+ZzJRGyxQO6lM6CRqm6uPwUTtqDDolmemItUbKsGh2vKuFIvy+y1ec4MzufQ
         Cx05prXleITG2xd7YWduVE4k3k/9CSrk6Z3j8KvYuCSKeLDMMn79fHpxx7lHh1qvslW7
         SHfTyc96VKkN0HTMzfYoEUfkLuFU180L8Z0D8gv8moFUpOcMTNAeBeTzQHCkPUziVQvW
         YHlm2eCYkTORmbcUMbmlWYl0Psi3+D/Xv68JwW69eh2CrkfN7klNFNe1zWZUXdHxSWbM
         L8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YId2qFc2g35/E70lSaVSWi+LP5D0a4HgnSmJlhd/KK8=;
        b=ATAsrNiEItiWc47FpFGE53PyoeEoArOMHtbicjxHW/DtlX4VSmAu780C62KKA6fNtk
         ZCovGG+rxneo6Y/Q13z3kOM4+mHjw8C19aFYBgytsD0prcR3OGGHScQPZ2H9XPmn5I7Q
         qn3pPKsY5tCOEgYsTbs5h6i5YlZIw8pj8J6YZYvbU134PLI5HJAZhPgmLJOGYcK/pD80
         QSy9tYR3bbwSsMab0JPF3uzfU93ROB3h+dmRXdG0pAOV8t3Qzb3cM0/K6GVAt4xGmrJo
         pmaxshKKFOYMyVfvvWwcOIuYgEZIZHamaqzZRfjWvyE+eemaY27iDUwhBmDs/TD36tK2
         QKsg==
X-Gm-Message-State: ACgBeo0CdHrCZI4N8/yEk/eSH8z45GPXa4b0Zv89NFI51XJb8m2pHN8a
        TQgFsKZPamu+hxapSXyS5dyMNw==
X-Google-Smtp-Source: AA6agR72bENrYaV3AGytGeVqlM0eFcCOub+TVap9NDCtWO6DvsFG7u89q0BJcB/dxfhSP2zC9MhO2A==
X-Received: by 2002:a05:6512:1044:b0:48b:49b1:cc85 with SMTP id c4-20020a056512104400b0048b49b1cc85mr9327400lfb.57.1663006009387;
        Mon, 12 Sep 2022 11:06:49 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id e27-20020a05651c039b00b0026bf04aafd2sm1141288ljp.9.2022.09.12.11.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:06:48 -0700 (PDT)
Message-ID: <9ac13738-ea89-e2de-6316-ab8020580569@linaro.org>
Date:   Mon, 12 Sep 2022 21:06:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 3/7] drm/msm/dp: fix IRQ lifetime
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220912154046.12900-1-johan+linaro@kernel.org>
 <20220912154046.12900-4-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220912154046.12900-4-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2022 18:40, Johan Hovold wrote:
> Device-managed resources allocated post component bind must be tied to
> the lifetime of the aggregate DRM device or they will not necessarily be
> released when binding of the aggregate device is deferred.
> 
> This is specifically true for the DP IRQ, which will otherwise remain
> requested so that the next bind attempt fails when requesting the IRQ a
> second time.
> 
> Since commit c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
> this can happen when the aux-bus panel driver has not yet been loaded so
> that probe is deferred.
> 
> Fix this by tying the device-managed lifetime of the DP IRQ to the DRM
> device so that it is released when bind fails.
> 
> Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
> Cc: stable@vger.kernel.org      # 5.10
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> index fbe950edaefe..ba557328710a 100644
> --- a/drivers/gpu/drm/msm/dp/dp_display.c
> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> @@ -1258,7 +1258,7 @@ int dp_display_request_irq(struct msm_dp *dp_display)
>   		return -EINVAL;
>   	}
>   
> -	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
> +	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
>   			dp_display_irq_handler,
>   			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
>   	if (rc < 0) {

-- 
With best wishes
Dmitry

