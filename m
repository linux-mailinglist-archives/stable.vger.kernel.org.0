Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768836B4DA3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 17:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjCJQv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 11:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCJQvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 11:51:39 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1F0763C2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 08:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678466898; x=1710002898;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y1BIGZuvsiTUQZyUIGha39u4IVeDwFUA9ZldRq/rR0k=;
  b=AutAgHzzupcxedP14toXqI4oMQl0v3oKMFA/vSnK9rXDvwpQehTqx0vY
   dEdDNxm/Xr2Qw6JFYzTf3E51C0ZXskMnHBplWyS4rPEhwoRtsaBfXJd0B
   HrJD21We5iZgpFmZ8gBPraXTxt2EM/XE0YSR029WVFjMykHXk96sMeunL
   FYjhb1vJnb1iEPfn06+3iwA5ZhVDq106Q6LyfNe1cq4LB27OUVlzaaz1l
   ZN9ZKO7xX0jKbBfLxlOk0QohJJhgT1lX6rdms/UXevMFYNHNvZC4ZCgJn
   Fp5/5GAOVdO33FDphZzTPKO6zwDu2vzvqDqr7kCR9n8YcAUGrmKsilAhZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="399371644"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="399371644"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 08:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="671145703"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="671145703"
Received: from nirmoyda-mobl.ger.corp.intel.com (HELO [10.252.59.175]) ([10.252.59.175])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 08:48:12 -0800
Message-ID: <242c2634-1c38-351d-7198-cba3ec1ad4f2@linux.intel.com>
Date:   Fri, 10 Mar 2023 17:48:10 +0100
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
From:   "Das, Nirmoy" <nirmoy.das@linux.intel.com>
In-Reply-To: <2135859.irdbgypaU6@jkrzyszt-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Janusz,

On 3/10/2023 4:19 PM, Janusz Krzysztofik wrote:
> Hi Nirmoy,
>
> On Friday, 10 March 2023 15:11:38 CET Nirmoy Das wrote:
>> debug_active_activate() expected ref->count to be zero
>> which is not true anymore as __i915_active_activate() calls
>> debug_active_activate() after incrementing the count.
>>
>> Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->active
> callback")
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>> Cc: Thomas Hellström <thomas.hellstrom@intel.com>
>> Cc: Andi Shyti <andi.shyti@linux.intel.com>
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v5.10+
>> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
>> ---
>>   drivers/gpu/drm/i915/i915_active.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/
> i915_active.c
>> index a9fea115f2d2..1c3066eb359a 100644
>> --- a/drivers/gpu/drm/i915/i915_active.c
>> +++ b/drivers/gpu/drm/i915/i915_active.c
>> @@ -92,7 +92,7 @@ static void debug_active_init(struct i915_active *ref)
>>   static void debug_active_activate(struct i915_active *ref)
>>   {
>>   	lockdep_assert_held(&ref->tree_lock);
>> -	if (!atomic_read(&ref->count)) /* before the first inc */
>> +	if (atomic_read(&ref->count) == 1) /* after the first inc */
> While that's obviously better than never calling debug_active_activate(), I'm
> wondering how likely we can still miss it because the counter being
> incremented, e.g. via i915_active_acquire_if_busy(), by a concurrent thread.
> Since __i915_active_activate() is the only user and its decision making step
> is serialized against itself with a spinlock, couldn't we better call
> debug_object_activate() unconditionally here?


Yes, we can call debug_object_activate() without checking ref->count. 
Also we can remove the ref-count check for

debug_active_deactivate() as this is wrapped with 
"atomic_dec_and_lock_irqsave(&ref->count, &ref->tree_lock, flags)".


I think it makes sense to keep this patch as it is so it can be 
backported easily. I can add another patch to remove

unnecessary ref->count  checks.


Regards,

Nirmoy


>
> Thanks,
> Janusz
>
>>   		debug_object_activate(ref, &active_debug_desc);
>>   }
>>   
>>
>
>
>
