Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650C33DE1A0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 23:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHBV2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 17:28:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:45802 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231764AbhHBV2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 17:28:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="277304424"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="277304424"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 14:28:26 -0700
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="501970217"
Received: from skarumur-mobl.amr.corp.intel.com (HELO [10.212.72.192]) ([10.212.72.192])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 14:28:26 -0700
Subject: Re: [PATCH] ASoC: Intel: boards: fix xrun issue on platform with
 max98373
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>
References: <20210802180614.23940-1-pierre-louis.bossart@linux.intel.com>
 <YQhHO6EmugpHfJGe@sashalap>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <3abc9be2-d3e9-6e15-be73-782d6db4fe2f@linux.intel.com>
Date:   Mon, 2 Aug 2021 16:28:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQhHO6EmugpHfJGe@sashalap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/2/21 2:27 PM, Sasha Levin wrote:
> On Mon, Aug 02, 2021 at 01:06:14PM -0500, Pierre-Louis Bossart wrote:
>> From: Rander Wang <rander.wang@intel.com>
>>
>> commit 33c8516841ea4fa12fdb8961711bf95095c607ee upstream
>>
>> On TGL platform with max98373 codec the trigger start sequence is
>> fe first, then codec component and sdw link is the last. Recently
>> a delay was introduced in max98373 codec driver and this resulted
>> to the start of sdw stream transmission was delayed and the data
>> transmitted by fw can't be consumed by sdw controller, so xrun happened.
>>
>> Adding delay in trigger function is a bad idea. This patch enable spk
>> pin in prepare function and disable it in hw_free to avoid xrun issue
>> caused by delay in trigger.
>>
>> Fixes: 3a27875e91fb ("ASoC: max98373: Added 30ms turn on/off time delay")
>> BugLink: https://github.com/thesofproject/sof/issues/4066
>> Reviewed-by: Bard Liao <bard.liao@intel.com>
>> Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
>> Signed-off-by: Rander Wang <rander.wang@intel.com>
>> Signed-off-by: Pierre-Louis Bossart
>> <pierre-louis.bossart@linux.intel.com>
>> Link:
>> https://lore.kernel.org/r/20210625205042.65181-2-pierre-louis.bossart@linux.intel.com
>>
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> ---
>>
>> backport to stable/linux-5.13.y and stable/linux-5.12.y since upstream
>> commit does not apply directly due to a rename in 9c5046e4b3e7 which
>> creates a conflict.
> 
> Any objections to bringing in:
> 
> 9c5046e4b3e7 ("ASoC: Intel: boards: create sof-maxim-common module")
> f6081af6cf2b ("ASoC: Intel: boards: handle hda-dsp-common as a module")
> 
> to 5.13 instead? This way we'll be better aligned with upstream and
> avoid this type of failures in the future.

Thanks for the suggestion Sasha, it'd certainly be easier for us and
distros/end-users if such renames/repartition patches could land in -stable.

We have e.g. another recent case we de-duplicated a set of
jack-detection enums in "ASoC: Intel: sof_sdw: include rt711.h for RT711
JD mode" and as a result the addition of newer quirks for Dell or NUC
devices won't apply cleanly on the stable branch.
