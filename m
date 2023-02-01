Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE9686541
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 12:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjBALTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 06:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjBALTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 06:19:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD9E5EF9F
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 03:18:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v13so17283752eda.11
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 03:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LmkNkwc/roPUBoxOIRfaMs2JmM8/cj5oMwOtaYpttR0=;
        b=DmnxSKU7s6WIyUgSYiMgSy6s+OPOlWELHyjPOLn68AIZ/TRnmhV3B4rswEkHQbvUqk
         Y3nvRwRgX7qEMRWldjUqTrmEmSDuUsjz2RnaVKK2zFbnK3ugSuXqt2Qc9UzNq+PH4GYa
         3JmaNKcn2jcFB4r0BxD6Ps+GbVUFcFbRJueFzcaHEro9R1tC7CXCefdo1+OY7EHnVhSN
         ti3PkVGtzR4StfY990ViG0dDVR2WOvgj5yqV57QApSP3p+XmiqksrGtrUY3ujHsn51/0
         wj9xJVvbjXF93sMxw2SACtJjegkpiv1BjUW+GnKLrWsd8ORz9/1eYHzsBiEvExRHNjoF
         5sWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LmkNkwc/roPUBoxOIRfaMs2JmM8/cj5oMwOtaYpttR0=;
        b=fYKoJ5eHFIw38mjkdv1D9aKslbNWNFq8/W0UMAUyPvuv/rw97j8AWQGX3ths1Y+ZiW
         zHghxwj18PQUU7NV73LjNhoGiohTmePg1tdXoDh79EciD5xQ3NcXnMrKqUf+DK6sjsTH
         VGosNmKyZ/NRCaRX30fwsLJlVLORLU4+5i57zbJraICDyr6ZTkUcNdN523338kXZE9zC
         FBLKySLJW0y+//1eeX7GMtd8N+C/7R31pIBpYQaDEY+qIyZy6x6QT8O+XzE9SVhHP5QG
         qlWNhSPRqLxkODBoW2G5TvkLqGgQYmuP3SGf6zC8cXsXnszHYHFmwztItFhDszfYjzOd
         2/0g==
X-Gm-Message-State: AO0yUKWm2t+f5dHjfe7Zx+T1fqChL4nqWgqYmbV4McmYj0Tit3Hda2ob
        Krv2Qb8s0WdQVWBjaxKbKjqxgw==
X-Google-Smtp-Source: AK7set8RBAqgYqL/UHyvViSxh65icsNQZmgKHSdri9gKC/VCfijAbqmy6paNIDeBSH0CtXt3GutdKw==
X-Received: by 2002:aa7:cd53:0:b0:4a3:43c1:843c with SMTP id v19-20020aa7cd53000000b004a343c1843cmr1313349edw.16.1675250311234;
        Wed, 01 Feb 2023 03:18:31 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id t21-20020a170906065500b007a4e02e32ffsm9949372ejb.60.2023.02.01.03.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 03:18:30 -0800 (PST)
Message-ID: <93bec467-d8ff-efd0-4c7f-69e6bd42afbb@linaro.org>
Date:   Wed, 1 Feb 2023 12:18:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 01/23] interconnect: fix mem leak when freeing nodes
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?B?QXJ0dXIgxZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Georgi Djakov <georgi.djakov@linaro.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-2-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-2-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1.02.2023 11:15, Johan Hovold wrote:
> The node link array is allocated when adding links to a node but is not
> deallocated when nodes are destroyed.
> 
> Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
> Cc: stable@vger.kernel.org      # 5.1
> Cc: Georgi Djakov <georgi.djakov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
> index 423f875d4b54..dc61620a0191 100644
> --- a/drivers/interconnect/core.c
> +++ b/drivers/interconnect/core.c
> @@ -850,6 +850,7 @@ void icc_node_destroy(int id)
>  
>  	mutex_unlock(&icc_lock);
>  
> +	kfree(node->links);
>  	kfree(node);
>  }
>  EXPORT_SYMBOL_GPL(icc_node_destroy);
