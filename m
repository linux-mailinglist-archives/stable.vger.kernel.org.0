Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB50487A41
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 17:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiAGQZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 11:25:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47404 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiAGQZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 11:25:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F8961210
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 16:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E155C36AE0;
        Fri,  7 Jan 2022 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641572705;
        bh=0Gy6JzDjbAu9qXU60ydhgxzBbpOCDxGcLjhnSDJg7fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M1m2z15KD8xJuY+MTc1XdZHHdoWovdJqJuI8WvT/EWAfyBPjRm1UbyxH4V+dlNIdf
         fGOMInbxkmALEN2H/3XVTwuFGkPvXB3X//R4LW9tV0Qmlitobn/GXJCjLF0FqEtB0B
         /Hdlp5vRA2PXpyvt5RxEbrKSgItt6yPG26Digqig=
Date:   Fri, 7 Jan 2022 17:25:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wadim Egorov <w.egorov@phytec.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <YdhpXV0fXhV43RBY@kroah.com>
References: <20220107143043.2189378-1-w.egorov@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107143043.2189378-1-w.egorov@phytec.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 03:30:43PM +0100, Wadim Egorov wrote:
> From: Christian Melki <christian.melki@t2data.com>
> 
> commit 764d31cacfe48440745c4bbb55a62ac9471c9f19 upstream.
> 
> Following a similar reinstate for the KSZ9031.
> 
> Older kernels would use the genphy_soft_reset if the PHY did not implement
> a .soft_reset.
> 
> Bluntly removing that default may expose a lot of situations where various
> PHYs/board implementations won't recover on various changes.
> Like with this implementation during a 4.9.x to 5.4.x LTS transition.
> I think it's a good thing to remove unwanted soft resets but wonder if it
> did open a can of worms?
> 
> Atleast this fixes one iMX6 FEC/RMII/8081 combo.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Christian Melki <christian.melki@t2data.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Link: https://lore.kernel.org/r/20210224205536.9349-1-christian.melki@t2data.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
> ---
>  drivers/net/phy/micrel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 0b61d80ea3f8..18cc5e4280e8 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1096,6 +1096,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.probe		= kszphy_probe,
>  	.config_init	= ksz8081_config_init,
>  	.ack_interrupt	= kszphy_ack_interrupt,
> +	.soft_reset	= genphy_soft_reset,
>  	.config_intr	= kszphy_config_intr,
>  	.get_sset_count = kszphy_get_sset_count,
>  	.get_strings	= kszphy_get_strings,
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
