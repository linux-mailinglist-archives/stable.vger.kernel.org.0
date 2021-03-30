Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87134ECDC
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhC3PsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 11:48:01 -0400
Received: from mengyan1223.wang ([89.208.246.23]:33500 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhC3Pra (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 11:47:30 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 1C2D56594D;
        Tue, 30 Mar 2021 11:47:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617119249;
        bh=eigbB8qDAI5a8bYAXwC0uvl+3igPnE99OdGkCocv9GA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1EWOwcM9/Ngu2Q35IvMTF6ORq00zTvR8ODmvXryNd1NO40Una9iMzBXJpLZB6pIuu
         0nE/T24ASHFs5LYmG+Qy5eYqmx/mbYPQuGK4yWSbQvj2iXqpAek6FTl0I4Ln1a8OFd
         JBTCvwO77mb0Grnu0lK0gmEUeS7aQJY+KQP6TMz/fyJxsLubm+ib1rshZBJCiaoi2Y
         +CZ2RED5MXg1F2INPK0cWYlYGXCtgI3aYWoUr3lBHq2+vRV2Y2s6Ypbfsy8B6SqVQq
         ZTKxk3s8yVHLSfanPUHytOYezaBpaKChpVW7iFvHjtQCaWi/dTt0YoRhivNOaTfkfX
         y3vRPT3huSCAQ==
Message-ID: <91dec1a3b6fe9165d1adab9cc69a788799e64fec.camel@mengyan1223.wang>
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
From:   Xi Ruoyao <xry111@mengyan1223.wang>
To:     Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>
Cc:     Christian =?ISO-8859-1?Q?K=F6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
Date:   Tue, 30 Mar 2021 23:46:58 +0800
In-Reply-To: <92dc0767-0c4e-34bc-d1ee-66105d0f2013@amd.com>
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
         <f3fb57055f0bd3f19bb6ac397dc92113e1555764.camel@mengyan1223.wang>
         <63f5f6b39d22d9833a4c1503a34840eb08050f75.camel@mengyan1223.wang>
         <20210330152300.b790099debcd7659e30d9bfd@danny.cz>
         <92dc0767-0c4e-34bc-d1ee-66105d0f2013@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-30 15:24 +0200, Christian König wrote:
> Am 30.03.21 um 15:23 schrieb Dan Horák:
> > On Tue, 30 Mar 2021 21:09:12 +0800
> > Xi Ruoyao <xry111@mengyan1223.wang> wrote:
> > 
> > > On 2021-03-30 21:02 +0800, Xi Ruoyao wrote:
> > > > On 2021-03-30 14:55 +0200, Christian König wrote:
> > > > > I rather see this as a kernel bug. Can you test if this code fragment
> > > > > fixes your issue:
> > > > > 
> > > > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > > > index 64beb3399604..e1260b517e1b 100644
> > > > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > > > @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void
> > > > > *data, struct drm_file *filp)
> > > > >                   }
> > > > >                   dev_info->virtual_address_alignment =
> > > > > max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
> > > > >                   dev_info->pte_fragment_size = (1 <<
> > > > > adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
> > > > > -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
> > > > > +               dev_info->gart_page_size =
> > > > > dev_info->virtual_address_alignment;
> > > > >                   dev_info->cu_active_number = adev-
> > > > > >gfx.cu_info.number;
> > > > >                   dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
> > > > >                   dev_info->ce_ram_size = adev->gfx.ce_ram_size;
> > > > It works.  I've seen it at
> > > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fxen0n%2Flinux%2Fcommit%2F84ada72983838bd7ce54bc32f5d34ac5b5aae191&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cf37fddf20a8847edf67808d8f37ef23c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637527074118791321%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=DZnmee38NGpiWRMX5LmlxOhxAzBMhAusnAWNnCxXTJ0%3D&amp;reserved=0
> > > > before (with a common sub-expression, though :).
> > > Some comment: on an old version of Fedora ported by Loongson, Xorg just
> > > hangs
> > > without this commit.  But on the system I built from source, I didn't see
> > > any
> > > issue before Linux 5.11.  So I misbelieved that it was something already
> > > fixed.
> > > 
> > > Dan: you can try it on your PPC 64 with non-4K page as well.
> > yup, looks good here as well, ppc64le (Power9) system with 64KB pages
> 
> Mhm, as far as I can say this patch never made it to us.

I think maybe its author considers it a "workaround" like me, as there is
already a "virtual_address_alignment" which seems correct.

> Can you please send it to the mailing list with me on CC?

I've sent it, together with my patch for using ~PAGE_MASK in parameter
validation.

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

