Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB0F676D90
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAVORi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjAVORh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:17:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCBAFF0A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 715A7CE0EC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC05C433D2;
        Sun, 22 Jan 2023 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674397052;
        bh=cZCWrP4/kAflcxBBBEcB8+j/+hsrFMOOLqLAhZqdlmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hR9MiJq+jt02KU4IiemQE4Y315ySs+A1l6cuaVMtSVZg7G54tyaskw9YYmmM7vvrf
         FQzGbskNYFETcP1PUYMZodOswjsw7MvB7GuPMAnu3FOHaycR6slgxzuxAEQr6AYpAM
         MZBC9qwOTqLZNADiajfIPpP/AbgTKKUmDMPdmn0c=
Date:   Sun, 22 Jan 2023 15:17:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, kolAflash@kolahilft.de, jrf@mailbox.org,
        mario.limonciello@amd.com
Subject: Re: [PATCH] Revert "drm/amdgpu: make display pinning more flexible
 (v2)"
Message-ID: <Y81FdTg9H0kiN72c@kroah.com>
References: <20230116214411.1091288-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116214411.1091288-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 04:44:11PM -0500, Alex Deucher wrote:
> This reverts commit 78623b10fc9f8231802536538c85527dc54640a0.
> 
> This commit causes hiberation regressions on some platforms
> on kernels older than 6.1.x (6.1.x and newer kernels works
> fine) so let's revert it from 5.15 and older stable kernels.
> This should be reverted from 6.0.x as well, but that kernel
> is no longer supported.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216917
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: kolAflash@kolahilft.de
> Cc: jrf@mailbox.org
> Cc: mario.limonciello@amd.com
> Cc: stable@vger.kernel.org # 5.15.x
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> index b1d0cad00b2e..a0b1bf17cb74 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> @@ -1510,8 +1510,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
>  uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
>  					    uint32_t domain)
>  {
> -	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
> -	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
> +	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
>  		domain = AMDGPU_GEM_DOMAIN_VRAM;
>  		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
>  			domain = AMDGPU_GEM_DOMAIN_GTT;
> -- 
> 2.39.0
> 

Now queued up, thanks.

greg k-h
