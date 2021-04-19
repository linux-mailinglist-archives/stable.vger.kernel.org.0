Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2620C3645AE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhDSOLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 10:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhDSOLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 10:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3767E61157;
        Mon, 19 Apr 2021 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618841431;
        bh=WownmydrOxpUOptLEvndagm/h1+q78v5YIgMfPsOigw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gxLYn1nwC4j4FMk2MybvtzHeq9hXCjTNK+a0K8oJqCi4CPjP9Lt5gYMM9eo9takxr
         PkLQxvmkFrNIJuUOwfcsNV/iNs04REe1NvUiZKGXCR/lsqbl5KwYHc5qzpcLTfqqpI
         phKU2H0xwGuMSFp1XGV4GitB7Tc0ckN8vsZszAck=
Date:   Mon, 19 Apr 2021 16:10:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kabel@kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YH2PVIinj48rrqtK@kroah.com>
References: <20210419134709.12859-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419134709.12859-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:47:09PM +0200, Pali Rohár wrote:
> commit 1fe976d308acb6374c899a4ee8025a0a016e453e upstream.
> 
> Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
> sensor reading"), Linux reports the temperature of Topaz hwmon as
> constant -75°C.
> 
> This is because switches from the Topaz family (88E6141 / 88E6341) have
> the address of the temperature sensor register different from Peridot.
> 
> This address is instead compatible with 88E1510 PHYs, as was used for
> Topaz before the above mentioned commit.
> 
> Create a new mapping table between switch family and PHY ID for families
> which don't have a model number. And define PHY IDs for Topaz and Peridot
> families.
> 
> Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
> The only difference from Peridot's PHY driver is the HWMON probing
> method.
> 
> Prior this change Topaz's internal PHY is detected by kernel as:
> 
>   PHY [...] driver [Marvell 88E6390] (irq=63)
> 
> And afterwards as:
> 
>   PHY [...] driver [Marvell 88E6341 Family] (irq=63)
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> BugLink: https://github.com/globalscaletechnologies/linux/issues/1
> Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [pali: Backported to 5.10 version]
> ---
> This patch is backported to 5.10 version. Tested on Turris Mox with Topaz switch.

Now queued up,t hanks.

greg k-h
