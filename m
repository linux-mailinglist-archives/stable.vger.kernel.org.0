Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D44F6343
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiDFP3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbiDFP25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:28:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03402B6455;
        Wed,  6 Apr 2022 05:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CE0DB8232E;
        Wed,  6 Apr 2022 12:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBA3C385A7;
        Wed,  6 Apr 2022 12:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649248130;
        bh=lhzl1U57Qe8cjpHuHqDEXubDES3eaV7uHmLhtyalQ1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jg/0U5pUsnx+jbVWrFL7q/ngQlHrBAwc3atxGVQouRkrO7oXOt6F014Ujm6IzfeBd
         xiEpxheGzmBtFm9CZkoLcV9ojfigdMElSsVOhtC18aoSiTkC0OJr3W9b2O5nW6kHIU
         jSp/4V6YCZ3SXB4BJ2NWMfc4yoI+xiNpyiitBSKE=
Date:   Wed, 6 Apr 2022 14:28:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?iso-8859-1?Q?P=E9ter?= Ujfalusi 
        <peter.ujfalusi@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.17 0943/1126] ASoC: Intel: sof_es8336: use NHLT
 information to set dmic and SSP
Message-ID: <Yk2HfyiBtnY/RpgN@kroah.com>
References: <20220405070407.513532867@linuxfoundation.org>
 <20220405070435.188697055@linuxfoundation.org>
 <20220405214409.52f3ede7@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405214409.52f3ede7@mir>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:44:09PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2022-04-05, Greg Kroah-Hartman wrote:
> > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> >
> > [ Upstream commit 651c304df7f6e3fbb4779527efa3eb128ef91329 ]
> >
> > Since we see a proliferation of devices with various configurations,
> > we want to automatically set the DMIC and SSP information. This patch
> > relies on the information extracted from NHLT and partially reverts
> > existing DMI quirks added by commit a164137ce91a ("ASoC: Intel: add
> > machine driver for SOF+ES8336")
> >
> > Note that NHLT can report multiple SSPs, choosing from the
> > ssp_link_mask in an MSB-first manner was found experimentally to work
> > fine.
> >
> > The only thing that cannot be detected is the GPIO type, and users may
> > want to use the quirk override parameter if the 'wrong' solution is
> > provided.
> [...]
> 
> This patch, as part of v5.17.2-rc1 seems to introduce a build failure
> on x86_64 (with CONFIG_SND_SOC_INTEL_SOF_ES8336_MACH=m):
> 
>   LD [M]  sound/soc/intel/boards/snd-soc-sof_rt5682.o
>   LD [M]  sound/soc/intel/boards/snd-soc-sof_cs42l42.o
>   CC [M]  sound/soc/intel/boards/sof_es8336.o
> /build/linux-5.17/sound/soc/intel/boards/sof_es8336.c: In function 'sof_es8336_probe':
> /build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:482:32: error: 'struct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you mean 'link_mask'?
>   482 |         if (!mach->mach_params.i2s_link_mask) {
>       |                                ^~~~~~~~~~~~~
>       |                                link_mask
> /build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:494:39: error: 'struct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you mean 'link_mask'?
>   494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
>       |                                       ^~~~~~~~~~~~~
>       |                                       link_mask
> /build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:496:44: error: 'struct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you mean 'link_mask'?
>   496 |                 else if (mach->mach_params.i2s_link_mask & BIT(1))
>       |                                            ^~~~~~~~~~~~~
>       |                                            link_mask
> /build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:498:45: error: 'struct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you mean 'link_mask'?
>   498 |                 else  if (mach->mach_params.i2s_link_mask & BIT(0))
>       |                                             ^~~~~~~~~~~~~
>       |                                             link_mask
> make[4]: *** [/build/linux-5.17/scripts/Makefile.build:288: sound/soc/intel/boards/sof_es8336.o] Error 1
> 
> Reverting just this patch lets the build, using the same buildconfig,
> succeed again.

Offending commit now dropped, thanks!

greg k-h
