Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2146423AB1
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhJFJlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhJFJlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:41:53 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20195C061753
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 02:40:01 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v25so6897021wra.2
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 02:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZM0aAVFYc0rlVYzXR6lOn7gapiy86clYgqFzWRzZRQM=;
        b=fC5Jwc7vl2j0wd07nXEcPOs5huHXlNmaWEKKt0tHPFuuReV5LClasR//BkXBScnHrM
         q6iNasUf4x6wgxMNTTuRqtnLnKfMKCPK059UT/EuwjVn56CdUL30oLwJsRWFwwhN7pF9
         wmX31Mp5m8jtCAif8OmBIKuA1olg6pPiC4whbfoOi+CpRpkS0oVI80l+OB947XIfnInW
         G3p7mklqYIPFJMUzjYto553mN4v/INi6kjV0mh6Z7kbRr3zD5PZjez15P4/eIO900Csy
         sRE+OBTAthgjJY8OUYgbmvA1wvII7jwjjBkblWfTleShhl/mKWVzhQjYNGYfrPeigrXQ
         dX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZM0aAVFYc0rlVYzXR6lOn7gapiy86clYgqFzWRzZRQM=;
        b=jfd5ga+wXUsKj62UryVQCJiV0+CcFFln1tgCI1Bpd7L4ssnsayDln5NZjswfDykSlC
         FyCDhpJsyxnjdx131OHX+nO4LfJ+6ZoOSHUqmOAQKoXpk0hMR5pT4SDiyozTSepHZcTR
         T/QK0kqQCbuNqE1bugKDb7l96V7nEAWUqLUiZ8B2KB4+jSGh4UIEG3FVltxNVYH1kLlo
         b6kUqvK+kVK1JV6FRLbTR/67okCK+YLYK31palICObPcj9Zr/BazPXaq1ewBQ1JIBsix
         n2g7JZxgnDpNeRR/cOAepevrsx6suAwZ8LsZwGniSavigNUAnm945o5kXWjVuAYm/dDU
         AMiw==
X-Gm-Message-State: AOAM530hUGM364bEUvCL8U8oTLRP/rBxT6WtGYI34Hm+Vy/2ewf60TG8
        njjygg1cMTpKX+4kZ+GCCJ6lH3SwW9+CMg==
X-Google-Smtp-Source: ABdhPJxGYgn9BzjANB+d9fA29bz3DBw2Zage6bi9uAkkHwPusS7iJfx3UOVWBqimn8dOJYmXd8rnkQ==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr96789wmi.66.1633513199392;
        Wed, 06 Oct 2021 02:39:59 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:278:1f59:2992:87fe? ([2a01:e34:ed2f:f020:278:1f59:2992:87fe])
        by smtp.googlemail.com with ESMTPSA id u24sm4454538wmj.48.2021.10.06.02.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 02:39:58 -0700 (PDT)
Subject: Re: [PATCH v2] thermal: Fix a NULL pointer dereference
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Ram Chandrasekar <rkumbako@codeaurora.org>,
        stable@vger.kernel.org
References: <1631041289-11804-1-git-send-email-quic_subbaram@quicinc.com>
 <55999619-22c7-63fd-7006-f91f144e4a60@linaro.org>
 <7930989e-baf1-04f4-59ad-d65122149b9b@quicinc.com>
 <f869ea55-f071-f971-282e-31878a0f0b68@quicinc.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <ca7eb02d-2b21-9bc0-7abe-2a4e6ab0a07b@linaro.org>
Date:   Wed, 6 Oct 2021 11:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f869ea55-f071-f971-282e-31878a0f0b68@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/2021 00:09, Subbaraman Narayanamurthy wrote:

[ ... ]

>>> The tests can be replaced by (!data->ops), no ?
>> Thanks Daniel for reviewing the patch.
>>
>> I agree that even if a sensor module is unregistered, that would call
>> "thermal_zone_of_sensor_unregister" which would eventually set NULL on
>> get_temp() and get_trend() and "tzd->ops" as well.
>>
>> However, of_thermal_get_temp() is trying to call "data->ops->get_temp"
>> which comes from a sensor driver when it registers. There is no
>> guarantee that it would be non-NULL right?
>>
>> Thinking of which, I think having both checks would be valid.
> 
> Hi Daniel,
> Do you still have any concerns with this change?

Yes, let me answer to the initial patch.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
