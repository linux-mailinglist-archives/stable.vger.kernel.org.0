Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C106BF76E
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfIZRRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 13:17:33 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39160 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZRRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 13:17:33 -0400
Received: by mail-oi1-f195.google.com with SMTP id w144so2779019oia.6;
        Thu, 26 Sep 2019 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6iIyaUzF9v02p9F3h71C8x4tDacLmA6BNo4c1Ew2pJs=;
        b=dZKovGgbdsd2S4YW1nmKU9AKCVrY3PrOkZC0M14UJMIpQ+qRDzwZPmVIIFqq0Xk+eR
         4A95WaKJNw7EkpSPAYO/chkQFTbxnnTdC/9OHpPyt6nLSLZizpfd3UUROSkisuLJh6ij
         hrJIkannXvZfTi9lJ2zi+c1d0WRsgEKhxPMxV7gcTOf/ZVatEEO1rPohku5TLrJWADSy
         WZPR2APPq6hmVliPnTZ2jpXV/sR/u3+4Aw9uH0yzz44tvF5vCdCszeaP22atjbBH20tz
         lSQQsQIDzDR592IF0apV8xXcxtRp6DmoBq0YXt0BmRzR5n5QI+f3DMQ9C5XLmGqVyHKc
         17mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6iIyaUzF9v02p9F3h71C8x4tDacLmA6BNo4c1Ew2pJs=;
        b=MJvuC0CkFKYxh7nTOzAiibo0AV1UdNgPkpv2xoWaNH09QCK6NKU+aPeDbIODsLVNr6
         ZjgcARPd34zhArOKyL3G0UZWNDGbnEI16hRQd7kdGBkeyLLTLLrWWVV2gkwDhy6Afo/y
         32I0BiLaH1moQIRrOPtojzb0nWVYPOhyIfEieOvTwfLUOeun/Etqrkd+W6FMMbFEeI9r
         +ka9ZOALQYsVbLyoaZgUqMRHJG8V4aBC+ikKQOBMQtqCZdEanps5mQelmRnYNHD4XcrA
         sBk6AIKPLzsgo2ewFn/B6Xqd2FM3BXuIHqi65AGs7BBRSiJqNAjM8MR9BbZtklFR6DhG
         81VQ==
X-Gm-Message-State: APjAAAXFLNPFcbVuejwililDx/HWbQEYqWtSzfATpQ5uUYlKoCsNPx5t
        zTZ93YNwcu9aydjB7SBuyfOynDLM
X-Google-Smtp-Source: APXvYqyMW3KcJHL1VGgFwmaSAlmnyTk+9Zx0q0T+8icx9Z83JVR+fdqIHjILb+MW+p+dEDxgp9V2WQ==
X-Received: by 2002:aca:b256:: with SMTP id b83mr3379404oif.120.1569518252353;
        Thu, 26 Sep 2019 10:17:32 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l19sm788637oie.22.2019.09.26.10.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:17:31 -0700 (PDT)
Subject: Re: [PATCH] staging: rtl8188eu: fix HighestRate check in
 odm_ARFBRefresh_8188E()
To:     Denis Efremov <efremov@linux.com>, devel@driverdev.osuosl.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Straube <straube.linux@gmail.com>,
        stable@vger.kernel.org
References: <20190926073138.12109-1-efremov@linux.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <24dbe004-2afe-97e6-b281-3b7109034dd9@lwfinger.net>
Date:   Thu, 26 Sep 2019 12:17:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926073138.12109-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/19 2:31 AM, Denis Efremov wrote:
> It's incorrect to compare HighestRate with 0x0b twice in the following
> manner "if (HighestRate > 0x0b) ... else if (HighestRate > 0x0b) ...". The
> "else if" branch is constantly false. The second comparision should be
> with 0x03 according to the max_rate_idx in ODM_RAInfo_Init().
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Michael Straube <straube.linux@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>   drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c b/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
> index 9ddd51685063..5792f491b59a 100644
> --- a/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
> +++ b/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
> @@ -409,7 +409,7 @@ static int odm_ARFBRefresh_8188E(struct odm_dm_struct *dm_odm, struct odm_ra_inf
>   		pRaInfo->PTModeSS = 3;
>   	else if (pRaInfo->HighestRate > 0x0b)
>   		pRaInfo->PTModeSS = 2;
> -	else if (pRaInfo->HighestRate > 0x0b)
> +	else if (pRaInfo->HighestRate > 0x03)
>   		pRaInfo->PTModeSS = 1;
>   	else
>   		pRaInfo->PTModeSS = 0;
> 

I agree that the original code is wrong; however, I prefer that changes that 
alter the execution should be tested. I see no evidence that such testing has 
been done. It probably does not matter because a highest rate between 3 and 0xb 
means 802.11g is in use, and that may no longer be a real-world situation.

With any future patches, you need to indicate if testing has been done.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

