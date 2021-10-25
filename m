Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD04397B1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhJYNka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 09:40:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:23351 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbhJYNk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 09:40:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635169082; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=rKwVY6DER5hRBU502tf6xDfqm3iM28Wsco45I5rrP5M=; b=eZsTqT+pfSBNc+5juMwZyGMEzNefjX6KGOgskYhUUtnXiOvZEwXGzMAoNFzYYy7aDsjj1ONP
 Nv66HGUHti7x20maMzwRaeMWIcIHIsQ/gkWGQsEUGMZqUjdcig5Bkpkn1TCZjxAboOQ8zpdL
 gLY6iR48s3NVicTZXF08Mn8mwC8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6176b3395baa84c77b8b570f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 13:38:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F318C43460; Mon, 25 Oct 2021 13:38:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D022FC4338F;
        Mon, 25 Oct 2021 13:37:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D022FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        bryan.odonoghue@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: Channel list update before hardware scan
References: <1634737801-26071-1-git-send-email-loic.poulain@linaro.org>
Date:   Mon, 25 Oct 2021 16:37:56 +0300
In-Reply-To: <1634737801-26071-1-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Wed, 20 Oct 2021 15:50:01 +0200")
Message-ID: <87mtmx9qdn.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

> The channel scan list must be updated before triggering a hardware scan
> so that firmware takes into account the regulatory info for each single
> channel such as active/passive config, power, DFS, etc... Without this
> the firmware uses its own internal default channel configuration, which
> is not aligned with mac80211 regulatory rules, and misses several
> channels (e.g. 144).
>
> Cc: stable@vger.kernel.org
> Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

[...]

> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -928,6 +928,103 @@ int wcn36xx_smd_stop_hw_scan(struct wcn36xx *wcn)
>  	return ret;
>  }
>  
> +static void wcn36xx_channel_set_max_power(struct wcn36xx_hal_channel_param *p, u32 max)
> +{
> +	u32 min = WCN36XX_HAL_DEFAULT_MIN_POWER;
> +
> +	if (min > max)
> +		min = max;
> +
> +	p->reg_info_1 &= 0xffff0000;
> +	p->reg_info_1 |= (min & 0xff) + ((max & 0xff) << 8);
> +}
> +
> +static void wcn36xx_channel_set_reg_power(struct wcn36xx_hal_channel_param *p, u32 power)
> +{
> +	p->reg_info_1 &= 0xff00ffff;
> +	p->reg_info_1 |= (power & 0xff) << 16;
> +}
> +
> +static void wcn36xx_channel_set_class_id(struct wcn36xx_hal_channel_param *p, u32 id)
> +{
> +	p->reg_info_1 &= 0x00ffffff;
> +	p->reg_info_1 |= (id & 0xff) << 24;
> +}

Please use u32_replace_bits() family of functions with proper defines
for bitfields in hal.h. I suspect then you don't then even need these
helper functions and makes the code readable.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
