Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3472AAB12
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 14:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKHNOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 08:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbgKHNOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 08:14:17 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48823206ED;
        Sun,  8 Nov 2020 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604841256;
        bh=ACYX+dzqwM+pqodv+7eTSQQ2v0JAOW2m9T80x7FTPzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7O5RXI+yzbk9LJKFBokN0v+ZLqHuE7BSPzd/SEoYkJL2mr6e+0/xOPHnkYQo25O3
         /UDhFntFg3btGKPdbvIgZ7uts47RwM5PImyTFkgAyYN0xww3jegvoMHNo684oXWm0N
         S8mMTnROEGw5L21GeHKLPP2Lh0iAleDFd7FcqgyY=
Date:   Sun, 8 Nov 2020 08:14:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.9 02/35] arm64: dts: meson-axg: add USB nodes
Message-ID: <20201108131415.GO2092@sasha-vm>
References: <20201103011840.182814-1-sashal@kernel.org>
 <20201103011840.182814-2-sashal@kernel.org>
 <d3ef0d93-a95b-2109-ef6b-3d70ce3b9cc3@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d3ef0d93-a95b-2109-ef6b-3d70ce3b9cc3@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:55:45AM +0100, Neil Armstrong wrote:
>On 03/11/2020 02:18, Sasha Levin wrote:
>> From: Neil Armstrong <narmstrong@baylibre.com>
>>
>> [ Upstream commit 1b208bab34dc3f4ef8f408105017d4a7b72b2a2f ]
>>
>> This adds the USB Glue node, with the USB2 & USB3 controllers along the single
>> USB2 PHY node.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> Reviewed-by: Kevin Hilman <khilman@baylibre.com>
>> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 50 ++++++++++++++++++++++
>>  1 file changed, 50 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
>> index b9efc8469265d..fae48efae83e9 100644
>> --- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
>> +++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
>> @@ -171,6 +171,46 @@ soc {
>>  		#size-cells = <2>;
>>  		ranges;
>>
>> +		usb: usb@ffe09080 {
>> +			compatible = "amlogic,meson-axg-usb-ctrl";
>> +			reg = <0x0 0xffe09080 0x0 0x20>;
>> +			interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
>> +			#address-cells = <2>;
>> +			#size-cells = <2>;
>> +			ranges;
>> +
>> +			clocks = <&clkc CLKID_USB>, <&clkc CLKID_USB1_DDR_BRIDGE>;
>> +			clock-names = "usb_ctrl", "ddr";
>> +			resets = <&reset RESET_USB_OTG>;
>> +
>> +			dr_mode = "otg";
>> +
>> +			phys = <&usb2_phy1>;
>> +			phy-names = "usb2-phy1";
>> +
>> +			dwc2: usb@ff400000 {
>> +				compatible = "amlogic,meson-g12a-usb", "snps,dwc2";
>> +				reg = <0x0 0xff400000 0x0 0x40000>;
>> +				interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&clkc CLKID_USB1>;
>> +				clock-names = "otg";
>> +				phys = <&usb2_phy1>;
>> +				dr_mode = "peripheral";
>> +				g-rx-fifo-size = <192>;
>> +				g-np-tx-fifo-size = <128>;
>> +				g-tx-fifo-size = <128 128 16 16 16>;
>> +			};
>> +
>> +			dwc3: usb@ff500000 {
>> +				compatible = "snps,dwc3";
>> +				reg = <0x0 0xff500000 0x0 0x100000>;
>> +				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
>> +				dr_mode = "host";
>> +				maximum-speed = "high-speed";
>> +				snps,dis_u2_susphy_quirk;
>> +			};
>> +		};
>> +
>>  		ethmac: ethernet@ff3f0000 {
>>  			compatible = "amlogic,meson-axg-dwmac",
>>  				     "snps,dwmac-3.70a",
>> @@ -1734,6 +1774,16 @@ sd_emmc_c: mmc@7000 {
>>  				clock-names = "core", "clkin0", "clkin1";
>>  				resets = <&reset RESET_SD_EMMC_C>;
>>  			};
>> +
>> +			usb2_phy1: phy@9020 {
>> +				compatible = "amlogic,meson-gxl-usb2-phy";
>> +				#phy-cells = <0>;
>> +				reg = <0x0 0x9020 0x0 0x20>;
>> +				clocks = <&clkc CLKID_USB>;
>> +				clock-names = "phy";
>> +				resets = <&reset RESET_USB_OTG>;
>> +				reset-names = "phy";
>> +			};
>>  		};
>>
>>  		sram: sram@fffc0000 {
>>
>
>Hi Sasha,
>
>This needs also support in the dwc3-meson-g12a driver, you can drop it from backport.

Dropped, thanks!

-- 
Thanks,
Sasha
