Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC6747038B
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhLJPQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:16:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbhLJPQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 10:16:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5572BB82873
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 15:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F603C00446;
        Fri, 10 Dec 2021 15:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639149178;
        bh=DqDdzjqkLKtvyvR4rfMqqKpW4x2o34pLGXubzeRsLIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1XFLoZWej+9frPmf4TMW4FRX+SphW1J5FEH4fNiSF/y/2TmksUkdi8GIgLGQ17wn8
         JAyVsI4OYV4ZDb6EUkEZyHmsu0cVv9MnICOAyBzN6d66xfBZNfK4AZ9BvxYAucpyba
         QLGrvtVDmlp5mxGytMFyhMpr+dz01UUTsnFWD3ac=
Date:   Fri, 10 Dec 2021 16:12:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Zhu <jamesz@amd.com>
Cc:     James Zhu <James.Zhu@amd.com>, stable@vger.kernel.org,
        jzhums@gmail.com, alexander.deucher@amd.com,
        kolAflash@kolahilft.de, Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>
Subject: Re: [PATCH 6/6] drm/amdkfd: fix boot failure when iommu is disabled
 in Picasso.
Message-ID: <YbNud2OL+Mf6BCaE@kroah.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
 <20211209220956.3466442-7-James.Zhu@amd.com>
 <YbNXFGM4s93myyLu@kroah.com>
 <74391909-3894-457c-6516-7bc8c28e0d58@amd.com>
 <YbNluFUESYFvuWO6@kroah.com>
 <56c017a9-8def-4f1c-5c4e-f4977da0c3d7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56c017a9-8def-4f1c-5c4e-f4977da0c3d7@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 09:46:08AM -0500, James Zhu wrote:
> 
> On 2021-12-10 9:35 a.m., Greg Kroah-Hartman wrote:
> > On Fri, Dec 10, 2021 at 09:14:30AM -0500, James Zhu wrote:
> > > On 2021-12-10 8:33 a.m., Greg Kroah-Hartman wrote:
> > > > On Thu, Dec 09, 2021 at 05:09:56PM -0500, James Zhu wrote:
> > > > > From: Yifan Zhang <yifan1.zhang@amd.com>
> > > > > 
> > > > > commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.
> > > > > 
> > > > > When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
> > > > > init will fail. But this failure should not block amdgpu driver init.
> > > > > 
> > > > > Reported-by: youling <youling257@gmail.com>
> > > > > Tested-by: youling <youling257@gmail.com>
> > > > > Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> > > > > Reviewed-by: James Zhu <James.Zhu@amd.com>
> > > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Signed-off-by: James Zhu <James.Zhu@amd.com>
> > > > > ---
> > > > >    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
> > > > >    drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
> > > > >    2 files changed, 3 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> > > > > index 488e574f5da1..f262c4e7a48a 100644
> > > > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> > > > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> > > > > @@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
> > > > >    		amdgpu_xgmi_add_device(adev);
> > > > >    	amdgpu_amdkfd_device_init(adev);
> > > > > -	r = amdgpu_amdkfd_resume_iommu(adev);
> > > > > -	if (r)
> > > > > -		goto init_failed;
> > > > > -
> > > > >    	amdgpu_fru_get_product_info(adev);
> > > > >    init_failed:
> > > > > diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> > > > > index 1204dae85797..b35f0af71f00 100644
> > > > > --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> > > > > +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> > > > > @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
> > > > >    	kfd_cwsr_init(kfd);
> > > > > +	if (kgd2kfd_resume_iommu(kfd))
> > > > > +		goto device_iommu_error;
> > > > > +
> > > > >    	if (kfd_resume(kfd))
> > > > >    		goto kfd_resume_error;
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > Like I said last time, do not change the backport unless you HAVE to.
> > > > You did it here again for no good reason :(
> > > [JZ] Yes, I should add more explanation next time.
> > > 
> > > Backport conflict fix to remove  svm_migrate_init((struct amdgpu_device
> > > *)kfd->kgd);
> > > 
> > > new AMD svm feature has not been added for 5.10 So it is safe to remove it.
> > No, I am talking about the fact that you fixed up a coding style fix in
> > this backport that is not in the original commit in Linus's tree.
> 
> [JZ] I see. this fix is not necessary. Do you want me to send v2 with
> 
> this unnecessary coding style fix dropping for backport?
> 

I took what was in Linus's tree already.  Please verify that what I
applied to the queue still works.

thanks,

greg k-h
