Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98676468ADB
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhLEMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbhLEMtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:49:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D61C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 04:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B453860FC5
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B34FC341C1;
        Sun,  5 Dec 2021 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638708348;
        bh=vSQG77+5Pv0L6JFpCZ7H+vuRVyNLbnLMzEuUFaWje7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=meB/9vYAueMkdTslQ2gtL/+cM1jqjxqGZ3pYRsG2v8uAxExP3eHBzFQs/ZfxNx+rx
         A9eZsx07zY4G35/94LdJz4oQMh9UkCP3vH5QGK1yuP4OAJofz9phrghT5eDB3oTPMg
         2YKS4+xCzu1twX4cXYq1PvkRtLMPtCZqD9EYrV9I=
Date:   Sun, 5 Dec 2021 13:45:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de,
        Yifan Zhang <yifan1.zhang@amd.com>
Subject: Re: [PATCH 5/5] drm/amdkfd: fix boot failure when iommu is disabled
 in Picasso.
Message-ID: <Yay0bh/zdwJyTpar@kroah.com>
References: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
 <1638552452-4198-6-git-send-email-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638552452-4198-6-git-send-email-James.Zhu@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 12:27:32PM -0500, James Zhu wrote:
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
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index 488e574..f262c4e 100644
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
> index 1204dae..b35f0af 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
> @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>  
>  	kfd_cwsr_init(kfd);
>  
> +	if (kgd2kfd_resume_iommu(kfd))
> +		goto device_iommu_error;

No need to "fix up" the coding style here from the original, please
always stick to what is upstream whenever possible :(

thanks,

greg k-h
