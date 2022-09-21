Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90D85C0199
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiIUPaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiIUP3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:29:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC418274E;
        Wed, 21 Sep 2022 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774001; x=1695310001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lMTxh6KYx1sJCFJc5psK98Sjm17IdZ/t7HUfiUBreIE=;
  b=NBIspn2gKyEz/mWBBDhaa/EXLG2/SwJp9n+Rtg46yzoqJVoGxgicVCAm
   I9ngsjt+x+FlcB4m/ommEF7r/I77rCLtA0BEPvfAv6/voN5mxKBRWAAO5
   /dKJoyiBbzWHLqarYt98xyB55qvrkb9kFj+xReAm1Hl3+9Og3DDJnPO1t
   NCwYnDAxIrbLAGz5qLLFq8YYthoBmtXXWGLdA+EXs3H2DGZb7HrLzkXKh
   XVGoWhWw21wbuXUdC7ZCimFg4RmDPr7Pv4OES9XsvCvt9N2Mryrf68xNB
   zA22n5g/4O1oQwLVvV/t2RmOSbA2w9MBbD82zAwKxzukWDC4IlV2FHD84
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="361793726"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="361793726"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:25:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="864470733"
Received: from johannes-mobl1.ger.corp.intel.com (HELO [10.249.46.195]) ([10.249.46.195])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:25:19 -0700
Message-ID: <dd61f44e-8d4a-ac2e-0af4-56ced642c4bd@linux.intel.com>
Date:   Wed, 21 Sep 2022 17:25:16 +0200
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
 <fd74e77c-f3d3-1f09-2e5a-0a94e2a3eeea@linux.intel.com>
 <5e34eadc-ef6a-abeb-6bce-347593c275b7@linaro.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <5e34eadc-ef6a-abeb-6bce-347593c275b7@linaro.org>
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



On 9/21/22 17:19, Krzysztof Kozlowski wrote:
> On 21/09/2022 17:11, Pierre-Louis Bossart wrote:
>>>>> /**
>>>>>  * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
>>>>>  *
>>>>>  * @stream: instance of slim stream runtime to unprepare
>>>>>  *
>>>>>  * This API will un allocate all the ports and channels associated with
>>>>>  * SLIMbus stream
>>>>
>>>> You mean this piece of doc? Indeed looks inaccurate. I'll update it.
>>>
>>> Wait, no, this is correct. Please point to what is wrong in kernel doc.
>>> I don't see it. :(
>>
>> the TRIGGER_STOP and TRIGGER_PAUSE_PUSH do the same thing. There is no
>> specific mapping of disable() to TRIGGER_STOP and unprepare() to
>> TRIGGER_PAUSE_PUSH as the documentation hints at.
> 
> Which TRIGGER_STOP and TRIGGER_PAUSE_PUSH? In one specific codec driver?
> If yes, I don't think Slimbus documentation should care how actual users
> implement it (e.g. coalesce states).

In both of the patches you just modified :-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 06c6adbe5920..d2548fdf9ae5 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct
snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index f56907d0942d..28175c746b9a 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1913,8 +1913,8 @@ static int wcd934x_trigger(struct
snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;

the bus provides helpers to be used in well-defined transitions. A codec
driver doing whatever it wants whenever it wants would create chaos for
the bus.
