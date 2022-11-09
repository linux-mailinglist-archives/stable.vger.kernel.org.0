Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A35622F9D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiKIQFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 11:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiKIQFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 11:05:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC421268;
        Wed,  9 Nov 2022 08:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668009947; x=1699545947;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DUDgxCo8gHkX29vLar7UjmY10ZyQHpxE5MRL+xpehOw=;
  b=TVUao97su6HaOMrMMCXMMOAfzAmdFKt0RWaMM11QltuT1j+GF4d5v0ha
   WYGEfUieZII02nCryby7XnVzLza1WzyPR3rt1EKXjjy6le5d+PhVG/4Xm
   mRyHQA0l0NKx3ZDiUVaf0zE/tXkDkwu7FcKnqGmQgLTvJwmhvTSnoJOeO
   T2Ak6Y4Rj/dGAgU/DHvoggLC50JH/DyFCURdlEKHW1Xb+FN12n/BY2+e7
   ZU2In2Zq8O/4RlARnQBBgtEHQeMEnaQW6o+bT9A563y0VMup0odxv0Rd7
   61znW/wYChynQk+Xs9l6JxKB2NxBWvJZOBEqXw+LB0j5uw/gjk5v+r6kZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312817957"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="312817957"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 08:05:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="669999464"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="669999464"
Received: from ktan43-mobl2.amr.corp.intel.com (HELO [10.213.170.218]) ([10.213.170.218])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 08:05:45 -0800
Message-ID: <e5acf9e3-20b9-00b3-8d5f-687d47ccd49c@linux.intel.com>
Date:   Wed, 9 Nov 2022 10:05:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Content-Language: en-US
To:     Vinod Koul <vkoul@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
Cc:     stable@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, bard.liao@intel.com
References: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
 <Y1u855YZ/B3Q+FiI@matsya>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Y1u855YZ/B3Q+FiI@matsya>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/28/22 06:28, Vinod Koul wrote:
> On 20-10-22, 09:56, Bard Liao wrote:
>> From: Sjoerd Simons <sjoerd@collabora.com>
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
> 
> Applied to fixes, thanks

Thanks Vinod, was this sent to Greg/Linus? the last pull request I see
was for 6.1-rc1.
Arch Linux cherry-picked this patch but other distros did not, so quite
a few users are left with no audio card.
