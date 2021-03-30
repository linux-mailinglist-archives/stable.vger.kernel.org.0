Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0734E849
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhC3NDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:03:37 -0400
Received: from mengyan1223.wang ([89.208.246.23]:60036 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhC3NDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:03:14 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id D93746594D;
        Tue, 30 Mar 2021 09:02:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617109392;
        bh=X2EGDZ9BOxE5WHmYu74k0fWpD97KnsQjPUvAY9jam48=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X9+iU8o1vAmsAaz3z1YxHtzBYrzVoeUMfn9h4Rp4s308CHVoVU+a6Gm9GdlKHJIMU
         8AsSOQYR5ryPtMKkHfCfZfbP5mZ4PMDu2fV1zZ3RkV9HTpo4YMJDD9fxB9ZNrThDVp
         2uc59oXova4FbxZPKF/a7sHqurDtU9fbphbsLv0MumyvPPZOz22iYYeREiLRFMAex6
         DqUuuwGBvBS3eb3NGt5UN99Duq2/c+qsmT08bdCP+ynIaneJcJbIwSPp0uyXDPerAE
         CXRmp4Mh4tSVfoIWsyMTPG9F2FbyLDEFWt3fZGWep5oq/X1+bqoa4hUDB7QIxGTEKv
         5iyqqUE0IyIVw==
Message-ID: <f3fb57055f0bd3f19bb6ac397dc92113e1555764.camel@mengyan1223.wang>
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
From:   Xi Ruoyao <xry111@mengyan1223.wang>
To:     Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Cc:     David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
Date:   Tue, 30 Mar 2021 21:02:08 +0800
In-Reply-To: <c3caf16b-584a-3e4c-0104-15bb41613136@amd.com>
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
         <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
         <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
         <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
         <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
         <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
         <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
         <7701fb71-9243-2d90-e1e1-d347a53b7d77@gmail.com>
         <368b9b1b7343e35b446bb1028ccf0ae75dc2adc4.camel@mengyan1223.wang>
         <71e3905a5b72c5b97df837041b19175540ebb023.camel@mengyan1223.wang>
         <c3caf16b-584a-3e4c-0104-15bb41613136@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-30 14:55 +0200, Christian König wrote:
> Am 30.03.21 um 14:04 schrieb Xi Ruoyao:
> > On 2021-03-30 03:40 +0800, Xi Ruoyao wrote:
> > > On 2021-03-29 21:36 +0200, Christian König wrote:
> > > > Am 29.03.21 um 21:27 schrieb Xi Ruoyao:
> > > > > Hi Christian,
> > > > > 
> > > > > I don't think there is any constraint implemented to ensure `num_entries
> > > > > %
> > > > > AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in
> > > > > `amdgpu_vm_bo_map()`:
> > > > > 
> > > > >           /* validate the parameters */
> > > > >           if (saddr & AMDGPU_GPU_PAGE_MASK || offset &
> > > > > AMDGPU_GPU_PAGE_MASK
> > > > >               size == 0 || size & AMDGPU_GPU_PAGE_MASK)
> > > > >                   return -EINVAL;
> > > > > 
> > > > > /* snip */
> > > > > 
> > > > >           saddr /= AMDGPU_GPU_PAGE_SIZE;
> > > > >           eaddr /= AMDGPU_GPU_PAGE_SIZE;
> > > > > 
> > > > > /* snip */
> > > > > 
> > > > >           mapping->start = saddr;
> > > > >           mapping->last = eaddr;
> > > > > 
> > > > > 
> > > > > If we really want to ensure (mapping->last - mapping->start + 1) %
> > > > > AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace
> > > > > "AMDGPU_GPU_PAGE_MASK"
> > > > > in "validate the parameters" with "PAGE_MASK".
> > It should be "~PAGE_MASK", "PAGE_MASK" has an opposite convention of
> > "AMDGPU_GPU_PAGE_MASK" :(.
> > 
> > > > Yeah, good point.
> > > > 
> > > > > I tried it and it broke userspace: Xorg startup fails with EINVAL with
> > > > > this
> > > > > change.
> > > > Well in theory it is possible that we always fill the GPUVM on a 4k
> > > > basis while the native page size of the CPU is larger. Let me double
> > > > check the code.
> > On my platform, there are two issues both causing the VM corruption.  One is
> > fixed by agd5f/linux@fe001e7.
> 
> What is fe001e7? A commit id? If yes then that is to short and I can't 
> find it.
> 
> >    Another is in Mesa from userspace:  it uses
> > `dev_info->gart_page_size` as the alignment, but the kernel AMDGPU driver
> > expects it to use `dev_info->virtual_address_alignment`.
> 
> Mhm, looking at the kernel code I would rather say Mesa is correct and 
> the kernel driver is broken.
> 
> The gart_page_size is limited by the CPU page size, but the 
> virtual_address_alignment isn't.
> 
> > If we can make the change to fill the GPUVM on a 4k basis, we can fix this
> > issue
> > and make virtual_address_alignment = 4K.  Otherwise, we should fortify the
> > parameter validation, changing "AMDGPU_GPU_PAGE_MASK" to "~PAGE_MASK".  Then
> > the
> > userspace will just get an EINVAL, instead of a slient VM corruption.  And
> > someone should tell Mesa developers to fix the code in this case.
> 
> I rather see this as a kernel bug. Can you test if this code fragment 
> fixes your issue:
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c 
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> index 64beb3399604..e1260b517e1b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void 
> *data, struct drm_file *filp)
>                  }
>                  dev_info->virtual_address_alignment = 
> max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
>                  dev_info->pte_fragment_size = (1 << 
> adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
> -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
> +               dev_info->gart_page_size = 
> dev_info->virtual_address_alignment;
>                  dev_info->cu_active_number = adev->gfx.cu_info.number;
>                  dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
>                  dev_info->ce_ram_size = adev->gfx.ce_ram_size;

It works.  I've seen it at
https://github.com/xen0n/linux/commit/84ada72983838bd7ce54bc32f5d34ac5b5aae191
before (with a common sub-expression, though :).

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

