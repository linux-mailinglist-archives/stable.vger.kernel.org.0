Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77773CAF
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405083AbfGXT63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:58:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40837 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404944AbfGXT6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 15:58:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so21746768pgj.7;
        Wed, 24 Jul 2019 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kGXUJmflPwZDNqZjPGTg/V3j3vLBzx4voLRvsXsS5x0=;
        b=aD8DzIJr9crHzm0gBBO4cTdLB4JaczjMgE7+gZxVXuGETisB5/Coe/4fDBu6CPDDe5
         XoBvL/KZGrpqntiZ+kYWIh6OsYxQ8dKcRHRiCEfLwNWeohPX0eWh/OmPBT9iJW9OjTDv
         p/f/g24wKaYQU7CP6+cx8L1cpjK3yaypyoUX7TzqqdkgahmLctioNhQ4y2WmbzzycJIb
         Qp371SC/pNl4nosEc3lAytYs/sdVzjpIPXnFY1ghyLle5415/zDIYALelW3tn53SIXEt
         6DGiFNpJxtrWQ0kDcN9565KswsNxhccwABD4bjnWkoIvo9MlfdU0iZWNHLTkWB3ZOxAw
         bE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kGXUJmflPwZDNqZjPGTg/V3j3vLBzx4voLRvsXsS5x0=;
        b=uKMcekcsumt6Bej9FEEn1FI+CvhdT+5w2RCe3nhE4FR7gFw392rUuuZ5yBue3txzi0
         uNET2BfM0W7tirOXlk19P7QmGlNpBMMqQMFwxBqxs972NpWcYvn/+6SpRl2Z+kob+X4R
         leydJ0K06AWDFG2rTSR19YfGolx+dKy9sVDYRFh+CHBVpN/OStI4k41hYb1tE3JnNkgm
         8Ev05AHHBcx/CPO+dYdydrdk7Y/Ehg1/52rwMxZZwg19YZ/lyIIXNKz/CcdEAy5osLOz
         NYA7vRW3V8Sfb8Ps0TGU5Ba9LfYFiQ1YXN6qOHce6yEDikxloRgA8rFkkit5J3Qe/UZs
         ZZUw==
X-Gm-Message-State: APjAAAXyjHy6xuOr4i0XltTA2KN8gBntDFzUrVbF15xFxrbPiQYUnepB
        l2Hl1eS2rAwT2w4rQYoFQwoqKJ5D
X-Google-Smtp-Source: APXvYqzn7cT7zcsP8mgCbwroZ91teSNZ4cC4OJqPgYJN31TDgaNhbAOo22JdnPmzjE3E17x+IJT+hg==
X-Received: by 2002:a62:f20b:: with SMTP id m11mr13043335pfh.125.1563998303220;
        Wed, 24 Jul 2019 12:58:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b6sm41772738pgq.26.2019.07.24.12.58.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 12:58:22 -0700 (PDT)
Subject: Re: [PATCH 5.3] mwifiex: fix 802.11n/WPA detection
To:     Brian Norris <briannorris@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, stable@vger.kernel.org
References: <20190724194634.205718-1-briannorris@chromium.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <6c6b1d11-f13c-0dde-74ac-93a9e51c4deb@roeck-us.net>
Date:   Wed, 24 Jul 2019 12:58:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724194634.205718-1-briannorris@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 12:46 PM, Brian Norris wrote:
> Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
> vendor IEs") adjusted the ieee_types_vendor_header struct, which
> inadvertently messed up the offsets used in
> mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
> mwifiex_is_rsn_oui_present().
> 
> As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
> WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
> not supported by AP" case in mwifiex_is_network_compatible().
> 
> Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/net/wireless/marvell/mwifiex/main.h | 1 +
>   drivers/net/wireless/marvell/mwifiex/scan.c | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 3e442c7f7882..095837fba300 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -124,6 +124,7 @@ enum {
>   
>   #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
>   
> +#define WPA_GTK_OUI_OFFSET				2
>   #define RSN_GTK_OUI_OFFSET				2
>   
>   #define MWIFIEX_OUI_NOT_PRESENT			0
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 0d6d41727037..21dda385f6c6 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -181,7 +181,8 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
>   	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
>   
>   	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
> -		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
> +		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
> +					    WPA_GTK_OUI_OFFSET);
>   		oui = &mwifiex_wpa_oui[cipher][0];
>   		ret = mwifiex_search_oui_in_ie(iebody, oui);
>   		if (ret)
> 

