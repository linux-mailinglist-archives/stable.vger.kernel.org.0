Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9860A45D4CB
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 07:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346780AbhKYGby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 01:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347627AbhKYG3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 01:29:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E0C6101D;
        Thu, 25 Nov 2021 06:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637821602;
        bh=9ilxkP0MowwyQlRFGUCFz/9i0GPcZPYwTNX6q2HydnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+CEtR8AhN5afYzdOmy6ckH2PRnHGVJgmfQBM8KmbGnVf4AHhc45/fcw1y5eQ5EJT
         JdQquZWtaqWlhQ+BcCYkw/Chs+e4biNm5emuPVTZib/mmKgVa9P9+a17OxSB4iRg7O
         SXlXyu2wy9e7HWixUMaThGw2ryKxj/i+nE9X2T0A=
Date:   Thu, 25 Nov 2021 07:26:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 028/154] ASoC: Intel: sof_sdw: add missing quirk for
 Dell SKU 0A45
Message-ID: <YZ8soCFxqgawo/NP@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124115703.278367629@linuxfoundation.org>
 <YZ60vklYVessSxeU@eldamar.lan>
 <YZ62NH7krtupEhTa@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZ62NH7krtupEhTa@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 11:01:24PM +0100, Salvatore Bonaccorso wrote:
> On Wed, Nov 24, 2021 at 10:55:10PM +0100, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Wed, Nov 24, 2021 at 12:57:04PM +0100, Greg Kroah-Hartman wrote:
> > > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > 
> > > [ Upstream commit 64ba6d2ce72ffde70dc5a1794917bf1573203716 ]
> > > 
> > > This device is based on SDCA codecs but with a single amplifier
> > > instead of two.
> > > 
> > > BugLink: https://github.com/thesofproject/linux/issues/3161
> > > Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Rander Wang <rander.wang@intel.com>
> > > Reviewed-by: Bard Liao <bard.liao@intel.com>
> > > Link: https://lore.kernel.org/r/20211004213512.220836-6-pierre-louis.bossart@linux.intel.com
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > > index 25548555d8d79..d9b864856be19 100644
> > > --- a/sound/soc/intel/boards/sof_sdw.c
> > > +++ b/sound/soc/intel/boards/sof_sdw.c
> > > @@ -187,6 +187,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> > >  					SOF_RT715_DAI_ID_FIX |
> > >  					SOF_SDW_FOUR_SPK),
> > >  	},
> > > +	{
> > > +		.callback = sof_sdw_quirk_cb,
> > > +		.matches = {
> > > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A45")
> > > +		},
> > > +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> > > +					RT711_JD2 |
> > > +					SOF_RT715_DAI_ID_FIX),
> > > +	},
> > >  	/* AlderLake devices */
> > >  	{
> > >  		.callback = sof_sdw_quirk_cb,
> > 
> > This one causes a build failure:
> > 
> > sound/soc/intel/boards/sof_sdw.c:197:41: error: ‘RT711_JD2’ undeclared here (not in a function)
> >   197 |                                         RT711_JD2 |
> >       |                                         ^~~~~~~~~
> >   CC      lib/mpi/mpicoder.o
> > make[7]: *** [scripts/Makefile.build:280: sound/soc/intel/boards/sof_sdw.o] Error 1
> > make[6]: *** [scripts/Makefile.build:497: sound/soc/intel/boards] Error 2
> > make[5]: *** [scripts/Makefile.build:497: sound/soc/intel] Error 2
> > make[4]: *** [scripts/Makefile.build:497: sound/soc] Error 2
> > make[3]: *** [Makefile:1822: sound] Error 2
> > 
> > We do not have for instance 8e6c00f1fdea ("ASoC: Intel: sof_sdw: include
> > rt711.h for RT711 JD mode") for stable series. 
> 
> Should have added: [...] before 5.15-rc1.

Thanks, I'll go drop the commit for now, if someone needs/wants it, I'll
take a working backport :)

thanks,

greg k-h
