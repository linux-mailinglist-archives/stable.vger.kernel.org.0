Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF3E46BA16
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhLGLcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:32:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:64423 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230496AbhLGLcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:32:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300940684"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="300940684"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 03:28:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="611640335"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 07 Dec 2021 03:28:42 -0800
Received: from [10.252.34.167] (rgraefe-MOBL.ger.corp.intel.com [10.252.34.167])
        by linux.intel.com (Postfix) with ESMTP id 23F9A580522;
        Tue,  7 Dec 2021 03:28:40 -0800 (PST)
Message-ID: <e8b90142-770f-7c23-59c6-303c88eaf6e6@intel.com>
Date:   Tue, 7 Dec 2021 13:28:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc:     ML dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
 <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
 <7d2f372f-36f5-1ecc-7ddb-25cf7d444e5d@amd.com>
 <CAP+8YyEzsedvYObj=FVUFTtYo4sdHH354=gBfCAu16qtL1jqLg@mail.gmail.com>
 <9540e080-6b07-c82c-d4d2-d2711a50066d@amd.com>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <9540e080-6b07-c82c-d4d2-d2711a50066d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/12/2021 13:00, Christian König wrote:
> Am 07.12.21 um 11:40 schrieb Bas Nieuwenhuizen:
>> On Tue, Dec 7, 2021 at 8:21 AM Christian König 
>> <christian.koenig@amd.com> wrote:
>>> Am 07.12.21 um 08:10 schrieb Lionel Landwerlin:
>>>> On 07/12/2021 03:32, Bas Nieuwenhuizen wrote:
>>>>> See the comments in the code. Basically if the seqno is already
>>>>> signalled then we get a NULL fence. If we then put the NULL fence
>>>>> in a binary syncobj it counts as unsignalled, making that syncobj
>>>>> pretty much useless for all expected uses.
>>>>>
>>>>> Not 100% sure about the transfer to a timeline syncobj but I
>>>>> believe it is needed there too, as AFAICT the add_point function
>>>>> assumes the fence isn't NULL.
>>>>>
>>>>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between
>>>>> binary and timeline v2")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>>>>> ---
>>>>>    drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>>>>>    1 file changed, 26 insertions(+)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/drm_syncobj.c
>>>>> b/drivers/gpu/drm/drm_syncobj.c
>>>>> index fdd2ec87cdd1..eb28a40400d2 100644
>>>>> --- a/drivers/gpu/drm/drm_syncobj.c
>>>>> +++ b/drivers/gpu/drm/drm_syncobj.c
>>>>> @@ -861,6 +861,19 @@ static int
>>>>> drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>>>>>                         &fence);
>>>>>        if (ret)
>>>>>            goto err;
>>>>> +
>>>>> +    /* If the requested seqno is already signaled
>>>>> drm_syncobj_find_fence may
>>>>> +     * return a NULL fence. To make sure the recipient gets
>>>>> signalled, use
>>>>> +     * a new fence instead.
>>>>> +     */
>>>>> +    if (!fence) {
>>>>> +        fence = dma_fence_allocate_private_stub();
>>>>> +        if (!fence) {
>>>>> +            ret = -ENOMEM;
>>>>> +            goto err;
>>>>> +        }
>>>>> +    }
>>>>> +
>>>>
>>>> Shouldn't we fix drm_syncobj_find_fence() instead?
>>> Mhm, now that you mention it. Bas, why do you think that
>>> dma_fence_chain_find_seqno() may return NULL when the fence is already
>>> signaled?
>>>
>>> Double checking the code that should never ever happen.
>> Well, I tested the patch with
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fmesa%2Fmesa%2F-%2Fmerge_requests%2F14097%2Fdiffs%3Fcommit_id%3Dd4c5c840f4e3839f9f5c1747a9034eb2b565f5c0&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cc1ab29fc100842826f5d08d9b96e102a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637744705383763833%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sXkTJWm%2FWm2xwgLGdepVWAOlqj%2FeArnvmMvnJpQ9YEs%3D&amp;reserved=0 
>>
>> so I'm pretty sure it happens, and this patch fixes  it, though I may
>> have misidentified what the code should do.
>>
>> My reading is that the dma_fence_chain_for_each in
>> dma_fence_chain_find_seqno will never visit a signalled fence (unless
>> the top one is signalled), as dma_fence_chain_walk will never return a
>> signalled fence (it only returns on NULL or !signalled).
>
> Ah, yes that suddenly makes more sense.
>
>> Happy to move this to drm_syncobj_find_fence.
>
> No, I think that your current patch is fine.
>
> That drm_syncobj_find_fence() only returns NULL when it can't find 
> anything !signaled is correct behavior I think.


We should probably update the docs then :


  * Returns 0 on success or a negative error value on failure. On 
success @fence
  * contains a reference to the fence, which must be released by calling
  * dma_fence_put().


Looking at some of the kernel drivers, it looks like they don't all 
protect themselves against NULL pointers :


https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/vc4/vc4_gem.c#L1195

https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c#L1020


-Lionel


>
> Going to push your original patch if nobody has any more objections.
>
> But somebody might want to take care of the IGT as well.
>
> Regards,
> Christian.
>
>>> Regards,
>>> Christian.
>>>
>>>> By returning a stub fence for the timeline case if there isn't one.
>>>>
>>>>
>>>> Because the same NULL fence check appears missing in amdgpu (and
>>>> probably other drivers).
>>>>
>>>>
>>>> Also we should have tests for this in IGT.
>>>>
>>>> AMD contributed some tests when this code was written but they never
>>>> got reviewed :(
>>>>
>>>>
>>>> -Lionel
>>>>
>>>>
>>>>>        chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>>>>>        if (!chain) {
>>>>>            ret = -ENOMEM;
>>>>> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file
>>>>> *file_private,
>>>>>                         args->src_point, args->flags, &fence);
>>>>>        if (ret)
>>>>>            goto err;
>>>>> +
>>>>> +    /* If the requested seqno is already signaled
>>>>> drm_syncobj_find_fence may
>>>>> +     * return a NULL fence. To make sure the recipient gets
>>>>> signalled, use
>>>>> +     * a new fence instead.
>>>>> +     */
>>>>> +    if (!fence) {
>>>>> +        fence = dma_fence_allocate_private_stub();
>>>>> +        if (!fence) {
>>>>> +            ret = -ENOMEM;
>>>>> +            goto err;
>>>>> +        }
>>>>> +    }
>>>>> +
>>>>>        drm_syncobj_replace_fence(binary_syncobj, fence);
>>>>>        dma_fence_put(fence);
>>>>>    err:
>>>>
>

