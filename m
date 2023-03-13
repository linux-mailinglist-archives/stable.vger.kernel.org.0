Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16486B7424
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjCMKd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCMKd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:33:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBA62597F
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678703630; x=1710239630;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r1vE8faMn7hVzT2kG1EvEKxxtHhcmzA3q6YkMYequm4=;
  b=T9RNtkQ8grK85izyR+KN3WH8i+vzqwCfDYrxCyGpm3ki6POEUbyEmIIl
   0ymQcQfSzW0NO21jGTJvlWJMCCejAzXjMLcOQ6LOJ7Up5XaZ5dni9BspZ
   hlntbk7OOGFTMQbonxeRu/gmwgwt7MogoG/UvFFdv8fIQ7YQnj9YZIv+D
   NaXNetDtraw09GIX0+8sHurexpH/i1xvHps9x6+1mA+I0RJsIb25wwlPm
   vEuwyvTevbyVRSD2pQ0EdxSu5EuNWnLcg7wDiTeFVZQHRxKYVJufwHvSt
   l7ZZ2tz/PYi7DqDQXfqdmPsfT5K47juEuzGqrfYQQXhqqke/kImkMws4e
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="364774587"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="364774587"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="788880249"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="788880249"
Received: from nirmoyda-mobl.ger.corp.intel.com (HELO [10.252.33.220]) ([10.252.33.220])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 03:33:48 -0700
Message-ID: <42e5365a-c454-34cc-bc8b-3b56e5e181fb@linux.intel.com>
Date:   Mon, 13 Mar 2023 11:33:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915/active: Fix missing debug object
 activation
Content-Language: en-US
To:     Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Nirmoy Das <nirmoy.das@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas.hellstrom@intel.com>,
        stable@vger.kernel.org, Chris Wilson <chris.p.wilson@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
References: <20230310141138.6592-1-nirmoy.das@intel.com>
 <2135859.irdbgypaU6@jkrzyszt-mobl1.ger.corp.intel.com>
 <242c2634-1c38-351d-7198-cba3ec1ad4f2@linux.intel.com>
 <10239109.nUPlyArG6x@jkrzyszt-mobl1.ger.corp.intel.com>
From:   "Das, Nirmoy" <nirmoy.das@linux.intel.com>
In-Reply-To: <10239109.nUPlyArG6x@jkrzyszt-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/13/2023 10:55 AM, Janusz Krzysztofik wrote:
> On Friday, 10 March 2023 17:48:10 CET Das, Nirmoy wrote:
>> Hi Janusz,
>>
>> On 3/10/2023 4:19 PM, Janusz Krzysztofik wrote:
>>> Hi Nirmoy,
>>>
>>> On Friday, 10 March 2023 15:11:38 CET Nirmoy Das wrote:
>>>> debug_active_activate() expected ref->count to be zero
>>>> which is not true anymore as __i915_active_activate() calls
>>>> debug_active_activate() after incrementing the count.
>>>>
>>>> Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref-
>> active
>>> callback")
>>>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>>> Cc: Thomas Hellström <thomas.hellstrom@intel.com>
>>>> Cc: Andi Shyti <andi.shyti@linux.intel.com>
>>>> Cc: intel-gfx@lists.freedesktop.org
>>>> Cc: <stable@vger.kernel.org> # v5.10+
>>>> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
>>>> ---
>>>>    drivers/gpu/drm/i915/i915_active.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/
>>> i915_active.c
>>>> index a9fea115f2d2..1c3066eb359a 100644
>>>> --- a/drivers/gpu/drm/i915/i915_active.c
>>>> +++ b/drivers/gpu/drm/i915/i915_active.c
>>>> @@ -92,7 +92,7 @@ static void debug_active_init(struct i915_active *ref)
>>>>    static void debug_active_activate(struct i915_active *ref)
>>>>    {
>>>>    	lockdep_assert_held(&ref->tree_lock);
>>>> -	if (!atomic_read(&ref->count)) /* before the first inc */
>>>> +	if (atomic_read(&ref->count) == 1) /* after the first inc */
>>> While that's obviously better than never calling debug_active_activate(),
> I'm
>>> wondering how likely we can still miss it because the counter being
>>> incremented, e.g. via i915_active_acquire_if_busy(), by a concurrent
> thread.
>>> Since __i915_active_activate() is the only user and its decision making
> step
>>> is serialized against itself with a spinlock, couldn't we better call
>>> debug_object_activate() unconditionally here?
>>
>> Yes, we can call debug_object_activate() without checking ref->count.
>> Also we can remove the ref-count check for
>>
>> debug_active_deactivate() as this is wrapped with
>> "atomic_dec_and_lock_irqsave(&ref->count, &ref->tree_lock, flags)".
>>
>>
>> I think it makes sense to keep this patch as it is so it can be
>> backported easily. I can add another patch to remove
>>
>> unnecessary ref->count  checks.
> Looking at 5.10, I can't understand how dropping the check instead of
> replacing it with a still problematic one could make backporting less easy.


Indeed, I thought 5.10 is pretty far in the past but I was wrong. I can 
apply the modified patch.

Sent out a v2

Thanks,

Nirmoy

>
> Thanks,
> Janusz
>
>
>>
>> Regards,
>>
>> Nirmoy
>>
>>
>>> Thanks,
>>> Janusz
>>>
>>>>    		debug_object_activate(ref, &active_debug_desc);
>>>>    }
>>>>    
>>>>
>>>
>>>
>
>
>
