Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C930F4F8
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 15:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbhBDO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 09:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhBDO0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 09:26:44 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52DCC0613ED
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 06:26:02 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c12so3702417wrc.7
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 06:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f+Kn5O5ZpiyxGVryHYtP1dHvnCa/0Doj6DjufSQG6+s=;
        b=YS4z1atagIUMZKBbTg3QsyHjE/1Ce1TAm1g38OcbL+DaaCudgKyGyJ92SJH42zsX4o
         pSaOnLZdh0aj4jek4bosFfEUVg6E42JOGYzdVhr5bvcRepLuke37hPevPn4XOOToG2/Y
         54ftMvYMIxT77t56wHCgSvn1hhZdn8mvnZVL5IL8lSDlnUUGC8UdOMTCgC5YmDBrszY2
         XthJ0EO+zWAKUpMU/7mMiR2j4tafLHb+NNFL/vTg5PM69hkH8l67NWOfmNo0veQkoxSj
         fK4CwX0Xn3y0uYQuqfsIqiDJ09MbceOStRnmrN9S4/up5ra85FU1FbncX15gvjVK8/eS
         uc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+Kn5O5ZpiyxGVryHYtP1dHvnCa/0Doj6DjufSQG6+s=;
        b=f4jfs5jxxz8sLrB3IstceeaUr+zmTG5i22e6M+UxhKXy8Oro+y2UulOistINwLRxJT
         SqtdOrlsWFnxC1As7D2RkiihTON0KkrzsB6uggH6rCe/hAS5ibiNNDWaGGui7PYng/kH
         nl+eLALPrCDI6Y1ryUYZIcZJd9rpvxweyi4+OT0Zu/KrIcoBVnkcQ1DT3o3RDDKWG/ab
         zJtxHowsEr2+LaNN94WD1eTa4+JviEwJQJBtJ0+nTuJznpIJZlvTdY5celOAejEwu49p
         RXYokyvutsoxoo7t4h97El/Hue0aJrE+pV2a6ijS0yP0wipQjapdu3gIKR/ixnKiAHxQ
         dPKQ==
X-Gm-Message-State: AOAM531fCXTSN/iSL+RkMQznQeSRWL3mzkMqkqsM+6hyE4r+xU12GuwI
        7eHMUxzaRwo4aNuvHXyDr4NkEb2mafzN0Q==
X-Google-Smtp-Source: ABdhPJy3YVPTtEMFX+kbmWAPhOQGMRkTso3UENHpJVHtcB2KmShXPEyR2Eaalgda73n4/ohX3xkeGA==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr9655161wrl.214.1612448761048;
        Thu, 04 Feb 2021 06:26:01 -0800 (PST)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id y11sm8062875wrh.16.2021.02.04.06.25.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:26:00 -0800 (PST)
Subject: Re: [RESEND PATCH] nvmem: qcom-spmi-sdam: Fix uninitialized pdev
 pointer
To:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1612376126-31001-1-git-send-email-subbaram@codeaurora.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <b369ae3e-38d5-7e41-1380-982a8fe66660@linaro.org>
Date:   Thu, 4 Feb 2021 14:25:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1612376126-31001-1-git-send-email-subbaram@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 03/02/2021 18:15, Subbaraman Narayanamurthy wrote:
> "sdam->pdev" is uninitialized and it is used to print error logs.
> Fix it. Since device pointer can be used from sdam_config, use it
> directly thereby removing pdev pointer.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
> ---

Applied thanks,

--srini

>   drivers/nvmem/qcom-spmi-sdam.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
> index a72704c..f6e9f96 100644
> --- a/drivers/nvmem/qcom-spmi-sdam.c
> +++ b/drivers/nvmem/qcom-spmi-sdam.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /*
> - * Copyright (c) 2017, 2020 The Linux Foundation. All rights reserved.
> + * Copyright (c) 2017, 2020-2021, The Linux Foundation. All rights reserved.
>    */
>   
>   #include <linux/device.h>
> @@ -18,7 +18,6 @@
>   #define SDAM_PBS_TRIG_CLR		0xE6
>   
>   struct sdam_chip {
> -	struct platform_device		*pdev;
>   	struct regmap			*regmap;
>   	struct nvmem_config		sdam_config;
>   	unsigned int			base;
> @@ -65,7 +64,7 @@ static int sdam_read(void *priv, unsigned int offset, void *val,
>   				size_t bytes)
>   {
>   	struct sdam_chip *sdam = priv;
> -	struct device *dev = &sdam->pdev->dev;
> +	struct device *dev = sdam->sdam_config.dev;
>   	int rc;
>   
>   	if (!sdam_is_valid(sdam, offset, bytes)) {
> @@ -86,7 +85,7 @@ static int sdam_write(void *priv, unsigned int offset, void *val,
>   				size_t bytes)
>   {
>   	struct sdam_chip *sdam = priv;
> -	struct device *dev = &sdam->pdev->dev;
> +	struct device *dev = sdam->sdam_config.dev;
>   	int rc;
>   
>   	if (!sdam_is_valid(sdam, offset, bytes)) {
> 
