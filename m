Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28B95B232C
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 18:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIHQL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIHQLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 12:11:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7E780EB1
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 09:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FA661D25
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 16:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9984C433C1;
        Thu,  8 Sep 2022 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662653514;
        bh=ZGk6m4YBuf8eQneghKB/+vkHusHQRXsOGI7Eu8j29+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cz9yrcRZEzlvudBA15idgHDBcdAhyBT7d9KuNo9Y5wyHgGI3abt1GBrDrLPbfgX9+
         3A+VWZQltPeChCmbdiKNNL4e7VddC8Z9/ED7yKQ/ItwjERh5VjaXWVE/JxgkYlsCJx
         /h3gl9DafdJLpbuza94QuM3PpsSlDseQDHzQPAErj1vXyj77Aelm7/vE9+cVIhgufY
         VJ89ULAJuU+mFpjTopbQzcF+SXdyrDE0Qt/Kx25IM+BHsoIDZEBWdzlOfzJu1dAtM8
         py/s7NP+cr2n6+LxPz3+OYJgiujexs+EskyKTsRwce6aYR4WTZP9Dzw7QF13+9G2me
         3neHIobC4A79A==
Date:   Thu, 8 Sep 2022 11:11:52 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lijo Lazar <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        wielkiegie@gmail.com, stable@vger.kernel.org,
        Hawking.Zhang@amd.com, Evan Quan <evan.quan@amd.com>
Subject: Re: [PATCH] drm/amdgpu: Don't enable LTR if not supported
Message-ID: <20220908161152.GA200598@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908032344.1682187-1-lijo.lazar@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Evan, author of 62f8f5c3bfc2 ("drm/amdgpu: enable ASPM support
for PCIE 7.4.0/7.6.0")]

On Thu, Sep 08, 2022 at 08:53:44AM +0530, Lijo Lazar wrote:
> As per PCIE Base Spec r4.0 Section 6.18
> 'Software must not enable LTR in an Endpoint unless the Root Complex
> and all intermediate Switches indicate support for LTR.'
> 
> This fixes the Unsupported Request error reported through AER during
> ASPM enablement.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216455
> 
> The error was unnoticed before and got visible because of the commit
> referenced below. This doesn't fix anything in the commit below, rather
> fixes the issue in amdgpu exposed by the commit. The reference is only
> to associate this commit with below one so that both go together.
> 
> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
> 
> Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 9 ++++++++-
>  drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 9 ++++++++-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 9 ++++++++-

nbio_v4_3_program_ltr() checks pdev->ltr_path itself instead of doing
it in *_program_aspm().  It'd be nice to use the same approach for all
versions.

I really don't like the fact that amdgpu does all this ASPM fiddling
in the driver in the first place.  ASPM should be configured by the
PCI core, not by each individual driver.  ASPM has all sorts of
requirements that relate to upstream devices, which I think amdgpu
ignores, but the core pays attention to.

Do you know why the driver configures ASPM itself?  If the PCI core is
doing something wrong (and I'm sure it is, ASPM support is kind of a
mess), I'd much prefer to fix up the core where *all* drivers can
benefit from it.

> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> index b465baa26762..aa761ff3a5fa 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> @@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
>  		WREG32_PCIE(smnPCIE_LC_CNTL, data);
>  }
>  
> +#ifdef CONFIG_PCIEASPM
>  static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>  {
>  	uint32_t def, data;
> @@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>  	if (def != data)
>  		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>  }
> +#endif
>  
>  static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>  {
> +#ifdef CONFIG_PCIEASPM
>  	uint32_t def, data;
>  
>  	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
> @@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>  	if (def != data)
>  		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>  
> -	nbio_v2_3_program_ltr(adev);
> +	/* Don't bother about LTR if LTR is not enabled
> +	 * in the path */
> +	if (adev->pdev->ltr_path)
> +		nbio_v2_3_program_ltr(adev);
>  
>  	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
>  	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
> @@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>  	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>  	if (def != data)
>  		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> +#endif
>  }
