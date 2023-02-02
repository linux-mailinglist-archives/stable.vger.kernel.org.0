Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616A8687B74
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 12:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjBBLFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 06:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjBBLFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 06:05:42 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3235B8349D
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 03:04:58 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so1075223wms.2
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 03:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=84LdQG7FtMDJskUXUfOk9gQLMSBtSXh4k9NsYiJXRp8=;
        b=YY/PxCI0eSZTB1pdl42r362jpO42bOCq9Yw+LX8Ec62FpLPKaXUgZMLo4Up3JrS8Mp
         w/GqZ+LnGAQ/5Pj5cAd2zhHn6wzlhbFjrftMDnUqEhBMAlV1EQV0dNVXzBALcKPmHHe5
         NPly/afncSbS4UlFwDmGuDJxRC79BghUj/WdQ+RF205Q76FrLNzY6z3WqmJfgTOwOkGY
         uccm2bazfSmmgIa7yT6+oV+DNtsBK3Z/ydro3dd5QZ3k7Nt0Uxciowi5vfJXF3jeHPsP
         ELWV3AgenUEy3XigQD2p6ix69Fn5VHeqgUwHjfloJ369zdyxPEgbUYu5j7uE/cgZvDzt
         haag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84LdQG7FtMDJskUXUfOk9gQLMSBtSXh4k9NsYiJXRp8=;
        b=IuKYRk+srvSi6y9ZiD+AKkc707YcznSYg6eQ6r8Y3vknW+epg8D18VymLTDnYS8avc
         60Md2hyRAfPP2esfFDxDIvpWInzKUYgOhhoUFgjYuc3tpR6j1jmoxY1wmUszDbYCH50X
         fdJuXaSOGVlpwj0Jc75o0t/uibcJHSsG0k0CAvxR0wxNHhSUtySaecfpsVfGlW/d2uRf
         V83B/uMBav5XzvlS/F+aI8I05HM5+M95k8+giN7tgYK3UgtE7Gml6oUBf0Bb5EMkSoNN
         HruDbGQfV8Fo0+ITTgsBchMIh4tfDirEmKQbIbIiVC5kurtNqNPTlMqmItF83ild/61b
         P/DQ==
X-Gm-Message-State: AO0yUKUhdGBRR7jVFLwsV/p9EYv5EVZ4iLBq2tC27/JNMmqGzG9fk1X4
        dXbiEPtw1b7YiFR2HfroAOOwCg==
X-Google-Smtp-Source: AK7set9bhwS4j0q/7L9EvuG4nE3Tl5dVTO9q14HaPAJVMDLA/gZQo/8p5swe04iHnL1tsJwtBlw2iw==
X-Received: by 2002:a1c:7906:0:b0:3d3:49db:9b25 with SMTP id l6-20020a1c7906000000b003d349db9b25mr5335894wme.26.1675335892189;
        Thu, 02 Feb 2023 03:04:52 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id r38-20020a05600c322600b003dd7edcc960sm4125824wmp.45.2023.02.02.03.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 03:04:51 -0800 (PST)
Message-ID: <e706bb89-bb79-33e3-f319-268ec4695015@linaro.org>
Date:   Thu, 2 Feb 2023 12:04:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 15/23] interconnect: exynos: fix registration race
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
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?B?QXJ0dXIgxZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-16-johan+linaro@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230201101559.15529-16-johan+linaro@kernel.org>
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

On 01/02/2023 11:15, Johan Hovold wrote:
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to trigger a NULL-pointer
> deference when either a NULL pointer or not fully initialised node is
> returned from exynos_generic_icc_xlate().
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
> Cc: stable@vger.kernel.org      # 5.11
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/interconnect/samsung/exynos.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
> index e70665899482..72e42603823b 100644
> --- a/drivers/interconnect/samsung/exynos.c
> +++ b/drivers/interconnect/samsung/exynos.c
> @@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
>  	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
>  	struct icc_node *parent_node, *node = priv->node;
>  
> +	icc_provider_deregister(&priv->provider);
> +
>  	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
>  	if (parent_node && !IS_ERR(parent_node))
>  		icc_link_destroy(node, parent_node);
>  
>  	icc_nodes_remove(&priv->provider);
> -	icc_provider_del(&priv->provider);
>  
>  	return 0;
>  }
> @@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
>  	provider->inter_set = true;
>  	provider->data = priv;
>  
> -	ret = icc_provider_add(provider);
> -	if (ret < 0)
> -		return ret;
> +	icc_provider_init(provider);
>  
>  	icc_node = icc_node_create(pdev->id);
> -	if (IS_ERR(icc_node)) {
> -		ret = PTR_ERR(icc_node);
> -		goto err_prov_del;
> -	}
> +	if (IS_ERR(icc_node))
> +		return PTR_ERR(icc_node);
>  
>  	priv->node = icc_node;
>  	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
> @@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
>  			goto err_pmqos_del;
>  	}
>  
> +	ret = icc_provider_register(provider);
> +	if (ret < 0)
> +		goto err_pmqos_del;

If I understand correctly there is no need for icc_link_destroy() in
error path here, right? Even in case of probe retry (defer or whatever
reason) - the link will be removed with icc_nodes_remove()?

Best regards,
Krzysztof

