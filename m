Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A1171A3
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 08:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfEHGd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 02:33:26 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34461 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfEHGd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 02:33:26 -0400
Received: by mail-lf1-f65.google.com with SMTP id v18so11457348lfi.1
        for <stable@vger.kernel.org>; Tue, 07 May 2019 23:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wSfgw7BiPTIK7rSF926mclLkOzCKoWt4POZASR80exU=;
        b=XvtuTdiXdG50tx+b8t5XwkSkDso6nENBekOdEmZda7xvisWmptANvIxR6iYQRN6/ca
         h18uEkd4f7FA+9WxqLyhGDlLKchuF0UDxvZeZjdq/VAdX3sxp5nK41isI3OxaPWAeSF/
         uxeP2Uzq83bFlQgE4HTGsQ+1I7mhWnsxHLofoObgQg75XDVKIo84/1Z+NfBLAy9lLqO9
         6tqHK1S8CELuYGOmgfWWjBxaiNlBfbHDYUuxJHHI4vXUvjaHqiXkQYm0olq0iBwpNLmA
         UjEkQy799azHbghK9M/dNeSAa01GuSIBA326RSM2Moy3vMHvMwYEZVAjFEoahb9TaxW0
         Z/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wSfgw7BiPTIK7rSF926mclLkOzCKoWt4POZASR80exU=;
        b=t2OohRqkJiV7VZCDsvU71QUntbNzAdBMhaLmAuznmuxAvgayH0TEd37Qp/rit7jcn3
         Rji8U87ED96Cgtq61XkreTn4uxx2XJpbHAROYP+JwlRYnBd+xZT41rWlEeX9wYjU5vk6
         SPb5cX3srKAuDleCgKoF9K6+DgzJNFdYxulLWNK8nKEBaaj4uDfTGpiq8wezTVKzDAoj
         IqB6l0of4NxzOGR+BdzqdaQqiT/WrGNyO05n7/q8PSc5qaYI4//7Ot08CBjT20yIwvTj
         63ryb+eEvXJVwac9Pb6b9Hz+rOEvOcJECPLI/S2etTt3d8F0V53tBgzryFa+jWQF3fPS
         X2lQ==
X-Gm-Message-State: APjAAAUxWzOFAU/U6sxmnrXXJvg0nj1Huf8A4sWoFau+DrMDH9eE8vhG
        Nn3QJqYc/req29G05yrYFDTO0PJk
X-Google-Smtp-Source: APXvYqzKo3uOdRfceBfe2sas5wmynfulmeB4OPUXute987F0OwmCAXSLAI7TT44VpKJPPuRM4yAFlQ==
X-Received: by 2002:a19:a40f:: with SMTP id q15mr17527331lfc.121.1557297203407;
        Tue, 07 May 2019 23:33:23 -0700 (PDT)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id a11sm238059ljb.31.2019.05.07.23.33.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 23:33:22 -0700 (PDT)
Subject: Re: [PATCH] drm/cma-helper: Fix drm_gem_cma_free_object()
To:     =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        dri-devel@lists.freedesktop.org
Cc:     "Li, Tingqian" <tingqian.li@intel.com>, stable@vger.kernel.org
References: <20190426124753.53722-1-noralf@tronnes.org>
 <67fc69cc-7db3-968e-2492-acd01dc3def5@tronnes.org>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <1816a2c7-d409-09f5-964e-ebe7d4b91d1d@gmail.com>
Date:   Wed, 8 May 2019 09:33:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <67fc69cc-7db3-968e-2492-acd01dc3def5@tronnes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/19 7:04 PM, Noralf Trønnes wrote:
> Hi,
>
> Could someone please have a look at this one?
>
> Noralf.
>
> Den 26.04.2019 14.47, skrev Noralf Trønnes:
>> The logic for freeing an imported buffer with a virtual address is
>> broken. It will free the buffer instead of unmapping the dma buf.
>> Fix by reversing the if ladder and first check if the buffer is imported.
>>
>> Fixes: b9068cde51ee ("drm/cma-helper: Add DRM_GEM_CMA_VMAP_DRIVER_OPS")
>> Cc: stable@vger.kernel.org
>> Reported-by: "Li, Tingqian" <tingqian.li@intel.com>
>> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>
>>   drivers/gpu/drm/drm_gem_cma_helper.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
>> index cc26625b4b33..e01ceed09e67 100644
>> --- a/drivers/gpu/drm/drm_gem_cma_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_cma_helper.c
>> @@ -186,13 +186,13 @@ void drm_gem_cma_free_object(struct drm_gem_object *gem_obj)
>>   
>>   	cma_obj = to_drm_gem_cma_obj(gem_obj);
>>   
>> -	if (cma_obj->vaddr) {
>> -		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
>> -			    cma_obj->vaddr, cma_obj->paddr);
>> -	} else if (gem_obj->import_attach) {
>> +	if (gem_obj->import_attach) {
>>   		if (cma_obj->vaddr)
>>   			dma_buf_vunmap(gem_obj->import_attach->dmabuf, cma_obj->vaddr);
>>   		drm_prime_gem_destroy(gem_obj, cma_obj->sgt);
>> +	} else if (cma_obj->vaddr) {
>> +		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
>> +			    cma_obj->vaddr, cma_obj->paddr);
>>   	}
>>   
>>   	drm_gem_object_release(gem_obj);
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

