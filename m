Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48F22FC18
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 00:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgG0WZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 18:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0WZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 18:25:57 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A60C061794;
        Mon, 27 Jul 2020 15:25:57 -0700 (PDT)
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 828D0556;
        Tue, 28 Jul 2020 00:25:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595888749;
        bh=6sT4s9bubkqih4+AYxlrcHpz/H6v+knBKo4NibbsXSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pTOAEWhTQiSXIhFOzdRiNCRi//rtm/FxuF9bF8wPKDtNOSC/Dw6qaQLT/FSUzpI4N
         DbqSyBCAUwpuUlfDjhLzXtJ+1ntAxcNCIoaDzBZqO3BV6YrT6yZx8+qzUSu7JQREmA
         MBXwLtDzl6r1kfW/g0DP2Qx98OSpG7/LwaTRQNWg=
Date:   Tue, 28 Jul 2020 01:25:41 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having
 any effect
Message-ID: <20200727222541.GC15448@pendragon.ideasonboard.com>
References: <20200724114823.108237-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200724114823.108237-1-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Fri, Jul 24, 2020 at 01:48:23PM +0200, Hans de Goede wrote:
> uvc_ctrl_add_info() calls uvc_ctrl_get_flags() which will override
> the fixed-up flags set by uvc_ctrl_fixup_xu_info().
> 
> This commit fixes this by adding a is_xu argument to uvc_ctrl_add_info()
> and skipping the uvc_ctrl_get_flags() call for xu ctrls.
> 
> Note that the xu path has already called uvc_ctrl_get_flags() from
> uvc_ctrl_fill_xu_info() before calling uvc_ctrl_add_info().
> 
> This fixes the xu motor controls not working properly on a Logitech
> 046d:08cc, and presumably also on the other Logitech models which have
> a quirk for this in the uvc_ctrl_fixup_xu_info() function.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index e399b9fad757..4bdea5814d6a 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1815,7 +1815,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>  }
>  
>  static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
> -	const struct uvc_control_info *info);
> +	const struct uvc_control_info *info, bool is_xu);
>  
>  static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
>  	struct uvc_control *ctrl)
> @@ -1830,7 +1830,7 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = uvc_ctrl_add_info(dev, ctrl, &info);
> +	ret = uvc_ctrl_add_info(dev, ctrl, &info, true);
>  	if (ret < 0)
>  		uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize control "
>  			  "%pUl/%u on device %s entity %u\n", info.entity,
> @@ -2009,7 +2009,7 @@ int uvc_ctrl_restore_values(struct uvc_device *dev)
>   * Add control information to a given control.
>   */
>  static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
> -	const struct uvc_control_info *info)
> +	const struct uvc_control_info *info, bool is_xu)
>  {
>  	int ret = 0;
>  
> @@ -2029,7 +2029,8 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
>  	 * default flag values from the uvc_ctrl array when the device doesn't
>  	 * properly implement GET_INFO on standard controls.
>  	 */
> -	uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
> +	if (!is_xu)
> +		uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);

Would it make sense to instead move this line (and the above comment) to
uvc_ctrl_init_ctrl(), right after the uvc_ctrl_add_info() call ? If you
would prefer keeping it here, I think is_xu should be renamed to
update_flags (with the true/false values switched) to make it clearer.
It would then also add a comment to uvc_ctrl_init_xu_ctrl() right before
the call to uvc_ctrl_add_info() to state that we don't update flags to
avoid overwriting the value set by uvc_ctrl_fixup_xu_info() in
uvc_ctrl_fill_xu_info().

What's your preference ?

>  
>  	ctrl->initialized = 1;
>  
> @@ -2252,7 +2253,7 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
>  	for (; info < iend; ++info) {
>  		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
>  		    ctrl->index == info->index) {
> -			uvc_ctrl_add_info(dev, ctrl, info);
> +			uvc_ctrl_add_info(dev, ctrl, info, false);
>  			break;
>  		 }
>  	}

-- 
Regards,

Laurent Pinchart
