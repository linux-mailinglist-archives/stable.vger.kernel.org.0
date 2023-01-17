Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC2D66D8EE
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 09:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbjAQI7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 03:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbjAQI66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 03:58:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4721814D
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 00:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673945863; x=1705481863;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UGwC0F+2sTx0QDqsfwQrpl04CHc9lq1xYlAMZD/BwKA=;
  b=mhepK5qgTz1p5RmcYx097mpgzU4z4czqMbLJx8vaQ5wxMYx61PzObTSv
   KnuRSMFUCy7JTEchXJ8t1IzX2gc21wm+HkE2PcLLO+41WJXuESwMcC4cP
   8kJPDBoWjMbgPhJJA4rBeqMjycv4cjBCSVcQ8aZmaBkuMb4Nvk6MWRE4k
   HeGd/npczmoO5Sv0I5dy5tsLSm9VYYe58qMYQHern29fehvOc+sYL3Tve
   brF374cv6qbwOGSoOBzX4uDKBMdqP0y/vZ5ZAYY2vaJMdVntJHLR6HspU
   /R8xSS6H11Jj3nsx5wm5JzBccBUiAJ2/nfCnLw6w9y8Vse1MYtb1CEd/Z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="410883135"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="410883135"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 00:57:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="609184032"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="609184032"
Received: from nirmoyda-mobl.ger.corp.intel.com (HELO [10.249.45.93]) ([10.249.45.93])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 00:57:40 -0800
Message-ID: <2d8c8af8-238a-a164-0224-88ac12acaf7d@linux.intel.com>
Date:   Tue, 17 Jan 2023 09:57:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] drm/i915/selftests: Unwind hugepages to drop wakeref on
 error
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, matthew.auld@intel.com,
        chris.p.wilson@linux.intel.com
References: <20230113120053.29618-1-nirmoy.das@intel.com>
 <Y8WcLtKY3/cSMjgw@ashyti-mobl2.lan>
From:   "Das, Nirmoy" <nirmoy.das@linux.intel.com>
In-Reply-To: <Y8WcLtKY3/cSMjgw@ashyti-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/16/2023 7:49 PM, Andi Shyti wrote:
> Hi Nirmoy,
>
> On Fri, Jan 13, 2023 at 01:00:53PM +0100, Nirmoy Das wrote:
>> From: Chris Wilson <chris.p.wilson@linux.intel.com>
>>
>> Make sure that upon error after we have acquired the wakeref we do
>> release it again.
>>
>> Fixes: 027c38b4121e ("drm/i915/selftests: Grab the runtime pm in shrink_thp")
>> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
>> Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
>> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
>> Cc: <stable@vger.kernel.org> # v6.0+
>> ---
>>   drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> index c281b0ec9e05..295d6f2cc4ff 100644
>> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> @@ -1855,7 +1855,7 @@ static int igt_shrink_thp(void *arg)
>>   			I915_SHRINK_ACTIVE);
>>   	i915_vma_unpin(vma);
>>   	if (err)
>> -		goto out_put;
>> +		goto out_wf;
>>   
>>   	/*
>>   	 * Now that the pages are *unpinned* shrinking should invoke
>> @@ -1871,7 +1871,7 @@ static int igt_shrink_thp(void *arg)
>>   		pr_err("unexpected pages mismatch, should_swap=%s\n",
>>   		       str_yes_no(should_swap));
>>   		err = -EINVAL;
>> -		goto out_put;
>> +		goto out_wf;
>>   	}
> aren't we missing here one out_put -> out_wf change?
>
> This one:
>
> @@ -1878,7 +1878,7 @@ static int igt_shrink_thp(void *arg)
>                  pr_err("unexpected residual page-size bits, should_swap=%s\n",
>                         str_yes_no(should_swap));
>                  err = -EINVAL;
> -               goto out_put;
> +               goto out_wf;


Thanks for catching this. Yes, we need this too. I will resend.


Nirmoy

>          }
>   
>          err = i915_vma_pin(vma, 0, 0, flags);
>
> Andi
>
>>   
>>   	if (should_swap == (obj->mm.page_sizes.sg || obj->mm.page_sizes.phys)) {
>> @@ -1883,7 +1883,7 @@ static int igt_shrink_thp(void *arg)
>>   
>>   	err = i915_vma_pin(vma, 0, 0, flags);
>>   	if (err)
>> -		goto out_put;
>> +		goto out_wf;
>>   
>>   	while (n--) {
>>   		err = cpu_check(obj, n, 0xdeadbeaf);
>> -- 
>> 2.39.0
