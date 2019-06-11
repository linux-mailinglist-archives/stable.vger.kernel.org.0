Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28153D759
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406027AbfFKT67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:58:59 -0400
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:6993 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406025AbfFKT66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:58:58 -0400
Subject: Re: Linux 5.1.9 build failure with
 CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
To:     Sven Joachim <svenjoac@gmx.de>, Thomas Backlund <tmb@mageia.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
 <20190611174006.GB31662@kroah.com>
 <11b2d815-d0c0-1f68-557d-144166c4a1a7@mageia.org>
 <877e9rkiwb.fsf@turtle.gmx.de>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <6ddf2c2d-7078-ffab-ac8c-2b0295f8d12f@mageia.org>
Date:   Tue, 11 Jun 2019 22:58:55 +0300
MIME-Version: 1.0
In-Reply-To: <877e9rkiwb.fsf@turtle.gmx.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-WatchGuard-Spam-ID: str=0001.0A0C0206.5D000802.0012,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.195
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Den 11-06-2019 kl. 22:43, skrev Sven Joachim:
> On 2019-06-11 22:08 +0300, Thomas Backlund wrote:
>
>> Den 11-06-2019 kl. 20:40, skrev Greg Kroah-Hartman:
>>> On Tue, Jun 11, 2019 at 07:33:16PM +0200, Daniel Vetter wrote:
>>>> On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>> On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
>>>>>> Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
>>>>>> legacy contexts. (v3)") has caused a build failure for me when I
>>>>>> actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
>>>>>>
>>>>>> ,----
>>>>>> | Kernel: arch/x86/boot/bzImage is ready  (#1)
>>>>>> |   Building modules, stage 2.
>>>>>> |   MODPOST 290 modules
>>>>>> | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
>>>>>> | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
>>>>>> `----
>>>> Calling drm_legacy_mmap is definitely not a great idea. I think either
>>>> we need a custom patch to remove that out on older kernels, or maybe
>>>> even #ifdef if you want to be super paranoid about breaking stuff ...
>>>>
>>>>>> Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
>>>>>> Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
>>>>>> drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
>>>>>> apply in 5.1.9.
>>>>>>
>>>>>> Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
>>>>>> them yet.
>>>>> They probably are.
>>>>>
>>>>> Should I just revert this patch in the stable tree, or add some other
>>>>> patch (like the one pointed out here, which seems an odd patch for
>>>>> stable...)
>>>> ... or backport the above patch, that should be save to do too. Not
>>>> sure what stable folks prefer?
>>> The above patch does not apply to all of the stable branches, so how
>>> about I just revert this?  People can live with this option not able to
>>> turn off for now, and if they really want it, they can use a newer
>>> kernel, right?
>>>
>> Or add the simple fix suggested by Daniel (if I understand correctly):
>>
>>
>> From: Thomas Backlund <tmb@mageia.org>
>>
>> Setting CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n (added by commit:
>> b30a43ac7132) causes the build to fail with:
>>
>> ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
>>
>> Fix that by adding check for CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT around
>> the code using drm_legacy_mmap()
>>
>> Fixes: b30a43ac7132 drm/nouveau: add kconfig option to turn off
>> nouveau legacy contexts. (v3)
>> Signed-off-by: Thomas Backlund <tmb@mageia.org>
>>
>> ---
>>   drivers/gpu/drm/nouveau/nouveau_ttm.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> --- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
>> @@ -168,8 +168,10 @@ nouveau_ttm_mmap(struct file *filp, stru
>>   	struct drm_file *file_priv = filp->private_data;
>>   	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
>>
>> +#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
>>   	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
>>   		return drm_legacy_mmap(filp, vma);
>> +#endif
>>
>>   	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
>>   }
> That's not quite correct, I am afraid.  If
> CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT is not defined, you still need to do
> the test, but return -EINVAL.  Something along these lines:
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
> index 1543c2f8d3d3..05d513d54555 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
> @@ -169,7 +169,11 @@ nouveau_ttm_mmap(struct file *filp, struct vm_area_struct *vma)
>   	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
>
>   	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
> +#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
>   		return drm_legacy_mmap(filp, vma);
> +#else
> +		return -EINVAL;
> +#endif
>
>   	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
>   }
>
>
> At least that builds for me, need to reboot to check whether it works.
>
> Cheers,
>         Sven


Ah, indeed. thats what basically all other drivers did before bed2dd8421 
("drm/ttm:
Quick-test mmap offset in ttm_bo_mmap()"), and in that commit the same 
check
was moved to drivers/gpu/drm/ttm/ttm_bo_vm.c


--

Thomas


