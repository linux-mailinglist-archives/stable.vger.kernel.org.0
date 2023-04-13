Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7918B6E0D9A
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDMMnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 08:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDMMnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 08:43:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEAC196
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 05:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681389829; x=1712925829;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=fgUpKjvdbHFbBQ40hN9rUSqyCbKAgeCNloPQgK0eCeI=;
  b=PW5QbatHv3Mq5pFTSxBxgks1wQAkbzo/lRLuxr6iW061iMBXBViY0Ygm
   UM7WqEq1GrVbYbSViVYSf3p7+PxDf/KqkdPmWzln0y8kabd9OCGXmjFSt
   BjSlGjkJO1aTzPA0Renxr4qIzid8ePrZUuSwXJmkDK4VS8YMyQdQScfS+
   GXqIaAT6G2mvUMO+gVN4SdOYBjB8zKR8zZU2yGhEoVbCneaqIQFSBmpA6
   TzrLt2tsgFSQOzKi1Ai1DPtCFzglvzx/4JGChbe82+NPTWoYOcEdyfJVm
   bJNj9TPNWyd6a/9ClSydh6cTXa/tNxUxZo7nuKYSo2NxiV/WkkfsE2DYm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="342917111"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="342917111"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 05:43:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863760031"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="863760031"
Received: from mmcgar2x-mobl1.ger.corp.intel.com (HELO [10.213.231.135]) ([10.213.231.135])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 05:43:47 -0700
Message-ID: <5b7f82db-b9dd-e9c9-496c-72995469d699@linux.intel.com>
Date:   Thu, 13 Apr 2023 13:43:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v5 5/5] drm/i915/gt: Make sure that errors are
 propagated through request chains
Content-Language: en-US
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>,
        Matthew Auld <matthew.auld@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
 <20230412113308.812468-6-andi.shyti@linux.intel.com>
 <ca796c78-67cf-c803-b3bc-7d6eaa542b32@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <ca796c78-67cf-c803-b3bc-7d6eaa542b32@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/04/2023 12:56, Tvrtko Ursulin wrote:
