Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D700E42EFA4
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 13:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhJOL1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 07:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhJOL1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 07:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345F960F44;
        Fri, 15 Oct 2021 11:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634297099;
        bh=S2ttHTQZbViKN90vGN8gNTlVq12qJiTgjIvyidc8/Bc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HWmRHTMl3VUejfX914gy+1GM3sMI3DowdNIrg0vsqgu4AEPguSBrWS/mnX5cS84xP
         9kXi8MzoWBVNNRFY1FZWTiRMEjEcArj3XqjpY9uRI9n9Mr3zhTGpSJj9pQ7EE+1uOe
         XPQcVXgy/QjmjfPDw+hFaiyb0dNc0qrMrUUj5aLR1W1Si4ElHAI++WqZ8/ksMa6dgv
         YMhqFNXzHlr1hi+89G4SYNXavI5aKNeLhUUE/LQpu81zI5chTQitRGJavVu5iBd8Cb
         vTP/TcOeB/YLqemUI1+prYsTXlHIbJs5u0zEWuzmY/ewmYVyF6rNWo2vTiCFrxu0Rl
         pMpjbRjqxCNtQ==
Message-ID: <4eeec0ec-c178-248a-f053-2352131c1052@kernel.org>
Date:   Fri, 15 Oct 2021 14:24:52 +0300
MIME-Version: 1.0
Subject: Re: [PATCH 5.14 05/30] interconnect: qcom: sdm660: Add missing a2noc
 qos clocks
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Sasha Levin <sashal@kernel.org>
References: <20211014145209.520017940@linuxfoundation.org>
 <20211014145209.702501084@linuxfoundation.org>
From:   Georgi Djakov <djakov@kernel.org>
In-Reply-To: <20211014145209.702501084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 14.10.21 17:54, Greg Kroah-Hartman wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> [ Upstream commit 13404ac8882f5225af07545215f4975a564c3740 ]
> 
> It adds the missing a2noc clocks required for QoS registers programming
> per downstream kernel[1].  Otherwise, qcom_icc_noc_set_qos_priority()
> call on mas_ufs or mas_usb_hs node will simply result in a hardware hang
> on SDM660 SoC.
> 
> [1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> Link: https://lore.kernel.org/r/20210824043435.23190-3-shawn.guo@linaro.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

There is no benefit to backport this change, as devices that
needed it, would not boot on v5.14 anyways. Please drop it.

Thanks,
Georgi

> ---
>   drivers/interconnect/qcom/sdm660.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/interconnect/qcom/sdm660.c b/drivers/interconnect/qcom/sdm660.c
> index 99eef7e2d326..fb23a5b780a4 100644
> --- a/drivers/interconnect/qcom/sdm660.c
> +++ b/drivers/interconnect/qcom/sdm660.c
> @@ -173,6 +173,16 @@ static const struct clk_bulk_data bus_mm_clocks[] = {
>   	{ .id = "iface" },
>   };
>   
> +static const struct clk_bulk_data bus_a2noc_clocks[] = {
> +	{ .id = "bus" },
> +	{ .id = "bus_a" },
> +	{ .id = "ipa" },
> +	{ .id = "ufs_axi" },
> +	{ .id = "aggre2_ufs_axi" },
> +	{ .id = "aggre2_usb3_axi" },
> +	{ .id = "cfg_noc_usb2_axi" },
> +};
> +
>   /**
>    * struct qcom_icc_provider - Qualcomm specific interconnect provider
>    * @provider: generic interconnect provider
> @@ -809,6 +819,10 @@ static int qnoc_probe(struct platform_device *pdev)
>   		qp->bus_clks = devm_kmemdup(dev, bus_mm_clocks,
>   					    sizeof(bus_mm_clocks), GFP_KERNEL);
>   		qp->num_clks = ARRAY_SIZE(bus_mm_clocks);
> +	} else if (of_device_is_compatible(dev->of_node, "qcom,sdm660-a2noc")) {
> +		qp->bus_clks = devm_kmemdup(dev, bus_a2noc_clocks,
> +					    sizeof(bus_a2noc_clocks), GFP_KERNEL);
> +		qp->num_clks = ARRAY_SIZE(bus_a2noc_clocks);
>   	} else {
>   		if (of_device_is_compatible(dev->of_node, "qcom,sdm660-bimc"))
>   			qp->is_bimc_node = true;
> 

