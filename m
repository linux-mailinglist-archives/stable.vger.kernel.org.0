Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C34C688D47
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjBCCuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBCCuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:50:02 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5DC27D7C
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:50:01 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bk15so11674817ejb.9
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WR8hXlu/BYrtVyPTl82muaFen2DxWKhdrgyPId7s8/M=;
        b=QHEwTZmDNwcplXS/XoctQn0Xkc720zEqw4643z2uVQvFLOCQJBhUOWWQ8B9oiafj2m
         hTkyPEWCnczxcdz2r/Xh1V8vFUGvA1sOyAcTQoAvw/BTxKweVaZThjL7NSPSeIcSTaEV
         As7r4+yu5KhZmViQq8ocdMUm6Cw6ZDLqGdzSOYEBp+MJL9PsfKrAK+9wsgAr1MLDGHMe
         MXGxh5mXHXtnzloo6cyhiPXspkBuRnjEAmGdeur7qyvZ0faVZterqHdV8/xy0DxibmOh
         yvu3ZW0+KYPBooUGJW945SUBXCUXmRRlmjmZBqWOskY1FlWpDHYXd7zYBa8qiuY8UIHs
         OEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WR8hXlu/BYrtVyPTl82muaFen2DxWKhdrgyPId7s8/M=;
        b=vLnY1CClWSIDAdXpsJmTMZCpiU0cAymAUHBN1OepKjC2QDecdyZPOpKbCmQUT5cEWZ
         Zmwsdgwj0HIQrBDRkYEqlwKMiq3Gn5CElNvAf4k1k6yM+yiZO2t9OfKAt/m7tkNnYz40
         kmOg90eqHra1HNSPt2/TLOT09gjx6agstwwjHe/XuP0V2aDVNbzw0k5g/i/l5a2d+PTK
         KVyOf2BLgmEkybhwvCt9o9CptpBjO49YE6blW2kFDu+F/Vc0cxNoGrSCMs/PS496Xks4
         torGbv0On0DPJyVYOzas/YlH2MRcobRORq1opDzU6sdHD0k1AzosfvxW6s3L4GI1kdRf
         rDvA==
X-Gm-Message-State: AO0yUKXctdmFlQwDiMnZNd4QLCESiv9QwHoW840UGu5b7jllfut+d767
        2i6ccw+DQF2+sLY7IkQ4KnqJAQ==
X-Google-Smtp-Source: AK7set+ecVqLmDG6TS3QSNxUGtbY8WK8wzUz1GEqh0+5MQf75lNeUmIJohQGjASr/HdMApxBTVZn+g==
X-Received: by 2002:a17:906:edc4:b0:885:5231:359c with SMTP id sb4-20020a170906edc400b008855231359cmr7688184ejb.5.1675392599356;
        Thu, 02 Feb 2023 18:49:59 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id rh25-20020a17090720f900b00887830e535csm656959ejb.159.2023.02.02.18.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:49:59 -0800 (PST)
Message-ID: <63d1da22-84b0-1b02-2766-99cc298a8ac4@linaro.org>
Date:   Fri, 3 Feb 2023 03:49:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 04/23] interconnect: imx: fix registration race
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
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Alexandre Bailon <abailon@baylibre.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-5-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-5-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1.02.2023 11:15, Johan Hovold wrote:
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
> Cc: stable@vger.kernel.org      # 5.8
> Cc: Leonard Crestez <leonard.crestez@nxp.com>
> Cc: Alexandre Bailon <abailon@baylibre.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/imx/imx.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/interconnect/imx/imx.c b/drivers/interconnect/imx/imx.c
> index 823d9be9771a..979ed610f704 100644
> --- a/drivers/interconnect/imx/imx.c
> +++ b/drivers/interconnect/imx/imx.c
> @@ -295,6 +295,9 @@ int imx_icc_register(struct platform_device *pdev,
>  	provider->xlate = of_icc_xlate_onecell;
>  	provider->data = data;
>  	provider->dev = dev->parent;
> +
> +	icc_provider_init(provider);
> +
>  	platform_set_drvdata(pdev, imx_provider);
>  
>  	if (settings) {
> @@ -306,20 +309,18 @@ int imx_icc_register(struct platform_device *pdev,
>  		}
>  	}
>  
> -	ret = icc_provider_add(provider);
> -	if (ret) {
> -		dev_err(dev, "error adding interconnect provider: %d\n", ret);
> +	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
> +	if (ret)
>  		return ret;
> -	}
>  
> -	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
> +	ret = icc_provider_register(provider);
>  	if (ret)
> -		goto provider_del;
> +		goto err_unregister_nodes;
>  
>  	return 0;
>  
> -provider_del:
> -	icc_provider_del(provider);
> +err_unregister_nodes:
> +	imx_icc_unregister_nodes(&imx_provider->provider);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(imx_icc_register);
> @@ -328,9 +329,8 @@ void imx_icc_unregister(struct platform_device *pdev)
>  {
>  	struct imx_icc_provider *imx_provider = platform_get_drvdata(pdev);
>  
> +	icc_provider_deregister(&imx_provider->provider);
>  	imx_icc_unregister_nodes(&imx_provider->provider);
> -
> -	icc_provider_del(&imx_provider->provider);
>  }
>  EXPORT_SYMBOL_GPL(imx_icc_unregister);
>  
