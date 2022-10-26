Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C8F60E945
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiJZTng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 15:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiJZTnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 15:43:14 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720E3D18CF
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:42:47 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j4so31010652lfk.0
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMYZxL04hWH2PZ6vJak+KLXReH8LIrsCpuymZRqCQuk=;
        b=ZAx/9und4SFDOlvDZ90doIyigl1AirCbsf8z2YGYEMc3bk06egUUEnFcVFM1BgdTyc
         O6fqj4TVqhqMAN8EZm6Vt2eZtZN+qjWBNQMC5Vc8ukJIt8cumjiH8GcoHZEQOt74q9mO
         DdrGLyflrMRO8MnizNC6H9DQfc7mOATT+5ZjdplMQ6vvBi9bGzIj7fi7KdSr/ucrmhVf
         6vUckxsvzBW2cu3KX6Kc8V+holQLkpum6Gma33Y1mke8Tt9Cfw0TQQ8aLWPMdESVJNOM
         ZuqtfXYPEvqAvUiv+PwWDtIk50PHjY5/pPnRD8rjjCIEn9XxQGSfqS3KM3yvbD5WQjwY
         OWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMYZxL04hWH2PZ6vJak+KLXReH8LIrsCpuymZRqCQuk=;
        b=v+3Sg2EOSaDLKV2tsteN4GXy0FbJPSJZ6hCCu9txpOIKYc/PrGwDv5cxUNUV5slcMa
         QNnYaBQd+WDtECEkLBeBUT3VpIm0Nj2jQb7/FFWWMnVuJqkqj2djYCpwVPtYJ2zH8+2Q
         gWKwOZRXhEMPQjQDnH20sQg46IK+TiFKm+k7mXqbieGr59lhs3Osnq1DwxWPCNFcY3yF
         P/l9FmP8Pq5oZh0MQhB1n4qLTdd17ZkxMDnCuZRqSFFKzPktVDS9h+NSHBdBW2w3f282
         Qoq8r+0nv82Gg1Bj6I5DbYKGYIEvaqWQksxxN1PO9SOF6R2z/qdUX2XBfN5Fy2v6EyOe
         IgZg==
X-Gm-Message-State: ACrzQf3A5rmI8rzA7vYICEkxucTbjJ8uyFHsJf3WuIYOiQCGdCKPY62N
        BVs1pR9UkEmg+RqT9YBajew9Cw==
X-Google-Smtp-Source: AMsMyM67lIeLflrZFt4dXiuUg4lborbWndQxvZ66aIfbu2PHV9pOgXVdY2Tf1eV2Lal90qH3qePTVg==
X-Received: by 2002:a05:6512:3d9f:b0:4a2:4986:281 with SMTP id k31-20020a0565123d9f00b004a249860281mr15907943lfv.123.1666813365853;
        Wed, 26 Oct 2022 12:42:45 -0700 (PDT)
Received: from [10.27.10.248] ([195.165.23.90])
        by smtp.gmail.com with ESMTPSA id b14-20020a056512070e00b0049f54c5f2a4sm943868lfs.229.2022.10.26.12.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 12:42:45 -0700 (PDT)
Message-ID: <5ff7957a-d220-f134-4b33-7c388dbb5627@linaro.org>
Date:   Wed, 26 Oct 2022 22:42:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] phy: qcom-qmp-combo: fix NULL-deref on runtime resume
Content-Language: en-GB
To:     Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221026162116.26462-1-johan+linaro@kernel.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20221026162116.26462-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/10/2022 19:21, Johan Hovold wrote:
> Commit fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate
> PCS_USB region") started treating the PCS_USB registers as potentially
> separate from the PCS registers but used the wrong base when no PCS_USB
> offset has been provided.
> 
> Fix the PCS_USB base used at runtime resume to prevent dereferencing a
> NULL pointer on platforms that do not provide a PCS_USB offset (e.g.
> SC7180).
> 
> Fixes: fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate PCS_USB region")
> Cc: stable@vger.kernel.org	# 5.20
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>   drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

