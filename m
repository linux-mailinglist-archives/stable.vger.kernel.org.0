Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783652A8147
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 15:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgKEOsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 09:48:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:25351 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731299AbgKEOsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 09:48:16 -0500
IronPort-SDR: TxdvGvM8kUZYge+JI0SfC5JNSWBxVuRq5cO4Fox5NRq41yyZQ3IqcbhdKdv8Kn+McajMaR8c3o
 EocQ50oXfGFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="233559149"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="233559149"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 06:47:59 -0800
IronPort-SDR: MbNgxm5bJTlWd7YnlMT8d5fT0TN5vZIAFol8pCMpL4KNc81QXGlMq6CW8fgT3MYBgUGFYtgIye
 AuluQnbN9IJg==
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="471675105"
Received: from gabrielv-mobl1.amr.corp.intel.com (HELO [10.209.96.164]) ([10.209.96.164])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 06:47:58 -0800
Subject: Re: [PATCH 5.9 080/391] ASoC: SOF: fix a runtime pm issue in SOF when
 HDMI codec doesnt work
To:     Sasha Levin <sashal@kernel.org>, Paul Bolle <pebolle@tiscali.nl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201103203352.505472614@linuxfoundation.org>
 <64a618a3cc00de4a1c3887b57447906351db77b9.camel@tiscali.nl>
 <20201105143551.GH2092@sasha-vm>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <1f0c6a62-5208-801d-d7c2-725ee8da19b2@linux.intel.com>
Date:   Thu, 5 Nov 2020 08:47:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105143551.GH2092@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/5/20 8:35 AM, Sasha Levin wrote:
> On Thu, Nov 05, 2020 at 02:23:35PM +0100, Paul Bolle wrote:
>> Greg Kroah-Hartman schreef op di 03-11-2020 om 21:32 [+0100]:
>>> From: Rander Wang <rander.wang@intel.com>
>>>
>>> [ Upstream commit 6c63c954e1c52f1262f986f36d95f557c6f8fa94 ]
>>>
>>> When hda_codec_probe() doesn't initialize audio component, we disable
>>> the codec and keep going. However,the resources are not released. The
>>> child_count of SOF device is increased in snd_hdac_ext_bus_device_init
>>> but is not decrease in error case, so SOF can't get suspended.
>>>
>>> snd_hdac_ext_bus_device_exit will be invoked in HDA framework if it
>>> gets a error. Now copy this behavior to release resources and decrease
>>> SOF device child_count to release SOF device.
>>>
>>> Signed-off-by: Rander Wang <rander.wang@intel.com>
>>> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
>>> Reviewed-by: Guennadi Liakhovetski 
>>> <guennadi.liakhovetski@linux.intel.com>
>>> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>>> Link: 
>>> https://lore.kernel.org/r/20200825235040.1586478-3-ranjani.sridharan@linux.intel.com 
>>>
>>> Signed-off-by: Mark Brown <broonie@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  sound/soc/sof/intel/hda-codec.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/sound/soc/sof/intel/hda-codec.c 
>>> b/sound/soc/sof/intel/hda-codec.c
>>> index 2c5c451fa19d7..c475955c6eeba 100644
>>> --- a/sound/soc/sof/intel/hda-codec.c
>>> +++ b/sound/soc/sof/intel/hda-codec.c
>>> @@ -151,7 +151,7 @@ static int hda_codec_probe(struct snd_sof_dev 
>>> *sdev, int address,
>>>          if (!hdev->bus->audio_component) {
>>>              dev_dbg(sdev->dev,
>>>                  "iDisp hw present but no driver\n");
>>> -            return -ENOENT;
>>> +            goto error;
>>>          }
>>>          hda_priv->need_display_power = true;
>>>      }
>>> @@ -174,7 +174,7 @@ static int hda_codec_probe(struct snd_sof_dev 
>>> *sdev, int address,
>>>           * other return codes without modification
>>>           */
>>>          if (ret == 0)
>>> -            ret = -ENOENT;
>>> +            goto error;
>>>      }
>>>
>>>      return ret;
>>
>> My local build of v5.9.5 broke on this patch.
>>
>> sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe':
>> sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error' used but 
>> not defined
>>  177 |    goto error;
>>      |    ^~~~
>> make[4]: *** [scripts/Makefile.build:283: 
>> sound/soc/sof/intel/hda-codec.o] Error 1
>> make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2
>> make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
>> make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2
>> make: *** [Makefile:1778: sound] Error 2
>>
>> There's indeed no error label in v5.9.5. (There is one in v5.10-rc2, I 
>> just
>> checked.) Is no-one else running into this?
> 
> It seems that setting CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y is very
> "difficult", it's not being set by allmodconfig nor is it easy to
> manually set it up.
> 
> I'll revert the patch, but it would be nice to make sure it's easier to
> test this out too.

this issue comes from out-of-order patches, give me a couple of hours to 
look into this before reverting. thanks!
