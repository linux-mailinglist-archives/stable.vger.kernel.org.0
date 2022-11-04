Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1296193C7
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 10:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKDJoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 05:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiKDJny (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 05:43:54 -0400
Received: from relay07.th.seeweb.it (relay07.th.seeweb.it [IPv6:2001:4b7a:2000:18::168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FACD62F7;
        Fri,  4 Nov 2022 02:43:52 -0700 (PDT)
Received: from [192.168.31.208] (unknown [194.29.137.22])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by m-r2.th.seeweb.it (Postfix) with ESMTPSA id 8708F3F792;
        Fri,  4 Nov 2022 10:43:50 +0100 (CET)
Message-ID: <0da38ea1-23ce-23d4-ade5-cddfff5d957f@somainline.org>
Date:   Fri, 4 Nov 2022 10:43:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 1/2] arm64: dts: qcom: sc8280xp: fix UFS reference clocks
To:     Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Brian Masney <bmasney@redhat.com>,
        Shazad Hussain <quic_shazhuss@quicinc.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221104092045.17410-1-johan+linaro@kernel.org>
 <20221104092045.17410-2-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
In-Reply-To: <20221104092045.17410-2-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/11/2022 10:20, Johan Hovold wrote:
> There are three UFS reference clocks on SC8280XP which are used as
> follows:
>
>   - The GCC_UFS_REF_CLKREF_CLK clock is fed to any UFS device connected
>     to either controller.
>
>   - The GCC_UFS_1_CARD_CLKREF_CLK and GCC_UFS_CARD_CLKREF_CLK clocks
>     provide reference clocks to the two PHYs.
>
> Note that this depends on first updating the clock driver to reflect
> that all three clocks are sourced from CXO. Specifically, the UFS
> controller driver expects the device reference clock to have a valid
> frequency:
>
> 	ufshcd-qcom 1d84000.ufs: invalid ref_clk setting = 0
>
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Fixes: 8d6b458ce6e9 ("arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock")
> Fixes: f3aa975e230e ("arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy")
> Link: https://lore.kernel.org/lkml/Y2OEjNAPXg5BfOxH@hovoldconsulting.com/
> Cc: stable@vger.kernel.org	# 5.20
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>


Konrad

>   arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index 21ac119e0382..e0d0fb6994b5 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -912,7 +912,7 @@ ufs_mem_hc: ufs@1d84000 {
>   				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>   				 <&gcc GCC_UFS_PHY_AHB_CLK>,
>   				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> -				 <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
>   				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>   				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
>   				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
> @@ -943,7 +943,7 @@ ufs_mem_phy: phy@1d87000 {
>   			ranges;
>   			clock-names = "ref",
>   				      "ref_aux";
> -			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
> +			clocks = <&gcc GCC_UFS_CARD_CLKREF_CLK>,
>   				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
>   
>   			resets = <&ufs_mem_hc 0>;
> @@ -980,7 +980,7 @@ ufs_card_hc: ufs@1da4000 {
>   				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
>   				 <&gcc GCC_UFS_CARD_AHB_CLK>,
>   				 <&gcc GCC_UFS_CARD_UNIPRO_CORE_CLK>,
> -				 <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
>   				 <&gcc GCC_UFS_CARD_TX_SYMBOL_0_CLK>,
>   				 <&gcc GCC_UFS_CARD_RX_SYMBOL_0_CLK>,
>   				 <&gcc GCC_UFS_CARD_RX_SYMBOL_1_CLK>;
> @@ -1011,7 +1011,7 @@ ufs_card_phy: phy@1da7000 {
>   			ranges;
>   			clock-names = "ref",
>   				      "ref_aux";
> -			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
> +			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
>   				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
>   
>   			resets = <&ufs_card_hc 0>;
