Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0575F432
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 10:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGDIA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 04:00:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:29111 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfGDIA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 04:00:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 01:00:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="184948937"
Received: from coxu-arch-shz.sh.intel.com (HELO [10.239.160.21]) ([10.239.160.21])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jul 2019 01:00:54 -0700
Reply-To: Colin.Xu@intel.com
Subject: Re: [PATCH v2] drm/i915/gvt: Adding ppgtt to GVT GEM context after
 pin.
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
References: <20190704070613.31609-1-colin.xu@intel.com>
 <20190704074351.GV9684@zhen-hp.sh.intel.com>
From:   Colin Xu <Colin.Xu@intel.com>
Message-ID: <4d2595be-6614-0f33-0cbf-a7341cf94906@intel.com>
Date:   Thu, 4 Jul 2019 16:00:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704074351.GV9684@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019-07-04 15:43, Zhenyu Wang wrote:
> On 2019.07.04 15:06:13 +0800, Colin Xu wrote:
>> Windows guest can't run after force-TDR with host log:
>> ...
>> gvt: vgpu 1: workload shadow ppgtt isn't ready
>> gvt: vgpu 1: fail to dispatch workload, skip
>> ...
>>
>> The error is raised by set_context_ppgtt_from_shadow(), when it checks
>> and found the shadow_mm isn't marked as shadowed.
>>
>> In work thread before each submission, a shadow_mm is set to shadowed in:
>> shadow_ppgtt_mm()
>> <-intel_vgpu_pin_mm()
>> <-prepare_workload()
>> <-dispatch_workload()
>> <-workload_thread()
>> However checking whether or not shadow_mm is shadowed is prior to it:
>> set_context_ppgtt_from_shadow()
>> <-dispatch_workload()
>> <-workload_thread()
>>
>> In normal case, create workload will check the existence of shadow_mm,
>> if not it will create a new one and marked as shadowed. If already exist
>> it will reuse the old one. Since shadow_mm is reused, checking of shadowed
>> in set_context_ppgtt_from_shadow() actually always see the state set in
>> creation, but not the state set in intel_vgpu_pin_mm().
>>
>> When force-TDR, all engines are reset, since it's not dmlr level, all
>> ppgtt_mm are invalidated but not destroyed. Invalidation will mark all
>> reused shadow_mm as not shadowed but still keeps in ppgtt_mm_list_head.
>> If workload submission phase those shadow_mm are reused with shadowed
>> not set, then set_context_ppgtt_from_shadow() will report error.
>>
>> Fixes: 4f15665ccbba (drm/i915: Add ppgtt to GVT GEM context)
>>
>> v2:
>> Move set_context_ppgtt_from_shadow() after prepare_workload(). (zhenyu)
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Colin Xu <colin.xu@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/scheduler.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
>> index 196b4155a309..100040209188 100644
>> --- a/drivers/gpu/drm/i915/gvt/scheduler.c
>> +++ b/drivers/gpu/drm/i915/gvt/scheduler.c
>> @@ -685,13 +685,6 @@ static int dispatch_workload(struct intel_vgpu_workload *workload)
>>   	mutex_lock(&vgpu->vgpu_lock);
>>   	mutex_lock(&dev_priv->drm.struct_mutex);
>>   
>> -	ret = set_context_ppgtt_from_shadow(workload,
>> -					    s->shadow[ring_id]->gem_context);
>> -	if (ret < 0) {
>> -		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
>> -		goto err_req;
>> -	}
>> -
>>   	ret = intel_gvt_workload_req_alloc(workload);
>>   	if (ret)
>>   		goto err_req;
>> @@ -707,6 +700,13 @@ static int dispatch_workload(struct intel_vgpu_workload *workload)
>>   	}
>>   
>>   	ret = prepare_workload(workload);
>> +	if (ret)
>> +		goto out;
>> +
>> +	ret = set_context_ppgtt_from_shadow(workload,
>> +					    s->shadow[ring_id]->gem_context);
>> +	if (ret)
>> +		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
> As workload's shadow_mm should always be for ppgtt, so we don't need return
> for set_context_ppgtt_from_shadow, can just be void. Then how about do that
> in prepare_workload after we settle down shadow pdp?
>
If so, is checking mm->type and shadowed flag stil necessary? since intel_vgpu_pin_mm()
in prepare_workload will guaranee that, if intel_vgpu_pin_mm() fails, shadow pdp won't
get updated and no need to pin. Am I right?

>>   out:
>>   	if (ret) {
>>   		/* We might still need to add request with
>> -- 
>> 2.22.0
>>
-- 
Best Regards,
Colin Xu

