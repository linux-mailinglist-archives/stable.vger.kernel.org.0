Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2743B4DA598
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 23:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352336AbiCOWrB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 15 Mar 2022 18:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352334AbiCOWrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 18:47:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0045213DEB;
        Tue, 15 Mar 2022 15:45:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FBB41474;
        Tue, 15 Mar 2022 15:45:47 -0700 (PDT)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A52363F66F;
        Tue, 15 Mar 2022 15:45:45 -0700 (PDT)
Date:   Tue, 15 Mar 2022 22:44:44 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Jernej =?UTF-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>,
        Petr =?UTF-8?B?xaB0ZXRpYXI=?= <ynezz@true.cz>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, stable@vger.kernel.org,
        Bastien =?UTF-8?B?Um91Y2FyacOocw==?= <rouca@debian.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Revert "ARM: dts: sun7i: A20-olinuxino-lime2:
 Fix ethernet phy-mode"
Message-ID: <20220315224444.1825833e@slackpad.lan>
In-Reply-To: <44524634.fMDQidcC6G@kista>
References: <20220315095244.29718-1-ynezz@true.cz>
        <20220315095244.29718-2-ynezz@true.cz>
        <44524634.fMDQidcC6G@kista>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Mar 2022 19:50:23 +0100
Jernej Škrabec <jernej.skrabec@gmail.com> wrote:

> Hi Petr!
> 
> Dne torek, 15. marec 2022 ob 10:52:42 CET je Petr Štetiar napisal(a):
> > This reverts commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 as it
> > breaks network on my A20-olinuxino-lime2 hardware revision "K" which has
> > Micrel KSZ9031RNXCC-TR Gigabit PHY. Bastien has probably some previous
> > hardware revisions which were based on RTL8211E-VB-CG1 PHY and thus this
> > fix was working on his board.  
> 
> NAK.
> 
> As Corentin mentioned in another discussion, new DT variant should be 
> introduced for newer board model. Otherwise we can play this revert game with 
> each new revision which changes Ethernet PHY behaviour. It also makes most 
> sense to have naming chronologically sorted. If board name in DT file doesn't 
> have any postfix, it should be compatible with earliest publicly available 
> board. If board manufacturer releases new board variant with incompatible 
> changes, new DT with appropriate postfix should be introduced.
> 
> I understand that this is frustrating for you, but whole situation around 
> mentioned commit is unfortunate and we can't satisfy everyone.
> 
> Also good way to solve such issues is to apply DT overlay in bootloader based 
> on board revision number. I know Olimex implemented DT fixup in their 
> downstream U-Boot fork.

I agree with Jernej's here.
I had a quick look into the U-Boot source, and it seem like the Micrel
PHY should work there, since its phy_driver.config routine seems to
ignore the phy-mode property (in contrast to its 9131 sibling in the
same file). So we can go with the Realtek setting in the DT.

If U-Boot's networking itself is fine, we can just try to fix up the
DT. Looks like board/sunxi/board.c:ft_board_setup() is the place. The
PHY is autodetected, I am pretty sure we can somehow read the PHY
driver name, and depending on that just patch the phy-mode property.

Does that sound like a way out?

Cheers,
Andre

> Best regards,
> Jernej
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Bastien Roucariès <rouca@debian.org>
> > References: https://github.com/openwrt/openwrt/issues/9153
> > References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/hardware_revision_changes_log.txt
> > Signed-off-by: Petr Štetiar <ynezz@true.cz>
> > ---
> >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/  
> dts/sun7i-a20-olinuxino-lime2.dts
> > index ecb91fb899ff..8077f1716fbc 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > @@ -112,7 +112,7 @@ &gmac {
> >  	pinctrl-names = "default";
> >  	pinctrl-0 = <&gmac_rgmii_pins>;
> >  	phy-handle = <&phy1>;
> > -	phy-mode = "rgmii-id";
> > +	phy-mode = "rgmii";
> >  	status = "okay";
> >  };
> >  
> >   
> 
> 
> 

