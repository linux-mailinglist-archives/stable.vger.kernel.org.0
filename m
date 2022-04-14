Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89E50086F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiDNIe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbiDNIe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:34:57 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B00363391;
        Thu, 14 Apr 2022 01:32:33 -0700 (PDT)
Received: from [192.168.1.111] (91-156-85-209.elisa-laajakaista.fi [91.156.85.209])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 99A1125B;
        Thu, 14 Apr 2022 10:32:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1649925151;
        bh=f95sAmWwdjHUVI8Avcc4pPnkl/AY78Md6cw7xBbSuOw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vHnKDAOozWKdm9KwKMINztx80dsZqkPD9YUHKngyWssNiBI1T7OkTyynBzZIozuIT
         l4Dn2O+eAWi5OB2z6Bd+IZcRoMfcU8Ab0DQsirXjNwgvIp8JlCGz5a60gr+3jCNSLe
         Fr+VPChZjLnp7FfaxMIiJIyxyvUlmW+d3DM5vJKg=
Message-ID: <b2afddb7-13fc-9ed8-ad0f-fe5a33ee9da0@ideasonboard.com>
Date:   Thu, 14 Apr 2022 11:32:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RESEND][PATCH] omapdrm: fix missing check on list iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, airlied@linux.ie,
        daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220414061410.7678-1-xiam0nd.tong@gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
In-Reply-To: <20220414061410.7678-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 14/04/2022 09:14, Xiaomeng Tong wrote:
> The bug is here:
> 	bus_flags = connector->display_info.bus_flags;
> 
> The list iterator 'connector-' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will lead
> to a invalid memory access.
> 
> To fix this bug, add an check. Use a new value 'iter' as the list
> iterator, while use the old value 'connector' as a dedicated variable
> to point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: ("drm/omap: Add support for drm_panel")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>   drivers/gpu/drm/omapdrm/omap_encoder.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/omapdrm/omap_encoder.c b/drivers/gpu/drm/omapdrm/omap_encoder.c
> index 4dd05bc732da..d648ab4223b1 100644
> --- a/drivers/gpu/drm/omapdrm/omap_encoder.c
> +++ b/drivers/gpu/drm/omapdrm/omap_encoder.c
> @@ -76,14 +76,16 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
>   	struct omap_encoder *omap_encoder = to_omap_encoder(encoder);
>   	struct omap_dss_device *output = omap_encoder->output;
>   	struct drm_device *dev = encoder->dev;
> -	struct drm_connector *connector;
> +	struct drm_connector *connector = NULL, *iter;
>   	struct drm_bridge *bridge;
>   	struct videomode vm = { 0 };
>   	u32 bus_flags;
>   
> -	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> -		if (connector->encoder == encoder)
> +	list_for_each_entry(iter, &dev->mode_config.connector_list, head) {
> +		if (iter->encoder == encoder) {
> +			connector = iter;
>   			break;
> +		}
>   	}

When does this bug happen? How do you get omap_encoder_mode_set() called 
for an encoder with a connector that is not valid?

>   
>   	drm_display_mode_to_videomode(adjusted_mode, &vm);
> @@ -106,8 +108,10 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
>   		omap_encoder_update_videomode_flags(&vm, bus_flags);
>   	}
>   
> -	bus_flags = connector->display_info.bus_flags;
> -	omap_encoder_update_videomode_flags(&vm, bus_flags);
> +	if (connector) {
> +		bus_flags = connector->display_info.bus_flags;
> +		omap_encoder_update_videomode_flags(&vm, bus_flags);
> +	}
>   
>   	/* Set timings for all devices in the display pipeline. */
>   	dss_mgr_set_timings(output, &vm);

How does this fix the issue? You just skip the lines that set up the 
videomode, but then pass that videomode to dss_mgr_set_timings()...

  Tomi
