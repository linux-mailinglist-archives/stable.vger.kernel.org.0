Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA243C6982
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 06:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhGMEq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 00:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhGMEq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 00:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E21161026;
        Tue, 13 Jul 2021 04:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626151445;
        bh=LhQ88MmfLPgOgVF9V7BGRh5TOT9dUVIs3HJWRwi/M/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BC3ljYCFeJX0g7nn9XG2d24A3mG2UG5gGN9eA6jn1Ejes2QpC/K/xiIwax5ccS1/p
         pwXsa2WLUb4CPQtUrJpwp8GHxNddjlkse0poNTvo1+/FOkKHinyYSQHKcLUgXbtYs+
         jMsDybxPtlivulap/rxVzSvjnu0sX2OwecK5nzoE=
Date:   Tue, 13 Jul 2021 06:44:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>,
        Yong Zhi <yong.zhi@intel.com>, Bard Liao <bard.liao@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for
 Brya and BT-offload
Message-ID: <YO0aEm/kWuu1UCow@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712061045.833441566@linuxfoundation.org>
 <20210713054118.4e5abba3@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713054118.4e5abba3@mir>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 05:41:18AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2021-07-12, Greg Kroah-Hartman wrote:
> > From: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
> >
> > [ Upstream commit 03effde3a2ea1d82c4dd6b634fc6174545d2c34f ]
> >
> > Brya is another ADL-P product.
> >
> > AlderLake has support for Bluetooth audio offload capability.
> > Enable the BT-offload quirk for ADL-P Brya and the Intel RVP.
> [...]
> 
> This patch seems to introduce a build failure into v5.13.2-rc1 on x86_64:
> 
>   CC [M]  sound/soc/intel/boards/sof_sdw.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt5682.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt700.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt711.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt711_sdca.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt715.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_rt715_sdca.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_dmic.o
>   CC [M]  sound/soc/intel/boards/sof_sdw_hdmi.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sof_rt5682.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-haswell.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-bxt-da7219_max98357a.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-bxt-rt298.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-sof-pcm512x.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-sof-wm8804.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-glk-rt5682_max98357a.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-broadwell.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-bdw-rt5650-mach.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-bytcr-rt5640.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-bytcr-rt5651.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-rt5672.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-rt5645.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-max98090_ti.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-nau8824.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-cx2072x.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-da7213.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-es8316.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-nocodec.o
>   LD [M]  sound/soc/intel/boards/snd-soc-cml_rt1011_rt5682.o
>   LD [M]  sound/soc/intel/boards/snd-soc-kbl_da7219_max98357a.o
>   LD [M]  sound/soc/intel/boards/snd-soc-kbl_da7219_max98927.o
>   CHK     kernel/kheaders_data.tar.xz
>   LD [M]  sound/soc/intel/boards/snd-soc-kbl_rt5663_max98927.o
>   LD [M]  sound/soc/intel/boards/snd-soc-kbl_rt5660.o
>   LD [M]  sound/soc/intel/boards/snd-soc-skl_rt286.o
>   LD [M]  sound/soc/intel/boards/snd-skl_nau88l25_max98357a.o
>   LD [M]  sound/soc/intel/boards/snd-soc-skl_nau88l25_ssm4567.o
>   LD [M]  sound/soc/intel/boards/snd-soc-skl_hda_dsp.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sof_da7219_max98373.o
>   LD [M]  sound/soc/intel/boards/snd-soc-ehl-rt5660.o
>   LD [M]  sound/soc/snd-soc-acpi.o
> /build/linux-aptosid-5.13/sound/soc/intel/boards/sof_sdw.c:200:6: error: implicit declaration of function 'SOF_BT_OFFLOAD_SSP' [-Werror=implicit-function-declaration]
>   200 |      SOF_BT_OFFLOAD_SSP(2) |
>       |      ^~~~~~~~~~~~~~~~~~
>   LD [M]  sound/soundcore.o
>   LD [M]  sound/soc/sof/xtensa/snd-sof-xtensa-dsp.o
> /build/linux-aptosid-5.13/sound/soc/intel/boards/sof_sdw.c:201:6: error: 'SOF_SSP_BT_OFFLOAD_PRESENT' undeclared here (not in a function)
>   201 |      SOF_SSP_BT_OFFLOAD_PRESENT),
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
>   LD [M]  sound/soc/sof/intel/snd-sof-acpi-intel-bdw.o
>   LD [M]  sound/soc/sof/intel/snd-sof-intel-hda.o
>   LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-tng.o
>   LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-apl.o
>   LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-cnl.o
>   LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-icl.o
>   LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-tgl.o
> cc1: some warnings being treated as errors
> make[5]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:273: sound/soc/intel/boards/sof_sdw.o] Error 1
> 
> > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > index dfad2ad129ab..35ad448902c7 100644
> > --- a/sound/soc/intel/boards/sof_sdw.c
> > +++ b/sound/soc/intel/boards/sof_sdw.c
> > @@ -197,7 +197,21 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> >  		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
> >  					SOF_SDW_TGL_HDMI |
> >  					SOF_RT715_DAI_ID_FIX |
> > -					SOF_SDW_PCH_DMIC),
> > +					SOF_SDW_PCH_DMIC |
> > +					SOF_BT_OFFLOAD_SSP(2) |
> > +					SOF_SSP_BT_OFFLOAD_PRESENT),
> > +	},
> > +	{
> > +		.callback = sof_sdw_quirk_cb,
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "Brya"),
> > +		},
> > +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> > +					SOF_SDW_PCH_DMIC |
> > +					SOF_SDW_FOUR_SPK |
> > +					SOF_BT_OFFLOAD_SSP(2) |
> > +					SOF_SSP_BT_OFFLOAD_PRESENT),
> >  	},
> >  	{}
> >  };
> 

Already dropped, thanks!

greg k-h
