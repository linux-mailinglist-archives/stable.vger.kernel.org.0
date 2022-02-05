Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32E94AAC44
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 20:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbiBET1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 14:27:46 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:41530 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiBET1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 14:27:45 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 848C18001D4C;
        Sat,  5 Feb 2022 22:27:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 848C18001D4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644089264;
        bh=6d946YNSYy9lBn5l3Uo3PEpFMtGbZ/0eghbBZieAOzA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=GrKRvH4A0mai9uO5s4cQr3hPcxRI1x5S/VZ7OEHjULRZwhJsFHxcSiJT7ZMCtGQ0V
         oMaR0kqw/ltKKRr3tU1Vm9jEnVdJ4dml0HrCG68gz71mDX7DqRY4m7mxFtVsL2Tlk/
         HCfv/wij7Y4tO4qdLQoYnPtU4z0ZvVjMIbuB094U=
Received: from mobilestation (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Sat, 5 Feb 2022 22:27:29 +0300
Date:   Sat, 5 Feb 2022 22:27:43 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting
 in 88e1121-compatible PHYs
Message-ID: <20220205192743.vzjkxrnwq3tbufme@mobilestation>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
 <20220205190814.20282-1-Pavel.Parkhomenko@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220205190814.20282-1-Pavel.Parkhomenko@baikalelectronics.ru>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Folks,

Ah, sorry for the noise. A wrong version of the patch was by mistake sent to
you, Russel, and to the netdev stable list only. Please just ignore
it. There is another patch, which we are going to re-send shortly to
all the required addressee.

-Serge

On Sat, Feb 05, 2022 at 10:08:14PM +0300, Pavel Parkhomenko wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply it'
> being done on the PHY side will consequently cause the traffic loss. We
> discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.
> 
> Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Link: https://lore.kernel.org/netdev/96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru/
> Changelog v2:
> - Add "net" suffix into the PATCH-clause of the subject.
> - Cc the patch to the stable tree list.
> - Rebase onto the latset netdev/net branch with the top commit
> ---
>  drivers/net/phy/marvell.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index fa71fb7a66b5..4b8f822f8c51 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -553,9 +553,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
>  	else
>  		mscr = 0;
>  
> -	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> -				MII_88E1121_PHY_MSCR_REG,
> -				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
> +	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
> +					MII_88E1121_PHY_MSCR_REG,
> +					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
>  }
>  
>  static int m88e1121_config_aneg(struct phy_device *phydev)
> @@ -569,11 +569,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
>  			return err;
>  	}
>  
> +	changed = err;
> +
>  	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
>  	if (err < 0)
>  		return err;
>  
> -	changed = err;
> +	changed |= err;
>  
>  	err = genphy_config_aneg(phydev);
>  	if (err < 0)
> @@ -1211,17 +1213,22 @@ static int m88e1510_config_init(struct phy_device *phydev)
>  
>  static int m88e1118_config_aneg(struct phy_device *phydev)
>  {
> +	int changed = 0;
>  	int err;
>  
> -	err = genphy_soft_reset(phydev);
> +	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
>  	if (err < 0)
>  		return err;
>  
> -	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
> +	changed = err;
> +
> +	err = genphy_config_aneg(phydev);
>  	if (err < 0)
>  		return err;
>  
> -	err = genphy_config_aneg(phydev);
> +	if (phydev->autoneg != AUTONEG_ENABLE || changed)
> +		return genphy_soft_reset(phydev);
> +
>  	return 0;
>  }
>  
> -- 
> 2.34.1
> 
