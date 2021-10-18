Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C250431794
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJRLlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJRLlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:41:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4216CC061745
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 04:38:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i12so40696669wrb.7
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 04:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=izAChMKfU4M1JtEGtK63C3jheOqpGSqPDw4xf2Pzy7E=;
        b=fewHGW7vIwSWex8bkszpvWTo47fUznS598hQauS06eYBYCGz6vUuZ5k1Nz4huioQtM
         RSIaWO3S7nEMSl9piHQ/NJ/ZFpx/yQQ9efLjxR9IsQFN8M3tOGdynTFOPZ4Fw5tm4ww5
         J8Z6RgYKi6peEYkQl5F4svOc6TWnjN5NTSGeM8Gvn9wYNLSCFW8wEBfjDI+bZYo2kfVP
         Fdg2Msr3zcLY1R5QByOkNWBxpcI48K9FSxEOULQWzq/FmBxbVhNwYB+ePNDD+M2IdzH/
         6IO4KxJ2iOBuvmDQ7hS2KkAiyNR/p9eTKvLje6+k/6IZamD1UiRXz8Ukz5edAp+3jrLn
         AZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izAChMKfU4M1JtEGtK63C3jheOqpGSqPDw4xf2Pzy7E=;
        b=wbLvZMtHsWJUt3xZ7SUz2UsPisimmSGBgvl+SsKM3Y99aWd0nkXcDj5N/KHTCwMy+9
         A1JhCW/hMzEB/19oEHZYV+LODoLbkuZYmUhIIfu8y35Zb7+OkuEO5uqmGQuiiPp2CqvL
         XgJ/+c9FfDchhh7xBJqe5dul/i981SIGAj447Fo533aLw/18pfVYv5Jm0YR3M3n9yTDp
         2BY9glpWOxzoKETw5j+RDBhoxGeNdj+J2QQH2lfq043vH3kwqzTf6yd6n/ps387lEnKN
         +8GuKc3Uc5GJX3UTd4Si0zeLgU8DdhRhPsHF2AHPCbXMg4Q3kb/8PUoJeMYO81Z0ye52
         Q3Ng==
X-Gm-Message-State: AOAM533LxdxuJI0udIiJuL6hLuyaefh/bESXGEqajRqFx5/7FPCSmkry
        Wea6qVbix+m1frAHwZR/I+9iRN2OtRYjRi2i
X-Google-Smtp-Source: ABdhPJxauBtLw8WWbhOtAf35iDo3MhCEFh3QfeIBCE6PrLfoWQRRcRu3dNH4TYeyLp2sRkClnLSa+A==
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr34381292wrg.23.1634557129700;
        Mon, 18 Oct 2021 04:38:49 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:b2b3:1133:5bdb:b2f2? ([2a01:e34:ed2f:f020:b2b3:1133:5bdb:b2f2])
        by smtp.googlemail.com with ESMTPSA id b3sm12549662wrp.52.2021.10.18.04.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 04:38:49 -0700 (PDT)
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after
 alarm
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=c5=a1?= <petr.benes@ysoft.com>,
        petrben@gmail.com, stable@vger.kernel.org
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
 <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <37bc3702-bc98-dc54-e9c7-bf9bc92432f0@linaro.org>
Date:   Mon, 18 Oct 2021 13:38:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2021 13:28, Oleksij Rempel wrote:
> Hi Michal,
> 
> I hope you have seen this patch:
> https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix.de/
> 
> Are there any reason why this was ignored?

No reasons, I was waiting for some tags before merging it. But I forget
about it when reviewing the current patch.



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
