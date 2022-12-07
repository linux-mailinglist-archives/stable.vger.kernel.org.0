Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B3E645E5A
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 17:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLGQId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 11:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGQIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 11:08:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA190101DE;
        Wed,  7 Dec 2022 08:08:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB86B81E8B;
        Wed,  7 Dec 2022 16:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3FAC433D6;
        Wed,  7 Dec 2022 16:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670429308;
        bh=vcyAyh2sLrxbL8pzcLbQv6twMaQG9hdT0WW2MzYtfuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t+67XZVJXUWBmzO4Gi151p+9RzfGxGYQVf0sCUrOCCx3hH40QsJuv2PUGn7bkhU6A
         ihijHKC+Qdv4mZJ9aRU8DxGnHSuDaA7+rVXTEEhaMHlhDv4qzJ4C3q3qbnVmWueJiS
         dQQmmmRktGJwTOaT85BWxxVAIVGZB8lVzEdxIfm+9fwKEt53MCPYeVJ6HUJOTHjv0M
         A82fS7ymPqZOXl/eOksp51JrzR8Bq21yf3dxRV37C0IKpouxswUCoKsfvGf/vF9uF5
         w3PsG0lYUFY/Xt/IX3vyywYxatyIzaKpImrB1G5itZwUqf3eV2EI7wvIjslv90GszD
         5EEYm4LO+SV3Q==
Date:   Wed, 7 Dec 2022 10:08:25 -0600
From:   Bjorn Andersson <andersson@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        bp@alien8.de, tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] dt-bindings: arm: msm: Fix register regions used
 for LLCC banks
Message-ID: <20221207160825.nafywxehxjx42kww@builder.lan>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
 <20221207135922.314827-3-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207135922.314827-3-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 07:29:11PM +0530, Manivannan Sadhasivam wrote:
> Register regions of the LLCC banks are located at separate addresses.
> Currently, the binding just lists the LLCC0 base address and specifies
> the size to cover all banks. This is not the correct approach since,
> there are holes and other registers located in between.
> 
> So let's specify the base address of each LLCC bank. It should be noted
> that the bank count differs for each SoC, so that also needs to be taken
> into account in the binding.
> 
> Cc: <stable@vger.kernel.org> # 4.19
> Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  .../bindings/arm/msm/qcom,llcc.yaml           | 125 ++++++++++++++++--
>  1 file changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> index d1df49ffcc1b..7f694baa017c 100644
> --- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> @@ -33,14 +33,12 @@ properties:
>        - qcom,sm8550-llcc
>  
>    reg:
> -    items:
> -      - description: LLCC base register region
> -      - description: LLCC broadcast base register region
> +    minItems: 2
> +    maxItems: 9
>  
>    reg-names:
> -    items:
> -      - const: llcc_base
> -      - const: llcc_broadcast_base
> +    minItems: 2
> +    maxItems: 9

Afaict changing llcc_base to llcc0_base would not allow the
implementation to find the llcc_base region with an older DTB.

But if you instead modify the driver to pick up N-1 regions for base and
the last for broadcast, by index. This should continue to work for the
platforms where it actually worked.

Based on that I suggest that you just remove reg-names from the binding.
It will clean up the binding and we won't have reg-names containing
"llcc" or "base" :)

Regards,
Bjorn

>  
>    interrupts:
>      maxItems: 1
> @@ -50,15 +48,120 @@ required:
>    - reg
>    - reg-names
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc7180-llcc
> +              - qcom,sm6350-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC broadcast base register region
> +        reg-names:
> +          items:
> +            - const: llcc0_base
> +            - const: llcc_broadcast_base
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc7280-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC broadcast base register region
> +        reg-names:
> +          items:
> +            - const: llcc0_base
> +            - const: llcc1_base
> +            - const: llcc_broadcast_base
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc8180x-llcc
> +              - qcom,sc8280xp-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC2 base register region
> +            - description: LLCC3 base register region
> +            - description: LLCC4 base register region
> +            - description: LLCC5 base register region
> +            - description: LLCC6 base register region
> +            - description: LLCC7 base register region
> +            - description: LLCC broadcast base register region
> +        reg-names:
> +          items:
> +            - const: llcc0_base
> +            - const: llcc1_base
> +            - const: llcc2_base
> +            - const: llcc3_base
> +            - const: llcc4_base
> +            - const: llcc5_base
> +            - const: llcc6_base
> +            - const: llcc7_base
> +            - const: llcc_broadcast_base
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sdm845-llcc
> +              - qcom,sm8150-llcc
> +              - qcom,sm8250-llcc
> +              - qcom,sm8350-llcc
> +              - qcom,sm8450-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC2 base register region
> +            - description: LLCC3 base register region
> +            - description: LLCC broadcast base register region
> +        reg-names:
> +          items:
> +            - const: llcc0_base
> +            - const: llcc1_base
> +            - const: llcc2_base
> +            - const: llcc3_base
> +            - const: llcc_broadcast_base
> +
>  additionalProperties: false
>  
>  examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    system-cache-controller@1100000 {
> -      compatible = "qcom,sdm845-llcc";
> -      reg = <0x1100000 0x200000>, <0x1300000 0x50000> ;
> -      reg-names = "llcc_base", "llcc_broadcast_base";
> -      interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> +    soc {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        system-cache-controller@1100000 {
> +          compatible = "qcom,sdm845-llcc";
> +          reg = <0 0x01100000 0 0x50000>, <0 0x01180000 0 0x50000>,
> +                <0 0x01200000 0 0x50000>, <0 0x01280000 0 0x50000>,
> +                <0 0x01300000 0 0x50000>;
> +          reg-names = "llcc0_base", "llcc1_base", "llcc2_base",
> +                "llcc3_base", "llcc_broadcast_base";
> +          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> +        };
>      };
> -- 
> 2.25.1
> 
