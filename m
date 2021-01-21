Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BC62FE78A
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 11:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbhAUK1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 05:27:23 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14001 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbhAUK1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 05:27:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600956d40000>; Thu, 21 Jan 2021 02:26:28 -0800
Received: from [10.26.72.207] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Jan
 2021 10:26:25 +0000
Subject: Re: [PATCH] arm64: tegra: Enable Jetson-Xavier J512 USB host
To:     JC Kuo <jckuo@nvidia.com>, <gregkh@linuxfoundation.org>,
        <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210119022349.136453-1-jckuo@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4790de5a-f299-219b-1d50-6fe98942c2e1@nvidia.com>
Date:   Thu, 21 Jan 2021 10:26:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119022349.136453-1-jckuo@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611224788; bh=sct4guh8tyVx7wvx6PCrh8j4kV3LgnQtah4P1FR8Wxo=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=nltaLyNWSpKaTMH9c/msvna7xDzoq2b3KsD2bo5FEO3SzddIuvp3u/L0mAJc9Sbi4
         axH5JGLSi3Dp55nekMmDW2JIiEvvIkGRs5y++pa/5ySgv+qq7E1Nlu6jhJTyBzULMv
         c5pBGPGb7q4vVrpfKlELi8kiXBYGFjgRvfrlkKBcInAIRdv0h36EUg3NZfICk+RwBm
         9WQ/CPLV1lZAqE7iTvzGD7a1VGffM693MJDFjXB3tAaQEBtXmJLZBR5YFlMjbKXe0N
         SKXOiMlYuWTQvk3aWSIyrfpucqiQEWG9GtUH79b40jFWCI+2KBqVfCzR9MdkBTfY1u
         4xlA3+Oe3CbKQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/01/2021 02:23, JC Kuo wrote:
> This commit enables USB host mode at J512 type-C port of Jetson-Xavier.
> 
> Signed-off-by: JC Kuo <jckuo@nvidia.com>
> ---
>  .../arm64/boot/dts/nvidia/tegra194-p2888.dtsi |  8 +++++++
>  .../boot/dts/nvidia/tegra194-p2972-0000.dts   | 24 +++++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
> index d71b7a1140fe..7e7b0eb90c80 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi
> @@ -93,6 +93,10 @@ padctl@3520000 {
>  			vclamp-usb-supply = <&vdd_1v8ao>;
>  
>  			ports {
> +				usb2-0 {
> +					vbus-supply = <&vdd_5v0_sys>;
> +				};
> +
>  				usb2-1 {
>  					vbus-supply = <&vdd_5v0_sys>;
>  				};
> @@ -105,6 +109,10 @@ usb3-0 {
>  					vbus-supply = <&vdd_5v0_sys>;
>  				};
>  
> +				usb3-2 {
> +					vbus-supply = <&vdd_5v0_sys>;
> +				};
> +
>  				usb3-3 {
>  					vbus-supply = <&vdd_5v0_sys>;
>  				};
> diff --git a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
> index 54d057beec59..8697927b1fe7 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
> +++ b/arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts
> @@ -57,6 +57,10 @@ padctl@3520000 {
>  			pads {
>  				usb2 {
>  					lanes {
> +						usb2-0 {
> +							status = "okay";
> +						};
> +
>  						usb2-1 {
>  							status = "okay";
>  						};
> @@ -73,6 +77,10 @@ usb3-0 {
>  							status = "okay";
>  						};
>  
> +						usb3-2 {
> +							status = "okay";
> +						};
> +
>  						usb3-3 {
>  							status = "okay";
>  						};
> @@ -81,6 +89,11 @@ usb3-3 {
>  			};
>  
>  			ports {
> +				usb2-0 {
> +					mode = "host";
> +					status = "okay";
> +				};
> +
>  				usb2-1 {
>  					mode = "host";
>  					status = "okay";
> @@ -96,6 +109,11 @@ usb3-0 {
>  					status = "okay";
>  				};
>  
> +				usb3-2 {
> +					nvidia,usb2-companion = <0>;
> +					status = "okay";
> +				};
> +
>  				usb3-3 {
>  					nvidia,usb2-companion = <3>;
>  					maximum-speed = "super-speed";
> @@ -107,11 +125,13 @@ usb3-3 {
>  		usb@3610000 {
>  			status = "okay";
>  
> -			phys =	<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-1}>,
> +			phys =	<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-0}>,
> +				<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-1}>,
>  				<&{/bus@0/padctl@3520000/pads/usb2/lanes/usb2-3}>,
>  				<&{/bus@0/padctl@3520000/pads/usb3/lanes/usb3-0}>,
> +				<&{/bus@0/padctl@3520000/pads/usb3/lanes/usb3-2}>,
>  				<&{/bus@0/padctl@3520000/pads/usb3/lanes/usb3-3}>;
> -			phy-names = "usb2-1", "usb2-3", "usb3-0", "usb3-3";
> +			phy-names = "usb2-0", "usb2-1", "usb2-3", "usb3-0", "usb3-2", "usb3-3";
>  		};
>  
>  		pwm@c340000 {
> 

Thanks. Works for me.

Acked-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
