Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2DD46D09B
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhLHKLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 05:11:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:20482 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhLHKLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 05:11:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237607943"
X-IronPort-AV: E=Sophos;i="5.87,297,1631602800"; 
   d="scan'208";a="237607943"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 02:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,297,1631602800"; 
   d="scan'208";a="612042658"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2021 02:08:21 -0800
Received: from [10.252.36.35] (unknown [10.252.36.35])
        by linux.intel.com (Postfix) with ESMTP id B11F6580641;
        Wed,  8 Dec 2021 02:08:20 -0800 (PST)
Message-ID: <ca5724e4-85a7-11a7-51fa-1152e0cf403f@intel.com>
Date:   Wed, 8 Dec 2021 12:08:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] drm/syncobj: Deal with signalled fences in
 drm_syncobj_find_fence.
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20211208023935.17018-1-bas@basnieuwenhuizen.nl>
 <2e0269eb-d007-4577-d760-343ccfb05c9a@amd.com>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <2e0269eb-d007-4577-d760-343ccfb05c9a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/12/2021 11:28, Christian König wrote:
> Am 08.12.21 um 03:39 schrieb Bas Nieuwenhuizen:
>> dma_fence_chain_find_seqno only ever returns the top fence in the
>> chain or an unsignalled fence. Hence if we request a seqno that
>> is already signalled it returns a NULL fence. Some callers are
>> not prepared to handle this, like the syncobj transfer functions
>> for example.
>>
>> This behavior is "new" with timeline syncobj and it looks like
>> not all callers were updated. To fix this behavior make sure
>> that a successful drm_sync_find_fence always returns a non-NULL
>> fence.
>>
>> v2: Move the fix to drm_syncobj_find_fence from the transfer
>>      functions.
>>
>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between 
>> binary and timeline v2")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>
> Reviewed-by: Christian König <christian.koenig@amd.com>


Thanks!


Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>


>
>> ---
>>   drivers/gpu/drm/drm_syncobj.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/drm_syncobj.c 
>> b/drivers/gpu/drm/drm_syncobj.c
>> index fdd2ec87cdd1..11be91b5709b 100644
>> --- a/drivers/gpu/drm/drm_syncobj.c
>> +++ b/drivers/gpu/drm/drm_syncobj.c
>> @@ -404,8 +404,17 @@ int drm_syncobj_find_fence(struct drm_file 
>> *file_private,
>>         if (*fence) {
>>           ret = dma_fence_chain_find_seqno(fence, point);
>> -        if (!ret)
>> +        if (!ret) {
>> +            /* If the requested seqno is already signaled
>> +             * drm_syncobj_find_fence may return a NULL
>> +             * fence. To make sure the recipient gets
>> +             * signalled, use a new fence instead.
>> +             */
>> +            if (!*fence)
>> +                *fence = dma_fence_get_stub();
>> +
>>               goto out;
>> +        }
>>           dma_fence_put(*fence);
>>       } else {
>>           ret = -EINVAL;
>

