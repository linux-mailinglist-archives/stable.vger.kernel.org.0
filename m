Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00467489C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 10:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388844AbfGYIBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 04:01:13 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49169 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388596AbfGYIBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 04:01:13 -0400
Received: from [192.168.2.10] ([46.9.232.237])
        by smtp-cloud7.xs4all.net with ESMTPA
        id qYgWhCDqBLqASqYgZhS8aI; Thu, 25 Jul 2019 10:01:11 +0200
Subject: Re: [PATCH] media: vivid: fix device init when no_error_inj=1 and fb
 disabled
To:     Guillaume Tucker <guillaume.tucker@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, stable@vger.kernel.org
References: <20190724151922.11124-1-guillaume.tucker@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f17408a7-9fe9-4773-e65e-9b6902b8a3d5@xs4all.nl>
Date:   Thu, 25 Jul 2019 10:01:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190724151922.11124-1-guillaume.tucker@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIuGBWIwoYQBSx957OuHTumsupf8/RkUBa6k2//VgT25QcHRUy9KKLNQnAEFyAqsYySeo/CeJV1fTKDF9LAQ91/W4vDMgy6CCUxQLX10cUCaoxVlnCw1
 XL9Zvohf6BK2OL2ZndTJVkXQ+27OcnjkMUpitbqMVVSEsU+rNkSO25hTeTl5yZbGhsuDh7ARwRx5mN21TmKxN2AzKlLuVHruHEP3jQbv+kl1iNj1Gtx+Chp2
 0d+75JL0qF9w1fd1LdEruznblylq65AP/1jF78RDsqATHKesrz7SZJkn2Sh5P3wgLzJnNSccZlEPIuS2Ii/yP5IDgcOPwafW+F2210sZOMoBj266DJVhH0U6
 KQ09JKb/Gv4U+sm+iDUu+hdmjdv2cnleTwKQwWyNT8XTWbskpRg=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 5:19 PM, Guillaume Tucker wrote:
> Add an extra condition to add the video output control class when the
> device has some hdmi outputs defined.  This is required to then always
> be able to add the display present control, which is enabled when
> there are some hdmi outputs.
> 
> This fixes the corner case where no_error_inj is enabled and the
> device has no frame buffer but some hdmi outputs, as otherwise the
> video output control class would be added anyway.  Without this fix,
> the sanity checks fail in v4l2_ctrl_new() as name is NULL.

Good catch.

Note that you can just drop the no_error_inj module option: v4l2-compliance
will detect the vivid driver and skip the error controls while testing.

I stopped using no_error_inj since I made that v4l2-compliance change.

Regards,

	Hans

> 
> Fixes: c533435ffb91 ("media: vivid: add display present control")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
> ---
>  drivers/media/platform/vivid/vivid-ctrls.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
> index 3e916c8befb7..7a52f585cab7 100644
> --- a/drivers/media/platform/vivid/vivid-ctrls.c
> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
> @@ -1473,7 +1473,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
>  	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
>  	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
>  	v4l2_ctrl_handler_init(hdl_vid_out, 26);
> -	if (!no_error_inj || dev->has_fb)
> +	if (!no_error_inj || dev->has_fb || dev->num_hdmi_outputs)
>  		v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
>  	v4l2_ctrl_handler_init(hdl_vbi_cap, 21);
>  	v4l2_ctrl_new_custom(hdl_vbi_cap, &vivid_ctrl_class, NULL);
> 

