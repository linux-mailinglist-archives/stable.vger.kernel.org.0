Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E6934E8EA
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhC3NX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhC3NXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 09:23:02 -0400
Received: from redcrew.org (redcrew.org [IPv6:2a02:2b88:2:1::1cde:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AEDC061574;
        Tue, 30 Mar 2021 06:23:02 -0700 (PDT)
Received: from server.danny.cz (19.161.broadband4.iol.cz [85.71.161.19])
        by redcrew.org (Postfix) with ESMTP id D4E3269;
        Tue, 30 Mar 2021 15:23:00 +0200 (CEST)
Received: from talos.danny.cz (talos.danny.cz [192.168.160.68])
        by server.danny.cz (Postfix) with SMTP id 65522DA004;
        Tue, 30 Mar 2021 15:23:00 +0200 (CEST)
Date:   Tue, 30 Mar 2021 15:23:00 +0200
From:   Dan =?UTF-8?B?SG9yw6Fr?= <dan@danny.cz>
To:     Xi Ruoyao <xry111@mengyan1223.wang>
Cc:     Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Christian =?UTF-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
Message-Id: <20210330152300.b790099debcd7659e30d9bfd@danny.cz>
In-Reply-To: <63f5f6b39d22d9833a4c1503a34840eb08050f75.camel@mengyan1223.wang>
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
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; powerpc64le-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Mar 2021 21:09:12 +0800
Xi Ruoyao <xry111@mengyan1223.wang> wrote:

> On 2021-03-30 21:02 +0800, Xi Ruoyao wrote:
> > On 2021-03-30 14:55 +0200, Christian König wrote:
> > > 
> > > I rather see this as a kernel bug. Can you test if this code fragment 
> > > fixes your issue:
> > > 
> > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c 
> > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > index 64beb3399604..e1260b517e1b 100644
> > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
> > > @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void 
> > > *data, struct drm_file *filp)
> > >                  }
> > >                  dev_info->virtual_address_alignment = 
> > > max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
> > >                  dev_info->pte_fragment_size = (1 << 
> > > adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
> > > -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
> > > +               dev_info->gart_page_size = 
> > > dev_info->virtual_address_alignment;
> > >                  dev_info->cu_active_number = adev->gfx.cu_info.number;
> > >                  dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
> > >                  dev_info->ce_ram_size = adev->gfx.ce_ram_size;
> > 
> > It works.  I've seen it at
> > https://github.com/xen0n/linux/commit/84ada72983838bd7ce54bc32f5d34ac5b5aae191
> > before (with a common sub-expression, though :).
> 
> Some comment: on an old version of Fedora ported by Loongson, Xorg just hangs
> without this commit.  But on the system I built from source, I didn't see any
> issue before Linux 5.11.  So I misbelieved that it was something already fixed.
> 
> Dan: you can try it on your PPC 64 with non-4K page as well.

yup, looks good here as well, ppc64le (Power9) system with 64KB pages


		Dan
