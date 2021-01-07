Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517DD2ECD19
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAGJst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 04:48:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7024 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGJss (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 04:48:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff6d8d80001>; Thu, 07 Jan 2021 01:48:08 -0800
Received: from [10.26.72.150] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 09:48:06 +0000
Subject: Re: [PATCH] arm64: tegra: Add power-domain for Tegra210 HDA
To:     Sameer Pujar <spujar@nvidia.com>, <thierry.reding@gmail.com>,
        <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <1609995970-12256-1-git-send-email-spujar@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1dfc080c-f587-d19f-65c9-b3220b3202a0@nvidia.com>
Date:   Thu, 7 Jan 2021 09:48:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1609995970-12256-1-git-send-email-spujar@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610012888; bh=IjN25z+yWpSbbGI53L+67ScDv4QXQ/8Bbz0TLdhRyYY=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=qznrjEdnM+8mWavbGJf3rO0LQ3iotUPiNeuxvyJx46Ish8/Wf5e57/u6S51anRH9i
         8yIa+4+SPIIBprmZJUC/rDpPY6iVoqLxqzhdw3NQtL89llzVTR4LbCjAp9CH3Xp/cq
         OvtvdlzUYz7eq7KWiSwaQ2M++oDC5IECF8OK6C84HMIm9E5n2VGqF1IrkvEeBX9eis
         Us9XxNEj5e7OHPF6GW+204NzUKzX+nQGuK5Z1RwTHWco0vtipJMI78rOd/UBtijxmH
         pNLL8NQO0PWTiXsb7MRt94yRntPVg3bplOcEi8k9iAVRvPDu7sjJtwUl7s1Yfgh5VP
         Xmh/wDGucEdUw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/01/2021 05:06, Sameer Pujar wrote:
> HDA initialization is failing occasionally on Tegra210 and following
> print is observed in the boot log. Because of this probe() fails and
> no sound card is registered.
> 
>   [16.800802] tegra-hda 70030000.hda: no codecs found!
> 
> Codecs request a state change and enumeration by the controller. In
> failure cases this does not seem to happen as STATETS register reads 0.
> 
> The problem seems to be related to the HDA codec dependency on SOR
> power domain. If it is gated during HDA probe then the failure is
> observed. Building Tegra HDA driver into kernel image avoids this
> failure but does not completely address the dependency part. Fix this
> problem by adding 'power-domains' DT property for Tegra210 HDA. Note
> that Tegra186 and Tegra194 HDA do this already.
> 
> Fixes: 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support")
> Depends-on: 96d1f078ff0 ("arm64: tegra: Add SOR power-domain for Tegra210")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> ---
>  arch/arm64/boot/dts/nvidia/tegra210.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
> index 4fbf8c1..fd33b4d 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
> @@ -997,6 +997,7 @@
>  			 <&tegra_car 128>, /* hda2hdmi */
>  			 <&tegra_car 111>; /* hda2codec_2x */
>  		reset-names = "hda", "hda2hdmi", "hda2codec_2x";
> +		power-domains = <&pd_sor>;
>  		status = "disabled";
>  	};

Thanks!

Acked-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
