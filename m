Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660DF34E70F
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 14:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhC3MFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 08:05:13 -0400
Received: from mengyan1223.wang ([89.208.246.23]:59640 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhC3MEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 08:04:55 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 221F36594D;
        Tue, 30 Mar 2021 08:04:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617105894;
        bh=9n4noZb5E2aEglOTZKnCbCPj/j/5SXMSR6/nQrd4Z1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kxJCRiyaZuIykRdtEdnLeNCB1VYo85ccJt3fleCbfgrj3r1qyGVrwAZUVJU3uF4kI
         i2iXYTcWqsr3T9rnfMMri2Y9+l/4fwm39xu9PFgdZMh25sqJY+J5RRAGRRPMeQSJiq
         DxbKp7oM/F44iT7w/Y+z7ZvV+2CvBu3whU2JmmsQ0oneTHcOmyv+KCH1046dUZ8vdI
         PIYzQ5rPlInEZLchxh0a6QnGkiQ86o1QIbbEWB6UVGdnuQEx79v8JDWtPT31SMob5Y
         eDRbFnIiSC1UXko1ZhyEc5kwmZqMr/2PJenlzN1xhgcigd87MpfgzPlYhjhhKZ7Ppm
         Sy8Tfjjy6aBsQ==
Message-ID: <71e3905a5b72c5b97df837041b19175540ebb023.camel@mengyan1223.wang>
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
Date:   Tue, 30 Mar 2021 20:04:32 +0800
In-Reply-To: <368b9b1b7343e35b446bb1028ccf0ae75dc2adc4.camel@mengyan1223.wang>
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
         <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
         <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
         <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
         <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
         <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
         <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
         <7701fb71-9243-2d90-e1e1-d347a53b7d77@gmail.com>
         <368b9b1b7343e35b446bb1028ccf0ae75dc2adc4.camel@mengyan1223.wang>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-30 03:40 +0800, Xi Ruoyao wrote:
> On 2021-03-29 21:36 +0200, Christian König wrote:
> > Am 29.03.21 um 21:27 schrieb Xi Ruoyao:
> > > Hi Christian,
> > > 
> > > I don't think there is any constraint implemented to ensure `num_entries %
> > > AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in `amdgpu_vm_bo_map()`:
> > > 
> > >          /* validate the parameters */
> > >          if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK
> > > > > 
> > >              size == 0 || size & AMDGPU_GPU_PAGE_MASK)
> > >                  return -EINVAL;
> > > 
> > > /* snip */
> > > 
> > >          saddr /= AMDGPU_GPU_PAGE_SIZE;
> > >          eaddr /= AMDGPU_GPU_PAGE_SIZE;
> > > 
> > > /* snip */
> > > 
> > >          mapping->start = saddr;
> > >          mapping->last = eaddr;
> > > 
> > > 
> > > If we really want to ensure (mapping->last - mapping->start + 1) %
> > > AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace
> > > "AMDGPU_GPU_PAGE_MASK"
> > > in "validate the parameters" with "PAGE_MASK".

It should be "~PAGE_MASK", "PAGE_MASK" has an opposite convention of
"AMDGPU_GPU_PAGE_MASK" :(.

> > Yeah, good point.
> > 
> > > I tried it and it broke userspace: Xorg startup fails with EINVAL with
> > > this
> > > change.
> > 
> > Well in theory it is possible that we always fill the GPUVM on a 4k 
> > basis while the native page size of the CPU is larger. Let me double 
> > check the code.

On my platform, there are two issues both causing the VM corruption.  One is
fixed by agd5f/linux@fe001e7.  Another is in Mesa from userspace:  it uses
`dev_info->gart_page_size` as the alignment, but the kernel AMDGPU driver
expects it to use `dev_info->virtual_address_alignment`.

If we can make the change to fill the GPUVM on a 4k basis, we can fix this issue
and make virtual_address_alignment = 4K.  Otherwise, we should fortify the
parameter validation, changing "AMDGPU_GPU_PAGE_MASK" to "~PAGE_MASK".  Then the
userspace will just get an EINVAL, instead of a slient VM corruption.  And
someone should tell Mesa developers to fix the code in this case.
--
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

