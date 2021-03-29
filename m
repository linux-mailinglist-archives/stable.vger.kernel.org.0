Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29C34D6E7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhC2SWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:22:13 -0400
Received: from mengyan1223.wang ([89.208.246.23]:53502 "EHLO mengyan1223.wang"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhC2SWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 14:22:07 -0400
Received: from [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e] (unknown [IPv6:240e:35a:1037:8a00:70b2:e35d:833c:af3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
        (Client did not present a certificate)
        (Authenticated sender: xry111@mengyan1223.wang)
        by mengyan1223.wang (Postfix) with ESMTPSA id 5A69D65B2D;
        Mon, 29 Mar 2021 14:21:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mengyan1223.wang;
        s=mail; t=1617042124;
        bh=YHCTLOQji1TU6PObSe0lzPj8T+Fg3PTAYM1EeyxrTnQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kScrJxKtrzkjmZaqBTvC/q0aDm55v4zy0NZzfmG1WADUs+/bOimqcylR6UIgZT6SS
         EanGcnOGHOVoE/bcwylAs+rVAUNfdVW1cYCIGQ9vtGj71+VktU83WHF25EicmM1e8G
         7L9YszFJY7ltQ3BJrox9JozuLhrRzg1u5esLN5q6fKWbE57ClR9jwhbZ0eBEVrjHCh
         2/AA5SlkSqjTx1VMFYdYN2hNc75l1rAfwtNY8/9t6xbL3LkpcMgcHv3Di4RLnf6DpO
         eyHR5K/btD0GZXcMaMzxGvaNScXHXcmTQWNfdUhTOUI4JJXSxSoHLIb5W8Q2ljbuI0
         w1zbYPYaij3uw==
Message-ID: <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
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
Date:   Tue, 30 Mar 2021 02:21:48 +0800
In-Reply-To: <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
         <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
         <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
         <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-29 20:10 +0200, Christian König wrote:
> You need to identify the root cause of this, most likely start or last 
> are not a multiple of AMDGPU_GPU_PAGES_IN_CPU_PAGE.

I printk'ed the value of start & last, they are all a multiple of 4
(AMDGPU_GPU_PAGES_IN_CPU_PAGE).

However... `num_entries = last - start + 1` so it became some irrational
thing...  Either this line is wrong, or someone called
amdgpu_vm_bo_update_mapping with [start, last) instead of [start, last], which
is unexpected.

> > > > BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
> > > > Fixes: a39f2a8d7066 ("drm/amdgpu: nuke amdgpu_vm_bo_split_mapping v2")
> > > > Reported-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > > > Reported-by: Dan Horák <dan@danny.cz>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
> > > > ---
> > > >    drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > index ad91c0c3c423..cee0cc9c8085 100644
> > > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> > > > @@ -1707,7 +1707,7 @@ static int amdgpu_vm_bo_update_mapping(struct
> > > > amdgpu_device *adev,
> > > >                  }
> > > >                  start = tmp;
> > > >    
> > > > -       } while (unlikely(start != last + 1));
> > > > +       } while (unlikely(start < last + 1));
> > > >    
> > > >          r = vm->update_funcs->commit(&params, fence);
> > > >    
> > > > 
> > > > base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3
> 

-- 
Xi Ruoyao <xry111@mengyan1223.wang>
School of Aerospace Science and Technology, Xidian University

