Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A850171150
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 08:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgB0HQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 02:16:55 -0500
Received: from pio-pvt-msa3.bahnhof.se ([79.136.2.42]:55442 "EHLO
        pio-pvt-msa3.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbgB0HQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 02:16:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTP id 0DBF53F619;
        Thu, 27 Feb 2020 08:16:53 +0100 (CET)
Authentication-Results: pio-pvt-msa3.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=iJco5cwq;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.099
X-Spam-Level: 
X-Spam-Status: No, score=-2.099 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
        DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from pio-pvt-msa3.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa3.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9s2FL3lWlzPa; Thu, 27 Feb 2020 08:16:52 +0100 (CET)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTPA id ED2B23F56A;
        Thu, 27 Feb 2020 08:16:49 +0100 (CET)
Received: from localhost.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id 54FBC360161;
        Thu, 27 Feb 2020 08:16:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1582787809; bh=czSVFr3N8XD20OuzmIfwTeJukmx6qXdkbu8G6D4uGW4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iJco5cwq3tifyUhkXULafE2E2SK5e+v+J9B7XYh2qG+7F11JINzsBKZmLzRA9B/2w
         y2kbglX6cpm9cvR95UVbBEo93uBouanPt0rjIpjhuPqoTbLAvcCHybEOPYpbD0Irog
         n46IYsNNHpyrXpXirNOiX5dCn1yFly6CK5V20pqU=
Subject: Re: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
To:     Chia-I Wu <olvaffe@gmail.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Guillaume Gardet <Guillaume.Gardet@arm.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        tzimmermann@suse.de
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-2-kraxel@redhat.com>
 <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
 <CAPaKu7R4VFYnk9UdpguZnkWeKk2ELVnoQ60=i72RN2GkME1ukw@mail.gmail.com>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Organization: VMware Inc.
Message-ID: <614ed528-8d6d-0179-6149-218566d4af06@shipmail.org>
Date:   Thu, 27 Feb 2020 08:16:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAPaKu7R4VFYnk9UdpguZnkWeKk2ELVnoQ60=i72RN2GkME1ukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 1:02 AM, Chia-I Wu wrote:
> On Wed, Feb 26, 2020 at 10:25 AM Thomas Hellström (VMware)
> <thomas_os@shipmail.org> wrote:
>> Hi, Gerd,
>>
>>
>>
>>    #define to_drm_gem_shmem_obj(obj) \
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index a421a2eed48a..aad9324dcf4f 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem)
>>        if (ret)
>>                goto err_zero_use;
>>
>> -     if (obj->import_attach)
>> +     if (obj->import_attach) {
>>                shmem->vaddr = dma_buf_vmap(obj->import_attach->dmabuf);
>> -     else
>> +     } else {
>> +             pgprot_t prot = PAGE_KERNEL;
>> +
>> +             if (!shmem->map_cached)
>> +                     prot = pgprot_writecombine(prot);
>>                shmem->vaddr = vmap(shmem->pages, obj->size >> PAGE_SHIFT,
>> -                                 VM_MAP, pgprot_writecombine(PAGE_KERNEL));
>> +                                 VM_MAP, prot)
>>
>> Wouldn't a vmap with pgprot_writecombine() create conflicting mappings
>> with the linear kernel map which is not write-combined? Or do you change
>> the linear kernel map of the shmem pages somewhere? vmap bypassess at
>> least the x86 PAT core mapping consistency check and this could
>> potentially cause spuriously overwritten memory.
> Yeah, I think this creates a conflicting alias.  It seems a call to
> set_pages_array_wc here or changes elsewhere is needed..
>
> But this is a pre-existing issue in the shmem helper.  There is also
> no universal fix (e.g., set_pages_array_wc is x86 only)?  I would hope
> this series can be merged sooner to fix the regression first.

The problem is this isn't doable with shmem, since that would create 
interesting problems when pages are swapped out.

So I would argue that the correct fix is to revert commit 0be895893607f 
("drm/shmem: switch shmem helper to &drm_gem_object_funcs.mmap")

If some drivers can argue that in their particular environment it's safe 
to use writecombine in this way, then modifying the page protection 
should be moved out to those drivers documenting that assumption. Using 
pgprot_decrypted() in this way could never be safe.

But IMO this should never be part of generic helpers.

/Thomas


