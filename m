Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535264D9543
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 08:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbiCOHaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345411AbiCOHaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 03:30:16 -0400
Received: from smtp-out.xnet.cz (smtp-out.xnet.cz [178.217.244.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64464B1D1;
        Tue, 15 Mar 2022 00:29:02 -0700 (PDT)
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 420E01822C;
        Tue, 15 Mar 2022 08:29:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=true.cz; s=xnet;
        t=1647329340; bh=65xHoffDZObM2VcshT2400SVsaHk3C3lcItOW7dYiro=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
        b=LcIHGOxyWO+eN62q6QH5dSr84iz8ODEZ+2nhHHrUG1w6UE9Mbsyr0H+6UP3nbzIEz
         iL4g6D3ZcfQvtl5m/BPl39+tqWEOqudRSbqqAc9/G/IA561CnJWYn4B635DHO7RPwP
         FFTlRZGBFvEp1AbDNB2L8qBC5vk6B2GVeGlH8olY=
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 7ab44043;
        Tue, 15 Mar 2022 08:28:36 +0100 (CET)
Date:   Tue, 15 Mar 2022 08:28:58 +0100
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Maxime Ripard <mripard@kernel.org>,
        Bastien =?utf-8?Q?Roucari=C3=A8s?= <rouca@debian.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: dts: sun7i: A20-olinuxino-lime2: Fix
 ethernet phy-mode"
Message-ID: <20220315072846.GA9129@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <20220308125531.27305-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308125531.27305-1-ynezz@true.cz>
X-PGP-Key: https://gist.githubusercontent.com/ynezz/477f6d7a1623a591b0806699f9fc8a27/raw/a0878b8ed17e56f36ebf9e06a6b888a2cd66281b/pgp-key.pub
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Petr Štetiar <ynezz@true.cz> [2022-03-08 13:55:30]:

Hi Greg,

one week has passed and as I didn't received any feedback, I'm providing more
details in a hope to make it more clear, why I think, that this fix is wrong
and should be reverted in LTS kernels 5.10 and 5.15.

> This reverts commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 as it breaks
> network on my A20-olinuxino-lime2 hardware revision "K" which has Micrel
> KSZ9031RNXCC-TR Gigabit PHY. Bastien has probably some previous hardware
> revisions which were based on RTL8211E-VB-CG1 PHY and thus this fix was
> working on his board.

Disclaimer, I don't own A20-olinuxino-lime2 board with earlier HW revisions
G/G1/G2 utilizing RTL8211E PHY.

My understanding is, that up to kernel version 5.9 and specifically commit
bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config") it was
likely possible to use same DTS for A20-olinuxino-lime2 with KSZ9031 or
RTL8211E PHYs (all HW revisions).

At least I was using my A20-olinuxino-lime2 HW revision K with KSZ9031 PHY
just fine with 4.19 kernel. After upgrade to 5.10 LTS kernel my network
stopped working, reverting stable backport commit a90398438517 ("ARM: dts:
sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode") fixed it.

From my POV proper fix for earlier HW revisions G/G1/G2 is introduction of
sun7i-a20-olinuxino-lime2-revG.dts with a proper `phy-mode` for RTL8211E PHY.

Cheers,

Petr

> Cc: stable@vger.kernel.org
> Cc: Bastien Roucariès <rouca@debian.org>
> References: https://github.com/openwrt/openwrt/issues/9153
> References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/hardware_revision_changes_log.txt
> Signed-off-by: Petr Štetiar <ynezz@true.cz>
> ---
>  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> index ecb91fb899ff..8077f1716fbc 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> @@ -112,7 +112,7 @@ &gmac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
> -	phy-mode = "rgmii-id";
> +	phy-mode = "rgmii";
>  	status = "okay";
>  };
