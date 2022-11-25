Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638F7638478
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 08:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKYH3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 02:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKYH3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 02:29:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC80E240A3
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 23:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86A4062240
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 07:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0196C433D6;
        Fri, 25 Nov 2022 07:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669361380;
        bh=uhGxFeY9LyGFmFlDmU3F9aDauq7CH4tJBuWChnXzBQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ynjm6ASOWcdmME4A3ir7eI0+LcM8+TbYIAGFLQCY5z+jX2UsJmbhHQE/clbmsUiRU
         HtjEi25ZBpS6tNwKSOnCPILhiIngpZpo4xKkl000ikzZeP9kkgBFE5BiJBrzTXHYFL
         plTcMxRPVVoaUkpGXKzFbcA7ohJOr3+XcRLinlmc=
Date:   Fri, 25 Nov 2022 08:29:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 011/149] ASoC: Intel: sof_sdw: add quirk variant for
 LAPBC710 NUC15
Message-ID: <Y4Bu3/cTg/kCql6v@kroah.com>
References: <20221123084557.945845710@linuxfoundation.org>
 <20221123084558.387879056@linuxfoundation.org>
 <Y392B4HibRmMU1o3@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y392B4HibRmMU1o3@eldamar.lan>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 02:47:51PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Nov 23, 2022 at 09:49:54AM +0100, Greg Kroah-Hartman wrote:
> > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > 
> > [ Upstream commit 41deb2db64997d01110faaf763bd911d490dfde7 ]
> > 
> > Some NUC15 LAPBC710 devices don't expose the same DMI information as
> > the Intel reference, add additional entry in the match table.
> > 
> > BugLink: https://github.com/thesofproject/linux/issues/3885
> > Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> > Link: https://lore.kernel.org/r/20221017204054.207512-1-pierre-louis.bossart@linux.intel.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  sound/soc/intel/boards/sof_sdw.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > index 25548555d8d7..5e1a718a64da 100644
> > --- a/sound/soc/intel/boards/sof_sdw.c
> > +++ b/sound/soc/intel/boards/sof_sdw.c
> > @@ -175,6 +175,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> >  					SOF_SDW_PCH_DMIC |
> >  					SOF_RT711_JD_SRC_JD2),
> >  	},
> > +	{
> > +		/* NUC15 LAPBC710 skews */
> > +		.callback = sof_sdw_quirk_cb,
> > +		.matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
> > +		},
> > +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> > +					SOF_SDW_PCH_DMIC |
> > +					RT711_JD1),
> > +	},
> >  	/* TigerLake-SDCA devices */
> >  	{
> >  		.callback = sof_sdw_quirk_cb,
> > -- 
> > 2.35.1
> 
> This one causes a build failure for 5.10.156-rc1 (not tested newer
> ones possibly affected):
> 
> sound/soc/intel/boards/sof_sdw.c:187:6: error: ‘RT711_JD1’ undeclared here (not in a function)
>   187 |      RT711_JD1),
>       |      ^~~~~~~~~
> make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1
> make[6]: *** [scripts/Makefile.build:503: sound/soc/intel/boards] Error 2
> make[5]: *** [scripts/Makefile.build:503: sound/soc/intel] Error 2
> make[4]: *** [scripts/Makefile.build:503: sound/soc] Error 2
> make[3]: *** [Makefile:1837: sound] Error 2
> make[3]: *** Waiting for unfinished jobs....
> 
> If not mistaken this is because 5.10.y does not have yet 8e6c00f1fdea ("ASoC:
> Intel: sof_sdw: include rt711.h for RT711 JD mode") which is present on
> 5.15-rc1 onwards.

Thanks, I've now dropped this commit.

greg k-h
