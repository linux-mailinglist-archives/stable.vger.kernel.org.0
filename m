Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA986605F28
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 13:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJTLoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 07:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiJTLol (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 07:44:41 -0400
Received: from srv6.fidu.org (srv6.fidu.org [159.69.62.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD37D140D3
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 04:44:25 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 95FF0C80095;
        Thu, 20 Oct 2022 13:44:24 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id oGo-z1GZGyrg; Thu, 20 Oct 2022 13:44:24 +0200 (CEST)
Received: from [192.168.178.52] (host-212-18-30-247.customer.m-online.net [212.18.30.247])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPSA id 47723C80091;
        Thu, 20 Oct 2022 13:44:24 +0200 (CEST)
Message-ID: <e9ff8fc9-10e6-0174-13e2-2e0322f745c1@tuxedocomputers.com>
Date:   Thu, 20 Oct 2022 13:44:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Werner Sembach <wse@tuxedocomputers.com>
Subject: Re: [PATCH v2] ACPI: video: Force backlight native for more TongFang
 devices
To:     stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>
References: <20221019153059.127812-1-wse@tuxedocomputers.com>
Content-Language: en-US
In-Reply-To: <20221019153059.127812-1-wse@tuxedocomputers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding Hans de Goede to the CC

Thanks for offering to review this.

Am 19.10.22 um 17:30 schrieb Werner Sembach:
> The TongFang GKxNRxx, GMxNGxx, GMxZGxx, and GMxRGxx / TUXEDO
> Stellaris/Polaris Gen 1-4, have the same problem as the Clevo NL5xRU and
> NL5xNU / TUXEDO Aura 15 Gen1 and Gen2:
> They have a working native and video interface for screen backlight.
> However the default detection mechanism first registers the video interface
> before unregistering it again and switching to the native interface during
> boot. This results in a dangling SBIOS request for backlight change for
> some reason, causing the backlight to switch to ~2% once per boot on the
> first power cord connect or disconnect event. Setting the native interface
> explicitly circumvents this buggy behaviour by avoiding the unregistering
> process.
>
> The upstream commit "ACPI: video: Make backlight class device registration
> a separate step (v2)" changes the logic in a way that these quirks are not
> required anymore, but kernel <= 6.0 still need these.
>
> Signed-off-by: Werner Sembach<wse@tuxedocomputers.com>
> ---
>   drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 64 insertions(+)
>
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 3b972ca53689..e5518b88f710 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -463,6 +463,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
>   		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
>   		},
>   	},
> +	/*
> +	 * More Tongfang devices with the same issue as the Clevo NL5xRU and
> +	 * NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description above.
> +	 */
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GKxNRxx",
> +	.matches = {
> +		DMI_MATCH(DMI_BOARD_NAME, "GKxNRxx"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GKxNRxx",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
> +		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A1650TI"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GKxNRxx",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
> +		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A2060"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GKxNRxx",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
> +		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A1650TI"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GKxNRxx",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
> +		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A2060"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GMxNGxx",
> +	.matches = {
> +		DMI_MATCH(DMI_BOARD_NAME, "GMxNGxx"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GMxZGxx",
> +	.matches = {
> +		DMI_MATCH(DMI_BOARD_NAME, "GMxZGxx"),
> +		},
> +	},
> +	{
> +	.callback = video_detect_force_native,
> +	.ident = "TongFang GMxRGxx",
> +	.matches = {
> +		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
> +		},
> +	},
>   	/*
>   	 * Desktops which falsely report a backlight and which our heuristics
>   	 * for this do not catch.
