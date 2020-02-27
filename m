Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902C9171253
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 09:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgB0IUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 03:20:53 -0500
Received: from ste-pvt-msa2.bahnhof.se ([213.80.101.71]:41757 "EHLO
        ste-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0IUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 03:20:53 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 03:20:51 EST
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 9F5ED3FDD8;
        Thu, 27 Feb 2020 09:11:03 +0100 (CET)
Authentication-Results: ste-pvt-msa2.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=XxKN2Xlt;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.099
X-Spam-Level: 
X-Spam-Status: No, score=-2.099 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
        DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Authentication-Results: ste-ftg-msa2.bahnhof.se (amavisd-new);
        dkim=pass (1024-bit key) header.d=shipmail.org
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (ste-ftg-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I4TNgQ69zXiU; Thu, 27 Feb 2020 09:11:01 +0100 (CET)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id DEC903FD95;
        Thu, 27 Feb 2020 09:11:00 +0100 (CET)
Received: from localhost.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id 02844360161;
        Thu, 27 Feb 2020 09:11:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1582791060; bh=4+EUKvhq052ADxUY5m3Qra0RsCbqHdQMZ0878ICxJ/A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XxKN2Xltkigp8bI3i4eY9sLbnotimpTjgwP/4RwY7bAC+p8ritoU52OUi85dFl1sE
         awh+0IsJUr1oaYibbpGRnRjHDYPDAYRZhh1Ok6JJlENqZf355Mv4guK/U2DwnTzige
         /msPpZyKFVYtYP64oOEkUgVja6dPnqpLzz+G3uhk=
Subject: Re: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, Guillaume.Gardet@arm.com,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, gurchetansingh@chromium.org,
        tzimmermann@suse.de
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-2-kraxel@redhat.com>
 <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
 <20200227075321.ki74hfjpnsqv2yx2@sirius.home.kraxel.org>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Organization: VMware Inc.
Message-ID: <41ca197c-136a-75d8-b269-801db44d4cba@shipmail.org>
Date:   Thu, 27 Feb 2020 09:10:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200227075321.ki74hfjpnsqv2yx2@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 8:53 AM, Gerd Hoffmann wrote:
>    Hi,
>
>>> +		if (!shmem->map_cached)
>>> +			prot = pgprot_writecombine(prot);
>>>    		shmem->vaddr = vmap(shmem->pages, obj->size >> PAGE_SHIFT,
>>> -				    VM_MAP, pgprot_writecombine(PAGE_KERNEL));
>>> +				    VM_MAP, prot)
>>
>> Wouldn't a vmap with pgprot_writecombine() create conflicting mappings with
>> the linear kernel map which is not write-combined?
> I think so, yes.
>
>> Or do you change the linear kernel map of the shmem pages somewhere?
> Havn't seen anything doing so while browsing the code.
>
>> vmap bypassess at least the
>> x86 PAT core mapping consistency check and this could potentially cause
>> spuriously overwritten memory.
> Well, I don't think the linear kernel map is ever used to access the
> shmem gem objects.  So while this isn't exactly clean it shouldn't
> cause problems in practice.
>
> Suggestions how to fix that?
>
So this has historically caused problems since the linear kernel map has 
been accessed while prefetching, even if it's never used. Some 
processors like AMD athlon actually even wrote back the prefetched 
contents without ever using it.

Also the linear kernel map could be cached somewhere because of the 
page's previous usage. (hibernation  for example?)

I think it might be safe for some integrated graphics where the driver 
maintainers can guarantee that it's safe on all particular processors 
used with that driver, but then IMO it should be moved out to those drivers.

Other drivers needing write-combine shouldn't really use shmem.

So again, to fix the regression, could we revert 0be895893607f 
("drm/shmem: switch shmem helper to &drm_gem_object_funcs.mmap") or does 
that have other implications?

/Thomas


