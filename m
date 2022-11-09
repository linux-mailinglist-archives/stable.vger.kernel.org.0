Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9F9622E35
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiKIOoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiKIOoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:44:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE6B94
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0A861AF5
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 14:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4848FC433C1;
        Wed,  9 Nov 2022 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668005050;
        bh=+gDZO3Is9fM22o4yml2bOxDfA0QF8dm1F91Qj1Qxg28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jw0tW6FFNVsQ5dDUGtxv/1H9jRqK95g8A6F9KUI7fpGGT3+AUZ+GSG8+KHVhKujhl
         lPLl9dYu3BMII6Yie9ww6uhanHVotZ8csSRHKZo25Y48BP7/3bXpjaLc7ALmXFHm7F
         z95IU8/qSb7Dse4O/gFjU/W42/kNoSOLdGuVMseE=
Date:   Wed, 9 Nov 2022 15:44:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: Re:
Message-ID: <Y2u8t4iPX+2Jc24R@kroah.com>
References: <20221109143413.71896-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109143413.71896-1-arefev@swemel.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 05:34:13PM +0300, Denis Arefev wrote:
> Date: Wed, 9 Nov 2022 16:52:17 +0300
> Subject: [PATCH 5.10] nbio_v7_4: Add pointer check
> 
> Return value of a function 'amdgpu_ras_find_obj' is dereferenced at nbio_v7_4.c:325 without checking for null
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
> ---
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> index eadc9526d33f..d2627a610e48 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> @@ -303,6 +303,9 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
>  	struct ras_manager *obj = amdgpu_ras_find_obj(adev, adev->nbio.ras_if);
>  	struct ras_err_data err_data = {0, 0, 0, NULL};
>  	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
> 
> +	if (!obj)
> +		return;
>  
>  	bif_doorbell_intr_cntl = RREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL);
>  	if (REG_GET_FIELD(bif_doorbell_intr_cntl,
> -- 
> 2.25.1
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
