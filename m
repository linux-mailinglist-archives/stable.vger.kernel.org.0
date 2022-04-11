Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42D4FB151
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbiDKBWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 21:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244226AbiDKBW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 21:22:29 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4177B1F5
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 18:20:15 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bq30so11234026lfb.3
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 18:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=05X/pQBV2MI76IjGX7fSWAPTcXgd+Vfg/z1tUXGVcQc=;
        b=HL6xtEPacsZ6zEKa4xgS6WpIIMLbpOvanq1tH1R7pc6+fIzJsqF2GEV5pG2IK8elON
         hsvsroTmMu2x5m6FPVW5qBKhOYyboosL2EwPqiYVFTS0jKuLzouTo1KtofUzvDfkD4cs
         xL4TYxCEuMsVT4bKCXdH+iC0gQLvWGlE8UbgE/VycNqIfEchp1SI7lntYmR437jI/5qy
         PkYk45rDiQT6d9iXs7Ub/EwEvcr3AmZ8U60Qn8oScXCXO00MkqUaTkU0MRXRw1mygVbw
         QjrFj7UF2xCBo+z2qiy9CNBAqj9VWhvR7o0CcSEuWatpe88mc5YfMKKWYZ9/DaVqB5d7
         KWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=05X/pQBV2MI76IjGX7fSWAPTcXgd+Vfg/z1tUXGVcQc=;
        b=VxuqZ0JsU28aRSv4BldjrZ89xh6ZrGQ5it2LrlfkqG0MLp7ErGjS8SAqc5NL3nQjC8
         2jDRKMmcBD6UCXM8sHJ29yDy4prxYQTHsbtpAj5NigFQO9JYyLB2Y1Sd6MPFjpIJaGzP
         Ugya5VWU2kBk+cWM5a6Png0WG5xPNtDSU+PD5RzfsCTfTuzWePcJPEzsACrkLiPNzSxO
         9mwpDe/lwAhST8186yx0iwry96TlEKT97HZwJhPhU+8XV0AESrU8wDO0DrZeQYoKuLT5
         LQc0JNyojPgiRGpyO7VVuh0/1+vg9uiOExcxSmscQY/znMlMjQMInqpmi8lfhy0nFa89
         U58Q==
X-Gm-Message-State: AOAM530RWKVtLqtms7l21wasGJzMRvBQm9EANDLN70eQBGs68U1DuIqn
        sfmhO8gmUJXYVI1+lVjOfZ07Hg==
X-Google-Smtp-Source: ABdhPJwgOvDStoVkU5PcymcKMDfs/8Fh2oeLos5hkTOAv/lK50CRFRy3NioQSwXdvc/8q7VUKZrx6g==
X-Received: by 2002:a05:6512:3994:b0:44a:7125:c689 with SMTP id j20-20020a056512399400b0044a7125c689mr20002136lfu.166.1649640014132;
        Sun, 10 Apr 2022 18:20:14 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id b16-20020a2ebc10000000b0024b63f0da2csm154707ljf.13.2022.04.10.18.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 18:20:13 -0700 (PDT)
Message-ID: <7e0592bc-1e8f-0981-cea2-f74402ab5886@linaro.org>
Date:   Mon, 11 Apr 2022 04:20:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dpu1: dpu_encoder: fix a missing check on list iterator
Content-Language: en-GB
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch
Cc:     quic_abhinavk@quicinc.com, swboyd@chromium.org,
        bjorn.andersson@linaro.org, quic_khsieh@quicinc.com,
        quic_kalyant@quicinc.com, markyacoub@google.com,
        jsanka@codeaurora.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220327073252.10871-1-xiam0nd.tong@gmail.com>
 <0788b245-ee8f-25de-dde3-7ff10f6c688c@linaro.org>
In-Reply-To: <0788b245-ee8f-25de-dde3-7ff10f6c688c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/04/2022 03:56, Dmitry Baryshkov wrote:
> On 27/03/2022 10:32, Xiaomeng Tong wrote:
>> The bug is here:
>>      cstate = to_dpu_crtc_state(drm_crtc->state);
>>
>> For the drm_for_each_crtc(), just like list_for_each_entry(),
>> the list iterator 'drm_crtc' will point to a bogus position
>> containing HEAD if the list is empty or no element is found.
>> This case must be checked before any use of the iterator,
>> otherwise it will lead to a invalid memory access.
>>
>> To fix this bug, use a new variable 'iter' as the list iterator,
>> while use the origin variable 'drm_crtc' as a dedicated pointer
>> to point to the found element.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: b107603b4ad0f ("drm/msm/dpu: map mixer/ctl hw blocks in encoder 
>> modeset")
>> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

On the other hand, this code has been removed in 5.18-rc1 in the commit 
764332bf96244cbc8baf08aa35844b29106da312.

> 
>> ---
>>   drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c 
>> b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
>> index 1e648db439f9..d3fdb18e96f9 100644
>> --- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
>> +++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
>> @@ -965,7 +965,7 @@ static void dpu_encoder_virt_mode_set(struct 
>> drm_encoder *drm_enc,
>>       struct dpu_kms *dpu_kms;
>>       struct list_head *connector_list;
>>       struct drm_connector *conn = NULL, *conn_iter;
>> -    struct drm_crtc *drm_crtc;
>> +    struct drm_crtc *drm_crtc = NULL, *iter;
>>       struct dpu_crtc_state *cstate;
>>       struct dpu_global_state *global_state;
>>       struct dpu_hw_blk *hw_pp[MAX_CHANNELS_PER_ENC];
>> @@ -1007,9 +1007,14 @@ static void dpu_encoder_virt_mode_set(struct 
>> drm_encoder *drm_enc,
>>           return;
>>       }
>> -    drm_for_each_crtc(drm_crtc, drm_enc->dev)
>> -        if (drm_crtc->state->encoder_mask & drm_encoder_mask(drm_enc))
>> +    drm_for_each_crtc(iter, drm_enc->dev)
>> +        if (iter->state->encoder_mask & drm_encoder_mask(drm_enc)) {
>> +            drm_crtc = iter;
>>               break;
>> +        }
>> +
>> +    if (!drm_crtc)
>> +        return;
>>       /* Query resource that have been reserved in atomic check step. */
>>       num_pp = dpu_rm_get_assigned_resources(&dpu_kms->rm, global_state,
> 
> 


-- 
With best wishes
Dmitry
