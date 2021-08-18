Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94E3F0404
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 14:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhHRMw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhHRMw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 08:52:56 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CABC0613CF
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 05:52:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x10so3338985wrt.8
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xFwQC76YRs1b+balHFsNhYa8Q3dbh5M6tcZISrVr7U=;
        b=rePmvwHcLd56nyH/T/M7cs5REdM49mVsqP0Nifakm9MqxgxnuwBwrmIiqnj9TNl4FB
         tI9bI2Hur/PT61hvT1zIzowJ4VrGJ9z8kBQtaZn8NPhK/UUBn/WoVEXEIlgVanIW6Bw4
         r3sjMrmxR3dNYS/fi1cEuhSQsfwllyk8/oNj2thM0s7ZvvXepaH3fi7zN5sy4c/GFUlj
         yUl3d7QTl4R6lPw9lYFy0Um3JYPqsXz6XQJT7R3zzpyIId3mEHqWSKD7a14bRdqczNSh
         VpsyNUKqiw0tizgqBfkjLo6B0FuH4uNmkepJuYOJ5DEj/ym3V4fivgwVkod0Slx79mjn
         PWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xFwQC76YRs1b+balHFsNhYa8Q3dbh5M6tcZISrVr7U=;
        b=gl5VeS/fN4PGCX1xq3D6ksOFlb8ex8DEjJuuFjSvJyOWcxKLuwclmOKnYTwOv3/pBJ
         VVKrPsLS4iSXdShXTtxzKzOc6EPe7CEHU2Vdvw95iIyvAKEUDPCbFVXearx6C9DctLPD
         trulDMUiyfIuepqx5SZhTNQscR8W7Zm7WGDvhCrGlkk2xfSURtWoIgE55WQKR+E9Z7RU
         oXF8iSYdnQC4lqUmBe2E6meJCkgmnt6UH8S4GTAJ8nrNuiQMxVljLuXoHIHLnaqvVTpf
         +OaC1EPDY8a99X/CzXlwyDlb2QI1YelMnZ6M0kEPV77zUjn+1nMlECCmENFZ6rQ6W54T
         aHnQ==
X-Gm-Message-State: AOAM5305skpbX1igqvqMIA3FDUHG9Eti91ZzKV2WjAy51iSjgh2QwwDE
        IIuAapPzvj6FZfer/w7gAa2h4hpnlXICzfFt
X-Google-Smtp-Source: ABdhPJzXi+j1LU3ChBoLIWvcMhymG795XN+JxI2S0n/UGVkkqGFifbkKKWCBmxQqgtXgJtvOQLc9jA==
X-Received: by 2002:adf:cd8e:: with SMTP id q14mr10466551wrj.410.1629291140549;
        Wed, 18 Aug 2021 05:52:20 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id p5sm6410358wrd.25.2021.08.18.05.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:52:20 -0700 (PDT)
Subject: Re: [PATCH] wcn36xx: Ensure finish scan is not requested before start
 scan
To:     Loic Poulain <loic.poulain@linaro.org>, kvalo@codeaurora.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        Joseph Gates <jgates@squareup.com>, stable@vger.kernel.org
References: <1629286303-13179-1-git-send-email-loic.poulain@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <ea9b0197-ff0c-b6c5-0a95-08875e745748@linaro.org>
Date:   Wed, 18 Aug 2021 13:54:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1629286303-13179-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/08/2021 12:31, Loic Poulain wrote:
> From: Joseph Gates <jgates@squareup.com>
> 
> If the operating channel is the first in the scan list, it was seen that
> a finish scan request would be sent before a start scan request was
> sent, causing the firmware to fail all future scans. Track the current
> channel being scanned to avoid requesting the scan finish before it
> starts.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 5973a2947430 ("wcn36xx: Fix software-driven scan")
> Signed-off-by: Joseph Gates <jgates@squareup.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>   drivers/net/wireless/ath/wcn36xx/main.c    | 5 ++++-
>   drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index dabed4e..e8c772a 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -405,13 +405,14 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
>   		wcn36xx_dbg(WCN36XX_DBG_MAC, "wcn36xx_config channel switch=%d\n",
>   			    ch);
>   
> -		if (wcn->sw_scan_opchannel == ch) {
> +		if (wcn->sw_scan_opchannel == ch && wcn->sw_scan_channel) {
>   			/* If channel is the initial operating channel, we may
>   			 * want to receive/transmit regular data packets, then
>   			 * simply stop the scan session and exit PS mode.
>   			 */
>   			wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
>   						wcn->sw_scan_vif);
> +			wcn->sw_scan_channel = 0;
>   		} else if (wcn->sw_scan) {
>   			/* A scan is ongoing, do not change the operating
>   			 * channel, but start a scan session on the channel.
> @@ -419,6 +420,7 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
>   			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
>   					      wcn->sw_scan_vif);
>   			wcn36xx_smd_start_scan(wcn, ch);
> +			wcn->sw_scan_channel = ch;
>   		} else {
>   			wcn36xx_change_opchannel(wcn, ch);
>   		}
> @@ -699,6 +701,7 @@ static void wcn36xx_sw_scan_start(struct ieee80211_hw *hw,
>   
>   	wcn->sw_scan = true;
>   	wcn->sw_scan_vif = vif;
> +	wcn->sw_scan_channel = 0;
>   	if (vif_priv->sta_assoc)
>   		wcn->sw_scan_opchannel = WCN36XX_HW_CHANNEL(wcn);
>   	else
> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> index 71fa999..d0fcce8 100644
> --- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> @@ -232,6 +232,7 @@ struct wcn36xx {
>   	struct cfg80211_scan_request *scan_req;
>   	bool			sw_scan;
>   	u8			sw_scan_opchannel;
> +	u8			sw_scan_channel;
>   	struct ieee80211_vif	*sw_scan_vif;
>   	struct mutex		scan_lock;
>   	bool			scan_aborted;
> 

LGTM
