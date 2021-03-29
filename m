Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0379634D68F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhC2SE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhC2SED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:04:03 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7385C061574;
        Mon, 29 Mar 2021 11:04:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id o19so15232473edc.3;
        Mon, 29 Mar 2021 11:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=91f+t4KKqAvvbgMruzc8afBLkhYSXYPNhwopXJ4FvVA=;
        b=p6FRuPHxYfTgUMm71UKWithIReDTZW6SeruOWNV5sOveBvkwcHbRXfHKWUKErqFjv4
         VnseLfIZ+uJXbhBFCOgoZiIF2USLUIHX8guz67aa7SeGe11LtVAGOftJ8rpQYzABxZv0
         NBGKe3elev+KxtqxnS/kfj6uTohaKbXdcMYSJgcmQP/m93VQC0iZ5hAhIGx0Vm3NOhd/
         fz6BPNiXsw7YJn8r+AIL+RtgZ1wnaaiCC4DYk44V8NMxun+pnLMhD/XuSL9iBWztZI3T
         dFVtrMO23I9KORs2uL48iAYqFmQXkBmVF0QeRvWJntphdGHVrrY0CyCA0WqebLbC+C2w
         k8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=91f+t4KKqAvvbgMruzc8afBLkhYSXYPNhwopXJ4FvVA=;
        b=CB5n52rXqQFTIDnmWNX2m20U3omZVqpHF5I0byisE1F2XE6l+uRsi2eqzoVA1lN5aT
         2A3IEiDyxwHSfOXkG6r+pmsCzEBm0keq0dFdr9jQ0BdzzqoEmII90rp0U7ry/gy90tlz
         JPs6lCKGecd89ujVgGO4vAPL7QoRKGDz5nt81vOcIEVfeT6isYX1XwYJah/z8Ks5Uwwc
         IdIRCjQ/Y1b4Sb6h4BrU52disESgPRnrG54V4dFyXrDR69TJifVzzBb6wUDnszSc34S1
         BpZ/kFhmzoZbA4QSp8LLZM4H97wv9bVOWS+8vAFVJQjmEfL85Fqg7PItqWknYZLiVz3I
         sYJA==
X-Gm-Message-State: AOAM532HZSoGDAMQApf5U5hQbbBCSNtdL2hVdUHEGPz0Au1xOt4mtSgh
        6ccYVPqgO/W9LrpCdtn7Lr7fUpxRJh8=
X-Google-Smtp-Source: ABdhPJySGC280M1HDveYNoXLySwn5Qy7wl8t1bmn1rG2whFdiva4yYtWd0vkZ3aI0+Zv6ITZX6kE+Q==
X-Received: by 2002:aa7:db53:: with SMTP id n19mr30446881edt.330.1617041041521;
        Mon, 29 Mar 2021 11:04:01 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd? ([2a02:908:1252:fb60:8415:4d1c:ad0a:e8fd])
        by smtp.gmail.com with ESMTPSA id cf4sm9446313edb.19.2021.03.29.11.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 11:04:01 -0700 (PDT)
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
To:     =?UTF-8?B?WOKEuSBSdW95YW8=?= <xry111@mengyan1223.wang>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
Date:   Mon, 29 Mar 2021 20:04:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329175348.26859-1-xry111@mengyan1223.wang>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29.03.21 um 19:53 schrieb Xℹ Ruoyao:
> If the initial value of `num_entires` (calculated at line 1654) is not
> an integral multiple of `AMDGPU_GPU_PAGES_IN_CPU_PAGE`, in line 1681 a
> value greater than the initial value will be assigned to it.  That causes
> `start > last + 1` after line 1708.  Then in the next iteration an
> underflow happens at line 1654.  It causes message
>
>      *ERROR* Couldn't update BO_VA (-12)
>
> printed in kernel log, and GPU hanging.
>
> Fortify the criteria of the loop to fix this issue.

NAK the value of num_entries must always be a multiple of 
AMDGPU_GPU_PAGES_IN_CPU_PAGE or otherwise we corrupt the page tables.

How do you trigger that?

Christian.

>
> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
> Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
> Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
> Reported-by: Dan Horák <dan@danny.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> index ad91c0c3c423..cee0cc9c8085 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct amdgpu_device *adev,
>   		}
>   		start = tmp;
>   
> -	} while (unlikely(start != last + 1));
> +	} while (unlikely(start < last + 1));
>   
>   	r = vm->update_funcs->commit(&params, fence);
>   
>
> base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3

