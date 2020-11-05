Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669BF2A80C0
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 15:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgKEOV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 09:21:58 -0500
Received: from wp530.webpack.hosteurope.de ([80.237.130.52]:56322 "EHLO
        wp530.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbgKEOV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 09:21:58 -0500
X-Greylist: delayed 1989 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2020 09:21:57 EST
Received: from ip4d145e30.dynamic.kabel-deutschland.de ([77.20.94.48] helo=[192.168.66.101]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1kafcw-0004jl-Bi; Thu, 05 Nov 2020 14:48:34 +0100
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-39-sashal@kernel.org>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Subject: Build error with 5.9.5 in sound/soc/sof/intel/hda-codec.c (was:
 [PATCH AUTOSEL 5.9 039/147] ASoC: SOF: fix a runtime pm issue in SOF when
 HDMI codec doesn't work)
Message-ID: <f254331d-7ae2-e26f-3e1b-33a870349126@leemhuis.info>
Date:   Thu, 5 Nov 2020 14:48:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026234905.1022767-39-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1604586117;170aacbe;
X-HE-SMSGID: 1kafcw-0004jl-Bi
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lo! I just tried to compile 5.9.5 and ran into a build error with below 
patch. I only did a quick look (I have to leave the keyboard soon), but 
seems the patch quoted below that was added to 5.9.5 depends on 
11ec0edc6408 (git.kernel.org/linus/11ec0edc6408) which wasn't backported.

The build error can be found here:
https://kojipkgs.fedoraproject.org//work/tasks/8246/54978246/build.log

Relevant part:

+ make -s 'HOSTCFLAGS=-O2 -flto=auto -ffat-lto-objects -fexceptions -g 
-grecord-gcc-switches -pipe -Wall -Werror=format-security 
-Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS 
-specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong 
-specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -fcommon -m64 
-mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection' 
'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed  -Wl,-z,now 
-specs=/usr/lib/rpm/redhat/redhat-hardened-ld ' ARCH=x86_64 'KCFLAGS= ' 
WITH_GCOV=0 -j48 modules
sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe':
sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error' used but not 
defined
   177 |    goto error;
       |    ^~~~
make[4]: *** [scripts/Makefile.build:283: 
sound/soc/sof/intel/hda-codec.o] Error 1
make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2
make: *** [Makefile:1784: sound] Error 2
make: *** Waiting for unfinished jobs....
+ exit 1

Looks like the compiler is right from a quick look at
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/sound/soc/sof/intel/hda-codec.c?h=linux-5.9.y&id=43836fdc9e318a11233cf19c5ee7ffb04e8e5d8f

But as I said, I lack the time for a closer look.

Ciao, Thorsten

Am 27.10.20 um 00:47 schrieb Sasha Levin:
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
>   sound/soc/sof/intel/hda-codec.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
> index 2c5c451fa19d7..c475955c6eeba 100644
> --- a/sound/soc/sof/intel/hda-codec.c
> +++ b/sound/soc/sof/intel/hda-codec.c
> @@ -151,7 +151,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>   		if (!hdev->bus->audio_component) {
>   			dev_dbg(sdev->dev,
>   				"iDisp hw present but no driver\n");
> -			return -ENOENT;
> +			goto error;
>   		}
>   		hda_priv->need_display_power = true;
>   	}
> @@ -174,7 +174,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>   		 * other return codes without modification
>   		 */
>   		if (ret == 0)
> -			ret = -ENOENT;
> +			goto error;
>   	}
>   
>   	return ret;
> 

