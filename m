Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBBE5F9A36
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiJJHm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiJJHlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D782B4
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 00:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665387417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5D/0ptM0mq2jELn0o53/s/8oJ9fCmptsdKH7DRxNtGw=;
        b=gr7AvGINJ8ma47Vxal34SRVUTUkbG8VMiaQYmDdFs7bJv4dAN6naEdWs4pMGC6Lr7L57Kp
        axiFDCoqGIXJoSyjfJXDXQXAvTnX0rT9GLKdfiZIyyEBVdOSlcHNMtXEzECeKucNhTYwVM
        sqYVcNgFiMR521OY9WuavpwhayVzBq0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-62-IMXWlkCIMP6znrzJXtCk3A-1; Mon, 10 Oct 2022 03:36:56 -0400
X-MC-Unique: IMXWlkCIMP6znrzJXtCk3A-1
Received: by mail-ej1-f70.google.com with SMTP id sb13-20020a1709076d8d00b0078d8e1f6f7aso1291472ejc.8
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 00:36:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5D/0ptM0mq2jELn0o53/s/8oJ9fCmptsdKH7DRxNtGw=;
        b=A6zsxpX2uvdr9crejnws/Tvo2uufLJvIsCygQl4wk7j1HDGjx3O4FwzsTEGHvn8Uoq
         x08UqU1CTNOBku11o913wOR1zd1zoiK9PQmelXPYgtoBcU5yfGQiRBaru8w5Z5lXL5ZQ
         DgtXgEAsKMljK4Rw99WF5ig3geE+5p03W2O5F8GeSvoLXVb7YMuCNlK1BIEZ6evWdeqh
         pPOQh4Ct8+cE/lHQt3RPY7fKQ9RZrcSB6LPhiI5LcotP270T1igJYl+U/DBMtoKD7EBb
         jilWCrDeFBpNo+3kNT9tS4uMDrzwEx5nxteIGp/v4kUcmr0vMO/manV7YleQW0qQcuWs
         LwHQ==
X-Gm-Message-State: ACrzQf2BYbOY1xFT2wCGKB2qXRmdo/42yt5VWHLkNs8lDqcmktq2oXmE
        PqDfqjznw4qUcychGlNLC8Bj0awAEndW2DkvxaO6MoGOSnQziUgTE7eP+eaVGr3CDHafMUlLtLA
        b6NQgLaYjYSq17rvx
X-Received: by 2002:a17:907:3c81:b0:77a:327a:815f with SMTP id gl1-20020a1709073c8100b0077a327a815fmr14001774ejc.422.1665387415419;
        Mon, 10 Oct 2022 00:36:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM47SQMv715Io/bXc/MJd2HwmzP721cBGNQJX/6D8+uHuA4m5H0tqEjtqWwJNCq/W7N2o0qvyw==
X-Received: by 2002:a17:907:3c81:b0:77a:327a:815f with SMTP id gl1-20020a1709073c8100b0077a327a815fmr14001762ejc.422.1665387415205;
        Mon, 10 Oct 2022 00:36:55 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id z25-20020aa7cf99000000b0044e9601e53fsm6569108edx.19.2022.10.10.00.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 00:36:54 -0700 (PDT)
Message-ID: <f634ad7f-92f0-ee22-8a9a-51e1852f6826@redhat.com>
Date:   Mon, 10 Oct 2022 09:36:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH AUTOSEL 4.19 06/10] ACPI: video: Change
 disable_backlight_sysfs_if quirks to acpi_backlight=native
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Arvid Norlander <lkml@vorpal.se>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
References: <20221009235746.1232129-1-sashal@kernel.org>
 <20221009235746.1232129-6-sashal@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221009235746.1232129-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/10/22 01:57, Sasha Levin wrote:
> From: Hans de Goede <hdegoede@redhat.com>
> 
> [ Upstream commit c5b94f5b7819348c59f9949b2b75c341a114cdd4 ]
> 
> Some Toshibas have a broken acpi-video interface for brightness control
> and need a special firmware call on resume to turn the panel back on.
> So far these have been using the disable_backlight_sysfs_if workaround
> to deal with this.
> 
> The recent x86/acpi backlight refactoring has broken this workaround:
> 1. This workaround relies on acpi_video_get_backlight_type() returning
>    acpi_video so that the acpi_video code actually runs; and
> 2. this relies on the actual native GPU driver to offer the sysfs
>    backlight interface to userspace.
> 
> After the refactor this breaks since the native driver will no
> longer register its backlight-device if acpi_video_get_backlight_type()
> does not return native and making it return native breaks 1.
> 
> Keeping the acpi_video backlight handling on resume active, while not
> using it to set the brightness, is necessary because it does a _BCM
> call on resume which is necessary to turn the panel back on on resume.
> 
> Looking at the DSDT shows that this _BCM call results in a Toshiba
> HCI_SET HCI_LCD_BRIGHTNESS call, which turns the panel back on.
> 
> This kind of special vendor specific handling really belongs in
> the vendor specific acpi driver. An earlier patch in this series
> modifies toshiba_acpi to make the necessary HCI_SET call on resume
> on affected models.
> 
> With toshiba_acpi taking care of the HCI_SET call on resume,
> the acpi_video code no longer needs to call _BCM on resume.
> 
> So instead of using the (now broken) disable_backlight_sysfs_if
> workaround, simply setting acpi_backlight=native to disable
> the broken apci-video interface is sufficient fix things now.
> 
> After this there are no more users of the disable_backlight_sysfs_if
> flag and as discussed above the flag also no longer works as intended,
> so remove the disable_backlight_sysfs_if flag entirely.
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Arvid Norlander <lkml@vorpal.se>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch goes hand in hand with:

