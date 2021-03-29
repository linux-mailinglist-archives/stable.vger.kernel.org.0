Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC1834D81C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhC2T14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 15:27:56 -0400
Received: from mengyan1223.wang ([89.208.246.23]:54130 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhC2T1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 15:27:35 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id D718C65B2D;
        Mon, 29 Mar 2021 15:27:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617046055;
        bh=q5jy06gXbsh54zTcjXzkpHo6iPU/YhiGMix3TqY8BK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hg/Gc597690mti/NLTwXW6eufoo40Y0FP61MRrSTcqtmdukiixS07cWw2xjn9/Ipn
         nNFA4csrZtwx0neVRRo6IQNXbOwejpumm2sQN8z/eQuoSwoZ/AXHcNASsM9Z+Qr+Pz
         +ZHCHnG+6iUs46Z4iYdKoJvTabQwRWdaLymrD1B8ijcWq7UX06Q79eiohSyCktTKng
         a14eSX2wdS3GSIliKyke8imRGdN2ITbYjwwwCN0v/d5gXUjOJvs1Xs7CAAI15g2xyK
         aHaPfvz4cagvj2dz+MlehKdzSNxmR+cLosYlmKvV1YG90qEqf0rDe9I90xdZBj2rq8
         mBNCzDIY/CN/Q==
Message-ID: <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
From:   Xi Ruoyao <xry111@mengyan1223.wang>
To:     Christian =?ISO-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
Date:   Tue, 30 Mar 2021 03:27:15 +0800
In-Reply-To: <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
         <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
         <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
         <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
         <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
         <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

I don't think there is any constraint implemented to ensure `num_entries %
AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in `amdgpu_vm_bo_map()`:

        /* validate the parameters */
        if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
            size == 0 || size & AMDGPU_GPU_PAGE_MASK)
                return -EINVAL;

/* snip */

        saddr /= AMDGPU_GPU_PAGE_SIZE;
        eaddr /= AMDGPU_GPU_PAGE_SIZE;

/* snip */

        mapping->start = saddr;
        mapping->last = eaddr;


If we really want to ensure (mapping->last - mapping->start + 1) %
AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace "AMDGPU_GPU_PAGE_MASK"
in "validate the parameters" with "PAGE_MASK".

I tried it and it broke userspace: Xorg startup fails with EINVAL with this
change.

On 2021-03-30 02:30 +0800, Xi Ruoyao wrote:
> On 2021-03-30 02:21 +0800, Xi Ruoyao wrote:
> > On 2021-03-29 20:10 +0200, Christian König wrote:
> > > You need to identify the root cause of this, most likely start or last 
> > > are not a multiple of AMDGPU_GPU_PAGES_IN_CPU_PAGE.
> > 
> > I printk'ed the value of start & last, they are all a multiple of 4
> > (AMDGPU_GPU_PAGES_IN_CPU_PAGE).
> > 
> > However... `num_entries = last - start + 1` so it became some irrational
> > thing...  Either this line is wrong, or someone called
> > amdgpu_vm_bo_update_mapping with [start, last) instead of [start, last], which
> > is unexpected.
> 
> I added BUG_ON(num_entries % AMDGPU_GPU_PAGES_IN_CPU_PAGE != 0), get:
> 
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c90750>]
> > amdgpu_vm_bo_update_mapping.constprop.0+0x218/0xae8
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c922b8>]
> > amdgpu_vm_bo_update+0x270/0x4c0
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c823ec>]
> > amdgpu_gem_va_ioctl+0x40c/0x430
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c1cae4>]
> > drm_ioctl_kernel+0xcc/0x120
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c1cfd8>]
> > drm_ioctl+0x220/0x408
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff83c5ea48>]
> > amdgpu_drm_ioctl+0x58/0x98
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff838feac4>] sys_ioctl+0xcc/0xe8
> > Mar 30 02:28:27 xry111-A1901 kernel: [<ffffffff836e74f0>]
> > syscall_common+0x34/0x58
> > 
> 
> > > > > > BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
> > > > > > Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
> > > > > > Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > > > > > Reported-by: Dan Horák <dan@danny.cz>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > > > > > ---
> > > > > >    drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
> > > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > > > index ad91c0c3c423..cee0cc9c8085 100644
> > > > > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > > > @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct
> > > > > > amdgpu_device *adev,
> > > > > >                  }
> > > > > >                  start = tmp;
> > > > > >    
> > > > > > -       } while (unlikely(start != last + 1));
> > > > > > +       } while (unlikely(start < last + 1));
> > > > > >    
> > > > > >          r = vm->update_funcs->commit(&params, fence);
> > > > > >    
> > > > > > 
> > > > > > base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3
> > > 
> > 
> 

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

