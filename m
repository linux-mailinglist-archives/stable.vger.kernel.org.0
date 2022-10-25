Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD2060D1C6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiJYQpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJYQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 12:45:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210548B2C2;
        Tue, 25 Oct 2022 09:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666716340; x=1698252340;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7GFgHD8VpMSSYSQYldtRzowtwwtMBpNwmVTSdlESscM=;
  b=GaoShgxeBP0eH5EYguT398G5jCFdjBGKIIUiyWQ7FJvQUTDk5WsY4Pg3
   Q2q2YpxDgdcRzbUXoOLLQfyuVThzf038pQQn8Jc6f4HEb4tgYRXG3WH4P
   ZyUeVyPVY5nI4hW3npUN0/jvlvk4DCisvTHrAwEFXqQZuMG691ehZHIBi
   v3p9cymjsnuT59Vu4H7LgixKwiVg1Sf9Y/6NCJhvf0ORTRvqR6p9kxWuu
   kmaX1b2YQwUHwjs7AOvEgNDlHGhhLnpJ9oYZN7uEO1pW3KQqk9FDUeUO4
   rKP0kh9t0Yt2k1cSv64Q/7+FrZ6c3BMR/8KqWLceqd/4vvO6wesDhANpW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="305345463"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="305345463"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 09:45:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="664977540"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="664977540"
Received: from pperezji-mobl.amr.corp.intel.com (HELO [10.212.98.192]) ([10.212.98.192])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 09:45:38 -0700
Message-ID: <0aafc75f-942a-531d-5e78-a8fb211f43bc@linux.intel.com>
Date:   Tue, 25 Oct 2022 11:45:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH AUTOSEL 6.0 07/44] ALSA: hda: Fix page fault in
 snd_hda_codec_shutdown()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tiwai@suse.com,
        alsa-devel@alsa-project.org, peter.ujfalusi@linux.intel.com,
        mkumard@nvidia.com
References: <20221009234932.1230196-1-sashal@kernel.org>
 <20221009234932.1230196-7-sashal@kernel.org>
 <24d084e1-700d-da77-d93e-2d330aac2f63@linux.intel.com>
 <Y1f3opiid6pvKINq@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Y1f3opiid6pvKINq@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/25/22 09:50, Greg KH wrote:
> On Tue, Oct 25, 2022 at 09:27:32AM -0500, Pierre-Louis Bossart wrote:
>>
>>
>> On 10/9/22 18:48, Sasha Levin wrote:
>>> From: Cezary Rojewski <cezary.rojewski@intel.com>
>>>
>>> [ Upstream commit f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 ]
>>
>> This commit on linux-stable seems to have broken a number of platforms.
>>
>> 6.0.2 worked fine.
>> 6.0.3 does not
>>
>> reverting this commit solves the problem, see
>> https://github.com/thesofproject/linux/issues/3960 for details.
>>
>> Are we missing a prerequisite patch for this commit?
> 
> Please see https://lore.kernel.org/r/20221024143931.15722-1-tiwai@suse.de
> 
> Does that solve it for you?

Yep, that's the revert I tested.
