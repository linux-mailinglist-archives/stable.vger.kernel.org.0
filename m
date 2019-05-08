Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1817B53
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfEHOIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 10:08:48 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:54234 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfEHOIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 10:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=OXWL9yM5oSKvXY+Sc7sNvmmV1lIcFuLOw5jmcfOW6rc=;
        b=C11pfppLtMrgZB4cdv4b181Uat0VLWF7YT6O5JXLMFO/XBN+xchN+ebE9yvTJw5yRIISfd1FRaNIJieIMEDm2JmQCTXKhJANlb0ABNeipCn3FmhSFuNMSSLruKv7UL1OZSigptel6JhQfBhw0cOjsXRZcEMs+6I61qCBgJBlpF+dBAI7HXMdkaVjSSk2ZEKmIcumfjOzvh7o2B2tFVHq9hb4q4b73FRM7adc8eLkBlU0ZXGvSGGC8pk2Zr9xoB0FXFbAAhQns7fQcBmSopbKyH0E1E4FV8dRau7vFjqVIn7Vusxbrr9Cv43QbDbSh+G00FrYxfybxAwvbkDYr+dvLA==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:61879 helo=[192.168.10.178])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <noralf@tronnes.org>)
        id 1hONFV-0002YE-Gp; Wed, 08 May 2019 16:08:45 +0200
Subject: Re: [PATCH] drm/cma-helper: Fix drm_gem_cma_free_object()
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        dri-devel@lists.freedesktop.org
Cc:     "Li, Tingqian" <tingqian.li@intel.com>, stable@vger.kernel.org
References: <20190426124753.53722-1-noralf@tronnes.org>
 <67fc69cc-7db3-968e-2492-acd01dc3def5@tronnes.org>
 <1816a2c7-d409-09f5-964e-ebe7d4b91d1d@gmail.com>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Message-ID: <d1f983a0-fa3d-f3e1-707b-3412becc109e@tronnes.org>
Date:   Wed, 8 May 2019 16:08:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1816a2c7-d409-09f5-964e-ebe7d4b91d1d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 08.05.2019 08.33, skrev Oleksandr Andrushchenko:
> On 5/7/19 7:04 PM, Noralf Trønnes wrote:
>> Hi,
>>
>> Could someone please have a look at this one?
>>
>> Noralf.
>>
>> Den 26.04.2019 14.47, skrev Noralf Trønnes:
>>> The logic for freeing an imported buffer with a virtual address is
>>> broken. It will free the buffer instead of unmapping the dma buf.
>>> Fix by reversing the if ladder and first check if the buffer is
>>> imported.
>>>
>>> Fixes: b9068cde51ee ("drm/cma-helper: Add DRM_GEM_CMA_VMAP_DRIVER_OPS")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: "Li, Tingqian" <tingqian.li@intel.com>
>>> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
> Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Thanks Oleksandr, applied to drm-misc-next-fixes.

Noralf.

>>> ---
>>>
>>>   drivers/gpu/drm/drm_gem_cma_helper.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c
>>> b/drivers/gpu/drm/drm_gem_cma_helper.c
>>> index cc26625b4b33..e01ceed09e67 100644
>>> --- a/drivers/gpu/drm/drm_gem_cma_helper.c
>>> +++ b/drivers/gpu/drm/drm_gem_cma_helper.c
>>> @@ -186,13 +186,13 @@ void drm_gem_cma_free_object(struct
>>> drm_gem_object *gem_obj)
>>>         cma_obj = to_drm_gem_cma_obj(gem_obj);
>>>   -    if (cma_obj->vaddr) {
>>> -        dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
>>> -                cma_obj->vaddr, cma_obj->paddr);
>>> -    } else if (gem_obj->import_attach) {
>>> +    if (gem_obj->import_attach) {
>>>           if (cma_obj->vaddr)
>>>               dma_buf_vunmap(gem_obj->import_attach->dmabuf,
>>> cma_obj->vaddr);
>>>           drm_prime_gem_destroy(gem_obj, cma_obj->sgt);
>>> +    } else if (cma_obj->vaddr) {
>>> +        dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
>>> +                cma_obj->vaddr, cma_obj->paddr);
>>>       }
>>>         drm_gem_object_release(gem_obj);
>>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
