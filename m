Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D0657031
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 23:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiL0WZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 17:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL0WZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 17:25:20 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BF6CCD8;
        Tue, 27 Dec 2022 14:25:19 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 113C42F4;
        Tue, 27 Dec 2022 14:26:00 -0800 (PST)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC9FA3F663;
        Tue, 27 Dec 2022 14:25:16 -0800 (PST)
Date:   Tue, 27 Dec 2022 22:23:30 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>, kishon@kernel.org,
        wens@csie.org, jernej.skrabec@gmail.com,
        wsa+renesas@sang-engineering.com, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 1/7] phy: sun4i-usb: Add support for the
 H616 USB PHY
Message-ID: <20221227222330.5ebdf780@slackpad.lan>
In-Reply-To: <530561e9-9ef8-7c8c-8e73-838c86a92266@sholland.org>
References: <20221227203512.1214527-1-sashal@kernel.org>
        <530561e9-9ef8-7c8c-8e73-838c86a92266@sholland.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Dec 2022 15:58:16 -0600
Samuel Holland <samuel@sholland.org> wrote:

> Hi Sasha,
> 
> On 12/27/22 14:35, Sasha Levin wrote:
> > From: Andre Przywara <andre.przywara@arm.com>
> > 
> > [ Upstream commit 0f607406525d25019dd9c498bcc0b42734fc59d5 ]
> > 
> > The USB PHY used in the Allwinner H616 SoC inherits some traits from its
> > various predecessors: it has four full PHYs like the H3, needs some
> > extra bits to be set like the H6, and puts SIDDQ on a different bit like
> > the A100. Plus it needs this weird PHY2 quirk.
> > 
> > Name all those properties in a new config struct and assign a new
> > compatible name to it.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Reviewed-by: Samuel Holland <samuel@sholland.org>
> > Link: https://lore.kernel.org/r/20221031111358.3387297-5-andre.przywara@arm.com
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/phy/allwinner/phy-sun4i-usb.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
> > index 651d5e2a25ce..230987e55ece 100644
> > --- a/drivers/phy/allwinner/phy-sun4i-usb.c
> > +++ b/drivers/phy/allwinner/phy-sun4i-usb.c
> > @@ -974,6 +974,17 @@ static const struct sun4i_usb_phy_cfg sun50i_h6_cfg = {
> >  	.missing_phys = BIT(1) | BIT(2),
> >  };
> >  
> > +static const struct sun4i_usb_phy_cfg sun50i_h616_cfg = {
> > +	.num_phys = 4,
> > +	.type = sun50i_h6_phy,
> > +	.disc_thresh = 3,
> > +	.phyctl_offset = REG_PHYCTL_A33,
> > +	.dedicated_clocks = true,
> > +	.phy0_dual_route = true,
> > +	.hci_phy_ctl_clear = PHY_CTL_SIDDQ,
> > +	.needs_phy2_siddq = true,  
> 
> This will fail to compile without b45c6d80325b ("phy: sun4i-usb:
> Introduce port2 SIDDQ quirk"). However, like Andre mentioned in
> reference to the devicetree updates[1], we were not expecting any of
> these patches to be backported. Since you already dropped the DT
> portion, there is no need to bother with these two patches either.

Well, definitely not for 5.4 and 5.10, since the essential pinctrl and
clock patches for the H616 were only added in 5.12, so there is no
point in having USB support.

I don't know how useful it is for 6.0, but having both patches in 6.1
would make some sense, since it's an LTS kernel. The H616 SoC became
usable in 6.0, with the USB patches being delayed back then. And it's
only those two that are missing from enabling USB support, IIRC.
The DT part is not really relevant, since you can always use U-Boot's
DT (recommended) or the DT from any newer kernel.

So from an user's perspective, it would be very helpful to just have:
- [PATCH AUTOSEL 6.1 12/28]
- [PATCH AUTOSEL 6.1 13/28]
Personally I would support this, since it makes all H616 based devices
much more usable with next year's distribution kernels.

I don't know if this fulfils the stable kernel rules, though, since
strictly speaking they don't fix anything, but add (USB) support to a
new SoC. Then again they are little risk, since most of the code is
guarded by H616 filters, so wouldn't be used by other SoCs.

Cheers,
Andre

> 
> Regards,
> Samuel
> 
> [1]: https://lore.kernel.org/lkml/20221220000115.19c152fe@slackpad.lan/
> 
> > +};
> > +
> >  static const struct of_device_id sun4i_usb_phy_of_match[] = {
> >  	{ .compatible = "allwinner,sun4i-a10-usb-phy", .data = &sun4i_a10_cfg },
> >  	{ .compatible = "allwinner,sun5i-a13-usb-phy", .data = &sun5i_a13_cfg },
> > @@ -988,6 +999,7 @@ static const struct of_device_id sun4i_usb_phy_of_match[] = {
> >  	{ .compatible = "allwinner,sun50i-a64-usb-phy",
> >  	  .data = &sun50i_a64_cfg},
> >  	{ .compatible = "allwinner,sun50i-h6-usb-phy", .data = &sun50i_h6_cfg },
> > +	{ .compatible = "allwinner,sun50i-h616-usb-phy", .data = &sun50i_h616_cfg },
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(of, sun4i_usb_phy_of_match);  
> 