commit 3cb1f40dfdc3 ("drivers/platform: toshiba_acpi: Call HCI_PANEL_POWER_ON on resume on some models")

and without that commit also being present it will cause a regression on
the quirked Toshiba models.

This really is part of the big x86/ACPI backlight handling refactor which 
has landed in 6.1 and as such is not intended for older kernels, please
drop this from the stable series.

Regards,

Hans



> ---
>  drivers/acpi/acpi_video.c   | 48 -------------------------------------
>  drivers/acpi/video_detect.c | 35 +++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
> index ac54fc03cf81..51a9937e6e3e 100644
> --- a/drivers/acpi/acpi_video.c
> +++ b/drivers/acpi/acpi_video.c
> @@ -63,9 +63,6 @@ module_param(brightness_switch_enabled, bool, 0644);
>  static bool allow_duplicates;
>  module_param(allow_duplicates, bool, 0644);
>  
> -static int disable_backlight_sysfs_if = -1;
> -module_param(disable_backlight_sysfs_if, int, 0444);
> -
>  #define REPORT_OUTPUT_KEY_EVENTS		0x01
>  #define REPORT_BRIGHTNESS_KEY_EVENTS		0x02
>  static int report_key_events = -1;
> @@ -397,14 +394,6 @@ static int video_set_bqc_offset(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> -static int video_disable_backlight_sysfs_if(
> -	const struct dmi_system_id *d)
> -{
> -	if (disable_backlight_sysfs_if == -1)
> -		disable_backlight_sysfs_if = 1;
> -	return 0;
> -}
> -
>  static int video_set_device_id_scheme(const struct dmi_system_id *d)
>  {
>  	device_id_scheme = true;
> @@ -477,40 +466,6 @@ static const struct dmi_system_id video_dmi_table[] = {
>  		},
>  	},
>  
> -	/*
> -	 * Some machines have a broken acpi-video interface for brightness
> -	 * control, but still need an acpi_video_device_lcd_set_level() call
> -	 * on resume to turn the backlight power on.  We Enable backlight
> -	 * control on these systems, but do not register a backlight sysfs
> -	 * as brightness control does not work.
> -	 */
> -	{
> -	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
> -	 .callback = video_disable_backlight_sysfs_if,
> -	 .ident = "Toshiba Portege R700",
> -	 .matches = {
> -		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> -		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R700"),
> -		},
> -	},
> -	{
> -	 /* https://bugs.freedesktop.org/show_bug.cgi?id=82634 */
> -	 .callback = video_disable_backlight_sysfs_if,
> -	 .ident = "Toshiba Portege R830",
> -	 .matches = {
> -		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> -		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R830"),
> -		},
> -	},
> -	{
> -	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
> -	 .callback = video_disable_backlight_sysfs_if,
> -	 .ident = "Toshiba Satellite R830",
> -	 .matches = {
> -		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> -		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE R830"),
> -		},
> -	},
>  	/*
>  	 * Some machine's _DOD IDs don't have bit 31(Device ID Scheme) set
>  	 * but the IDs actually follow the Device ID Scheme.
> @@ -1773,9 +1728,6 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
>  	if (result)
>  		return;
>  
> -	if (disable_backlight_sysfs_if > 0)
> -		return;
> -
>  	name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
>  	if (!name)
>  		return;
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 490ae990bd3c..62975cfcce68 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -447,6 +447,41 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
>  		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
>  		},
>  	},
> +	/*
> +	 * These Toshibas have a broken acpi-video interface for brightness
> +	 * control. They also have an issue where the panel is off after
> +	 * suspend until a special firmware call is made to turn it back
> +	 * on. This is handled by the toshiba_acpi kernel module, so that
> +	 * module must be enabled for these models to work correctly.
> +	 */
> +	{
> +	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
> +	 .callback = video_detect_force_native,
> +	 /* Toshiba Portégé R700 */
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R700"),
> +		},
> +	},
> +	{
> +	 /* Portégé: https://bugs.freedesktop.org/show_bug.cgi?id=82634 */
> +	 /* Satellite: https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
> +	 .callback = video_detect_force_native,
> +	 /* Toshiba Satellite/Portégé R830 */
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "R830"),
> +		},
> +	},
> +	{
> +	 .callback = video_detect_force_native,
> +	 /* Toshiba Satellite/Portégé Z830 */
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "Z830"),
> +		},
> +	},
> +
>  	/*
>  	 * Desktops which falsely report a backlight and which our heuristics
>  	 * for this do not catch.

