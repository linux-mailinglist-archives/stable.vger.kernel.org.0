Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74B734D69E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhC2SJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:09:17 -0400
Received: from mengyan1223.wang ([89.208.246.23]:52800 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhC2SIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:08:55 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 8E86265B2D;
        Mon, 29 Mar 2021 14:08:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617041334;
        bh=DnbFnwZ0/NuIMzB/7EbnclRu37Hg7RRrTWRMFouAYiY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eud4UHFmqGdkogF/vnhMCKl190X1Lx65bFaTgdfl+MlbTUpeY7mcQy4Vbmpjtc95J
         PMqWWNP7RQ75jB/WpJ3wr3rkXC9baOSQyJPRpYIp20wzuZYlkBZtwHVFr/UkHKLl37
         dnaSp+ZX2lG0dIZeqmglsLk0cEQC9LzZ1f9CfhEh/GQL0/MvG1MxssMrKQpNZWiZUf
         hJJbRSc+mafXGpbfgbeOKZOnQDG0QVHPiOoc6Liu3sf4khCbQ6/gf/876E4QCouvFk
         0ZtsKsl1RlGA0ursq/pLBvT4uoIc2edOlSRAd8iCn5wo2bUCJKZO7codNKxm6NAAiS
         +2HbmYpCJKk9g==
Message-ID: <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
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
Date:   Tue, 30 Mar 2021 02:08:36 +0800
In-Reply-To: <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
         <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-29 20:04 +0200, Christian König wrote:
> Am 29.03.21 um 19:53 schrieb Xℹ Ruoyao:
> > If the initial value of `num_entires` (calculated at line 1654) is not
> > an integral multiple of `AMDGPU_GPU_PAGES_IN_CPU_PAGE`, in line 1681 a
> > value greater than the initial value will be assigned to it.  That causes
> > `start > last + 1` after line 1708.  Then in the next iteration an
> > underflow happens at line 1654.  It causes message
> > 
> >      *ERROR* Couldn't update BO_VA (-12)
> > 
> > printed in kernel log, and GPU hanging.
> > 
> > Fortify the criteria of the loop to fix this issue.
> 
> NAK the value of num_entries must always be a multiple of 
> AMDGPU_GPU_PAGES_IN_CPU_PAGE or otherwise we corrupt the page tables.
> 
> How do you trigger that?

Simply run "OpenGL area" from gtk3-demo (which just renders a triangle with GL)
under Xorg, on MIPS64.  See the BugLink.

> Christian.
> 
> > 
> > BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
> > Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
> > Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > Reported-by: Dan Horák <dan@danny.cz>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > ---
> >   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > index ad91c0c3c423..cee0cc9c8085 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct
> > amdgpu_device *adev,
> >                 }
> >                 start = tmp;
> >   
> > -       } while (unlikely(start != last + 1));
> > +       } while (unlikely(start < last + 1));
> >   
> >         r = vm->update_funcs->commit(&params, fence);
> >   
> > 
> > base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3
> 

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

