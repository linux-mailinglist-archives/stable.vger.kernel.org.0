Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC5C643378
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiLETgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbiLETgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:18 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68E7C74D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670268787; x=1701804787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2JmSaB3npkDinTcz+srPn+65nQfK/acy008ksNaYfPQ=;
  b=OG0Z6JPG7oQrbUJHFn9H4lblhhg4NwBHDX4jqDKxgQcKSyQyU1Y1fSkA
   fobon4uJk5pFGti7JX5f4C5irVhlNebH2V+bOaDCgsAJZOSPsQXYAU6Vk
   ACXdD7hsrjXuOk6MlRZouAA4toEzkymIPF1iv1N/bE8EWX4k4ZK6aF+Wu
   V+IjuUGggGzxV94Q+rxO9Wll7u83oiuQbheVb956gJ3Lj3U/VNP/fbdj8
   IYv5nS7H/EWEAzUoGaBL5bLnMASjxUd359T4OHjVR+GxZXIQLDnJ8T+3l
   6w4AZm0j+RXKCuew/BEdJ0F+nFgDqhQl+WV5d75f+gwM9ytSZ6hHKty1o
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="315149030"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="315149030"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 11:33:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="974807255"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="974807255"
Received: from ysuvarna-mobl1.amr.corp.intel.com (HELO [10.212.123.127]) ([10.212.123.127])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 11:33:06 -0800
Message-ID: <2f12eb6e-6866-1945-b24b-edceb423e6b3@linux.intel.com>
Date:   Mon, 5 Dec 2022 13:33:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, vkoul@kernel.org,
        Sjoerd Simons <sjoerd@collabora.com>,
        Chao Song <chao.song@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
References: <20221205170600.15002-1-pierre-louis.bossart@linux.intel.com>
 <Y445YurEQGO0tQqJ@kroah.com>
Content-Language: en-US
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Y445YurEQGO0tQqJ@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/22 12:33, Greg KH wrote:
> On Mon, Dec 05, 2022 at 11:06:00AM -0600, Pierre-Louis Bossart wrote:
>> From: Sjoerd Simons <sjoerd@collabora.com>
>>
>> commit 13c30a755847c7e804e1bf755e66e3ff7b7f9367 upstream
>>
>> The bus->clk_stop_timeout member is only initialized to a non-zero value
>> during the codec driver probe. This can lead to corner cases where this
>> value remains pegged at zero when the bus suspends, which results in an
>> endless loop in sdw_bus_wait_for_clk_prep_deprep().
>>
>> Corner cases include configurations with no codecs described in the
>> firmware, or delays in probing codec drivers.
>>
>> Initializing the default timeout to the smallest non-zero value avoid this
>> problem and allows for the existing logic to be preserved: the
>> bus->clk_stop_timeout is set as the maximum required by all codecs
>> connected on the bus.
>>
>> Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")
> 
> This commit is is only in 6.1-rc1, so why does it need to go to any
> older kernels?  Is this tag not correct?

I don't recall why this tag was selected, it's clearly not related
functionality-wise. I vaguely recall a discussion with Bard Liao on
this... And yes sure enough here it is [1], it was to indicate a
conflict but that was confusing in hindsight.

At any rate, this one-line change is really needed, some distributions
such as Arch back-ported this change but most did not, and users don't
have a working setup.

[1] https://github.com/thesofproject/linux/pull/3911#issuecomment-1284750003
