Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661E036421F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhDSM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhDSM53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 08:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C99661107;
        Mon, 19 Apr 2021 12:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837019;
        bh=cTgs9pm2rq228Qo6aQ8yi0b6TU1sj5k9OZnCIyYX6yM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3+jCd4B5qBNBb9y9Uv1TngquDyugfjViCXQLNwu+2VUgRFE8OJoHZpe9CD1a0DXB
         S/KWC+pF1RjO+CG++EjxtZgIPkk+gmTewfZQ8n9nvlA4REO/SAnGt0rSKurqgpjBpE
         Vk5PsFEjRhonMa/qsFzsDPwULuPrXaYEulnt/3a0=
Date:   Mon, 19 Apr 2021 14:56:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kabel@kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YH1+FoK4eScCnIAq@kroah.com>
References: <16187482432842@kroah.com>
 <161874858144103@kroah.com>
 <20210418131344.21024-1-pali@kernel.org>
 <YH1x/qt8wpOh0bvj@kroah.com>
 <20210419120856.xtym4nhplgwrtoot@pali>
 <YH15B/ZwuXg4R9lw@kroah.com>
 <20210419124711.h55orlwpgjizjmuf@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419124711.h55orlwpgjizjmuf@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 02:47:11PM +0200, Pali Rohár wrote:
> On Monday 19 April 2021 14:35:19 Greg KH wrote:
> > On Mon, Apr 19, 2021 at 02:08:56PM +0200, Pali Rohár wrote:
> > > On Monday 19 April 2021 14:05:18 Greg KH wrote:
> > > > On Sun, Apr 18, 2021 at 03:13:44PM +0200, Pali Rohár wrote:
> > > > > commit 1fe976d308acb6374c899a4ee8025a0a016e453e upstream.
> > > > > 
> > > > > Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
> > > > > sensor reading"), Linux reports the temperature of Topaz hwmon as
> > > > > constant -75°C.
> > > > > 
> > > > > This is because switches from the Topaz family (88E6141 / 88E6341) have
> > > > > the address of the temperature sensor register different from Peridot.
> > > > > 
> > > > > This address is instead compatible with 88E1510 PHYs, as was used for
> > > > > Topaz before the above mentioned commit.
> > > > > 
> > > > > Create a new mapping table between switch family and PHY ID for families
> > > > > which don't have a model number. And define PHY IDs for Topaz and Peridot
> > > > > families.
> > > > > 
> > > > > Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
> > > > > The only difference from Peridot's PHY driver is the HWMON probing
> > > > > method.
> > > > > 
> > > > > Prior this change Topaz's internal PHY is detected by kernel as:
> > > > > 
> > > > >   PHY [...] driver [Marvell 88E6390] (irq=63)
> > > > > 
> > > > > And afterwards as:
> > > > > 
> > > > >   PHY [...] driver [Marvell 88E6341 Family] (irq=63)
> > > > > 
> > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > BugLink: https://github.com/globalscaletechnologies/linux/issues/1
> > > > > Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
> > > > > Reviewed-by: Marek Behún <kabel@kernel.org>
> > > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > > > [pali: Backported to 5.4 version]
> > > > > ---
> > > > > This patch is backported to 5.4 version. Tested on Turris Mox with Topaz switch.
> > > > 
> > > > What about a 5.10 version?
> > > 
> > > Is manual backport required also for 5.10? I got email that automatic
> > > backporting failed only for 4.19 and 5.4 versions.
> > 
> > It also failed for 5.10.y, so yes, if you could provide a version for
> > that tree it would be most appreciated.
> 
> Ok! I will prepare it, no problem. I just did not know that it failed
> also for 5.10 as I have not received any email about it.

Odd, I must have forgotten to add that version to the command line
script I run to tell people that a patch failed, sorry about that.

greg k-h
