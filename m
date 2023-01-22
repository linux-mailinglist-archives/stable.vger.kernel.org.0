Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F49676D27
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjAVN1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVN1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:27:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DE512F14
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:27:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D2B760B41
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF7AC433EF;
        Sun, 22 Jan 2023 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674394064;
        bh=sPw02e20hsT/QUGt1nMfaq//HqIy5Dmgpcq+R7Ak/V4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUlWFMNPWxmiQA7FNckTOqQxfvFdESLI6VsiKYzo7uctFPDFr5vRMuIEQGNCUKtrm
         KppmmGmGNOkcyYJ7Pwj/duSSbsU0bNdQAZu65bn7MKBvpWLIRyaFevCm8QzyXxNRHE
         BFZdNrIImiDyQFayLKMhZdcgxGCp4f35w59dKer4=
Date:   Sun, 22 Jan 2023 14:27:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>
Subject: Re: [PATCH] drm/amdgpu: drop experimental flag on aldebaran
Message-ID: <Y805zgg8RutFowHL@kroah.com>
References: <20230118210446.2661629-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118210446.2661629-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 04:04:46PM -0500, Alex Deucher wrote:
> These have been at production level for a while. Drop
> the flag.
> 
> This should have gone back to 5.15 at the time, but got
> missed, so let's change it now so users don't have to
> specify the module parameter.
> 
> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 3786a9bc0455ca58d953319f62daf96b6eb95490)
> Cc: stable@vger.kernel.org # 5.15.x
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index cabbf02eb054..c946590ce635 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -1936,10 +1936,10 @@ static const struct pci_device_id pciidlist[] = {
>  	{0x1002, 0x73FF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
>  
>  	/* Aldebaran */
> -	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
> -	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
> -	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
> -	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
> +	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
> +	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
> +	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
> +	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
>  
>  	/* CYAN_SKILLFISH */
>  	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
> -- 
> 2.39.0
>


Now queued up, thanks.

greg k-h
