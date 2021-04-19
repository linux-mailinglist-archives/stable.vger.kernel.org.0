Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526FB3641C5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhDSMfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233651AbhDSMfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 08:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFB1561029;
        Mon, 19 Apr 2021 12:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618835724;
        bh=7xhdBvdsKZ2H5pkHnxQwbAnS451BCUO4/8gvKj56xG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yzk5hPEgVPFdojTw+xDCr1iHcmrryozVXosYUelI3+Co+452L/ccOfjoZOKUkQhEX
         nZrsaVtoQgaltzm8BzBPQjsXsCmhGgt+WEM2owcsBSI9dUnZWC5OLtvwQNjwdNOtft
         RNV8ynNljkyyh+65hNUXcoqegisIuv+1k1cF+vJg=
Date:   Mon, 19 Apr 2021 14:35:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kabel@kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YH15B/ZwuXg4R9lw@kroah.com>
References: <16187482432842@kroah.com>
 <161874858144103@kroah.com>
 <20210418131344.21024-1-pali@kernel.org>
 <YH1x/qt8wpOh0bvj@kroah.com>
 <20210419120856.xtym4nhplgwrtoot@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419120856.xtym4nhplgwrtoot@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 02:08:56PM +0200, Pali Rohár wrote:
> On Monday 19 April 2021 14:05:18 Greg KH wrote:
> > On Sun, Apr 18, 2021 at 03:13:44PM +0200, Pali Rohár wrote:
> > > commit 1fe976d308acb6374c899a4ee8025a0a016e453e upstream.
> > > 
> > > Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
> > > sensor reading"), Linux reports the temperature of Topaz hwmon as
> > > constant -75°C.
> > > 
> > > This is because switches from the Topaz family (88E6141 / 88E6341) have
> > > the address of the temperature sensor register different from Peridot.
> > > 
> > > This address is instead compatible with 88E1510 PHYs, as was used for
> > > Topaz before the above mentioned commit.
> > > 
> > > Create a new mapping table between switch family and PHY ID for families
> > > which don't have a model number. And define PHY IDs for Topaz and Peridot
> > > families.
> > > 
> > > Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
> > > The only difference from Peridot's PHY driver is the HWMON probing
> > > method.
> > > 
> > > Prior this change Topaz's internal PHY is detected by kernel as:
> > > 
> > >   PHY [...] driver [Marvell 88E6390] (irq=63)
> > > 
> > > And afterwards as:
> > > 
> > >   PHY [...] driver [Marvell 88E6341 Family] (irq=63)
> > > 
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > BugLink: https://github.com/globalscaletechnologies/linux/issues/1
> > > Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
> > > Reviewed-by: Marek Behún <kabel@kernel.org>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > [pali: Backported to 5.4 version]
> > > ---
> > > This patch is backported to 5.4 version. Tested on Turris Mox with Topaz switch.
> > 
> > What about a 5.10 version?
> 
> Is manual backport required also for 5.10? I got email that automatic
> backporting failed only for 4.19 and 5.4 versions.

It also failed for 5.10.y, so yes, if you could provide a version for
that tree it would be most appreciated.

thanks,

greg k-h
