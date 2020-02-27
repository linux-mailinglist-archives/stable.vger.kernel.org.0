Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7391716E4
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgB0MQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:16:52 -0500
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:60677 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgB0MQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 07:16:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 620A23FD5F;
        Thu, 27 Feb 2020 13:16:49 +0100 (CET)
Authentication-Results: ste-pvt-msa1.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=gLbEzXfu;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.099
X-Spam-Level: 
X-Spam-Status: No, score=-2.099 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
        DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rfGpzPSC_Tad; Thu, 27 Feb 2020 13:16:48 +0100 (CET)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id B73293F622;
        Thu, 27 Feb 2020 13:16:46 +0100 (CET)
Received: from localhost.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id 07765360058;
        Thu, 27 Feb 2020 13:16:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1582805806; bh=HS94RJPImzDoQLY2q4Ne/b5a9NMsxYAfRk+4BrMewsw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gLbEzXfuzrAyw9EoRIHV1y36EvZXgzqWODh7uN9Np4P9BOcC3coXG7IQxrWeJsq3B
         bmwBK/ss7x+uwsleuEHkleUDcAYo5ayY+0hUiPO6JEA3VFA6oCzv8nIz467Mo9yiL7
         6hul+ss9vMywmIcQvCaux0tUk+2Pynh9sJKcBeTU=
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
 <41ca197c-136a-75d8-b269-801db44d4cba@shipmail.org>
 <20200227105643.h4klc3ybhpwv2l3x@sirius.home.kraxel.org>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Organization: VMware Inc.
Message-ID: <68a05ace-40bc-76d6-5464-2c96328874b9@shipmail.org>
Date:   Thu, 27 Feb 2020 13:16:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200227105643.h4klc3ybhpwv2l3x@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 11:56 AM, Gerd Hoffmann wrote:
>    Hi,
>
>> I think it might be safe for some integrated graphics where the driver
>> maintainers can guarantee that it's safe on all particular processors used
>> with that driver, but then IMO it should be moved out to those drivers.
>>
>> Other drivers needing write-combine shouldn't really use shmem.
>>
>> So again, to fix the regression, could we revert 0be895893607f ("drm/shmem:
>> switch shmem helper to &drm_gem_object_funcs.mmap") or does that have other
>> implications?
> This patch isn't a regression.  The old code path has the
> pgprot_writecombine() call in drm_gem_mmap_obj(), so the behavior
> is the same before and afterwards.

OK. I wasn't checking where this all came from from the start...

> But with the patch in place we can easily have shmem helpers do their
> own thing instead of depending on whatever drm_gem_mmap_obj() is doing.
> Just using cached mappings unconditionally would be perfectly fine for
> virtio-gpu.
>
> Not sure about the other users though.  I'd like to fix the virtio-gpu
> regression (coming from ttm -> shmem switch) asap, and I don't feel like
> changing the behavior for other drivers in 5.6-rc is a good idea.
>
> So I'd like to push patches 1+2 to -fixes and sort everything else later
> in -next.  OK?

OK with me. Do we have any idea what drivers are actually using 
write-combine and decrypted?

/Thomas



>
> cheers,
>    Gerd


