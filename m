Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AB542EB9
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiFHLHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237758AbiFHLHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:07:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6097419B691;
        Wed,  8 Jun 2022 04:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F25B5B826E0;
        Wed,  8 Jun 2022 11:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2DC34116;
        Wed,  8 Jun 2022 11:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654686445;
        bh=Xh9ijLZzb53sng45/ClJFX3kzZcCCZ+7wszfgVVtkFQ=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=J72rdBT0BYrBchDWCvCe3E6RdwXTHZgTxBD6QmpED84s+7ipVk2wqSDTqNOd3NzM5
         LlFbvvUJFXoiww48UasPKo3fvgeNyNSjI7D4qnBR9806k0Lr5vcp9fKGq4FLgX7EJ6
         IvdQJ87C/wey74LoWHHTaib9qFHoxqby45J/1UYZGR8zFRCmu1pQvg0tgnJIMk7VXT
         tDwf1zANupD2AHNuc0j9ZeshlKDbno/ZVooUkdfWegLd21wrfEefx39nV/EfY0xYMl
         duy35yLL5XxwLmI09jLQHir13/D5wRJFJ6850Cc74y/gErEDgi0nZYfLv2n06h1B2l
         SRswhBofSLrfQ==
Date:   Wed, 8 Jun 2022 13:07:22 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Maximilian Luz <luzmaximilian@gmail.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: hid-input: add Surface Go battery quirk
In-Reply-To: <20220525230827.1019662-1-luzmaximilian@gmail.com>
Message-ID: <nycvar.YFH.7.76.2206081307160.10851@cbobk.fhfr.pm>
References: <20220525230827.1019662-1-luzmaximilian@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 May 2022, Maximilian Luz wrote:

> Similar to the Surface Go (1), the (Elantech) touchscreen/digitizer in
> the Surface Go 2 mistakenly reports the battery of the stylus. Instead
> of over the touchscreen device, battery information is provided via
> bluetooth and the touchscreen device reports an empty battery.
> 
> Apply the HID_BATTERY_QUIRK_IGNORE quirk to ignore this battery and
> prevent the erroneous low battery warnings.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> ---
>  drivers/hid/hid-ids.h   | 1 +
>  drivers/hid/hid-input.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index d9eb676abe96..9c4e92a9c646 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -413,6 +413,7 @@
>  #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
>  #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
>  #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
> +#define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
>  
>  #define USB_VENDOR_ID_ELECOM		0x056e
>  #define USB_DEVICE_ID_ELECOM_BM084	0x0061
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index c6b27aab9041..48c1c02c69f4 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -381,6 +381,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
>  	  HID_BATTERY_QUIRK_IGNORE },
>  	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
>  	  HID_BATTERY_QUIRK_IGNORE },
> +	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
> +	  HID_BATTERY_QUIRK_IGNORE },

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

