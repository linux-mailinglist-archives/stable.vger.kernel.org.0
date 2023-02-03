Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D716A688D6F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjBCCyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBCCyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:54:08 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FD8A7F9
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:53:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so11748877ejc.4
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/gjAdjMgntSc2V+0JCh5W3UQ5YtCxuSW7UX1/RImx9U=;
        b=r2/ojgy3wlbssfealO65rOyentvFfKc8Xc2q5F6Gawxe2muvitDP3D/qinUOSurCEE
         GdYWGgJwNKR4rLcIHwkqfsloahAJkbz7K33id165R9BHg5qGAROmo3pVLOqNE97wNbuB
         DzQrqzZLZtlTX090m9uR7vWaML4wvc3LZtnNQGEJuVVmMeUUUf86/nxZbpoa5/Mc3wFJ
         mS2Bx/FFieIx9jCC1QRcBWueb4N3FNzNuoQfpT9+R5IRWi9uf6KI1EPiBLLf/96PuR9k
         2hTsQw1ZWwXxRs1UV+1jsic2DTFBPf+4DbCkbjT/VGiH7oB1O9XCfpnGnhIA35SwD1rn
         8QDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gjAdjMgntSc2V+0JCh5W3UQ5YtCxuSW7UX1/RImx9U=;
        b=wPQl1KOVXsL4uvKGOvC00LDPv6wDR/aetjEI5p1sABNvMuWAfWyPzbiKM+COve00P7
         /QqGRDOMovMtZQcx/Pfw9HpFBtNAmc3f61IHUVWXpr5JueVt29pQBpU1F9ux16XEQr7N
         RFdrk34ZJX4/5Z28eM2R+NZaipSudXVfDylMGmTHwt9M5IvCQYeNWtcC7FDP2SdsqiX5
         LOG1fAsFhWtgZn6W8CLtzUDx3VVUXvrKOtt/slgnehkZ6tclocuH/CdsRC1pTUEIdZ4E
         Vesk7khxJ+7sI/tIp1hXRhrpWYKCPkKpyhd5W08tsfjvQd9ibkFN4rx8hpoVXN0VerWj
         cUbA==
X-Gm-Message-State: AO0yUKUfDGdeKzNjkqDa16/XWkqWLS2Rv83rvMA7qT8MkZKbisNU7KKY
        3IU1A9np0pgqg0bGaz9ZEyovgA==
X-Google-Smtp-Source: AK7set+exeVHhx5lH4QHq60LJIjL4PJsX/fg5A7/SPoAayXl6UnezMk0KP2iYWt4w2IOyrwX9gLBrw==
X-Received: by 2002:a17:907:3e82:b0:885:8f79:d6d7 with SMTP id hs2-20020a1709073e8200b008858f79d6d7mr11541664ejc.61.1675392836850;
        Thu, 02 Feb 2023 18:53:56 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id r5-20020a170906a20500b008710789d85fsm665313ejy.156.2023.02.02.18.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:53:56 -0800 (PST)
Message-ID: <92cbad8e-6e18-4ecf-17a7-3d40a429cad9@linaro.org>
Date:   Fri, 3 Feb 2023 03:53:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 08/23] interconnect: qcom: rpm: fix registration race
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
        stable@vger.kernel.org, Jun Nie <jun.nie@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-9-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-9-johan+linaro@kernel.org>
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
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: 62feb14ee8a3 ("interconnect: qcom: Consolidate interconnect RPM support")
> Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
> Cc: stable@vger.kernel.org	# 5.7
> Cc: Jun Nie <jun.nie@linaro.org>
> Cc: Georgi Djakov <georgi.djakov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/qcom/icc-rpm.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
> index da595059cafd..4d0997b210f7 100644
> --- a/drivers/interconnect/qcom/icc-rpm.c
> +++ b/drivers/interconnect/qcom/icc-rpm.c
> @@ -502,7 +502,6 @@ int qnoc_probe(struct platform_device *pdev)
>  	}
>  
>  	provider = &qp->provider;
> -	INIT_LIST_HEAD(&provider->nodes);
>  	provider->dev = dev;
>  	provider->set = qcom_icc_set;
>  	provider->pre_aggregate = qcom_icc_pre_bw_aggregate;
> @@ -510,11 +509,7 @@ int qnoc_probe(struct platform_device *pdev)
>  	provider->xlate_extended = qcom_icc_xlate_extended;
>  	provider->data = data;
>  
> -	ret = icc_provider_add(provider);
> -	if (ret) {
> -		dev_err(dev, "error adding interconnect provider: %d\n", ret);
> -		goto err_disable_clks;
> -	}
> +	icc_provider_init(provider);
>  
>  	for (i = 0; i < num_nodes; i++) {
>  		size_t j;
> @@ -522,7 +517,7 @@ int qnoc_probe(struct platform_device *pdev)
>  		node = icc_node_create(qnodes[i]->id);
>  		if (IS_ERR(node)) {
>  			ret = PTR_ERR(node);
> -			goto err;
> +			goto err_remove_nodes;
>  		}
>  
>  		node->name = qnodes[i]->name;
> @@ -536,19 +531,25 @@ int qnoc_probe(struct platform_device *pdev)
>  	}
>  	data->num_nodes = num_nodes;
>  
> +	ret = icc_provider_register(provider);
> +	if (ret)
> +		goto err_remove_nodes;
> +
>  	platform_set_drvdata(pdev, qp);
>  
>  	/* Populate child NoC devices if any */
>  	if (of_get_child_count(dev->of_node) > 0) {
>  		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
>  		if (ret)
> -			goto err;
> +			goto err_deregister_provider;
>  	}
>  
>  	return 0;
> -err:
> +
> +err_deregister_provider:
> +	icc_provider_deregister(provider);
> +err_remove_nodes:
>  	icc_nodes_remove(provider);
> -	icc_provider_del(provider);
>  err_disable_clks:
>  	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
>  
> @@ -560,9 +561,9 @@ int qnoc_remove(struct platform_device *pdev)
>  {
>  	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
>  
> +	icc_provider_deregister(&qp->provider);
>  	icc_nodes_remove(&qp->provider);
>  	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
> -	icc_provider_del(&qp->provider);
>  
>  	return 0;
>  }
