Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8322E2A834D
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgKEQSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:18:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:28624 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbgKEQSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:18:01 -0500
IronPort-SDR: HZJaVa0WPgdpLEtAsRSmENygeYfuKRcwHcZNib7Xg8LS5qruIVWuIjAKg3eLfZY7iAZ1sGxFH/
 el5dc+u/0cug==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="149263094"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="149263094"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 08:17:59 -0800
IronPort-SDR: yxVP6A03J0rDAwY3WimJcT+LNkyeHm3psP8GU8uJmIIEa5rJx22tVlprrSvwqsSFT4xu9EwGb5
 ky6pImHJjbMA==
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="539464944"
Received: from umedepal-mobl2.amr.corp.intel.com (HELO [10.254.6.114]) ([10.254.6.114])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 08:17:58 -0800
Subject: Re: [PATCH 5.9 080/391] ASoC: SOF: fix a runtime pm issue in SOF when
 HDMI codec doesnt work
To:     Sasha Levin <sashal@kernel.org>
Cc:     Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
 <1f0c6a62-5208-801d-d7c2-725ee8da19b2@linux.intel.com>
 <20201105154426.GI2092@sasha-vm>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <e13d8fb6-4f69-23ad-22f6-499bffbf03d6@linux.intel.com>
Date:   Thu, 5 Nov 2020 10:17:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105154426.GI2092@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>> My local build of v5.9.5 broke on this patch.
>>>>
>>>> sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe':
>>>> sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error' used but 
>>>> not defined
>>>>  177 |    goto error;
>>>>      |    ^~~~
>>>> make[4]: *** [scripts/Makefile.build:283: 
>>>> sound/soc/sof/intel/hda-codec.o] Error 1
>>>> make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2
>>>> make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
>>>> make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2
>>>> make: *** [Makefile:1778: sound] Error 2
>>>>
>>>> There's indeed no error label in v5.9.5. (There is one in v5.10-rc2, 
>>>> I just
>>>> checked.) Is no-one else running into this?
>>>
>>> It seems that setting CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y is very
>>> "difficult", it's not being set by allmodconfig nor is it easy to
>>> manually set it up.
>>>
>>> I'll revert the patch, but it would be nice to make sure it's easier to
>>> test this out too.
>>
>> this issue comes from out-of-order patches, give me a couple of hours 
>> to look into this before reverting. thanks!
> 
> Sure! Thanks for looking into this.

I would recommend adding this commit to 5.9-stable:

11ec0edc6408a ('ASOC: SOF: Intel: hda-codec: move unused label to 
correct position')

I just tried with 5.9.5 and the compilation error is solved with this 
commit.

It was initially intended to solve a minor 'defined but not used' issue, 
which somehow became a bad 'used but not defined' one. Probably a bad 
git merge I did, sorry about that.

Thanks!
-Pierre



