Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7CA552DEB
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348614AbiFUJG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348583AbiFUJGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E31719F97;
        Tue, 21 Jun 2022 02:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A185061572;
        Tue, 21 Jun 2022 09:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FECFC341C4;
        Tue, 21 Jun 2022 09:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655802414;
        bh=N3p+7KlMfefdfn/ZBHvMoWcodfs7abt2FrfWbGO/KsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AUYhA0zhMP1sbp1Fo5+zjviMRMEknLfVukO7ghaNxa82h23l6lmM9/mngfqqtGpFi
         jTwkXfKIjKb0La+IhkkgQbVwjYMx/xe6oVp/qT4a9lMWlZhc9eus3TA0IVryDCWYCp
         I6OVCTnH3zkG4HZhah+VSJgLb+6MnWLYEICKxPcg=
Date:   Tue, 21 Jun 2022 11:06:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        charles-yeh@prolific.com.tw, Charles Yeh <charlesyeh522@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: pl2303: add support for more HXN (G) types
Message-ID: <YrGKK7Ua20Boz1oZ@kroah.com>
References: <20220621085855.6252-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621085855.6252-1-johan@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 10:58:55AM +0200, Johan Hovold wrote:
> Add support for further HXN (G) type devices (GT variant, GL variant, GS
> variant and GR) and document the bcdDevice mapping.
> 
> Note that the TA and TB types use the same bcdDevice as some GT and GE
> variants, respectively, but that the HX status request can be used to
> determine which is which.
> 
> Also note that we currently do not distinguish between the various HXN
> (G) types in the driver but that this may change eventually (e.g. when
> adding GPIO support).
> 
> Reported-by: Charles Yeh <charlesyeh522@gmail.com>
> Link: https://lore.kernel.org/r/YrF77b9DdeumUAee@hovoldconsulting.com
> Cc: stable@vger.kernel.org	# 5.13
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/pl2303.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index 3506c47e1eef..40b1ab3d284d 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -436,22 +436,27 @@ static int pl2303_detect_type(struct usb_serial *serial)
>  		break;
>  	case 0x200:
>  		switch (bcdDevice) {
> -		case 0x100:
> +		case 0x100:	/* GC */
>  		case 0x105:
> +			return TYPE_HXN;
> +		case 0x300:	/* GT / TA */
> +			if (pl2303_supports_hx_status(serial))
> +				return TYPE_TA;
> +			fallthrough;
>  		case 0x305:
> +		case 0x400:	/* GL */
>  		case 0x405:
> +			return TYPE_HXN;
> +		case 0x500:	/* GE / TB */
> +			if (pl2303_supports_hx_status(serial))
> +				return TYPE_TB;
> +			fallthrough;
> +		case 0x505:
> +		case 0x600:	/* GS */
>  		case 0x605:
> -			/*
> -			 * Assume it's an HXN-type if the device doesn't
> -			 * support the old read request value.
> -			 */
> -			if (!pl2303_supports_hx_status(serial))
> -				return TYPE_HXN;
> -			break;
> -		case 0x300:
> -			return TYPE_TA;
> -		case 0x500:
> -			return TYPE_TB;
> +		case 0x700:	/* GR */
> +		case 0x705:
> +			return TYPE_HXN;
>  		}
>  		break;
>  	}
> -- 
> 2.35.1
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
