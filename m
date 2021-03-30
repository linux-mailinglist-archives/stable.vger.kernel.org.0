Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30A434E883
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhC3NKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:10:02 -0400
Received: from mengyan1223.wang ([89.208.246.23]:60066 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhC3NJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:09:36 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 5D1C765C14;
        Tue, 30 Mar 2021 09:09:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617109776;
        bh=3iP3rLSkq+VHRv9oXI55n1v+WgpcbUG9Pj6ypqndVyM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jlPQQcKuSJNeAKBfBqLWKzTAZ6N3flgBhFW3Ivu2XobvF0fkmyiHwYvb0HYY7nIZS
         EBh7I34Aisb+H8iNJUk3xZs/BiLYHW++v/XmWX/jf4Cbx4JrIWmZjQl0MjILUeF/1K
         xQdpbmBBBpAD+PN9Hay0/EduuiMHirfHM5ih+7WqO+HWmI17Md3WelMnUP8QFlI1hb
         +gyjmh3U67Y5rwG1qJaBq/SfFhaaFz+ITR1uTpf6zaGyb7Elk0WXQdpSyHX6S/qiv6
         87TdrlOY3uqwScMSVkaLwGfXUsy0fESYLEcLKt+Af+m4bbWtgROcHaKY5ESNYCHmmG
         lTlQjar0XhL5w==
Message-ID: <63f5f6b39d22d9833a4c1503a34840eb08050f75.camel@mengyan1223.wang>
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
Date:   Tue, 30 Mar 2021 21:09:12 +0800
In-Reply-To: <f3fb57055f0bd3f19bb6ac397dc92113e1555764.camel@mengyan1223.wang>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-30 21:02 +0800, Xi Ruoyao wrote:
> On 2021-03-30 14:55 +0200, Christian König wrote:
> > 
> > I rather see this as a kernel bug. Can you test if this code fragment 
> > fixes your issue:
> > 
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c 
> > b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > index 64beb3399604..e1260b517e1b 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void 
> > *data, struct drm_file *filp)
> >                  }
> >                  dev_info->virtual_address_alignment = 
> > max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
> >                  dev_info->pte_fragment_size = (1 << 
> > adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
> > -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
> > +               dev_info->gart_page_size = 
> > dev_info->virtual_address_alignment;
> >                  dev_info->cu_active_number = adev->gfx.cu_info.number;
> >                  dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
> >                  dev_info->ce_ram_size = adev->gfx.ce_ram_size;
> 
> It works.  I've seen it at
> https://github.com/xen0n/linux/commit/84ada72983838bd7ce54bc32f5d34ac5b5aae191
> before (with a common sub-expression, though :).

Some comment: on an old version of Fedora ported by Loongson, Xorg just hangs
without this commit.  But on the system I built from source, I didn't see any
issue before Linux 5.11.  So I misbelieved that it was something already fixed.

Dan: you can try it on your PPC 64 with non-4K page as well.
-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

