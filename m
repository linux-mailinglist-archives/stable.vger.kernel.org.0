Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0862C5C00CE
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIUPLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIUPLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:11:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F11B86892;
        Wed, 21 Sep 2022 08:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663773093; x=1695309093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A7sz6EXwqIAWb/Tb19LXWHCaCFvIWu79u7rPwHDHwVw=;
  b=KYntNlSfARDsGOaQqayGdW5BSgAKLZQlMnamFrtT/GbZVukPL2N43x70
   R/+D9fmO7KGdj4KriaJFb3ZN88fTrL59QkIKRKBrQtqmy9ee+XY497Lk7
   /GBDPyibWTUF2kFvkGnh0ji3OJyBQyVDicSUyTPnHFsRZIQ956cYOXtlp
   SY51I+sG+5npThIPdVmFU4x5/LBL/ZhycPbcXuirHCYoqKWjrgvE2dk7m
   v5N2SoKlYdIPXKsXAWE0SekZlBgqo8LZWCwv3CD63Behm+6vil4Nhy8iN
   8AkrsQCfMuvF47CP0rH9JUSa88h5SkqULR9EDSrxVxVHiSaN09DVY3DqB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="364005697"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="364005697"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:11:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="864464249"
Received: from johannes-mobl1.ger.corp.intel.com (HELO [10.249.46.195]) ([10.249.46.195])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:11:27 -0700
Message-ID: <fd74e77c-f3d3-1f09-2e5a-0a94e2a3eeea@linux.intel.com>
Date:   Wed, 21 Sep 2022 17:11:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
 <20916c9d-3598-7c40-ee77-1148c3d2e4b1@linux.intel.com>
 <af3bd3f4-dcd9-8f6c-6323-de1b53301225@linaro.org>
 <9a210b04-2ff2-df98-ad1a-89e9d8b0f686@linaro.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <9a210b04-2ff2-df98-ad1a-89e9d8b0f686@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/21/22 17:08, Krzysztof Kozlowski wrote:
> On 21/09/2022 17:06, Krzysztof Kozlowski wrote:
>> On 21/09/2022 17:05, Pierre-Louis Bossart wrote:
>>>> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
>>>> index 06c6adbe5920..d2548fdf9ae5 100644
>>>> --- a/sound/soc/codecs/wcd9335.c
>>>> +++ b/sound/soc/codecs/wcd9335.c
>>>> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
>>>>  	case SNDRV_PCM_TRIGGER_STOP:
>>>>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>>>>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>>>> -		slim_stream_unprepare(dai_data->sruntime);
>>>>  		slim_stream_disable(dai_data->sruntime);
>>>> +		slim_stream_unprepare(dai_data->sruntime);
>>>
>>> This looks logical but different from what the kernel doc says:
>>>
>>> /**
>>>  * slim_stream_disable() - Disable a SLIMbus Stream
>>>  *
>>>  * @stream: instance of slim stream runtime to disable
>>>  *
>>>  * This API will disable all the ports and channels associated with
>>>  * SLIMbus stream
>>>  *
>>>  * Return: zero on success and error code on failure. From ASoC DPCM
>>> framework,
>>>  * this state is linked to trigger() pause operation.
>>>  */
>>>
>>> /**
>>>  * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
>>>  *
>>>  * @stream: instance of slim stream runtime to unprepare
>>>  *
>>>  * This API will un allocate all the ports and channels associated with
>>>  * SLIMbus stream
>>
>> You mean this piece of doc? Indeed looks inaccurate. I'll update it.
> 
> Wait, no, this is correct. Please point to what is wrong in kernel doc.
> I don't see it. :(

the TRIGGER_STOP and TRIGGER_PAUSE_PUSH do the same thing. There is no
specific mapping of disable() to TRIGGER_STOP and unprepare() to
TRIGGER_PAUSE_PUSH as the documentation hints at.
