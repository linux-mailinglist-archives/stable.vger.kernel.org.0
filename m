Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9795D338A72
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhCLKnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:43:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36205 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhCLKnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 05:43:25 -0500
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKfGN-0003gb-Fn
        for stable@vger.kernel.org; Fri, 12 Mar 2021 10:43:23 +0000
Received: by mail-ej1-f69.google.com with SMTP id gn30so9872668ejc.3
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 02:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3krHMf8FRMVK6CtYPofCBzLrKQGSEz6pFoDSv1Aq7s=;
        b=SD7fN/NrSla8bc8RoTj6LpxDM+ItCr6fVDL3z7R9p/tufjahBnIOmDL1tEaSYbaP5y
         PeZLrtiQlnLW1vgUJt2Ung5jKUNWsTRBqfYt59KgI1kzoV+ti3SS4o0Eu17ckTcKnJMu
         DXGmHlVrhCf9J8fVvKdJk5UHxzNdW1UOrjQnYHwHG7t5W/9RgvdlnpJ+R61MQ6giEw8y
         v7MvFzuqVtvvhH1ro9EzWVOeusHVXpqclK5x4lrE5LXbMABSg+7LKk8z+/lTZUVsYSSW
         oDQWLKRmwT2Nw8J4DkipAwMIaj93VdeaJDcXpB+7nRisJeVqPVRe0XU5M7WeqY5wEMXm
         Enyg==
X-Gm-Message-State: AOAM5335DYSTe2ponHPoreM4l7YvFccdWTblWURvZUShgFII8/Vv+YiY
        phPHOnpnxTdwkA6PZCbvh+RpeSc5WcSxH1+K2J9J9Qy/TCeciAVjtfvfEreBsX/iFuPpTZ0TGia
        66hcYo0RAknjxEWEmNRZcREKi3pfDbKGZZg==
X-Received: by 2002:a50:d753:: with SMTP id i19mr13381981edj.43.1615545802824;
        Fri, 12 Mar 2021 02:43:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNugyXYmLMwKIxfkBcrE+fq0BL9z6U0OsA4mFutDTaa/42Ml2+NTvEwFgIlJazoXpPMTP1JQ==
X-Received: by 2002:a50:d753:: with SMTP id i19mr13381969edj.43.1615545802665;
        Fri, 12 Mar 2021 02:43:22 -0800 (PST)
Received: from [192.168.1.116] (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id c2sm2524450ejn.63.2021.03.12.02.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 02:43:22 -0800 (PST)
Subject: Re: [PATCH v3 1/2] ASoC: samsung: tm2_wm5110: check of of_parse
 return value
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        stable@vger.kernel.org
References: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
 <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <98d492b4-4d1f-fcc7-c8f0-5191b1a31e1c@canonical.com>
Date:   Fri, 12 Mar 2021 11:43:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/03/2021 01:35, Pierre-Louis Bossart wrote:
> cppcheck warning:
> 
> sound/soc/samsung/tm2_wm5110.c:605:6: style: Variable 'ret' is
> reassigned a value before the old one has been
> used. [redundantAssignment]
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> sound/soc/samsung/tm2_wm5110.c:554:7: note: ret is assigned
>   ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
>       ^
> sound/soc/samsung/tm2_wm5110.c:605:6: note: ret is overwritten
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> 
> The args is a stack variable, so it could have junk (uninitialized)
> therefore args.np could have a non-NULL and random value even though
> property was missing. Later could trigger invalid pointer dereference.
> 
> There's no need to check for args.np because args.np won't be
> initialized on errors.
> 
> Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> ---
>  sound/soc/samsung/tm2_wm5110.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
