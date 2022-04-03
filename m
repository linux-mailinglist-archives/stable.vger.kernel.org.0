Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D44F0728
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 06:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiDCECo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 00:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiDCECn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 00:02:43 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8F83136B
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 21:00:50 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id j83so6811532oih.6
        for <stable@vger.kernel.org>; Sat, 02 Apr 2022 21:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f0EwDMvEhwYs9akmYrCWRqvVUe1YRZlgKBnIDL/ZNUQ=;
        b=qOMHXnfRgCKuoFkPORBkCQ+KohSKzpJlY8KzB7zJJHhE31XXrcgSzHT48+dE2IJsfa
         ktoa8djUs6V3Wv+b03Zq0cXofKebWFtAUJMlO8MFG5Y0W23Z+mWhV3KGJZ8rTM9HN+vJ
         0NbJZG4nJmGJDEV650TgVR+VbFiUL0ohZVdAhNs4BPoesppjWJAcraX3sYTY45sfHQip
         36Pjb52xen9Nod0kq5+yVtT5TAftDukgvWIZdDspIhkOM+wRsJLQmJqQ6ye8fdnj6m92
         oTwRrEVX727vVL1DanFhtaAMWNssCZPOCCRTMng7ilCH7aUk9tidjgAmMsjfV4zaLCjm
         y0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f0EwDMvEhwYs9akmYrCWRqvVUe1YRZlgKBnIDL/ZNUQ=;
        b=249vsb9WSaqMvYpgleA0Xa6+XnIMVtd8gtq5HdCdKpj08HrJhYlDZ/tY4VtuWg+v9X
         /fWL58S4q9Vv6Qt4sAeaLapvE3OfCQ+7ZsLa6AKDjTd5icNdGWWmLymmB7nyoeTZ1XKv
         Il1jOSBWxAE2YhKqPIf6kpzqqZFgJEfkShuewy43C/n8F4IFgITYS5/gWZNUkQp4I6IE
         0vFv1JkPRab53kUuXuhdA2o9yWq36kcPPjMjdbEbvurnmATlmCT2ZLUcR9gtcp8RZfIe
         mkVod96wO0w0eY/ByoJBQpOJ6irmmkrE0yVknaC92q8+uHkuzjRAr8szJT9rKDPxdFVJ
         ZZTg==
X-Gm-Message-State: AOAM532cyjL9KqNvP6nxV7zdBnEsVG7MLoEIz0TQJzHP8+zGqKfF4nyN
        82/C9BUvDWVMlcdX7xAzwhWICg==
X-Google-Smtp-Source: ABdhPJzKGhwW2UyzAVbE4pY8vf/rF1hWveiUrm7gi9PtjMLz/zTG9TG4/Eju94h52+sTDPT5CDYXxw==
X-Received: by 2002:a05:6808:1402:b0:2d9:d4f6:b1c9 with SMTP id w2-20020a056808140200b002d9d4f6b1c9mr7697200oiv.3.1648958449932;
        Sat, 02 Apr 2022 21:00:49 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id s41-20020a05683043a900b005cdb244c9c3sm3161895otv.47.2022.04.02.21.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 21:00:49 -0700 (PDT)
Date:   Sat, 2 Apr 2022 21:03:16 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Wilczy??ski <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: fix pipe clock imbalance
Message-ID: <YkkchEu1K3gZf38q@ripper>
References: <20220401101325.16983-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401101325.16983-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 01 Apr 03:13 PDT 2022, Johan Hovold wrote:

> Commit ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe
> controller") introduced a clock imbalance by enabling the pipe clock
> both in init() and in post_init() but only disabling in post_deinit().
> 
> Note that the pipe clock was also never disabled in the init() error
> paths and that enabling the clock before powering up the PHY looks
> questionable.
> 
> Fixes: ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe controller")
> Cc: stable@vger.kernel.org      # 5.6
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index b79d98e5e228..20a0e6533a1c 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1238,12 +1238,6 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
>  		goto err_disable_clocks;
>  	}
>  
> -	ret = clk_prepare_enable(res->pipe_clk);
> -	if (ret) {
> -		dev_err(dev, "cannot prepare/enable pipe clock\n");
> -		goto err_disable_clocks;
> -	}
> -
>  	/* Wait for reset to complete, required on SM8450 */
>  	usleep_range(1000, 1500);
>  
> -- 
> 2.35.1
> 
