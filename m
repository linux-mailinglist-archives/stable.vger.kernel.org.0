Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3390B5F1365
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 22:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiI3UOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 16:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiI3UOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 16:14:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8B53741D
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:13:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z97so7367556ede.8
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ha+dKpSD18b7SEyJFVqme7qsmksxsxZGbH3m9OgZDbM=;
        b=byuuoeNvEGfA9DoTk0fRGAN94y0fhLTVYJo2TFIx/jnQ6NdwKJ83dTGNZMGDC2MjEB
         Xn8L4huWtJDnhB3D2NJv4ROqmXWaJLs2lbfyBrM/oklu1cHT/NKPsKqDpDiE0bRDleP1
         ljEtIWDc8Lhw/job9967nDVhUOhHhXgPXYwnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ha+dKpSD18b7SEyJFVqme7qsmksxsxZGbH3m9OgZDbM=;
        b=RqBFOLR9LcC+qQijoB9YxOyN2SGcKJwwRl5wUm7sfEcu6OccBco2RHup9wyiB7JdKo
         S2WnmGcvpvLadWlj8vyiZCg5RdD+7N/FbEzfpafkdZ70yfRzp+WZ32rEwsATPSoIndXz
         kl5l3JIlryiSRvg6zFlbskNju5enBFg1Lv8glb8jmLzj58smfeVHA1VVE9Mnzsc2pJY9
         EQcWmzN5SzJXgyZzbJJhnxrFL3mBrT1e0TETYMbgbNt9rM7oyQ0tvj6bVRtNOFPEzQ08
         einEyhUeWWxemD9hZhQ7YyB8vOu5qetOPsk2qMrnLkj3hYqg9giDBNmu8rL/z0UPH/lj
         wc7A==
X-Gm-Message-State: ACrzQf3cudY9GzV2LeKl7IQsOWeMZOkdHns5jrAndhK0lIqQ1zOOQmVS
        MlZwi6BPLDdLeB12ibYYwSwehGIQ0zOyBp+I
X-Google-Smtp-Source: AMsMyM4sb6dBl9r0MbYhQ+CsePBD6jjD7PZA1lyo7+u4j48ky6rGSdwpDBAjl9w0AdFw5csnR/5mZg==
X-Received: by 2002:aa7:c050:0:b0:453:4427:a947 with SMTP id k16-20020aa7c050000000b004534427a947mr9215701edo.172.1664568793240;
        Fri, 30 Sep 2022 13:13:13 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id r8-20020a1709062cc800b0072b7d76211dsm1653902ejr.107.2022.09.30.13.13.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 13:13:11 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id r6so8433918wru.8
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:13:11 -0700 (PDT)
X-Received: by 2002:adf:f90d:0:b0:20c:de32:4d35 with SMTP id
 b13-20020adff90d000000b0020cde324d35mr6823437wrr.583.1664568790844; Fri, 30
 Sep 2022 13:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org> <20220930182212.209804-2-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220930182212.209804-2-krzysztof.kozlowski@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 30 Sep 2022 13:12:59 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WSbpV4aqyHgSX6rwanQmZYG1hdNourjP5DEmsfdq6aDA@mail.gmail.com>
Message-ID: <CAD=FV=WSbpV4aqyHgSX6rwanQmZYG1hdNourjP5DEmsfdq6aDA@mail.gmail.com>
Subject: Re: [PATCH 2/3] arm64: dts: qcom: sdm845-db845c: correct SPI2 pins
 drive strength
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Sep 30, 2022 at 11:22 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> The pin configuration (done with generic pin controller helpers and
> as expressed by bindings) requires children nodes with either:
> 1. "pins" property and the actual configuration,
> 2. another set of nodes with above point.
>
> The qup_spi2_default pin configuration used second method - with a
> "pinmux" child.
>
> Fixes: 8d23a0040475 ("arm64: dts: qcom: db845c: add Low speed expansion i2c and spi nodes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> ---
>
> Not tested on hardware.
> ---
>  arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> index 132417e2d11e..a157eab66dee 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> @@ -1123,7 +1123,9 @@ &wifi {
>
>  /* PINCTRL - additions to nodes defined in sdm845.dtsi */
>  &qup_spi2_default {
> -       drive-strength = <16>;
> +       pinmux {
> +               drive-strength = <16>;
> +       };

The convention on Qualcomm boards of this era is that muxing (setting
the function) is done under a "pinmux" node and, unless some of the
pins need to be treated differently like for the UARTs, configuration
(bias, drive strength, etc) is done under a "pinconf" subnode. I
believe that the "pinconf" subnode also needs to replicate the list of
pins, or at least that's what we did everywhere else on sdm845 /
sc7180.

Thus to match conventions, I assume you'd do:

&qup_spi2_default {
  pinconf {
    pins = "gpio27", "gpio28", "gpio29", "gpio30";
    drive-strength = <16>;
  };
};

We've since moved away from this to a less cumbersome approach, but
for "older" boards like db845c we should probably match the existing
convention, or have a flag day and change all sdm845 boards over to
the new convention.

-Doug
