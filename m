Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FC94447E7
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 19:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhKCSIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 14:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhKCSIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 14:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 370A461156;
        Wed,  3 Nov 2021 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635962772;
        bh=z5FjduUAlGI+nADuCOd2fkCKBVWzT0ED254H9NtgefI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EmYKbp5qO1Hg+URKxQ3othg++7TmXVDXOjukdQMQ/R2Cl8Bxee8E0eE++YG9VBh2g
         u3vFvYiNFsFadan5HdpX3jQUwX7XzyjpSO+CNrB32yVJTA+FmoJIPeV1gm94zh+xTB
         1aqS1Ml/BPl4iCTsW9RAEwohzwZuhwmlV8Mw0xAU=
Date:   Wed, 3 Nov 2021 19:06:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zhang, Yifan" <Yifan1.Zhang@amd.com>,
        youling <youling257@gmail.com>, "Zhu, James" <James.Zhu@amd.com>
Subject: Re: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in
 Picasso.
Message-ID: <YYLPkulC8SNU4fev@kroah.com>
References: <20211103145256.1359520-1-alexander.deucher@amd.com>
 <YYLLKqAxsgg+dCGU@kroah.com>
 <BL1PR12MB514414DC0EDB244757084059F78C9@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB514414DC0EDB244757084059F78C9@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 05:52:37PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, November 3, 2021 1:47 PM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: stable@vger.kernel.org; Zhang, Yifan <Yifan1.Zhang@amd.com>; youling
> > <youling257@gmail.com>; Zhu, James <James.Zhu@amd.com>
> > Subject: Re: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in
> > Picasso.
> > 
> > On Wed, Nov 03, 2021 at 10:52:56AM -0400, Alex Deucher wrote:
> > > From: Yifan Zhang <yifan1.zhang@amd.com>
> > >
> > > When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2 init
> > > will fail. But this failure should not block amdgpu driver init.
> > >
> > > Bug:
> > >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugz
> > >
> > illa.kernel.org%2Fshow_bug.cgi%3Fid%3D214859&amp;data=04%7C01%7Cal
> > exan
> > >
> > der.deucher%40amd.com%7C995f91a70fdd40d87e4908d99ef1ffb9%7C3dd89
> > 61fe48
> > >
> > 84e608e11a82d994e183d%7C0%7C0%7C637715584500181786%7CUnknown%
> > 7CTWFpbGZ
> > >
> > sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M
> > n0%3
> > >
> > D%7C1000&amp;sdata=J9BXIQq57fr%2BfvFHNkrPYps0M7JaFzq4mTh3dMNsk
> > Xw%3D&am
> > > p;reserved=0
> > > Bug:
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitl
> > > ab.freedesktop.org%2Fdrm%2Famd%2F-
> > %2Fissues%2F1770&amp;data=04%7C01%7C
> > >
> > alexander.deucher%40amd.com%7C995f91a70fdd40d87e4908d99ef1ffb9%7
> > C3dd89
> > >
> > 61fe4884e608e11a82d994e183d%7C0%7C0%7C637715584500181786%7CUnkn
> > own%7CT
> > >
> > WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLC
> > JXVCI
> > >
> > 6Mn0%3D%7C1000&amp;sdata=OTO7kY60xizpZ0uHUn56OcZG0OzzUoytRnv
> > QJfFCABg%3
> > > D&amp;reserved=0
> > > Reported-by: youling <youling257@gmail.com>
> > > Tested-by: youling <youling257@gmail.com>
> > > Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> > > Reviewed-by: James Zhu <James.Zhu@amd.com>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (cherry
> > picked
> > > from commit afd18180c07026f94a80ff024acef5f4159084a4)
> > > Cc: stable@vger.kernel.org # 5.14.x
> > > ---
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
> > >  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
> > >  2 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > Now queued up, thanks.
> 
> Thanks.  This should go to 5.15.x as well.  I'm not sure if 5.15.x stable is open yet.

It already got added there as well :)

thanks,

greg k-h
