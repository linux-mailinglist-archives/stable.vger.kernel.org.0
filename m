Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2C0541FBC
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386046AbiFHAE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 20:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455645AbiFGXSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:18:55 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E014CA3C;
        Tue,  7 Jun 2022 14:21:01 -0700 (PDT)
Received: from nicolas-tpx395.localdomain (192-222-136-102.qc.cable.ebox.net [192.222.136.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: nicolas)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B5C076601871;
        Tue,  7 Jun 2022 22:20:51 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1654636852;
        bh=dH4ePZwfeLtm9fi79oxsDTUIBw0bx6MHdxM1wE/tZqQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WNvOADoRCCmqcW0ciRe4n/B5kvdvxoJJyqgrUKUAHAR9nFu2Ku1T2a+690+lFyA/S
         2IDgEVjcC11SDcfX1akflY4OIdQ/bj0Uj2IxoEB+aaIyLlGaDOed642U3BPt8K2BhQ
         8/Nni2eDQz6US5/y0asqf3RapGjnyJ24LUK82CN8Ov/JHF04L09D0oZPffGtRD2Zov
         ZpQUQ2wg7HVqhSKQyF5Y58FNo4dNohpAPurdNF+dCWQfQ0tbLaCR+IDcF3HvOFG6dV
         0FmnwFZKDFjbTZJqi27BvEYUY8a/wALRUJ5nlV+tT5Y3sdhoVenVLWDLs9kLcxtx8J
         N7lkevwSQJjzQ==
Message-ID: <253e2771abb13a3e62c07dfb0b420169bb572c2d.camel@collabora.com>
Subject: Re: [PATCH] arm64: dts: rockchip: Assign RK3399 VDU clock rate
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        stable@vger.kernel.org
Date:   Tue, 07 Jun 2022 17:20:41 -0400
In-Reply-To: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
References: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le mardi 07 juin 2022 =C3=A0 14:15 -0700, Brian Norris a =C3=A9crit=C2=A0:
> Before commit 9998943f6dfc ("media: rkvdec: Stop overclocking the
> decoder"), the rkvdec driver was forcing the VDU clock rate. After that
> commit, we rely on the default clock rate. That rate works OK on many
> boards, with the default PLL settings (CPLL is 800MHz, VDU dividers
> leave it at 400MHz); but some boards change PLL settings.
>=20
> Assign the expected default clock rate explicitly, so that the rate is
> consistent, regardless of PLL configuration.
>=20
> This was particularly broken on RK3399 Gru Scarlet systems, where the
> rk3399-gru-scarlet.dtsi assigns PLL_CPLL to 1.6 GHz, and so the VDU
> clock ends up at 800 MHz (twice the expected rate), and causes video
> artifacts and other issues.
>=20
> Note: I assign the clock rate in the clock controller instead of the
> vdec node, because there are multiple nodes that use this clock, and per
> the clock.yaml specification:
>=20
>   Configuring a clock's parent and rate through the device node that
>   consumes the clock can be done only for clocks that have a single
>   user. Specifying conflicting parent or rate configuration in multiple
>   consumer nodes for a shared clock is forbidden.
>=20
>   Configuration of common clocks, which affect multiple consumer devices
>   can be similarly specified in the clock provider node.
>=20
> Fixes: 9998943f6dfc ("media: rkvdec: Stop overclocking the decoder")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

My only doubt was if you really needed to duplicate that setting into gru-
scarlet.dtsi, but I've simply assumed the answer is yes, and that you alrea=
dy
checked that.

> ---
> This is a candidate for 5.19 IMO, since commit 9998943f6dfc landed in
> 5.19-rc1 and is being queued up for -stable as we speak.
>=20
>  arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi | 4 +++-
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi             | 6 ++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi b/arch/=
arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
> index 913d845eb51a..1977103a5ef4 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
> @@ -376,7 +376,8 @@ &cru {
>  		<&cru ACLK_VIO>,
>  		<&cru ACLK_GIC_PRE>,
>  		<&cru PCLK_DDR>,
> -		<&cru ACLK_HDCP>;
> +		<&cru ACLK_HDCP>,
> +		<&cru ACLK_VDU>;
>  	assigned-clock-rates =3D
>  		<600000000>, <1600000000>,
>  		<1000000000>,
> @@ -388,6 +389,7 @@ &cru {
>  		<400000000>,
>  		<200000000>,
>  		<200000000>,
> +		<400000000>,
>  		<400000000>;
>  };
> =20
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/d=
ts/rockchip/rk3399.dtsi
> index fbd0346624e6..9d5b0e8c9cca 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> @@ -1462,7 +1462,8 @@ cru: clock-controller@ff760000 {
>  			<&cru HCLK_PERILP1>, <&cru PCLK_PERILP1>,
>  			<&cru ACLK_VIO>, <&cru ACLK_HDCP>,
>  			<&cru ACLK_GIC_PRE>,
> -			<&cru PCLK_DDR>;
> +			<&cru PCLK_DDR>,
> +			<&cru ACLK_VDU>;
>  		assigned-clock-rates =3D
>  			 <594000000>,  <800000000>,
>  			<1000000000>,
> @@ -1473,7 +1474,8 @@ cru: clock-controller@ff760000 {
>  			 <100000000>,   <50000000>,
>  			 <400000000>, <400000000>,
>  			 <200000000>,
> -			 <200000000>;
> +			 <200000000>,
> +			 <400000000>;
>  	};
> =20
>  	grf: syscon@ff770000 {

