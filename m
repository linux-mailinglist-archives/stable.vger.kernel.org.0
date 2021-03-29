Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9334D861
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhC2ThB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 15:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhC2Tgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 15:36:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF48C061574;
        Mon, 29 Mar 2021 12:36:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o19so15517266edc.3;
        Mon, 29 Mar 2021 12:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HXb5EXzJ9acUERimB6ho5NVSB8Y8VyVg4M94D5L/HOM=;
        b=CofKSEonRZOnXxo6VoPfMdSdBQidCfltrWE4tINepx7+9oG3jTSKS2XIYruNZU+dLU
         VIaoSTgJyyFpzOmD4yi2WpPWJuc6qnbiJskzA2tDWfyOfStKsJ33lgeKkIjbArwjgnfx
         9XWwx41n/7BBkVk6e83DLQAsB0y5rGhqAj8uOT8ZsGU7L5JbBamH6oY3ZWzBLGh+YOe5
         ne+axUl4l6dDWgI3seBjFfgqP5JSpMjY3VSBwMEjbNnLw3ZjtDyiReasRpaFokNwNzcP
         kM2EMgP+JJWjrrVMAcVHFnJSIBrChZSI6zC0JcKjP2qcrdALC/aPcdKoYbW64iNWoyq2
         w73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HXb5EXzJ9acUERimB6ho5NVSB8Y8VyVg4M94D5L/HOM=;
        b=eLYu8JICQVRdcuRV5CvFgdXb5Xpfq5Lda8ylmOHdm8kIJGnS88xpYAemntn4SO2Kew
         RYAiGV4BmCpv59uTyYy+w5cv3AEK1AbreUjN6C1KJ3tX2ulx4BEus5v5+Qc4qh5XNLsW
         nKk6Q1BkP08vQG/wLW05YFA0SVijLajPgEy7GpJOeu5BzayS9lslweXXZMHQROm9PcQp
         gVOU+uaHVmdwJtxqCSMnKg6HlZ4URyjKyrK90JL1PgS6eHSaLAiuaTzKrtTauWpMAgRy
         kGZ6q7f4JniGix0Msqf5UviAPriZpMmSbTUgQT8lEqEJlaSd9mVJ9fPrtk443pBXr5sy
         a7SA==
X-Gm-Message-State: AOAM531E6K0YzP+9d5a7PcgaAc5cJRgptojf/cBo+Yrz/BZioqtATlPJ
        3APpwCtDaTQpVOCnCbYs/Apwjj/xSnE=
X-Google-Smtp-Source: ABdhPJwLSDAEF398fF1iUjClkbrtBHM+UjKBBKiBdnEtSAk0hMf0CEzHf12psHWT9y9vxfYZsxYCBQ==
X-Received: by 2002:aa7:d813:: with SMTP id v19mr30086149edq.213.1617046608196;
        Mon, 29 Mar 2021 12:36:48 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd? ([2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd])
        by smtp.gmail.com with ESMTPSA id u14sm8747191ejx.60.2021.03.29.12.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 12:36:47 -0700 (PDT)
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
To:     Xi Ruoyao <xry111@mengyan1223.wang>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
 <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
 <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
 <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
 <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
 <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
 <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <7701fb71-9243-2d90-e1e1-d347a53b7d77@gmail.com>
Date:   Mon, 29 Mar 2021 21:36:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29.03.21 um 21:27 schrieb Xi Ruoyao:
> Hi Christian,
>
> I don't think there is any constraint implemented to ensure `num_entries %
> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in `amdgpu_vm_bo_map()`:
>
>          /* validate the parameters */
>          if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
>              size == 0 || size & AMDGPU_GPU_PAGE_MASK)
>                  return -EINVAL;
>
> /* snip */
>
>          saddr /= AMDGPU_GPU_PAGE_SIZE;
>          eaddr /= AMDGPU_GPU_PAGE_SIZE;
>
> /* snip */
>
>          mapping->start = saddr;
>          mapping->last = eaddr;
>
>
> If we really want to ensure (mapping->last - mapping->start + 1) %
> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace "AMDGPU_GPU_PAGE_MASK"
> in "validate the parameters" with "PAGE_MASK".

Yeah, good point.

> I tried it and it broke userspace: Xorg startup fails with EINVAL with this
> change.

Well in theory it is possible that we always fill the GPUVM on a 4k 
basis while the native page size of the CPU is larger. Let me double 
check the code.

BTW: What code base are you based on? The code your post here is quite 
outdated.

Christian.

>
> On 2021-03-30 02:30 +0800, Xi Ruoyao wrote:
>> On 2021-03-30 02:21 +0800, Xi Ruoyao wrote:
>>> On 2021-03-29 20:10 +0200, Christian König wrote:
>>>> You need to identify the root cause of this, most likely start or last
>>>> are not a multiple of AMDGPU_GPU_PAGES_IN_CPU_PAGE.
>>> I printk'ed the value of start & last, they are all a multiple of 4
>>> (AMDGPU_GPU_PAGES_IN_CPU_PAGE).
>>>
>>> However... `num_entries = last - start + 1` so it became some irrational
>>> thing...  Either this line is wrong, or someone called
>>> amdgpu_vm_bo_update_mapping with [start, last) instead of [start, last], which
>>> is unexpected.
>> I added BUG_ON(num_entries % AMDGPU_GPU_PAGES_IN_CPU_PAGE != 0), get:
>>
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c90750>]
>>> amdgpu_vm_bo_update_mapping.constprop.0+0x218/0xae8
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c922b8>]
>>> amdgpu_vm_bo_update+0x270/0x4c0
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c823ec>]
>>> amdgpu_gem_va_ioctl+0x40c/0x430
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c1cae4>]
>>> drm_ioctl_kernel+0xcc/0x120
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c1cfd8>]
>>> drm_ioctl+0x220/0x408
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c5ea48>]
>>> amdgpu_drm_ioctl+0x58/0x98
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff838feac4>] sys_ioctl+0xcc/0xe8
>>> Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff836e74f0>]
>>> syscall_common+0x34/0x58
>>>
>>>>>>> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
>>>>>>> Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
>>>>>>> Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
>>>>>>> Reported-by: Dan Horák <dan@danny.cz>
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
>>>>>>> ---
>>>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
>>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>>>>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>>>>>> index ad91c0c3c423..cee0cc9c8085 100644
>>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>>>>>> @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct
>>>>>>> amdgpu_device *adev,
>>>>>>>                   }
>>>>>>>                   start = tmp;
>>>>>>>     
>>>>>>> -       } while (unlikely(start != last + 1));
>>>>>>> +       } while (unlikely(start < last + 1));
>>>>>>>     
>>>>>>>           r = vm->update_funcs->commit(&params, fence);
>>>>>>>     
>>>>>>>
>>>>>>> base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3