> 
> On 12/04/2023 12:33, Andi Shyti wrote:
>> Currently, when we perform operations such as clearing or copying
>> large blocks of memory, we generate multiple requests that are
>> executed in a chain.
>>
>> However, if one of these requests fails, we may not realize it
>> unless it happens to be the last request in the chain. This is
>> because errors are not properly propagated.
>>
>> For this we need to keep propagating the chain of fence
>> notification in order to always reach the final fence associated
>> to the final request.
>>
>> To address this issue, we need to ensure that the chain of fence
>> notifications is always propagated so that we can reach the final
>> fence associated with the last request. By doing so, we will be
>> able to detect any memory operation  failures and determine
>> whether the memory is still invalid.
> 
> Above two paragraphs seems to have redundancy in the message they convey.
> 
>> On copy and clear migration signal fences upon completion.
>>
>> On copy and clear migration, signal fences upon request
>> completion to ensure that we have a reliable perpetuation of the
>> operation outcome.
> 
> These two too. So I think commit message can be a bit polished.
> 
>> Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
>> Reported-by: Matthew Auld <matthew.auld@intel.com>
>> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
>> Acked-by: Nirmoy Das <nirmoy.das@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gt/intel_migrate.c | 51 +++++++++++++++++++------
>>   1 file changed, 39 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c 
>> b/drivers/gpu/drm/i915/gt/intel_migrate.c
>> index 3f638f1987968..668c95af8cbcf 100644
>> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
>> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
>> @@ -742,13 +742,19 @@ intel_context_migrate_copy(struct intel_context 
>> *ce,
>>               dst_offset = 2 * CHUNK_SZ;
>>       }
>> +    /*
>> +     * While building the chain of requests, we need to ensure
>> +     * that no one can sneak into the timeline unnoticed.
>> +     */
>> +    mutex_lock(&ce->timeline->mutex);
>> +
>>       do {
>>           int len;
>> -        rq = i915_request_create(ce);
>> +        rq = i915_request_create_locked(ce);
>>           if (IS_ERR(rq)) {
>>               err = PTR_ERR(rq);
>> -            goto out_ce;
>> +            break;
>>           }
>>           if (deps) {
>> @@ -878,10 +884,14 @@ intel_context_migrate_copy(struct intel_context 
>> *ce,
>>           /* Arbitration is re-enabled between requests. */
>>   out_rq:
>> -        if (*out)
>> +        i915_sw_fence_await(&rq->submit);
>> +        i915_request_get(rq);
>> +        i915_request_add_locked(rq);
>> +        if (*out) {
>> +            i915_sw_fence_complete(&(*out)->submit);
>>               i915_request_put(*out);
> 
> Could you help me understand this please. I have a few questions - 
> first, what are the actual mechanics of fence error transfer here? I see 
> the submit fence is being blocked until the next request is submitted - 
> effectively previous request is only allowed to get on the hardware 
> after the next one has been queued up. But I don't immediately see what 
> that does in practice.
> 
> Second question relates to the need to hold the timeline mutex 
> throughout. Presumably this is so two copy or migrate operations on the 
> same context do not interleave, which can otherwise happen?
> 
> Would the error propagation be doable without the lock held by chaining 
> on the previous request _completion_ fence? If so I am sure that would 
> have a performance impact, because chunk by chunk would need a GPU<->CPU 
> round trip to schedule. How much of an impact I don't know. Maybe 
> enlarging CHUNK_SZ to compensate is an option?
> 
> Or if the perf hit would be bearable for stable backports only (much 
> smaller patch) and then for tip we can do this full speed solution.
> 
> But yes, I would first want to understand the actual error propagation 
> mechanism because sadly my working knowledge is a bit rusty.

Another option - maybe - is this related to revert of fence error 
propagation? If it is and having that would avoid the need for this 
invasive fix, maybe we unrevert 3761baae908a7b5012be08d70fa553cc2eb82305 
with edits to limit to special contexts? If doable..

Regards,

Tvrtko

> 
>> -        *out = i915_request_get(rq);
>> -        i915_request_add(rq);
>> +        }
>> +        *out = rq;
>>           if (err)
>>               break;
>> @@ -905,7 +915,10 @@ intel_context_migrate_copy(struct intel_context *ce,
>>           cond_resched();
>>       } while (1);
>> -out_ce:
>> +    mutex_unlock(&ce->timeline->mutex);
>> +
>> +    if (*out)
>> +        i915_sw_fence_complete(&(*out)->submit);
>>       return err;
>>   }
>> @@ -999,13 +1012,19 @@ intel_context_migrate_clear(struct 
>> intel_context *ce,
>>       if (HAS_64K_PAGES(i915) && is_lmem)
>>           offset = CHUNK_SZ;
>> +    /*
>> +     * While building the chain of requests, we need to ensure
>> +     * that no one can sneak into the timeline unnoticed.
>> +     */
>> +    mutex_lock(&ce->timeline->mutex);
>> +
>>       do {
>>           int len;
>> -        rq = i915_request_create(ce);
>> +        rq = i915_request_create_locked(ce);
>>           if (IS_ERR(rq)) {
>>               err = PTR_ERR(rq);
>> -            goto out_ce;
>> +            break;
>>           }
>>           if (deps) {
>> @@ -1056,17 +1075,25 @@ intel_context_migrate_clear(struct 
>> intel_context *ce,
>>           /* Arbitration is re-enabled between requests. */
>>   out_rq:
>> -        if (*out)
>> +        i915_sw_fence_await(&rq->submit);
>> +        i915_request_get(rq);
>> +        i915_request_add_locked(rq);
>> +        if (*out) {
>> +            i915_sw_fence_complete(&(*out)->submit);
>>               i915_request_put(*out);
>> -        *out = i915_request_get(rq);
>> -        i915_request_add(rq);
>> +        }
>> +        *out = rq;
> 
> Btw if all else fails perhaps these two blocks can be consolidated by 
> something like __chain_requests(rq, out) and all these operations in it. 
> Not sure how much would that save in the grand total.
> 
> Regards,
> 
> Tvrtko
> 
>> +
>>           if (err || !it.sg || !sg_dma_len(it.sg))
>>               break;
>>           cond_resched();
>>       } while (1);
>> -out_ce:
>> +    mutex_unlock(&ce->timeline->mutex);
>> +
>> +    if (*out)
>> +        i915_sw_fence_complete(&(*out)->submit);
>>       return err;
>>   }
