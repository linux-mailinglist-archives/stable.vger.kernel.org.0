Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F44F6336
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiDFP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiDFP2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87F6343321;
        Wed,  6 Apr 2022 05:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45D8AB8232B;
        Wed,  6 Apr 2022 12:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B6C385A3;
        Wed,  6 Apr 2022 12:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649248112;
        bh=kEM4i/7mjSD9kvqkJT0FilhFPy81p7ObvOzAUQW1JQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4Lh2Rl6v0fBe/ww6iBNWpx4NP9kxSvaIB65hwDpaOTU5xSTH2yZjiKv28Cgzgesb
         52lrccVtlmx5Ek0buNPfM4KCrIZQlScfTAuvFwb5amua0cKSFZqyq3DMKrGo7hc+y/
         5w2/f5F8JSu1/Rz34byDIbFdyWsjZgqsD5++ciEU=
Date:   Wed, 6 Apr 2022 14:28:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, pierre-louis.bossart@linux.intel.com,
        Mark Brown <broonie@kernel.org>,
        yung-chuan.liao@linux.intel.com, peter.ujfalusi@linux.intel.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: Re: sof_es8336 build failure [was: [PATCH 5.17 0000/1126] 5.17.2-rc1
 review]
Message-ID: <Yk2HbuCEaSSh8sKc@kroah.com>
References: <20220405070407.513532867@linuxfoundation.org>
 <8ea245ed-eac9-1cd5-31bd-150a06378872@kernel.org>
 <06b5cc53-8de6-b238-70eb-9c1d5f245f78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06b5cc53-8de6-b238-70eb-9c1d5f245f78@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 09:37:59AM +0200, Jiri Slaby wrote:
> Cc some folks and change subject
> 
> On 06. 04. 22, 9:29, Jiri Slaby wrote:
> > On 05. 04. 22, 9:12, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.17.2 release.
> > > There are 1126 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > ...
> > > Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > >      ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP
> > 
> > Fails to build w/ suse x86_64 default config [1] (and x86_32 too):
> >  > sound/soc/intel/boards/sof_es8336.c: In function ‘sof_es8336_probe’:
> >  > sound/soc/intel/boards/sof_es8336.c:482:32: error: ‘struct
> > snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
> > mean ‘link_mask’?
> >  >   482 |         if (!mach->mach_params.i2s_link_mask) {
> >  >       |                                ^~~~~~~~~~~~~
> >  >       |                                link_mask
> >  > sound/soc/intel/boards/sof_es8336.c:494:39: error: ‘struct
> > snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
> > mean ‘link_mask’?
> >  >   494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
> >  >       |                                       ^~~~~~~~~~~~~
> >  >       |                                       link_mask
> >  > sound/soc/intel/boards/sof_es8336.c:496:44: error: ‘struct
> > snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
> > mean ‘link_mask’?
> >  >   496 |                 else if (mach->mach_params.i2s_link_mask &
> > BIT(1))
> >  >       |                                            ^~~~~~~~~~~~~
> >  >       |                                            link_mask
> >  > sound/soc/intel/boards/sof_es8336.c:498:45: error: ‘struct
> > snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
> > mean ‘link_mask’?
> >  >   498 |                 else  if (mach->mach_params.i2s_link_mask &
> > BIT(0))
> >  >       |                                             ^~~~~~~~~~~~~
> >  >       |                                             link_mask
> > 
> > So 679aa83a0fb70dcbf9e97c is missing -- but likely more is needed.
> > 
> > [1] https://raw.githubusercontent.com/SUSE/kernel-source/stable/config/x86_64/default
> > 
> > 

Offending commit now dropped, thanks!

greg k-h
