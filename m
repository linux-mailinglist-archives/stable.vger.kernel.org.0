Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F072A8108
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 15:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgKEOf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 09:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgKEOfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 09:35:55 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5EE22078E;
        Thu,  5 Nov 2020 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604586955;
        bh=koczk0h3+aDrB9Ca+JmHyqTqMhq2kIrm4R015M/HJ/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kKBwXk3B8KxkvQG9GhCCbGla8J26xCjbh4VFwWKX9F77ErtYQVK6QeT8xrfQAaP8T
         EVaTHdzMp+e0HonLp01wH4DaoaipM2c878cnCQW2xUxjOw6+oQhkJmpsfvVj3bGvMq
         NLVs4JBJJznPkkW6VOAaDH2w+tZR3qsXPTQHUYw8=
Date:   Thu, 5 Nov 2020 09:35:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paul Bolle <pebolle@tiscali.nl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.9 080/391] ASoC: SOF: fix a runtime pm issue in SOF
 when HDMI codec doesnt work
Message-ID: <20201105143551.GH2092@sasha-vm>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201103203352.505472614@linuxfoundation.org>
 <64a618a3cc00de4a1c3887b57447906351db77b9.camel@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <64a618a3cc00de4a1c3887b57447906351db77b9.camel@tiscali.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 02:23:35PM +0100, Paul Bolle wrote:
>Greg Kroah-Hartman schreef op di 03-11-2020 om 21:32 [+0100]:
>> From: Rander Wang <rander.wang@intel.com>
>>
>> [ Upstream commit 6c63c954e1c52f1262f986f36d95f557c6f8fa94 ]
>>
>> When hda_codec_probe() doesn't initialize audio component, we disable
>> the codec and keep going. However,the resources are not released. The
>> child_count of SOF device is increased in snd_hdac_ext_bus_device_init
>> but is not decrease in error case, so SOF can't get suspended.
>>
>> snd_hdac_ext_bus_device_exit will be invoked in HDA framework if it
>> gets a error. Now copy this behavior to release resources and decrease
>> SOF device child_count to release SOF device.
>>
>> Signed-off-by: Rander Wang <rander.wang@intel.com>
>> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
>> Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
>> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>> Link: https://lore.kernel.org/r/20200825235040.1586478-3-ranjani.sridharan@linux.intel.com
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  sound/soc/sof/intel/hda-codec.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
>> index 2c5c451fa19d7..c475955c6eeba 100644
>> --- a/sound/soc/sof/intel/hda-codec.c
>> +++ b/sound/soc/sof/intel/hda-codec.c
>> @@ -151,7 +151,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>>  		if (!hdev->bus->audio_component) {
>>  			dev_dbg(sdev->dev,
>>  				"iDisp hw present but no driver\n");
>> -			return -ENOENT;
>> +			goto error;
>>  		}
>>  		hda_priv->need_display_power = true;
>>  	}
>> @@ -174,7 +174,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
>>  		 * other return codes without modification
>>  		 */
>>  		if (ret == 0)
>> -			ret = -ENOENT;
>> +			goto error;
>>  	}
>>
>>  	return ret;
>
>My local build of v5.9.5 broke on this patch.
>
>sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe':
>sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error' used but not defined
>  177 |    goto error;
>      |    ^~~~
>make[4]: *** [scripts/Makefile.build:283: sound/soc/sof/intel/hda-codec.o] Error 1
>make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2
>make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
>make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2
>make: *** [Makefile:1778: sound] Error 2
>
>There's indeed no error label in v5.9.5. (There is one in v5.10-rc2, I just
>checked.) Is no-one else running into this?

It seems that setting CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y is very
"difficult", it's not being set by allmodconfig nor is it easy to
manually set it up.

I'll revert the patch, but it would be nice to make sure it's easier to
test this out too.

-- 
Thanks,
Sasha
