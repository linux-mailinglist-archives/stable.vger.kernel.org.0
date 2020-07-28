Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36B23134E
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgG1T6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 15:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgG1T6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 15:58:34 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7372C061794;
        Tue, 28 Jul 2020 12:58:34 -0700 (PDT)
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DA27F563;
        Tue, 28 Jul 2020 21:58:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595966307;
        bh=FHmiDJkKSgx1tmB25R46oNgNHZUHsQv24Z/0cU0Tfiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8W7SnIk2LpAmoAbYQOR9vJtCl9S4sSQyhlU2usWPFuYZs1GO1YBC0DfkOCMEXqfN
         XlS9DnxpERw76NtlBE/6gQXwMDNdIIcZ82kEvoqGk1SNRS8o46O8bxrlOqw2motv3L
         QnFcDMyrozdC/8VPLfEgZ3OXjT/ZWF5oEn3ciKW0=
Date:   Tue, 28 Jul 2020 22:58:18 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not
 having any effect
Message-ID: <20200728195818.GO13753@pendragon.ideasonboard.com>
References: <20200728112209.26207-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728112209.26207-1-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Tue, Jul 28, 2020 at 01:22:08PM +0200, Hans de Goede wrote:
> uvc_ctrl_add_info() calls uvc_ctrl_get_flags() which will override
> the fixed-up flags set by uvc_ctrl_fixup_xu_info().
> 
> uvc_ctrl_init_xu_ctrl() already calls uvc_ctrl_get_flags() before
> calling uvc_ctrl_add_info(), so the uvc_ctrl_get_flags() call in
> uvc_ctrl_add_info() is not necessary for xu ctrls.
> 
> This commit moves the uvc_ctrl_get_flags() call for normal controls
> from uvc_ctrl_add_info() to uvc_ctrl_init_ctrl(), so that we no longer
> call uvc_ctrl_get_flags() twice for xu controls and so that we no longer
> override the fixed-up flags set by uvc_ctrl_fixup_xu_info().
> 
> This fixes the xu motor controls not working properly on a Logitech
> 046d:08cc, and presumably also on the other Logitech models which have
> a quirk for this in the uvc_ctrl_fixup_xu_info() function.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Changes in v2:
> - Move the uvc_ctrl_get_flags() call for normal controls to uvc_ctrl_init_ctrl()
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index e399b9fad757..b78aba991212 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -2024,13 +2024,6 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>  		goto done;
>  	}
>  
> -	/*
> -	 * Retrieve control flags from the device. Ignore errors and work with
> -	 * default flag values from the uvc_ctrl array when the device doesn't
> -	 * properly implement GET_INFO on standard controls.
> -	 */
> -	uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
> -
>  	ctrl->initialized = 1;
>  
>  	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
> @@ -2253,6 +2246,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
>  		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
>  		    ctrl->index == info->index) {
>  			uvc_ctrl_add_info(dev, ctrl, info);
> +			/*
> +			 * Retrieve control flags from the device. Ignore errors
> +			 * and work with default flag values from the uvc_ctrl
> +			 * array when the device doesn't properly implement
> +			 * GET_INFO on standard controls.
> +			 */
> +			uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
>  			break;
>  		 }
>  	}

-- 
Regards,

Laurent Pinchart
