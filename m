Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D982A7FB5
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgKENar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 08:30:47 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59553 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKENar (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 08:30:47 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2020 08:30:45 EST
Received: from cust-43cce789 ([IPv6:fc0c:c1a4:736c:9c1a:15d2:fd0f:664c:4844])
        by smtp-cloud8.xs4all.net with ESMTPSA
        id afElkDBJjNanzafEokoTFN; Thu, 05 Nov 2020 14:23:38 +0100
Message-ID: <64a618a3cc00de4a1c3887b57447906351db77b9.camel@tiscali.nl>
Subject: Re: [PATCH 5.9 080/391] ASoC: SOF: fix a runtime pm issue in SOF
 when HDMI codec doesnt work
From:   Paul Bolle <pebolle@tiscali.nl>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Date:   Thu, 05 Nov 2020 14:23:35 +0100
In-Reply-To: <20201103203352.505472614@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
         <20201103203352.505472614@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCGEJ0SEHC8hxLtU1zJbR5j6wVkwuwuqrCZxBwaDPHIl5/5hiM0Hs1zJkEgRYeuuQUvtonj0v+55Rg3ZrkVMxczgzKLJ6eqF98LZzAqIsaxd6cwCple1
 n0YtDe2EndKhclFww/5bBSaoMKNycEaRWNC/Fq+kvxDyGPmwvN7nRWXm7TeejQC/VsPWDQX9bTy4O9Q68c1JunilrubABMTvxRjWZDyE9DSLdTdcKHeF+z2b
 VpCD4PlSHISgPlvxzqeK3xD7e/zFHfxeZTne0F3pocj84q8jX63IMDdV3wLm3fBED5oBnDM68XI1cdoUls5o1wZMIYwOJNCWIl/WTyss5mo0gL6moVFToYzK
 rlH84gpdzXkLNbjJW/77LMq8asD/PGywIN89l5Sr69kMZNzmTQWNEADFwpbV8RlJ0J7WrIEu0M7YtzTcGf6xpTe+lBRP2AHYLudo6u1mfuSDNHGLBpRuwcDM
 wy4Br9MG4Sfw51lRu0SoHwwMmOUIp0aRJ8RRltP3VXJgoJubD9+UnZPfEiH2n7dACkafR3lyX5ufN7Sjq0Rt9kUQRzXRqs6xvwovhg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman schreef op di 03-11-2020 om 21:32 [+0100]:
> From: Rander Wang <rander.wang@intel.com>
> 
> [ Upstream commit 6c63c954e1c52f1262f986f36d95f557c6f8fa94 ]
> 
> When hda_codec_probe() doesn't initialize audio component, we disable
> the codec and keep going. However,the resources are not released. The
> child_count of SOF device is increased in snd_hdac_ext_bus_device_init
> but is not decrease in error case, so SOF can't get suspended.
> 
> snd_hdac_ext_bus_device_exit will be invoked in HDA framework if it
> gets a error. Now copy this behavior to release resources and decrease
> SOF device child_count to release SOF device.
> 
> Signed-off-by: Rander Wang <rander.wang@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Link: https://lore.kernel.org/r/20200825235040.1586478-3-ranjani.sridharan@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/sof/intel/hda-codec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
> index 2c5c451fa19d7..c475955c6eeba 100644
> --- a/sound/soc/sof/intel/hda-codec.c
> +++ b/sound/soc/sof/intel/hda-codec.c
> @@ -151,7 +151,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>  		if (!hdev->bus->audio_component) {
>  			dev_dbg(sdev->dev,
>  				"iDisp hw present but no driver\n");
> -			return -ENOENT;
> +			goto error;
>  		}
>  		hda_priv->need_display_power = true;
>  	}
> @@ -174,7 +174,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>  		 * other return codes without modification
>  		 */
>  		if (ret == 0)
> -			ret = -ENOENT;
> +			goto error;
>  	}
>  
>  	return ret;

My local build of v5.9.5 broke on this patch.

sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe': 
sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error' used but not defined 
  177 |    goto error; 
      |    ^~~~ 
make[4]: *** [scripts/Makefile.build:283: sound/soc/sof/intel/hda-codec.o] Error 1 
make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2 
make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2 
make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2 
make: *** [Makefile:1778: sound] Error 2

There's indeed no error label in v5.9.5. (There is one in v5.10-rc2, I just
checked.) Is no-one else running into this?

Thanks,


Paul Bolle

