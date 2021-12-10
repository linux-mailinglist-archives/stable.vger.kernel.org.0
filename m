Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD144701B0
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 14:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbhLJNgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 08:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbhLJNgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 08:36:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C66C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 05:33:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45AE4CE29FC
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 13:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1128C00446;
        Fri, 10 Dec 2021 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639143191;
        bh=cr3BJDrGta8OYAOf48Lvefw4agd7Mg9POkAAsYphC4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1jBdQx+MZDsxIZlEQTWMQ499Lj0jGxbbHIFRIAiEfBpOsYavmiRVpeaZ5h0KfGn2w
         1aJU4qVKPv/WbMUAP+1JA0Kw69+Uw2dyY4dgYh0QhIipRHNXnNvZMq4JWPOt9h1HmG
         49qn0fSlceyuh3/dvSLsSjZhRTwKFyq1+XXCqbEE=
Date:   Fri, 10 Dec 2021 14:33:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de,
        Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>
Subject: Re: [PATCH 6/6] drm/amdkfd: fix boot failure when iommu is disabled
 in Picasso.
Message-ID: <YbNXFGM4s93myyLu@kroah.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
 <20211209220956.3466442-7-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209220956.3466442-7-James.Zhu@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 05:09:56PM -0500, James Zhu wrote:
> From: Yifan Zhang <yifan1.zhang@amd.com>
> 
> commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.
> 
> When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
> init will fail. But this failure should not block amdgpu driver init.
> 
> Reported-by: youling <youling257@gmail.com>
> Tested-by: youling <youling257@gmail.com>
> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> Reviewed-by: James Zhu <James.Zhu@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: James Zhu <James.Zhu@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index 488e574f5da1..f262c4e7a48a 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>  		amdgpu_xgmi_add_device(adev);
>  	amdgpu_amdkfd_device_init(adev);
>  
> -	r = amdgpu_amdkfd_resume_iommu(adev);
> -	if (r)
> -		goto init_failed;
> -
>  	amdgpu_fru_get_product_info(adev);
>  
>  init_failed:
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> index 1204dae85797..b35f0af71f00 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>  
>  	kfd_cwsr_init(kfd);
>  
> +	if (kgd2kfd_resume_iommu(kfd))
> +		goto device_iommu_error;
> +
>  	if (kfd_resume(kfd))
>  		goto kfd_resume_error;
>  
> -- 
> 2.25.1
> 

Like I said last time, do not change the backport unless you HAVE to.
You did it here again for no good reason :(

greg k-h
