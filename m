Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0210D90F89
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfHQIk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 04:40:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43220 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHQIk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 04:40:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id h13so7048603edq.10
        for <stable@vger.kernel.org>; Sat, 17 Aug 2019 01:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qRs++cUPWqE7h71iD/NyfIih5j7NXZt7bjbEdWqVzho=;
        b=Hec0dV1XgpXlg6oiwSYKhqQweW9Ukjj1CPRjp1dnsKxTnjt004k00ay7Ia3P7LoWrm
         OPqCRhwlmxmljIpObztdMpGGgJPE9Ytq24R9XapX/TnqZvegzqPiO/XAdQLYqOm5sG3x
         tZfvmQDl5rjtF8EbhbTD0yiIZG3PfJwdEhkfhIeDics9UAbg0JqZar6b/TfUjG6taGVQ
         0yRtYXs5nbc0XY100GBb7bu4qkr3UQ/tc8CvwVsbDCaVAatOS4KkmpkbOYeb0Gut7gw2
         PoEsEJxEC/dnONYBgAxpO8oHVWrqevW1Pm0EmjwRaYXlbTky/oe1tZyEC6U1FxPp4p+r
         RNvw==
X-Gm-Message-State: APjAAAVYNl77moi7iyBhB0R7wFMilNSTciJBrQBw1d05KYbplLTp8TAl
        RNgDUsXI6Qgiipid2IKNrib8sxVtTTo=
X-Google-Smtp-Source: APXvYqyVeGWshlkAN3hcVFd4OniDjXvWk5lT+Wx1OL/j+MklrUymZoMYlJwTuyfs+e6TUmXM+MwbzQ==
X-Received: by 2002:a50:90c4:: with SMTP id d4mr15291715eda.107.1566031255204;
        Sat, 17 Aug 2019 01:40:55 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id e24sm1136686ejb.53.2019.08.17.01.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2019 01:40:54 -0700 (PDT)
Subject: Re: [PATCH] efifb: BGRT: Improve efifb_bgrt_sanity_check
To:     Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org
References: <20190721131918.10115-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a94c96de-16a5-7b52-a964-f8974e867a65@redhat.com>
Date:   Sat, 17 Aug 2019 10:40:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190721131918.10115-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 21-07-19 15:19, Hans de Goede wrote:
> For various reasons, at least with x86 EFI firmwares, the xoffset and
> yoffset in the BGRT info are not always reliable.
> 
> Extensive testing has shown that when the info is correct, the
> BGRT image is always exactly centered horizontally (the yoffset variable
> is more variable and not always predictable).
> 
> This commit simplifies / improves the bgrt_sanity_check to simply
> check that the BGRT image is exactly centered horizontally and skips
> (re)drawing it when it is not.
> 
> This fixes the BGRT image sometimes being drawn in the wrong place.
> 
> Cc: stable@vger.kernel.org
> Fixes: 88fe4ceb2447 ("efifb: BGRT: Do not copy the boot graphics for non native resolutions")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

ping? I do not see this one in -next yet, what is the status of this
patch?

Regards,

Hans




> ---
>   drivers/video/fbdev/efifb.c | 27 ++++++---------------------
>   1 file changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index dfa8dd47d19d..5b3cef9bf794 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -122,28 +122,13 @@ static void efifb_copy_bmp(u8 *src, u32 *dst, int width, struct screen_info *si)
>    */
>   static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
>   {
> -	static const int default_resolutions[][2] = {
> -		{  800,  600 },
> -		{ 1024,  768 },
> -		{ 1280, 1024 },
> -	};
> -	u32 i, right_margin;
> -
> -	for (i = 0; i < ARRAY_SIZE(default_resolutions); i++) {
> -		if (default_resolutions[i][0] == si->lfb_width &&
> -		    default_resolutions[i][1] == si->lfb_height)
> -			break;
> -	}
> -	/* If not a default resolution used for textmode, this should be fine */
> -	if (i >= ARRAY_SIZE(default_resolutions))
> -		return true;
> -
> -	/* If the right margin is 5 times smaller then the left one, reject */
> -	right_margin = si->lfb_width - (bgrt_tab.image_offset_x + bmp_width);
> -	if (right_margin < (bgrt_tab.image_offset_x / 5))
> -		return false;
> +	/*
> +	 * All x86 firmwares horizontally center the image (the yoffset
> +	 * calculations differ between boards, but xoffset is predictable).
> +	 */
> +	u32 expected_xoffset = (si->lfb_width - bmp_width) / 2;
>   
> -	return true;
> +	return bgrt_tab.image_offset_x == expected_xoffset;
>   }
>   #else
>   static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
> 
