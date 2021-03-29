Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5BE34D6A5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhC2SKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhC2SKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:10:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA618C061574;
        Mon, 29 Mar 2021 11:10:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u5so20892065ejn.8;
        Mon, 29 Mar 2021 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Plqd5i+LPDd0jPBiJdlzC3DqCduM4xFyiw8RibbunbE=;
        b=GGAJnYFkEf90LJp1AAn7mPBjicf2vH039Kxhfbt+EPABm1WqdzQ2y/h9i1JkwUbiRI
         dAe/5Qwst3GtU96zlTgjA7R4BZ9LhCVbWmxwzwq3wgZ/1Ss7JcOdTvB7umiuDQLh+DhH
         //ub0K9u+OOzbhevvUrccF2TeSHVxG5HwV03AuSs5uDrcKXMSNzfiHTbI9CSzbZL9GCB
         jHt0eyRclnjG07Hp1wsi+97G5O4oj3//A1LAYQFuALNAk0OYMquJtUpFUI5aK619eOLL
         VgL7lcE7WqPwNSGvivaJ+5WV5x0u1mF0N6xw02Fr8544hpbDuLyZ/5x0tcNK4+g78SaJ
         0hbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Plqd5i+LPDd0jPBiJdlzC3DqCduM4xFyiw8RibbunbE=;
        b=osMMrB+UP2vSfrzePr6nf9GPdf8AJczixTc+m4NTlpa4jNayNS4ejGq+3P5okI2szI
         PgCCaW2Ye0I3CLzcQAg5HiK8C4fYIROJ1/CiDNYTN4ZIQJa+DeciLDC7v6k734C2ftot
         A2P/9lsPNZFFn+1l9KjNlQke8NmimvkOM14IG6An8Jzx/HO70DZW8Vsce0eDO4c6hZWc
         eNjbzgKUEfjg1zM7gZAib5Zh9t0IGLknVU79SCcIC94KebQpDB2LIIr8x9NFvm92hy3u
         /ecSeMUpV2dZv8+hhn1Gdcsf/NWASkUBGZLF8BylO+IRxvJQm1+ViAbHm6yB/Go1GFNv
         xhEw==
X-Gm-Message-State: AOAM533F77Q/NlGq4TLe28xVZA0H0vdlgQvvbznHcfwYMA+Z2HVTaFY/
        bDO7tFHlNy8GaCD2IgC7qgJwy8u5pRk=
X-Google-Smtp-Source: ABdhPJxjZ33z4CQsjnd+1lRZeUqy5TceelIpWoWgfLE8I3eWx5vmN4nP3s62sh0lAkghmk8iycFyyQ==
X-Received: by 2002:a17:906:5295:: with SMTP id c21mr29779263ejm.67.1617041446634;
        Mon, 29 Mar 2021 11:10:46 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd? ([2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd])
        by smtp.gmail.com with ESMTPSA id v8sm9586002edq.76.2021.03.29.11.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 11:10:46 -0700 (PDT)
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
Date:   Mon, 29 Mar 2021 20:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29.03.21 um 20:08 schrieb Xi Ruoyao:
> On 2021-03-29 20:04 +0200, Christian König wrote:
>> Am 29.03.21 um 19:53 schrieb Xℹ Ruoyao:
>>> If the initial value of `num_entires` (calculated at line 1654) is not
>>> an integral multiple of `AMDGPU_GPU_PAGES_IN_CPU_PAGE`, in line 1681 a
>>> value greater than the initial value will be assigned to it.  That causes
>>> `start > last + 1` after line 1708.  Then in the next iteration an
>>> underflow happens at line 1654.  It causes message
>>>
>>>       *ERROR* Couldn't update BO_VA (-12)
>>>
>>> printed in kernel log, and GPU hanging.
>>>
>>> Fortify the criteria of the loop to fix this issue.
>> NAK the value of num_entries must always be a multiple of
>> AMDGPU_GPU_PAGES_IN_CPU_PAGE or otherwise we corrupt the page tables.
>>
>> How do you trigger that?
> Simply run "OpenGL area" from gtk3-demo (which just renders a triangle with GL)
> under Xorg, on MIPS64.  See the BugLink.

You need to identify the root cause of this, most likely start or last 
are not a multiple of AMDGPU_GPU_PAGES_IN_CPU_PAGE.

Christian.

>
>> Christian.
>>
>>> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
>>> Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
>>> Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
>>> Reported-by: Dan Horák <dan@danny.cz>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
>>> ---
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>> index ad91c0c3c423..cee0cc9c8085 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
>>> @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct
>>> amdgpu_device *adev,
>>>                  }
>>>                  start = tmp;
>>>    
>>> -       } while (unlikely(start != last + 1));
>>> +       } while (unlikely(start < last + 1));
>>>    
>>>          r = vm->update_funcs->commit(&params, fence);
>>>    
>>>
>>> base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3

