Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E1A2E776C
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 10:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgL3J2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 04:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgL3J2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 04:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A67220781;
        Wed, 30 Dec 2020 09:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609320476;
        bh=mqG3cXbNjrt1D6ev+R04acOuzGKfS+yInJ9c/d85gPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6WhCaOvgtavsTdnJu8aVVRQac0J5B70e1mULAWLvlNdVi8tuqFiy7zFXCqqodbds
         u6Qrb9V5iXMadaqVIuxF67aDHxvwvh8YgUoXTytTcplvoTEZJvp2SUXozxQAmNkPs3
         RL3UuUHRTieLs04+gVghSMzikv3+QMQw1thv7UP0=
Date:   Wed, 30 Dec 2020 10:29:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 212/717] platform/x86: mlx-platform: Remove PSU
 EEPROM from MSN274x platform configuration
Message-ID: <X+xIaxkuYMFIowSd@kroah.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125031.129265421@linuxfoundation.org>
 <20201229190144.GA1515901@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229190144.GA1515901@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 12:01:44PM -0700, Nathan Chancellor wrote:
> On Mon, Dec 28, 2020 at 01:43:30PM +0100, Greg Kroah-Hartman wrote:
> > From: Vadim Pasternak <vadimp@nvidia.com>
> > 
> > [ Upstream commit 912b341585e302ee44fc5a2733f7bcf505e2c86f ]
> > 
> > Remove PSU EEPROM configuration for systems class equipped with
> > Mellanox chip Spectrum and ATOM CPU - system types MSN274x. Till now
> > all the systems from this class used few types of power units, all
> > equipped with EEPROM device with address space two bytes. Thus, all
> > these devices have been handled by EEPROM driver "24c02".
> > 
> > There is a new requirement is to support power unit replacement by "off
> > the shelf" device, matching electrical required parameters. Such device
> > can be equipped with different EEPROM type, which could be one byte
> > address space addressing or even could be not equipped with EEPROM.
> > In such case "24c02" will not work.
> > 
> > Fixes: ef08e14a3 ("platform/x86: mlx-platform: Add support for new msn274x system type")
> > Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
> > Link: https://lore.kernel.org/r/20201125101056.174708-3-vadimp@nvidia.com
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/platform/x86/mlx-platform.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
> > index 623e7f737d4ab..598f445587649 100644
> > --- a/drivers/platform/x86/mlx-platform.c
> > +++ b/drivers/platform/x86/mlx-platform.c
> > @@ -601,15 +601,13 @@ static struct mlxreg_core_data mlxplat_mlxcpld_msn274x_psu_items_data[] = {
> >  		.label = "psu1",
> >  		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
> >  		.mask = BIT(0),
> > -		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[0],
> > -		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
> > +		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
> >  	},
> >  	{
> >  		.label = "psu2",
> >  		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
> >  		.mask = BIT(1),
> > -		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[1],
> > -		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
> > +		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
> >  	},
> >  };
> >  
> > -- 
> > 2.27.0
> > 
> > 
> > 
> 
> Please pick up eca6ba20f38c ("platform/x86: mlx-platform: remove an
> unused variable") everywhere that this patch was applied to avoid
> introducing a new clang warning.

Now queued up, thanks.

greg k-h
